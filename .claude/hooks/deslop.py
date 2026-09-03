#!/usr/bin/env python3
"""PreToolUse: refuse prose carrying the mechanical AI-slop patterns.

Consolidates prose-no-x-not-y.sh and ban-em-dashes.sh with the mechanical
subset of the 32 deslop warning signs (the is-it-slop checker,
https://adamdunkels.github.io/is-it-slop/, source github.com/adamdunkels/deslop-text).
Only deterministic pattern checks run here; the statistical and semantic signs
(passive-voice share, repetition, thematic repeats, scare quotes) need
whole-document judgment and are out of scope for a hook.

Covers Write and Edit (Write content, Edit new_string; an Edit that removes a
pattern always passes) and Bash commands that write prose files via heredocs.
Prose file extensions only. Files under ~/.claude are exempt, since rule and
skill files quote these patterns as examples. MCP tools (tool names starting
mcp__, when the settings.json matcher routes them here) get the W checks on
their message/text/content fields, so Slack sends are gated too.

Deliberate omissions beyond the statistical checks: W12 bold-in-body (the
standup checklists and bold lead-ins need it) and W27
curly quotes (verbatim Slack quotes carry them, and quotes stay verbatim).

Also enforces the mechanically checkable subset of the Google developer
documentation style guide (the GDS* checks below, modeled on the errata-ai
Vale Google package); the judgment-level principles (second person, active
voice, sentence-case headings, contractions encouraged) have no
deterministic check. The em-dash ban (W3) overrides the Google guide's
em-dash usage.
"""
from __future__ import annotations

import json
import re
import sys

PROSE_EXT = (".md", ".markdown", ".html", ".htm", ".txt", ".rst")

EMPHASIS_EMOJI = "\U0001F680\U0001F525✨\U0001F4A1⭐✅\U0001F449"

CHECKS = [
    ("W1", "filler phrase", re.compile(
        r"\b(it'?s worth noting|it bears mentioning|it goes without saying"
        r"|at the end of the day|moving forward|when all is said and done"
        r"|delves? into|delving into|underscores? the|leverag(?:e|es|ed|ing)"
        r"|utiliz\w+|nuanced|tapestry|the \w+ landscape|landscape of"
        r"|not only\b[^.!?]{0,80}\bbut also|holistic|robust|cutting.edge)\b", re.I)),
    ("W2", "not-X-but-Y framing", re.compile(
        r"(,\s+not\s+[a-z]"
        r"|\bnot (?:just |merely |only )?about\b[^.!?]{0,60}\b(?:it'?s|but) about\b"
        r"|\bless about\b[^.!?]{0,60}\bmore about\b"
        r"|\b(?:it|this|that)(?:'s| is) not\b[^.!?]{2,60}[.!?]\s+(?:it|this|that)(?:'s| is)\b)", re.I)),
    ("W3", "em-dash", re.compile("—")),
    ("W5", "marketing language", re.compile(
        r"\b(powerful|seamless(?:ly)?|revolutionary|game.chang(?:ing|er)"
        r"|best.in.class|world.class|next.generation|innovative"
        r"|groundbreaking|transformative)\b", re.I)),
    ("W6", "generic opening", re.compile(
        r"\b(in today'?s \w+(?:.\w+)? world|as we all know|have you ever wondered"
        r"|imagine a world where|imagine if you could|is evolving rapidly)\b", re.I)),
    ("W8", "hedging", re.compile(
        r"\b(it could be argued|one might say|it is possible that"
        r"|it seems like|it appears that|arguably)\b", re.I)),
    ("W9", "paired adjectives", re.compile(
        r"\b(simple|elegant|lightweight|clean|small|minimal)\s+(yet|but)\s+"
        r"(powerful|robust|comprehensive|complete|capable|mighty)\b"
        r"|\b(elegant|simple)\s+and\s+(robust|powerful)\b", re.I)),
    ("W10", "meta-reference", re.compile(
        r"\b(in this (?:post|article|document)|as (?:we )?(?:discussed|mentioned) (?:above|earlier)"
        r"|let'?s explore|below,? we'?ll cover|i want to walk you through)\b", re.I)),
    ("W11", "mechanical transition", re.compile(
        r"(?:^|[.!?]\s+|\n)(furthermore|moreover|additionally|in conclusion"
        r"|that said|with that in mind|having established that"
        r"|it is also worth mentioning)\b", re.I)),
    ("W15", "excited-to-announce", re.compile(
        r"\b(we'?re excited to (?:announce|share)|i'?m thrilled to share"
        r"|we'?re proud to present|excited to announce)\b", re.I)),
    ("W16", "whether-you're inclusivity", re.compile(
        r"\bwhether you'?re \w[^.!?]{0,60}\bor\b", re.I)),
    ("W17", "faux-conversational pivot", re.compile(
        r"\b(here'?s the thing:|let me be clear:|the truth is:"
        r"|so here'?s what happened:)|(?:^|\n)look:", re.I)),
    ("W19", "consecutive You starters", re.compile(
        r"\bYou\b[^.!?]*[.!?]\s+You\b[^.!?]*[.!?]\s+You\b")),
    ("W20", "the word very", re.compile(r"\bvery\b", re.I)),
    ("W21", "corporate cliche", re.compile(
        r"\b(think outside the box|move the needle|growth mindset"
        r"|digital transformation|synergy|paradigm shift|disruptive"
        r"|thought leaders?|best practices|deep dive|double down"
        r"|circle back|take it to the next level|game.changers?"
        r"|mission.critical|ecosystem)\b", re.I)),
    ("W22", "hashtag block", re.compile(r"#[A-Z]\w+\s+#[A-Z]\w+")),
    ("W25", "corporate slang", re.compile(
        r"\b(low.hanging fruit|boil the ocean|bandwidth|touch base"
        r"|table this|unpack (?:this|that)|lean into)\b", re.I)),
    ("W32", "internet cliche", re.compile(
        r"\b(you can'?t unsee|hits different|rent.free|chef'?s kiss"
        r"|the quiet part out loud|i'?m here for it|without telling me you"
        r"|let that sink in|this is the way"
        r"|say it louder for the people in the back)\b", re.I)),
    # "two corrections, both in the direction you want" / "three findings,
    # all blocking": an enumerated noun phrase re-qualified as a set by a
    # comma appositive. The gap excludes clause breaks so a both/all in a
    # later clause ("the two crons; both were rejected") stays legal, the
    # comma must sit directly before the quantifier ("the two, and both
    # approaches work" stays legal), and "both of which" is a relative
    # clause, exempted.
    ("W33", "set-requalifying appositive", re.compile(
        r"\b(?:two|three|four|five|several|a few|a couple of|[2-9])\b"
        r"[^,.!?;:\n]{1,60},\s*(?:both|all|each|neither)(?!\s+of\b)\s+\w", re.I)),
    # "the migration walks the cohort", "the service wants": a system noun
    # given a flowery or sentient verb. The GDS rule bans anthropomorphism
    # at the judgment level; this is its deterministic core.
    # Verb list stays conservative (no knows/decides/sees) so ordinary
    # technical phrasing passes.
    ("W34", "anthropomorphized system verb", re.compile(
        r"\b(?:migration|workflow|sweep|module|guard|service|activity"
        r"|function|query|queries|program|schedule|system|pipeline)s?\s+"
        r"(?:walk|want|think|believe|hope|dream|dance|sing|journey|march|weave"
        r"|tell|see)s?\b", re.I)),
]

# Google developer documentation style guide checks (see
# https://developers.google.com/style). Each entry carries the
# rewrite the guide asks for, shown in the denial. These run on stripped
# prose (code, markup, URLs, and verbatim quotes removed), so a code
# identifier or a quoted sentence never trips a check. GDS9 requires two
# commas before the conjunction (a four-item list): the one-comma form
# also matches an introductory clause ("After the sweep, review and
# submit"), which is not a list.
GDS_CHECKS = [
    ("GDS1", "Latin abbreviation", re.compile(
        r"(?<![\w.])(e\.g\.|i\.e\.|etc\.|et al\.|viz\.)", re.I),
     "write: for example / that is / and so on"),
    ("GDS2", "future tense", re.compile(
        r"\b(will|shall)\b|\bwon['’]t\b|\b(we|you|it|they|there)['’]ll\b", re.I),
     "describe behavior in the present tense"),
    ("GDS3", "exclamation point", re.compile(r"!(?![\[=(])"),
     "end the sentence with a period"),
    ("GDS4", "optional plural (s)", re.compile(r"\b\w+\(s\)"),
     "use the plural, or write: one or more"),
    ("GDS5", "gendered pronoun pair", re.compile(
        r"\b(he/she|s/he|his/her|him/her|he or she|him or her|his or her)\b", re.I),
     "use: they / their"),
    ("GDS6", "exclusionary term", re.compile(
        r"\b(white-?list\w*|black-?list\w*|grandfather(?:ed|ing)"
        r"|sanity[- ]check\w*|man-?hours?|master/slave)\b", re.I),
     "use: allowlist / denylist / exempted / confirmation check / person-hours"),
    ("GDS7", "and/or", re.compile(r"\band/or\b", re.I),
     "pick one, or write: X or Y or both"),
    ("GDS8", "in order to", re.compile(r"\bin order to\b", re.I),
     "write: to"),
    ("GDS9", "missing serial comma", re.compile(
        r"\b\w+, \w+, \w+ (?:and|or) \w+", re.I),
     "put a comma before the conjunction"),
    ("GDS10", "double space after sentence", re.compile(r"[.!?]  +\S"),
     "use a single space between sentences"),
    ("GDS11", "heading ends with a period", re.compile(
        r"(?m)^#{1,6}\s[^\n]*[^.\n]\.\s*$"),
     "drop the terminal period"),
    ("GDS12", "ellipsis", re.compile(r"\.\.\.|…"),
     "finish the sentence"),
    ("GDS13", "numeric ordinal", re.compile(r"\b[1-9](?:st|nd|rd|th)\b", re.I),
     "spell it out: first, second, ... ninth"),
    ("GDS14", "let's", re.compile(r"\blet['’]s\b", re.I),
     "address the reader directly instead"),
    # GDS15: the guide's word list (developers.google.com/style/word-list),
    # curated to entries whose guidance is an unconditional "Don't use" and
    # whose enforcement cannot collide with January vocabulary. Deliberately
    # excluded despite the guide banning them: repo, regex, tl;dr (the PR
    # framework's own heading), healthy, account name, and the conditional
    # entries (abort, above, access, and kin).
    ("GDS15", "word-list banned term", re.compile(
        r"\b(?:"
        # figurative or exclusionary
        r"crazy|bonkers|insane|lunatic|loony|retarded|lame|gimpy?|ghetto"
        r"|gypsy|voodoo|chubby|dojo|crippl\w*|sexy|slave"
        # violence and military metaphors
        r"|nuke[sd]?|blast radius|war[- ]?rooms?|demilitarized zone"
        r"|break-glass|final solution|off the reservation"
        # figurative tech idiom
        r"|tribal (?:knowledge|wisdom)|housekeeping|dumb(?:ed)? down"
        r"|(?:black|white|gr[ae]y)[- ]?hats?\b|white[- ]?label\w*"
        r"|black[- ]?hol(?:e[sd]?|ing)\b|pets (?:versus|vs\.?) cattle"
        r"|brown[- ]bag|build (?:cops?|sheriffs?)|webmasters?"
        # plain substitutions the guide names
        r"|agnostic|aka|allows you to|autoupdate|auth[nz]\b"
        r"|cell ?phones?|cellular (?:data|network)|smart ?phones?"
        r"|comprise[sd]?|comprising|denigrate[sd]?|desired?\b|learnings"
        r"|sane\b|sign into|tar ?balls?|unarchive|uncompress|untar|unzip"
        r"|unselect|vice versa|voila|wish(?:es|ed)?\b|world wide web"
        r"|ymmv|rtfm|noops|k8s|k[ae]bob|kebab[- ]case|kebab menu"
        r"|hamburger menus?|omnibox|gr[ae]yed[- ]out|gr[ae]y out"
        r"|click here|pop-?ups?\b|\bpros\b|\bcons\b|preferred pronouns"
        r"|disclosure (?:triangle|widget)|text ?box(?:es)?|hover(?:ing)?\b"
        r"|curated roles|network IP address|interconnect type"
        r"|representational state transfer|via"
        r"|female adapters?|male adapters?"
        r")\b", re.I),
     "banned by the GDS word list; see developers.google.com/style/word-list for the replacement"),
    # L1: a sentence carrying more than 3 commas is a run-on enumeration
    # and must become a list. Semicolons and newlines
    # reset the count, so joined clauses and bullet items judge separately.
    ("L1", "run-on enumeration (more than 3 commas in one sentence)", re.compile(
        r"(?:[^,.!?;\n]*,){4}"),
     "use a bulleted, numbered, or checkboxed list instead"),
]


def paragraph_exclamations(text):
    """W18: two or more exclamation marks inside one paragraph."""
    hits = []
    for para in re.split(r"\n\s*\n", text):
        if para.count("!") >= 2:
            hits.append(para.strip()[:80])
    return hits


def heading_emoji(text):
    """W30: decorative emoji at the start of a markdown heading."""
    return [m.group(0)[:80] for m in re.finditer(
        r"^#{1,6}\s*[\U0001F300-\U0001FAFF☀-➿]", text, re.M)]


def emphasis_emoji_cluster(text):
    """W23: two or more emphasis emoji in the text."""
    found = [c for c in text if c in EMPHASIS_EMOJI]
    return ["".join(found)] if len(found) >= 2 else []


def gds_strip(text):
    """Remove the spans the GDS checks must not judge: frontmatter, code,
    markup, URLs, and verbatim quoted text. Parenthetical prose stays,
    since the guide's rules apply inside parentheses too (and GDS4's
    literal "(s)" lives there)."""
    text = re.sub(r"\A---\n.*?\n---\n", " ", text, flags=re.S)
    text = re.sub(r"```.*?(```|\Z)", " ", text, flags=re.S)
    # table rows pad cells with spaces, which GDS10 must not read as
    # inter-sentence spacing
    text = re.sub(r"(?m)^\s*\|.*$", " ", text)
    text = re.sub(r"(?is)<(style|script)\b.*?(</\1>|\Z)", " ", text)
    text = re.sub(r"<[^>\n]{1,300}>", " ", text)
    text = re.sub(r"&[a-zA-Z]{1,10};|&#x?[0-9a-fA-F]{1,8};", " X ", text)
    text = re.sub(r"`[^`\n]*`", " X ", text)
    # the token-start lookbehind keeps this linear: without it, a long
    # slash-free token backtracks quadratically and stalls the hook
    text = re.sub(r"https?://\S+|(?<![^\s/])[^\s/]+(?:/[^\s/]+){2,}", " X ", text)
    text = re.sub(r"“[^”\n]{0,300}”", " X ", text)
    text = re.sub(r'"[^"\n]*"', " X ", text)
    return text


def gds_findings(text):
    findings = []
    stripped = gds_strip(text)
    for check_id, label, pattern, fix in GDS_CHECKS:
        snippets = []
        for m in pattern.finditer(stripped):
            start = max(0, m.start() - 30)
            snippet = stripped[start:m.end() + 30].replace("\n", " ").strip()
            snippets.append("{} [{}]".format(snippet, fix))
            if len(snippets) == 2:
                break
        if snippets:
            findings.append((check_id, label, snippets))
    return findings


def main():
    raw = sys.stdin.read()
    try:
        payload = json.loads(raw)
    except (ValueError, TypeError):
        return
    if not isinstance(payload, dict):
        return
    tool = payload.get("tool_name")
    tool_input = payload.get("tool_input")
    if not isinstance(tool_input, dict):
        return

    if tool in ("Write", "Edit"):
        path = tool_input.get("file_path")
        if not isinstance(path, str) or not path.endswith(PROSE_EXT):
            return
        if "/.claude/" in path:
            return
        parts = [tool_input.get("content"), tool_input.get("new_string")]
        text = "\n".join(p for p in parts if isinstance(p, str))
        doc_text = text
    elif tool == "Bash":
        cmd = tool_input.get("command")
        if not isinstance(cmd, str):
            return
        # searching for a pattern is not committing it
        if re.search(r"(^|[^\w])(grep|rg|ag|ack|awk|sed -n)([^\w]|$)", cmd):
            return
        if not re.search(r"\.(md|markdown|html|htm|txt|rst)\b", cmd):
            return
        text = cmd
        # GDS checks judge written prose only: heredoc bodies whose own
        # command line targets a prose file. A heredoc feeding an
        # interpreter (python3 - <<EOF) is code, and the command line
        # around any heredoc (paths, flags) is not sentences.
        doc_text = "\n".join(
            m.group(3) for m in re.finditer(
                r"(?m)^([^\n]*?<<-?\s*['\"]?(\w+)['\"]?[^\n]*)\n(.*?)\n\s*\2\s*$",
                cmd, re.S)
            if re.search(r"\.(md|markdown|html|htm|txt|rst)\b", m.group(1)))
    elif isinstance(tool, str) and tool.startswith("mcp__"):
        # outbound message tools (Slack send/draft, canvas updates) carry
        # their prose in these fields; only the W checks judge it, since
        # the GDS checks are scoped to documents written to files
        parts = [tool_input.get(k) for k in ("message", "text", "content")]
        text = "\n".join(p for p in parts if isinstance(p, str))
        doc_text = ""
    else:
        return

    if not text:
        return
    # rule files and their edits quote these patterns as examples
    if re.search(r"claude/rules|CLAUDE\.md", text):
        return

    findings = []
    for check_id, label, pattern in CHECKS:
        snippets = []
        for m in pattern.finditer(text):
            start = max(0, m.start() - 30)
            snippets.append(text[start:m.end() + 30].replace("\n", " ").strip())
            if len(snippets) == 2:
                break
        if snippets:
            findings.append((check_id, label, snippets))
    for check_id, label, fn in (("W18", "exclamation cluster", paragraph_exclamations),
                                ("W23", "emphasis emoji cluster", emphasis_emoji_cluster),
                                ("W30", "heading emoji", heading_emoji)):
        snippets = fn(text)
        if snippets:
            findings.append((check_id, label, snippets[:2]))
    if doc_text:
        findings.extend(gds_findings(doc_text))

    if not findings:
        return

    lines = []
    for check_id, label, snippets in findings[:10]:
        for s in snippets:
            lines.append("- {} ({}): ...{}...".format(check_id, label, s))
    reason = (
        "Blocked: the text breaks the writing standards (W* = banned "
        "AI-slop pattern; GDS* = Google developer documentation style guide, "
        "https://developers.google.com/style). Reword and retry.\n\n"
        + "\n".join(lines)
    )
    json.dump({
        "hookSpecificOutput": {
            "hookEventName": "PreToolUse",
            "permissionDecision": "deny",
            "permissionDecisionReason": reason,
        }
    }, sys.stdout)


if __name__ == "__main__":
    # a crash prints no JSON and the harness reads the silence as approval,
    # so any unanticipated exception must degrade to a clean pass
    try:
        main()
    except Exception:
        pass

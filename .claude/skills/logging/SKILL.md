---
name: logging
description: Guidelines when adding or modifying log statements. Use when instrumenting workflows, activities, services, or any function with logging.
---

# Logging Guidelines

## Message format

Log messages should be **human-readable sentences, capitalized**. They are read by humans scanning the log stream — not parsed by machines.

```python
# BAD — snake_case event name
logger.info("some_flow_failed", log_metadata)

# GOOD — readable sentence
logger.info("Some flow failed", log_metadata)
```

## Identifiers go in metadata, not the message

Never interpolate IDs, UUIDs, counts, or status values into the message string. Put them in the metadata dict so they become searchable fields.

```python
# BAD — IDs in the message string
workflow.logger.warning(f"Message {message.id} blocked by queue {queue.id}")

# GOOD — IDs in metadata
workflow.logger.warning("Message blocked by queue", {"message_id": message.id, "queue_id": queue.id})
```

## Shared `log_metadata` dict pattern

For functions/workflows that emit multiple logs, declare a single `log_metadata` dict near the top and enrich it in place as more context becomes known. Each subsequent log spreads `**log_metadata` plus any per-event extras.

```python
async def run(self, params: SomeParams) -> None:
    log_metadata: dict = {
        "workflow_id": workflow.info().workflow_id,
        "primary_id": params.primary_id,
    }

    workflow.logger.info("Started SomeWorkflow", log_metadata)

    result_one = await workflow.execute_activity(activity_one, ...)
    log_metadata["result_one_id"] = result_one.id
    workflow.logger.info("Completed activity one", log_metadata)

    result_two = await workflow.execute_activity(activity_two, ...)
    workflow.logger.info(
        "Completed activity two",
        {**log_metadata, "items_processed": result_two.count},
    )

    workflow.logger.info("SomeWorkflow completed", log_metadata)
```

**Why:** every log carries the cumulative context. A single search on `primary_id` in Datadog surfaces the full run, in order. No copy-pasting identifier dicts at every call site.

## Where to log

Log at meaningful boundaries — not every line, not just at the very end. Good defaults:

- **Entry** — workflow/function start with the input identifiers
- **After each activity / external call** — enrich `log_metadata` with the result, then log
- **Branch points** — early returns, skipped paths, fallbacks (so you can tell *which* path the run took)
- **Completion** — final summary line with cumulative counts/outcomes

Skip logs that just repeat the previous one with no new information.

## Temporal workflows: include `workflow_id`

Always seed `log_metadata` with `workflow.info().workflow_id`. This lets a Datadog log click straight through to the Temporal UI for that run.

```python
log_metadata: dict = {
    "workflow_id": workflow.info().workflow_id,
    ...domain identifiers...
}
```

Use `workflow.logger.*` inside `@workflow.run`, and `activity.logger.*` inside `@activity.defn`. Don't import a module-level logger — Temporal's bundled loggers add run/activity context automatically.

## Don't break existing logs unnecessarily

When editing a file with pre-existing logs, follow the file's prevailing convention if it differs from these guidelines — don't bulk-rewrite unrelated logs unless the user asks. If the file has no convention yet, apply these guidelines to the new logs you add.

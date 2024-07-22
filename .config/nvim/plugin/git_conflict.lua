local git_conflict = require("git-conflict")

git_conflict.setup({
	default_mappings = {
		ours = "co",
		theirs = "ct",
		none = "c0",
		both = "cb",
		next = "cc",
		prev = "CC",
	},
})

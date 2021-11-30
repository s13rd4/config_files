require('git-worktree').setup({
	change_directory_command = "cd",
	update_on_change = true,
	update_on_change_command = "e .",
	clearjumps_on_change = true,
	autopush = false

})

require('telescope').load_extension("git_worktree")

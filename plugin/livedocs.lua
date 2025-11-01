if vim.g.loaded_livedocs then
	return
end
vim.g.loaded_livedocs = true

vim.api.nvim_create_user_command("ToggleDocs", function(opts)
	local direction = opts.args ~= "" and opts.args or nil
	require("livedocs").toggle(direction)
end, {
	nargs = "?",
	desc = "Toggle live documentation window",
	complete = function()
		return require("livedocs.utils").valid_directions
	end,
})

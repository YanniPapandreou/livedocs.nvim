local M = {}

-- Default configuration
M.defaults = {
	ui = {
		position = "below",
		size = nil,
	},
	win = {
		number = false,
		relativenumber = false,
	},
	buf = {
		modifiable = true,
		buftype = "nofile",
		filetype = "markdown",
	},
}

-- Current configuration (will be merged with user options)
M.opts = {}

-- Setup function merges user options with defaults
M.setup = function(user_opts)
	M.opts = vim.tbl_deep_extend("force", M.defaults, user_opts or {})
end

return M

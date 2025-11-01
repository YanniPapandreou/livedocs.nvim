local M = {}
local ui = require("livedocs.ui")
local lsp = require("livedocs.lsp")
local config = require("livedocs.config")
local utils = require("livedocs.utils")
local augroup = vim.api.nvim_create_augroup("LiveDocs", { clear = false })

local state = {
	win = nil,
	buf = nil,
	timer = nil,
}

M.setup = function(opts)
	config.setup(opts)
end

M.toggle = function(direction)
	-- Check if we already have a window open
	if state.win and vim.api.nvim_win_is_valid(state.win) then
		-- close it
		vim.api.nvim_win_close(state.win, true)
		state.win = nil
		state.buf = nil
		-- clean up autocommands
		vim.api.nvim_clear_autocmds({ group = augroup })
	else
		-- open it
		local win = vim.api.nvim_get_current_win()
		if direction and not utils.direction_is_valid(direction) then
			return
		end
		local result = ui.create_split(config.opts, direction)
		-- move back to original window
		vim.api.nvim_set_current_win(win)
		state.win = result.win
		state.buf = result.buf

		-- Set up cursor tracking
		M.setup_cursor_tracking()
	end
end

M.setup_cursor_tracking = function()
	vim.api.nvim_clear_autocmds({ group = augroup })

	vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
		group = augroup,
		callback = M.on_cursor_moved,
	})
end

M.on_cursor_moved = function()
	-- Skip if cursor is in the docs window
	local current_buf = vim.api.nvim_get_current_buf()
	if current_buf == state.buf then
		return
	end

	-- Cancel previous timer if it exists
	if state.timer then
		state.timer:stop()
	end

	-- Create new timer
	state.timer = vim.loop.new_timer()

	-- Start timer: wait 200ms, then make request
	state.timer:start(
		200,
		0,
		vim.schedule_wrap(function()
			-- Request hover info and update display
			lsp.request_hover(function(content)
				ui.update_display(state.buf, content)
			end)
		end)
	)
end

return M

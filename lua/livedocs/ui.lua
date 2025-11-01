local M = {}

local function get_default_size(direction)
	if direction == "left" or direction == "right" then
		return 60 -- columns for vertical
	else
		return 15 -- lines for horizontal
	end
end

M.create_split = function(opts, split_direction)
	opts = opts or {}
	local direction = split_direction or opts.ui.position
	local size = opts.ui.size or get_default_size(direction)
	-- Create split
	vim.api.nvim_open_win(0, true, {
		split = direction,
		win = 0,
	})

	-- Get the window that was just created (current window after split)
	local win = vim.api.nvim_get_current_win()

	-- Create a scratch buffer
	local buf = vim.api.nvim_create_buf(false, true)

	-- Put buffer in window
	vim.api.nvim_win_set_buf(win, buf)

	for k, v in pairs(opts.win) do
		vim.api.nvim_set_option_value(k, v, { win = win })
	end

	for k, v in pairs(opts.buf) do
		vim.api.nvim_set_option_value(k, v, { buf = buf })
	end

	if direction == "left" or direction == "right" then
		vim.api.nvim_win_set_width(win, size)
	else
		vim.api.nvim_win_set_height(win, size)
	end
	return {
		win = win,
		buf = buf,
	}
end

M.update_display = function(buf, content)
	if not vim.api.nvim_buf_is_valid(buf) then
		return
	end

	if not content then
		vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "No hover info" })
		return
	end

	-- Split content into lines and display
	local lines = vim.split(content, "\n", { plain = true })
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
end

return M

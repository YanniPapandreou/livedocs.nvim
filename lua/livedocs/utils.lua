local M = {}

M.valid_directions = { "left", "right", "above", "below" }

M.direction_is_valid = function(direction)
	if not vim.tbl_contains(M.valid_directions, direction) then
		vim.notify(
			"livedocs: Invalid direction '" .. direction .. "'. Please use one of {'left', 'right', 'above', 'below'}",
			vim.log.levels.ERROR
		)
		return false
	end
	return true
end

return M

local M = {}

-- Request hover info at current cursor position
M.request_hover = function(callback)
	local params = vim.lsp.util.make_position_params()

	vim.lsp.buf_request(0, "textDocument/hover", params, function(err, result, ctx, config)
		if err then
			callback(nil)
			return
		end

		if not result or not result.contents then
			callback(nil)
			return
		end

		-- Parse the content
		local content = M.parse_hover_result(result)
		callback(content)
	end)
end

-- Parse different LSP hover response formats
M.parse_hover_result = function(result)
	if not result or not result.contents then
		return nil
	end

	local content
	if type(result.contents) == "string" then
		-- R language server format: contents is a plain string
		content = result.contents
	elseif result.contents.value then
		-- Luae/most LSPs: contents is an object with 'value' field
		content = result.contents.value
	elseif type(result.contents) == "table" and result.contents[1] then
		-- Array format (some language servers)
		content = table.concat(result.contents, "\n")
	else
		-- unknown format - maybe error?
		return nil
	end

	return content
end

return M

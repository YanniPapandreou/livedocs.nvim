local M = {}

M.check = function()
	vim.health.start("livedocs report")

	-- Get all active LSP clients across all buffers
	local clients = vim.lsp.get_active_clients()

	if #clients == 0 then
		vim.health.warn("No LSP clients attached to current buffer.")
		return
	end

	-- Check which clients support hover
	local hover_clients = {}
	for _, client in ipairs(clients) do
		if client.server_capabilities.hoverProvider then
			table.insert(hover_clients, client.name)
		end
	end

	if #hover_clients > 0 then
		vim.health.ok(
			string.format(
				"Found %d LSP client(s) with hover support: %s",
				#hover_clients,
				table.concat(hover_clients, ", ")
			)
		)
	else
		vim.health.error(
			string.format(
				"LSP clients active but none support hover. Clients: %s",
				table.concat(
					vim.tbl_map(function(c)
						return c.name
					end, clients),
					", "
				)
			)
		)
	end
end

return M

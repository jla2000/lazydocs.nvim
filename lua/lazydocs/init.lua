local M = {}

local util = require("lazydocs.util")

local function parse_declaration(node, params)
	local declaration = util.find_parent_node(node, "declaration")
	if declaration == nil then
		return nil
	end

	local parameters = util.get_child_by_name(declaration, "parameters")
	if parameters == nil then
		return nil
	end
	local param_names = {}
	for param in parameters:iter_children() do
		local name = util.find_child_node(param, "identifier")
		if name ~= nil then
			table.insert(param_names, vim.treesitter.get_node_text(name, params["bufnr"]))
		end
	end

	local return_node = util.get_child_by_name(declaration, "type")
	if return_node == nil then
		return nil
	end
	local has_return = vim.treesitter.get_node_text(return_node, params["bufnr"]) ~= "void"

	return {
		parameters = param_names,
		has_return = has_return,
	}
end

M.setup = function()
	local null_ls = require("null-ls")

	local luasnip = require("luasnip")

	null_ls.register({
		name = "lazydocs",
		method = null_ls.methods.CODE_ACTION,
		filetypes = { "cpp" },
		generator = {
			fn = function(params)
				local actions = {}

				local node = vim.treesitter.get_node()
				local declaration = parse_declaration(node, params)

				if declaration ~= nil then
					table.insert(actions, {
						title = "Generate Doxygen Comment",
						action = function()
							local indent = string.rep(" ", vim.fn.indent(params.row))

							local snippet_body = {
								luasnip.text_node({ indent .. "/*!", indent .. " * \\brief " }),
								luasnip.insert_node(1, "<Function description>"),
							}

							local insert_index = 2

							for _, param in ipairs(declaration.parameters) do
								table.insert(
									snippet_body,
									luasnip.text_node({ "", indent .. " * \\param[in] " .. param .. " " })
								)
								table.insert(snippet_body, luasnip.insert_node(insert_index, "<Parameter description>"))
								insert_index = insert_index + 1
							end

							if declaration.has_return then
								table.insert(snippet_body, luasnip.text_node({ "", indent .. " * \\return " }))
								table.insert(
									snippet_body,
									luasnip.insert_node(insert_index, "<Return value description>")
								)
							end

							table.insert(snippet_body, luasnip.text_node({ "", indent .. " */" }))

							vim.fn.append(params.row - 1, "")
							vim.cmd("norm! k")
							luasnip.snip_expand(luasnip.snippet("", snippet_body))
						end,
					})
				end

				return actions
			end,
		},
	})
end

return M

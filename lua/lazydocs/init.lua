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

							local comment = {
								indent .. "/*!",
								indent .. " * \\brief",
							}

							for _, param in ipairs(declaration.parameters) do
								table.insert(comment, indent .. " * \\param[in] " .. param)
							end

							if declaration.has_return then
								table.insert(comment, indent .. " * \\return ")
							end

							table.insert(comment, indent .. " */")

							vim.fn.append(params.row - 1, comment)
						end,
					})
				end

				return actions
			end,
		},
	})
end

return M

local M = {}

function M.find_parent_node(node, type)
	while node ~= nil do
		if node:type() == type then
			return node
		end
		node = node:parent()
	end

	return nil
end

function M.find_child_node(node, type)
	for child in node:iter_children() do
		if child:type() == type then
			return child
		end

		local nested = M.find_child_node(child, type)
		if nested ~= nil then
			return nested
		end
	end

	return nil
end

function M.get_child_by_field(node, field)
	for child, child_field in node:iter_children() do
		if child_field == field then
			return child
		end

		local nested = M.get_child_by_field(child, field)
		if nested ~= nil then
			return nested
		end
	end
	return nil
end

return M

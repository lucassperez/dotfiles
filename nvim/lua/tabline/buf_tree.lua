-- If node[1] is present, it means we are at a leaf.
-- Note that nodes usually are tables with keys. Only the last leaf will
-- have a positional argument.
local function is_leaf(node)
  -- return not not node[1]
  return type(node[1]) == 'number'
end

-- When reaching nodes that only has 1 or 0 keys, we have to go
-- to the last leaf to retrieve the bufnr. Reaching such a node means
-- that it is already enough to uniquely name a buffer.
local function follow_linear_chain_until_leaf(node)
  -- Generally speaking, node[1] is already the bufnr we are looking for.
  -- There is a possible edge case where two buffers actually have the same
  -- exact path. This can happen when both are unnamed.
  -- In this case, the leaf/last node will have many bufnrs.
  -- This is why we return the leaf, and not the bufnr at node[1].
  -- We would be ignoring other bufnrs in this edge case.
  if is_leaf(node) then return node end

  local key
  for k in pairs(node) do
    -- If table has many keys, only god knows what this for loop does.
    -- This function is only called if node has <= 1 child anyways.
    -- It is assumed that in buf_tree, if a node has only 1 key, it is already a
    -- uniquely identifiable path, and all the following nodes will also have
    -- only 1 key, until we reach the last one, which has 0 keys but it has an
    -- integer at the first index, the bufnr or the buf that generated that
    -- whole branch.
    key = k
    break
  end

  if key == nil then
    -- This should never happen.
    -- If a node has no keys, it must have node[1] and
    -- would have exited on the first line of this function.
    -- But anyways.
    return nil
  end

  return follow_linear_chain_until_leaf(node[key])
end

local function has_at_most_one_child(node)
  local found_a_child = false
  for k in pairs(node) do
    if type(k) == 'string' then
      if found_a_child then
        return false
      end
      found_a_child = true
    end
  end

  return true
end

--[[
This function gets a buf_tree and produces something like this:
{
  { "init.lua", "plugins", 2 },
  { "init.lua", "nvim", 1 },
}
It traverses buf_tree until it finds a path that can be used to
uniquely identify a buffer name (node with only 1 key).
It then stops collecting keys and dives until it finds the bufnr at the last
leaf of the node and extract it.
]]
local function collect_uniquely_identifiable_paths(node, path, result)
  if is_leaf(node) or has_at_most_one_child(node) then
    -- It is imperative that in the buf_tree, when a node has <= 1 children,
    -- the entire subtree is a linear chain until leaf, where we have bufnrs
    -- as positional arguments. Or current node is already the leaf.
    -- In both cases, the follow_linear_chain_until_leaf function will retrieve
    -- the last node (leaf).
    -- There is a weird edge case where the leaf may hold multiple bufnrs. This
    -- is the case if multiple buffers have the same exact name, which happens
    -- for unnamed buffers.

    local leaf = follow_linear_chain_until_leaf(node)
    if not leaf then
      vim.notify(
        string.format('tabline: Leaf is nil! %s -- %s', path, vim.inspect(node)),
        vim.log.levels.ERROR
      )
    else
      for _, bufnr in ipairs(leaf) do
        -- The unpack pattern makes a shallow copy, but path is a list/array without
        -- nested tables/lists/arrays, so I guess we're good not using vim.deepcopy?
        local copy = { unpack(path) }
        table.insert(copy, bufnr)
        table.insert(result, copy)
      end
      return
    end
  end

  for child in pairs(node) do
    path[#path + 1] = child
    collect_uniquely_identifiable_paths(node[child], path, result)
    path[#path] = nil
  end
end

--[[
se os buffers são isso:

bufnr_1, { 'nvim', 'lua', 'plugins', 'init.lua' }
bufnr_2, { 'nvim', 'init.lua }

a buf_tree é isso:

{
  ['init.lua'] = {
    plugins = {
      lua = {
        nvim = { <bufnr_1> }
      }
    },
    nvim = { <bufnr_2> }
  }
}
]]
local function calculate_buf_tree(buffers, directory_separator)
  local buf_tree = {}

  for _, buf in ipairs(buffers) do
    -- splitted é tipo isso: { 'nvim', 'lua', 'plugins', 'init.lua' }
    local splitted = vim.split(buf.path, directory_separator, { plain = true })
    local bufnr = buf.bufnr

    local current = buf_tree

    for i = #splitted, 1, -1 do
      -- key vai ser 'nvim', depois 'lua', depois 'plugins' etc.
      local key = splitted[i]

      if current[key] == nil then
        current[key] = {}
      end

      current = current[key]
    end

    -- Weird edge case: The last node, the leaf, can potentially be
    -- reached by two different buffers if they have the exact same path.
    -- This can happen when both are unnamed buffers.
    -- So instead of simply setting current[1] = bufnr, we are
    -- adding bufnr to the last node. Later, we iterate over them during
    -- the flatten buf_tree phase.
    current[#current + 1] = bufnr
  end

  return buf_tree
end

local function flatten_buf_tree_into_list(buf_tree)
  --[[
  Com buffers em

  1 nvim/init.lua
  2 nvim/lua/plugins.init.lua

  result vai ser uma lista de coisas assim:
  {
    { "init.lua", "plugins", 2 },
    { "init.lua", "nvim", 1 },
  }

  Importante notar:
  - Sempre terá 2 elementos pelo menos
  - Primeiro elemento é o arquivo
  - Último elemento é o bufnr
  - O miolo são os diretórios para identificar de maneira única, quando necessários
  ]]
  local result = {}
  for k, v in pairs(buf_tree) do
    collect_uniquely_identifiable_paths(v, { k }, result)
  end
  local buf_tree_flattened = {}
  for _, list in ipairs(result) do
    local bufnr = list[#list]
    list[#list] = nil
    -- list is reversed, so we reverse now
    local l = {}
    for j = #list, 1, -1 do
      table.insert(l, list[j])
    end
    buf_tree_flattened[bufnr] = l
  end
  --[[
  o state.buf_tree_flattened é assim:
  {
    [1] = { 'plugins', 'init.lua', },
    [2] = { 'nvim', 'init.lua', },
    [36] = { ... }
  }
  Os índices são os BUFNRs!
  ]]
  return buf_tree_flattened
end

return {
  calculate_paths = function(buffers, directory_separator)
    local buf_tree = calculate_buf_tree(buffers, directory_separator)
    return flatten_buf_tree_into_list(buf_tree)
  end,
}

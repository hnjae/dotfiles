local lua_keywords = {
  "nil",
  "any",
  "boolean",
  "string",
  "number",
  "integer",
  "function",
  "table",
  "thread",
  "userdata",
  "lightuserdata",
  "alias",
  "@async",
  "@cast",
  "@type",
  "@class",
  "@field",
  "@deprecated",
  "@diagnostic",
  "@enum",
  "@field",
  "@generic",
  "@meta",
  "@module",
  "@nodiscard",
  "@operator",
  "@overload",
  "@package",
  "@param",
  "@private",
  "@protected",
  "@return",
  "@see",
  "@source",
  "@type",
  "@vararg",
  "@version",
}

local source = {}

function source:complete(params, callback)
  local items = {}
  for _, word in ipairs(lua_keywords) do
    table.insert(items, { label = word })
  end
  callback({ items = items })
end

return source

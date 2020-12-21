local class = require "class"

local type = type
local assert = assert
local ipairs = ipairs

local fmt = string.format
local tconcat = table.concat

local Set = class("Set")

function Set:ctor(opt)
  self.type = "set"
  self.comment = opt.comment                 -- 注释
  self.primary = opt.primary                 -- 主键
  self.default = opt.default                 -- 默认值
  self.values = opt.values                   -- 枚举值
  self.name = opt.name                       -- 字段名
end

-- 验证字段传值有效
function Set:verify(x)
  if type(x) ~= 'string' then
    return false
  end
  for _, v in ipairs(self.values) do
    if x == v then
      return true
    end
  end
  return false
end

-- 是否为自增
function Set:isAutoIncrement()
  return false
end

-- 是否为主键
function Set:isPrimary()
  return self.primary
end

-- 将字段转DDL语句
function Set:toSqlDefine()
  local DDL = {" "}
  DDL[#DDL+1] = fmt([[`%s`]], assert(type(self.name) == 'string' and self.name ~= '' and self.name, "Invalid field name"))
  if type(self.values) == 'string' then
    DDL[#DDL+1] = fmt([[SET('%s')]], self.values)
  elseif type(self.values) == 'table' and #self.values > 0 then
    local list = {}
    for _, v in ipairs(self.values) do
      list[#list+1] = fmt([['%s']], v)
    end
    DDL[#DDL+1] = fmt([[SET('%s')]], tconcat(list, ", "))
  else
    error("Invalid `SET` field values.")
  end
  if self:isPrimary() then
    assert(not self.null, "The `primary` field must be `non-NULL`.")
  end
  if self.default then
    DDL[#DDL+1] = fmt("DEFAULT '%s'", assert(type(self.default) == 'string' and utf8.len(self.default) <= self.length and self.default, fmt("`%s` field has invalid default value.", self.name)))
  end
  if self.comment then
    DDL[#DDL+1] = fmt("COMMENT '%s'", self.comment)
  end
  return tconcat(DDL, " ")
end

return function (meta)
  return Set:new(assert(meta))
end
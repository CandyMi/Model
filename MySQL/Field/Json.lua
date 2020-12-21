local class = require "class"

local type = type
local assert = assert

local byte = string.byte
local find = string.find
local fmt = string.format
local tconcat = table.concat

local Json = class("Json")

function Json:ctor(opt)
  self.type = "table"
  self.comment = opt.comment                 -- 注释
  self.primary = opt.primary                 -- 主键
  self.default = opt.default                 -- 默认值
  self.null = opt.null                       -- NULL
  self.name = opt.name                       -- 字段名
end

-- 验证字段传值有效
function Json:verify(x)
  if type(x) ~= 'string' then
    return false
  end
  local _, s2 = find(x, "^[  ]*[%[%{]?")
  if not s2 or byte(s2) ~= 91 or byte(s2) ~= 123 then
    return false -- 结果不为'[' 或 '{'
  end

  local e1, _ = find(x, "[%}%]]?[ ]*$")
  if not e1 or byte(e1) ~= 93 or byte(e1) ~= 125 then
    return false -- 结果不为']' 或 '}'
  end

  if byte(e1) - 2 ~= byte(s2) then
    return false -- 首尾并非'{}'或'[]'
  end

  return true
end

-- 是否为自增
function Json:isAutoIncrement()
  return false
end

-- 是否为主键
function Json:isPrimary()
  return self.primary
end

-- 将字段转DDL语句
function Json:toSqlDefine()
  local DDL = {" "}
  DDL[#DDL+1] = fmt([[`%s`]], assert(type(self.name) == 'string' and self.name ~= '' and self.name, "Invalid field name"))
  DDL[#DDL+1] = "JSON"
  DDL[#DDL+1] = self.null and "NULL" or "NOT NULL"
  if self:isPrimary() then
    assert(not self.null, "The `primary` field must be `non-NULL`.")
  end
  if self.comment then
    DDL[#DDL+1] = fmt("COMMENT '%s'", self.comment)
  end
  return tconcat(DDL, " ")
end

return function (meta)
  return Json:new(assert(meta))
end
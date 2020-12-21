local class = require "class"

local type = type
local assert = assert

local fmt = string.format
local tconcat = table.concat

local VarBinary = class("VarBinary")

function VarBinary:ctor(opt)
  self.type = "string"
  self.comment = opt.comment                 -- 注释
  self.primary = opt.primary                 -- 主键
  self.default = opt.default                 -- 默认值
  self.length = opt.length                   -- 字段长度
  self.null = opt.null                       -- NULL
  self.name = opt.name                       -- 字段名
end

-- 验证字段传值有效
function VarBinary:verify(x)
  if type(x) ~= 'string' then
    return false
  end
  return #x >= 0 and #x <= self.length
end

-- 是否为自增
function VarBinary:isAutoIncrement()
  return false
end

-- 是否为主键
function VarBinary:isPrimary()
  return self.primary
end

-- 将字段转DDL语句
function VarBinary:toSqlDefine()
  local DDL = {" "}
  DDL[#DDL+1] = fmt([[`%s`]], assert(type(self.name) == 'string' and self.name ~= '' and self.name, "Invalid field name"))
  DDL[#DDL+1] = fmt("VarBINARY(%u)", assert(self.length and self.length >= 0 and self.length <= 65535 and self.length, "Invalid VarBinary length."))
  DDL[#DDL+1] = self.null and "NULL" or "NOT NULL"
  if self:isPrimary() then
    assert(not self.null, "The `primary` field must be `non-NULL`.")
  end
  if self.default then
    DDL[#DDL+1] = fmt("DEFAULT '%s'", assert(type(self.default) == 'string' and #(self.default) <= self.length and self.default, fmt("`%s` field has invalid default value.", self.name)))
  end
  if self.comment then
    DDL[#DDL+1] = fmt("COMMENT '%s'", self.comment)
  end
  return tconcat(DDL, " ")
end

return function (meta)
  return VarBinary:new(assert(meta))
end
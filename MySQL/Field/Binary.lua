local class = require "class"

local type = type
local assert = assert

local fmt = string.format
local tconcat = table.concat

local Binary = class("Binary")

function Binary:ctor(opt)
  self.type = "string"
  self.comment = opt.comment                 -- 注释
  self.primary = opt.primary                 -- 主键
  self.default = opt.default                 -- 默认值
  self.length = opt.length                   -- 字段长度
  self.null = opt.null                       -- NULL
  self.name = opt.name                       -- 字段名
end

-- 验证字段传值有效
function Binary:verify(x)
  if type(x) ~= 'string' then
    return false
  end
  return #x >= 0 and #x <= self.length
end

-- 是否为自增
function Binary:isAutoIncrement()
  return false
end

-- 是否为主键
function Binary:isPrimary()
  return self.primary
end

-- 将字段转DDL语句
function Binary:toSqlDefine()
  local DDL = {" "}
  DDL[#DDL+1] = fmt([[`%s`]], assert(type(self.name) == 'string' and self.name ~= '' and self.name, "Invalid field name"))
  DDL[#DDL+1] = fmt("BINARY(%u)", assert(self.length and self.length >= 0 and self.length <= 255 and self.length, "Invalid Binary length."))
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
  return Binary:new(assert(meta))
end
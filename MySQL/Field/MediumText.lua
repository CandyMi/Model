local class = require "class"

local type = type
local assert = assert

local fmt = string.format
local tconcat = table.concat

local MediumText = class("MediumText")

function MediumText:ctor(opt)
  self.type = "string"
  self.comment = opt.comment                 -- 注释
  self.primary = opt.primary                 -- 主键
  self.default = opt.default                 -- 默认值
  self.length = 2 ^ 24 - 1                   -- 字段长度
  self.null = opt.null                       -- NULL
  self.name = opt.name                       -- 字段名
end

-- 验证字段传值有效
function MediumText:verify(x)
  if type(x) ~= 'string' then
    return false
  end
  return #x >= 0 and #x <= self.length
end

-- 是否为自增
function MediumText:isAutoIncrement()
  return false
end

-- 是否为主键
function MediumText:isPrimary()
  return self.primary
end

-- 将字段转DDL语句
function MediumText:toSqlDefine()
  local DDL = {" "}
  DDL[#DDL+1] = fmt([[`%s`]], assert(type(self.name) == 'string' and self.name ~= '' and self.name, "Invalid field name"))
  DDL[#DDL+1] = "MEDIUMTEXT"
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
  return MediumText:new(assert(meta))
end
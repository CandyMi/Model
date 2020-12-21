local class = require "class"

local type = type
local assert = assert

local fmt = string.format
local tconcat = table.concat

local LongBlob = class("LongBlob")

function LongBlob:ctor(opt)
  self.type = "string"
  self.comment = opt.comment                 -- 注释
  self.primary = opt.primary                 -- 主键
  self.length = 2 ^ 32 - 1                   -- 字段长度
  self.null = opt.null                       -- NULL
  self.name = opt.name                       -- 字段名
end

-- 验证字段传值有效
function LongBlob:verify(x)
  if type(x) ~= 'string' then
    return false
  end
  return #x >= 0 and #x <= self.length
end

-- 是否为自增
function LongBlob:isAutoIncrement()
  return false
end

-- 是否为主键
function LongBlob:isPrimary()
  return self.primary
end

-- 将字段转DDL语句
function LongBlob:toSqlDefine()
  local DDL = {" "}
  DDL[#DDL+1] = fmt([[`%s`]], assert(type(self.name) == 'string' and self.name ~= '' and self.name, "Invalid field name"))
  DDL[#DDL+1] = "LONGBLOB"
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
  return LongBlob:new(assert(meta))
end
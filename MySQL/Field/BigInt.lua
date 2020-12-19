local class = require "class"

local assert = assert

local fmt = string.format
local toint = math.tointeger
local tconcat = table.concat

local BigInt = class("BigInt")

function BigInt:ctor(opt)
  self.auto_increment = opt.auto_increment   -- 自增
  self.comment = opt.comment                 -- 注释
  self.unsigned = opt.unsigned               -- 无符号
  self.default = opt.default                 -- 默认值
  self.primary = opt.primary                 -- 主键
  self.null = opt.null                       -- NULL
  self.name = opt.name                       -- 字段名
end

-- 验证字段传值有效
function BigInt:verify(x)
  x = assert(toint( x ), fmt("`%s` field was passed a invalid value(`BigInt`).", self.name))
  if self.unsigned then
    return x >= 0 and x <= 18446744073709551615
  end
  return x >= -9223372036854775808 and x <= 9223372036854775807
end

-- 是否为自增
function BigInt:isAutoIncrement()
  return self.auto_increment
end

-- 是否为主键
function BigInt:isPrimary()
  return self.primary
end

-- 将字段转DDL语句
function BigInt:toSqlDefine()
  local DDL = {" "}
  DDL[#DDL+1] = fmt([[`%s`]], self.name)
  DDL[#DDL+1] = self.unsigned and "BIGINT UNSIGNED" or "BIGINT"
  DDL[#DDL+1] = self.null and "NULL" or "NOT NULL"
  if self.default then
    if self.default == null then
      DDL[#DDL+1] = "DEFAULT 'NULL'"
    else
      DDL[#DDL+1] = fmt("DEFAULT '%s'", self.default)
    end
  end
  if self.auto_increment then
    DDL[#DDL+1] = "AUTO_INCREMENT"
  end
  if self.comment then
    DDL[#DDL+1] = fmt("COMMENT '%s'", self.comment)
  end
  return tconcat(DDL, " ")
end

return function (meta)
  return BigInt:new(assert(meta))
end
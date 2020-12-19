local class = require "class"

local assert = assert

local fmt = string.format
local toint = math.tointeger
local tconcat = table.concat

local Int = class("Int")

function Int:ctor(opt)
  self.auto_increment = opt.auto_increment   -- 自增
  self.comment = opt.comment                 -- 注释
  self.unsigned = opt.unsigned               -- 无符号
  self.default = opt.default                 -- 默认值
  self.primary = opt.primary                 -- 主键
  self.unique = opt.unique                   -- 唯一
  self.index = opt.index                     -- 索引
  self.null = opt.null                       -- NULL
  self.name = opt.name                       -- 字段名
end

-- 验证字段传值有效
function Int:verify(x)
  x = assert(toint( x ), fmt("`%s` field was passed a invalid value(`Int`).", self.name))
  if self.unsigned then
    return x >= 0 and x <= 4294967295
  end
  return x >= -2147483648 and x <= 2147483647
end

-- 是否为自增
function Int:isAutoIncrement()
  return self.auto_increment
end

-- 是否为主键
function Int:isPrimary()
  return self.primary
end

-- 是否有索引
function Int:isIndex()
  return self.index
end

-- 将字段转DDL语句
function Int:toSqlDefine()
  local DDL = {" "}
  DDL[#DDL+1] = fmt([[`%s`]], self.name)
  DDL[#DDL+1] = self.unsigned and "INT UNSIGNED" or "INT"
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
  return Int:new(assert(meta))
end
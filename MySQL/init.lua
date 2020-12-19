local class = require "class"

local fmt = string.format

-- 导入DML对象
local Select = require "Model.Mysql.Select"
local Insert = require "Model.Mysql.Insert"
local Update = require "Model.Mysql.Update"
local Delete = require "Model.Mysql.Delete"

local type = type
local ipairs = ipairs
local assert = assert

-- 对象模型
local Model = class("Model")

function Model:ctor(opt)
  self.tname = opt.tname
  self.fields = opt.fields
end

-- 传递数据库连接对象
function Model:setDB(DB)
  self.db = assert(DB, "Invalid DB Class.")
end

-- 初始化表
function Model:InitTable()
  local auto_increment
  local fDefines = {}
  local primaries = {}
  local engine = "InnoDB"
  local charset = "utf8mb4"
  local collate = "utf8mb4_unicode_ci"
  local kmap = {}
  for idx, f in ipairs(self.fields) do
    if f:isPrimary() then
      primaries[#primaries+1] = {idx = idx, name = f.name}
    end
    -- 判断是否需要设置自增ID
    if f:isAutoIncrement() then
      assert(not auto_increment, fmt("Multiple `auto_increment` fields are not allowed: [`%s`.`%s`].", self.tname, f.name))
      auto_increment = assert(math.tointeger(f.auto_increment), fmt("Invalid `auto_increment` field attr in [`%s`.%s`]", self.tname, f.name))
    end
    kmap[f.name] = idx
    fDefines[#fDefines+1] = f:toSqlDefine()
  end
  -- 定义主键
  if #primaries > 0 then
    local list = {}
    for _, item in pairs(primaries) do
      list[#list+1] = fmt([[`%s`]], item.name)
    end
    fDefines[#fDefines+1] = fmt([[  PRIMARY KEY (%s)]], table.concat(list, ", "))
  end
  local fields = self.fields
  if type(fields.indexes) == 'table'and next(fields.indexes) then
    local indexes = fields.indexes
    -- 索引分类
    local types = { normal = "KEY", unique = "UNIQUE KEY", fulltext = "FULLTEXT KEY"}
    -- 索引类型
    local using = { btree = "USING BTREE", hash = "USING HASH", }
    -- 索引插件
    local with = { ngram = "WITH PARSER ngram"}
    -- 建立索引
    for i, item in ipairs(indexes) do
      local list = {}
      local t = assert(types[item.type], fmt("Invalid Index type(Need `unique`, `normal`, `fulltext`) In `%s` at index = [%d].", self.tname, i))
      local iname = assert(item.name, fmt("Invalid Index-Name in `%s` at index = [%d].", self.tname, i))
      assert(type(item.keys) == "table" or type(item.keys) == "string", fmt("Invalid Index Keys Name Defined In `%s` as index = [%d].", self.tname, i))
      local us = using[item.using] and " " .. using[item.using] or ""
      local wt = with[item.with] and " " .. with[item.with] or ""
      if type(item.keys) == "table" then
        for _, name in ipairs(item.keys) do
          list[#list+1] = fmt([[`%s`]], name)
        end
      else
        list[#list+1] = fmt([[`%s`]], item.keys)
      end
      fDefines[#fDefines+1] = fmt([[  %s `%s`(%s)%s%s]], t, iname, table.concat(list, ", "), us, wt)
    end
  end
  -- 如果需要自定义额外的表属性
  if type(fields.attr) == "table" and next(fields.attr) then
    local attr = fields.attr
    if type(attr.engine) == 'string' and attr.engine ~= '' and string.lower(attr.engine) ~= 'innodb' then
      engine = attr.engine
    end
    if type(attr.charset) == 'string' and attr.charset ~= '' and string.lower(attr.charset) ~= 'utf8mb4' then
      charset = attr.charset
    end
    if type(attr.collate) == 'string' and attr.collate ~= '' and string.lower(attr.collate) ~= 'utf8mb4_unicode_ci' then
      collate = attr.collate
    end
  end
	return fmt("CREATE TABLE IF NOT EXISTS `%s`(\n%s\n) ENGINE=%s DEFAULT CHARSET=%s COLLATE=%s AUTO_INCREMENT=%u", self.tname, table.concat(fDefines, ",\n"), engine, charset, collate, auto_increment)
end

-- 查询语句
function Model:find(tab)
  -- TODO
  return Select:new()
end

-- 插入语句
function Model:insert(tab)
  -- TODO
  return Insert:new()
end

-- 更新语句
function Model:update(tab)
  -- TODO
  return Update:new()
end

-- 删除语句
function Model:delete(tab)
  -- TODO
  return Delete:new()
end

-- 模型初始化方法
return function (tname, fields)
  -- 表名称
  tname = assert(type(tname) == "string" and tname ~= '' and tname, "Invalid mysql table name.")
  -- 字段与配置
  fields = assert(type(fields) == 'table' and #fields > 0 and fields, "Invalid Fields.")
  -- 创建表模型
  return Model:new { tname = tname, fields = fields }
end
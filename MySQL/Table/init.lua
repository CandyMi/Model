local type = type
local next = next
local print = print
local ipairs = ipairs
local assert = assert

local fmt = string.format
local lower = string.lower
local toint = math.tointeger
local tconcat = table.concat

-- 导入DML对象
local Select = require "Model.MySQL.Table.Select"
local Insert = require "Model.MySQL.Table.Insert"
local Update = require "Model.MySQL.Table.Update"
local Delete = require "Model.MySQL.Table.Delete"

local class = require "class"

--- 对象模型
---@class MTable
---@field private fields     table[]                @表字段
---@field private tname      string                 @表名称
---@field private indexes    table[]                @表索引
---@field private attr       table<string, string>   @表属性
---@field private partitions table                  @表分区(未实现)
local MTable = class("MTable")

function MTable:ctor(opt)
  self.tname = opt.tname
  self.attr = opt.attr
  self.fields = opt.fields
  self.indexes = opt.indexes
  self.partitions = opt.partitions
  -- 内部映射
  self.map = {}
  for index, field in ipairs(opt.fields) do
    self.map[field.name] = field:setIndex(index)
  end
end

--- 传递数据库连接对象
---@param DB table @DB对象
function MTable:setDB(DB)
  self.db = assert(type(DB) == "table" and type(DB.query) == "function" and DB, "Invalid DB Class.")
end

---@param sql string @SQL标准语法
---@return table|boolean @成功-返回`table`, 失败返回`nil`与`err`
function MTable:query(sql)
  return assert(self.db, "Before using the model, please pass the database object to the model."):query(sql)
end

-- 初始化表
---@param opt table @可选的行为控制参数
function MTable:CreateTable(opt)
  -- 自增属性
  local auto_increment
  local fDefines = {}
  local primaries = {}
  for idx, f in ipairs(self.fields) do
    if f:isPrimary() then
      primaries[#primaries+1] = {idx = idx, name = f.name}
    end
    -- 判断是否需要设置自增ID
    if f:isAutoIncrement() then
      assert(not auto_increment, fmt("Multiple `auto_increment` fields are not allowed: [`%s`.`%s`].", self.tname, f.name))
      auto_increment = fmt("AUTO_INCREMENT=%u", assert(toint(f.auto_increment), fmt("Invalid `auto_increment` field attr in [`%s`.%s`]", self.tname, f.name)))
    end
    fDefines[#fDefines+1] = f:toSqlDefine()
  end
  -- 定义主键
  if #primaries > 0 then
    local list = {}
    for _, item in pairs(primaries) do
      list[#list+1] = fmt([[`%s`]], item.name)
    end
    fDefines[#fDefines+1] = fmt([[  PRIMARY KEY (%s)]], tconcat(list, ", "))
  end
  -- 定义索引
  if type(self.indexes) == "table" and next(self.indexes) then
    local indexes = self.indexes
    -- 索引分类
    local types = { normal = "KEY", unique = "UNIQUE KEY", fulltext = "FULLTEXT KEY"}
    -- 索引类型
    local using = { btree = " USING BTREE", hash = " USING HASH", }
    -- 索引插件
    local with = { ngram =  " WITH PARSER ngram" }
    -- 建立索引
    for idx, item in ipairs(indexes) do
      local list = {}
      local itype = assert(types[item.type], fmt("Invalid Index type(Need `unique`, `normal`, `fulltext`) In `%s` at index = [%d].", self.tname, idx))
      local iname = assert(item.name, fmt("Invalid Index-Name in `%s` at index = [%d].", self.tname, idx))
      assert(type(item.keys) == "table" or type(item.keys) == "string", fmt("Invalid Index Keys Name Defined In `%s` as index = [%d].", self.tname, idx))
      local us = using[item.using] and using[item.using] or ""
      local wt = with[item.with] and with[item.with] or ""
      if item.type ~= 'fulltext' then
        wt = ""
      end
      if type(item.keys) == "table" then
        for _, name in ipairs(item.keys) do
          list[#list+1] = fmt([[`%s`]], name)
        end
      else
        list[#list+1] = fmt([[`%s`]], item.keys)
      end
      fDefines[#fDefines+1] = fmt([[  %s `%s`(%s)%s%s]], itype, iname, tconcat(list, ", "), us, wt)
    end
  end
  local engine = "ENGINE=InnoDB"
  local charset = "DEFAULT CHARSET=utf8mb4"
  local collate = "COLLATE=utf8mb4_unicode_ci"
  -- 如果需要自定义额外的表属性
  if type(self.attr) == "table" and next(self.attr) then
    local attr = self.attr
    if type(attr.engine) == "string" and attr.engine ~= "" and lower(attr.engine) ~= "innodb" then
      engine = fmt("ENGINE=%s", attr.engine)
    end
    if type(attr.charset) == "string" and attr.charset ~= "" and lower(attr.charset) ~= "utf8mb4" then
      charset = fmt("DEFAULT CHARSET=%s", attr.charset)
    end
    if type(attr.collate) == "string" and attr.collate ~= "" and lower(attr.collate) ~= "utf8mb4_unicode_ci" then
      collate = fmt("COLLATE=%s", attr.collate)
    end
  end
  -- 表分区
  local partitions = ""
  if type(self.partitions) == "table" then
    partitions = ""
  end
  if not auto_increment then
    auto_increment = ""
  end
  -- DDL构建完成
  local sql = fmt("CREATE TABLE IF NOT EXISTS `%s`(\n%s\n) %s %s %s %s\n%s", self.tname, tconcat(fDefines, ",\n"), engine, charset, collate, auto_increment, partitions)
  if type(opt) == 'table' and opt.debug == true and opt.dump == true then
    print(sql)
  end
  if type(opt) == 'table' and opt.debug == true and opt.drop == true then
    self:DeleteTable()
  end
  return self:query(sql)
end

-- 删除表
function MTable:DeleteTable()
  local ok, err = self:query(fmt([[DROP TABLE IF EXISTS `%s`]], self.tname))
  return assert(ok, fmt("[%s] Error : %s",self.tname, err))
end

-- 截断/清空表
function MTable:TruncateTable()
  local ok, err = self:query(fmt([[TRUNCATE TABLE `%s`]], self.tname))
  return assert(ok, fmt("[%s] Error : %s",self.tname, err))
end

-- 查询语句
function MTable:find()
  -- TODO
  return Select:new()
end

-- 插入语句
function MTable:insert()
  -- TODO
  return Insert:new()
end

-- 更新语句
function MTable:update()
  -- TODO
  return Update:new()
end

-- 删除语句
function MTable:delete()
  -- TODO
  return Delete:new()
end

--- 表模型->构造方法
---@param tname  string
---@param fields Table <string, table | string>
---@return MTable
return function (tname, fields)
  -- 表名称
  tname = assert(type(tname) == "string" and tname ~= '' and tname, "Invalid table name.")
  -- 字段与配置
  fields = assert(type(fields) == 'table' and #fields > 0 and fields, "Invalid table fields.")
  -- 创建表模型
  return MTable:new { tname = tname, fields = fields, indexes = fields.indexes, attr = fields.attr, partitions = fields.partitions }
end
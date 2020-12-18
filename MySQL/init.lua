local class = require "class"

-- 导入DML对象
local Select = require "Model.Mysql.Select"
local Insert = require "Model.Mysql.Insert"
local Update = require "Model.Mysql.Update"
local Delete = require "Model.Mysql.Delete"

local type = type
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

-- 开始建表
function Model:createTable()
	-- TODO
	local query = fmt("CREATE TABLE IF NOT EXISTS `%s`(\n%s\n)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", self.tname)
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
	local tname = assert(type(tname) == "string" and tname ~= '' and tname, "Invalid mysql table name.")
	-- 字段与配置
	local fields = assert(type(fields) == 'table' and #fields > 0, "Invalid Fields.")
	-- 创建表模型
	return Model:new { tname = tname, fields = fields }
end
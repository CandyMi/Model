local Model = require "Model.MySQL"
local Field = require "Model.MySQL.Field"

local Int = Field.Int({ name = "id", unsigned = true, default = 0, primary = true, auto_increment = 0, comment = "自增ID"})
print(Int:toSqlDefine(), Int:verify(1))
local Int = Field.Int({ name = "user_id", unsigned = true, default = 0, auto_increment = 0, comment = "用户ID"})
print(Int:toSqlDefine(), Int:verify(-1))

-- local test = Model ("my_test", {
--   Field.Int({ name = "id", unsigned = true, DEFAULT = 0, primary = true, auto_increment = 0, comment = "自增ID"}),
--   Field.Int({ name = "user_id", unsigned = true, DEFAULT = 0, default = 0, auto_increment = 0, comment = "用户ID"}),
-- })
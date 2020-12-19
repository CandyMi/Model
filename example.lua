local Model = require "Model.MySQL"
local Field = require "Model.MySQL.Field"

local cfadmin_test = Model("cfadmin_test", {
  -- 字段定义
  Field.Int { name = "id", unsigned = true, primary = true, auto_increment = 0, comment = "自增ID" },
  Field.BigInt { name = "user_id", unsigned = true, comment = "用户ID" },
  Field.SmallInt { name = "role_id", unsigned = true, comment = "规则ID" },
  Field.TinyInt { name = "is_active", unsigned = true, comment = "是否生效" },
  -- -- 索引定义(可选) : name(必填), type(必填), keys(必填string|array), using(选填), with(选填)
  -- indexes = {
  --   { name = "uid_index", keys = "user_id", type = "normal", using = "hash" },
  --   { name = "rid_index", keys = {"role_id", "user_id"}, type = "unique", using = "btree" },
  --   { name = "aid_index", keys = {"is_active"}, type = "fulltext", with = "ngram" },
  -- },
  -- -- 表属性定义(可选): 所有参数均为选填但不可与实际可用版本冲突.
  -- attr = { engine = "myisam", charset = "gbk", collate = "gbk_chinese_ci" },
})

print(cfadmin_test:InitTable())
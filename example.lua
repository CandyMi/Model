local Table = require "Model.MySQL.Table"
local Field = require "Model.MySQL.Field"

local test = Table("cfadmin_test", {
  -- 整型字段
  Field.BigInt { name = "id", unsigned = true, primary = true, auto_increment = 0, comment = "自增ID" },
  Field.Int { name = "user_id", unsigned = true, default = 0, null = true, comment = "用户ID" },
  Field.SmallInt { name = "role_id", unsigned = true, comment = "规则ID" },
  Field.TinyInt { name = "is_active", unsigned = true, comment = "是否生效" },
  -- 字符串字段
  Field.VarChar { name = "firstname", primary = true, length = 2, default = "先生", comment = "名1" },
  Field.Char { name = "lastname", primary = true, length = 2, default = "車", comment = "姓2" },
  -- Binary
  Field.VarBinary { name = "firstname_1", primary = true, length = 2, default = "12", comment = "名11" },
  Field.Binary { name = "lastname_2", primary = true, length = 2, default = "21", comment = "姓22" },
  -- BLOB
  Field.TinyBlob { name = "description_1", null = true, comment = "介绍1" },
  Field.Blob { name = "description_2", null = true, comment = "介绍2" },
  Field.MediumBlob { name = "description_3", null = true, comment = "介绍3" },
  Field.LongBlob { name = "description_4", null = true, comment = "介绍4" },
  -- TEXT
  Field.TinyText { name = "description_11", null = true, comment = "介绍11" },
  Field.Text { name = "description_22", null = true, comment = "介绍22" },
  Field.MediumText { name = "description_33", null = true, comment = "介绍33" },
  Field.LongText { name = "description_44", null = true, comment = "介绍44" },
  -- JSON
  Field.Json { name = "JSON_FMT", null = true, comment = "特殊数据" },
  -- SET
  Field.Set { name = "SSet", primary = true, values = "", comment = "多选枚举(集合)" },
  -- Enum
  Field.Enum { name = "EEnum", primary = true, values = "", comment = "单选枚举(集合)" },
  -- 索引定义(可选) : name(必填), type(必填), keys(必填string|array), using(选填), with(选填)
  indexes = {
    { name = "uid_index", keys = "user_id", type = "normal", using = "hash" },
    { name = "rid_index", keys = {"role_id", "user_id"}, type = "unique", using = "btree" },
    { name = "aid_index", keys = {"firstname", "lastname"}, type = "fulltext", with = "ngram" },
  },
  -- 表属性定义(可选): 所有参数均为选填但不可与实际可用版本冲突.
  -- 默认属性为: InnoDB utf8mb4 utf8mb4_unicode_ci
  attr = { engine = "myisam", charset = "gbk", collate = "gbk_chinese_ci" },
})

test:CreateTable({ debug = true, dump = true, drop = false})
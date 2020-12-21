# MySQL 对象映射模型

  `MySQL`的模型库实现.

## Field - 字段类型模型

  目前已经实现的`MySQL`字段类型模型包括:

  * 整数类型: `BigInt`、`Int`、`SmallInt`、`TinyInt`;

  * 小数类型: `Decimal`、`float`、`Double`;

  * 字符类型: `Text`、`Blob`、`Binary`、`Char`;

  * 时间类型: `DateTime`、`TimeStamp`、`Year`、`Date`、`Time`;

  * 枚举类型: `Enum`、`Set`;

  * 特殊类型: `Json`;

  注意: 不支持空间数据结构与二维数据结构.

## Table(tname, info) - 表结构模型

  `MySQL`的表模型构造方法.

### 1. tname - 表名称

  `tname` 是对表进行DML、DDL、DCL操作时使用的名称, 开发者应该传递一个符合`MySQL`的表命名规范的值.

### 2. info  - 表结构

  `info`的内容定义了`tname`表对应的结构. 所有的表内包含的字段都至少需要存在一个, 并且还可以设置以下额外的属性:

  * `indexes` - 表字段索引(可选);

  * `attr` - 表结构属性(可选);

  * `partitions` - 表分区属性(可选);

#### 2.1 info[fields-index] - 表字段

  所有的字段定义都是以数组的形式写入到`info`内的. 例如:

```lua
local tab = Table("mytab", {
  Field.BigInt { name = "id", unsigned = true, primary = true, comment = "自增ID"},
  Field.Int { name = "user_id", unsigned = true, comment = "用户ID" },
})
```

  参考前面提到的内容可以获取到更多字段类型信息.

#### 2.2 info.indexes - 表索引

  `indexes`展示了`Table`模型的索引应该如何配置:
  
  * 索引名称(`name`)为: 自定义传递的索引名称;

  * 索引字段(`keys`)为: 数组为多列联合索引, 字符串为单列索引;
  
  * 索引类型(`type`)分为: `unique`、`normal`、`fulltext`;

  * 索引算法(`using`)分为: `btree`、`hash`;

  * 索引插件(`with`)分为: `ngram`, `type`为`fulltext`的时候传递才有效;

  设置为主键的字段只需要在字段参数属性内指定即可.

#### 2.3 info.attr - 表属性

  `attr`展示了`Table`模型的属性应该如何设置:

  * `engine`  - 表存储引擎, 默认为: `InnoDB`, 字符串类型, 例如: `InnoDB`、`MyISAM`、`xtraDB`;

  * `charset` - 表内容字符集, 默认为: `utf8mb4`, 字符串类型, 可更改为其它字符集(例如:`utf8`、`GBK`), 但是不会自动进行字符集转换;

  * `collate` - 表内容排序、比较方式, 默认为:`utf8mb4_unicode_ci`, 字符串类型, 例如: `utf8mb4_unicode_ci`、`utf8mb4_general_ci`;

  默认情况下在内部已经有`相对合适`的属性值被定义, 所以不建议开发者主动修改字符集与字符集排序、比较方式. 除非你清楚的知道自己在做什么并且确定你的修改更加合适且正确.

#### 2.4 info.partitions - 表分区

  `partitions`展示了`Table`模型的分区应该如何设置: (暂未实现).

### 3 完整示例

```lua
  local Field = require "Model.MySQL.Field"
  local Table = require "Model.MySQL.Table"

  local tab = Table("mytest", {
    Field.BigInt { name = "id", unsigned = true, primary = true, comment = "自增ID"},
    Field.Int { name = "user_id", unsigned = true, comment = "用户ID" },
    indexes = {
      { name = "uid_index", keys = "user_id", type = "normal" }
    }
    attr = { engine = "InnoDB", charset = "utf8mb4", collate = "utf8mb4_unicode_ci" },
  })
```

## 常用的方法

  默认情况下, 模型定义都创建都是无害的! 但是你也可以指定参数来改变这一行为, 这通常在开发的时候比较有效.

  需要注意的是: 在生产环境下请不要使用危险的参数, 这将可能造成无法挽回的后果。

### 1. Table:CreateTable(opt)

  构造方法创建的表`Model`在调用次方法后根据`opt`内包含的参数来指定行为. 注意: `opt`与内部所有的参数都是可选的.

  * `opt.debug` - 只有当`debug == true`表达式为`true`的时候, 下面配置的参数才会生效.

  * `opt.dump` - 开启`debug`模式后生效; 此参数会将`CreateTable`方法的创建语句输出到`stdout`;

  * `opt.drop` - 开启`debug`模式后生效; 此模式下每次都会`删除tname指定的表后, 再根据定义的表结构再重新创建一次.`

### 2. Table:DeleteTable()

  删除`tname`指定的表.

### 3. Table:TruncateTable()

  -- 截断/清空表


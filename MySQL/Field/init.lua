local NULL = null

return {
  -- String
	["Char"] = require "Model.MySQL.Field.Char",
  ["VarChar"] = require "Model.MySQL.Field.VarChar",
  -- TEXT
  ["TinyText"] = require "Model.MySQL.Field.TinyText",
  ["Text"] = require "Model.MySQL.Field.Text",
  ["MediumText"] = require "Model.MySQL.Field.MediumText",
  ["LongText"] = require "Model.MySQL.Field.LongText",
  -- BLOB
  ["TinyBlob"] = require "Model.MySQL.Field.TinyBlob",
  ["Blob"] = require "Model.MySQL.Field.Blob",
  ["MediumBlob"] = require "Model.MySQL.Field.MediumBlob",
  ["LongBlob"] = require "Model.MySQL.Field.LongBlob",
  -- BINARY
  ["Binary"] = require "Model.MySQL.Field.Binary",
  ["VarBinary"] = require "Model.MySQL.Field.VarBinary",
  -- Json
  ["Json"] = require "Model.MySQL.Field.Json",
  -- Set
  ["Set"] = require "Model.MySQL.Field.Set",
  ["Enum"] = require "Model.MySQL.Field.Enum",
  -- Integer
	["TinyInt"] = require "Model.MySQL.Field.TinyInt",
	["SmallInt"] = require "Model.MySQL.Field.SmallInt",
	["Int"] = require "Model.MySQL.Field.Int",
  ["BigInt"] = require "Model.MySQL.Field.BigInt",
  -- Float
  ["Float"] = NULL,
  ["Double"] = NULL,
  ["Decimal"] = NULL,
  -- DateTime
  ["Year"] = NULL,
  ["Date"] = NULL,
  ["Time"] = NULL,
  ["TimeStamp"] = NULL,
  ["DateTime"] = NULL,
}

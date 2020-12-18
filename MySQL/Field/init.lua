return {
  -- String
	["Char"] = NULL,
  ["VarChar"] = NULL,
  ["Binary"] = NULL,
  ["VarBinary"] = NULL,
  ["Text"] = NULL,
  ["TinyText"] = NULL,
  ["MediumText"] = NULL,
  ["LongText"] = NULL,
  ["Blog"] = NULL,
  ["TinyBlob"] = NULL,
  ["MediumBlob"] = NULL,
  ["LongBlob"] = NULL,
  -- Json
  ["Json"] = NULL,
  -- Set
  ["Set"] = NULL,
  -- Integer
	["TinyInt"] = require "Model.MySQL.Field.TinyInt",
	["SmallInt"] = require "Model.MySQL.Field.SmallInt",
	["Int"] = require "Model.MySQL.Field.Int",
  ["BigInt"] = require "Model.MySQL.Field.BigInt",
  -- Float
  ["float"] = NULL,
  ["double"] = NULL,
  ["decimal"] = NULL,
  -- DateTime
  ["Year"] = NULL,
  ["Date"] = NULL,
  ["Time"] = NULL,
  ["TimeStamp"] = NULL,
  ["DateTime"] = NULL,
}

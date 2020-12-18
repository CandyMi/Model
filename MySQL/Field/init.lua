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
	["TinyInt"] = NULL,
	["SmallInt"] = NULL,
	["Int"] = require "Model.Mysql.Field.Int",
  ["BigInt"] = require "Model.Mysql.Field.BigInt",
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

return {
  -- Key 分区
  Key = require "Model.MySQL.Partition.Key",
  -- Hash分区
  Hash = require "Model.MySQL.Partition.Hash",
  -- Range分区
  Range = require "Model.MySQL.Partition.Range",
}
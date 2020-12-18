local class = require "class"

local INSERT = class("DML")

function INSERT:ctor( opt )
	self.db = opt.db
	self.tname = opt.tname
	self.fields = opt.fields
	self.query = {"INSERT"}
end

return INSERT
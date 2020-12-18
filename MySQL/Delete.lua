local class = require "class"

local DELETE = class("DML")

function DELETE:ctor( opt )
	self.db = opt.db
	self.tname = opt.tname
	self.fields = opt.fields
	self.query = {"DELETE"}
end

return DELETE
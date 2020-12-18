local class = require "class"

local UPDATE = class("DML")

function UPDATE:ctor( opt )
	self.db = opt.db
	self.tname = opt.tname
	self.fields = opt.fields
	self.query = {"UPDATE"}
end

return UPDATE
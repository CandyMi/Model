local class = require "class"

local SELECT = class("DML")

function SELECT:ctor( opt )
	self.db = opt.db
	self.tname = opt.tname
	self.fields = opt.fields
	self.query = {"SELECT"}
end

return SELECT
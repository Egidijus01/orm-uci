local models = {}
Table = require("orm.model")
local fields = require("orm.field_type")
print("cia")
models.User = Table({
    __tablename__ = "user",
    -- username = string,
    -- password = string

    username = fields.CharField({}),
    password = fields.CharField({}),

})
models.Job = Table({
    __tablename__ = "job",
    -- location = string,
    -- type = string
    
    location = fields.CharField({}),
    type = fields.CharField({}),

})
-- models.House = Table:create_table({
--     __tablename__ = "house",
--     -- color = string,
--     -- size = string
    
--     username = fields.CharField(),
--     password = fields.CharField(),

-- })models.Info = Table:create_table({
--     __tablename__ = "info",
--     -- address = string,
--     -- something = string
    
--     username = fields.CharField(),
--     password = fields.CharField(),

-- })



return models

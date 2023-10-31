local uci = require("uci")
local Select = require('orm.get')
local Query = require('orm.query')
local x = uci.cursor()

local fields = require('orm.field_type')


All_Tables = {}




Table = {
   
    __tablename__ = nil,
    tables = {}

}

local function create_config_file(name)
    local file_path = "/etc/config/" .. name
-- Open the file in write mode
    local file = io.open(file_path, "w")
    -- if file then
    --     -- Write some content to the file
    --     file:write("This is a sample configuration.")
    
    --     -- Close the file to save changes
    --     file:close()
    --     print("File created successfully.")
    -- else
    --     print("Error: Could not open the file for writing.")
    -- end
    file:close()
end


function Table:create_table(table_instance)

    -- table information
    local tablename = table_instance.__tablename__
    local columns = table_instance.__colnames
   

    
    -- print("after")

    create_config_file(tablename)


    

    
end

-- Create new table instance
--------------------------------------

function Table.new(self, args)
    self.tables = {}
    local colnames = {}
    self.__tablename__ = args.__tablename__
    args.__tablename__ = nil

    self.__cols__ = {};


    for colname, coltype in pairs(args) do

        -- append to self cols
        if (args[colname]) then
          table.insert(self.__cols__, colname);
        end
    end
    

    local Table_instance = {
        ------------------------------------------------
        --            Table info variables            --
        ------------------------------------------------

        -- SQL table name
        __tablename__ = self.__tablename__,

        -- list of column names
        __colnames = {},




        __index = function (self, key)
            
            if key == "get" then
                return Select(self)
            end

            local old_index = self.__index
           
            setmetatable(self, {__index = nil})

            key = self[key]

            setmetatable(self, {__index = old_index, __call = self.create})

            return key
        end,

        -- Create new row instance
        -----------------------------------------
        -- @data {table} parsed query answer data
        --
        -- @retrun {table} Query instance
        -----------------------------------------
        create = function (self, data)
         
            return Query(self, data)

        end,

        ------------------------------------------------
        --          Methods which using               --
        ------------------------------------------------

        -- parse column in correct types
        column = function (self, column)
            local tablename = self.__tablename__

            if Type.is.table(column) and column.__classtype__ == AGGREGATOR then
                column.colname = tablename .. column.colname
                column = column .. ""
            end

            return "`" .. tablename .. "`.`" .. column .. "`",
                   tablename .. "_" .. column
        end,

        -- Check column in table
        -----------------------------------------
        -- @colname {string} column name
        --
        -- @return {boolean} get true if column exist
        -----------------------------------------
        has_column = function (self, colname)
            for _, table_column in pairs(self.__colnames) do
                if table_column.name == colname then
                    return true
                end
            end

            BACKTRACE(WARNING, "Can't find column '" .. tostring(colname) ..
                               "' in table '" .. self.__tablename__ .. "'")
        end,
        
        get_tables = function ()
            return self.tables
        end,
        -- get column instance by name
        -----------------------------------------
        -- @colname {string} column name
        --
        -- @return {table} get column instance if column exist
        -----------------------------------------
        get_column = function (self, colname)
            for _, table_column in pairs(self.__colnames) do
                if table_column.name == colname then
                    return table_column
                end
            end

            BACKTRACE(WARNING, "Can't find column '" .. tostring(column) ..
                               "' in table '" .. self.__tablename__ .. "'")
        end
    }

    -- Add default column 'id'

    args.id = fields.PrimaryField({auto_increment = true})
 
    -- copy column arguments to new table instance
    for _, colname in ipairs(self.__cols__) do
        
        local coltype = args[colname];
        coltype.name = colname
        coltype.__table__ = Table_instance
 
        table.insert(Table_instance.__colnames, coltype)
    end


    table.insert(self.tables, Table_instance)
    setmetatable(Table_instance, {
        __call = Table_instance.create,
        __index = Table_instance.__index
    })
    -- _G.All_Tables[self.__tablename__] = Table_instance



    -- for i,x in pairs(Table_instance) do
    
    --     print(i,x)
    -- end


    -- Create new table if needed
    self:create_table(Table_instance)

    return Table_instance
    
end

setmetatable(Table, {__call = Table.new})

return Table
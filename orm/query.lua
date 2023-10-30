------------------------------------------------------------------------------
--                          query.lua                                       --
------------------------------------------------------------------------------

local uci = require("uci")
local x = uci.cursor()
-- Creates an instance to retrieve and manage a
-- string table with the database
---------------------------------------------------
-- @own_table {table} parent table instace
-- @data {table} data returned by the query to the database
--
-- @return {table} database query instance
---------------------------------------------------

local function get_id(table) 
    print("?????????????????????????????????????????")
    for _, table_column in pairs(table[1]) do
        -- for i,x in pairs(table_column) do
        --     print(i,x)
        -- end
        print(table_column)
    end
    print("?????????????????????????????????????????")
    
end

function Query(own_table, data)
    local query = {
        ------------------------------------------------
        --          Table info varibles               --
        ------------------------------------------------

        -- Table instance
        own_table = own_table,


        _data = {},



        _add = function (self)
           
            local ann = x:add(self.own_table.__tablename__, "interface")
            self._data["id"] = {new=ann, old=ann}
         
            for name, value in pairs(data) do
           
                x:set(self.own_table.__tablename__, ann, name, value)
            end
            
            x:commit(self.own_table.__tablename__)
            -- for colname, colinfo in pairs(self._data) do
            --     print(colname, colinfo)
            --     for i,x in pairs(colinfo) do
            --         print(i,x)
            --     end
            -- end
        

   


        end,

        
        _update = function (self)

                x:foreach(self.own_table.__tablename__, "interface", function(s)
                
                
                local id = self._data.id.new
               
                
                if s['.name'] == id then
                    
                    for key, value in pairs(self._data) do
                        x:set(self.own_table.__tablename__, id, key, value.new)
                    end
                
                if x:commit(self.own_table.__tablename__) then
                    print("ok")
                end
               
                end
                end)

        end,

        ------------------------------------------------
        --             User methods                   --
        ------------------------------------------------

        -- save row
        save = function (self)
            
            if self._data.id then
                
                self:_update()
            else
                self:_add()
            end
        end,

        -- delete row
        delete = function (self)
            
            
            x:delete(self.own_table.__tablename__, self._data.id.new)
            x:commit(self.own_table.__tablename__)
            
        end
    }

    if data then
      

        for colname, colvalue in pairs(data) do
            if query.own_table:has_column(colname) then
                colvalue = query.own_table:get_column(colname)
                                          .field.to_type(colvalue)
                query._data[colname] = {
                    new = colvalue,
                    old = colvalue
                }
            else
                if _G.All_Tables[colname] then
                    current_table = _G.All_Tables[colname]
                    colvalue = Query(current_table, colvalue)

                    query._readonly[colname .. "_all"] = QueryList(current_table, {})
                    query._readonly[colname .. "_all"]:add(colvalue)

                end

                query._readonly[colname] = colvalue
            
            end
        end
    
    end



    return query
end



return Query
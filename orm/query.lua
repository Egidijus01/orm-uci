------------------------------------------------------------------------------
--                          query.lua                                       --
------------------------------------------------------------------------------

local uci = require("uci")
local x = uci.cursor()


function Query(own_table, data)
    local query = {
        ------------------------------------------------
        --          Table info varibles               --
        ------------------------------------------------

        -- Table instance
        own_table = own_table,


        _data = {},
        _get_col = function (self, colname)
            
            if self._data[colname] and self._data[colname].new then
                return self._data[colname].new

            elseif self._readonly[colname] then
                return self._readonly[colname]
            end
        end,

        -- Set column new value
        -----------------------------------------
        -- @colname {string} column name in table
        -- @colvalue {string|number|boolean} new column value
        -----------------------------------------
        _set_col = function (self, colname, colvalue)
            
            local coltype

            if self._data[colname] and self._data[colname].new and colname ~= ID then
                coltype = self.own_table:get_column(colname)

                if coltype and coltype.field.validator(colvalue) then
                    self._data[colname].old = self._data[colname].new
                    self._data[colname].new = colvalue
                else
                    BACKTRACE(WARNING, "Not valid column value for update")
                end
            end
        end,


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
            
            end
        end
    
    end
    setmetatable(query, {__index = query._get_col,
                         __newindex = query._set_col})

    local tablename = query.own_table.__tablename__

    if not _G.All_Tables[tablename] then
        _G.All_Tables[tablename] = {}
    end
    
    table.insert(_G.All_Tables[tablename], query)


    return query
end



return Query
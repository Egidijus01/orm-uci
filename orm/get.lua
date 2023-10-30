local uci = require("uci")

local x = uci.cursor()

local function return_match(data, rules)

    -- for index, table in ipairs(data) do
    --     local match = false
    --     --  id    2
    --     for key, value in pairs(rules) do
    --         -- local a = x:get(tablename, "interface", 1)
    --         -- print("a",a)
    --         -- print(table[key])
    --         -- print(value)
    --         -- local id = table[".index"]
    --         -- print("id",id)

    --         x:foreach("user", "interface", function(s)
    --                  print('------------------')
    --                  if s['.name'] == 'cfg026d96' then
                        
    --                     for key, value in pairs(s) do
    --                         print(key .. ': ' .. tostring(value))
    --                     end
    --                  end
    --             end)
    --         -- for i,x in pairs(table) do
            
    --         --     print(i,x)
    --         -- end
    --         if table.id == value then
    --             match = true
    --             break
    --         end
    --     end
    --     if match then
    --         return table
    --     end
    -- end

    for key, value in pairs(rules) do
        
        if data[value] then
            return data[value]
            
        end
    end

    return data[2]
end

local Select = function(own_table)
    return {
        ------------------------------------------------
        --          Table info varibles               --
        ------------------------------------------------
        -- Link for table instance
        own_table = own_table,

        -- Create select rules
        _rules = {
            -- Where equation rules
            where = {},
   
            
        },


        


        where = function (self, args)

            
            for col, value in pairs(args) do
                self._rules.where[col] = value
            end

            return self
        end,


        
        
        --------------------------------------------------------
        --                 Update data methods                --
        --------------------------------------------------------

        update = function (self, data)
            if Type.is.table(data) then
                

                

                -- Build WHERE
                -- if next(self._rules.where) then
                --     _where = self:_condition(self._rules.where, "\nWHERE")
                -- else

                -- end

               
            else
                BACKTRACE(WARNING, "No data for global update")
            end
        end,

        --------------------------------------------------------
        --                 Delete data methods                --
        --------------------------------------------------------


        delete = function (self)
            
            local data = self:all()
            -- Build WHERE
            if next(self._rules.where) then
                local tab = return_match(data, self._rules.where)
                if tab then
                    x:delete(self.own_table.__tablename__, tab.id)

                    x.commit(self.own_table.__tablename__)
                end
            else
                return "error"
            end
            
        end,


-------------------------------------------------------------------------

        -- GET

        first = function (self)
            
            local data = self:all()
            -- for i,x in pairs(self) do
            --     print(i,x)
            -- end
            

            local table = return_match(data, self._rules.where)
            
            if table then
                return table
            end

        end,

        -- Return list of values
        all = function (self)
            -- local res = {}
            -- local data = x:get_all(self.own_table.__tablename__)

            
            -- for section, options in pairs(data) do
            --     local t = {}

            --     for option, value in pairs(options) do
                    
            --         if not option:match("^%.") then 
                       
            --             t[option] = value
            --         end

            --     end
            -- table.insert(res, t)

            -- end
            -- return res
            -- local data = self.data
            -- print(All_Tables)
            -- return QueryList(self.own_table)
            local data = self.own_table.get_tables()
                
            -- for i,x in pairs(data) do
            -- print(i,x)
            -- end
            return data
        end,

    }
end

return Select 
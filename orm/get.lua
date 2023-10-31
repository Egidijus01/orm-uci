local uci = require("uci")

local x = uci.cursor()

local function return_match(data, rules)
    for _, table in ipairs(data) do
        local match = true
        for key, value in pairs(rules) do
            if table[key] ~= value then
                match = false
                break  -- Break the inner loop when a non-match is found
            end
        end
        if match then
            return table  -- Return the table after checking all key-value pairs
        end
    end
end

local Select = function(own_table)
    return {

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

---------------------------------------------------------------------

        -- GET METHODS
        with_id = function (self, id)
            local data = self:all()

            -- for key, value in pairs(rules) do
        
                if data[id] then
                    return data[id]
                    
                end
            -- end
        end,

        first = function (self)
            
            local data = self:all()
            -- for i,x in pairs(data) do
            --     print(i,x)
            -- end
            
            local table = return_match(data, self._rules.where)
            
            if table then
                return table
            end

        end,

        -- Return list of values
        all = function (self)

            local data = _G.All_Tables

            local tablename = self.own_table.__tablename__

            return data[tablename]
        end,

    }
end

return Select
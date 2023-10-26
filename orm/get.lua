local uci = require("uci")

local x = uci.cursor()


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
            -- Having equation rules


            
            
        },

        ------------------------------------------------
        --          Private methods                   --
        ------------------------------------------------

      
        

        -- Build condition for equation rules
        ---------------------------------------------------
        -- @rules {table} list of columns
        -- @start_with {string} WHERE or HAVING
        --
        -- @retrun {string} parsed string for select equation
        ---------------------------------------------------
        _condition = function (self, rules, start_with)
            local counter = 0
            local condition = ""
            local _equation

            condition = condition .. start_with

            -- TODO: add OR
            for colname, value in pairs(rules) do
                _equation = self:_build_equation(colname, value)

                if counter ~= 0 then
                     _equation = "AND " .. _equation
                end

                condition = condition .. " " .. _equation
                counter = counter + 1
            end

            return condition
        end,

        _has_foreign_key_table = function (self, left_table, right_table)
            for _, key in pairs(left_table.__foreign_keys) do
                if key.settings.to == right_table then
                    return true
                end
            end
        end,

        -- Build join tables rules
        _build_join = function (self)
            local result_join = ""
            local unique_tables = {}
            local left_table, right_table, mode
            local join_mode, colname
            local parsed_column, _
            local tablename

            for _, value in pairs(self._rules.columns.join) do
                left_table = value[1]
                right_table = value[2]
                mode = value[3]
                tablename = left_table.__tablename__

                if mode == JOIN.INNER then
                    join_mode = "INNER JOIN"

                elseif mode == JOIN.LEFT then
                    join_mode = "LEFT OUTER JOIN"

                elseif mode == JOIN.RIGHT then
                    join_mode = "RIGHT OUTER JOIN"

                elseif mode == JOIN.FULL then
                    join_mode = "FULL OUTER JOIN"

                else
                    BACKTRACE(WARNING, "Not valid join mode " .. mode)
                end

                if self:_has_foreign_key_table(right_table, left_table) then
                    left_table, right_table = right_table, left_table
                    tablename = right_table.__tablename__

                elseif not self:_has_foreign_key_table(right_table, left_table) then
                    BACKTRACE(WARNING, "Not valid tables links")
                end

                for _, key in pairs(left_table.__foreign_keys) do
                    if key.settings.to == right_table then
                        colname = key.name

                        result_join = result_join .. " \n" .. join_mode .. " `" ..
                                      tablename .. "` ON "

                        parsed_column, _ = left_table:column(colname)
                        result_join = result_join .. parsed_column

                        parsed_column, _ = right_table:column(ID)
                        result_join = result_join .. " = " .. parsed_column

                        break
                    end
                end
            end

            return result_join
        end,

        -- String with including data in select
        --------------------------------------------
        -- @own_table {table|nil} Table instance
        --
        -- @return {string} comma separated fields
        --------------------------------------------
        _build_including = function (self, own_table)
            local include = {}
            local colname_as, colname

            if not own_table then
                own_table = self.own_table
            end

            -- get current column
            for _, column in pairs(own_table.__colnames) do
                colname, colname_as = own_table:column(column.name)
                table.insert(include, colname .. " AS " .. colname_as)
            end

            include = table.join(include)

            return include
        end,

        -- Method for build select with rules
        _select = function (self)
            local including = self:_build_including()
            local joining = ""
            local _select
            local tablename
            local condition
            local where
            local rule
            local join

            --------------------- Include Columns To Select ------------------
            

            -- Add join rules
            
        end,

        -- Add column to table
        -------------------------------------------------
        -- @col_table {table} table with column names
        -- @colname {string/table} column name or list of column names
        -------------------------------------------------
        _add_col_to_table = function (self, col_table, colname)
            if Type.is.str(colname) and self.own_table:has_column(colname) then
                table.insert(col_table, colname)

            elseif Type.is.table(colname) then
                for _, column in pairs(colname) do
                    if (Type.is.table(column) and column.__classtype__ == AGGREGATOR
                    and self.own_table:has_column(column.colname))
                    or self.own_table:has_column(column) then
                        table.insert(col_table, column)
                    end
                end

            else
                BACKTRACE(WARNING, "Not a string and not a table (" ..
                                   tostring(colname) .. ")")
            end
        end,

        --------------------------------------------------------
        --                   Column filters                   --
        --------------------------------------------------------

        -- Including columns to select query
        include = function (self, column_list)
            if Type.is.table(column_list) then
                for _, value in pairs(column_list) do
                    if Type.is.table(value) and value.as and value[1]
                    and value[1].__classtype__ == AGGREGATOR then
                        table.insert(self._rules.columns.include, value)
                    else
                        BACKTRACE(WARNING, "Not valid aggregator syntax")
                    end
                end
            else
                BACKTRACE(WARNING, "You can include only table type data")
            end

            return self
        end,

        --------------------------------------------------------
        --              Joining tables methods                --
        --------------------------------------------------------

        -- By default, join is INNER JOIN command
        _join = function (self, left_table, MODE, right_table)
            if not right_table then
                right_table = self.own_table
            end

            if left_table.__tablename__ then
                table.insert(self._rules.columns.join,
                            {left_table, right_table, MODE})
            else
                BACKTRACE(WARNING, "Not table in join")
            end

            return self
        end,

        join = function (self, left_table, right_table)
            self:_join(left_table, JOIN.INNER, right_table)
            return self
        end,

        -- left outer joining command
        left_join = function (self, left_table, right_table)
            self:_join(left_table, JOIN.LEFT, right_table)
            return self
        end,

        -- right outer joining command
        right_join = function (self, left_table, right_table)
            self:_join(left_table, JOIN.RIGHT, right_table)
            return self
        end,

        -- full outer joining command
        full_join = function (self, left_table, right_table)
            self:_join(left_table, JOIN.FULL, right_table)
            return self
        end,

        --------------------------------------------------------
        --              Select building methods               --
        --------------------------------------------------------

        -- SQL Where query rules
        where = function (self, args)
            for i,x in pairs(args) do
                print(i,x)
            end
            
            for col, value in pairs(args) do
                self._rules.where[col] = value
            end

            return self
        end,

        -- Set returned data limit
        limit = function (self, count)
            if Type.is.int(count) then
                self._rules.limit = count
            else
                BACKTRACE(WARNING, "You try set limit to not integer value")
            end

            return self
        end,

        -- From which position start get data
        offset = function (self, count)
            if Type.is.int(count) then
                self._rules.offset = count
            else
                BACKTRACE(WARNING, "You try set offset to not integer value")
            end

            return self
        end,

        -- Order table
        order_by = function (self, colname)
            self:_add_col_to_table(self._rules.order, colname)
            return self
        end,

        -- Group table
        group_by = function (self, colname)
            self:_add_col_to_table(self._rules.group, colname)
            return self
        end,

        -- Having
        having = function (self, args)
            for col, value in pairs(args) do
                self._rules.having[col] = value
            end

            return self
        end,

        --------------------------------------------------------
        --                 Update data methods                --
        --------------------------------------------------------

        update = function (self, data)
            if Type.is.table(data) then
                local _update = "UPDATE `" .. self.own_table.__tablename__ .. "`"
                local _set = ""
                local coltype
                local _set_tbl = {}
                local i=1

                for colname, new_value in pairs(data) do
                    coltype = self.own_table:get_column(colname)

                    if coltype and coltype.field.validator(new_value) then
                        _set = _set .. " `" .. colname .. "` = " ..
                              coltype.field.as(new_value)
                        _set_tbl[i] = " `" .. colname .. "` = " ..
                                coltype.field.as(new_value)
                        i=i+1
                    else
                        BACKTRACE(WARNING, "Can't update value for column `" ..
                                            Type.to.str(colname) .. "`")
                    end
                end

                -- Build WHERE
                if next(self._rules.where) then
                    _where = self:_condition(self._rules.where, "\nWHERE")
                else

                end

                if _set ~= "" then
                    if #_set_tbl<2 then
                        _update = _update .. " SET " .. _set .. " " .. _where
                    else
                        _update = _update .. " SET " .. table.concat(_set_tbl,",") .. " " .. _where
                    end

                    db:execute(_update)
                else
                    BACKTRACE(WARNING, "No table columns for update")
                end
            else
                BACKTRACE(WARNING, "No data for global update")
            end
        end,

        --------------------------------------------------------
        --                 Delete data methods                --
        --------------------------------------------------------

        delete = function (self)
            local _delete = "DELETE FROM `" .. self.own_table.__tablename__ .. "` "

            -- Build WHERE
            if next(self._rules.where) then
                _delete = _delete .. self:_condition(self._rules.where, "\nWHERE")
            else
                BACKTRACE(WARNING, "Try delete all values")
            end

            db:execute(_delete)
        end,

        --------------------------------------------------------
        --              Get select data methods               --
        --------------------------------------------------------

        -- Return one value
        first = function (self)
            local data = self:all()
            -- for i,x in pairs(self.data) do
            --     print(i,x)
            -- end
            -- self._rules.where.id
            local sect = data[self._rules.where.id]
            print(sect)
            for key, value in pairs(sect) do
                print(key,value)
            end
            -- local data = self:all()

            -- if data:count() == 1 then
            --     return data[1]
            -- end
        end,

        -- Return list of values
        all = function (self)
            local res = {}
            local data = x:get_all(self.own_table.__tablename__)

            
            for section, options in pairs(data) do
                local t = {}

                t["id"] = section 
                for option, value in pairs(options) do
                    
                    if not option:match("^%.") then 
                        print(option, value)
                        t[option] = value
                    end

                end
            table.insert(res, t)

            end
            return res
        end
    }
end

return Select 
package.path = package.path .. ";/home/studentas/Public/learn/uci/?.lua"
local models = require("./models")
local User = models.User
require("./models")



local user = User({
    username = "Bob Smith",
    password = "SuperSecretPassword",
})


local user1 = User({
    username = "Bob Smith",
    password = "SuperSecretPassword",
})

local k  = User.get:where({id=1}):all()

-- for i,x in pairs(k) do
--     print(i,x)
-- end
print("Ok")





























-- local uci = require("uci")

-- local x = uci.cursor()




-- local function list_of_conf()
--     print("-----------------------------------")
--     for dir in io.popen([[ls -pa /etc/config | grep -v /]]):lines() do
--         print(dir) 
--     end
--     print("-----------------------------------")
-- end

-- local function print_sect(file)
--     local fileContent = x:get_all(file)
--     for section, options in pairs(fileContent) do
--         print("[" .. section .. "]")
--         for option, value in pairs(options) do
--             print(option , value)
--         end
--         print("---------------------------------")
--         print()
--     end
-- end
-- local function desired_sec(file, section)
--     local fileContent = x:get_all(file)
--     local sect = fileContent[section]
--     for key, value in pairs(sect) do
--         print(key,value)
--     end
-- end

-- local function create_section(file, name, type)
--     x:set(file, name,  type)
-- end

-- local function set_value(file, section, option, text)
--     x:set(file, section, option, text)
-- end


-- local menu = [[
--     Menu:
--     1 - List of configuration files
--     2 - Whole selected configuration file
--     3 - Print value of desired section
--     4 - Create new section
--     5 - Delete section
--     6 - Set value for option
--     7 - Delete option
-- ]]



-- while true do

--     list_of_conf()
--     print("Select configuration")
--     local configFile = io.read("*l")
--     local fileContent = x:get_all(configFile)
--     print(fileContent)

--     while true do
--         print(menu)
--         local s = io.read("*n")
--             if s==1 then
--                 break
--             elseif s==2 then
--                 print_sect(configFile)
--             elseif s==3 then
--                 io.read("*l")
--                 print("Type name of section")
--                 local sel = io.read("*l")
--                 desired_sec(configFile, sel)
--             elseif s==4 then
--                 local name = io.read("*l")
--                 print("Type in section name\n")
--                 local type = io.read("*l")
--                 print("Type in section type\n")
--                 create_section(configFile, name, type)
--             elseif s==5 then
--                 local name = io.read("*l")
--                 print("Name of the section")
--                 x:delete(configFile, name)
--             elseif s==6 then
--                 local name = io.read("*l")
--                 print("Name of the section")
--                 local option = io.read("*l")
--                 print("Name of the option")
--                 local val = io.read("*l")
--                 print("What do you want to change it to")
--                 set_value(configFile, name, option, val)
--             elseif s==7 then
--                 local name = io.read("*l")
--                 print("Name of the section")
--                 local val = io.read("*l")
--                 print("Option you want to delete")
--                 x:delete(configFile, name, val)
--             end
--     end


-- end




    
-- -- local fileContent = x:get_all("/etc/config")
-- -- print(fileContent)

--     -- local host = x:get("example", "interface", "address")
--     -- print("here",host)

--     -- local host = x:get("example", "main")
--     -- print("here",host)


--     local configFile = "example"

-- -- Get the content of the configuration file
-- -- local sect = fileContent["main"]

-- -- x:set(configFile, "something",  "general")
-- -- local fileContent = x:get_all(configFile)

-- -- x:set(configFile, "main", "host", "nice")

-- -- x:delete(configFile, "something")
-- -- x:delete(configFile, "main", "host")

-- -- local fileContent = x:get_all(configFile)

-- -- -- Print the content
-- -- for section, options in pairs(fileContent) do
-- --     print("[" .. section .. "]")
-- --     for option, value in pairs(options) do
-- --         print(option , value)
-- --     end
-- --     print("---------------------------------")
-- --     print()
-- -- end
--     -- print(menu)
--     -- local s = io.read("*n")
--     -- print(s)
    
    
    
    
--     -- while true do
--     -- print(menu)
--     -- local s = io.read("*n")
--     -- print(s)
    
--     -- if s == 1 then
--     --     for dir in io.popen([[ls -pa /etc/config | grep -v /]]):lines() do
--     --         print(dir) end
--     -- end
--     -- end
local LClass = {}

local l_type =
{
    number = "number",
    boolean = "boolean",
    string = "string",
    ["function"] = "function",
    userdata = "userdata",
    table = "table",
    dynamic = "dynamic",
}
local l_number = "number"

local ClassMap = {}

local type_flag
-- create class
local function _createClass(className, baseClass)
    local class = {}
    local def = {}
    class.define = def

    local members = {}
    class.members = members

    def.field = {}
    local fieldMeta = {}
    setmetatable(def.field, fieldMeta)
    fieldMeta.__call = function(field, ...)
        -- "#"
        local type = select(1, ...)
        if l_type[type] then
            type_flag = l_type[type]
            return field
        else
            error(string.format("Type of field incorrect, type:%s,", type), 1)
        end
    end

    fieldMeta.__newindex = function(field, key, value)
        if members[key] then
            error(string.format("Field of %s has already defined", key), 1)
        end

        local valueType = type(value)
        if type_flag == l_type.table and valueType ~= "function" then
            error(string.format("Default value of table field must be a function, field:", key), 1)
        elseif type_flag ~= l_type.dynamic and valueType ~= type_flag then
            error(string.format("Field of %s type incorrect", key), 1)
        end

        members[key] =
        {
            member_type = "field",
            type = type_flag,
            default_value = value,
        }
    end

    return class
end

-- create class interface
LClass.Class = function(className)
    if ClassMap[className] then
        error("Duplicate class defined, class name: " .. className, 1)
    end

    local class = _createClass(className)
    ClassMap[className] = class

    return ClassMap[className]
end

LClass.Extend = function(baseClass, className)
    assert(baseClass)

    if ClassMap[className] then
        error("Duplicate class defined, class name: " .. className, 1)
    end

end



return LClass

local LClass = dofile "../LClass.lua"

local ClassA = LClass.Class("A")
do
    local def = ClassA.define
    def.field("number").m_num1 = 1
    def.field("boolean").m_bool1 = true
end

-- local ClassAA = LClass.Class("A")

local ObjA = ClassA()
print("ObjA", ObjA, ObjA.m_num1, ObjA.m_bool1)

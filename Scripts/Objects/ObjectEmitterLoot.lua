include("Scripts/Objects/PlaceableObject.lua")

-------------------------------------------------------------------------------
ObjectEmitterLoot = PlaceableObject.Subclass("ObjectEmitterLoot")

--------------------------------------------------------------------------------
function ObjectEmitterLoot:GetLootHandler( )
	return "EmitterLootHandler"
end

-------------------------------------------------------------------------------
EntityFramework:RegisterGameObject(ObjectEmitterLoot)

-- ExamplesMod
include("Scripts/Characters/3PModel.lua")
table.insert(ThirdPersonModel.ESlots["Left Arm"],"Geo_L_Arm_PlateGuard01")

include("Scripts/Characters/FPSHands.lua")
table.insert(FPSHands.ESlots["Left Arm"],"Geo_L_Arm_PlateGuard01")

-------------------------------------------------------------------------------
if ExamplesMod == nil then
	ExamplesMod = EternusEngine.ModScriptClass.Subclass("ExamplesMod")
end

-------------------------------------------------------------------------------
function ExamplesMod:Constructor(  )
end

-------------------------------------------------------------------------------
-- Called once from C++ at engine initialization time
function ExamplesMod:Initialize()
	-- Parse archetypes
	Eternus.CraftingSystem:ParseArchetypesFile("Data/Archetypes/Black_Modular.txt")
	
	-- Parse crafting recipes
	Eternus.CraftingSystem:ParseRecipeFile("Data/Crafting/ExamplesMod_crafting.txt", "ExamplesMod")
	Eternus.CraftingSystem:ParseRecipeFile("Data/Crafting/ExamplesMod_BlackParts.txt", "ExamplesMod")
	Eternus.CraftingSystem:ParseRecipeFile("Data/Crafting/ExamplesMod_BlackTools.txt", "ExamplesMod")
	Eternus.CraftingSystem:ParseRecipeFile("Data/Crafting/ExamplesMod_BlackGear.txt", "ExamplesMod")
	Eternus.CraftingSystem:ParseRecipeFile("Data/Crafting/ExamplesMod_Slingshot.txt", "ExamplesMod")
end

-------------------------------------------------------------------------------
-- Called from C++ every update tick
function ExamplesMod:Process(dt)
end

-------------------------------------------------------------------------------
-- 
function ExamplesMod:ModifyBiomeData(biomeName, biome)
	
end

-------------------------------------------------------------------------------
-- Called from C++ when the current game enters 
--function ExamplesMod:Enter()	
--end

-------------------------------------------------------------------------------
-- Called from C++ when the game leaves it current mode
--function ExamplesMod:Leave()
--end


-------------------------------------------------------------------------------
-- Called from C++ every time the world is saved
--function ExamplesMod:Save(outData)
--end

-------------------------------------------------------------------------------
-- Called from C++ every time the world is restored
--function ExamplesMod:Restore(inData, version)
--end

EntityFramework:RegisterModScript(ExamplesMod)

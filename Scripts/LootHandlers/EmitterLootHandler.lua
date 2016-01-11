local LootManager = include("Scripts/LootHandlers/LootManager.lua")
local LootHandlerClass = include("Scripts/LootHandlers/LootHandlerClass.lua")

-------------------------------------------------------------------------------
EmitterLootHandler = LootHandlerClass.Subclass("EmitterLootHandler")
EternusEngine.LootManager:RegisterHandler("EmitterLootHandler", EmitterLootHandler)

-------------------------------------------------------------------------------
function EmitterLootHandler:Constructor(args)
	if args == nil then
		args = {}
	end
	
	self.m_objectData = {}
end

-------------------------------------------------------------------------------
-- Server side only!
function EmitterLootHandler:SetupLootObject(object, lootObject)
	local componentData = {}
	
	self.m_objectData.emitters = {}
	
	local children = object:NKGetChildren()
	for key,value in pairs(children) do
		table.insert(self.m_objectData.emitters, {name = value:NKGetName(),position = value:NKGetPosition(),rotation = value:NKGetOrientation()})
	end
end

-------------------------------------------------------------------------------
-- Client side only!
function EmitterLootHandler:CreateLootObject(lootObject)

	proxyGraphic = Eternus.GameObjectSystem:NKCreateGameObject("Loot Proxy Graphic", true)
	
	if Eternus.IsServer then
		proxyGraphic:NKSetGraphics(lootObject.m_lootObject:NKGetStaticGraphics())
	else
		proxyGraphic:NKSetGraphics(Eternus.GameObjectSystem:NKFindObjectSchematicByName(lootObject.m_lootName):NKCreateStaticGraphics())
	end
	
	for _, emitter in pairs( self.m_objectData.emitters ) do

		local newEmitter = Eternus.GameObjectSystem:NKCreateGameObject(emitter.name, true)
		newEmitter:NKSetShouldSave(false)
		proxyGraphic:NKSetPosition( vec3(0,0,0) - emitter.position, false )
		proxyGraphic:NKSetOrientation( emitter.rotation, false )
		proxyGraphic:NKAddChildObject(newEmitter)
		newEmitter:NKPlaceInWorld(true, false)
		proxyGraphic:NKActivateEmitterByName(emitter.name)
	end
	
	
	
	proxyGraphic:NKSetParent(lootObject)
	proxyGraphic:NKSetPosition(vec3(0.0))
	proxyGraphic:NKSetShouldSave(false)
	proxyGraphic:NKPlaceInWorld(false, false)
	
	return proxyGraphic
end

-------------------------------------------------------------------------------
function EmitterLootHandler:LootSerializeConstruction( stream )
	local count = 0
	for _, _ in pairs( self.m_objectData.emitters ) do
		count = count + 1
	end
	stream:NKWriteInt(count)
	
	for _, emitter in pairs( self.m_objectData.emitters ) do
		stream:NKWriteString(emitter.name)
		stream:NKWriteVec3(emitter.position)
		local rot = emitter.rotation
		stream:NKWriteDouble(rot:w())
		stream:NKWriteDouble(rot:x())
		stream:NKWriteDouble(rot:y())
		stream:NKWriteDouble(rot:z())
	end
end

-------------------------------------------------------------------------------
function EmitterLootHandler:LootDeserializeConstruction( stream )
	local count = stream:NKReadInt()
	self.m_objectData.emitters = {}
	for i = 1,count do
		local emitter = {}
		emitter.name = stream:NKReadString()
		emitter.position = stream:NKReadVec3()
		emitter.rotation = quat(stream:NKReadDouble(),stream:NKReadDouble(),stream:NKReadDouble(),stream:NKReadDouble())
		self.m_objectData.emitters[i] = emitter
	end
end

return EmitterLootHandler
include("Scripts/Interactable.lua")
include("Scripts/Objects/CraftingStation.lua")
include("Scripts/Mixins/ConsumesItems.lua")

-------------------------------------------------------------------------------
BlackFurnace = CraftingStation.Subclass("BlackFurnace")

-------------------------------------------------------------------------------
function BlackFurnace:Constructor( args )
	self:Mixin(ConsumesItems, args)
end

-------------------------------------------------------------------------------
function BlackFurnace:Spawn()
	BlackFurnace.__super.Spawn(self)
	
	if (self.m_activeCrafter) then
		Eternus.EventSystem:NKBroadcastEventInRadius("Event_FurnaceIsOn", self:NKGetPosition(), 6.0, self)
	else
		Eternus.EventSystem:NKBroadcastEventInRadius("Event_FurnaceIsOff", self:NKGetPosition(), 6.0, self)
	end
end

-------------------------------------------------------------------------------
function BlackFurnace:OnEquip()
	local light = self:NKGetLight()
	if (light ~= nil) then
		light:NKSetRadius(0)
		light:NKSetFlicker(false)
	end
end

function BlackFurnace:OnDeactivate()
	BlackFurnace.__super.OnDeactivate(self)
	Eternus.EventSystem:NKBroadcastEventInRadius("Event_FurnaceIsOff", self:NKGetPosition(), 6.0, self)
end


function BlackFurnace:OnActivate()
	BlackFurnace.__super.OnActivate(self)
	Eternus.EventSystem:NKBroadcastEventInRadius("Event_FurnaceIsOn", self:NKGetPosition(), 6.0, self)
end

function BlackFurnace:OnRemoveFromWorld( freeMemory )
	Eternus.EventSystem:NKBroadcastEventInRadius("Event_FurnaceIsOff", self:NKGetPosition(), 6.0, self)
end

-------------------------------------------------------------------------------
function BlackFurnace:Event_SeekingFurnace(obj)
	if self.m_activeCrafter then
		Eternus.EventSystem:NKBroadcastEventInRadius("Event_FurnaceIsOn", self:NKGetPosition(), 6.0, self)	
	else
		Eternus.EventSystem:NKBroadcastEventInRadius("Event_FurnaceIsOff", self:NKGetPosition(), 6.0, self)	
	end
end

function BlackFurnace:Event_FurnaceIsOff()
end
-------------------------------------------------------------------------------
EntityFramework:RegisterGameObject(BlackFurnace)

ConsumesItems = EternusEngine.Mixin.Subclass("ConsumesItems")


-------------------------------------------------------------------------------
-- Mixin for crafting stations that provides logic for requiring fuel.  
function ConsumesItems:Constructor( args )
	self.m_fuelTimer = 0.0
	self.m_activeCrafter = false
	
	self.m_consumableObjects = {}
	if (args.ConsumableObjects) then
		for categoryName, categoryData in pairs(args.ConsumableObjects) do
			self.m_consumableObjects[categoryName] = {}
			self.m_consumableObjects[categoryName].Duration = categoryData.duration
			
			if (categoryData.canStart ~= nil) then
				if (categoryData.canStart == 1) then
					self.m_consumableObjects[categoryName].CanStart = true
				elseif (categoryData.canStart == 0) then
					self.m_consumableObjects[categoryName].CanStart = false
				end
			else
				self.m_consumableObjects[categoryName].CanStart = true
			end
			
			if (categoryData.isConsumed ~= nil) then
				if (categoryData.isConsumed == 1) then
					self.m_consumableObjects[categoryName].IsConsumed = true
				elseif (categoryData.isConsumed == 0) then
					self.m_consumableObjects[categoryName].IsConsumed = false
				end
			else
				self.m_consumableObjects[categoryName].IsConsumed = true
			end
		end
	end
	
	if (args.defaultBurnTime ~= nil) then
		self.m_fuelTimer = args.defaultBurnTime
	end

	-- Tick the update loop every second
	self:NKEnableScriptProcessing(true, 1000)
end

function ConsumesItems:Spawn()
	if (self.m_fuelTimer > 0.0) then
		self:OnActivate()
	end
	
	if (self.m_fuelTimer <= 0.0) then
		self:OnDeactivate()
	end
end

-------------------------------------------------------------------------------
function ConsumesItems:Update( dt )
	if (not Eternus.IsServer) then
		return
	end
	
	if self.m_fuelTimer ~= 0.0 then
		self.m_fuelTimer = self.m_fuelTimer - dt
	end

	if self.m_fuelTimer < 0.0 then
		self.m_fuelTimer = 0.0
		
		
		self:OnDeactivate()
	end
end

-------------------------------------------------------------------------------
function ConsumesItems:GetFuelData( fuelObject )
	if (fuelObject ~= nil) then
		local fuelName = fuelObject:NKGetName()
		for name,value in pairs(self.m_consumableObjects) do
			if name == fuelName then
				return value
			end
		end
		for name,value in pairs(self.m_consumableObjects) do
			if Eternus.CraftingSystem:IsMatchFor(name, fuelObject) then
				return value
			end
		end
	end
	return nil
end

-------------------------------------------------------------------------------
-- Attempts to use whatever is in args.heldItem to extend the fuel timer.
function ConsumesItems:Interact( args )
	if (not Eternus.IsServer) then
		return
	end
	
	local player = args.player
	local fuelObject = args.heldItem
	
	if (player ~= nil and fuelObject ~= nil) then
		local consumeData = self:GetFuelData(fuelObject)
		if (consumeData ~= nil) then
			if (self.m_fuelTimer <= 0.0 and not consumeData.CanStart) then
				return false 
			end
			
			if (consumeData.IsConsumed) then
				player:RemoveHandItem(1)
			end
			
			self:Consume(consumeData.Duration)
			return true
		end
	end

	return false
end

-------------------------------------------------------------------------------
function ConsumesItems:Consume( amount )
	if (not Eternus.IsServer) then
		return
	end

	self.m_fuelTimer = self.m_fuelTimer + amount
	
	self:OnActivate()
end

-------------------------------------------------------------------------------
function ConsumesItems:Save(outData)
	outData.fuelTimer = self.m_fuelTimer
end

-------------------------------------------------------------------------------
function ConsumesItems:Restore(inData, version)
	if (inData.fuelTimer ~= nil) then
		self.m_fuelTimer = inData.fuelTimer
	end
end

-------------------------------------------------------------------------------
function ConsumesItems:NetSerialize( netWriter )
	netWriter:NKWriteDouble(self.m_fuelTimer)
end

-------------------------------------------------------------------------------
function ConsumesItems:NetDeserialize( netReader )
	self.m_fuelTimer = netReader:NKReadDouble()

	if self.m_fuelTimer <= 0.0 then
		self.m_fuelTimer = 0.0
		self:OnDeactivate()
	end
end

--------------------------------------------------------------------------------
function ConsumesItems:SetupGhostObject( sourceObject )
	self.m_fuelTimer = sourceObject.m_fuelTimer
	
	if self.m_fuelTimer <= 0.0 then
		self.m_fuelTimer = 0.0
		self:OnDeactivate()
	end
end

return ConsumesItems
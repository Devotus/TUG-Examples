include("Scripts/Buffs/DamageDebuff.lua")

-------------------------------------------------------------------------------
if PoisonDebuff == nil then
	PoisonDebuff = DamageDebuff.Subclass("PoisonDebuff")
	EternusEngine.BuffManager:RegisterBuff("PoisonDebuff", PoisonDebuff)
end

PoisonDebuff.Name = "PoisonDebuff"
PoisonDebuff.Emitter = "Drift Fungal Gas Mist Emitter"

PoisonDebuff.StatToModify = "SpeedMultiplier"
PoisonDebuff.DefaultModification = 1.0
PoisonDebuff.DefaultModificationAction = StatModifier.EStatModAction.eMultiply

-------------------------------------------------------------------------------
function PoisonDebuff:Constructor( args )
	if (args.value ~= nil and Eternus.IsServer) then
		-- Mix in a stat modifier and pass args along.
		self:Mixin(StatModifier, args)
		self:InitModifier(args)
	end
	
	if (args.duration == nil) then
		self.m_duration = 5.0
	end
end

-------------------------------------------------------------------------------
function PoisonDebuff:OnStart()
	PoisonDebuff.__super.OnStart(self)
	if self.m_emitter then
		self.m_emitter:NKSetPosition(vec3(0,2,0))
	end
end

-------------------------------------------------------------------------------
function PoisonDebuff:IsHarmful()
	return true
end

return PoisonDebuff
-- Black Luster Soldier - Eclipse KnightFall
-- scripted by 4yze
local s,id=GetID()
function s.initial_effect(c)
-- Must be properly summoned before reviving
	c:EnableReviveLimit()
-- Can only be Special Summoned OPT
	c:SetSPSummonOnce(id)
-- Special Summon this card from your hand
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetCondition(s.hspcon)
	e1:SetTarget(s.hsptg)
	e1:SetOperation(s.hspop)
	c:RegisterEffect(e1)
-- Special Summon this card, Set 1 "BLS" or "GFK" Trap from hand/Deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,{id,1})
	e2:SetTarget(s.settg)
	e2:SetOperation(s.setop)
	c:RegisterEffect(e2)
-- If sent from field to GY, Set 1 "BLS" or "GFK" Spell from Deck/GY
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(s.splcon)
	e3:SetTarget(s.spltg)
	e3:SetOperation(s.splop)
	c:RegisterEffect(e3)
end
s.listed_series={0x10cf,0xbd}
function s.hspfilter(c)
	return c:IsMonster() and c:IsRace(RACE_WARRIOR|RACE_SPELLCASTER) and c:GetLevel()>=7 and c:IsReleasable()
end
function s.hspcon(e,c)
	if c==nil then return true end
	local c=e:GetHandler()
	return Duel.CheckReleaseGroup(c:GetControler(),(s.hspfilter),1,true,1,true,c,c:GetControler(),nil,false,e:GetHandler(),(s.hspfilter))
end
function s.hsptg(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectReleaseGroup(tp,(s.hspfilter),1,1,true,true,true,c,nil,nil,false,e:GetHandler(),(s.hspfilter))
	if g then
		g:KeepAlive()
		e:SetLabelObject(g)
	return true
	end
	return false
end
function s.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	if not g then return end
	Duel.Release(g,REASON_COST)
	g:DeleteGroup()
end
--If this card is Special Summoned
function s.immcon(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SPECIAL)
end
--Set "BLS" or "GFK" Trap from Hand/Deck
function s.setfilter(c)
	return (c:IsCode(32360466) or c:IsCode(73694478) or c:IsCode(00799183) or c:IsCode(56461575) or c:IsCode(29477860)) and c:IsSSetable()
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.setfilter,tp,(LOCATION_DECK|LOCATION_HAND),0,1,nil) end
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,s.setfilter,tp,(LOCATION_DECK|LOCATION_HAND),0,1,1,nil)
	local tc=g:GetFirst()
	if tc and tc:IsSSetable() then
		Duel.SSet(tp,tc)
		--Can be activated this turn
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(id,3))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetReset(RESET_EVENT|RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
 end
 function s.splcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function s.filter(c)
	return (c:IsCode(40089744) or c:IsCode(45948430) or c:IsCode(14094090) or c:IsCode(38590361) or c:IsCode(49328340) or c:IsCode(02106266) or c:IsCode(23701465) or c:IsCode(21082832) or c:IsCode(55761792)) and c:IsSpell() and c:IsSSetable()
end
function s.spltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,(LOCATION_DECK|LOCATION_GRAVE),0,1,nil) end
end
function s.splop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,(LOCATION_DECK|LOCATION_GRAVE),0,1,1,nil)
	if #g>0 then
		Duel.SSet(tp,g:GetFirst())
	end
end
 


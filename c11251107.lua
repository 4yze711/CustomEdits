--Palladium Oracle Magister
--scripted by 4yze
local s,id=GetID()
function s.initial_effect(c)
--Dark Magician + Dark Magician Girl
	c:EnableReviveLimit()
	Fusion.AddProcMixN(c,true,true,CARD_DARK_MAGICIAN,1,CARD_DARK_MAGICIAN_GIRL,1)
	Fusion.AddContactProc(c,s.contactfil,s.contactop,s.splimit,nil,nil,nil,false)
--This card's name becomes "Dark Magician" while on the field
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(CARD_DARK_MAGICIAN)
	c:RegisterEffect(e1)
--Special Summon this card and you can Set 1 "Dark Magical Circle" from Deck or GY
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,id)
	e2:SetTarget(s.settg)
	e2:SetOperation(s.setop)
	c:RegisterEffect(e2)
--Tutor "Soul Servant" from your Deck or face-up banishment
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,{id,1})
	e3:SetHintTiming(0,TIMING_MAIN_END|TIMINGS_CHECK_MONSTER)
	e3:SetCondition(function() return Duel.IsMainPhase() end)
	e3:SetTarget(s.thtg)
	e3:SetOperation(s.thop)
	c:RegisterEffect(e3)
--Add DARK attribute
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_ADD_ATTRIBUTE)
	e4:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e4:SetValue(ATTRIBUTE_DARK)
	c:RegisterEffect(e4)
end
s.listed_name={CARD_DARK_MAGICIAN|CARD_DARK_MAGICIAN_GIRL}
--Summoning Condition
function s.contactfil(tp)
	return Duel.GetMatchingGroup(Card.IsAbleToGraveAsCost,tp,LOCATION_ONFIELD,0,nil)
end
function s.contactop(g,tp)
	Duel.SendtoGrave(g,REASON_COST+REASON_MATERIAL)
end
--If this card is Special Summoned
function s.immcon(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SPECIAL)
end
--Set Circle from Deck or GY
function s.setfilter(c)
	return c:IsCode(47222536) and c:IsSSetable()
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.setfilter,tp,(LOCATION_DECK|LOCATION_GRAVE),0,1,nil) end
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,s.setfilter,tp,(LOCATION_DECK|LOCATION_GRAVE),0,1,1,nil)
	if #g>0 then
		Duel.SSet(tp,g)
	end
end
--Tutor Soul Servant
function s.tgfilter(c)
	return c:IsSetCard(0x13a) and c:IsAbleToGraveAsCost()
end
function s.thfilter(c)
	return c:IsCode(23020408) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,(LOCATION_DECK|LOCATION_REMOVED),0,1,nil) end
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,(LOCATION_DECK|LOCATION_REMOVED)) 
end
function s.thop(e,tp,eg,ep,ev,re,r,rp,c)
	local tc=Duel.SelectMatchingCard(tp,s.tgfilter,tp,(LOCATION_HAND|LOCATION_DECK),0,1,1,nil):GetFirst()
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,(LOCATION_DECK|LOCATION_REMOVED),0,1,1,nil)
	if tc and Duel.SendtoGrave(tc,REASON_COST)>0 and tc:IsLocation(LOCATION_GRAVE) and #g>0 then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
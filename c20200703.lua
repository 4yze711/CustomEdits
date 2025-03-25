-- Beyond The Veil
-- Scripted by 4yze
local s,id=GetID()
function s.initial_effect(c)
-- Link Summon Procedure: 1 Level 7 Normal Spellcaster monster
	c:EnableReviveLimit()
	Link.AddProcedure(c,s.matfilter,1,1)
--Can only be special summoned once per turn
	c:SetSPSummonOnce(id)
--This card's name becomes "Dark Magician" while on the field
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(CARD_DARK_MAGICIAN)
	c:RegisterEffect(e1)
--Cannot destroy with card effects
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetValue(1)
	c:RegisterEffect(e2)
--Cannot target with card effects when DM in GY
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(function(e) return Duel.IsExistingMatchingCard(Card.IsCode,e:GetHandlerPlayer(),LOCATION_GRAVE,0,1,nil,CARD_DARK_MAGICIAN) end)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)	
--If this card is Link Summoned
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,0))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCountLimit(1,{id,1})
	e4:SetCondition(s.spcon)
	e4:SetTarget(s.thtg)
	e4:SetOperation(s.thop)
	c:RegisterEffect(e4)
-- Heart of the Cards
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,1))
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_PREDRAW)
	e5:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,id)
	e5:SetCost(s.pdcost)
	e5:SetCondition(s.pdcon)
	e5:SetTarget(s.pdtg)
	e5:SetOperation(s.pdop)
	c:RegisterEffect(e5)
-- Return from the Veil
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(id,2))
	e6:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1,id)
	e6:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e6:SetCondition(function() return Duel.IsMainPhase() end)
	e6:SetCost(s.tgcost)
	e6:SetTarget(s.tgtg)
	e6:SetOperation(s.tgop)
	c:RegisterEffect(e6)
-- Cannot be targeted for attacks
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetCode(EFFECT_IGNORE_BATTLE_TARGET)
	e7:SetRange(LOCATION_MZONE)
	e7:SetValue(1)
	e7:SetCondition(function(e) return Duel.IsExistingMatchingCard(Card.IsCode,e:GetHandlerPlayer(),LOCATION_GRAVE,0,1,nil,CARD_DARK_MAGICIAN) end)
	c:RegisterEffect(e7)
end	
s.listed_names={CARD_DARK_MAGICIAN}
--1 Level 7 Normal Spellcaster
function s.matfilter(c,lc,sumtype,tp)
	return c:IsLevel(7) and c:IsRace(RACE_SPELLCASTER,lc,sumtype,tp) and c:IsType(TYPE_NORMAL)
end
function s.lmfilter(c)
	return c:IsCode(CARD_DARK_MAGICIAN)
end
function s.rmfilter(c)
	return c:IsRace(RACE_SPELLCASTER) and c:IsAbleToRemove()
end
function s.dmfilter(c,e,tp)
	return c:IsCode(CARD_DARK_MAGICIAN) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
end
--If this card is Link Summoned
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
-- Rod effect
function s.thfilter(c)
	return c:ListsCode(CARD_DARK_MAGICIAN) and c:IsNormalSpell() and c:IsAbleToHand()
end
function s.chainlm(e,rp,tp)
	return tp==rp
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,(LOCATION_DECK|LOCATION_GRAVE),0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,(LOCATION_DECK|LOCATION_GRAVE))
		if Duel.IsExistingMatchingCard(s.lmfilter,tp,LOCATION_GRAVE,0,1,nil) then
		Duel.SetChainLimit(s.chainlm)
	end
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,(LOCATION_DECK|LOCATION_GRAVE),0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function s.pdcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsTurnPlayer(tp) and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0
		and Duel.GetDrawCount(tp)>0 and (Duel.GetTurnCount()>1 or Duel.IsDuelType(DUEL_1ST_TURN_DRAW))
end
function s.pdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.rmfilter,tp,LOCATION_GRAVE,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.rmfilter,tp,LOCATION_GRAVE,0,2,2,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function s.pdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>2 end
	if Duel.IsExistingMatchingCard(s.lmfilter,tp,LOCATION_GRAVE,0,1,nil) then
		Duel.SetChainLimit(s.chainlm)
	end
end
function s.pdop(e,tp,eg,ep,ev,re,r,rp)
	local dt=Duel.GetDrawCount(tp)
	if dt==0 then return false end
	_replace_count=1
	_replace_max=dt
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<3 then return end
	local g=Duel.GetDecktopGroup(tp,3)
		Duel.ConfirmCards(tp,g)
		Duel.DisableShuffleCheck()
		Duel.ShuffleHand(tp)
		Duel.SortDecktop(tp,tp,3)
end
function s.tgfilter(c)
	return c:IsRace(RACE_SPELLCASTER) and c:IsAbleToGrave() and c:IsLevelBelow(4)
end
function s.filter(c)
	return c:IsSetCard(0x46) and c:IsSpell() and c:IsAbleToHand()
end
function s.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.tgfilter,tp,(LOCATION_DECK|LOCATION_HAND),0,3,nil) and 
	Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil)end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.tgfilter,tp,(LOCATION_DECK|LOCATION_HAND),0,3,3,nil)
	Duel.SendtoGrave(g,POS_FACEUP,REASON_COST)
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.dmfilter,tp,(LOCATION_GRAVE|LOCATION_REMOVED),0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,(LOCATION_GRAVE|LOCATION_REMOVED))
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,(LOCATION_DECK|LOCATION_GRAVE))
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	Duel.BreakEffect()
	Duel.SendtoDeck(c,nil,0,REASON_EFFECT)
	if c:IsLocation(LOCATION_EXTRA) and Duel.IsExistingMatchingCard(s.dmfilter,tp,(LOCATION_GRAVE|LOCATION_REMOVED),0,1,nil,e,tp) then
	local tg=Duel.GetFirstMatchingCard(s.dmfilter,tp,(LOCATION_GRAVE|LOCATION_REMOVED),0,nil,e,tp)
	if tg then
	Duel.SpecialSummon(tg,0,tp,tp,false,false,POS_FACEUP)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,(LOCATION_DECK|LOCATION_GRAVE),0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
  end
end
end	
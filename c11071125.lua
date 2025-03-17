--Dark Sorcerer's Fusion
--Scripted by 4yze
local s,id=GetID()
function s.initial_effect(c)
--Fusion Effect
	local e1=Fusion.CreateSummonEff(c,s.ffilter,s.matfilter,s.fextra,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,s.extratg)
	e1:SetCountLimit(1,id)
	c:RegisterEffect(e1)
--Draw 1
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(s.drtg)
	e2:SetOperation(s.drop)
	c:RegisterEffect(e2)
end	
s.listed_names={CARD_DARK_MAGICIAN_GIRL,CARD_DARK_MAGICIAN}
function s.ffilter(c)
	return c:ListsCodeAsMaterial(CARD_DARK_MAGICIAN) or c:ListsCodeAsMaterial(CARD_DARK_MAGICIAN_GIRL)
end
function s.dmfilter(c)
	return c:IsCode(CARD_DARK_MAGICIAN) or c:IsCode(CARD_DARK_MAGICIAN_GIRL)
end
function s.matfilter(c)
	return  (c:IsLocation(LOCATION_HAND+LOCATION_MZONE) and c:IsAbleToGrave())
end
function s.fextra(e,tp,mg)
	if Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsCode,CARD_DARK_MAGICIAN,CARD_DARK_MAGICIAN_GIRL),tp,LOCATION_ONFIELD,0,1,nil) or
	Duel.IsExistingMatchingCard(s.dmfilter,tp,LOCATION_HAND,0,1,nil) then
	local sg=Duel.GetMatchingGroup(Fusion.IsMonsterFilter(Card.IsAbleToGrave),tp,LOCATION_DECK,0,nil)
	if #sg>0 then
			return sg,s.fcheck
		end
	end
	return nil
end
function s.fcheck(tp,sg,fc)
	return sg:FilterCount(Card.IsLocation,nil,LOCATION_DECK)<=1
end
function s.desfilter(c,tp)
	return c:IsType(TYPE_FUSION) and c:ListsCodeAsMaterial(CARD_DARK_MAGICIAN,CARD_DARK_MAGICIAN_GIRL)
end
function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.desfilter,tp,LOCATION_MZONE,0,1,nil) 
	and Duel.IsPlayerCanDraw(tp,1) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,s.desfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
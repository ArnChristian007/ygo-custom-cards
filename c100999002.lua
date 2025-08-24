--Uma☆Musume - Silence Suzuka
--coded by Arn Christian
local s,id=GetID()
function s.initial_effect(c)
    Pendulum.AddProcedure(c)
    c:EnableCounterPermit(0x1210,LOCATION_MZONE)
    --move 1 Training Counter
    local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTarget(s.cttg)
	e1:SetOperation(s.ctop)
	c:RegisterEffect(e1)
    --search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,id)
    e2:SetCondition(function(e) return e:GetHandler():IsSummonType(SUMMON_TYPE_PENDULUM) end)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
end
s.counter_place_list={0x1210}
s.listed_series={0x1010}
function s.ctfilter(c,tp)
    return c:IsFaceup() and c:IsCanAddCounter(0x1210,1)
        and Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,1,c,tp) 
end
function s.cfilter(c,tp)
    return c:IsFaceup() and c:IsSetCard(0x1010) and c:IsCanRemoveCounter(tp,0x1210,1,REASON_EFFECT)
end
function s.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and s.ctfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.ctfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.SelectTarget(tp,s.ctfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
    Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,tp,0x1210)
end
function s.ctop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if not tc and not tc:IsRelateToEffect(e) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COUNTER)
    local ct=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_MZONE,0,1,1,tc,tp):GetFirst()
    if ct and ct:IsCanRemoveCounter(tp,0x1210,1,REASON_EFFECT) and ct:RemoveCounter(tp,0x1210,1,REASON_EFFECT) then
        --can attack directly
        tc:AddCounter(0x1210,1)
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_DIRECT_ATTACK)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e1)
    end
end
function s.thfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsSetCard(0x1010) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
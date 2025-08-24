--Uma☆Musume Race Start
--coded by Arn Christian
local s,id=GetID()
function s.initial_effect(c)
    c:EnableCounterPermit(0x1210, LOCATION_MZONE)
    --Activate
    local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
    --place 1 training counter each
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
    e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCountLimit(1,id)
	e2:SetTarget(s.cttg)
	e2:SetOperation(s.ctop)
	c:RegisterEffect(e2)
end
s.counter_place_list={0x1210}
s.listed_series={0x1010}
function s.pcfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x1010) and not c:IsForbidden()
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
    if Duel.IsExistingMatchingCard(s.pcfilter,tp,LOCATION_DECK,0,1,nil)
        and Util:CheckPendulumZone(tp)
        and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
        local g=Duel.SelectMatchingCard(tp,s.pcfilter,tp,LOCATION_DECK,0,1,1,nil)
        if #g>0 then
            Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
        end
    end
end
function s.ctfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x1010) and c:IsCanAddCounter(0x1210,1)
end
function s.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
    local g=Duel.GetMatchingGroup(s.ctfilter,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return #g>0 end
end
function s.ctop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.ctfilter,tp,LOCATION_MZONE,0,nil)
    for tc in aux.Next(g) do
        tc:AddCounter(0x1210,1)
    end
end
Duel.LoadCardScript("utility-function.lua")
--Uma☆Musume – Special Week
--coded by Arn Christian
local s,id=GetID()
function s.initial_effect(c)
    Pendulum.AddProcedure(c)
    c:EnableCounterPermit(0x1210, LOCATION_MZONE)
    --add 1 training counter
    local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCountLimit(1)
	e1:SetTarget(s.cttg)
	e1:SetOperation(s.ctop)
	c:RegisterEffect(e1)
    --special summon from hand
    local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(s.spcon)
	c:RegisterEffect(e2)
    --gains 800 ATK
    local e4=Effect.CreateEffect(c)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e4:SetRange(LOCATION_MZONE)
    e4:SetCountLimit(1)
	e4:SetCondition(s.indcon)
	e4:SetValue(1)
	c:RegisterEffect(e4)
    local e5=e4:Clone()
    e5:SetCode(EFFECT_UPDATE_ATTACK)
    e5:SetValue(800)
	c:RegisterEffect(e5)
end
s.counter_place_list={0x1210}
s.listed_series={0x1010}
function s.ctfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x1010) and c:IsCanAddCounter(0x1210, 1)
end
function s.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.ctfilter,tp,LOCATION_MZONE,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,tp,0x1210)
end
function s.ctop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COUNTER)
	local g=Duel.SelectMatchingCard(tp,s.ctfilter,tp,LOCATION_MZONE,0,1,1,nil)
    local tc=g:GetFirst()
    if tc then
        tc:AddCounter(0x1210,1)
        if tc:GetCounter(0x1210)>=3 then
            Duel.BreakEffect()
            Duel.Draw(tp,1,REASON_EFFECT)
        end
    end
end
function s.cfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x1010)
end
function s.spcon(e,c)
	if c==nil then return true end
	return Duel.IsExistingMatchingCard(s.cfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
        and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function s.indcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetCounter(0x1210)>=2
end
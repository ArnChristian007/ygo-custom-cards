Util = {}
function Util:RemoveCounter(type,countertype,count,reason)
    return function(e,tp,eg,ep,ev,re,r,rp,chk)
        local c=e:GetHandler()
        local res=type and Duel.IsCanRemoveCounter(tp,1,0,countertype,count,reason) or c:IsCanRemoveCounter(tp,countertype,count,reason)
        if chk==0 then return res end
	    if res then
            Duel.RemoveCounter(tp,1,0,countertype,count,reason)
        else
            c:RemoveCounter(tp,countertype,count,reason)
        end
    end
end
function Util:CheckPendulumZone(tp)
    return Duel.CheckLocation(tp,LOCATION_PZONE,0) and Duel.CheckLocation(tp,LOCATION_PZONE,1)
end
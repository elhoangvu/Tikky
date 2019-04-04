local shakura = {
onEnter = function(self)
local director = cc.Director:getInstance()
local winSize = director:getVisibleSize()
local visibleOrigin = director:getVisibleOrigin()

local me = self:getOwner()
local contentSize = me:getContentSize()
me:setAnchorPoint(0.5, 0)
me:setScale(0.01)
me:setPosition(winSize.width/2.0 + visibleOrigin.x, visibleOrigin.y)

local scaleIn = winSize.width*0.9265/contentSize.width
local scaleOut = scaleIn*1.2
local scaleOutAction = cc.ScaleTo:create(0.25, scaleOut)
local scaleInAction = cc.ScaleTo:create(0.05, scaleIn)
local seqAction = cc.Sequence:create(scaleOutAction, scaleInAction, nil)
me:runAction(seqAction)

end,

onExit = function(self)
end,

update = function(self)
end
}

-- it is needed to return shakura to let c++ nodes know it
return shakura

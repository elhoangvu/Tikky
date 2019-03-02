local shakura = {
onEnter = function(self)
local director = cc.Director:getInstance()
local winSize = director:getVisibleSize()
local visibleOrigin = director:getVisibleOrigin()

local me = self:getOwner()
local contentSize = me:getContentSize()
me:setAnchorPoint(0.5, 0.5)
me:setScale(0.01)
me:setPosition(winSize.width*0.5 + visibleOrigin.x, winSize.height*0.81 + visibleOrigin.y)

local scaleIn = winSize.width*0.71664/contentSize.width
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

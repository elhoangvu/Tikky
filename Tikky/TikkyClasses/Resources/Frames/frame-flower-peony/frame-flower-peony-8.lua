local peony = {
onEnter = function(self)
local director = cc.Director:getInstance()
local winSize = director:getVisibleSize()
local visibleOrigin = director:getVisibleOrigin()

local me = self:getOwner()
local contentSize = me:getContentSize()
me:setAnchorPoint(0.29692, 0.60657)
me:setScale(winSize.width*0.73384/contentSize.width)
me:setPosition(-contentSize.width + visibleOrigin.x, winSize.height + contentSize.height + visibleOrigin.y)

local offset = winSize.width*0.02
local newPos = { x = visibleOrigin.x + offset, y = winSize.height + visibleOrigin.y - offset }
local moveAction = cc.MoveTo:create(0.25, newPos)
newPos.y = newPos.y + offset
newPos.x = newPos.x - offset
local effAction = cc.MoveTo:create(0.05, newPos)
local seqAction = cc.Sequence:create(moveAction, effAction, nil)
me:runAction(seqAction)

end,

onExit = function(self)
end,

update = function(self)
end
}

-- it is needed to return peony to let c++ nodes know it
return peony

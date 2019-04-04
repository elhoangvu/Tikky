local peony = {
onEnter = function(self)
local director = cc.Director:getInstance()
local winSize = director:getVisibleSize()
local visibleOrigin = director:getVisibleOrigin()

local me = self:getOwner()
local contentSize = me:getContentSize()
me:setAnchorPoint(0.36139, 0.54138)
me:setScale(winSize.width*0.30849/contentSize.width)
me:setPosition(winSize.width + contentSize.width + visibleOrigin.x, winSize.height*0.36575 + visibleOrigin.y)

local offset = winSize.width*0.02
local newPos = { x = winSize.width*0.89189 + visibleOrigin.x - offset, y = winSize.height*0.36575 + visibleOrigin.y }
local moveAction = cc.MoveTo:create(0.25, newPos)
newPos.x = newPos.x + offset
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

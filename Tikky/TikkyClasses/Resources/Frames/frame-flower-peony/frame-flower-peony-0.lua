local peony = {
onEnter = function(self)
local director = cc.Director:getInstance()
local winSize = director:getVisibleSize()
local visibleOrigin = director:getVisibleOrigin()

local me = self:getOwner()
local contentSize = me:getContentSize()
me:setAnchorPoint(0.72625, 0.68399)
me:setScale(winSize.width*0.74936/contentSize.width)
me:setPosition(winSize.width + contentSize.width + visibleOrigin.x, winSize.height + visibleOrigin.y)

local offset = winSize.width*0.02
local newPos = { x = winSize.width + visibleOrigin.x - offset, y = winSize.height + visibleOrigin.y }
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

local peony = {
onEnter = function(self)
local director = cc.Director:getInstance()
local winSize = director:getVisibleSize()
local visibleOrigin = director:getVisibleOrigin()

local me = self:getOwner()
local contentSize = me:getContentSize()
me:setAnchorPoint(0.82768, 0.28368)
me:setScale(winSize.width*0.95822/contentSize.width)
me:setPosition(winSize.width + contentSize.width + visibleOrigin.x, - contentSize.height + visibleOrigin.y)

local offset = winSize.width*0.02
local newPos = { x = winSize.width + visibleOrigin.x - offset, y = visibleOrigin.y + offset }
local moveAction = cc.MoveTo:create(0.25, newPos)
newPos.y = newPos.y - offset
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

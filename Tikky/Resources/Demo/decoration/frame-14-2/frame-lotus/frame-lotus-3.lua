local shakura = {
onEnter = function(self)
local director = cc.Director:getInstance()
local winSize = director:getVisibleSize()
local visibleOrigin = director:getVisibleOrigin()

local me = self:getOwner()
local contentSize = me:getContentSize()
me:setAnchorPoint(0.5, 0.5)
me:setScale(winSize.width*0.9265/contentSize.width)
me:setPosition(contentSize.width/2.0 + visibleOrigin.x, -contentSize.height + visibleOrigin.y)

local offset = winSize.width*0.02
local newPos = { x = contentSize.width/2.0 + visibleOrigin.x, y = visibleOrigin.y + offset}
local moveAction = cc.MoveTo:create(0.25, newPos)
newPos.y = newPos.y - offset
local effAction = cc.MoveTo:create(0.05, newPos)
local seqAction = cc.Sequence:create(moveAction, effAction, nil)
me:runAction(seqAction)

end,

onExit = function(self)
end,

update = function(self)
end
}

-- it is needed to return shakura to let c++ nodes know it
return shakura

local xoffset = 2.0
local yoffset = 2.0
local rotation = 5.0
local player = {
onEnter = function(self)
print("entering")
local director = cc.Director:getInstance()
local winSize = director:getVisibleSize()
local visibleOrigin = director:getVisibleOrigin()

local me = self:getOwner()
local contentSize = me:getContentSize()
me:setPosition(winSize.width/5 - contentSize.width/5 + visibleOrigin.x,
winSize.height/2 - contentSize.height/2 + visibleOrigin.y)
end,

onExit = function(self)
print("exiting")
end,

update = function(self)
-- on update
local me = self:getOwner()
local px = me:getPositionX()
local py = me:getPositionY()
local director = cc.Director:getInstance()
local winSize = director:getVisibleSize()
if py >= winSize.height then
    yoffset = -2.0
elseif py <= 0 then
    yoffset = 2.0
end

if px >= winSize.width then
    xoffset = -2.0
elseif px <= 0 then
    xoffset = 2.0
end
rotation = rotation + 5.0
me:setRotation(rotation)
me:setPosition(px + xoffset, py + yoffset)
-- print(xoffset);
end
}
print("test")
-- it is needed to return player to let c++ nodes know it
return player

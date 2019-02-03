local facial_sticker_fox_4 = {

onEnter = function(self)
local director = cc.Director:getInstance()
local visibleOrigin = director:getVisibleOrigin()
local winSize = director:getVisibleSize()
local me = self:getOwner()
local contentSize = me:getContentSize()
me:setAnchorPoint(0.5, 0.5)

end,

onExit = function(self)
end,

updateLandmarks = function(self, args, size)
local me = self:getOwner()
local numLandmark = size/2.0
local leftX = (args[0] + args[1])/2.0
local leftY = (args[0 + numLandmark] + args[1 + numLandmark])/2.0
local rightX = (args[2] + args[3])/2.0 
local rightY = (args[2 + numLandmark] + args[3 + numLandmark])/2.0
local width = math.abs(rightX - leftX)
local scale = width/(me:getContentSize().width*0.5)

me:setScale(scale)

local scalar = (leftY-rightY)
local vectorLength = math.sqrt((rightX-leftX)*(rightX-leftX) + (rightY-leftY)*(rightY-leftY))
local alpha = math.acos(scalar/vectorLength)
local pi = 3.1415926535897
local alphaOffset = alpha*180/pi
me:setRotation(90-alphaOffset)

local x = (leftX+rightX)/2.0
local y = (leftY+rightY)/2.0
--local x = args[2]
--local y = args[2 + numLandmark]
me:setPosition(x , y)
--print("landmark x: "..x.." y: "..y)
end,

update = function(self, dt)
end

}


-- it is needed to return shakura to let c++ nodes know it
return facial_sticker_fox_4
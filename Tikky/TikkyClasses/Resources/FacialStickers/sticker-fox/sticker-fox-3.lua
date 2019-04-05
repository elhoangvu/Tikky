local facial_sticker_fox_3 = {

onEnter = function(self)
local director = cc.Director:getInstance()
local visibleOrigin = director:getVisibleOrigin()
local winSize = director:getVisibleSize()
local me = self:getOwner()
local contentSize = me:getContentSize()
me:setAnchorPoint(0.5, 0.5)
me:setVisible(false)

end,

onExit = function(self)
end,

updateLandmarks = function(self, args, size)
local me = self:getOwner()
local numLandmark = size/2.0
local leftX = args[1]
local leftY = args[1 + numLandmark]
local rightX = args[3]
local rightY = args[3 + numLandmark]
local width = math.abs(rightX - leftX)
local curScale = me:getScale()
local scale = (width*3.5)/(me:getContentSize().width)
--print("width: "..width.." curScale: "..curScale.." scale: "..scale.." size w: "..me:getContentSize().width)
me:setScale(scale)

local scalar = (leftY-rightY)
local vectorLength = math.sqrt((rightX-leftX)*(rightX-leftX) + (rightY-leftY)*(rightY-leftY))
local alpha = math.acos(scalar/vectorLength)
local pi = 3.1415926535897
local alphaOffset = alpha*180/pi
me:setRotation(90-alphaOffset)

local x = (args[0]+args[2])/2.0
local y = (args[0 + numLandmark]+args[2 + numLandmark])/2.0
--local x = args[2]
--local y = args[2 + numLandmark]
me:setPosition(x , y)
me:setVisible(true)
--print("landmark x: "..x.." y: "..y)
--me:setVisible(true)
end,

notifyNoFaceDetected = function(self)
local me = self:getOwner()
me:setVisible(false)
end,

update = function(self, dt)
end

}


-- it is needed to return shakura to let c++ nodes know it
return facial_sticker_fox_3

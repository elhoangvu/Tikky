local facial_sticker_flag_vn_1 = {

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
local leftX = args[3]
local leftY = args[3 + numLandmark]
local rightX = args[4]
local rightY = args[4 + numLandmark]
local width = math.abs(rightX - leftX)
local width0_1 = math.abs(args[0]-args[1])
local scale = (width0_1*0.35)/(me:getContentSize().width)
--print("width: "..width.." curScale: "..curScale.." scale: "..scale.." size w: "..me:getContentSize().width)
me:setScale(scale)

local scalar = (leftY-rightY)
local vectorLength = math.sqrt((rightX-leftX)*(rightX-leftX) + (rightY-leftY)*(rightY-leftY))
local alpha = math.acos(scalar/vectorLength)
local pi = 3.1415926535897
local alphaOffset = alpha*180/pi
me:setRotation(90-alphaOffset)

local x = (args[1]+args[2])*0.5 + width0_1*0.075
local y = (args[1 + numLandmark]+args[2 + numLandmark])*0.5

me:setPosition(x , y)
me:setVisible(true)
--print("landmark x: "..x.." y: "..y)
end,

notifyNoFaceDetected = function(self)
local me = self:getOwner()
me:setVisible(false)
end,

update = function(self, dt)
end

}


-- it is needed to return shakura to let c++ nodes know it
return facial_sticker_flag_vn_1

local facial_sticker_dog_3 = {

onEnter = function(self)
local director = cc.Director:getInstance()
local visibleOrigin = director:getVisibleOrigin()
local winSize = director:getVisibleSize()
local me = self:getOwner()
local contentSize = me:getContentSize()
me:setAnchorPoint(0.4776, 1.0)
me:setVisible(false)

end,

onExit = function(self)
end,

updateLandmarks = function(self, args, size)
local me = self:getOwner()
local numLandmark = size/2.0
local xlmk61 = args[0]
local ylmk61 = args[0 + numLandmark]
local xlmk63 = args[1]
local ylmk63 = args[1 + numLandmark]
local xlmk65 = args[2]
local ylmk65 = args[2 + numLandmark]
local xlmk67 = args[3]
local ylmk67 = args[3 + numLandmark]
local mouthHeight = math.sqrt((xlmk61 - xlmk67)*(xlmk61 - xlmk67)+(ylmk61-ylmk67)*(ylmk61-ylmk67))
local mouthWidth = math.sqrt((xlmk61 - xlmk63)*(xlmk61 - xlmk63)+(ylmk61-ylmk63)*(ylmk61-ylmk63))

if (mouthHeight >= mouthWidth*0.6)
then
    local leftX = (xlmk61+xlmk67)/2.0
    local leftY = (ylmk61+ylmk67)/2.0
    local rightX = (xlmk63+xlmk65)/2.0
    local rightY = (ylmk63+ylmk65)/2.0
    local width = math.abs(rightX - leftX)
    local scale = (width*5.5)/(me:getContentSize().width)
    --print("width: "..width.." scale: "..scale.." size w: "..me:getContentSize().width)
    me:setScale(scale)

    local scalar = (leftY-rightY)
    local vectorLength = math.sqrt((rightX-leftX)*(rightX-leftX) + (rightY-leftY)*(rightY-leftY))
    local alpha = math.acos(scalar/vectorLength)
    local pi = 3.1415926535897
    local alphaOffset = alpha*180/pi
    me:setRotation(90-alphaOffset)

    local x = (xlmk61+xlmk63+xlmk65+xlmk67)/4.0
    local y = (ylmk61+ylmk63+ylmk65+ylmk67)/4.0

    me:setPosition(x , y)
    me:setVisible(true)
else
    me:setVisible(false)
end
end,

notifyNoFaceDetected = function(self)
local me = self:getOwner()
me:setVisible(false)
end,

update = function(self, dt)
end

}


-- it is needed to return shakura to let c++ nodes know it
return facial_sticker_dog_3

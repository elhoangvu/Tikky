local shakura = {

onEnter = function(self)
local director = cc.Director:getInstance()
local visibleOrigin = director:getVisibleOrigin()
local winSize = director:getVisibleSize()
local me = self:getOwner()
local contentSize = me:getContentSize()
me:setAnchorPoint(0.25, 0.28)

end,

onExit = function(self)
end,

updateLandmarks = function(self, args, size)
local me = self:getOwner()
local numLandmark = size/2.0
local leftX = args[0]
local leftY = args[0 + numLandmark]
local rightX = args[2]
local rightY = args[2+ numLandmark]
local toprightX = args[3]
local toprightY = args[3 + numLandmark]
local bottomrightX = args[1]
local bottomrightY = args[1 + numLandmark]

local width = math.abs(rightX - leftX)
local heightright = math.abs(toprightY-bottomrightY)
local offsetright = heightright*0.2935

local curScale = me:getScale()
local scale = (width*0.65)/(me:getContentSize().width)
-- print("width: "..width.." curScale: "..curScale.." scale: "..scale.." size w: "..me:getContentSize().width)
me:setScale(scale)

local scalar = (toprightY-bottomrightY)
local vectorLength = math.sqrt((toprightX-bottomrightX)*(toprightX-bottomrightX) + (toprightY-bottomrightY)*(toprightY-bottomrightY))
local alpha = math.acos(scalar/vectorLength)
local pi = 3.1415926535897
local alphaOffset = alpha*180/(pi)
if (toprightX-bottomrightX < 0)
then
	alphaOffset = -alphaOffset
end
--print("alpha: "..alphaOffset)
me:setRotation(alphaOffset)


local x = 0
local y = 0
if (toprightX-bottomrightX == 0)
then
	x = args[3]
	y = args[3 + numLandmark]+offsetright
else
	local a1 = toprightX
	local a2 = toprightY
	local b1 = bottomrightX
	local b2 = bottomrightY
	local a = (a2-b2)/(a1-b1)
	local b = (a2-a*a1)
	local A = a*a+1
	local B = -a1+a*b-a2*a
	local C = a1*a1+b*b-2*a2*b+a2*a2-offsetright*offsetright
	local delta = B*B-A*C
	local x1 = (-B + math.sqrt(delta))/A
	local x2 = (-B - math.sqrt(delta))/A
	local y1 = a*x1+b
	local y2 = a*x2+b
	local len1 = (x1-b1)*(x1-b1)+(y1-b2)*(y1-b2)
	local len2 = (x2-b1)*(x2-b1)+(y2-b2)*(y2-b2)
	if (len1 > len2)
	then
		x = x1
		y = y1
	else
		x = x2
		y = y2
	end
end

me:setPosition(x , y)
--print("landmark x: "..x.." y: "..y)
end,

--update = function(self, dt)
--end

}


-- it is needed to return shakura to let c++ nodes know it
return shakura

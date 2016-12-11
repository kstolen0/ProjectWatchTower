-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- show default status bar (iOS)
display.setStatusBar( display.DefaultStatusBar )
-- include Corona's "widget" library
local widget = require "widget"
local composer = require "composer"
local loadsave = require("loadsave")
imgDir = "Images/" -- Prep the imageDirectory
local myData = loadsave.loadTable("data.json",system.DocumentsDirectory)
print(os.date("*t").yday)
---[[

local function ShiftDays(d)
	local diff = os.date("*t").yday - d.lastEntry
	if diff > 0 then
		print("different day: ".. tostring(diff))
		for i = 1, diff do
			myData.days[7] = myData.days[6]
			myData.days[6] = myData.days[5]
			myData.days[5] = myData.days[4]
			myData.days[4] = myData.days[3]
			myData.days[3] = myData.days[2]
			myData.days[2] = myData.days[1]
			myData.days[1] = {0,0}
		end
	else
		print("same day: "..tostring(diff))
	end
end

if myData == nil then

	myData = {
		good = 0,
		bad = 0,
		days = {
			{0,0},
			{0,0},
			{0,0},
			{0,0},
			{0,0},
			{0,0},
			{0,0},
		},
		lastEntry = os.date("*t").yday,
	}

	loadsave.saveTable(myData,"data.json",system.documentDirectory)
else
	ShiftDays(myData)
end--]]
composer.setVariable("myData",myData)

-- event listeners for tab buttons:
local function onFirstView( event )
	local options = {
		effect = "slideRight",
	}
	composer.gotoScene( "view1",options )
end

local function onSecondView( event )
	local options = {
		effect = "slideLeft",
	}
	composer.gotoScene( "view2",options)
end


-- create a tabBar widget with two buttons at the bottom of the screen

-- table to setup buttons
local tabButtons = {
	{ label="home", defaultFile="icon1.png", overFile="icon1-down.png", width = 32, height = 32, onPress=onFirstView, selected=true },
	{ label="data", defaultFile="icon2.png", overFile="icon2-down.png", width = 32, height = 32, onPress=onSecondView },
}

-- create the actual tabBar widget
local tabBar = widget.newTabBar{
	top = display.contentHeight - 50,	-- 50 is default height for tabBar widget
	buttons = tabButtons
}
composer.setVariable("tBar",tabBar)
onFirstView()	-- invoke first tab button's onPress event manually

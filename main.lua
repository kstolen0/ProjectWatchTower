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
local notifications = require("plugin.notifications")
local data = require("MyData")
imgDir = "Images/" -- Prep the imageDirectory

local options = {
	alert = data:GetToday(),
	sound = "alarm.caf",
	custom = {foo = "bar" }
}

local now = os.time()
local later = os.date("*t")
later.hour = 22
later.min = 0
later.sec = 0
local laterTime = os.time(later)
local diff = laterTime - now
if diff < 0 then
	diff = diff + (60*60*24)
end
print(diff)
local notif1 = notifications.scheduleNotification(diff,options)

local onNotification = function( event )
	print( event.name )
	if( event.custom ) then
		print(event.custom.foo)
	end
end

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

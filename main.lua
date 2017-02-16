-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- show default status bar (iOS)
display.setStatusBar( display.DefaultStatusBar )

  --  Include Libraries
local widget = require "widget"
local composer = require "composer"
local loadsave = require("loadsave")
local notifications = require("plugin.notifications")
local data = require("MyData")
imgDir = "Images/" -- Prep the imageDirectory


--  Prepare the trophies for first load (could also include a tutorial inside if statement)
local trophies = loadsave.loadTable("trophies.json",system.DocumentsDirectory)

if trophies == nil then

  temp = require("Trophy")
  trophies = temp:CreateTrophies()

  --  save the trohpies to json file
	loadsave.saveTable(trophies,"trophies.json",system.DocumentsDirectory)


end
--[[  (code to reset/test the trohpies, not required atm as function is in the reset button on view2)
trophies = nil
loadsave.saveTable(trophies,"trophies.json",system.DocumentsDirectory)
--]]

--  reset notifictions on app start
notifications.cancelNotification()


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

local function onThirdView( event )
	local options = {
		effect = "slideLeft",
	}
	composer.gotoScene("trophies", options)
end

--  create a tab bar for alternate page navigation
-- table to setup buttons
local tabButtons = {
	{ label="home", defaultFile="icon1.png", overFile="icon1-down.png", width = 32, height = 32, onPress=onFirstView, selected=true },
	{ label="history", defaultFile="icon2.png", overFile="icon2-down.png", width = 32, height = 32, onPress=onSecondView },
	{ label="trophies", defaultFile="icon1.png", overFile="icon1-down.png", width=32,height=32, onPress=onThirdView},
}

-- create the actual tabBar widget
local tabBar = widget.newTabBar{
	top = display.contentHeight - 40,	-- 50 is default height for tabBar widget
	buttons = tabButtons
}
--  add tabbar to composer so buttons can be set on page swipes
composer.setVariable("tBar",tabBar)
onFirstView()	-- invoke first tab button's onPress event manually

--  Set the local notifications
  --  One for 10pn tonight
  --  another for 3 days from now
local function onSystemEvent( event )

  --  Only set the notifications on application exit (could fail if app is "shut down" or something)
	if event.type == "applicationExit" then
		local options = {
			alert = data:GetToday(),   --  Get the results from today
			sound = "alarm.caf",
		}

    --  Calculate difference between now and the next 10pm
		local now = os.time()
		local later = os.date("*t")
		later.hour = 22
		later.min = 0
		later.sec = 0
		local laterTime = os.time(later)
		local diff = laterTime - now
		if diff < 0 then  --  If we've passed 10pm then add 24hrs to the clock
			diff = diff + (60*60*24)
		end

		print(diff) --  Let the console know so we can calc the time
		local notif1 = notifications.scheduleNotification(diff,options) --  set notification

    --  set other notification for three days from now
		local lateOptions = {
			alert = "It's been a while since your last entry",
			sound = "alarm.caf",
		}
		local notif2 = notifications.scheduleNotification(3*60*60*24,options)
	end
end


Runtime:addEventListener("system",onSystemEvent)

-----------------------------------------------------------------------------------------
--
-- view2.lua
--
-----------------------------------------------------------------------------------------

--	include libraries
local composer = require( "composer" )
local scene = composer.newScene()
local widget = require("widget")
local loadsave = require("loadsave")

--	initialize important variables
local lblGoodVal
local lblBadVal
local lblTotalVal
local lblGoodWeekVal
local lblBadWeekVal
local myData = require("MyData")
local background = display.newRect( display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight )
background:setFillColor( 0.15 )	-- dark
local yDisp = 39

--	function to reset data and trophies  (FOR TESTING)
local function resetEvent( event )
	if event.phase == "ended" then
		myData:Reset()
		local trophies = require "Trophy"
		loadsave.saveTable(trophies:CreateTrophies(),"trophies.json",system.DocumentsDirectory)
		local options = {
			effect = "slideLeft"
		}
		composer.gotoScene( "view2",options)
	end
end

--	function to simlate one day passing 	(FOR TESTING)
local function NextDayEvent( event )
	if event.phase == "ended" then
		myData:ShiftDays(1)
		myData:PrintWeekData()
		composer.gotoScene( "view2",options)
	end

end

--	create testing buttons
local btnReset = widget.newButton(	{
			x = display.contentWidth-60,
			y = display.contentHeight - 100,
			width = 80,
			height = 40,
			id = "btnReset",
			label = "RESET",
			onEvent = resetEvent,
			shape = "rect",
			fillColor = {default={0.25}, over={0.3}}

	}
)

local btnPushDay = widget.newButton({
	x = 60,
	y = display.contentHeight - 100,
	width = 90,
	height = 40,
	id = "btnDay",
	label = "Next Day",
	onEvent = NextDayEvent,
	shape = "rect",
	fillColor = {default={0.55},over={0.6}},
})




function scene:create( event )
	local sceneGroup = self.view

	--  Add title
  local title = display.newText( "My History", display.contentCenterX, 25, native.systemFont,28 )
  title:setFillColor( 1 )

	--	label for displaying all the positive entries
	local lblTotalGood = display.newText("total good entries",75,25 + yDisp,native.systemFont,16)
	local goodVal = tostring(myData.save.good)
	lblGoodVal = display.newText(goodVal, display.contentWidth - 20, 25 + yDisp, native.systemFont, 16)
	lblGoodVal.anchorX = 1

	--	horizontal line
	local h1 = display.newRect( display.contentCenterX+5, 45 + yDisp, display.contentWidth-10,3)
	h1:setFillColor(0.95)

	--	label for displaying all the negative entries
	local lblTotalBad = display.newText("total bad entries", 72, 65 + yDisp, native.systemFont,16)
	local badVal = tostring(myData.save.bad)
	lblBadVal = display.newText(badVal,display.contentWidth - 20, 65 + yDisp, native.systemFont, 16)
	lblBadVal.anchorX = 1

	--	horizontal line
	local h2 = display.newRect( display.contentCenterX+5, 85 + yDisp, display.contentWidth-10,3)
	h2:setFillColor(0.95)

	--	label for displaying the total number of entries
	local lblTotal = display.newText("total entries", 57, 105 + yDisp, native.systemFont,16)
	lblTotalVal = display.newText("000",display.contentWidth - 20,105 + yDisp,native.systemFont,16)
	lblTotalVal.anchorX = 1

	--	horizontal line
	local h3 = display.newRect( display.contentCenterX+5, 125 + yDisp, display.contentWidth-10,3)
	h3:setFillColor(0.95)

	--	label for displaying the past weeks good entries
	local lblGoodWeek = display.newText("recent good entries", 84, 145 + yDisp, native.systemFont,16)
	lblGoodWeekVal = display.newText("0",display.contentWidth - 20, 145 + yDisp, native.systemFont,16)
	lblGoodWeekVal.anchorX = 1

	--	horizontal line
	local h4 = display.newRect( display.contentCenterX+5, 165 + yDisp, display.contentWidth-10,3 )
	h4:setFillColor(0.95)

	--	 label for displaying the past weeks bad entries
	local lblBadWeek = display.newText("recent bad entries", 80, 185 + yDisp, native.systemFont,16)
	lblBadWeekVal = display.newText("0",display.contentWidth - 20, 185 + yDisp, native.systemFont,16)
	lblBadWeekVal.anchorX = 1

	-- all objects must be added to group (e.g. self.view)
	sceneGroup:insert( background )
	sceneGroup:insert( title )
	sceneGroup:insert( lblTotalGood )
	sceneGroup:insert( lblGoodVal )
	sceneGroup:insert( lblTotalBad )
	sceneGroup:insert( lblBadVal )
	sceneGroup:insert( lblTotal )
	sceneGroup:insert( lblTotalVal )
	sceneGroup:insert( lblGoodWeek )
	sceneGroup:insert( lblBadWeek )
	sceneGroup:insert( lblGoodWeekVal )
	sceneGroup:insert( lblBadWeekVal )
	sceneGroup:insert( h1 )
	sceneGroup:insert( h2 )
	sceneGroup:insert( h3 )
	sceneGroup:insert( h4 )

	sceneGroup:insert( btnReset )
	sceneGroup:insert( btnPushDay )

end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase

	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen

		composer.getVariable("tBar"):setSelected(2)
		local wGood
		local wBad
		wGood, wBad = myData:GetWeekData()

		--	update text
		lblGoodVal.text = tostring(myData.save.good)
		lblBadVal.text = tostring(myData.save.bad)
		lblTotalVal.text = tostring(myData.save.good + myData.save.bad)
		lblGoodWeekVal.text = tostring(wGood)
		lblBadWeekVal.text = tostring(wBad)
	elseif phase == "did" then
		-- Called when the scene is now on screen
		--
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
	end
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase

	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end
end

function scene:destroy( event )
	local sceneGroup = self.view

	-- Called prior to the removal of scene's "view" (sceneGroup)
	--
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
end

--	function to swipe between scenes
local function scTouch( event )

	if event.phase == "moved" then
		if event.x - event.xStart < -50 then
			local options = {
				effect = "slideLeft"
			}
			composer.gotoScene( "trophies",options)


		elseif event.x - event.xStart > 50 then
			local options = {
				effect = "slideRight"
			}
			composer.gotoScene("view1",options)

		end
	end
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
background:addEventListener("touch",scTouch)


-----------------------------------------------------------------------------------------

return scene

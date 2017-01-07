-----------------------------------------------------------------------------------------
--
-- view2.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
local widget = require("widget")
local lblGoodVal
local lblBadVal
local lblTotalVal
local lblGoodWeekVal
local lblBadWeekVal
local myData = require("MyData")

local function resetEvent( event )
	if event.phase == "ended" then
		myData:Reset()
		local options = {
			effect = "slideLeft"
		}
		composer.gotoScene( "view2",options)
	end
end

local function NextDayEvent( event )
	if event.phase == "ended" then
		myData:ShiftDays(1)
		myData:PrintWeekData()
		composer.gotoScene( "view2",options)
	end

end


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

	-- create a dark background to fill screen
	local background = display.newRect( display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight )
	background:setFillColor( 0.15 )	-- dark

	local lblTotalGood = display.newText("total good entries",75,25,native.systemFont,16)
	local goodVal = tostring(myData.save.good)
	lblGoodVal = display.newText(goodVal, display.contentWidth - 30, 25, native.systemFont, 16)

	local h1 = display.newRect( display.contentCenterX+5, 45, display.contentWidth-10,3)
	h1:setFillColor(0.95)

	local lblTotalBad = display.newText("total bad entries", 72, 65, native.systemFont,16)
	local badVal = tostring(myData.save.bad)
	lblBadVal = display.newText(badVal,display.contentWidth - 20, 65, native.systemFont, 16)

	local h2 = display.newRect( display.contentCenterX+5, 85, display.contentWidth-10,3)
	h2:setFillColor(0.95)

	local lblTotal = display.newText("total entries", 57, 105, native.systemFont,16)
	lblTotalVal = display.newText("000",display.contentWidth - 20,105,native.systemFont,16)

	local h3 = display.newRect( display.contentCenterX+5, 125, display.contentWidth-10,3)
	h3:setFillColor(0.95)

	local lblGoodWeek = display.newText("recent good entries", 84, 145, native.systemFont,16)
	lblGoodWeekVal = display.newText("0",display.contentWidth - 20, 145, native.systemFont,16)

	local h4 = display.newRect( display.contentCenterX+5, 165, display.contentWidth-10,3 )
	h4:setFillColor(0.95)

	local lblBadWeek = display.newText("recent bad entries", 80, 185, native.systemFont,16)
	lblBadWeekVal = display.newText("0",display.contentWidth - 20, 185, native.systemFont,16)

	-- all objects must be added to group (e.g. self.view)
	sceneGroup:insert( background )
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

		lblGoodVal.text = tostring(myData.save.good)
		if #lblGoodVal.text > 3 then
			lblGoodVal.x = display.contentCenterX + (display.contentCenterX/1.5)
		else
			lblGoodVal.x = display.contentWidth - 20
		end

		lblBadVal.text = tostring(myData.save.bad)
		if #lblBadVal.text > 3 then
			lblBadVal.x = display.contentCenterX + (display.contentCenterX/1.5)
		else
			lblBadVal.x = display.contentWidth - 20
		end

		lblTotalVal.text = tostring(myData.save.good + myData.save.bad)
		if #lblTotalVal.text > 3 then
			lblTotalVal.x = display.contentCenterX + (display.contentCenterX/1.5)
		else
			lblTotalVal.x = display.contentWidth - 20
		end

		lblGoodWeekVal.text = tostring(wGood)
		if #lblGoodWeekVal.text > 3 then
			lblGoodWeekVal.x = display.contentCenterX + (display.contentCenterX/1.5)
		else
			lblGoodWeekVal.x = display.contentWidth - 20
		end

		lblBadWeekVal.text = tostring(wBad)
		if #lblBadWeekVal.text > 3 then
			lblBadWeekVal.x = display.contentCenterX + (display.contentCenterX/1.5)
		else
			lblBadWeekVal.x = display.contentWidth - 20
		end



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

function scTouch( event )

	if event.phase == "moved" then
		if event.x - event.xStart > 50 then
			local options = {
				effect = "slideRight"
			}
			composer.gotoScene( "view1",options)
		end
	end
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
Runtime:addEventListener("touch", scTouch )
-----------------------------------------------------------------------------------------

return scene

-----------------------------------------------------------------------------------------
--
-- view2.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
local lblGoodVal
local lblBadVal
local lblTotalVal
local myData = require("MyData")

function scene:create( event )
	local sceneGroup = self.view

	-- create a dark background to fill screen
	local background = display.newRect( display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight )
	background:setFillColor( 0.15 )	-- dark

	local lblGood = display.newText("good choices",55,25,native.systemFont,16)
	local goodVal = tostring(myData.save.good)
	lblGoodVal = display.newText(goodVal, display.contentWidth - 30, 25, native.systemFont, 16)

	local h1 = display.newRect( display.contentCenterX+5, 45, display.contentWidth-10,3)
	h1:setFillColor(0.95)

	local lblBad = display.newText("bad choices", 52, 65, native.systemFont,16)
	local badVal = tostring(myData.save.bad)
	lblBadVal = display.newText(badVal,display.contentWidth - 20, 65, native.systemFont, 16)

	local h2 = display.newRect( display.contentCenterX+5, 85, display.contentWidth-10,3)
	h2:setFillColor(0.95)

	local lblTotal = display.newText("total choices", 55, 105, native.systemFont,16)
	lblTotalVal = display.newText("000",display.contentWidth - 20,105,native.systemFont,16)

	local h3 = display.newRect( display.contentCenterX+5, 125, display.contentWidth-10,3)
	h3:setFillColor(0.95)

	-- all objects must be added to group (e.g. self.view)
	sceneGroup:insert( background )
	sceneGroup:insert( lblGood )
	sceneGroup:insert( lblGoodVal )
	sceneGroup:insert( lblBad )
	sceneGroup:insert( lblBadVal )
	sceneGroup:insert( lblTotal )
	sceneGroup:insert( lblTotalVal )
	sceneGroup:insert( h1 )
	sceneGroup:insert( h2 )
	sceneGroup:insert( h3 )

end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase

	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
		composer.getVariable("tBar"):setSelected(2)
		lblGoodVal.text = tostring(myData.save.good)
			if #lblGoodVal.text > 3 then
				lblGoodVal.x = display.contentWidth - ((#lblGoodVal)*10) - 20
			else
				lblGoodVal.x = display.contentWidth - 20
			end

		lblBadVal.text = tostring(myData.save.bad)
		if #lblBadVal.text > 3 then
			lblBadVal.x = display.contentWidth - ((#lblBadVal)*10) - 20
		else
			lblBadVal.x = display.contentWidth - 20
		end

		lblTotalVal.text = tostring(myData.save.good + myData.save.bad)
		if #lblTotalVal.text > 3 then
			lblTotalVal.x = display.contentWidth - ((#lblTotalVal)*10) - 20
		else
			lblTotalVal.x = display.contentWidth - 20
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

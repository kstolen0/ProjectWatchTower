-----------------------------------------------------------------------------------------
--
-- view1.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
local widget = require("widget")
local loadsave = require("loadsave")
local strData
local faceGood
local faceBad
local faceEmote
local myData = require("MyData")
local background = display.newRect( display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight )
background:setFillColor( 0.15 )

function UpdateFace(val)

	local alph = math.floor(val)/100
	local temp = ""
	faceGood.alpha = 0.0
	faceBad.alpha = 0.0
	if val < 0 then
		faceBad.alpha = -alph
	else
		 faceGood.alpha = alph
	end

	if val <= -90 then
			temp = "-100"
	elseif val <= -85 then
		temp = "-90"
	elseif val <= -75 then
		temp = "-85"
	elseif val <= -65 then
		temp = "-75"
	elseif val <= -50 then
		temp = "-65"
	elseif val <= -35 then
		temp = "-50"
	elseif val <= -25 then
		temp = "-35"
	elseif val <= -10 then
		temp = "-25"
	elseif val < 0 then
		temp = "-10"
	elseif val == 0 then
		temp = "0"
	elseif val >= 90 then
		temp = "100"
	elseif val >= 85 then
		temp = "90"
	elseif val >= 75 then
		temp = "85"
	elseif val >= 65 then
		temp = "75"
	elseif val >= 50 then
		temp = "65"
	elseif val >= 35 then
		temp = "50"
	elseif val >= 25 then
		temp = "35"
	elseif val >= 10 then
		temp = "25"
	else
		temp = "10"
	end

	faceEmote:removeSelf()
	faceEmote = nil
	faceEmote = display.newImage(imgDir..temp..".png",display.contentCenterX,140)
	scene.view:insert(faceEmote)

end


function GoUp(event)

	if event.phase == "ended" then
	myData:GoUp()
	local temp = myData:NormalizeData()
	UpdateFace(temp)
	strData.text = tostring(temp)
 end
end

function GoDown(event)

	if event.phase == "ended" then
		myData:GoDown()
		local temp = myData:NormalizeData()
		UpdateFace(temp)
		strData.text = tostring(temp)
	end

end

local BadBtn = widget.newButton {

	top = display.contentCenterY + 120,
	left = display.contentCenterX - 140,
	width = 120,
	height = 40,
	defaultFile = imgDir.."BadBtn.png",
	overFile = imgDir.."BadBtn_h.png",
	onEvent = GoDown,
	set = false,
}

local GoodBtn = widget.newButton {

	top = display.contentCenterY + 120,
	left = display.contentCenterX + 20,
	width = 120,
	height = 40,
	defaultFile = imgDir.."GoodBtn.png",
	overFile = imgDir.."GoodBtn_h.png",
	onEvent = GoUp,
	set = false
}

local function scTouch( event )

	if event.phase == "moved" then
		if event.x - event.xStart < -50 then
			local options = {
				effect = "slideLeft"
			}
			composer.gotoScene( "view2",options)
			SCROLLING = true

		elseif event.x - event.xStart > 50 then
			local options = {
				effect = "slideRight"
			}
			composer.gotoScene("trophies",options)
			SCROLLING = true
		end
	end

end

function scene:create( event )
	local sceneGroup = self.view

	-- Called when the scene's view does not exist.
	--
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.

	-- create some text
	local title = display.newText( "brainwaves", display.contentCenterX, 25, native.systemFont, 32 )
	title:setFillColor( 1 )
	local face = display.newImage(imgDir.."headBase.png",display.contentCenterX,130)
	faceGood = display.newImage(imgDir.."headGood.png",display.contentCenterX,130)
	faceGood.alpha = 0.0
	faceBad = display.newImage(imgDir.."headBad.png",display.contentCenterX,130)
	faceBad.alpha = 0.0
	faceEmote = display.newImage(imgDir.."0.png",display.contentCenterX,140)
	strData = display.newText(tostring(myData:NormalizeData()),display.contentCenterX,display.contentCenterY+30,native.systemFont,46)
	UpdateFace(myData:NormalizeData())

	-- all objects must be added to group (e.g. self.view)
	sceneGroup:insert( background )
	sceneGroup:insert( title )
	sceneGroup:insert( face )
	sceneGroup:insert( faceGood )
	sceneGroup:insert( faceBad )
	sceneGroup:insert( strData )
	sceneGroup:insert( GoodBtn )
	sceneGroup:insert( BadBtn )
	sceneGroup:insert( faceEmote )

end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase

	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen

		local temp = myData:NormalizeData()
		UpdateFace(temp)
		strData.text = tostring(temp)
		composer.getVariable("tBar"):setSelected(1)
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


---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
background:addEventListener("touch", scTouch )
-----------------------------------------------------------------------------------------

return scene

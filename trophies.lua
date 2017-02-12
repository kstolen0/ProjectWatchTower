
local composer = require("composer")
local scene = composer.newScene()
local loadsave = require("loadsave")
local widget = require("widget")

local scroller = {}


local background = display.newRect( display.contentCenterX,display.contentCenterY, display.contentWidth,display.contentHeight)
background:setFillColor( 0.15 )



function scene:create( event )
  local sceneGroup = self.view



  local title = display.newText( "My Trophies", display.contentCenterX, 45, native.systemFont,28 )
  title:setFillColor( 1 )



  sceneGroup:insert( background )
  sceneGroup:insert( title )

  scroller = widget.newScrollView(
  {
    top = 64,
    width = display.contentWidth,
    height = display.contentHeight - 120,
    --scrollHeight = 500,
    horizontalScrollDisabled = true,
    hideBackground = true,
    length = 0,
  }
  )

  sceneGroup:insert( scroller )


end

function scene:show( event )
  local sceneGroup = self.view

  if event.phase == "will" then



    composer.getVariable("tBar"):setSelected(3)
    local trophies = loadsave.loadTable("trophies.json",system.DocumentsDirectory)


    for i,a in ipairs(trophies) do

      local tbg = display.newRect(display.contentCenterX,14 + 70*i, display.contentWidth - 20, 65)
      tbg:setFillColor(0.1)
      local tName = display.newText(a.name,15,70*i - 4,native.systemFont,18)
      tName.anchorX = 0
      local tDesc = display.newText(a.desc,15,20 + 70*i,native.systemFont,12)
      tDesc.anchorX = 0
      local tImg = display.newImage(imgDir..a.img,display.contentWidth - 42, 14 + 70*i)


      scroller:insert(tbg)
      scroller:insert(tName)
      scroller:insert(tDesc)
      scroller:insert(tImg)
      local tprogBar = display.newRect( display.contentCenterX - 30, 40 + 70*i, display.contentWidth - 84,5)
      tprogBar:setFillColor(0.06)
      scroller:insert(tprogBar)
      local p = a.count / a.total
      local tProg = display.newRect(display.contentCenterX - 30 - (tprogBar.width * (1-p)/2),40+70*i,(display.contentWidth - 84) * p,5 )
      tProg:setFillColor(0.2)
      scroller:insert(tProg)

      if a.isComplete == false then
        tName:setFillColor(0.4)
        tDesc:setFillColor(0.4)
        tImg.alpha = 0.2
      end
      --scroller.length = scroller.length + 1
      --print(i)
    end


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
      --print(scroller.length)



	end
end

local function scTouch( event )

  if event.phase == "moved" then
    if event.x - event.xStart < -50 then
      local options = {
        effect = "slideLeft"
      }
      composer.gotoScene( "view1",options)
      SCROLLING = true

    elseif event.x - event.xStart > 50 then
      local options = {
        effect = "slideRight"
      }
      composer.gotoScene("view2",options)
      SCROLLING = true
    end
  end

end



scene:addEventListener("create",scene)
scene:addEventListener("show",scene)
scene:addEventListener("hide",scene)
background:addEventListener("touch",scTouch)
return scene

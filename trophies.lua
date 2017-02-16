
--  include libraries and declare important variables
local composer = require("composer")
local scene = composer.newScene()
local loadsave = require("loadsave")
local widget = require("widget")

local scroller = {}

--  create the page background
local background = display.newRect( display.contentCenterX,display.contentCenterY, display.contentWidth,display.contentHeight)
background:setFillColor( 0.15 )



function scene:create( event )
  local sceneGroup = self.view



  --  Add title
  local title = display.newText( "My Trophies", display.contentCenterX, 25, native.systemFont,28 )
  title:setFillColor( 1 )



  sceneGroup:insert( background )
  sceneGroup:insert( title )

-- add page swipe functionality to scroller, otherwise can only swipe from the title
local function scrollListener( event )
  if event.phase == "moved" then
    if event.x - event.xStart < -50 then
      local options = {
        effect = "slideLeft"
      }
      composer.gotoScene( "view1",options)


    elseif event.x - event.xStart > 50 then
      local options = {
        effect = "slideRight"
      }
      composer.gotoScene("view2",options)

    end
  end
end

  --  create the scroller
  scroller = widget.newScrollView(
  {
    top = 64,
    width = display.contentWidth,
    height = display.contentHeight - 120,
    --scrollHeight = 500,
    horizontalScrollDisabled = true,
    hideBackground = true,
    length = 0,
    listener = scrollListener,
  }
  )

  sceneGroup:insert( scroller )


end

function scene:show( event )
  local sceneGroup = self.view

  if event.phase == "will" then


    --  set the tabbar to this page
    composer.getVariable("tBar"):setSelected(3)
    --  load trophies
    local trophies = loadsave.loadTable("trophies.json",system.DocumentsDirectory)

    --  create trophy items to display to screen. Should probably be done better, perhaps in the Trophy.lua file
    for i,a in ipairs(trophies) do

      local tbg = display.newRect(display.contentCenterX,14 + 70*i, display.contentWidth - 20, 65)  --  trophy background
      tbg:setFillColor(0.1)
      local tName = display.newText(a.name,15,70*i - 4,native.systemFont,18)  --  trophy name
      tName.anchorX = 0
      local tDesc = display.newText(a.desc,15,20 + 70*i,native.systemFont,12) -- trophy description
      tDesc.anchorX = 0
      local tImg = display.newImage(imgDir..a.img,display.contentWidth - 42, 14 + 70*i) --  trophy image


      scroller:insert(tbg)
      scroller:insert(tName)
      scroller:insert(tDesc)
      scroller:insert(tImg)
      local tprogBar = display.newRect( display.contentCenterX - 30, 40 + 70*i, display.contentWidth - 84,5)    --  progress bar background ,
      tprogBar:setFillColor(0.06)
      scroller:insert(tprogBar)
      local p = a.count / a.total --  get progress percentage
      local tProg = display.newRect(display.contentCenterX - 30 - (tprogBar.width * (1-p)/2),40+70*i,(display.contentWidth - 84) * p,5 )  --  progress completion bar
      tProg:setFillColor(0.2)
      scroller:insert(tProg)

      if a.isComplete == false then -- darken image if it's not complete
        tName:setFillColor(0.4)
        tDesc:setFillColor(0.4)
        tImg.alpha = 0.2
      end
      --scroller.length = scroller.length + 1
      --print(i)
    end


  end
end

  --  what to do when we leave the page
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

--  function for swiping between pages 
local function scTouch( event )

  if event.phase == "moved" then
    if event.x - event.xStart < -50 then
      local options = {
        effect = "slideLeft"
      }
      composer.gotoScene( "view1",options)


    elseif event.x - event.xStart > 50 then
      local options = {
        effect = "slideRight"
      }
      composer.gotoScene("view2",options)

    end
  end

end



scene:addEventListener("create",scene)
scene:addEventListener("show",scene)
scene:addEventListener("hide",scene)
background:addEventListener("touch",scTouch)
return scene

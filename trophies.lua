
local composer = require("composer")
local scene = composer.newScene()

local background = display.newRect( display.contentCenterX,display.contentCenterY, display.contentWidth,display.contentHeight)
background:setFillColor( 0.15 )



function scene:create( event )
  local sceneGroup = self.view



  local title = display.newText( "Trophies Coming Soon", display.contentCenterX, 45, native.systemFont,28 )
  title:setFillColor( 1 )

  sceneGroup:insert( background )
  sceneGroup:insert( title )

end

function scene:show( event )
  if event.phase == "will" then
    composer.getVariable("tBar"):setSelected(3)

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
background:addEventListener("touch",scTouch)

return scene

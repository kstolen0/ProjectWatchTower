
local composer = require("composer")
local scene = composer.newScene()
local loadsave = require("loadsave")

local trophies = loadsave.loadTable("trophies.json",system.DocumentsDirectory)


local background = display.newRect( display.contentCenterX,display.contentCenterY, display.contentWidth,display.contentHeight)
background:setFillColor( 0.15 )



function scene:create( event )
  local sceneGroup = self.view



  local title = display.newText( "Trophies Coming Soon", display.contentCenterX, 45, native.systemFont,28 )
  title:setFillColor( 1 )



  sceneGroup:insert( background )
  sceneGroup:insert( title )

  for i,a in ipairs(trophies) do
    local tbg = display.newRect(display.contentCenterX,56 + 70*i, display.contentWidth - 20, 65)
    tbg:setFillColor(0.1)
    local tName = display.newText(a.name,15,40 + 70*i,native.systemFont,18)
    tName.anchorX = 0
    local tDesc = display.newText(a.desc,15,60 + 70*i,native.systemFont,14)
    tDesc.anchorX = 0

    sceneGroup:insert(tbg)
    sceneGroup:insert(tName)
    sceneGroup:insert(tDesc)

    local tprogBar = display.newRect( display.contentCenterX - 30, 80 + 70*i, display.contentWidth - 84,5)
    tprogBar:setFillColor(0.06)
    sceneGroup:insert(tprogBar)
    local p = a.count / a.total
    local tProg = display.newRect(display.contentCenterX - 30 - (tprogBar.width * (1-p)/2),80+70*i,(display.contentWidth - 84) * p,5 )
    tProg:setFillColor(0.2)
    sceneGroup:insert(tProg)

    print(tprogBar.width)
    print(tProg.width)

  end
end

function scene:show( event )
  local sceneGroup = self.view

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

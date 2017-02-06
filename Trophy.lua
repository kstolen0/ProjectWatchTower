module(...,package.seeall)

local trophy = {}

function trophy:SetTrophy(name,desc,count,total,comp,img)
  temp = {}
  temp.name = name
  temp.desc = desc
  temp.count = count
  temp.total = total
  temp.isComplete = comp
  temp.img = img

  return temp
end


return trophy

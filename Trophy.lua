module(...,package.seeall)

local trophy = {}

--  function to create an object that holds trophy data
function trophy:SetTrophy(name, desc, count, total, comp, img, code)
  temp = {}
  temp.name = name
  temp.desc = desc
  temp.count = count
  temp.total = total
  temp.isComplete = comp
  temp.img = img
  temp.code = code

  return temp
end

function trophy:CreateTrophies()

  trophies = {}

  --  Trophies for positive entries
  trophies[1] = self:SetTrophy("Beginning Of A Good Thing","First positive entry",0,1,false,"TrophyTemp.png","pos")
  trophies[2] = self:SetTrophy("In For A Penny. . . ","Ten positive entries",0,10,false,"TrophyTemp.png","pos")
  trophies[3] = self:SetTrophy("In For A Pound", "Fifty positive entries",0,50,false,"TrophyTemp.png","pos")
  trophies[4] = self:SetTrophy("100 High Fives For You!", "One hundred positive entries",0,100,false,"TrophyTemp.png","pos")
  trophies[5] = self:SetTrophy("500 High Fives For You!", "Five hundred positive entries",0,500,false,"TrophyTemp.png","pos")
  trophies[6] = self:SetTrophy("All The High Fives", "One thousand positive entries",0,1000,false,"TrophyTemp.png","pos")

  --  Unique Trophies
  trophies[7] = self:SetTrophy("Power User", "Active for seven days in a row",0,7,false,"TrophyTemp.png","7days")
  trophies[8] = self:SetTrophy("Zero Temptation", "Ten consecutive positive entries",0,10,false,"TrophyTemp.png","tenRow")
  trophies[9] = self:SetTrophy("A Good Week", "More positive than negative entries \nfor seven days",0,7,false,"TrophyTemp.png","7daysMore")

  --  Count Difference between pos/neg
  trophies[10] = self:SetTrophy("50 Shades Of Awesome", "Fifty more positive entries than \nnegative entries",0,50,false,"TrophyTemp.png","diff")
  trophies[11] = self:SetTrophy("100 Shades Of Awesome", "One hundred more positive entries than \nnegative entries",0,100,false,"TrophyTemp.png","diff")

  --  Count Number Entries
  trophies[12] = self:SetTrophy("Amateur Button Pusher", "One hundred entries",0,100,false,"TrophyTemp.png","tot")
  trophies[13] = self:SetTrophy("Attentive Button Pusher", "Two hundred entries",0,200,false,"TrophyTemp.png","tot")
  trophies[14] = self:SetTrophy("Disciplined Button Pusher", "Five hundred entries",0,500,false,"TrophyTemp.png","tot")
  trophies[15] = self:SetTrophy("Expert Button Pusher", "One thousand entries",0,1000,false,"TrophyTemp.png","tot")
  trophies[16] = self:SetTrophy("Master Button Pusher", "One thousand five hundred entries",0,1500,false,"TrophyTemp.png","tot")
  trophies[17] = self:SetTrophy("Buttons Are Fun!", "Two thousand entries",0,2000,false,"TrophyTemp.png","tot")
  trophies[18] = self:SetTrophy("Over 9000!", "Nine thousand and one entries",0,9001,false,"TrophyTemp.png","tot")

  --  Count lack of negative entries
  trophies[19] = self:SetTrophy("Not Today, Friendo", "No negative entries for one day",0,1,false,"TrophyTemp.png","neg")
  trophies[20] = self:SetTrophy("Can't Fool Me Often", "No negative entries for three days",0,3,false,"TrophyTemp.png","neg")
  trophies[21] = self:SetTrophy("Can't Fool Me Ever", "No negative entries for seven days",0,7,false,"TrophyTemp.png","neg")

  return trophies

end


--  Function to add one to trophy count.
function AddOne(obj)

  obj.count = obj.count + 1
  if obj.count >= obj.total then
    obj.count = obj.total

    --  if this is the first time completing trophy, notify user
    if obj.isComplete == false then
      print(obj.name .. " IS COMPLETE!")
    end
    obj.isComplete = true
  end

  return obj
end

--  Update trophies related to counting difference between positive and negative entries
function DiffUpdate(obj,diff)

  if diff > 0 then
    if diff >= obj.total then
      obj.count = obj.total
      --  if this is the first time completing trophy, notify user
      if obj.isComplete == false then
        print(obj.name .. " IS COMPLETE!")
      end
      obj.isComplete = true
    else  --  set trophy count to diff if diff is less than total and greater than 0
      obj.count = diff
    end
  else  --  default to 0 if diff is less than 0
    obj.count = 0
  end

  return obj
end

--  check previous day's data, if negative is not 0 then reset count to 0
--  if positive > 0 and negative = 0 then add one to count
function NegUpdate(obj, data, pos)
  if not pos then
    obj.count = 0
    return obj
  end

  if data[2][1] > 0 and data[2][2] == 0 then
    obj = AddOne(obj) -- Add one to obj count
  else
    obj.count = 0
  end
  return obj
end

  --  Function to
function SevenDaysUpdate(obj, data)

  if data[2][1] > 0 or data[2][2] > 0 then
    obj = AddOne(obj)
  end
  return obj
end

function ConsecEntry(obj,pos)
  if pos then
    obj = AddOne(obj)
  else
    obj.count = 0
  end
  return obj
end

function GoodWeek(obj,data)
    if data[2][1] > data[2][2] then
      obj = AddOne(obj)
    else
      obj.count = 0
    end
end

function trophy:UpdateTrophies(trophies, myData, pos)

  data = myData.save

  for i,a in ipairs(trophies) do  --  a
    if a.isComplete == false then   --  b
      if a.code == "pos" and pos then       --  c
        a = AddOne(a)
      elseif a.code == "diff" then
        local diff = data.good - data.bad
        a = DiffUpdate(a,diff)
      elseif a.code == "tot" then
        a = DiffUpdate(a,data.good + data.bad)
      elseif a.code == "tenRow" then
        a = ConsecEntry(a, pos)
      elseif myData:IsFirstEntry() or not pos then
        if  a.code == "neg" then    --  d
            a = NegUpdate(a,data.days,pos)
        elseif a.code == "7days" then
          a = SevenDaysUpdate(a,data.days)
        elseif a.code == "7daysMore" then
          a = GoodWeek(a,data.days)
        end   --  d
      end   --  c
    end   --  b
  end   --  a

  return trophies
end

return trophy

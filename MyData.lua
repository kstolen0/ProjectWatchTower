module(...,package.seeall)
local loadsave = require("loadsave")

local myData = {}
myData.save = loadsave.loadTable("data.json",system.DocumentsDirectory)

function myData:Reset()

  self.save = {
    good = 0,
    bad = 0,
    days = {
      {0,0},
      {0,0},
      {0,0},
      {0,0},
      {0,0},
      {0,0},
      {0,0},
    },
    lastEntry = os.date("*t").yday,
  }

  loadsave.saveTable(myData.save,"data.json",system.DocumentsDirectory)
end

function myData:GetToday()
  local msg = "Don't forget to make your entries for today :)"
  local temp = self.save.days[1]

  if (temp[1] > temp[2]) then
    msg = "Good day today! Keep it up! :D"
  elseif (temp[1] < temp[2]) then
    msg = "Let's try and be better tomorrow :)"
  end

  return msg
end

function myData:IsFirstEntry()
  days = self.save.days

  if days[1][1] == 1 and days[1][2] == 0 then
    return true
  elseif days[1][1] == 0 and days[1][2] == 1 then
    return true
  end

  return false
end

function myData:ShiftDays(n)
  if n == nil then
    n = 0
  end
  local diff = os.date("*t").yday - self.save.lastEntry + n
	if diff > 0 then
		for i = 1, diff do
			self.save.days[7] = self.save.days[6]
			self.save.days[6] = self.save.days[5]
			self.save.days[5] = self.save.days[4]
			self.save.days[4] = self.save.days[3]
			self.save.days[3] = self.save.days[2]
			self.save.days[2] = self.save.days[1]
			self.save.days[1] = {0,0}
		end
	end

  self.save.lastEntry = os.date("*t").yday
  loadsave.saveTable(myData.save,"data.json",system.DocumentsDirectory)
end

--return good and bad entries from the last week
function myData:GetWeekData()
  local temp = self.save.days

  local good = 0
	local bad = 0

	for i,v in ipairs(temp) do
		good = good + v[1]
		bad = bad + v[2]
		--print(unpack(v))
	end
	--print("-----")

	return good, bad

end

function myData:PrintWeekData()
  for i,v in ipairs(self.save.days) do
    print(unpack(v))
  end
  print("[---]")
end

--  return the given days good and bad entries
function myData:GetDayData(i)

  return self.save.days[i][1], self.save.days[i][2]

end


function myData:NormalizeData()

  local good
  local bad
  good, bad = self:GetWeekData()
  total = good - bad
  if total == 0 then
    return 0
  end
  total = good + bad
  local nGood = good / total * 100
  nGood = math.round(nGood*100)*0.01
  local nBad = bad / total * 100
  nBad = math.round(nBad*100)*0.01
  local val = nGood - nBad

  return val
end

function myData:GoUp()
  self:ShiftDays()
  self.save.good = self.save.good + 1
  self.save.days[1][1] = self.save.days[1][1] + 1
  loadsave.saveTable(self.save,"data.json",system.DocumentsDirectory)
  self:PrintWeekData()
  --loadsave.saveTable(nil,"data.json",system.DocumentsDirectory)

end

function myData:GoDown()
  self:ShiftDays()
  self.save.bad = self.save.bad + 1
  self.save.days[1][2] = self.save.days[1][2] + 1
  loadsave.saveTable(self.save,"data.json",system.DocumentsDirectory)
  self:PrintWeekData()


end

if myData.save == nil then

	myData:Reset()

else
	myData:ShiftDays()
end

return myData

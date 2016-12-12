module(...,package.seeall)
local loadsave = require("loadsave")

local myData = {}
myData.save = loadsave.loadTable("data.json",system.DocumentsDirectory)

function myData:ShiftDays()
  local diff = os.date("*t").yday - self.save.lastEntry
	if diff > 0 then
		print("different day: ".. tostring(diff))
		for i = 1, diff do
			self.save.days[7] = self.save.days[6]
			self.save.days[6] = self.save.days[5]
			self.save.days[5] = self.save.days[4]
			self.save.days[4] = self.save.days[3]
			self.save.days[3] = self.save.days[2]
			self.save.days[2] = self.save.days[1]
			self.save.days[1] = {0,0}
		end
	else
		print("same day: "..tostring(diff))
	end

  self.lastEntry = os.date("*t").yday
end

if myData.save == nil then

	myData.save = {
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
else
	myData:ShiftDays()
end--]]


function myData:GetData()
  local temp = self.save.days

  local good = 0
	local bad = 0

	for i,v in ipairs(temp) do
		good = good + v[1]
		bad = bad + v[2]
		print(unpack(v))
	end
	print("-----")

	return good, bad

end

function myData:NormalizeData()

  local good
  local bad
  good, bad = self:GetData()
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
  print(self.save.good)
  self.save.days[1][1] = self.save.days[1][1] + 1
  loadsave.saveTable(self.save,"data.json",system.DocumentsDirectory)
  --loadsave.saveTable(nil,"data.json",system.DocumentsDirectory)

end

function myData:GoDown()
  self:ShiftDays()
  self.save.bad = self.save.bad + 1
  print(self.save.bad)
  self.save.days[1][2] = self.save.days[1][2] + 1
  loadsave.saveTable(self.save,"data.json",system.DocumentsDirectory)

end

return myData

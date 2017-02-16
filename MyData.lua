module(...,package.seeall)
--  Add libraries and delcare important variables
local loadsave = require("loadsave")

local myData = {}
myData.save = loadsave.loadTable("data.json",system.DocumentsDirectory)

--  function to reset the data to its initial state (0 out)
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
    lastEntry = os.date("*t").yday,   --  set last entry to today (yday means year day)
  }

  loadsave.saveTable(myData.save,"data.json",system.DocumentsDirectory) -- save to json file
end


--  return a summary of the day depending on the number of entries
function myData:GetToday()
  local msg = "Don't forget to make your entries for today"   -- default is 0
  local temp = self.save.days[1]

  if (temp[1] > temp[2]) then
    msg = "Good day today! Keep it up!"
  elseif (temp[1] < temp[2]) then
    msg = "Let's try and be better tomorrow."
  elseif temp[1] > 0 then
    msg = " You did well today!"
  end

  return msg
end

--  function to find out if this is the first entry of the day (required for some trophy evaluation)
function myData:IsFirstEntry()
  days = self.save.days

  if days[1][1] == 1 and days[1][2] == 0 then
    return true
  elseif days[1][1] == 0 and days[1][2] == 1 then
    return true
  end

  return false
end

--  Function to shift the days entry data for each day the app hasn't been used
function myData:ShiftDays(n)    --  add a variable for testing
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

  self.save.lastEntry = os.date("*t").yday    --  reset the last entry to today
  loadsave.saveTable(myData.save,"data.json",system.DocumentsDirectory)   -- update json file
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

--  function to print data for each day from the last week
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

--  function to normalize the net between good and bad entries
function myData:NormalizeData()

  local good
  local bad
  good, bad = self:GetWeekData()  --  get the last week's data
  total = good - bad  --  get the net value
  if total == 0 then  -- exit if they're equal
    return 0
  end

  total = good + bad  --  get the sum
  local nGood = good / total * 100  --  get the percentage of good
  nGood = math.round(nGood*100)*0.01  --  scale to number between 0 and 100 to 2 decimal places
  local nBad = bad / total * 100  --  same as above
  nBad = math.round(nBad*100)*0.01
  local val = nGood - nBad  --  get the net value of the percentages (number between -100 and 100)

  return val
end

--  function to update data when a positive entry has been made
function myData:GoUp()
  self:ShiftDays()
  self.save.good = self.save.good + 1 --  add 1 to total good entries
  self.save.days[1][1] = self.save.days[1][1] + 1 --  add 1 to today's good entries
  loadsave.saveTable(self.save,"data.json",system.DocumentsDirectory) --  update json file
  self:PrintWeekData()  --  print data to console

end

--  function to update data when negative entry has been made
function myData:GoDown()
  self:ShiftDays()
  self.save.bad = self.save.bad + 1 --  add 1 to total bad entries
  self.save.days[1][2] = self.save.days[1][2] + 1 --  add 1 to today's bad entries
  loadsave.saveTable(self.save,"data.json",system.DocumentsDirectory) --  update json file
  self:PrintWeekData()  --  print data to console

end

--  if create data structure if nothing exists in the json file, otherwise update data to today 
if myData.save == nil then

	myData:Reset()

else
	myData:ShiftDays()
end

return myData

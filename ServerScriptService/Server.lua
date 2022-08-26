local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")

local CloudsModule = require(ReplicatedStorage.Common.CloudsModule)

local firstBootup = false
local ApiKey = "" --Please don't share this! :-)
local Location = "Dryhope" --E.g: "London", "New York", "Paris", "Tokyo" - You may go into more detail. E.g: Tusayan
local DataUnits = "uk" --E.g: us, uk, metric

local function getWeather()
	local url = "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/"..Location.."/today?unitGroup="..DataUnits.."&include=days&key="..ApiKey.."&contentType=json"
	print(url)
	local response = HttpService:GetAsync(url)
	local data = HttpService:JSONDecode(response)
	return data
end

local function UpdateBoard(data)
	local Board = game.Workspace.DataBoard
	local Frame = Board.SurfaceGui.Frame
	Frame.Conditions.Text = "Conditions: ".. data.days[1].conditions
	Frame.Temp.Text = "Temperature: ".. data.days[1].temp
	Frame.description.Text = "Description: ".. data.days[1].description
	Frame.Timezone.Text = "Timezone: ".. data.timezone
	Frame.DataUnits.Text = "DataUnits: ".. DataUnits
end


function GenerateWeather()
	local data = getWeather()
	UpdateBoard(data) --Update the board with the new weather data, remove this line if you don't want to update the board.
	local Heightcalculation = 536 --Feel free to use an algorithim, may be very ugly though: (data.days[1].temp - data.days[1].dew) / 4.4 * 1000 - 400
	local EstimatedSizeCalculation = 3.572
	CloudsModule.NewCloud(
		{
			cover = data.days[1].cloudcover / 100; 
		})		
	Lighting.SunRays.Intensity = data.days[1].temp / 100
	if data.days[1].preciptype ~= nil then 
		for i,v in ipairs(data.days[1].preciptype)  do
			if v == "rain" then
				local Settings = {
					Rate = data.days[1].precip,
					Size = 0.08,
					Tint = Color3.fromRGB(226, 244, 255),
					Fade = 1.5,
					UpdateFreq = 1 / 45,
				}
				ReplicatedStorage.Common.Remote_Events.RainAction:FireAllClients(true, Settings)
			else 
				ReplicatedStorage.Common.Remote_Events.RainAction:FireAllClients(false)
				game.Workspace.RainBrick.ParticleEmitter.Enabled = false
			end
		end		
	end
end

GenerateWeather() --Generate the weather on startup.
while wait(60) do 
	GenerateWeather() --Generate the weather.	
end

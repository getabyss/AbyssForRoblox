local httpservice = game:GetService('HttpService')

local guiprofiles = {}
local profilesfetched
local downloadedprofiles = {}

local function vapeGithubRequest(scripturl)
	if not isfile('vape/'..scripturl) then
		local suc, res = pcall(function() return game:HttpGet('https://raw.githubusercontent.com/getabyss/AbyssForRoblox/main/'..scripturl, true) end)
		if not isfolder("vape/Profiles") then
			makefolder('vape/Profiles')
		end
		writefile('vape/'..scripturl, res)
		task.wait()
	end
	return print(scripturl)
end

local GuiLibrary = {
    MainGui = ""
}

local gui = Instance.new("ScreenGui")
	gui.Name = "idk"
	gui.DisplayOrder = 999
	gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
	gui.OnTopOfCoreBlur = true
	gui.ResetOnSpawn = false
	gui.Parent = game:GetService("Players").LocalPlayer.PlayerGui
	GuiLibrary["MainGui"] = gui

local function downloadVapeProfile(path)
	if not isfile('vape/'..path) then
		print(path)
		task.spawn(function()
			local textlabel = Instance.new('TextLabel')
			textlabel.Size = UDim2.new(1, 0, 0, 36)
			textlabel.Text = 'Downloading '..path
			textlabel.BackgroundTransparency = 1
			textlabel.TextStrokeTransparency = 0
			textlabel.TextSize = 30
			textlabel.Font = Enum.Font.SourceSans
			textlabel.TextColor3 = Color3.new(1, 1, 1)
			textlabel.Position = UDim2.new(0, 0, 0, -36)
			textlabel.Parent = GuiLibrary.MainGui
            vapeGithubRequest(path)
			textlabel:Destroy()
		end)
	end
	return downloadedprofiles[path] 
end

task.spawn(function()
    local res = game:HttpGet('https://api.github.com/repos/getabyss/AbyssForRoblox/contents/Profiles')
    if res ~= '404: Not Found' then 
        for i,v in next, httpservice:JSONDecode(res) do 
            task.wait()
            if type(v) == 'table' and v.name then 
                table.insert(guiprofiles, v.name) 
            end
        end
    end
    profilesfetched = true
end)

repeat task.wait() until profilesfetched

task.spawn(function()
	for i, v in pairs(guiprofiles) do
   		downloadVapeProfile('Profiles/'..guiprofiles[i])
		task.wait()
	end
end)	

writefile('vape/Libraries/profilesinstalled.json', 'yes')

return loadfile('vape/NewMainScript.lua')()

discord_inviterConsole = [[

     _ _                       _       _            _ _            
  __| (_)___  ___ ___  _ __ __| |     (_)_ ____   _(_) |_ ___ _ __ 
 / _` | / __|/ __/ _ \| '__/ _` |_____| | '_ \ \ / / | __/ _ \ '__|
| (_| | \__ \ (_| (_) | | | (_| |_____| | | | \ V /| | ||  __/ |   
 \__,_|_|___/\___\___/|_|  \__,_|     |_|_| |_|\_/ |_|\__\___|_|   

          discord-inviter module has loaded!!!
               made by zano_dev ❤️❤️❤️
]]

-- support path name: https://discord.com/invite/

local HttpService = game:GetService('HttpService');
local UserInputService = game:GetService('UserInputService');
local Platform = UserInputService:GetPlatform()

--VARIABLES--
local syn = syn
local http = http
local request = (syn and syn.request) or (http and http.request) or HttpService.RequestAsync or request
local split, find, format = string.split, string.find, string.format

--FUNCTIONS--
local function Split_invite_Code(str)
     local Invite_Code = "";
     if find(str, "/invite/") then
          Invite_Code = split(str, "https://discord.com/invite/")[2]
     end

     return Invite_Code
end

local utils = {}

function utils:Get_countMember_Data(url: string)
     local data = {
          total_Count = 0,
          online_Count = 0
     }

     local s, _ = pcall(function()
          local response = request({
               Url = format("https://canary.discord.com/api/v9/invites/%s?with_counts=true", Split_invite_Code(url)),
               Method = "GET",
               Headers = {
                    ["content-type"] = "application/json",
                    ["user-agent"] = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36"
               }
          })

          if response.StatusCode == 200 then
               local decode = HttpService:JSONDecode(response.Body)
               data.total_Count = decode["approximate_member_count"]
               data.online_Count = decode["approximate_presence_count"]
          end
     end)

     return data
end

warn(discord_inviterConsole)

return utils
local discordInviter = loadstring(game:HttpGet("https://raw.githubusercontent.com/notzanocoddz4/utils/main/discord_Inviter/src.luau"))()

local get_inviteData_1 = discordInviter.get_inviteData("https://discord.gg/beluga")

for key, value in pairs(get_inviteData_1) do
     print(key .. "=" .. value)
end

local get_inviteData_2 = discordInviter.get_inviteData("https://discord.gg/beluga", {
     with_total_members = true,
     with_online_members = true,
     with_guild = true,
})

for key, value in pairs(get_inviteData_2) do
     print(key .. "=" .. value)
end

discordInviter.get_joinRPC("https://discord.gg/beluga") -- it will return discord client RPC to join the server
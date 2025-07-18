local discordInviter = loadstring(game:HttpGet("https://raw.githubusercontent.com/notzanocoddz4/utils/main/discord_Inviter/src.luau"))()

local get_inviteData_1 = discordInviter.get_inviteData("https://discord.gg/beluga")

print("Invite Code: " .. get_inviteData_1.code) -- prints the invite code

local get_inviteData_2 = discordInviter.get_inviteData("https://discord.gg/beluga", {
     with_total_members = true,
     with_online_members = true,
     with_guild = true,
})

print("Invite Code: " .. get_inviteData_2.code) -- prints the invite code
print("Guild ID: " .. get_inviteData_2.guild.id) -- prints the guild ID
print("Guild Name: " .. get_inviteData_2.guild.name) -- prints the guild name
print("Guild Description: " .. get_inviteData_2.guild.description) -- prints the guild description
print("Guild Icon: " .. get_inviteData_2.guild.icon) -- prints the guild icon URL
print("Guild Splash: " .. get_inviteData_2.guild.splash) -- prints the guild splash URL
print("Guild Banner: " .. get_inviteData_2.guild.banner) -- prints the
print("Total Member Count: " .. get_inviteData_2.total_member_count) -- prints the total member count
print("Online Member Count: " .. get_inviteData_2.online_member_count) -- prints the online member count

discordInviter.get_joinRPC("https://discord.gg/beluga") -- it will return discord client RPC to join the 

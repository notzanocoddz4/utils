local discordInviter = loadstring(game:HttpGet("https://raw.githubusercontent.com/notzanocoddz4/utils/main/discord_Inviter/src.luau"))()

local get_inviteData_1 = discordInviter.get_inviteData("https://discord.gg/zr575byvYK")

print(get_inviteData_1) --[[
     Output:
     {
          code = data.code,
          guild = {
               id = data.guild.id,
               name = data.guild.name,
               description = data.guild.description,
               icon = data.guild.icon,
               splash = data.guild.splash,
               banner = data.guild.banner,
          },
     }
]]

local get_inviteData_2 = discordInviter.get_inviteData("https://discord.gg/zr575byvYK", {
     with_total_members = true,
     with_online_members = true,
})

print(get_inviteData_2) --[[
     Output:
     {
          code = data.code,
          guild = {
               id = data.guild.id,
               name = data.guild.name,
               description = data.guild.description,
               icon = data.guild.icon,
               splash = data.guild.splash,
               banner = data.guild.banner,
          },
          total_member_count = data.approximate_member_count,
          online_member_count = data.approximate_online_count,
     }
]]

discordInviter.get_joinRPC("https://discord.gg/zr575byvYK") -- it will return discord client RPC to join the server
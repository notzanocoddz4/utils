local discordInviter = loadstring(game:HttpGet("https://raw.githubusercontent.com/notzanocoddz4/utils/main/discord_Inviter/src.luau"))()

local get_inviteData_1 = discordInviter.get_inviteData("https://discord.gg/beluga")

print(get_inviteData_1) --[[
     Output:
     {
          code = "beluga",
          guild = {
               id = "846496831533088768",
               name = "BeluGANG",
               description = "The Official Beluga Discord Server!",
               icon = 31979cf932a2a7bf4a44449db61dfb99,
               splash = 1b728ecdbe543ff9e183605686639dce,
               banner = c2a7914104a45e47de19c003632fa25a,
          },
     }
]]

local get_inviteData_2 = discordInviter.get_inviteData("https://discord.gg/beluga", {
     with_total_members = true,
     with_online_members = true,
})

print(get_inviteData_2) --[[
     Output:
     {
          code = "beluga",
          guild = {
               id = "846496831533088768",
               name = "BeluGANG",
               description = "The Official Beluga Discord Server!",
               icon = 31979cf932a2a7bf4a44449db61dfb99,
               splash = 1b728ecdbe543ff9e183605686639dce,
               banner = c2a7914104a45e47de19c003632fa25a,
          },
          total_member_count = 936206,
          online_member_count = 57861
     }
]]

discordInviter.get_joinRPC("https://discord.gg/beluga") -- it will return discord client RPC to join the server
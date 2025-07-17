local HttpService = game:GetService('HttpService');
local Platform = game:GetService('UserInputService'):GetPlatform();

local discordInviter = {};

local format = string.format;

local Console = {
     print = function(...)
          print('[discord-inviter]', ...);
     end,
     warn = function(...)
          warn('[discord-inviter]', ...);
     end,
     error = function(...)
          error('[discord-inviter]', ...);
     end,
}

local function getInviteCodeFromUrl(url)
     assert(type(url) == 'string', 'Expected a string URL');

     local code = url:match('discord%.gg/([%w-]+)');
     if not code then
        code = url:match('discord%.com/invite/([%w-]+)');
     end
     return code;
end

local function generate_UUID()
     -- Generate a random UUID
     local a = "";
     for _ = 1, 8 do
          a = a .. format('%x', math.random(0, 15));
     end
     local b = "";
     for _ = 1, 4 do
          b = b .. format('%x', math.random(0, 15));
     end
     local c = "";
     for _ = 1, 4 do
          c = c .. format('%x', math.random(0, 15));
     end
     local d = "";
     for _ = 1, 4 do
          d = d .. format('%x', math.random(0, 15));
     end
     local e = "";
     for _ = 1, 12 do
          e = e .. format('%x', math.random(0, 15));
     end
     return format('%s-%s-%s-%s-%s', a, b, c, d, e);
end

export type Params = {
     with_total_members: boolean?,
     with_online_members: boolean?,
}

discordInviter.get_inviteData = function(url, params: Params)
     if not url or type(url) ~= 'string' then
          Console.warn('Invalid URL provided');
     end

     params = params or {}

     local code = getInviteCodeFromUrl(url)
     local s, r = pcall(function()
          return request({
               Url = 'https://discord.com/api/v9/invites/' .. code .. '?with_counts=true',
               Method = 'GET',
               Headers = {
                    ['Content-Type'] = 'application/json',
               }
          })
     end)

     if s and r then
          local data = HttpService:JSONDecode(r.Body)

          local result = {
               code = data.code,
               guild = nil,
               total_member_count = nil,
               online_member_count = nil,
          }

          if params.with_guild == true then
               result.guild = {
                    id = data.guild.id,
                    name = data.guild.name,
                    description = data.guild.description,
                    icon = data.guild.icon,
                    splash = data.guild.splash,
                    banner = data.guild.banner,
               }
          end
          if params.with_total_members == true then
               result.total_member_count = data.approximate_member_count
          end
          if params.with_online_members == true then
               result.online_member_count = data.approximate_persence_count
          end

          return {
               code = result.code,
               guild = result.guild,
               total_member_count = result.total_member_count,
               online_member_count = result.online_member_count,
          }
     else
          warn('Failed to fetch info ' .. tostring(r))
     end
end

discordInviter.get_joinRPC = function(url)
     if not url or type(url) ~= 'string' then
          Console.warn('Invalid URL provided');
     end

     if Platform ~= Enum.Platform.Windows then
          Console.warn('Join RPC is only supported on Windows platform');
     end
     
     local code = getInviteCodeFromUrl(url)
     local s, r = pcall(function()
          request({
               Url = 'http://127.0.0.1:6463/rpc?v=1',
               Method = 'POST',
               Headers = {
                    ['Content-Type'] = 'application/json',
                    ['Origin'] = 'https://discord.com',
               },
               Body = HttpService:JSONEncode({
                    cmd = 'INVITE_BROWSER',
                    nonce = generate_UUID(),
                    args = {
                         code = code,
                    },
               }),
          })
     end)

     if s then
          Console.print('Join RPC sent successfully');
     else
          Console.warn('Failed to send Join RPC: ' .. tostring(r));
     end
end

return discordInviter;
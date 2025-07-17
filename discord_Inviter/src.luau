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

export type Prams = {
     with_total_members: boolean?,
     with_online_members: boolean?,
}

discordInviter.get_inviteData = function(url, params: Prams)
     if not url or type(url) ~= 'string' then
          Console.warn('Invalid URL provided');
          return nil;
     end

     local code = getInviteCodeFromUrl(url);
     local s, r = pcall(function()
          local response = request({
               Url = 'https://discord.com/api/v9/invites/' .. code .. '?with_counts=true',
               Method = 'GET',
               Headers = {
                    ['Content-Type'] = 'application/json',
               }
          })
     end)

     if s and r then
          local data = HttpService:JSONDecode(r.Body);

          local result = {
               code = data.code,
               guild = {
                    id = data.guild.id,
                    name = data.guild.name,
                    description = data.guild.description,
                    icon = data.guild.icon,
                    splash = data.guild.splash,
                    banner = data.guild.banner,
               },
          };

          if params.with_total_members then
               result.total_member_count = data.approximate_member_count;
          end
          if params.with_online_members then
               result.online_member_count = data.approximate_online_count;
          end

          return result;
     else
          warn('Failed to fetch info ' .. tostring(r));
          return nil;
     end
end

discordInviter.get_joinRPC = function(url)
     if not url or type(url) ~= 'string' then
          Console.warn('Invalid URL provided');
          return nil;
     end

     if Platform ~= Enum.Platform.Windows then
          Console.warn('Join RPC is only supported on Windows platform');
          return nil;
     end
     
     local code = getInviteCodeFromUrl(url);
     local s, r = pcall(function()
          local response = request({
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
local HttpService = game:GetService("HttpService")
local Platform = game:GetService("UserInputService"):GetPlatform()

local discordInviter = {}

local format = string.format
local inviteCache = {}

local Console = {
	print = function(...) print("[discord-inviter]", ...) end,
	warn = function(...) warn("[discord-inviter]", ...) end,
	error = function(...) error("[discord-inviter]", ...) end,
}

local function getInviteCodeFromUrl(url: string)
	assert(type(url) == "string", "Expected a string URL")

	local code = url:match("discord%.gg/([%w-]+)")
	if not code then
		code = url:match("discord%.com/invite/([%w-]+)")
	end
	return code
end

local function generate_UUID()
	local function randHex(n)
		local s = ""
		for _ = 1, n do
			s = s .. format("%x", math.random(0, 15))
		end
		return s
	end
	return format("%s-%s-%s-%s-%s", randHex(8), randHex(4), randHex(4), randHex(4), randHex(12))
end

export type Params = {
	with_guild: boolean?,
	with_total_members: boolean?,
	with_online_members: boolean?,
}

-- Async + caching
discordInviter.get_inviteData = function(url: string, params: Params, callback: (any) -> ())
	if not url or type(url) ~= "string" then
		Console.warn("Invalid URL provided")
		return
	end

	params = params or {}
	local code = getInviteCodeFromUrl(url)
	if not code then
		Console.warn("Could not extract invite code")
		return
	end

	-- Cached?
	if inviteCache[code] then
		task.spawn(callback, inviteCache[code])
		return
	end

	-- Async request
	task.spawn(function()
		local s, r = pcall(function()
			return request({
				Url = "https://discord.com/api/v9/invites/" .. code .. "?with_counts=true",
				Method = "GET",
				Headers = {
					["Content-Type"] = "application/json",
				},
			})
		end)

		if s and r and r.Body then
			local data = HttpService:JSONDecode(r.Body)

			local result = {
				code = data.code,
			}

			if params.with_guild then
				result.guild = {
					id = data.guild.id,
					name = data.guild.name,
					description = data.guild.description,
					icon = data.guild.icon,
					splash = data.guild.splash,
					banner = data.guild.banner,
				}
			end
			if params.with_total_members then
				result.total_member_count = data.approximate_member_count
			end
			if params.with_online_members then
				result.online_member_count = data.approximate_presence_count
			end

			inviteCache[code] = result
			callback(result)
		else
			Console.warn("Failed to fetch invite: " .. tostring(r))
			callback(nil)
		end
	end)
end

-- Async RPC join
discordInviter.get_joinRPC = function(url: string)
	if not url or type(url) ~= "string" then
		Console.warn("Invalid URL provided")
		return
	end

	if Platform ~= Enum.Platform.Windows then
		Console.warn("Join RPC is only supported on Windows platform")
		return
	end

	local code = getInviteCodeFromUrl(url)
	if not code then
		Console.warn("Could not extract invite code")
		return
	end

	task.spawn(function()
		local s, r = pcall(function()
			return request({
				Url = "http://127.0.0.1:6463/rpc?v=1",
				Method = "POST",
				Headers = {
					["Content-Type"] = "application/json",
					["Origin"] = "https://discord.com",
				},
				Body = HttpService:JSONEncode({
					cmd = "INVITE_BROWSER",
					nonce = generate_UUID(),
					args = { code = code },
				}),
			})
		end)

		if s then
			Console.print("Join RPC sent successfully")
		else
			Console.warn("Failed to send Join RPC: " .. tostring(r))
		end
	end)
end

return discordInviter

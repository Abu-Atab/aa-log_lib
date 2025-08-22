local configs = {}

local LEVELS = {
    TRACE = {v=10, color=0x95a5a6},
    DEBUG = {v=20, color=0x3498db},
    INFO  = {v=30, color=0x2ecc71},
    WARN  = {v=40, color=0xf1c40f},
    ERROR = {v=50, color=0xe74c3c},
    FATAL = {v=60, color=0x8e44ad},
}

local function ensureConfig(resName)
    if not configs[resName] then
        configs[resName] = {
            enabled = true,
            level = "INFO",
            discord_webhook = "",
            author_name = "abu.atb Log Library",
            author_icon = "https://imgur.com/E3yRCLc",
            thumbnail = "https://imgur.com/E3yRCLc",
            image = "https://imgur.com/E3yRCLc",
        }
    end
    return configs[resName]
end

local function sendToDiscord(resName, level, message, ctx)
    local cfg = ensureConfig(resName)
    if not cfg.enabled or not cfg.discord_webhook or cfg.discord_webhook == '' then return end

    local lvl = LEVELS[level:upper()] or LEVELS.INFO

    local description = message or ""
    if ctx and next(ctx) ~= nil then
        description = description .. "\n\n```json\n" .. json.encode(ctx) .. "\n```"
    end

    local embed = {
        title       = ("[%s] [%s]"):format(resName, level:upper()),
        description = description,
        color       = lvl.color,
        footer      = { text = ("%s | %s"):format(resName, os.date("!%Y-%m-%d %H:%M:%S UTC")) },
        author      = { name = cfg.author_name, icon_url = cfg.author_icon },
        thumbnail   = { url = cfg.thumbnail },
        image       = { url = cfg.image },
        timestamp   = os.date("!%Y-%m-%dT%H:%M:%SZ")
    }

    PerformHttpRequest(cfg.discord_webhook, function() end, 'POST',
        json.encode({ username = "abu.atb Log Library", embeds = { embed } }),
        { ['Content-Type'] = 'application/json' }
    )
end

RegisterNetEvent('aa-log_lib:server:setConfig', function(resName, cfg)
    local cur = ensureConfig(resName)
    for k,v in pairs(cfg) do
        cur[k] = v
    end
end)

RegisterNetEvent('aa-log_lib:server:log', function(resName, level, message, ctx)
    local cfg = ensureConfig(resName)
    if not cfg.enabled then return end

    local lvl = LEVELS[level:upper()] or LEVELS.INFO
    local minLvl = LEVELS[(cfg.level or "INFO"):upper()] or LEVELS.INFO
    if lvl.v < minLvl.v then return end

    sendToDiscord(resName, level, message, ctx or {})
end)

-- Exports
local Logger = {}

function Logger.setConfig(cfg)
    TriggerEvent('aa-log_lib:server:setConfig', GetInvokingResource() or 'unknown', cfg)
end

function Logger.log(level, message, ctx)
    TriggerEvent('aa-log_lib:server:log', GetInvokingResource() or 'unknown', level, message, ctx)
end

function Logger.trace(msg, ctx) Logger.log('TRACE', msg, ctx) end
function Logger.debug(msg, ctx) Logger.log('DEBUG', msg, ctx) end
function Logger.info(msg, ctx)  Logger.log('INFO',  msg, ctx) end
function Logger.warn(msg, ctx)  Logger.log('WARN',  msg, ctx) end
function Logger.error(msg, ctx) Logger.log('ERROR', msg, ctx) end
function Logger.fatal(msg, ctx) Logger.log('FATAL', msg, ctx) end

exports('setConfig', Logger.setConfig)
exports('log', Logger.log)
exports('trace', Logger.trace)
exports('debug', Logger.debug)
exports('info', Logger.info)
exports('warn', Logger.warn)
exports('error', Logger.error)
exports('fatal', Logger.fatal)

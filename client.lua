local res = GetCurrentResourceName()

local function send(level, message, ctx)
    TriggerServerEvent('aa-log_lib:server:log', res, level, message, ctx or {})
end

local LoggerClient = {}

function LoggerClient.setConfig(cfg)
    TriggerServerEvent('aa-log_lib:server:setConfig', res, cfg)
end

function LoggerClient.log(level, message, ctx) send(level, message, ctx) end
function LoggerClient.trace(message, ctx) send('TRACE', message, ctx) end
function LoggerClient.debug(message, ctx) send('DEBUG', message, ctx) end
function LoggerClient.info(message, ctx)  send('INFO',  message, ctx) end
function LoggerClient.warn(message, ctx)  send('WARN',  message, ctx) end
function LoggerClient.error(message, ctx) send('ERROR', message, ctx) end
function LoggerClient.fatal(message, ctx) send('FATAL', message, ctx) end

exports('setConfig', LoggerClient.setConfig)
exports('log', LoggerClient.log)
exports('trace', LoggerClient.trace)
exports('debug', LoggerClient.debug)
exports('info', LoggerClient.info)
exports('warn', LoggerClient.warn)
exports('error', LoggerClient.error)
exports('fatal', LoggerClient.fatal)

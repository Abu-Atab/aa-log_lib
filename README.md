# aa-log_lib Script (Standalone)

This script allows you to log messages from your resources/scripts directly to Discord **with full Embed support**.
Each resource controls its own configuration, while the library automatically generates the Embed with all features.

## Features

* **Standalone** (works with server & client; does not require any external framework).
* **Per-resource configuration**: webhook, logging level, enabled/disabled.
* **Full Discord Embed support**:

  * `title` automatically generated as `[resource_name] [LEVEL]`
  * `description` contains your message + optional context in JSON
  * `color` based on logging level
  * `fields`, `footer`, `author`, `thumbnail`, `image`, `timestamp`
* **Ultra low performance usage** (no loops, only triggers on log calls).
* Lightweight and async (uses `PerformHttpRequest`).

## Usage

### Server Side

```lua
-- Set your resource-specific config
exports['aa-log_lib']:setConfig({
    enabled = true,
    level = 'DEBUG',
    discord_webhook = "https://discord.com/api/webhooks/XXXX/XXXX"
})

-- Log messages
exports['aa-log_lib']:info("Server script started", { version = "1.0.0" })
exports['aa-log_lib']:warn("Player used /arrest", { player = 42 })
exports['aa-log_lib']:error("Database connection failed")
```

### Client Side

```lua
-- Set client-side config
exports['aa-log_lib']:setConfig({
    enabled = true,
    level = 'INFO',
    discord_webhook = "https://discord.com/api/webhooks/YYYY/XXXX"
})

-- Log messages
exports['aa-log_lib']:debug("Client loaded", { player = GetPlayerServerId(PlayerId()) })
exports['aa-log_lib']:info("Player spawned", { coords = GetEntityCoords(PlayerPedId()) })
```

## Exports / API

```lua
exports['aa-log_lib']:setConfig(cfg)           -- Set resource config
exports['aa-log_lib']:log(level, message, ctx) -- Log any level
exports['aa-log_lib']:trace(message, ctx)
exports['aa-log_lib']:debug(message, ctx)
exports['aa-log_lib']:info(message, ctx)
exports['aa-log_lib']:warn(message, ctx)
exports['aa-log_lib']:error(message, ctx)
exports['aa-log_lib']:fatal(message, ctx)
```

**Parameters**:

* `message` (string) → main log message
* `ctx` (table, optional) → additional data; automatically formatted as JSON in Embed

## Logging Levels

| Level | Description       | Default Color |
| ----- | ----------------- | ------------- |
| TRACE | Fine-grained logs | Gray          |
| DEBUG | Debug messages    | Blue          |
| INFO  | Informational     | Green         |
| WARN  | Warnings          | Yellow        |
| ERROR | Errors            | Red           |
| FATAL | Critical errors   | Purple        |

## Performance

* **0.00ms idle usage** (no loops or threads).
* Each log is sent async, keeping server/client performance minimal.

## Notes

* Each resource/script manages its own webhook and settings.
* Embeds are generated automatically; you do not need to manually build Embed tables.
* Context tables are automatically formatted into a JSON code block inside the Embed.
* Works with both server-side and client-side scripts.

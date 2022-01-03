import dimscord, asyncdispatch, times, options

let discord = newDiscordClient("BOT_TOKEN_HERE")

# On ready event
proc onReady(s: Shard, r: Ready) {.event(discord).} =
    echo "Ready as " & $r.user
 
# Simple command using Nim (Ping command which edits and replies with the bot latency)
proc messageCreate(s: Shard, m: Message) {.event(discord).} =
    if m.author.bot: return
    if m.content == "!ping": # If message content is "!ping".
        let
            before = epochTime() * 1000
            msg = await discord.api.sendMessage(m.channel_id, "ping?")
            after = epochTime() * 1000
        discard await discord.api.editMessage(
            m.channel_id,
            msg.id, 
            "Pong! took " & $int(after - before) & "ms | " & $s.latency() & "ms."
        )
    # Simple embed command using Nim
    elif m.content == "!embed": # Otherwise if message content is "!embed".
        discard await discord.api.sendMessage(
            m.channel_id,
            embeds = some @[Embed(
                title: some "Hello there!", 
                description: some "This is description",
                color: some 0x00ffff
            )]
        )

# Connecting the bot to discord
waitFor discord.startSession()

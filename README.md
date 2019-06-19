# Insurgency Guns2 Addon

> Allows the VIP to acquire a primary weapon through using the `guns2` command.
> Limits weapons menu to VIPs only. This can be changes by setting
> `ins_guns2_ignore_vip_check` to `1`.

## Commands

`guns2` and `sm_guns2` will open the guns2 menu for applicable clients.

## ConVar

### ins_guns2_cooldown_time

The time a client must wait, measured in seconds, before they may access the
weapons menu again.

Default | `1`

Minimum | `0`

Maximum | no max value limit


`ins_guns2_version`: The version of the addon.

## How to Install

Copy the directories `plugins` and `scripting` to your
`steamapps\common\Insurgency Dedicated Server\insurgency` folder.

Then, reload your plugins with `sm plugins unload_all; sm plugins refresh`

**Requirements**: SourceMod and MetaMod must be installed on the server.

# Insurgency Guns2 Addon

> Allows the VIP to acquire a primary weapon through using the `guns2` command.
> Limits weapons menu to VIPs only. This can be changes by setting
> `ins_guns2_ignore_vip_check` to `1`.

## Commands

`guns2` and `sm_guns2` will open the guns2 menu for applicable clients.

`guns2_about` and `sm_guns2_about` will display information relating to the
plugin.

## ConVar

### ins_guns2_ignore_vip_check

When set to 1, all players may access the guns menu.

Default | `0`

### ins_guns2_auto_open_weapons_menu

When set to 1, the weapons menu is automatically opened at the start of a round.
Only applies to the VIP.

Default | `0`

### ins_guns2_cooldown_time

The time a client must wait, measured in seconds, before they may access the
weapons menu again.

Default | `1`

Minimum | `0`

Maximum | no max value limit

### ins_guns2_version

The version of the addon.

## How to Install

Copy the directories `plugins` and `scripting` to your
`steamapps\common\Insurgency Dedicated Server\insurgency` folder.

Then, reload your plugins with `sm plugins unload_all; sm plugins refresh`

**Requirements**: SourceMod and MetaMod must be installed on the server.

## How to Compile

You can compile the source files yourself by following these [instructions](https://wiki.alliedmods.net/Compiling_SourceMod_Plugins).

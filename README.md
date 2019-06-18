# Insurgency Guns2 Addon

> Allows the VIP to acquire a primary weapon through using the `guns2` command.
> Limits `guns2` to VIPs only.

## Commands

`guns2` and `sm_guns2` will open the guns2 menu for applicable clients.

## ConVar

`ins_guns2_ignore_vip_check` <small>default `0`</small>: When set to 1, all
players may access the guns menu.

`ins_guns2_version`: The version of the addon.

## How to Install

Copy the directories `plugins` and `scripting` to your
`steamapps\common\Insurgency Dedicated Server\insurgency` folder.

Then, reload your plugins with `sm plugins unload_all; sm plugins refresh`

**Requirements**: SourceMod and MetaMod must be installed on the server.

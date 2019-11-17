#pragma semicolon 1

#include <sdktools>
#include <sourcemod>

#define PLUGIN_NAME "VIP Gun Menu"
#define PLUGIN_DESCRIPTION "Allows the VIP to get a gun."
#define PLUGIN_VERSION "0.1.3"
#define PLUGIN_AUTHOR "Maxim Devoir"
#define PLUGIN_URL "https://github.com/MaximDevoir/ins-guns2"

#pragma newdecls required

int g_lastWeaponsTime[MAXPLAYERS + 1] = {0, ...};
bool hasVIPOpenedWeaponsMenu = false;
Handle g_IgnoreVIPCheck;
Handle g_CooldownTime;
Handle g_AutoOpenWeaponsMenu;

public Plugin myinfo = {
  name = PLUGIN_NAME,
  description = PLUGIN_DESCRIPTION,
  version = PLUGIN_VERSION,
  author = PLUGIN_AUTHOR,
  url = PLUGIN_URL
}

public void OnClientPostAdminCheck(int client) {
  g_lastWeaponsTime[client] = 0;
}

public void OnClientDisconnect_Post(int client) {
  g_lastWeaponsTime[client] = 0;
}

public void OnPluginStart() {
  LoadTranslations("common.phrases");
  CreateConVar("ins_guns2_version", PLUGIN_VERSION, PLUGIN_NAME, FCVAR_NOTIFY|FCVAR_SPONLY|FCVAR_REPLICATED);
  g_IgnoreVIPCheck = CreateConVar("ins_guns2_ignore_vip_check",
    "0",
    "When set to 1, all players may access the guns menu.",
    FCVAR_NOTIFY,
    true,
    0.0,
    true,
    1.0);
  g_AutoOpenWeaponsMenu = CreateConVar("ins_guns2_auto_open_weapons_menu",
    "0",
    "When set to 1, the weapons menu is automatically opened at the start of a round. Only applies to the VIP.",
    FCVAR_NOTIFY,
    true,
    0.0,
    true,
    1.0);
  g_CooldownTime = CreateConVar("ins_guns2_cooldown_time",
    "1",
    "The time a client must wait, measured in seconds, before they may access the weapons menu again.",
    FCVAR_NOTIFY,
    true,
    0.0);

  if (GetConVarInt(g_IgnoreVIPCheck) == 1) {
    ReplyToCommand(0, "[SM Guns2] g_IgnoreVIPCheck is set to 1.");
    ReplyToCommand(0, "[SM Guns2] All players are able to select weapons while g_IgnoreVIPCheck is 1.");
  }

  RegConsoleCmd("sm_guns2", WeaponMenu);
  RegConsoleCmd("guns2", WeaponMenu);

  RegConsoleCmd("sm_guns2_about", About);
  RegConsoleCmd("guns2_about", About);

  HookEvent("round_start", OnRoundStart);
  HookEvent("round_end", OnRoundEnd);
}

public void OnRoundStart(Handle event, const char[] name, bool dontBroadcast) {
  // The method `OnRoundStart` is executed before the character model information
  // is loaded onto the map. The `isVIP` function requires character model
  // information. Wait a couple seconds before checking character model
  // information.
  CreateTimer(5.0, InformVIP);
}

public void OnRoundEnd(Handle event, const char[] name, bool dontBroadcast) {
  hasVIPOpenedWeaponsMenu = false;
}

/**
 * Search for vip client and inform them of the `guns2` command.
 */
public Action InformVIP(Handle timer) {
  for (int client = 1; client <= MaxClients; client++ ) {
    if (!IsClientInGame(client) || IsFakeClient(client)) {
      continue;
    }

    if (isVIP(client)) {
      PrintToChat(client, "\x01You are the VIP. Type \x04!guns2\x01 in team chat to get a primary weapon.");
      PrintHintText(client, "You are the VIP. Type !guns2 in team chat to get a primary weapon.");

      if (GetConVarInt(g_AutoOpenWeaponsMenu) == 1 && hasVIPOpenedWeaponsMenu == false) {
        Weapons(client);
      }

      GivePlayerItem(client, "weapon_m18");
      PrintToChat(client, "M18 Obtained... Press 3");

      return Plugin_Handled;
    }
  }

  return Plugin_Handled;
}

public Action About(int client, int args) {
  ReplyToCommand(client, "\x04[About]\x01 %s | version %s", PLUGIN_NAME, PLUGIN_VERSION);
  ReplyToCommand(client, "\x04[Page]\x01 %s", PLUGIN_URL);
  return Plugin_Handled;
}

public Action WeaponMenu(int client, int args) {
  if (client == 0) {
    ReplyToCommand(client, "[SM] %t", "Command is in-game only");
    return Plugin_Handled;
  }

  bool isClientVIP = isVIP(client);

  if (isClientVIP == false && GetConVarInt(g_IgnoreVIPCheck) != 1) {
    PrintToChat(client, "The guns2 command is limited to the VIP.");
    return Plugin_Handled;
  }

  if (g_lastWeaponsTime[client] == 0 || g_lastWeaponsTime[client] <= (GetTime() - GetConVarInt(g_CooldownTime))) {
    g_lastWeaponsTime[client] = GetTime();
    Weapons(client);

    if (isClientVIP == true) {
      hasVIPOpenedWeaponsMenu = true;
    }
  } else {
    PrintToChat(client, "Wait %d seconds to use guns2.", GetConVarInt(g_CooldownTime) - (GetTime() - g_lastWeaponsTime[client]));
  }

  return Plugin_Handled;
}

public Action Weapons(int client) {
  Handle menu = CreateMenu(WeaponMenuHandler);

  SetMenuTitle(menu, PLUGIN_NAME);

  AddMenuItem(menu, "option1", "MP5K");
  AddMenuItem(menu, "option2", "UMP45");
  AddMenuItem(menu, "option3", "M14");
  AddMenuItem(menu, "option4", "MK18");
  AddMenuItem(menu, "option5", "M4A1");
  AddMenuItem(menu, "option6", "M16A4");
  AddMenuItem(menu, "option7", "Galil SAR");
  AddMenuItem(menu, "option8", "L1A1 SLR");
  AddMenuItem(menu, "option9", "M1A1");
  AddMenuItem(menu, "option10", "M249");
  AddMenuItem(menu, "option11", "M590");
  AddMenuItem(menu, "option12", "MP40");
  AddMenuItem(menu, "option13", "Sterling");
  AddMenuItem(menu, "option14", "SKS");
  AddMenuItem(menu, "option15", "AKS-74U");
  AddMenuItem(menu, "option16", "AKM");
  AddMenuItem(menu, "option17", "AK-74");
  AddMenuItem(menu, "option18", "Galil");
  AddMenuItem(menu, "option19", "FAL");
  AddMenuItem(menu, "option20", "RPK");
  AddMenuItem(menu, "option21", "TOZ");
  AddMenuItem(menu, "option22", "Mosin");

  SetMenuExitButton(menu, true);
  DisplayMenu(menu, client, 15);

  return Plugin_Handled;
}

public int WeaponMenuHandler(Handle menu, MenuAction action, int client, int itemNum) {
  if (action == MenuAction_Select) {
    switch (itemNum) {
      case 0: {
        GiveClientWeapon(client, "weapon_mp5", "MP5K");
      }
      case 1: {
        GiveClientWeapon(client, "weapon_ump45", "UMP45");
      }
      case 2: {
        GiveClientWeapon(client, "weapon_m14", "M14");
      }
      case 3: {
        GiveClientWeapon(client, "weapon_mk18", "MK18");
      }
      case 4: {
        GiveClientWeapon(client, "weapon_m4a1", "M4A1");
      }
      case 5: {
        GiveClientWeapon(client, "weapon_m16a4", "M16A4");
      }
      case 6: {
        GiveClientWeapon(client, "weapon_galil_sar", "Galil SAR");
      }
      case 7: {
        GiveClientWeapon(client, "weapon_l1a1", "L1A1");
      }
      case 8: {
        GiveClientWeapon(client, "weapon_m1a1", "M1A1");
      }
      case 9: {
        GiveClientWeapon(client, "weapon_m249", "M249");
      }
      case 10: {
        GiveClientWeapon(client, "weapon_m590", "M590");
      }
      case 11: {
        GiveClientWeapon(client, "weapon_mp40", "MP40");
      }
      case 12: {
        GiveClientWeapon(client, "weapon_sterling", "Sterling");
      }
      case 13: {
        GiveClientWeapon(client, "weapon_sks", "SKS");
      }
      case 14: {
        GiveClientWeapon(client, "weapon_aks74u", "AKS-74U");
      }
      case 15: {
        GiveClientWeapon(client, "weapon_akm", "AKM");
      }
      case 16: {
        GiveClientWeapon(client, "weapon_ak74", "AK-74");
      }
      case 17: {
        GiveClientWeapon(client, "weapon_galil", "GALIL");
      }
      case 18: {
        GiveClientWeapon(client, "weapon_fal", "FAL");
      }
      case 19: {
        GiveClientWeapon(client, "weapon_rpk", "RPK");
      }
      case 20: {
        GiveClientWeapon(client, "weapon_toz", "TOZ");
      }
      case 21: {
        GiveClientWeapon(client, "weapon_mosin", "Mosin");
      }
    }
  }
}

public void GiveClientWeapon(int client, const char[] item, const char[] name) {
  GivePlayerItem(client, item);
  PrintToChat(client, "%s Obtained... Press 1", name);
}

public bool isVIP(int client) {
  // PLATFORM_MAX_PATH is 256 on Windows
  char modelName[PLATFORM_MAX_PATH];
  GetClientModel(client, modelName, sizeof(modelName));

  // For VIPs, modelName is either:
  //  models\characters\civilian_vip_security.mdl
  //  models\characters\civilian_vip_insurgent.mdl
  if (StrContains(modelName, "civilian_vip_security", false) != -1
    || StrContains(modelName, "civilian_vip_insurgent", false) != -1
  ) {
    return true;
  }

  return false;
}

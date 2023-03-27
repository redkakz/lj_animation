#include <sourcemod>
#include <sdktools>
#include <sdkhooks>

#pragma newdecls required
#pragma semicolon 1

#include "lj_animation/constants.sp"

bool gB_IsMovementApiLibraryExist = false;
int gI_BeamModel;
int gI_IsLJAEnabled[MAXPLAYERS + 1];
int gI_SortedJumpData[MAXPLAYERS + 1][MAX_TRACKING_TICKCOUNT][10];

#include "lj_animation/sqlite.sp"
#include "lj_animation/commands.sp"
#include "lj_animation/statemachine.sp"


public Plugin myinfo =
{
	name = 			"Long Jump Animation - GOKZ",
	author = 		"redka",
	description = 	"CSGO GOKZ in-game animation for longjumps",
	version = 		LJA_VERSION,
	url = 			LJA_SOURCE_URL
};

public void OnPluginStart()
{
	gB_IsMovementApiLibraryExist = LibraryExists("movementapi");
	RegisterCommands();
	SetupDatabase();
}

public void OnMapStart()
{
    gI_BeamModel = PrecacheModel("materials/sprites/laserbeam.vmt", true);
}

public void OnPluginEnd()
{
	for (int client = 1; client <= MaxClients; client++)
	{
		if (IsClientInGame(client))
		{
			SaveIsLJAEnabled(client);
		}
	}
}
 
public void OnAllPluginsLoaded()
{
    gB_IsMovementApiLibraryExist = LibraryExists("movementapi");
}
 
public void OnLibraryRemoved(const char[] name)
{
    if (StrEqual(name, "movementapi"))
    {
        gB_IsMovementApiLibraryExist = false;
    }
}
 
public void OnLibraryAdded(const char[] name)
{
    if (StrEqual(name, "movementapi"))
    {
        gB_IsMovementApiLibraryExist = true;
    }
}

public void OnClientConnected(int client)
{
	if (IsFakeClient(client))
	{
		return;
	}
	
	gB_IsLJAEnabledLoaded[client] = false;
}

public void OnClientAuthorized(int client, const char[] auth)
{
	if (IsFakeClient(client))
	{
		return;
	}

	LoadIsLJAEnabled(client);
}

public void OnClientDisconnect(int client)
{
	if (IsFakeClient(client))
	{
		return;
	}
	
	ResetAnimation(client);
	
	SaveIsLJAEnabled(client);
}

public void OnPlayerRunCmdPost(int client, int buttons, int impulse,
		const float vel[3], const float angles[3], int weapon, int subtype,
		int cmdnum, int tickcount, int seed, const int mouse[2])
{
	if(gB_IsMovementApiLibraryExist
		&& gB_IsLJAEnabledLoaded[client]
		&& gI_IsLJAEnabled[client] == 1)
	{
		RunStateMachine(client);
	}
}
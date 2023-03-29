#include <sourcemod>
#include <sdktools>
#include <sdkhooks>
#include <clientprefs>

#include <movementapi>

#pragma newdecls required
#pragma semicolon 1

#include "lj_animation/constants.sp"
#include "lj_animation/globals.sp"
#include "lj_animation/cookies.sp"

#include "lj_animation/commands.sp"
#include "lj_animation/animation.sp"

#include "lj_animation/statemachine.sp"
#include "lj_animation/state.sp"

#include "lj_animation/statetransition.sp"
#include "lj_animation/stateconditions.sp"

#include "lj_animation/statetransitionpost.sp"
#include "lj_animation/jumpdata.sp"
#include "lj_animation/jumpdatavalidate.sp"


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
	
	RegisterCookies();
	
	for(int client = 1; client <= MaxClients; client++)
	{
		if(AreClientCookiesCached(client))
		{
			OnClientCookiesCached(client);
		}
	}
}

public void OnMapStart()
{
    gI_BeamModel = PrecacheModel("materials/sprites/laserbeam.vmt", true);
}

public void OnPluginEnd()
{
	for(int client = 1; client <= MaxClients; client++)
	{
		if(IsClientInGame(client)
			&& AreClientCookiesCached(client))
		{
			SaveLJACookie(client);
		}
	}
}
 
public void OnAllPluginsLoaded()
{
    gB_IsMovementApiLibraryExist = LibraryExists("movementapi");
}
 
public void OnLibraryRemoved(const char[] name)
{
    if(StrEqual(name, "movementapi"))
    {
        gB_IsMovementApiLibraryExist = false;
    }
}
 
public void OnLibraryAdded(const char[] name)
{
    if(StrEqual(name, "movementapi"))
    {
        gB_IsMovementApiLibraryExist = true;
    }
}

public void OnClientCookiesCached(int client)
{
	if (!IsFakeClient(client))
	{
		LoadLJACookie(client);
	}
}

public void OnClientDisconnect(int client)
{
	if(!IsFakeClient(client))
	{
		ResetAnimation(client);
	
		if(AreClientCookiesCached(client))
		{
			SaveLJACookie(client);
		}
		
		gI_IsLJAEnabled[client] = 0;
	}
}

public void OnPlayerRunCmdPost(int client, int buttons, int impulse,
		const float vel[3], const float angles[3], int weapon, int subtype,
		int cmdnum, int tickcount, int seed, const int mouse[2])
{
	if(gB_IsMovementApiLibraryExist && gI_IsLJAEnabled[client] == 1)
	{
		RunStateMachine(client);
	}
}
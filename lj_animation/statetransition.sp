int gI_AitTickCount[MAXPLAYERS + 1];

#include "lj_animation/stateconditions.sp"

state StateTransition(int client, state prevState)
{
	if(IsPlayerTeleported(client))
	{
		return INVALID;
	}
	if(!IsPlayerMovetypeValid(client) || IsPlayerInWater(client))
	{
		if(WasPlayerPrevStateValid(prevState))
		{
			return INVALID;
		}
		else
		{
			return DEFAULT;
		}
	}
	if (IsPlayerOnGround(client))
	{
		if(WasPlayerInAir(prevState))
		{
			return LANDED;
		}
		else
		{
			return PRE;
		}
	}
	else
	{
		if(IsAirMaxTickCountReached(client) || !WasPlayerPrevStateValidForAirState(prevState))
		{
			if(WasPlayerPrevStateValid(prevState))
			{
				return INVALID;
			}
			else
			{
				return DEFAULT;
			}
		}
		else
		{
			return AIR;
		}
	}
}
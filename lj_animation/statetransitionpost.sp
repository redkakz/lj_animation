#include "lj_animation/jumpdata.sp"

void StateTransitionPost(int client, state newState)
{
	switch(newState)
	{
		case DEFAULT:
		{
			
		}
		case PRE:
		{
			SetTickInJumpData(client, newState);
		}
		case AIR:
		{
			IncrementAirTickCount(client);
			SetTickInJumpData(client, newState);
		}
		case LANDED:
		{
			SetTickInJumpData(client, newState);
			
			CorrectLandOrigin(client);
			ProcessJumpData(client);
			
			ResetAirTickCount(client);
			ResetJumpData(client);
		}
		case INVALID:
		{
			ResetAirTickCount(client);
			ResetJumpData(client);
		}
	}
}

void IncrementAirTickCount(int client)
{
	gI_AitTickCount[client] += 1;
}

void ResetAirTickCount(int client)
{
	gI_AitTickCount[client] = 0;
}
void StateTransitionPost(int client)
{
	switch(gState_State[client])
	{
		case DEFAULT:
		{
			
		}
		case PRE:
		{
			SetTickInJumpData(client);
		}
		case AIR:
		{
			IncrementAirTickCount(client);
			SetTickInJumpData(client);
		}
		case LANDED:
		{
			SetTickInJumpData(client);
			
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
state StateTransition(int client)
{
	if(IsPlayerTeleported(client))
	{
		return INVALID;
	}
	if(!IsPlayerMovetypeValid(client) || IsPlayerInWater(client))
	{
		if(WasPlayerPrevStateValid(client))
		{
			return INVALID;
		}
		else
		{
			return DEFAULT;
		}
	}
	if(IsPlayerOnGround(client))
	{
		if(WasPlayerInAir(client))
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
		if(IsAirMaxTickCountReached(client) || !WasPlayerPrevStateValidForAirState(client))
		{
			if(WasPlayerPrevStateValid(client))
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
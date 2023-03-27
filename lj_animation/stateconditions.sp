bool IsPlayerTeleported(int client)
{
	static float gF_prevOrigin[MAXPLAYERS + 1][3];
	
	float origin[3];
	float velocity[3];
	GetClientAbsOrigin(client, origin);
	GetEntPropVector(client, Prop_Data, "m_vecVelocity", velocity);
	
	float expectedOrigin[2];
	expectedOrigin[0] = gF_prevOrigin[client][0] + velocity[0] * GetTickInterval();
	expectedOrigin[1] = gF_prevOrigin[client][1] + velocity[1] * GetTickInterval();

	float difference[3];
	difference[0] = FloatAbs(origin[0] - expectedOrigin[0]);
	difference[1] = FloatAbs(origin[1] - expectedOrigin[1]);
	
	
	gF_prevOrigin[client] = origin;
	
	if((TELEPORT_TOLERANCE < difference[0]) || (TELEPORT_TOLERANCE < difference[1]))
	{
		return true;
	}

	return false;
}

bool IsPlayerMovetypeValid(int client)
{
	return GetEntityMoveType(client) == MOVETYPE_WALK;
}

bool IsPlayerInWater(int client)
{
	return GetEntProp(client, Prop_Data, "m_nWaterLevel") != 0;
}

bool WasPlayerPrevStateValid(state prevState)
{
	return (prevState == PRE) || (prevState == AIR) || (prevState == LANDED);
}

bool IsPlayerOnGround(int client)
{
	return view_as<bool>(GetEntityFlags(client) & FL_ONGROUND);
}

bool WasPlayerInAir(state prevState)
{
	return prevState == AIR;
}

bool IsAirMaxTickCountReached(int client)
{
	return MAX_AIR_TICKCOUNT < gI_AitTickCount[client];
}

bool WasPlayerPrevStateValidForAirState(state prevState)
{
	return (prevState == PRE) || (prevState == AIR);
}
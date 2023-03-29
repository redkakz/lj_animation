bool IsPlayerTeleported(int client)
{
	float origin[3];
	float velocity[3];
	float expectedOrigin[2];
	float difference[2];
	
	GetClientAbsOrigin(client, origin);
	GetEntPropVector(client, Prop_Data, "m_vecVelocity", velocity);
	
	expectedOrigin[0] = gF_prevOrigin[client][0] + velocity[0] * GetTickInterval();
	expectedOrigin[1] = gF_prevOrigin[client][1] + velocity[1] * GetTickInterval();
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

bool WasPlayerPrevStateValid(int client)
{
	return (gState_State[client] == PRE) || (gState_State[client] == AIR) || (gState_State[client] == LANDED);
}

bool IsPlayerOnGround(int client)
{
	return view_as<bool>(GetEntityFlags(client) & FL_ONGROUND);
}

bool WasPlayerInAir(int client)
{
	return gState_State[client] == AIR;
}

bool IsAirMaxTickCountReached(int client)
{
	return MAX_AIR_TICKCOUNT < gI_AitTickCount[client];
}

bool WasPlayerPrevStateValidForAirState(int client)
{
	return (gState_State[client] == PRE) || (gState_State[client] == AIR);
}
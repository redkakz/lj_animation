bool IsJumpValid(int client)
{
	int takeoffOrigin[3];
	int landOrigin[3];
	
	int takeoffDataPosition = TakeoffDataPosition(client);
	
	takeoffOrigin[0] = gI_JumpData[client][takeoffDataPosition][4];
	takeoffOrigin[1] = gI_JumpData[client][takeoffDataPosition][5];
	takeoffOrigin[2] = gI_JumpData[client][takeoffDataPosition][6];
	landOrigin[0] = gI_JumpData[client][gI_DataInsertPosition[client]][4];
	landOrigin[1] = gI_JumpData[client][gI_DataInsertPosition[client]][5];
	landOrigin[2] = gI_JumpData[client][gI_DataInsertPosition[client]][6];

	if(!IsJumpPreSpeedValid(client, takeoffDataPosition))
	{
		return false;
	}

	if(!IsJumpOffsetValid(takeoffOrigin[2], landOrigin[2]))
	{
		return false;
	}
	
	if(!IsJumpMinPreTickCountValid(client))
	{
		return false;
	}

	if(!IsJumpDistanceValid(takeoffOrigin, landOrigin, client))
	{
		return false;
	}

	return true;
}

int TakeoffDataPosition(int client)
{
	int takeoffDataPosition = gI_DataInsertPosition[client];
	
	for(int i = 0; i < MAX_TRACKING_TICKCOUNT; i++)
	{
		takeoffDataPosition--;
		
		if(takeoffDataPosition < 0)
		{
			takeoffDataPosition += MAX_TRACKING_TICKCOUNT;
		}
		
		if(gI_JumpData[client][takeoffDataPosition][0] == view_as<int>(PRE))
		{
			break;
		}
	}
	
	return takeoffDataPosition;
}

bool IsJumpPreSpeedValid(int client, int dataPosition)
{
	float preSpeed = SquareRoot(Pow(IntToFloatWithPrecision(gI_JumpData[client][dataPosition][7]), 2.0)
									+ Pow(IntToFloatWithPrecision(gI_JumpData[client][dataPosition][8]), 2.0));
	
	return preSpeed < MAX_JUMP_PRESPEED;
}

bool IsJumpOffsetValid(int start, int end)
{
	float jumpOffset = FloatAbs(IntToFloatWithPrecision((end - start)));
	
	return jumpOffset < Z_OFFSET_TOLERANCE;
}

bool IsJumpMinPreTickCountValid(int client)
{
	int totalPreTicks;
	
	for(int i = 0; i < MAX_TRACKING_TICKCOUNT; i++)
	{
		if(gI_JumpData[client][i][0] == view_as<int>(PRE))
		{
			totalPreTicks++;
		}
	}
	
	return MIN_PRE_TICKCOUNT < totalPreTicks;
}

bool IsJumpDistanceValid(int start[3], int end[3], int client)
{
	float distance = SquareRoot(Pow((IntToFloatWithPrecision(end[0]) - IntToFloatWithPrecision(start[0])), 2.0)
									+ Pow((IntToFloatWithPrecision(end[1]) - IntToFloatWithPrecision(start[1])), 2.0));
	distance += 32.0;
	
	gI_Distance[client] = RoundToNearest(distance * FLOAT_PRECISION);
	
	return MIN_TRACKING_DISTANCE < distance;
}

float IntToFloatWithPrecision(int integer)
{
	return float(integer) / FLOAT_PRECISION;
}
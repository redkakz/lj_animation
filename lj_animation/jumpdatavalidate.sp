bool IsJumpValid(int client, int jumpData[MAX_TRACKING_TICKCOUNT][10], int dataPosition)
{
	int takeoffDataPosition = TakeoffDataPosition(jumpData, dataPosition);
	
	int takeoffOrigin[3];
	int landOrigin[3];
	takeoffOrigin[0] = jumpData[takeoffDataPosition][4];
	takeoffOrigin[1] = jumpData[takeoffDataPosition][5];
	takeoffOrigin[2] = jumpData[takeoffDataPosition][6];
	landOrigin[0] = jumpData[dataPosition][4];
	landOrigin[1] = jumpData[dataPosition][5];
	landOrigin[2] = jumpData[dataPosition][6];

	if(!IsJumpPreSpeedValid(jumpData, takeoffDataPosition))
	{
		return false;
	}

	if(!IsJumpOffsetValid(takeoffOrigin[2], landOrigin[2]))
	{
		return false;
	}
	
	if(!IsJumpMinPreTickCountValid(jumpData))
	{
		return false;
	}

	if(!IsJumpDistanceValid(takeoffOrigin, landOrigin, client))
	{
		return false;
	}

	return true;
}

int TakeoffDataPosition(int jumpData[MAX_TRACKING_TICKCOUNT][10], int dataPosition)
{
	int takeoffDataPosition = dataPosition;
	
	for(int i = 0; i < MAX_TRACKING_TICKCOUNT; i++)
	{
		takeoffDataPosition--;
		if(takeoffDataPosition < 0)
		{
			takeoffDataPosition += MAX_TRACKING_TICKCOUNT;
		}
		
		if(jumpData[takeoffDataPosition][0] == view_as<int>(PRE))
		{
			break;
		}
	}
	
	return takeoffDataPosition;
}

bool IsJumpPreSpeedValid(int jumpData[MAX_TRACKING_TICKCOUNT][10], int dataPosition)
{
	float preSpeed = SquareRoot(Pow(IntToFloatWithPrecision(jumpData[dataPosition][7]), 2.0)
									+ Pow(IntToFloatWithPrecision(jumpData[dataPosition][8]), 2.0));
	
	return preSpeed < MAX_JUMP_PRESPEED;
}

bool IsJumpOffsetValid(int start, int end)
{
	float jumpOffset = FloatAbs(IntToFloatWithPrecision((end - start)));
	
	return jumpOffset < Z_OFFSET_TOLERANCE;
}

bool IsJumpMinPreTickCountValid(int jumpData[MAX_TRACKING_TICKCOUNT][10])
{
	int totalPreTicks;
	for (int i = 0; i < MAX_TRACKING_TICKCOUNT; i++)
	{
		if(jumpData[i][0] == view_as<int>(PRE))
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
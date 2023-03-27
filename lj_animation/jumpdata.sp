#include <movementapi>

int gI_DataInsertPosition[MAXPLAYERS + 1] = {-1, ...};
int gI_JumpData[MAXPLAYERS + 1][MAX_TRACKING_TICKCOUNT][10];
int gI_Distance[MAXPLAYERS + 1];

#include "lj_animation/jumpdatavalidate.sp"

void SetTickInJumpData(int client, state tickState)
{
	gI_DataInsertPosition[client] = IncrementPosition(gI_DataInsertPosition[client]);
	
	float eyeAngles[3];
	float origin[3];
	float velocity[3];
	
	GetClientEyeAngles(client, eyeAngles);
	GetClientAbsOrigin(client, origin);
	GetEntPropVector(client, Prop_Data, "m_vecVelocity", velocity);
	
	gI_JumpData[client][gI_DataInsertPosition[client]][0] = tickState;
	gI_JumpData[client][gI_DataInsertPosition[client]][1] = GetClientButtons(client);
	gI_JumpData[client][gI_DataInsertPosition[client]][2] = RoundToNearest(eyeAngles[0] * FLOAT_PRECISION);
	gI_JumpData[client][gI_DataInsertPosition[client]][3] = RoundToNearest(eyeAngles[1] * FLOAT_PRECISION);
	gI_JumpData[client][gI_DataInsertPosition[client]][4] = RoundToNearest(origin[0] * FLOAT_PRECISION);
	gI_JumpData[client][gI_DataInsertPosition[client]][5] = RoundToNearest(origin[1] * FLOAT_PRECISION);
	gI_JumpData[client][gI_DataInsertPosition[client]][6] = RoundToNearest(origin[2] * FLOAT_PRECISION);
	gI_JumpData[client][gI_DataInsertPosition[client]][7] = RoundToNearest(velocity[0] * FLOAT_PRECISION);
	gI_JumpData[client][gI_DataInsertPosition[client]][8] = RoundToNearest(velocity[1] * FLOAT_PRECISION);
	gI_JumpData[client][gI_DataInsertPosition[client]][9] = RoundToNearest(velocity[2] * FLOAT_PRECISION);
}

void ResetJumpData(int client)
{
	gI_DataInsertPosition[client] = -1;
	
	for(int i = 0; i < MAX_TRACKING_TICKCOUNT; i++)
	{
		gI_JumpData[client][i][0] = EMPTYTICKSTATE;
		for(int j = 1; j < 10; j++)
		{
			gI_JumpData[client][i][j] = 0;
		} 
	}
	
	gI_Distance[client] = 0;
}

void CorrectLandOrigin(int client)
{
	float origin[3];
	Movement_GetNobugLandingOrigin(client, origin);
	
	gI_JumpData[client][gI_DataInsertPosition[client]][4] = RoundToNearest(origin[0] * FLOAT_PRECISION);
	gI_JumpData[client][gI_DataInsertPosition[client]][5] = RoundToNearest(origin[1] * FLOAT_PRECISION);
	gI_JumpData[client][gI_DataInsertPosition[client]][6] = RoundToNearest(origin[2] * FLOAT_PRECISION);
}

void ProcessJumpData(int client)
{
	if(!IsJumpValid(client, gI_JumpData[client], gI_DataInsertPosition[client]))
	{
		return;
	}
	
	SortJumpData(client);
	
	gI_CurrentAnimationPosition[client] = 1;
}

void SortJumpData(int client)
{
	int sortedPosition = MAX_TRACKING_TICKCOUNT;
	int dataPosition = gI_DataInsertPosition[client] + 1;
	
	for(int i = 0; i < MAX_TRACKING_TICKCOUNT; i++)
	{
		
		sortedPosition = DecrementPosition(sortedPosition);
		dataPosition = DecrementPosition(dataPosition);			
		
		if(gI_JumpData[client][dataPosition][0] == EMPTYTICKSTATE)
		{
			dataPosition = IncrementPosition(dataPosition);
			
			gI_SortedJumpData[client][sortedPosition][0] = gI_JumpData[client][dataPosition][0];
			gI_SortedJumpData[client][sortedPosition][1] = 0;
			gI_SortedJumpData[client][sortedPosition][2] = gI_JumpData[client][dataPosition][2];
			gI_SortedJumpData[client][sortedPosition][3] = gI_JumpData[client][dataPosition][3];
			gI_SortedJumpData[client][sortedPosition][4] = gI_JumpData[client][dataPosition][4]
															- gI_JumpData[client][dataPosition][7] / 128;
			gI_SortedJumpData[client][sortedPosition][5] = gI_JumpData[client][dataPosition][5]
															- gI_JumpData[client][dataPosition][8] / 128;
			gI_SortedJumpData[client][sortedPosition][6] = gI_JumpData[client][dataPosition][6];
			gI_SortedJumpData[client][sortedPosition][7] = 0;
			gI_SortedJumpData[client][sortedPosition][8] = 0;
			gI_SortedJumpData[client][sortedPosition][9] = 0;
		}
		else
		{
			for(int k = 0; k < 10; k++)
			{
				gI_SortedJumpData[client][sortedPosition][k] = gI_JumpData[client][dataPosition][k];
			}
		}
	}
}
int IncrementPosition(int dataPosition)
{
	dataPosition += 1;
	if(dataPosition == MAX_TRACKING_TICKCOUNT)
	{
		dataPosition -= MAX_TRACKING_TICKCOUNT;
	}
	
	return dataPosition;
}

int DecrementPosition(int dataPosition)
{
	dataPosition -= 1;
	if(dataPosition < 0)
	{
		dataPosition = MAX_TRACKING_TICKCOUNT - 1;
	}
	
	return dataPosition;
}
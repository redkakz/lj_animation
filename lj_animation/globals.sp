bool gB_IsMovementApiLibraryExist = false;
int gI_BeamModel;

Handle gH_IsLJAEnabledCookie;
int gI_IsLJAEnabled[MAXPLAYERS + 1];

state gState_State[MAXPLAYERS + 1];
int gI_AitTickCount[MAXPLAYERS + 1];
float gF_prevOrigin[MAXPLAYERS + 1][3];

int gI_DataInsertPosition[MAXPLAYERS + 1] = {-1, ...};
int gI_JumpData[MAXPLAYERS + 1][MAX_TRACKING_TICKCOUNT][10];
int gI_Distance[MAXPLAYERS + 1];
int gI_SortedJumpData[MAXPLAYERS + 1][MAX_TRACKING_TICKCOUNT][10];

bool gB_IsVisible[MAXPLAYERS + 1];
Handle gH_RedrawTimer[MAXPLAYERS + 1];
bool gB_IsAnimationPlaying[MAXPLAYERS + 1];
int gI_CurrentAnimationPosition[MAXPLAYERS + 1] = {1,...};
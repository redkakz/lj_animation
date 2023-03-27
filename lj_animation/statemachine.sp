#include "lj_animation/state.sp"
#include "lj_animation/statetransition.sp"
#include "lj_animation/statetransitionpost.sp"

state gState_State[MAXPLAYERS + 1];

void RunStateMachine(int client)
{
	gState_State[client] = StateTransition(client, gState_State[client]);

	StateTransitionPost(client, gState_State[client]);
}
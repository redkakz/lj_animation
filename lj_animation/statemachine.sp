void RunStateMachine(int client)
{
	gState_State[client] = StateTransition(client);

	StateTransitionPost(client);
}
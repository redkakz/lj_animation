void RegisterCommands()
{
	RegConsoleCmd("sm_lja", CommandToggleAnimation, "[LJA]: Toggle jump animation.");
	RegConsoleCmd("sm_ljamenu", CommandToggleAnimationMenu, "[LJA]: Toggle jump animation menu.");
}

Action CommandToggleAnimation(int client, int args)
{
	gI_IsLJAEnabled[client] = gI_IsLJAEnabled[client] == 0 ? 1 : 0;
	
	if(gI_IsLJAEnabled[client] == 1)
	{
		ReplyToCommand(client, "[LJA]: Jump animation is now enabled.");
		PrintToChat(client, "[LJA]: Jump animation is now enabled.");
	}
	else
	{
		ReplyToCommand(client, "[LJA]: Jump animation is now disabled.");
		PrintToChat(client, "[LJA]: Jump animation is now disabled.");
	}
	
	return Plugin_Handled;
}

Action CommandToggleAnimationMenu(int client, int args)
{
	CreateAnimationMenu(client);
	
	return Plugin_Handled;
}
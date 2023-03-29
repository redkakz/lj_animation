void RegisterCookies()
{
	gH_IsLJAEnabledCookie = RegClientCookie("LJA-cookie", "Cookie to enable/disable Long Jump Animation.", CookieAccess_Private);
}

void LoadLJACookie(int client)
{
	char buffer[2];
	GetClientCookie(client, gH_IsLJAEnabledCookie, buffer, sizeof(buffer));
	
	gI_IsLJAEnabled[client] = StringToInt(buffer);
}

void SaveLJACookie(int client)
{
	char buffer[2];
	IntToString(gI_IsLJAEnabled[client], buffer, sizeof(buffer));
		
	SetClientCookie(client, gH_IsLJAEnabledCookie, buffer);
}
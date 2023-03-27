Database gH_DB;
bool gB_IsLJAEnabledLoaded[MAXPLAYERS + 1];

void SetupDatabase()
{
	char error[512];
	
	gH_DB = SQL_Connect("lj_animation", true, error, sizeof(error));
	
	if (gH_DB == null)
	{
		SetFailState("[LJA]: Database connection failed. Error: \"%s\".", error);
	}
	
	Transaction txn = new Transaction();
	
	txn.AddQuery("CREATE TABLE IF NOT EXISTS IsLJAEnabled ("...
					"SteamID32 INTEGER, "...
					"isEnabled INTEGER)");
	
	gH_DB.Execute(txn, _, SQLTxnFailure_LogError, _, DBPrio_High);
}

void LoadIsLJAEnabled(int client)
{
	int userid = GetClientUserId(client);
	int steamid = GetSteamAccountID(client);
	if (steamid == 0)
	{
		return;
	}
	
	char query[256];
	Transaction txn = new Transaction();
	
	FormatEx(query, sizeof(query), 
				"SELECT isEnabled "...
				"FROM IsLJAEnabled "...
				"WHERE SteamID32 = %d", steamid);
	txn.AddQuery(query);
	
	gH_DB.Execute(txn, SQLTxnSuccess_LoadIsLJAEnabled, SQLTxnFailure_LogError, userid, DBPrio_Normal);
}

void SaveIsLJAEnabled(int client)
{
	int steamid = GetSteamAccountID(client);
	if (steamid == 0 || !gB_IsLJAEnabledLoaded[client])
	{
		return;
	}
	
	char query[1024];
	char buffer[128];
	Transaction txn = new Transaction();
	
	FormatEx(query, sizeof(query), "DELETE FROM IsLJAEnabled WHERE SteamID32 = %d", steamid);
	txn.AddQuery(query);
	
	FormatEx(query, sizeof(query), "INSERT INTO IsLJAEnabled (SteamID32, isEnabled) VALUES ");
	FormatEx(buffer, sizeof(buffer), "(%i,%i)", steamid, gI_IsLJAEnabled[client]);
	StrCat(query, sizeof(query), buffer);
	txn.AddQuery(query);
	
	gH_DB.Execute(txn, _, SQLTxnFailure_LogError, _, DBPrio_Normal);
}

void SQLTxnSuccess_LoadIsLJAEnabled(Database db, int userid, int numQueries, DBResultSet[] results, any[] queryData)
{
	int client = GetClientOfUserId(userid);
	if (client == 0)
	{
		return;
	}
	
	while (results[0].FetchRow())
	{
		gI_IsLJAEnabled[client] = results[0].FetchInt(0);
	}
	
	gB_IsLJAEnabledLoaded[client] = true;
}

void SQLTxnFailure_LogError(Database db, any unused, int numQueries, const char[] error, int failIndex, any[] queryData)
{
	LogError("[LJA]: %s", error);
} 
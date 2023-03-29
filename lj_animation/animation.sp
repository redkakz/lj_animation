int AnimationMenuHandler(Menu menu, MenuAction action, int param1, int param2)
{
	switch(action)
	{
		case MenuAction_Select:
		{
			int client = param1;
    	
			switch(param2)
			{
				case 0:
				{
					gB_IsVisible[client] = !gB_IsVisible[client];
				}
				case 1:
				{
					gB_IsAnimationPlaying[client] = !gB_IsAnimationPlaying[client];
				}
				case 2:
				{
					gB_IsAnimationPlaying[client] = false;
					gI_CurrentAnimationPosition[client] = 1;
				}
				case 3:
				{
					gI_CurrentAnimationPosition[client]
						= (MAX_TRACKING_TICKCOUNT - 1) < (gI_CurrentAnimationPosition[client] + 1)
						? (MAX_TRACKING_TICKCOUNT - 1) : (gI_CurrentAnimationPosition[client] + 1);
				}
				case 4:
				{
					gI_CurrentAnimationPosition[client]
						= (gI_CurrentAnimationPosition[client] - 1) < 1
						? 1 : (gI_CurrentAnimationPosition[client] - 1);
				}
    		}
    		
			delete gH_RedrawTimer[client];
	
			if(gB_IsVisible[client])
			{
				gH_RedrawTimer[client]
					= CreateTimer(0.4, AnimationTimer, GetClientUserId(client), TIMER_REPEAT);
			}
			
			CreateAnimationMenu(client);
		}
		case MenuAction_End:
		{
			delete menu;
		}
	}
	
	return 0;
}

Action AnimationTimer(Handle timer, int userid)
{
	int client = GetClientOfUserId(userid);
	
	DrawPositionLines(client);
	
	if((gI_CurrentAnimationPosition[client] + 1) !=MAX_TRACKING_TICKCOUNT)
	{
		DrawAnimatedLines(client);
		
		if(gB_IsAnimationPlaying[client])
		{
			gI_CurrentAnimationPosition[client]
				= (MAX_TRACKING_TICKCOUNT - 2) < (gI_CurrentAnimationPosition[client] + 1)
				? 1 : gI_CurrentAnimationPosition[client] + 1;
				
			DrawAnimatedLines(client);
		}
	}

	return Plugin_Continue;
}

void DrawPositionLines(int client)
{
	int color[4];
	float start[3];
	float end[3];
	start[2] = float(gI_SortedJumpData[client][0][6]) / FLOAT_PRECISION + 1;
	end[2] = float(gI_SortedJumpData[client][0][6]) / FLOAT_PRECISION + 1;
	
	for (int i = 1; i < (MAX_TRACKING_TICKCOUNT - 1); i++)
	{
		color = i < (MAX_PRE_TICKCOUNT + 1) ? ANIMATION_PRE_LINE_COLOR : ANIMATION_AIR_LINE_COLOR;
		
		start[0] = float(gI_SortedJumpData[client][i][4]) / FLOAT_PRECISION;
		start[1] = float(gI_SortedJumpData[client][i][5]) / FLOAT_PRECISION;
		end[0] = float(gI_SortedJumpData[client][i+1][4]) / FLOAT_PRECISION;
		end[1] = float(gI_SortedJumpData[client][i+1][5]) / FLOAT_PRECISION;
		
		TE_SetupBeamPoints(start, end, gI_BeamModel, 0, 0, 0, 0.4, 0.2, 0.2, 0, 0.0, color, 0);
		TE_SendToAll();
	}
}

void DrawAnimatedLines(int client)
{
	float start[3];
	float temp[3];
	float end[3];
	
	float eyeAngle;
	
	int buttons;
	int buttonForward;
	int buttonBack;
	int buttonLeft;
	int buttonRight;
	int numberOfButtonsPressed;
	int buttonEndArray[4][2];
	int buttonEndArrayLength;
	
	// velocity
	start[0] = float(gI_SortedJumpData[client][gI_CurrentAnimationPosition[client]][4]) / FLOAT_PRECISION;
	start[1] = float(gI_SortedJumpData[client][gI_CurrentAnimationPosition[client]][5]) / FLOAT_PRECISION;
	start[2] = float(gI_SortedJumpData[client][0][6]) / FLOAT_PRECISION + 1.01;
	temp[0] = start[0] + float(gI_SortedJumpData[client][(gI_CurrentAnimationPosition[client] - 1 < 0)
									? 0 : (gI_CurrentAnimationPosition[client] - 1)][4]) / FLOAT_PRECISION * -1;
	temp[1] = start[1] + float(gI_SortedJumpData[client][(gI_CurrentAnimationPosition[client] - 1 < 0)
									? 0 : (gI_CurrentAnimationPosition[client] - 1)][5]) / FLOAT_PRECISION * -1;							
	end[0] = start[0] + temp[0] * 40;
	end[1] = start[1] + temp[1] * 40;
	end[2] = float(gI_SortedJumpData[client][0][6]) / FLOAT_PRECISION + 1.01;
		
	TE_SetupBeamPoints(start, end, gI_BeamModel, 0, 0, 0, 0.4, 0.2, 0.2, 0, 0.0, ANIMATION_VEL_LINE_COLOR, 0);
	TE_SendToAll();
	
	// eye
	eyeAngle = float(gI_SortedJumpData[client][gI_CurrentAnimationPosition[client] + 1][3]) / FLOAT_PRECISION;
		
	temp[0] = Cosine(eyeAngle * (PI / 180));
	temp[1] = Sine(eyeAngle * (PI / 180));
	end[0] = start[0] + temp[0] * 80;
	end[1] = start[1] + temp[1] * 80;
		
	TE_SetupBeamPoints(start, end, gI_BeamModel, 0, 0, 0, 0.4, 0.2, 0.2, 0, 0.0, ANIMATION_EYE_LINE_COLOR, 0);
	TE_SendToAll();
	
	// buttons
	buttons = gI_SortedJumpData[client][(gI_CurrentAnimationPosition[client] + 1)][1];
	buttonForward = buttons & IN_FORWARD == 0 ? 0 : 1;
	buttonBack = buttons & IN_BACK == 0 ? 0 : 1;
	buttonLeft = buttons & IN_MOVELEFT == 0 ? 0 : 1;
	buttonRight = buttons & IN_MOVERIGHT == 0 ? 0 : 1;
	
	numberOfButtonsPressed = buttonForward + buttonBack + buttonLeft + buttonRight;

	switch(numberOfButtonsPressed)
	{
		case 4:
		{
			buttonEndArray[0] = FORWARDENDPOINT;
			buttonEndArray[1] = RIGHTENDPOINT;
			buttonEndArray[2] = BACKENDPOINT;
			buttonEndArray[3] = LEFTENDPOINT;
			
			buttonEndArrayLength = 4;
		}
		case 3:
		{
			if(buttonBack == 0)
			{
				buttonEndArray[0] = FORWARDLEFTENDPOINT;
				buttonEndArray[1] = FORWARDRIGHTENDPOINT;
			}
			else if(buttonLeft == 0)
			{
				buttonEndArray[0] = FORWARDRIGHTENDPOINT;
				buttonEndArray[1] = BACKRIGHTENDPOINT;
			}
			else if(buttonForward == 0)
			{
				buttonEndArray[0] = BACKRIGHTENDPOINT;
				buttonEndArray[1] = BACKLEFTENDPOINT;
			}
			else if(buttonRight == 0)
			{
				buttonEndArray[0] = FORWARDLEFTENDPOINT;
				buttonEndArray[1] = BACKLEFTENDPOINT;
			}
			
			buttonEndArrayLength = 2;
		}
		case 2:
		{
			if(buttonLeft == 1 && buttonRight == 1)
			{
				buttonEndArray[0] = LEFTENDPOINT;
				buttonEndArray[1] = RIGHTENDPOINT;
				
				buttonEndArrayLength = 2;
			}
			else if(buttonLeft == 1 && buttonForward == 1)
			{
				buttonEndArray[0] = FORWARDLEFTENDPOINT;
			}
			else if(buttonRight == 1 && buttonForward == 1)
			{
				buttonEndArray[0] = FORWARDRIGHTENDPOINT;
			}
			else if(buttonRight == 1 && buttonBack == 1)
			{
				buttonEndArray[0] = BACKRIGHTENDPOINT;
			}
			else if(buttonLeft == 1 && buttonBack == 1)
			{
				buttonEndArray[0] = BACKLEFTENDPOINT;
			}
			
			buttonEndArrayLength = 1;
		}
		case 1:
		{
			if(buttonForward == 1)
			{
				buttonEndArray[0] = FORWARDENDPOINT;
			}
			else if(buttonRight == 1)
			{
				buttonEndArray[0] = RIGHTENDPOINT;
			}
			else if(buttonBack == 1)
			{
				buttonEndArray[0] = BACKENDPOINT;
			}
			else if(buttonLeft)
			{
				buttonEndArray[0] = LEFTENDPOINT;
			}
			
			buttonEndArrayLength = 1;
		}
		default:
		{
			buttonEndArrayLength = 0;
		}
	}
	
	for(int i = 0; i < buttonEndArrayLength; i++)
	{
		float buttonEndRotated[2];
		float buttonEnd[3];

		buttonEndRotated[0] = temp[0] * buttonEndArray[i][0] - temp[1] * buttonEndArray[i][1];
		buttonEndRotated[1] = temp[1] * buttonEndArray[i][0] + temp[0] * buttonEndArray[i][1];
		buttonEnd[0] = start[0] + buttonEndRotated[0] * 16;
		buttonEnd[1] = start[1] + buttonEndRotated[1] * 16;
		buttonEnd[2] = end[2];
		
		TE_SetupBeamPoints(start, buttonEnd, gI_BeamModel, 0, 0, 0, 0.4, 0.2, 0.2, 0, 0.0, ANIMATION_BUTTONS_LINE_COLOR, 0);
		TE_SendToAll();
    }
}

void CreateAnimationMenu(int client)
{
	Menu menu;
	menu = new Menu(AnimationMenuHandler);
	menu.SetTitle("Long Jump Animation %s\n%s", LJA_VERSION, LJA_SOURCE_URL);
	menu.AddItem("1", gB_IsVisible[client] ? "Hide" : "Show");
	menu.AddItem("2", gB_IsAnimationPlaying[client] ? "Pause" : "Play");
	menu.AddItem("2", "Stop");
	menu.AddItem("4", "Step forward");
	menu.AddItem("5", "Step backward");
	menu.ExitButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

void ResetAnimation(int client)
{
	delete gH_RedrawTimer[client];
	
	gB_IsVisible[client] = false;
	gB_IsAnimationPlaying[client] = false;
	gI_CurrentAnimationPosition[client] = 1;
	
	for(int i = 0; i < MAX_TRACKING_TICKCOUNT; i++)
	{
		gI_SortedJumpData[client][i][0] = EMPTYTICKSTATE;
		for(int j = 1; j < 10; j++)
		{
			gI_SortedJumpData[client][i][j] = 0;
		} 
	}
}
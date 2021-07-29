local t = Def.ActorFrame{};
local key_open = 0;

--20160417
t[#t+1] = Def.ActorFrame{
	SelectNMessageCommand=function(self)
		(cmd(stoptweening;linear,0.5;queuecommand,"NextScreen"))(self)
		SOUND:PlayOnce(THEME:GetPathS("Common","start"));
	end;
	NextScreenCommand=function(self)
		SCREENMAN:SetNewScreen("ScreenOptionsService");
	end;
	
	Def.Quad{
		SelectNMessageCommand=cmd(Center;diffuse,color("0,1,1,0.4");zoomtowidth,SCREEN_WIDTH;zoomtoheight,0;fadetop,0.2;fadebottom,0.2;
				decelerate,0.2;fadetop,0;fadebottom,0;zoomtoheight,SCREEN_HEIGHT;linear,0.2;diffuse,color("0,0,0,0"););
	};

	Def.Quad{
		SelectNMessageCommand=cmd(diffuse,color("0,0,0,0");x,SCREEN_CENTER_X;y,SCREEN_TOP;vertalign,top;zoomtowidth,SCREEN_WIDTH;zoomtoheight,0;
				accelerate,0.2;diffuse,color("0,0,0,1");zoomtowidth,SCREEN_WIDTH;zoomtoheight,SCREEN_HEIGHT/2+10);
	};

	Def.Quad{
		SelectNMessageCommand=cmd(diffuse,color("0,0,0,0");x,SCREEN_CENTER_X;y,SCREEN_BOTTOM;vertalign,bottom;zoomtowidth,SCREEN_WIDTH;zoomtoheight,0;
				accelerate,0.2;diffuse,color("0,0,0,1");zoomtowidth,SCREEN_WIDTH;zoomtoheight,SCREEN_HEIGHT/2+10);
	};
};

function inputs(event)
	local button = event.GameButton
	if key_open == 0 then
		if event.type == "InputEventType_FirstPress" then
			if button == 'Start' or button == 'Center' then
				key_open = 1;
				MESSAGEMAN:Broadcast("SelectN");
			end;
		end;
	end;
end;

t[#t+1] = Def.ActorFrame {
	OnCommand=function(self)
		SCREENMAN:GetTopScreen():lockinput(0.5);
		SCREENMAN:GetTopScreen():AddInputCallback(inputs);
	end;
};


return t;
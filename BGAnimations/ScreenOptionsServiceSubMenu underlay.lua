
local t = Def.ActorFrame {
};

function focus(ci,i)
	if ci == i then
		return "GainFocus";
	end;
	return "LoseFocus";
end;

local setop_t = {};
if getenv("opst")[1] == "IC" then
	setop_t = {
		{ name = "Config Key/Joy Mappings" , screen = "ScreenMapControllers" },
		{ name = "Input/Sound Options" , screen = "ScreenSoundOptions" },
		{ name = "Calibrate Machine Sync" , screen = "ScreenGameplaySyncMachine" },
		{ name = "Test Input" , screen = "ScreenTestInput" }
	};
elseif getenv("opst")[1] == "DB" then
	setop_t = {
		{ name = "Display Options" , screen = "ScreenGraphicOptions" },
		{ name = "Background Options" , screen = "ScreenBackgroundOptions" },
		{ name = "Set BG Fit Mode" , screen = "ScreenSetBGFit" }
	};
elseif getenv("opst")[1] == "GJ" then
	setop_t = {
		{ name = "Coin Options" , screen = "ScreenCoinOptions" },
		{ name = "Gameplay Options" , screen = "ScreenGameplayOptions" },
		{ name = "Life/Judge Options" , screen = "ScreenMachineOptions" },
		{ name = "Section/Unlock Options" , screen = "ScreenSectionOptions" }
	};
elseif getenv("opst")[1] == "SC" then
	setop_t = {
		{ name = "Credits (Normal)" , screen = "ScreenTiCredits" },
		{ name = "Credits (Special)" , screen = "ScreenTTTiCredits" }
	};
end;
setop_t[#setop_t+1] = { name = "Exit" , screen = "ScreenOptionsService" };

local xy_set = {SCREEN_CENTER_X-200,SCREEN_CENTER_Y-36};
local stop = false;
local key_open = 0;
local curIndex = 1;

--back/misc
t[#t+1] = Def.Quad{
	InitCommand=cmd(Center;zoomto,SCREEN_WIDTH,SCREEN_HEIGHT;diffuse,color("0,0.2,0.2,0.65"););
	OnCommand=cmd(diffusealpha,0;decelerate,0.15;diffusealpha,0.65;);
	KResetMessageCommand=cmd(stoptweening;diffusealpha,0.65;sleep,0.3;linear,0.2;diffusealpha,0;);
};

local hlight_y = xy_set[2]+2;
t[#t+1] = Def.ActorFrame {
	InitCommand=cmd(visible,true;);
	
	Def.Quad{
		InitCommand=cmd(x,xy_set[1]-60;y,xy_set[2]+(28*(#setop_t/2))-20;horizalign,left;zoomto,640,(28*#setop_t)+60;
					diffuse,color("0,0,0,0.65");fadeleft,0.065;faderight,0.065;);
		OnCommand=cmd(diffusealpha,0.65;cropleft,1;decelerate,0.15;cropleft,0;);
		KResetMessageCommand=cmd(finishtweening;sleep,0.1;accelerate,0.2;zoomtoheight,SCREEN_HEIGHT;diffusealpha,0;);
	};
	LoadActor(THEME:GetPathG("_options","line highlight"))..{
		InitCommand=cmd(x,SCREEN_CENTER_X;y,hlight_y;diffusealpha,0.6;);
		OnCommand=cmd(croptop,1;decelerate,0.15;croptop,0;);
		DirectionButtonMessageCommand=function(self)
			self:finishtweening();
			if setop_t[curIndex].name == "Exit" then
				(THEME:GetMetric("ScreenOptions","LineHighlightP1ChangeToExitCommand"))(self);
			else (THEME:GetMetric("ScreenOptions","LineHighlightP1ChangeCommand"))(self);
			end;
			self:y(hlight_y+((curIndex-1)*28));
		end;
		KResetMessageCommand=cmd(stoptweening;decelerate,0.25;zoomy,0;);
	};
};

--OptionExplanations
t[#t+1] = Def.ActorFrame {
	Def.Quad{
		InitCommand=cmd(x,SCREEN_CENTER_X;
					y,THEME:GetMetric("ScreenOptionsSimple","ExplanationTogetherY");
					zoomtowidth,760;diffuse,color("0,0,0,0.65");fadeleft,0.05;faderight,0.05;);
		OnCommand=cmd(diffusealpha,0;zoomtoheight,0;accelerate,0.075;diffusealpha,0.65;zoomtoheight,60;);
		KResetMessageCommand=cmd(stoptweening;sleep,0.1;decelerate,0.1;zoomtoheight,0;);
	};
	LoadFont("_shared4") .. {
		InitCommand=cmd(x,THEME:GetMetric("ScreenOptionsSimple","ExplanationTogetherX");
					y,THEME:GetMetric("ScreenOptionsSimple","ExplanationTogetherY"););
		OnCommand=function(self)
			self:stoptweening();
			self:settext(THEME:GetString("OptionExplanations",setop_t[curIndex].name));
			(THEME:GetMetric("ScreenOptionsSimple","ExplanationTogetherOnCommand"))(self);
		end;
		DirectionButtonMessageCommand=cmd(playcommand,"On";);
		KResetMessageCommand=cmd(stoptweening;cropleft,0;decelerate,0.15;cropleft,1;);
	};
};

--OptionRowExit
t[#t+1] = Def.ActorFrame {
	InitCommand=cmd(x,SCREEN_CENTER_X;y,xy_set[2]+2+(28*(#setop_t-1)));
	KResetMessageCommand=cmd(stoptweening;zoomy,1;sleep,0.1;accelerate,0.05;zoomy,0;);
	LoadActor(THEME:GetPathG("OptionRowExit","frame/_triangle"))..{
		InitCommand=cmd(blend,Blend.Add;x,-38;diffuseblink;effectcolor1,color("0.6,0.6,0.6,1");effectperiod,0.4;effectoffset,0.2;effectclock,"beat");
		ExitSelectedMessageCommand=cmd(stoptweening;linear,0.15;rotationz,-90);
		ExitUnSelectedMessageCommand=cmd(stoptweening;linear,0.15;rotationz,0);
	};
	LoadActor(THEME:GetPathG("OptionRowExit","frame/_triangle"))..{
		InitCommand=cmd(blend,Blend.Add;x,38;diffuseblink;effectcolor1,color("0.6,0.6,0.6,1");effectperiod,0.4;effectoffset,0.2;effectclock,"beat");
		ExitSelectedMessageCommand=cmd(stoptweening;linear,0.15;rotationz,90);
		ExitUnSelectedMessageCommand=cmd(stoptweening;linear,0.15;rotationz,0);
	};
	LoadActor(THEME:GetPathG("OptionRowExit","frame/moreexit"))..{
		InitCommand=cmd(y,-19;croptop,0.57;cropbottom,.1);
		OnCommand=cmd(playcommand,"ExitUnSelected";);
		ExitSelectedMessageCommand=cmd(stoptweening;linear,0.15;y,-16;croptop,0.57;cropbottom,0.1);
		ExitUnSelectedMessageCommand=cmd(stoptweening;linear,0.15;y,16;croptop,0.07;cropbottom,0.6);
	};
};

--OptionRow
for idx, cat in pairs(setop_t) do
	local Cname = cat.name;
	if Cname ~= "Exit" then
		t[#t+1] = LoadActor(THEME:GetPathG("OptionRow","Frame/highlight")) .. {
			InitCommand=cmd(x,xy_set[1]-22-54;y,(xy_set[2])+2+(28*(idx-1)););
			OnCommand=cmd(playcommand,focus(curIndex,idx););
			DirectionButtonMessageCommand=cmd(playcommand,focus(curIndex,idx););
			GainFocusCommand=cmd(stoptweening;diffuse,color("1,0.8,1,1"));
			LoseFocusCommand=cmd(stoptweening;decelerate,0.1;diffuse,color("0,0,0,0");stopeffect;);
			KResetMessageCommand=cmd(stoptweening;cropleft,0;accelerate,0.2;cropleft,1;);
		};
		t[#t+1] = Def.ActorFrame {
			InitCommand=cmd(x,xy_set[1]-22;y,(xy_set[2])+2+(28*(idx-1)););
			LoadActor(THEME:GetPathG("OptionRow","Frame/bullet1")) .. {
				InitCommand=cmd(shadowlength,2;);
				OnCommand=cmd(playcommand,focus(curIndex,idx););
				DirectionButtonMessageCommand=cmd(playcommand,focus(curIndex,idx););
				GainFocusCommand=cmd(stoptweening;zoom,1.15;decelerate,0.2;glow,color("1,0.4,0,0.9"););
				LoseFocusCommand=cmd(stoptweening;decelerate,0.2;zoom,1;glow,color("0,0.4,0.4,0.3");stopeffect;);
				KResetMessageCommand=cmd(stoptweening;glow,color("0,0,0,0");diffusealpha,1;linear,0.15;diffusealpha,0;);
			};
			LoadActor(THEME:GetPathG("OptionRow","Frame/bullet2")) .. {
				OnCommand=cmd(playcommand,focus(curIndex,idx););
				DirectionButtonMessageCommand=cmd(playcommand,focus(curIndex,idx););
				GainFocusCommand=cmd(stoptweening;decelerate,0.2;diffusealpha,1;);
				LoseFocusCommand=cmd(stoptweening;decelerate,0.2;diffusealpha,0.3;);
				KResetMessageCommand=cmd(stoptweening;diffusealpha,1;linear,0.25;diffusealpha,0;);
			};
		};
	end;

	t[#t+1] = Def.ActorFrame {
		InitCommand=cmd(x,xy_set[1];y,(xy_set[2])+(28*(idx-1)););
		LoadFont("_shared4") .. {
			Text= THEME:GetString("OptionTitles",Cname);
			InitCommand=cmd(horizalign,left;stoptweening;zoomx,0.825;zoomy,0.75;diffuse,color("0.7,0.7,0.7,1");
						strokecolor,ColorDarkTone(color("0,1,1,0.5"));cropright,0;stopeffect;);
			OnCommand=function(self)
				(THEME:GetMetric("OptionRowService","Title"..focus(curIndex,idx).."Command"))(self);
			end;
			DirectionButtonMessageCommand=cmd(playcommand,"On";);
			KResetMessageCommand=cmd(stoptweening;cropleft,0;decelerate,0.3;cropleft,1;);
		};
	};
end;

--20160417
function inputs(event)
	local button = event.GameButton
	if key_open == 0 then
		if button == 'MenuUp' or button == 'MenuLeft' then
			stop = true;
			if curIndex > 1 then
				if event.type ~= "InputEventType_Release" then
					curIndex = curIndex - 1;
					MESSAGEMAN:Broadcast("DirectionButton");
					SOUND:PlayOnce(THEME:GetPathS("_common","value"));
				end;
			else
				if stop == true and event.type == "InputEventType_FirstPress" then
					curIndex = #setop_t;
					MESSAGEMAN:Broadcast("DirectionButton");
					SOUND:PlayOnce(THEME:GetPathS("_common","value"));
				end;
			end;
		end;
		if button == 'MenuDown' or button == 'MenuRight' then
			stop = true;
			if curIndex < #setop_t then
				if curIndex > 0 then
					if event.type ~= "InputEventType_Release" then
						curIndex = curIndex + 1;
						MESSAGEMAN:Broadcast("DirectionButton");
						SOUND:PlayOnce(THEME:GetPathS("_common","row"));
					end;
					if curIndex == #setop_t then
						stop = false;
					end;
				end;
			else
				if stop == true and event.type == "InputEventType_FirstPress" then
					curIndex = 1;
					MESSAGEMAN:Broadcast("DirectionButton");
					SOUND:PlayOnce(THEME:GetPathS("_common","row"));
				end;
			end;
		end;
		if event.type == "InputEventType_FirstPress" then
			if button == 'Start' or button == 'Center' then
				key_open = 1;
				MESSAGEMAN:Broadcast("StartButton");
				if curIndex < #setop_t then
					MESSAGEMAN:Broadcast("KOpen");	
					setenv("opst",{getenv("opst")[1],setop_t[curIndex].screen});
				else MESSAGEMAN:Broadcast("KReset");
				end;
				SOUND:PlayOnce(THEME:GetPathS("Common","start"));
				local s_count = 0;
				if curIndex == #setop_t then
					s_count = 1;
				end;
				SCREENMAN:GetTopScreen():PostScreenMessage('SM_GoToPrevScreen',s_count);
			end;
			if button == "Back" then
				key_open = 1;
				SOUND:PlayOnce(THEME:GetPathS("_Screen","cancel"));
				SCREENMAN:GetTopScreen():PostScreenMessage('SM_GoToPrevScreen',1);
				MESSAGEMAN:Broadcast("KReset");
			end;
		end;
		if setop_t[curIndex].name == "Exit" then
			MESSAGEMAN:Broadcast("ExitSelected");
		else MESSAGEMAN:Broadcast("ExitUnSelected");
		end;
		--SCREENMAN:SystemMessage(getenv("opst")[1].." : "..getenv("opst")[2]);
	end;
end;
t[#t+1] = Def.ActorFrame {
	OnCommand=function(self)
		SCREENMAN:GetTopScreen():lockinput(0.5);
		SCREENMAN:GetTopScreen():AddInputCallback(inputs);
	end;
};

t.OnCommand=function(self)
	SOUND:PlayOnce(THEME:GetPathS("","_prompt"));
	--SCREENMAN:SystemMessage(getenv("opst")[1].." : "..getenv("opst")[2]);
end;

return t;
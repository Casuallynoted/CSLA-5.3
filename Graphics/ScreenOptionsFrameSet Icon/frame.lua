local co,setname = ...
assert(co,"Must pass in a player, dingus");
assert(setname,"Must pass in a player, dingus");
local name = Var("GameCommand"):GetName();

local setx,zoomxset,setaddx,afteraddx,pn = THEME:GetMetric("ScreenGameplay","PlayerP1TwoPlayersTwoSidesX")-11,1,-100,100,PLAYER_1;
if co == 2 then setx,zoomxset,setaddx,afteraddx,pn = THEME:GetMetric("ScreenGameplay","PlayerP2TwoPlayersTwoSidesX")+11,-1,100,-100,PLAYER_2;
end;
local meterwidth = math.min(216,WideScale(213,216));
local meterheight = 14;

local t = Def.ActorFrame{};

if co == 1 then
	t[#t+1] = LoadActor(THEME:GetPathG("","GameFSet/Life/"..setname.."_LifeFrame/stageframe"))..{
		InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_TOP+30+80;);
		GainFocusCommand=cmd(addy,-30;decelerate,0.15;addy,30;glow,color("1,0.5,0,0");linear,0.025;glow,color("1,0.5,0,1");linear,0.2;glow,color("1,0.5,0,0"););
	};
	
	t[#t+1] = LoadActor(THEME:GetPathG("","GameFSet/Score/"..setname.."_ScoreFrame/bannerframe"))..{
		InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_BOTTOM-25-80;);
		GainFocusCommand=cmd(addy,30;decelerate,0.15;addy,-30;glow,color("1,0.5,0,0");linear,0.025;glow,color("1,0.5,0,1");linear,0.2;glow,color("1,0.5,0,0"););
	};
end;

--lifeframe
t[#t+1] = Def.ActorFrame{
	InitCommand=cmd(y,SCREEN_TOP+28+80);
	
	LoadActor(THEME:GetPathG("","GameFSet/Life/"..setname.."_LifeFrame/lifeframe_left_frame"))..{
		InitCommand=cmd(x,setx;zoomx,zoomxset;);
		GainFocusCommand=cmd(diffusealpha,0;addx,setaddx;sleep,0.1;accelerate,0.1;diffusealpha,1;addx,afteraddx;
					glow,color("1,1,0,0");linear,0.025;glow,color("1,1,0,1");linear,0.2;glow,color("1,1,0,0"););
	};
	
	Def.ActorFrame{
		InitCommand=function(self)
			if co == 1 then
				(cmd(x,setx-106;y,3;skewx,1))(self)
			else (cmd(x,setx+106;y,3;skewx,-1))(self)
			end;
		end;
		Def.Quad{
			Name="Meterback";
			InitCommand=function(self)
				if co == 1 then
					self:horizalign(left);
				else self:horizalign(right);
				end;
				(cmd(zoomto,meterwidth,meterheight;))(self)
			end;
			OnCommand=cmd(diffuse,color("0,0,0,0.6"););
		};
		GainFocusCommand=cmd(zoomx,0;sleep,0.4;linear,0.1;zoomx,1;);
	};

	LoadActor(THEME:GetPathG("","GameFSet/Life/"..setname.."_LifeFrame/lifeframe_life_frame"))..{
		InitCommand=cmd(x,setx;zoomx,zoomxset;);
		GainFocusCommand=cmd(diffusealpha,0;addy,20;sleep,0.2;decelerate,0.15;diffusealpha,1;addy,-20;
					glow,color("1,0.7,0,0");linear,0.025;glow,color("1,0.7,0,1");linear,0.2;glow,color("1,0.7,0,0"););
	};

	LoadActor(THEME:GetPathG("","GameFSet/Life/"..setname.."_LifeFrame/lifeframe_right_frame"))..{
		InitCommand=function(self)
			if co == 1 then
				(cmd(x,SCREEN_CENTER_X-182;zoomx,zoomxset;))(self)
			else (cmd(x,SCREEN_CENTER_X+182;zoomx,zoomxset;))(self)
			end;
		end;
		GainFocusCommand=cmd(cropleft,1;zoomy,2;sleep,0.25;accelerate,0.1;cropleft,0;zoomy,1;
					glow,color("1,0.5,0,0");linear,0.025;glow,color("1,0.5,0,1");linear,0.2;glow,color("1,0.5,0,0"););
	};
	
	LoadActor(THEME:GetPathG("","GameFSet/Life/p"..co.."_left_lamp"))..{
		InitCommand=function(self)
			if co == 1 then
				(cmd(x,setx-121;y,2;zoomx,zoomxset;))(self)
			else (cmd(x,setx+121;y,2;zoomx,zoomxset;))(self)
			end;
		end;
		GainFocusCommand=cmd(diffusealpha,0;sleep,0.4;linear,0.1;diffusealpha,1;glow,color("0,1,1,0");queuecommand,"Repeat";);
		RepeatCommand=cmd(glow,PlayerColor(pn);linear,0.5;glow,color("0,1,1,0");sleep,2;queuecommand,"Repeat";);
	};
	
	LoadActor(THEME:GetPathG("","GameFSet/Life/p"..co.."_right_lamp"))..{
		InitCommand=function(self)
			if co == 1 then
				(cmd(x,SCREEN_CENTER_X-65;y,-4;zoomx,zoomxset;))(self)
			else (cmd(x,SCREEN_CENTER_X+65;y,-4;zoomx,zoomxset;))(self)
			end;
		end;
		GainFocusCommand=cmd(diffusealpha,0;sleep,0.4;linear,0.1;diffusealpha,1;glow,color("0,1,1,0");queuecommand,"Repeat";);
		RepeatCommand=cmd(glow,PlayerColor(pn);linear,0.5;glow,color("0,1,1,0");sleep,2;queuecommand,"Repeat";);
	};
};

--scoreframe
t[#t+1] = Def.ActorFrame{
	InitCommand=cmd(y,SCREEN_BOTTOM-28-80);
	LoadActor(THEME:GetPathG("","GameFSet/Score/"..setname.."_ScoreFrame/scoreframe_left_frame"))..{
		InitCommand=cmd(x,setx;zoomx,zoomxset;y,3;);
		GainFocusCommand=cmd(diffusealpha,0;addx,setaddx;decelerate,0.15;diffusealpha,1;addx,afteraddx;
					glow,color("1,1,0,0");linear,0.025;glow,color("1,1,0,1");linear,0.2;glow,color("1,1,0,0"););
	};

	LoadActor(THEME:GetPathG("","GameFSet/Score/"..setname.."_ScoreFrame/scoreframe_right_frame"))..{
		InitCommand=function(self)
			if co == 1 then
				(cmd(x,SCREEN_CENTER_X-176;y,3;zoomx,zoomxset;))(self)
			else (cmd(x,SCREEN_CENTER_X+176;y,3;zoomx,zoomxset;))(self)
			end;
		end;
		GainFocusCommand=cmd(cropleft,1;zoomy,2;sleep,0.15;decelerate,0.2;cropleft,0;zoomy,1;
					glow,color("1,0.5,0,0");linear,0.025;glow,color("1,0.5,0,1");linear,0.2;glow,color("1,0.5,0,0"););
	};
	
	LoadActor(THEME:GetPathG("","GameFSet/Score/"..setname.."_ScoreFrame/bpmframe"))..{
		InitCommand=function(self)
			if co == 1 then
				(cmd(x,SCREEN_CENTER_X-114;y,17;zoomx,zoomxset;))(self)
			else (cmd(x,SCREEN_CENTER_X+114;y,17;zoomx,zoomxset;))(self)
			end;
		end;
		GainFocusCommand=cmd(cropleft,1;sleep,0.1;decelerate,0.1;cropleft,0;glow,color("1,0.5,0,0");linear,0.025;glow,color("1,0.5,0,1");linear,0.2;glow,color("1,0.5,0,0"););
	};

	LoadActor(THEME:GetPathG("","GameFSet/Score/p"..co.."_left_lamp"))..{
		InitCommand=function(self)
			if co == 1 then
				(cmd(x,setx-127;y,-4;zoomx,zoomxset;))(self)
			else (cmd(x,setx+127;y,-4;zoomx,zoomxset;))(self)
			end;
		end;
		GainFocusCommand=cmd(diffusealpha,0;sleep,0.4;linear,0.1;diffusealpha,1;glow,color("0,1,1,0");queuecommand,"Repeat";);
		RepeatCommand=cmd(glow,PlayerColor(pn);linear,0.5;glow,color("0,1,1,0");sleep,2;queuecommand,"Repeat";);
	};
};


--t.InitCommand=cmd(SetUpdateFunction,update;);
t.GainFocusCommand=cmd(visible,true;);
t.LoseFocusCommand=cmd(finishtweening;visible,false;);

return t;

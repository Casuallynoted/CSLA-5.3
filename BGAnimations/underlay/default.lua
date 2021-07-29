--[[underlay]]

local t = Def.ActorFrame {};

local HTitle = getenv("htitle");
--SCREENMAN:SystemMessage(tostring(HTitle));
local sixset = "";

if tobool(GetAdhocPref("CSLAEasterEggs")) == true and ((HTitle and GetAdhocPref("FrameSet") == "Cs1") or cs1md) then
	t[#t+1] = LoadActor(THEME:GetPathB("ScreenSelectMusicCS","background/cs_o"))..{
		InitCommand=cmd(horizalign,left;x,SCREEN_LEFT;y,SCREEN_CENTER_Y;faderight,0.2;queuecommand,"Set";);
		SetCommand=cmd(diffuse,color("0,1,1,0");sleep,0.5;linear,0.3;diffuse,color("0,1,1,0.6"););
	};

	t[#t+1] = Def.ActorFrame{
		Def.ActorFrame{
			InitCommand=cmd(y,SCREEN_BOTTOM;);
			LoadActor("1/under_back_sp")..{
				InitCommand=cmd(horizalign,right;vertalign,bottom;x,SCREEN_RIGHT;zoomtowidth,WideScale(0,214);queuecommand,"Set";);
				SetCommand=cmd(addx,-100;addy,100;decelerate,0.5;;addx,100;addy,-100;);
			};
			LoadActor("1/under_back_bl")..{
				InitCommand=cmd(horizalign,left;vertalign,bottom;x,SCREEN_LEFT;queuecommand,"Set";);
				SetCommand=cmd(addx,-100;addy,100;decelerate,0.5;addx,100;addy,-100;);
			};
		};
	};
elseif tobool(GetAdhocPref("CSLAEasterEggs")) == true and ((HTitle and GetAdhocPref("FrameSet") == "Cs6") or cs6md) then
	sixset = "6/";
	t[#t+1] = Def.Quad{
		InitCommand=cmd(Center;zoomto,SCREEN_WIDTH,SCREEN_HEIGHT;diffuse,color("0.4,0.1,0.7,0.3"));
	};
	
	t[#t+1] = LoadActor("6/over")..{
		InitCommand=cmd(Center;queuecommand,"Set";);
		SetCommand=cmd(zoomy,10;diffuse,color("0.4,0.3,0.8,0");linear,0.6;zoomy,1;diffuse,color("0.6,0.6,0.6,1"););
	};

	t[#t+1] = Def.ActorFrame{
		Def.ActorFrame{
			InitCommand=cmd(y,SCREEN_TOP;);
			LoadActor("6/under_back_sp")..{
				InitCommand=cmd(horizalign,left;vertalign,top;x,SCREEN_LEFT;zoomtowidth,WideScale(0,214);queuecommand,"Set";);
				SetCommand=cmd(zoomtoheight,300;diffuse,color("0.7,0.5,0.8,0.4");sleep,0.2;accelerate,0.1;zoomtoheight,40;diffuse,color("1,1,1,1"));
			};
			LoadActor("6/under_back_bl")..{
				InitCommand=cmd(horizalign,right;vertalign,top;x,SCREEN_RIGHT;queuecommand,"Set";);
				SetCommand=cmd(zoomtoheight,300;diffuse,color("0.7,0.5,0.8,0.4");sleep,0.2;accelerate,0.1;zoomtoheight,40;diffuse,color("1,1,1,1"));
			};
		};
	};
	
	t[#t+1] = LoadActor("6/widthline")..{
		InitCommand=cmd(x,SCREEN_RIGHT+120;y,SCREEN_TOP+22;diffuse,color("0,0.9,0.8,1");zoomtowidth,240;);
		OnCommand=cmd(sleep,0.5;playcommand,"Set1";);
		Set1Command=cmd(x,SCREEN_RIGHT+120;linear,8;x,SCREEN_LEFT-180;queuecommand,"Repeat1";);
		Repeat1Command=cmd(sleep,9;x,SCREEN_RIGHT+120;linear,8;x,SCREEN_LEFT-180;queuecommand,"Repeat1";);
	};
	
	t[#t+1] = Def.ActorFrame{
		Def.ActorFrame{
			InitCommand=cmd(zoomy,-1;y,SCREEN_BOTTOM;);
			LoadActor("6/under_back_sp")..{
				InitCommand=cmd(zoomy,-1;horizalign,right;vertalign,top;x,SCREEN_RIGHT;zoomtowidth,WideScale(0,214);queuecommand,"Set";);
				SetCommand=cmd(zoomtoheight,300;diffuse,color("0.7,0.5,0.8,0.4");sleep,0.2;accelerate,0.1;zoomtoheight,40;diffuse,color("1,1,1,1"));
			};
			LoadActor("6/under_back_bl")..{
				InitCommand=cmd(zoomx,-1;zoomy,-1;horizalign,right;vertalign,top;x,SCREEN_LEFT;queuecommand,"Set";);
				SetCommand=cmd(zoomtoheight,300;diffuse,color("0.7,0.5,0.8,0.4");sleep,0.2;accelerate,0.1;zoomtoheight,40;diffuse,color("1,1,1,1"));
			};
		};
	};

	t[#t+1] = LoadActor("6/widthline")..{
		InitCommand=cmd(x,SCREEN_RIGHT+120;y,SCREEN_BOTTOM-21;diffuse,color("0,0.5,1,1");zoomtowidth,240;);
		OnCommand=cmd(sleep,1;playcommand,"Set2";);
		Set2Command=cmd(x,SCREEN_RIGHT+120;linear,2;x,SCREEN_LEFT-180;queuecommand,"Repeat2";);
		Repeat2Command=cmd(sleep,3.5;x,SCREEN_RIGHT+120;linear,2;x,SCREEN_LEFT-180;queuecommand,"Repeat2";);
	};
	t[#t+1] = LoadActor("6/widthline")..{
		InitCommand=cmd(x,SCREEN_RIGHT+120;y,SCREEN_BOTTOM-21;diffuse,color("0,0.5,1,1");zoomtowidth,240;);
		OnCommand=cmd(sleep,3;playcommand,"Set3";);
		Set3Command=cmd(x,SCREEN_RIGHT+120;linear,6.5;x,SCREEN_LEFT-180;queuecommand,"Repeat3";);
		Repeat3Command=cmd(sleep,10;x,SCREEN_RIGHT+120;linear,6.5;x,SCREEN_LEFT-180;queuecommand,"Repeat3";);
	};
else
	t[#t+1] = Def.ActorFrame{
		Def.ActorFrame{
			InitCommand=cmd(x,SCREEN_LEFT;y,SCREEN_BOTTOM-20;queuecommand,"Set";);
			SetCommand=cmd(addx,-(660+SCREEN_WIDTH-340);addy,20;decelerate,0.4;addx,(660+SCREEN_WIDTH-340);decelerate,0.1;addy,-20;);
			LoadActor("under_back_sp")..{
				InitCommand=cmd(horizalign,left;zoomtowidth,WideScale(0,220);playcommand,"Set";);
				SetCommand=cmd(glow,color("1,0.5,0,0.5");linear,0.4;glow,color("1,0.5,0,0");queuecommand,"Repeat";);
				RepeatCommand=cmd(sleep,7.7;glow,color("1,0.5,0,0.4");linear,0.8;glow,color("1,0.5,0,0");sleep,0.3;queuecommand,"Repeat";);
			};
			LoadActor("under_back_bl")..{
				InitCommand=cmd(horizalign,left;x,WideScale(0,218);queuecommand,"Set";);
				SetCommand=cmd(glow,color("1,0.5,0,0.5");linear,0.4;glow,color("1,0.5,0,0");queuecommand,"Repeat";);
				RepeatCommand=cmd(sleep,7.7;glow,color("1,0.5,0,0.4");linear,0.8;glow,color("1,0.5,0,0");sleep,0.3;queuecommand,"Repeat";);
			};
		};
		Def.ActorFrame{
			InitCommand=cmd(queuecommand,"Set";);
			SetCommand=cmd(addx,340;addy,20;decelerate,0.5;addx,-340;decelerate,0.1;addy,-20;);
			LoadActor("under_back_br")..{
				InitCommand=cmd(horizalign,right;x,SCREEN_RIGHT;y,SCREEN_BOTTOM-20;queuecommand,"Set";);
				SetCommand=cmd(glow,color("1,0.5,0,0.5");linear,0.4;glow,color("1,0.5,0,0");queuecommand,"Repeat";);
				RepeatCommand=cmd(sleep,8;glow,color("1,0.5,0,0.3");linear,0.8;glow,color("1,0.5,0,0");queuecommand,"Repeat";);
			};
		};
	};

	t[#t+1] = Def.ActorFrame{
		Def.ActorFrame{
			InitCommand=cmd(zoomy,-1;x,SCREEN_RIGHT;y,SCREEN_TOP+20;queuecommand,"Set");
			SetCommand=cmd(addx,(660+SCREEN_WIDTH-340);addy,-20;decelerate,0.4;addx,-(660+SCREEN_WIDTH-340);decelerate,0.1;addy,20;);
			LoadActor("under_back_sp")..{
				InitCommand=cmd(horizalign,right;zoomtowidth,WideScale(0,220);queuecommand,"Set";);
				SetCommand=cmd(glow,color("1,0.5,0,0.5");linear,0.4;glow,color("1,0.5,0,0");queuecommand,"Repeat";);
				RepeatCommand=cmd(sleep,7.9;glow,color("1,0.5,0,0.3");linear,0.8;glow,color("1,0.5,0,0");sleep,0.1;queuecommand,"Repeat";);
			};
			LoadActor("under_back_bl")..{
				InitCommand=cmd(zoomx,-1;horizalign,left;x,WideScale(0,-218);y,SCREEN_TOP;queuecommand,"Set";);
				SetCommand=cmd(glow,color("1,0.5,0,0.5");linear,0.4;glow,color("1,0.5,0,0");queuecommand,"Repeat";);
				RepeatCommand=cmd(sleep,7.9;glow,color("1,0.5,0,0.3");linear,0.8;glow,color("1,0.5,0,0");sleep,0.1;queuecommand,"Repeat";);
			};

		};
		Def.ActorFrame{
			InitCommand=cmd(zoomx,-1;zoomy,-1;queuecommand,"Set";);
			SetCommand=cmd(addx,-340;addy,-20;decelerate,0.5;addx,340;decelerate,0.1;addy,20;);
			LoadActor("under_back_br")..{
				InitCommand=cmd(horizalign,right;x,SCREEN_LEFT;y,SCREEN_TOP-20;queuecommand,"Set";);
				SetCommand=cmd(glow,color("1,0.5,0,0.5");linear,0.4;glow,color("1,0.5,0,0");queuecommand,"Repeat";);
				RepeatCommand=cmd(sleep,7.8;glow,color("1,0.5,0,0.4");linear,0.8;glow,color("1,0.5,0,0");sleep,0.1;queuecommand,"Repeat";);
			};
		};
	};
end;

t[#t+1] = Def.ActorFrame{
	LoadActor(sixset.."leftset")..{
		InitCommand=cmd(x,SCREEN_LEFT;y,SCREEN_TOP;vertalign,top;horizalign,left;cropbottom,1;queuecommand,"Set";);
		SetCommand=cmd(glow,color("1,0.75,0,0");sleep,0.2;decelerate,0.7;cropbottom,0;diffusealpha,1;glow,color("1,0.75,0,0.8");accelerate,0.3;glow,color("1,0.75,0,0");queuecommand,"Repeat";);
		RepeatCommand=cmd(sleep,7;diffusealpha,1;glow,color("1,0.75,0,0");linear,0.05;glow,color("1,0.75,0,0.8");decelerate,0.6;glow,color("1,0.75,0,0");queuecommand,"Repeat";);
		OffCommand=cmd(finishtweening;);
	};

	LoadActor(sixset.."rightset")..{
		InitCommand=cmd(x,SCREEN_RIGHT;y,SCREEN_TOP;vertalign,top;horizalign,right;cropbottom,1;queuecommand,"Set";);
		SetCommand=cmd(glow,color("1,0.75,0,0");sleep,0.2;decelerate,0.7;cropbottom,0;diffusealpha,1;glow,color("1,0.75,0,0.8");accelerate,0.3;glow,color("1,0.75,0,0");queuecommand,"Repeat";);
		RepeatCommand=cmd(sleep,10;diffusealpha,1;glow,color("1,0.75,0,0");linear,0.05;glow,color("1,0.75,0,0.8");decelerate,0.6;glow,color("1,0.75,0,0");queuecommand,"Repeat";);
		OffCommand=cmd(finishtweening;);
	};
};


return t;

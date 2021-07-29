--[[ScreenSelectMode scroller]]

local gc = Var "GameCommand";

local exp = {
	Dance = "diffset",
	Rave = "stageset",
	Nonstop = nil,
	Oni = nil,
	Endless = nil
};

local t = Def.ActorFrame{
	InitCommand=cmd(fov,100;);

	Def.Quad{
		InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y-60;zoomto,SCREEN_WIDTH,220;diffuse,color("0,0,0,0.2");queuecommand,"Set";);
		SetCommand=cmd(zoomtoheight,0;glow,color("1,0.6,0,0.2");linear,0.4;zoomtoheight,220;glow,color("1,0.6,0,0"););
		GainFocusCommand=cmd(finishtweening;visible,true;glow,color("1,0.6,0,0.2");linear,0.4;glow,color("1,0.6,0,0");diffusealpha,0;);
		LoseFocusCommand=cmd(finishtweening;visible,false);
		OffFocusedCommand=cmd(finishtweening;);
	};
	
	--explanation
	Def.ActorFrame{
		InitCommand=cmd(x,SCREEN_CENTER_X-198;y,SCREEN_CENTER_Y-148+10;);
		OnCommand=cmd(queuecommand,"Set";);
		SetCommand=cmd(zoomy,5;decelerate,0.45;zoomy,1;);
		LoadActor(THEME:GetPathG("","stylemodeback/explanationunder"))..{
			InitCommand=cmd(queuecommand,"Set";);
			SetCommand=cmd(diffusealpha,0;glow,color("0,1,1,0");zoomy,1.5;addy,-10;sleep,0.3;glow,color("0,1,1,1");decelerate,0.5;zoomy,1;diffusealpha,1;addy,10;glow,color("0,1,1,0"););
			OffFocusedCommand=cmd(finishtweening;);
		};

		LoadActor(THEME:GetPathG("","stylemodeback/explanationunder"))..{
			InitCommand=cmd(queuecommand,"Set";);
			SetCommand=cmd(zoomx,0.2;zoom,3;decelerate,0.25;zoom,1;diffusealpha,0);
			OffFocusedCommand=cmd(finishtweening;);
		};

		LoadActor(THEME:GetPathG("","stylemodeback/explanationmode"))..{
			InitCommand=cmd(x,12;y,-3;queuecommand,"Set";);
			SetCommand=cmd(diffusealpha,0;glow,color("0,1,1,0");zoomy,1.5;addx,30;sleep,0.1;glow,color("0,1,1,1");decelerate,0.5;zoomy,1;diffusealpha,1;addx,-30;glow,color("0,1,1,0");queuecommand,"Repeat";);
			RepeatCommand=cmd(diffusealpha,1;sleep,8;glow,color("0,1,1,0");linear,0.05;glow,color("0,1,1,1");decelerate,0.5;glow,color("0,1,1,0");queuecommand,"Repeat";);
			OffFocusedCommand=cmd(finishtweening;);
		};
	};
	
	Def.ActorFrame{
	--20170920
		InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;);
		OnCommand=cmd(queuecommand,"Set";);
		SetCommand=cmd(zoomx,10;sleep,0.1;accelerate,0.2;zoomx,1;);

		Def.ActorFrame{
			LoadActor(THEME:GetPathG("","stylemodeback/info_back"))..{
				InitCommand=cmd(x,-124;y,-10;queuecommand,"Set";);
				SetCommand=cmd(croptop,1;decelerate,0.45;croptop,0;);
				GainFocusCommand=cmd(finishtweening;visible,true;croptop,1;decelerate,0.45;croptop,0;);
				LoseFocusCommand=cmd(finishtweening;visible,false);
				OffFocusedCommand=cmd(finishtweening;);
			};
	
			LoadActor(THEME:GetPathG("","stylemodeback/name_back"))..{
				InitCommand=cmd(x,-134;y,-86;queuecommand,"Set";);
				SetCommand=cmd(cropleft,1;glow,color("1,0.7,0,0.6");accelerate,0.55;cropleft,0;linear,0.1;glow,color("0,0,0,0"););
				GainFocusCommand=cmd(finishtweening;visible,true;cropleft,1;glow,color("1,0.7,0,0.6");accelerate,0.55;cropleft,0;linear,0.1;glow,color("0,0,0,0"););
				LoseFocusCommand=cmd(finishtweening;visible,false);
				OffFocusedCommand=cmd(finishtweening;);
			};
		};

		LoadActor("_"..gc:GetName().."_label")..{
			InitCommand=cmd(x,150;y,50;vertalign,bottom;queuecommand,"Set";);
			--SetCommand=cmd(addx,10;diffusealpha,0.8;cropbottom,1;decelerate,0.4;addx,-10;cropbottom,0;glow,color("0.6,0.25,0.1,1");linear,0.025;glow,color("1,0.5,0,0"););
			GainFocusCommand=cmd(finishtweening;visible,true;addx,10;diffusealpha,0.8;cropbottom,1;decelerate,0.4;addx,-10;cropbottom,0;glow,color("0.6,0.25,0.1,1");linear,0.025;glow,color("1,0.5,0,0"););
			LoseFocusCommand=cmd(finishtweening;visible,false);
			OffFocusedCommand=cmd(finishtweening;);
		};

		LoadActor("_"..gc:GetName().."_explain2")..{
			InitCommand=cmd(x,-112;y,-29+10;queuecommand,"Set";);
			--SetCommand=cmd(diffusealpha,0;addy,-5;sleep,0.5;linear,0.2;addy,5;diffusealpha,1;glow,color("1,1,1,0");linear,0.05;glow,color("1,1,1,0.5");linear,0.05;glow,color("1,1,1,0"););
			GainFocusCommand=cmd(finishtweening;visible,true;diffusealpha,0;addy,-5;sleep,0.1;linear,0.2;addy,5;diffusealpha,1;glow,color("1,1,1,0");linear,0.05;glow,color("1,1,1,0.5");linear,0.05;glow,color("1,1,1,0"););
			LoseFocusCommand=cmd(finishtweening;visible,false);
			OffFocusedCommand=cmd(finishtweening;);
		};
	
		LoadActor("_"..gc:GetName().."_explain1")..{
			InitCommand=cmd(x,-66;y,-88+10;queuecommand,"Set";);
			SetCommand=cmd(diffusealpha,0.5;addx,20;zoomx,210;zoomy,1;decelerate,0.35;zoomx,1.75;
						glow,color("0,1,1,0.5");addx,-20;zoomx,1;linear,0.05;glow,color("1,1,0,1");diffusealpha,1;decelerate,0.1;glow,color("0,1,1,0"));
			GainFocusCommand=cmd(finishtweening;visible,true;diffusealpha,0.5;addx,20;zoomx,210;zoomy,1;decelerate,0.35;zoomx,1.75;
						glow,color("0,1,1,0.5");addx,-20;zoomx,1;linear,0.05;glow,color("1,1,0,1");diffusealpha,1;decelerate,0.1;glow,color("0,1,1,0"));
			LoseFocusCommand=cmd(finishtweening;visible,false);
			OffFocusedCommand=cmd(finishtweening;);
		};

		Def.Sprite{
			InitCommand=function(self)
				self:x(-160);
				self:y(2);
				if exp[gc:GetName()] then
					self:Load(THEME:GetPathG("ScreenSelectMode","scroller/explain_"..exp[gc:GetName()]));
				end;
				(cmd(queuecommand,"Set";))(self)
			end;
			SetCommand=cmd(diffusealpha,0;addx,5;sleep,0.5;linear,0.2;addx,-5;diffusealpha,1;glow,color("1,1,1,0");linear,0.05;glow,color("1,1,1,0.5");linear,0.05;glow,color("1,1,1,0"););
			GainFocusCommand=cmd(finishtweening;visible,true;diffusealpha,0;addx,5;sleep,0.1;linear,0.2;addx,-5;diffusealpha,1;glow,color("1,1,1,0");linear,0.05;glow,color("1,1,1,0.5");linear,0.05;glow,color("1,1,1,0"););
			LoseFocusCommand=cmd(finishtweening;visible,false);
			OffFocusedCommand=cmd(finishtweening;);
		};

		LoadFont("_titleMenu_scroller") .. {
			Text="Which GameMode matches you?";
			InitCommand=cmd(x,-208;y,-120+10;diffuse,color("0,0,0,1");strokecolor,color("1,0.6,0,1");shadowlength,1;zoom,0.4;queuecommand,"Set";);
			SetCommand=cmd(cropright,1;sleep,0.1;linear,0.35;cropright,0;diffusealpha,1;);
			GainFocusCommand=cmd(finishtweening;visible,true;cropright,1;sleep,0.1;linear,0.35;cropright,0;diffusealpha,1;);
			LoseFocusCommand=cmd(finishtweening;visible,false);
			OffFocusedCommand=cmd(finishtweening;);
		};
	};
};
return t;
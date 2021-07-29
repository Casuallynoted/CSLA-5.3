
local t = Def.ActorFrame {};
local cStage = GAMESTATE:GetCurrentStage();
local iStage = cstage_set(cStage);

--stage label
t[#t+1] = Def.ActorFrame{
	Def.Sprite {
		Name="a";
		OnCommand=cmd(addx,340;diffusealpha,0;sleep,0.1;decelerate,0.2;addx,-340;diffusealpha,0.5;linear,0.6;diffusealpha,1;
					sleep,0.5;linear,0.075;addx,(-SCREEN_CENTER_X+164)-22;diffusealpha,0;);
	};
	Def.Sprite {
		Name="b";
		OnCommand=cmd(addx,SCREEN_WIDTH;accelerate,0.3;addx,-SCREEN_WIDTH;zoom,2;linear,1.35;addx,-SCREEN_WIDTH*0.035;diffusealpha,0;);
	};
	Def.Sprite {
		Name="c";
		OnCommand=cmd(diffusealpha,0;sleep,1.4;linear,0.075;diffusealpha,1;y,SCREEN_CENTER_Y+100-10;sleep,01.1;
					linear,0.1;rotationz,-45;linear,0.1;addx,100;addy,-100;diffusealpha,0;zoomy,0);
	};

	InitCommand=function(self)
		local a = self:GetChild('a');
		local b = self:GetChild('b');
		local c = self:GetChild('c');
		cStage = cstage_imagse_set(iStage);
		local st_image = THEME:GetPathB("ScreenStageInformation","in/stageregular_effect/_label "..cStage);
		if st_image then
			a:Load(st_image);
			b:Load(st_image);
			c:Load(st_image);
		end;
		(cmd(horizalign,right;shadowlength,2;x,SCREEN_RIGHT-13;y,SCREEN_CENTER_Y-100;))(a);
		(cmd(x,SCREEN_RIGHT-100;y,SCREEN_CENTER_Y-90;diffusealpha,0.4;))(b);
		(cmd(horizalign,left;shadowlength,2;x,SCREEN_CENTER_X-200;y,SCREEN_CENTER_Y-100;))(c);
	end;
};

return t;
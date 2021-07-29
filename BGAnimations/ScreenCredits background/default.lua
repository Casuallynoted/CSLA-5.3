--[[ScreenCredits background]]

local t = Def.ActorFrame{};

t[#t+1] = Def.Quad {
	InitCommand=cmd(Center;FullScreen;diffuse,color("0,1,0.9,1");diffuserightedge,color("0,1,0.9,0.35"););
};

t[#t+1] = Def.ActorFrame{
	InitCommand=cmd(fov,100;);

	Def.ActorFrame{
		InitCommand=cmd(x,SCREEN_RIGHT-100;y,SCREEN_CENTER_Y+50;zoom,1.25;rotationx,0;rotationz,0;queuecommand,"Repeat";);
		RepeatCommand=cmd(spin;effectmagnitude,0,-5,-6;);
		LoadActor( THEME:GetPathB("_shared","models/_l_2") )..{
			InitCommand=cmd(blend,'BlendMode_Add';diffusealpha,0.4;);
		};
	};
	
	LoadActor( THEME:GetPathB("","_shared models/block4"))..{
		InitCommand=cmd(CenterY;x,SCREEN_RIGHT-100;zoomto,500,SCREEN_HEIGHT;customtexturerect,0,0,1,SCREEN_HEIGHT/self:GetHeight();ztest,true);
		OnCommand=cmd(texcoordvelocity,0,0.04;diffuse,color("1,1,1,0.4");diffuseleftedge,color("1,1,1,0"););
	};
};

return t;

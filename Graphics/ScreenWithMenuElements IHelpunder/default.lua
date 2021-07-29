--[[ScreenWithMenuElements IHelpunder]]

local t = Def.ActorFrame{};
local screen = SCREENMAN:GetTopScreen();
local HTitle = CScreen(Var("LoadingScreen"));

t[#t+1] = Def.ActorFrame {
	InitCommand=cmd(playcommand,"Set");
	SetCommand=function(self)
		if getenv("ReloadAnimFlag") == 1 then self:queuecommand("NoAnim");
		else self:queuecommand("Anim");
		end;
	end;

	Def.Sprite {
		InitCommand=function(self)
			if tobool(GetAdhocPref("CSLAEasterEggs")) == true and ((HTitle and GetAdhocPref("FrameSet") == "Cs6") or cs6md) then
				self:Load(THEME:GetPathG("ScreenWithMenuElements","IHelpunder/6frame"));
			else self:Load(THEME:GetPathG("ScreenWithMenuElements","IHelpunder/frame"));
			end;
			(cmd(x,SCREEN_CENTER_X;y,SCREEN_TOP+56;zoomtowidth,SCREEN_WIDTH;))(self)
		end;
		AnimCommand=function(self)
			if getenv("exflag") == "csc" then
				(cmd(zoomtoheight,40;cropleft,1;diffusealpha,0;linear,0.25;cropleft,0;diffusealpha,1;linear,0.15;
				zoomtoheight,28;diffuse,color("0.8,0.8,0.8,0.8");diffusetopedge,color("0,1,1,0.65");diffuserightedge,color("0,0.5,0.7,0.5");))(self)
			else
				if (HTitle and GetAdhocPref("FrameSet") == "Cs6") or cs6md then
					(cmd(zoomtoheight,40;cropleft,1;diffusealpha,0;linear,0.25;cropleft,0;diffusealpha,1;linear,0.15;
					zoomtoheight,28;diffuse,color("0.8,0.8,0.8,0.8");diffusetopedge,color("1,1,1,0.65");diffuserightedge,color("0.5,0.5,0.5,0.5");))(self)
				else
					(cmd(zoomtoheight,40;cropleft,1;diffusealpha,0;linear,0.25;cropleft,0;diffusealpha,1;linear,0.15;
					zoomtoheight,28;diffuse,color("0,0.8,0.8,0.8");diffusetopedge,color("0,1,1,0.65");diffuserightedge,color("0,0.5,0.7,0.5");))(self)
				end;
			end;
		end;
		NoAnimCommand=function(self)
			if tobool(GetAdhocPref("CSLAEasterEggs")) == true and ((HTitle and GetAdhocPref("FrameSet") == "Cs6") or cs6md) then
				(cmd(cropleft,0;diffuse,color("0.8,0.8,0.8,0.8");diffusetopedge,color("1,1,1,0.65");diffuserightedge,color("0.5,0.5,0.7,0.5");zoomtoheight,28;))(self)
			else
				(cmd(cropleft,0;diffuse,color("0,0.8,0.8,0.8");diffusetopedge,color("0,1,1,0.65");diffuserightedge,color("0,0.5,0.7,0.5");zoomtoheight,28;))(self)
			end;
		end;
	};

	LoadActor("information")..{
		InitCommand=function(self)
			if CAspect() >= 1.6 then
				self:x(SCREEN_WIDTH*0.25-58);
			else
				self:x(SCREEN_LEFT+114-58);
			end;
			self:y(SCREEN_TOP+52);
		end;
		AnimCommand=cmd(cropright,1;accelerate,0.4;cropright,0;);
		NoAnimCommand=cmd(cropright,0;diffusealpha,1;);
	};
};

return t;


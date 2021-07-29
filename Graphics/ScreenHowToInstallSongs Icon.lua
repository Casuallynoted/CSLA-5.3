local gc = Var "GameCommand";
local Name = gc:GetName();
local Index = gc:GetIndex();

local previewWidth = SCREEN_CENTER_X*0.825;
local previewHeight = SCREEN_CENTER_Y;

local t = Def.ActorFrame{
	Name="PreviewFrame";
	InitCommand=cmd(x,SCREEN_CENTER_X*1.25;y,SCREEN_CENTER_Y*0.85);
};

local previews = {
	WhereToFind = Def.ActorFrame{
		LoadActor(THEME:GetPathG("_howto","find"))..{
			InitCommand=cmd(zoomto,previewWidth,previewHeight);
			GainFocusCommand=cmd(stoptweening;decelerate,0.5;diffusealpha,1);
			LoseFocusCommand=cmd(stoptweening;accelerate,0.5;diffusealpha,0);
		};

	};
	HowToInstall = Def.ActorFrame{
		LoadActor(THEME:GetPathG("_howto","install"))..{
			InitCommand=cmd(zoomto,previewWidth,previewHeight);
			GainFocusCommand=cmd(stoptweening;decelerate,0.5;diffusealpha,1);
			LoseFocusCommand=cmd(stoptweening;accelerate,0.5;diffusealpha,0);
		};

	};
	AdditionalFolders = Def.ActorFrame{
		Def.Quad{
			InitCommand=cmd(zoomto,previewWidth,previewHeight);
			GainFocusCommand=cmd(stoptweening;decelerate,0.5;diffusealpha,1);
			LoseFocusCommand=cmd(stoptweening;accelerate,0.5;diffusealpha,0);
		};
		Def.Quad{
			InitCommand=cmd(y,-previewHeight*0.45;diffuse,color("#E0F0F0");zoomto,previewWidth,previewHeight*0.1;);
			GainFocusCommand=cmd(stoptweening;decelerate,0.5;diffusealpha,1);
			LoseFocusCommand=cmd(stoptweening;accelerate,0.5;diffusealpha,0);
		};
		LoadFont("Common Normal")..{
			InitCommand=cmd(x,-(SCREEN_CENTER_X*0.4);y,-(SCREEN_CENTER_Y*0.475);zoom,0.625;halign,0;valign,0;diffuse,color("#000000"));
			BeginCommand=function(self)
				local text = "Preferences.ini";
				self:settext(text);
			end;
			GainFocusCommand=cmd(stoptweening;decelerate,0.5;diffusealpha,1);
			LoseFocusCommand=cmd(stoptweening;accelerate,0.5;diffusealpha,0);
		};
		LoadFont("Common Normal")..{
			Text="[Options]\nAdditionalCourseFolders=\nAdditionalFolders=\nAdditionalSongFolders=";
			InitCommand=cmd(x,-(SCREEN_CENTER_X*0.4);y,-(SCREEN_CENTER_Y*0.35);zoom,0.75;halign,0;valign,0;diffuse,color("#000000"););
			GainFocusCommand=cmd(stoptweening;decelerate,0.5;diffusealpha,1);
			LoseFocusCommand=cmd(stoptweening;accelerate,0.5;diffusealpha,0);
		};
	};
	ReloadSongs = Def.ActorFrame{
	};
	Exit = Def.ActorFrame{
	};
};

t[#t+1] = previews[Name];

t[#t+1] = LoadFont("Common Normal")..{
	Name="Explanation";
	--Text="The quick brown fox jumps over the lazy dog ".. Index .." times.";
	Text=Screen.String("Explanation-"..Name);
	-- was x,-(SCREEN_CENTER_X*0.4);y,SCREEN_CENTER_Y*0.525;
	InitCommand=cmd(x,-(SCREEN_CENTER_X);y,SCREEN_CENTER_Y*0.65;halign,0;valign,0;zoom,0.65;wrapwidthpixels,(SCREEN_WIDTH*0.65)*1.75;strokecolor,color("0,0,0,1"););
	GainFocusCommand=cmd(stoptweening;decelerate,0.5;diffusealpha,1);
	LoseFocusCommand=cmd(stoptweening;accelerate,0.5;diffusealpha,0);
};

return t;

local cjacket = THEME:GetPathG("","_MusicWheelItem parts/section_mono_jacket");
local ac = 1;
local path = cbanner;
local drawindex = 0;
local items = 0;

local t = Def.ActorFrame{};

	--back
t[#t+1] = Def.ActorFrame{
	OnCommand=function(self)
		if THEME:GetMetric( Var "LoadingScreen","ScreenType") == 0 then
			(cmd(linear,0.4;playcommand,"Flag"))(self)
		else
			(cmd(playcommand,"Flag"))(self)
		end;
	end;
	FlagCommand=function(self) ac = 0;
	end;
	SetMessageCommand=function(self, params)
		drawindex = params.DrawIndex;
		song = params.Song;
		course = params.Course;
		items = THEME:GetMetric( "MusicWheel","NumWheelItems" ) + 2;
		if ac == 1 then
			if drawindex > math.floor(items / 2) then
				(cmd(addy,100;zoomx,0;decelerate,math.min(0.4,(items -1 - drawindex)*0.07);addy,-100;rotationz,0;zoomx,1;))(self)
			elseif drawindex < math.floor(items / 2) then
				(cmd(addy,100;zoomx,0;decelerate,math.min(0.4,drawindex*0.07);addy,-100;rotationz,0;zoomx,1;))(self)
			elseif drawindex == math.floor(items / 2) then
				(cmd(addy,-100;zoomy,0;decelerate,0.2;addy,100;zoomy,1;))(self)
			end;
		end;
	end;
	
	LoadActor(THEME:GetPathG("_MusicWheelItem","parts/section_back"))..{
		InitCommand=cmd(y,10;diffuse,color("0.5,0.5,0.5,1");diffusetopedge,color("0.5,1,0.1,1");
					diffusebottomedge,color("0.5,0.5,0.5,0.8"););
	};

	--jacket_mirror
	LoadActor(cjacket)..{
		Name="Banner";
		InitCommand=cmd(y,113;rotationy,180;rotationz,180;zoomtowidth,174;zoomtoheight,174*0.3;
					diffusetopedge,color("1,1,1,0");diffusebottomedge,color("1,1,1,0.2"););
	};
	
	--jacket
	LoadActor(cjacket)..{
		Name="Banner";
		InitCommand=cmd(diffuse,color("0,0.4,0.4,1");diffusebottomedge,color("0.2,0.2,0.2,1");zoomto,174,174);
	};

	--title
--[[
	Def.ActorFrame{
		LoadActor(THEME:GetPathG("_MusicWheelItem","parts/songinfotitle"))..{
			InitCommand=cmd(x,-92;y,108;);
		};
	};
]]
};

return t;
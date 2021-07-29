
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
	
	Def.ActorFrame{
		InitCommand=cmd(x,-45;y,-88;);
		
		LoadActor(THEME:GetPathG("_MusicWheelItem","parts/down_folder"))..{
		};

		LoadActor(THEME:GetPathG("_MusicWheelItem","parts/up_folder"))..{
		};
	};
};

return t;
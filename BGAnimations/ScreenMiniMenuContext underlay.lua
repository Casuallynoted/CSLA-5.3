local t = Def.ActorFrame{};

local yset = 0;
if vcheck() then
	if vcheck() ~= "beta4" then
		yset = 48;
	end;
end;

t[#t+1]=Def.ActorFrame {
	InitCommand=cmd(Center;);
	Def.Quad{
		BeginCommand=function(self)
			self:finishtweening();
			self:zoomtowidth(SCREEN_WIDTH*2);
			self:zoomtoheight(SCREEN_HEIGHT*2.5);
			self:diffuse(color("0,0,0,0"));
			self:linear(0.1);
			self:diffuse(color("0.025,0.21,0.2,0.85"));
		end;
	};
};

t[#t+1]=Def.ActorFrame {
	LoadActor( THEME:GetPathB("ScreenSelectProfile","overlay/avatar_frame") )..{
		Name="a_frame";
		InitCommand=cmd(x,SCREEN_CENTER_X-50;y,SCREEN_TOP-28-yset;zoomx,-1;shadowlength,2;);
	};
	Def.Sprite{
		Name="a_image";
	};

	LoadFont("_shared2") .. {
		Name="p_name";
		InitCommand=cmd(horizalign,right;y,SCREEN_TOP-10-yset;maxwidth,250;zoom,0.9;shadowlength,2;strokecolor,Color("Black"););
	};
	
	BeginCommand=function(self)
		local a_frame = self:GetChild('a_frame');
		local a_image = self:GetChild('a_image');
		local p_name = self:GetChild('p_name');
		local profile = GAMESTATE:GetEditLocalProfile();
		a_frame:visible(false);
		a_image:visible(false);
		p_name:visible(false);
		if profile then
			p_name:visible(true);
			p_name:settext( profile:GetDisplayName() );
			p_name:x(SCREEN_CENTER_X);
			if FILEMAN:DoesFileExist( ProfIDPrefCheck("ProfAvatar",Pid(profile),"Off") ) then
				a_frame:visible(true);
				a_image:visible(true);
				p_name:x(SCREEN_CENTER_X-120);
				a_image:Load( ProfIDPrefCheck("ProfAvatar",Pid(profile),"Off") );
				(cmd(stoptweening;scaletofit,0,0,60,60;x,SCREEN_CENTER_X-50;y,SCREEN_TOP-28-yset;croptop,1;decelerate,0.15;croptop,0;))(a_image)
			end;
		end;
	end;
	--scaletofit,0,0,60,60;
};

return t;
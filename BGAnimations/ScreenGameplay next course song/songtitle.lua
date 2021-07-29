
local t = Def.ActorFrame{};

local coursemode = GAMESTATE:IsCourseMode();
local showjacket = GetAdhocPref("WheelGraphics");

t[#t+1] = Def.ActorFrame{
	LoadFont("","_shared2")..{
		Name="MainorFullTitle1";
	};
	LoadFont("","_shared2")..{
		Name="MainorFullTitle2";
	};
	
	LoadFont("","_shared2")..{
		Name="SubTitle1";
	};
	LoadFont("","_shared2")..{
		Name="SubTitle2";
	};
	
	LoadFont("","_shared2")..{
		Name="Artist1";
	};
	LoadFont("","_shared2")..{
		Name="Artist2";
	};

	BeforeLoadingNextCourseSongMessageCommand=function(self)
		local songorcourse = SCREENMAN:GetTopScreen():GetNextCourseSong();
		local songorcoursecolor = SONGMAN:GetSongColor(songorcourse);
		local sectioncolorlist = getenv("sectioncolorlist");
		local sdirs = split("/",songorcourse:GetSongDir());
		if sectioncolorlist ~= "" then
			if sectioncolorlist[songorcourse:GetGroupName().."/"..sdirs[4]] then
				songorcoursecolor = color(sectioncolorlist[songorcourse:GetGroupName().."/"..sdirs[4]]);
			elseif sectioncolorlist[songorcourse:GetGroupName()] then
				songorcoursecolor = color(sectioncolorlist[songorcourse:GetGroupName()]);
			end;
		end;
		local usesubtitle = 0;
		local tTextOne = self:GetChild('MainorFullTitle1');
		local tTextTwo = self:GetChild('MainorFullTitle2');
		local sTextOne = self:GetChild('SubTitle1');
		local sTextTwo = self:GetChild('SubTitle2');
		local aTextOne = self:GetChild('Artist1');
		local aTextTwo = self:GetChild('Artist2');
		
		(cmd(visible,true;diffuse,songorcoursecolor;strokecolor,Color("Black");horizalign,right;maxwidth,225*1.7;x,SCREEN_RIGHT-20;zoomx,1;zoomy,0.9;shadowlength,2;))(tTextOne);
		(cmd(visible,true;diffuse,songorcoursecolor;strokecolor,Color("Black");horizalign,left;maxwidth,225*1.7;x,SCREEN_CENTER_X-192;zoomx,1;zoomy,0.9;shadowlength,2;))(tTextTwo);
		(cmd(visible,true;diffuse,songorcoursecolor;strokecolor,Color("Black");horizalign,right;maxwidth,392*1.7;x,SCREEN_RIGHT-20;zoomx,0.575;zoomy,0.565;shadowlength,2;))(sTextOne);
		(cmd(visible,true;diffuse,songorcoursecolor;strokecolor,Color("Black");horizalign,left;maxwidth,392*1.7;x,SCREEN_CENTER_X-192;zoomx,0.575;zoomy,0.565;shadowlength,2;))(sTextTwo);
		(cmd(visible,true;diffuse,songorcoursecolor;strokecolor,Color("Black");horizalign,right;maxwidth,346*1.7;x,SCREEN_RIGHT-20;zoom,0.65;shadowlength,2;))(aTextOne);
		(cmd(visible,true;diffuse,songorcoursecolor;strokecolor,Color("Black");horizalign,left;maxwidth,346*1.7;x,SCREEN_CENTER_X-192;zoom,0.65;shadowlength,2;))(aTextTwo);

		sTextOne:y(SCREEN_CENTER_Y-34);
		aTextOne:y(SCREEN_CENTER_Y-20);

		if coursemode then
			if songorcourse:GetDisplaySubTitle() ~= "" then
				usesubtitle = -10;
				tTextOne:settext(songorcourse:GetDisplayMainTitle());
				tTextTwo:settext(songorcourse:GetDisplayMainTitle());
				sTextOne:settext(songorcourse:GetDisplaySubTitle());
				sTextTwo:settext(songorcourse:GetDisplaySubTitle());
			else
				tTextOne:settext(songorcourse:GetDisplayFullTitle());
				tTextTwo:settext(songorcourse:GetDisplayFullTitle());
				sTextOne:visible(false);
				sTextTwo:visible(false);
			end;
			aTextOne:settext(songorcourse:GetDisplayArtist());
			aTextTwo:settext(songorcourse:GetDisplayArtist());
			tTextOne:y(SCREEN_CENTER_Y-40+usesubtitle);
			tTextTwo:y(SCREEN_CENTER_Y+30+usesubtitle);
			sTextTwo:y(SCREEN_CENTER_Y+36);
			aTextTwo:y(SCREEN_CENTER_Y+50);
			if showjacket ~= "Off" then
				if not songorcourse:HasBanner() then
					tTextTwo:y(SCREEN_BOTTOM-70+usesubtitle);
					sTextTwo:y(SCREEN_BOTTOM-64);
					aTextTwo:y(SCREEN_BOTTOM-50);
				elseif songorcourse:HasBanner() and (songorcourse:HasJacket() or songorcourse:HasCDImage()) then
					tTextTwo:y(SCREEN_BOTTOM-70+usesubtitle);
					sTextTwo:y(SCREEN_BOTTOM-64);
					aTextTwo:y(SCREEN_BOTTOM-50);
				end;
			end;
		end;
	end;
	StartCommand=function(self)
		local tTextOne = self:GetChild('MainorFullTitle1');
		local tTextTwo = self:GetChild('MainorFullTitle2');
		local sTextOne = self:GetChild('SubTitle1');
		local sTextTwo = self:GetChild('SubTitle2');
		local aTextOne = self:GetChild('Artist1');
		local aTextTwo = self:GetChild('Artist2');
		(cmd(rotationz,0;addx,SCREEN_WIDTH*0.5;decelerate,0.2;zoomx,1;
		addx,-SCREEN_WIDTH*0.5;sleep,1.2;accelerate,0.1;addy,-150;diffusealpha,0;))(tTextOne);
		(cmd(rotationz,0;addx,-200;diffusealpha,0;sleep,1.4;accelerate,0.1;addx,200;diffusealpha,1;sleep,0.9+0.3;
		linear,0.1;rotationz,-45;linear,0.2;addx,100;addy,-100;diffusealpha,0;zoomy,0))(tTextTwo);
		(cmd(rotationz,0;addx,SCREEN_WIDTH*0.5;decelerate,0.2;zoomx,0.575;
		addx,-SCREEN_WIDTH*0.5;sleep,1.2;accelerate,0.1;addy,-300/2;diffusealpha,0;))(sTextOne);
		(cmd(rotationz,0;addx,-200;diffusealpha,0;sleep,1.4;accelerate,0.1;addx,200;diffusealpha,1;sleep,0.9+0.3;
		linear,0.1;rotationz,-45;linear,0.2;addx,100;addy,-100;diffusealpha,0;zoomy,0))(sTextTwo);
		(cmd(rotationz,0;addx,SCREEN_WIDTH*0.5;decelerate,0.2;zoomx,0.65;
		addx,-SCREEN_WIDTH*0.5;sleep,1.2;accelerate,0.1;addy,-300/2;diffusealpha,0))(aTextOne);
		(cmd(rotationz,0;addx,-200;diffusealpha,0;sleep,1.4;accelerate,0.1;addx,200;diffusealpha,1;sleep,0.9+0.3;
		linear,0.1;rotationz,-45;linear,0.2;addx,100;addy,-100;diffusealpha,0;zoomy,0))(aTextTwo);
	end;
};

return t;
local song = GAMESTATE:GetCurrentSong();
local course = GAMESTATE:GetCurrentCourse();
local coursemode = GAMESTATE:IsCourseMode();

local t = Def.ActorFrame{
	Def.TextBanner {
		InitCommand=cmd(x,-126;Load,"EvaluationTextBanner";SetFromString,"", "", "", "", "", "";);
		OnCommand=function(self)
			(cmd(zoomx,1;zoomy,0;sleep,0.45;accelerate,0.1;zoomy,1))(self)
			self:visible(true);
			if coursemode then
				self:y(6);
				if course then
					self:SetFromString( course:GetDisplayFullTitle(), "", "", "", "", "" );
					self:diffuse( getenv("wheelsectionetccolorfocus") );
				end;
			else
				self:y(0);
				if song then
					sgbtsetting(self,song);
				end;
			end;
		end;
	};
	LoadFont("","_shared2")..{
		InitCommand=cmd(x,0;y,-28;maxwidth,290;shadowlength,0);
		OnCommand=function(self)
			self:visible(false);
			if not coursemode and song and 
			THEME:GetMetric(SCREENMAN:GetTopScreen():GetName(),"HeaderTitle") == "Evaluation" then
				self:visible(true);
				(cmd(zoomx,0.6;zoomy,0;sleep,0.45;accelerate,0.1;zoomy,0.6;strokecolor,Color("Black");))(self)
				self:settext(song:GetGroupName());
				--self:settext("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
				local sectioncolorlist = getenv("sectioncolorlist");
				local sectiontextlist = getenv("sectionsubnamelist");
				if sectioncolorlist ~= "" then
					if sectioncolorlist[song:GetGroupName()] then
						self:diffuse(color(sectioncolorlist[song:GetGroupName()]));
					end;
				end;
				if sectiontextlist ~= "" then
					if sectiontextlist[song:GetGroupName()] then
						self:settext(sectiontextlist[song:GetGroupName()]);
					end;
				end;
			end;
		end;
	};
};
return t;

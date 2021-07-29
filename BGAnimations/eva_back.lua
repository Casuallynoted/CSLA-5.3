local t = Def.ActorFrame{};

local showjacket = GetAdhocPref("WheelGraphics");
local songorcourse =CurSOSet();

t[#t+1] = Def.ActorFrame{
	InitCommand=function(self)
		self:fov(100);
		self:y(SCREEN_CENTER_Y+100);
	end;
	OnCommand=function(self)
		local plus = 0;
		if THEME:GetMetric(SCREENMAN:GetTopScreen():GetName(),"OptionScreenType") == 1 then
			plus = 0.2;
		end;
		if plus == 0 then
			if GAMESTATE:IsPlayerEnabled(PLAYER_1) and GAMESTATE:IsHumanPlayer(PLAYER_1) and 
			not GAMESTATE:IsPlayerEnabled(PLAYER_2) and not GAMESTATE:IsHumanPlayer(PLAYER_2) then
				self:x(SCREEN_RIGHT-(SCREEN_WIDTH*0.54));
			elseif GAMESTATE:IsPlayerEnabled(PLAYER_2) and GAMESTATE:IsHumanPlayer(PLAYER_2) and 
			not GAMESTATE:IsPlayerEnabled(PLAYER_1) and not GAMESTATE:IsHumanPlayer(PLAYER_1) then
				self:x(SCREEN_LEFT+(SCREEN_WIDTH*0.54));
			else
				self:x(SCREEN_RIGHT-(SCREEN_WIDTH*0.54));
			end;
		else self:x(SCREEN_RIGHT-(SCREEN_WIDTH*0.54));
		end;
	end;

--banner_background
	Def.ActorFrame{
		BeginCommand=function(self)
			local plus = 0;
			if THEME:GetMetric(SCREENMAN:GetTopScreen():GetName(),"OptionScreenType") == 1 then
				plus = 0.2;
			end;
			if plus == 0 then
				if GAMESTATE:IsPlayerEnabled(PLAYER_1) and GAMESTATE:IsHumanPlayer(PLAYER_1) and 
				not GAMESTATE:IsPlayerEnabled(PLAYER_2) and not GAMESTATE:IsHumanPlayer(PLAYER_2) then
					(cmd(rotationz,20;))(self)
				elseif GAMESTATE:IsPlayerEnabled(PLAYER_2) and GAMESTATE:IsHumanPlayer(PLAYER_2) and 
				not GAMESTATE:IsPlayerEnabled(PLAYER_1) and not GAMESTATE:IsHumanPlayer(PLAYER_1) then
					(cmd(rotationz,-20;))(self)
				else
					(cmd(rotationz,20;))(self)
				end;
			else (cmd(rotationz,20;))(self)
			end;
		end;
--		OnCommand=cmd(zoom,1.5;decelerate,0.5;zoom,1;rotationx,200;rotationy,130;rotationz,200;);
		OnCommand=function(self)
			local plus = 0;
			if THEME:GetMetric(SCREENMAN:GetTopScreen():GetName(),"OptionScreenType") == 1 then
				plus = 0.2;
			end;
			if plus == 0 then
				if GAMESTATE:IsPlayerEnabled(PLAYER_1) and GAMESTATE:IsHumanPlayer(PLAYER_1) and 
				not GAMESTATE:IsPlayerEnabled(PLAYER_2) and not GAMESTATE:IsHumanPlayer(PLAYER_2) then
					(cmd(zoom,1.5;decelerate,0.5;zoom,1;rotationx,200;rotationy,130;rotationz,200;))(self)
				elseif GAMESTATE:IsPlayerEnabled(PLAYER_2) and GAMESTATE:IsHumanPlayer(PLAYER_2) and 
				not GAMESTATE:IsPlayerEnabled(PLAYER_1) and not GAMESTATE:IsHumanPlayer(PLAYER_1) then
					(cmd(zoom,1.5;decelerate,0.5;zoom,1;rotationx,200;rotationy,-130;rotationz,-200;))(self)
				else
					(cmd(zoom,1.5;decelerate,0.5;zoom,1;rotationx,200;rotationy,130;rotationz,200;))(self)
				end;
			else (cmd(zoom,1.5;decelerate,0.5;zoom,1;rotationx,200;rotationy,130;rotationz,200;))(self)
			end;
		end;
		Def.Banner {
			InitCommand=cmd(y,-110;diffusealpha,0.45;vertalign,bottom;);
			OnCommand=function(self, params)
				local plus = 0;
				if THEME:GetMetric(SCREENMAN:GetTopScreen():GetName(),"OptionScreenType") == 1 then
					plus = 0.2;
				end;
				self:visible(false);
				if songorcourse:HasBackground() then
					self:visible(true);
					self:Load(songorcourse:GetBackgroundPath());
					local gw = self:GetWidth();
					local gh = self:GetHeight();
					local graphicAspect = gw/gh;
					local dwidth = 480 * graphicAspect;
					dwidth = dwidth * (CAspect() / 5);
					local dheight = 480;
					dheight = dheight * (CAspect() / 5);
					self:scaletoclipped(dwidth,dheight);
					self:diffusetopedge(color("1,1,1,"..0.4+plus));
					self:diffusebottomedge(color("1,1,1,"..0.4+plus));
					if plus == 0 then
						if GAMESTATE:IsPlayerEnabled(PLAYER_1) and GAMESTATE:IsHumanPlayer(PLAYER_1) and 
						not GAMESTATE:IsPlayerEnabled(PLAYER_2) and not GAMESTATE:IsHumanPlayer(PLAYER_2) then
							(cmd(diffuserightedge,color("1,1,1,"..0.3+plus);horizalign,left;))(self)
						elseif GAMESTATE:IsPlayerEnabled(PLAYER_2) and GAMESTATE:IsHumanPlayer(PLAYER_2) and 
						not GAMESTATE:IsPlayerEnabled(PLAYER_1) and not GAMESTATE:IsHumanPlayer(PLAYER_1) then
							(cmd(diffuseleftedge,color("1,1,1,"..0.3+plus);horizalign,right;))(self)
						else
							(cmd(diffuserightedge,color("1,1,1,"..0.3+plus);horizalign,left;))(self)
						end;
					else (cmd(diffuserightedge,color("1,1,1,"..0.3+plus);horizalign,left;))(self)
					end;
				end;
			end;
		};

		Def.Banner {
			InitCommand=cmd(diffusealpha,0.45;);
			OnCommand=function(self, params)
				local plus = 0;
				if THEME:GetMetric(SCREENMAN:GetTopScreen():GetName(),"OptionScreenType") == 1 then
					plus = 0.2;
				end;
				self:visible(false);
				if GetSongImage(songorcourse) ~= songorcourse:GetBackgroundPath() then
					self:visible(true);
					self:diffusetopedge(color("1,1,1,"..0.4+plus));
					self:diffusebottomedge(color("1,1,1,"..0.4+plus));
					if plus == 0 then
						if GAMESTATE:IsPlayerEnabled(PLAYER_1) and GAMESTATE:IsHumanPlayer(PLAYER_1) and 
						not GAMESTATE:IsPlayerEnabled(PLAYER_2) and not GAMESTATE:IsHumanPlayer(PLAYER_2) then
							(cmd(diffuserightedge,color("1,1,1,"..0.3+plus);horizalign,left;))(self)
						elseif GAMESTATE:IsPlayerEnabled(PLAYER_2) and GAMESTATE:IsHumanPlayer(PLAYER_2) and 
						not GAMESTATE:IsPlayerEnabled(PLAYER_1) and not GAMESTATE:IsHumanPlayer(PLAYER_1) then
							(cmd(diffuseleftedge,color("1,1,1,"..0.3+plus);horizalign,right;))(self)
						else
							(cmd(diffuserightedge,color("1,1,1,"..0.3+plus);horizalign,left;))(self)
						end;
					else (cmd(diffuserightedge,color("1,1,1,"..0.3+plus);horizalign,left;))(self)
					end;
					
					self:Load(GetSongImage(songorcourse));
					if not songorcourse:HasBackground() then
						self:y(-160);
						self:zoomto(GetSongImageSize(songorcourse,"normal")[1]*1.4,GetSongImageSize(songorcourse,"normal")[2]*1.4);
					else
						self:y(-100);
						self:vertalign(top);
						self:zoomto(GetSongImageSize(songorcourse,"normal")[1],GetSongImageSize(songorcourse,"normal")[2]);
					end;
				end;
			end;
		};
	};
};

return t;
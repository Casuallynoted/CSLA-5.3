local t = Def.ActorFrame{};

for i = 1, 2 do
	local function player()
		local PLAYER;
		if i == 1 then PLAYER = PLAYER_1
		else PLAYER = PLAYER_2
		end;
		return PLAYER;
	end;

	t[#t+1] = Def.ActorFrame{
		InitCommand=function(self)
			self:y(SCREEN_BOTTOM-46);
			if i == 1 then self:x((SCREEN_CENTER_X*0.575)-44);
			else self:x((SCREEN_CENTER_X*1.425)+11);
			end;
		end;
		LoadActor(THEME:GetPathG("ScreenWithMenuElements","Statusbar/at"))..{
			InitCommand=cmd(queuecommand,"Refresh");
			CoinInsertedMessageCommand=cmd(playcommand,"Refresh");
			CoinModeChangedMessageCommand=cmd(playcommand,"Refresh");
			RefreshCommand=cmd(finishtweening;diffusealpha,0;zoom,1.35;decelerate,0.3;diffusealpha,1;zoom,1;);
			PlayerJoinedMessageCommand=function(self,param)
				if param.Player == player() then
					(cmd(finishtweening;diffusealpha,0;zoom,1.35;decelerate,0.3;diffusealpha,1;zoom,1;))(self)
				end;
			end;
		};
		LoadActor(THEME:GetPathG("ScreenWithMenuElements","Statusbar/lamp"))..{
			InitCommand=cmd(y,30;diffusealpha,0;zoomx,1.35;sleep,0.3;decelerate,0.3;diffusealpha,1;zoom,1;queuecommand,"Repeat";);
			CoinInsertedMessageCommand=cmd(playcommand,"Refresh");
			CoinModeChangedMessageCommand=cmd(playcommand,"Refresh");
			RepeatCommand=cmd(sleep,6;linear,0.05;glow,color("1,0.5,0,1");decelerate,2.5;glow,color("0,0,0,0");queuecommand,"Repeat";);
			PlayerJoinedMessageCommand=function(self,param)
				if param.Player == player() then
					(cmd(finishtweening;diffusealpha,0;zoom,1.35;decelerate,0.3;diffusealpha,1;zoom,1;))(self)
				end;
			end;
		};
		Def.Sprite{
			InitCommand=function(self)
				(cmd(x,-93;y,12;))(self)
				if i == 1 then self:Load(THEME:GetPathG("ScreenWithMenuElements","Statusbar/p1"));
				else self:Load(THEME:GetPathG("ScreenWithMenuElements","Statusbar/p2"));
				end;
				(cmd(queuecommand,"Refresh"))(self)
			end;
			CoinInsertedMessageCommand=cmd(playcommand,"Refresh");
			CoinModeChangedMessageCommand=cmd(playcommand,"Refresh");
			RefreshCommand=function(self)
				local join = GAMESTATE:IsHumanPlayer(player());
				if join then
					(cmd(finishtweening;diffusealpha,0;zoom,1.35;decelerate,0.3;diffusealpha,1;zoom,1;))(self)
				else
					(cmd(finishtweening;diffusealpha,1;zoom,1;accelerate,0.3;diffusealpha,0;zoom,1.35;))(self)
				end;
			end;
			PlayerJoinedMessageCommand=function(self,param)
				if param.Player == player() then
					(cmd(finishtweening;diffusealpha,0;zoom,1.35;decelerate,0.3;diffusealpha,1;zoom,1;))(self)
				end;
			end;
		};

		LoadActor(THEME:GetPathG("ScreenWithMenuElements","Statusbar/joinup"))..{
			InitCommand=cmd(x,28;y,4;diffusealpha,0.6;queuecommand,"Refresh");
			CoinInsertedMessageCommand=cmd(playcommand,"Refresh");
			CoinModeChangedMessageCommand=cmd(playcommand,"Refresh");
			RefreshCommand=function(self)
				local join = GAMESTATE:IsHumanPlayer(player());
				if join then
					self:finishtweening();
					self:visible(false);
				else
					self:visible(true);
					(cmd(finishtweening;diffusealpha,0;zoom,1.35;decelerate,0.3;diffusealpha,1;zoom,1;))(self)
				end;
			end;
			PlayerJoinedMessageCommand=function(self,param)
				if param.Player == player() then
					self:finishtweening();
					self:visible(false);
				end;
			end;
		};

		Def.ActorFrame{
			InitCommand=cmd(playcommand,"CheckNumPlayers");
			CheckNumPlayersCommand=function(self)
				if #GAMESTATE:GetHumanPlayers() > 1 then
					self:visible(false);
				else
					self:visible(true);
				end;
			end;

			LoadFont("_shared2")..{
				InitCommand=cmd(x,20;y,2;zoom,0.6;maxwidth,260;strokecolor,Color("Black");queuecommand,"Refresh");
				--Text="TESTING";
				CoinInsertedMessageCommand=cmd(playcommand,"Refresh");
				CoinModeChangedMessageCommand=cmd(playcommand,"Refresh");
				RefreshCommand=function(self)
					(cmd(zoomy,0;linear,0.3;zoomy,0.6;diffuseshift;effectperiod,0.5;effectcolor1,color("1,0.5,0,1");effectcolor2,color("0,1,1,1");))(self)
					local bCanPlay = GAMESTATE:EnoughCreditsToJoin();
					local p1join = GAMESTATE:IsHumanPlayer(PLAYER_1);
					local p2join = GAMESTATE:IsHumanPlayer(PLAYER_2);
					--[ja] 20160408修正
					if i == 1 then
						if bCanPlay then
							if p1join and p2join then
								self:finishtweening();
								self:visible(false);
							elseif p2join then
								self:finishtweening();
								self:visible(true);
								self:settext(THEME:GetString("ScreenTitleJoin","HelpTextJoin"));
							else
								self:finishtweening();
								self:visible(false);
							end;
						else
							if p1join then
								self:finishtweening();
								self:visible(false);
							else
								self:finishtweening();
								self:visible(true);
								self:settext(THEME:GetString("ScreenTitleJoin","HelpTextWait"));
							end;
						end;
					else
						if bCanPlay then
							if p1join and p2join then
								self:finishtweening();
								self:visible(false);
							elseif p1join then
								self:finishtweening();
								self:visible(true);
								self:settext(THEME:GetString("ScreenTitleJoin","HelpTextJoin"));
							else
								self:finishtweening();
								self:visible(false);
							end;
						else
							if p2join then
								self:finishtweening();
								self:visible(false);
							else
								self:finishtweening();
								self:visible(true);
								self:settext(THEME:GetString("ScreenTitleJoin","HelpTextWait"));
							end;
						end;
					end;
				end;
				PlayerJoinedMessageCommand=function(self,param)
					if param.Player == player() then
						self:finishtweening();
						self:visible(false);
					end;
				end;
			};
		};
	};
end;

return t;
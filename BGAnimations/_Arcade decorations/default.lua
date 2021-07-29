local t = Def.ActorFrame {};
t.InitCommand=function(self)
	self:name("ArcadeOverlay")
	ActorUtil.LoadAllCommandsAndSetXY(self,Var "LoadingScreen")
end;
t[#t+1] = Def.ActorFrame {
	Name="ArcadeOverlay.Text";
	InitCommand=function(self)
		ActorUtil.LoadAllCommandsAndSetXY(self,Var "LoadingScreen")
	end;
	LoadFont("_shared2") .. {
		InitCommand=function(self)
			self:shadowlength(1);
			self:zoom(0.65);
			self:diffuseshift();
			self:effectperiod(0.4);
			self:effectcolor1(color("1,0.6,0.9,1"));
			self:effectcolor2(color("1,0.3,0.4,1"));
			self:strokecolor(Color("Black"));
		end;
		--Text="TESTING";
		OnCommand=function(self)
			self:playcommand("Refresh");
		end;
		CoinInsertedMessageCommand=function(self)
			self:playcommand("Refresh");
		end;
		CoinModeChangedMessageCommand=function(self)
			self:playcommand("Refresh");
		end;
		RefreshCommand=function(self)
			local bCanPlay = GAMESTATE:EnoughCreditsToJoin();
			local bReady = GAMESTATE:GetNumSidesJoined() > 0;
			if bCanPlay or bReady then
				self:settext(THEME:GetString("ScreenTitleJoin","HelpTextJoin"));
			else
				self:settext(THEME:GetString("ScreenTitleJoin","HelpTextWait"));
			end
		end;
	};
};
return t
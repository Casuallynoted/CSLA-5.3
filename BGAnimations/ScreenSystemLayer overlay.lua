--20160420
local function CreditsText( pn )
	local text = LoadFont(Var "LoadingScreen","credits") .. {
		InitCommand=function(self)
			self:name("Credits" .. PlayerNumberToString(pn))
			ActorUtil.LoadAllCommandsAndSetXY(self,Var "LoadingScreen");
		end;
		UpdateTextCommand=function(self)
			local str = ScreenSystemLayerHelpers.GetCreditsMessage(pn);
			if string.find(str,THEME:GetString("ScreenSystemLayer","CreditsCredits"),1,true) then
				self:settext("");
			else self:settext(str);
			end;
			--self:settext(str);
		end;
		UpdateVisibleCommand=function(self)
			local screen = SCREENMAN:GetTopScreen();
			local bShow = true;
			if screen then
				local sClass = screen:GetName();
				bShow = THEME:GetMetric( sClass, "ShowCoinsAndCredits" );
			end

			self:visible( bShow );
		end
	};
	return text;
end;

local function CreditsCreditsText()
	local text = LoadFont(Var "LoadingScreen","credits") .. {
		InitCommand=function(self)
			self:name("CreditsCredits")
			ActorUtil.LoadAllCommandsAndSetXY(self,Var "LoadingScreen");
		end;
		UpdateTextCommand=function(self)
			local pay = GAMESTATE:GetCoinMode() == 'CoinMode_Pay';
			if pay then
				self:visible(true);
			else self:visible(false);
			end;
			
			local coin = GAMESTATE:GetCoins();
			local creditsstr = THEME:GetString("ScreenSystemLayer","CreditsCredits");
			local max = THEME:GetString("ScreenSystemLayer","CreditsMax");
			local pcoins = tonumber(PREFSMAN:GetPreference("CoinsPerCredit"));
			local ccredit = 0;
			local ccoin = 0;
			if pcoins > 1 then
				if coin >= pcoins then
					ccredit = math.floor(coin / pcoins);
					ccoin = coin % pcoins;
				else ccoin = coin;
				end;
				creditsstr = creditsstr.." : "..ccredit.." - "..ccoin.."/"..pcoins;
			else
				ccredit = coin;
				creditsstr = creditsstr.." : "..coin;
			end;
			if ccredit >= 20 then
				creditsstr = creditsstr.." "..max;
			end;
			self:settext(creditsstr);
		end;
	};
	return text;
end;

local t = Def.ActorFrame {};

-- Aux
--t[#t+1] = LoadActor(THEME:GetPathB("ScreenSystemLayer","aux"));

-- Credits
t[#t+1] = Def.ActorFrame {
 	CreditsText( PLAYER_1 );
	CreditsText( PLAYER_2 );
	CreditsCreditsText();
};

-- Text
t[#t+1] = Def.ActorFrame {
	Def.ActorFrame {
		Def.Quad {
			InitCommand=function(self)
				self:zoomtowidth(SCREEN_WIDTH);
				self:zoomtoheight(50);
				self:horizalign(left);
				self:vertalign(top,SCREEN_TOP);
				self:diffuse(color("0,0,0,0"));
			end;
			OnCommand=function(self)
				self:finishtweening();
				self:linear(0.4);
				self:diffuse(color("0,0,0,0.65"));
				self:diffusebottomedge(color("0,0,0,0"));
			end;
			OffCommand=function(self)
				self:sleep(3);
				self:linear(0.5);
				self:diffusealpha(0);
			end;
		};
		LoadFont(Var "LoadingScreen","SystemMessage") .. {
			Name="Text";
			InitCommand=function(self)
				self:maxwidth(SCREEN_WIDTH*1.5-10);
				self:horizalign(left);
				self:vertalign(top);
				self:zoom(0.75);
				self:x(SCREEN_LEFT+10);
				self:y(SCREEN_TOP+10);
				--self:shadowlength(2);
				self:strokecolor(color("0,0,0,1"));
				self:diffusealpha(0);
			end;
			OnCommand=function(self)
				--20160420
				--[ja] ネット接続時のステータス表示・Event Mode設定
				if self:GetText() == THEME:GetString("NetworkSyncManager","Connection failed.") or 
				self:GetText() == THEME:GetString("NetworkSyncManager","Connection to server dropped.") or
				self:GetText() == THEME:GetString("ScreenNetworkOptions","Disconnected from server.") then 
					MESSAGEMAN:Broadcast("NetConnectionFailed");
				elseif self:GetText() == string.format( THEME:GetString("NetworkSyncManager","Connection to '%s' successful."), GetServerName()) then 
					MESSAGEMAN:Broadcast("NetConnectionSuccess");
				end;
				self:finishtweening();
				self:linear(0.5);
				self:diffusealpha(1);
			end;
			OffCommand=function(self)
				local scf = {"None","Prof_Prof",0,{{0,0,0,0,0},{0,0,0,0,0}},{0,0,0,0,0},"Default"};
				s_envcheck(scf);
				--20170902
				--[ja] EDITデータを変更して保存したか
				--Trace("Question: "..screen:GetChild("Question"):GetText());
				if self:GetText() == THEME:GetString("ScreenEdit","Save successful.") or 
				self:GetText() == THEME:GetString("ScreenEdit","Saved as SM and DWI.") or 
				self:GetText() == THEME:GetString("ScreenEdit","Saved as SM.") or 
				self:GetText() == THEME:GetString("ScreenEdit","Autosave successful.") then
					Trace("sloadcheckflag: 2");
					scf[3] = 1;
					scf[5] = {1,1,1,1,1};
					setenv("sloadcheckflag",{scf[1],scf[2],scf[3],scf[4],scf[5],scf[6]});
				end;
				self:sleep(3);
				self:linear(0.4);
				self:diffusealpha(0);
			end;
		};
		SystemMessageMessageCommand = function(self, params)
			self:GetChild("Text"):settext( params.Message );
			self:playcommand( "On" );
			if params.NoAnimate then
				self:finishtweening();
			end
			self:playcommand( "Off" );
		end;
		HideSystemMessageMessageCommand = function(self)
			self:finishtweening();
		end;
	};
};

return t;

local t = LoadFallbackB();

--20160420
t[#t+1] = netstatecheck();

t[#t+1] = StandardDecorationFromFileOptional( "statusjoin","statusjoin" );

--[ja] グループカラー
SnamecolorSet("course");

t[#t+1] = Def.ActorFrame{
	OffCommand=function(self)
		for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
			local p = ( (pn == "PlayerNumber_P1") and 1 or 2 );
			local pstr = ProfIDSet(p);
			if not IsNetConnected() then
				--[ja] キャラクターセットフラグ
				local charaset = ProfIDPrefCheck("CharacterSet",pstr,"default,0");
				local chastr = split(",",charaset);
				SetAdhocPref("CharacterSet",chastr[1]..",1",pstr);
			end;
			CustomcolorSet(pstr);
		end;
	end;
};

return t;
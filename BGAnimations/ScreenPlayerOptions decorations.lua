local t = LoadFallbackB();

t[#t+1] = StandardDecorationFromFileOptional( "InfoStatusP1","InfoStatusP1" );
t[#t+1] = StandardDecorationFromFileOptional( "InfoStatusP2","InfoStatusP2" );
t[#t+1] = StandardDecorationFromFileOptional("TLDifficulty","TLDifficulty");
t[#t+1] = StandardDecorationFromFileOptional("SongInformation","SongInformation");

setenv("net_opback",0);

for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
	local p = ( (pn == "PlayerNumber_P1") and 1 or 2 );
	sc_change_rt_set(p,"sel");
	local pstr = ProfIDSet(p);
	local adgraph = ProfIDPrefCheck("ScoreGraph",pstr,"Off");
	--SCREENMAN:SystemMessage(getenv("scoregraphp"..p)..","..adgraph);
	local metrics_name = "PlayerNameplate" .. ToEnumShortString(pn);
	t[#t+1] = LoadActor( THEME:GetPathG(Var "LoadingScreen", "PlayerNameplate"), pn ) .. {
		InitCommand=function(self)
			self:name(metrics_name);
			ActorUtil.LoadAllCommandsAndSetXY(self,Var "LoadingScreen"); 
		end;
	};
	t[#t+1] = Def.ActorFrame{
		OffCommand=function(self)
			sc_change_rt_set(p,"op");
			--SCREENMAN:SystemMessage(getenv("scoregraphp"..p)..","..adgraph);
		end;
	};
end

return t;
local t = LoadFallbackB();

t[#t+1] = StandardDecorationFromFileOptional( "InfoStatusP1","InfoStatusP1" );
t[#t+1] = StandardDecorationFromFileOptional( "InfoStatusP2","InfoStatusP2" );

for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
	local metrics_name = "PlayerNameplate" .. ToEnumShortString(pn);
	t[#t+1] = LoadActor( THEME:GetPathG(Var "LoadingScreen", "PlayerNameplate"), pn ) .. {
		InitCommand=function(self)
			self:name(metrics_name);
			ActorUtil.LoadAllCommandsAndSetXY(self,Var "LoadingScreen"); 
		end;
	};
end

return t;
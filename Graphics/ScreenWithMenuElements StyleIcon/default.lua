
local t = {};

local style = GAMESTATE:GetCurrentStyle();
if style then
	local master_pn = GAMESTATE:GetMasterPlayerNumber();
	local st = style:GetName();
	local state = 0;
	local stf = "";
	
	if CurGameName() ~= "dance" then stf = CurGameName().."_";
	end;
	if st ~= "Versus" and st ~= "Couple" then
		state = master_pn == PLAYER_2 and 1 or 0
	end;

	return LoadActor(THEME:GetPathG("ScreenWithMenuElements","StyleIcon/"..stf..""..st))..{
		InitCommand=cmd(animate,false;setstate,state);
	};
else
	return Def.Actor {};
end

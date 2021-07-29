local pn = ...;
assert(pn);

local t = Def.ActorFrame {};

local Letters = {
	"&BACK;", "&OK;",
	"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M",
	"N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z",
	"0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "?", "!"	
}

local psetindex = {3,3};
local psetstring = {"",""};

t[#t+1] = Def.ActorFrame {
	MenuRightP1MessageCommand=function(self)
		if pn == PLAYER_1 and IsEnteringName then
			self:queuecommand("MoveRight");
		end
	end;
	MenuLeftP1MessageCommand=function(self)
		if pn == PLAYER_1 and IsEnteringName then
			self:queuecommand("MoveLeft");
		end
	end;
	MenuRightP2MessageCommand=function(self)
		if pn == PLAYER_2 and IsEnteringName then
			self:queuecommand("MoveRight");
		end
	end;
	MenuLeftP2MessageCommand=function(self)
		if pn == PLAYER_2 and IsEnteringName then
			self:queuecommand("MoveLeft");
		end
	end;
	MoveLeftCommand=function(self)
		if pn
	end;
};

return t;

--[[ Infostatus ]]
local pn = ...
assert(pn,"Must pass in a player, dingus");

local t = Def.ActorFrame{
	Name="Infostatus"..pn;
	BeginCommand=function(self)
		self:visible(GAMESTATE:IsHumanPlayer(pn));
	end;
	PlayerJoinedMessageCommand=function(self,param)
		if param.Player == pn then
			self:visible(true);
		end;
	end;
	PlayerUnjoinedMessageCommand=function(self,param)
		if param.Player == pn then
			self:visible(false);
		end;
	end;
};

t[#t+1] = Def.ActorFrame {};

t[#t+1] = Def.ActorFrame{
	LoadActor("help")..{
		OnCommand=cmd(cropbottom,1;cropleft,1;sleep,0.2;accelerate,0.4;cropbottom,0;cropleft,0;);
		OffCommand=cmd(stoptweening;);
	};
};

return t;
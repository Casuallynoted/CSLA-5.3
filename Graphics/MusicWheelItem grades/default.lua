-- This actor is duplicated.  Upvalues will not be duplicated.
local ac = 1;
if getenv("ReloadAnimFlag") == 1 then ac = 0;
end;
local drawindex = 0;
local grades = {
	Grade_Tier01 = 0;
	Grade_Tier02 = 0;
	Grade_Tier03 = 0;
	Grade_Tier04 = 0;
	Grade_Tier05 = 0;
	Grade_Tier06 = 0;
	Grade_Tier07 = 0;
	Grade_Failed = 0;
	Grade_None = nil;
};

local t = Def.ActorFrame{
	LoadActor(THEME:GetPathG("MusicWheelItem","grades/grades"))..{
		InitCommand=cmd(pause);
		OnCommand=cmd(linear,0.4;playcommand,"Flag";);
		FlagCommand=function(self) ac = 0;
		end;
		SetMessageCommand=function(self, params)
			drawindex = params.DrawIndex;
			local items = THEME:GetMetric( "MusicWheel","NumWheelItems" ) + 2;
			if ac == 1 then
if params.DrawIndex then
				if drawindex > math.floor(items / 2) then
					(cmd(addy,100;zoomx,0;decelerate,math.min(0.4,(items -1 - drawindex)*0.07);addy,-100;rotationz,0;zoomx,1;))(self)
				elseif drawindex < math.floor(items / 2) then
					(cmd(addy,100;zoomx,0;decelerate,math.min(0.4,drawindex*0.07);addy,-100;rotationz,0;zoomx,1;))(self)
				elseif drawindex == math.floor(items / 2) then
					(cmd(addy,-100;zoomy,0;decelerate,0.2;addy,100;zoomy,1;))(self)
				end;
end;
			end;
		end;
		SetGradeCommand=function(self, params)
			self:diffuse(color("1,1,1,1"));
			local state = grades[params.Grade];
			if state and getenv("rnd_song") == 0 then
				self:visible(true);
				--state = state*2;
				if params.PlayerNumber == PLAYER_2 then
					state = state+1;
				end
				
				if params.Grade == "Grade_Failed" then
					self:diffuse(color("0.55,0.55,0.55,1"));
				end;
				self:setstate(state);
				--setenv("setgrades", 1 );
			else
				self:visible(false);
				--setenv("setgrades", 0 );
			end;
		end;
		SectionSetRMessageCommand=cmd(stoptweening;cropleft,1;linear,0.1;cropleft,0;);
	};
};
return t;


-- (c) 2007 Glenn Maynard
-- All rights reserved.
-- 
-- Permission is hereby granted, free of charge, to any person obtaining a
-- copy of this software and associated documentation files (the
-- "Software"), to deal in the Software without restriction, including
-- without limitation the rights to use, copy, modify, merge, publish,
-- distribute, and/or sell copies of the Software, and to permit persons to
-- whom the Software is furnished to do so, provided that the above
-- copyright notice(s) and this permission notice appear in all copies of
-- the Software and that both the above copyright notice(s) and this
-- permission notice appear in supporting documentation.
-- 
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
-- OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
-- MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT OF
-- THIRD PARTY RIGHTS. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR HOLDERS
-- INCLUDED IN THIS NOTICE BE LIABLE FOR ANY CLAIM, OR ANY SPECIAL INDIRECT
-- OR CONSEQUENTIAL DAMAGES, OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS
-- OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
-- OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
-- PERFORMANCE OF THIS SOFTWARE.

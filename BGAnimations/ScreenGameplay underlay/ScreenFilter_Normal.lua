
local pn = ...;
assert(pn);

--local csize = split(",",ProfIDPrefCheck("CNoteSize",GetAdhocPref("ProfIDSet" .. ToEnumShortString(pn)),"New,0"))
 --[ja] Player.cpp 858～860行
local mlevel = GAMESTATE:IsCourseMode() and "ModsLevel_Stage" or "ModsLevel_Preferred";
local mini_set = GAMESTATE:GetPlayerState(pn):GetPlayerOptions(mlevel):Mini();
local tiny_set = GAMESTATE:GetPlayerState(pn):GetPlayerOptions(mlevel):Tiny();
if tiny_set == 1 then
	tiny_set = scale(mini_set,0.98,-1,0.5,1.5);
end;
local filterzoom = scale(mini_set+tiny_set,0.98,-1,0.5,1.5);
--SCREENMAN:SystemMessage(mini_set..","..tiny_set);
--[[
if csize[1] == "Old" and filterzoom < 0.99494 then
	mini_set = 1;
	tiny_set = 0;
	filterzoom = scale(filterzoom,0,1,1.5,1);
end;
]]
local overhead_set = GAMESTATE:GetPlayerState(pn):GetPlayerOptions(mlevel):Overhead();
local drunk_set = GAMESTATE:GetPlayerState(pn):GetPlayerOptions(mlevel):Drunk();
local tornado_set = GAMESTATE:GetPlayerState(pn):GetPlayerOptions(mlevel):Tornado();
local xmode_set = GAMESTATE:GetPlayerState(pn):GetPlayerOptions(mlevel):Xmode();
local cline = overhead_set and drunk_set == 0 and tornado_set == 0 and xmode_set == 0;

local t = Def.ActorFrame{};

local p = ( (pn == "PlayerNumber_P1") and 1 or 2 );
local pstr = ProfIDSet(p);
local filter = ProfIDPrefCheck("ScreenFilterV2",pstr,"Off,Black,Off");
local filters = split(",",filter);
local filter_v1 = ProfIDPrefCheck("ScreenFilter",pstr,"Off");
local one = tonumber(THEME:GetMetric("ArrowEffects","ArrowSpacing"));
local cp = tonumber(GAMESTATE:GetCurrentStyle():ColumnsPerPlayer());
local diffusea = 0;
local ldiffusea = 0;
local child;
if tonumber(filters[1]) then
	diffusea = filters[1];
end;
function DarkColor( color ) 
	local c = color
	return { c[1]*0.6, c[2]*0.6, c[3]*0.6, c[4] }
end

t[#t+1] = Def.Quad{
	Name="Filter";
	InitCommand=function(self)
		self:visible(false);
		self:x(GetPosition(pn));
		self:zoomto((ColumnChecker()*filterzoom)+scale(mini_set+tiny_set,0.98,-1,20,70),SCREEN_HEIGHT);
		self:fadeleft(1/32);
		self:faderight(1/32);
		(cmd(y,SCREEN_CENTER_Y;))(self)
	end;
	OffCommand=cmd(stoptweening;);
};

if CurGameName() == "dance" and filters[3] and cline then
	if filters[3] ~= "Off" then
		ldiffusea = diffusea + 0.35;
		for l = 0, cp do
			t[#t+1] = Def.Quad{
				Name="Line"..l+1;
				InitCommand=function(self)
					local xset = GetPosition(pn) - ((ColumnChecker()*filterzoom) / 2) + ((one * filterzoom) * l); 
					self:visible(false);
					self:x(xset);
					self:zoomto(scale(mini_set+tiny_set,0.98,-1,1,2),SCREEN_HEIGHT);
					if l == 0 or l == cp then
						if l == 0 then
							self:x(xset - 2);
						elseif l == cp then
							self:x(xset + 2);
						end;
						self:zoomto(scale(mini_set+tiny_set,0.98,-1,2,5),SCREEN_HEIGHT);
					end;
					self:y(SCREEN_CENTER_Y);
				end;
				OffCommand=cmd(stoptweening;);
			};
		end;
	end;
end;

t.InitCommand=function(self)
	child = self:GetChildren();
	self:playcommand("Check");
end;

t.CheckCommand=function(self)
	self:stoptweening();
	local song = GAMESTATE:GetCurrentSong();
	local start = 0;
	local last = 0;
	if song then
		start = song:GetFirstBeat();
		last = song:GetLastBeat();
	end;
	local now = 0;
	now = GAMESTATE:GetSongBeat();
	for i, cat in pairs(child) do
		if (now >= start-8) and (now <= last) then
			if child[i]:GetName() == "Filter" then
				if filters[2] == "Black" or filters[2] == "White" then
					child[i]:diffuse(Color(filters[2]));
				else child[i]:diffuse(DarkColor(Color(filters[2])));
				end;
			else
				child[i]:diffuse(Color["White"]);
				if filters[2] == "White" then
					child[i]:diffuse(Color["Black"]);
				end;
			end;
			if tonumber(filters[1]) then
				diffusea = filters[1];
				child[i]:visible(true);
				if child[i]:GetName() == "Filter" then
					child[i]:diffusealpha(filters[1]);
				else child[i]:diffusealpha(math.min(1,ldiffusea));
				end;
			else
				if not filter then
					if tonumber(filter_v1) then
						child[i]:visible(true);
						child[i]:diffusealpha(filter_v1);
					end;
				end;
			end;
		else
			child[i]:visible(false);
			child[i]:diffusealpha(0);
		end;
	end;
	self:sleep(0.1);
	self:queuecommand("Check");
end;

return t;

--[[ScreenSelectAvatar overlay]]

--[ja] ここでリロードしないとライバル反映されない
THEME:ReloadMetrics();

local t = Def.ActorFrame {
};

local profile= GAMESTATE:GetEditLocalProfile();
local profile_id= GAMESTATE:GetEditLocalProfileID();

local key_open = 0;
local tpwidth = 240;
local space = 72;
local rsetnum = 5;
local curIndex = 1;

local cset = {};
local csetdir = {};
local csetstr = "";
local count = 2;
--local mpn = GAMESTETE:GetMasterPlayerNumber() == PLAYER_1 and 1 or 2;
cset[1] = "Off";
csetdir[1] = "Off";
for i=1, #extension do
	local commonfile = FILEMAN:GetDirListing( THEME:GetCurrentThemeDirectory()..
						"BGAnimations/ScreenSelectAvatar overlay/_avatar_image/*."..extension[i] );
	local prof_file = FILEMAN:GetDirListing( PROFILEMAN:LocalProfileIDToDir(profile_id).."CSAvatar."..extension[i] );
	if #commonfile > 0 then
		for j=1, #commonfile do
			if commonfile[j] then
				cset[count] = commonfile[j]
				csetdir[count] = THEME:GetCurrentThemeDirectory()..
						"BGAnimations/ScreenSelectAvatar overlay/_avatar_image/"..commonfile[j];
				if csetdir[count] == ProfIDPrefCheck("ProfAvatar",profile_id,"Off") then
					curIndex = count;
				end;
				count = count + 1;
			end;
		end;
	end;
	if #prof_file > 0 then
		for k=1, #prof_file do
			if prof_file[k] then
				cset[count] = prof_file[k]
				csetdir[count] = PROFILEMAN:LocalProfileIDToDir(profile_id)..""..prof_file[k];
				if csetdir[count] == ProfIDPrefCheck("ProfAvatar",profile_id,"Off") then
					curIndex = count;
				end;
				count = count + 1;
			end;
		end;
	end;
end;

--[[
for m=1,#cset do
	csetstr = table.concat(cset,",");
end;
local name = {}
do
	local csets = split(",", csetstr);
	for k, av in ipairs(csets) do
		local dname = av
		local exst = -5
		if string.find(av,".jpeg") then exst = -6
		end;
		if string.find(av,"(doubleres)") then exst = exst - 12
		end;
		dname = string.sub(av,1,exst)
		if string.len(av) > 15 then
			dname = string.sub(av,1,15).." ..."
		end;
		name[k] = dname
	end
end;
]]

function GetAvatar()
	local t = {};

	for x = 1,#cset do
		local opdCard = Def.ActorFrame {
--[[
			LoadFont("_shared2") .. {
				Text= name[x];
				InitCommand=cmd(horizalign,left;maxwidth,150;x,30;zoom,0.8;strokecolor,Color("Black"););
			};
]]
			Def.Sprite{
				InitCommand=function(self)
					self:visible(false);
					if csetdir[x] ~= "Off" and FILEMAN:DoesFileExist(csetdir[x]) then 
						self:visible(true);
						self:Load(csetdir[x]);
					end;
					(cmd(scaletofit,0,0,60,60;x,0;y,0;))(self)
				end;
			};
			Def.Quad{
				InitCommand=function(self)
					self:visible(false);
					if csetdir[x] == "Off" then
						self:visible(true);
						self:diffuse(color("0.5,0.5,0.5,0.65"));
					end;
					(cmd(zoomto,60,60;))(self)
				end;
			};
			LoadFont("_shared2") .. {
				Text= "Off";
				InitCommand=function(self)
					self:visible(false);
					if csetdir[x] == "Off" then 
						self:visible(true);
					end;
					(cmd(maxwidth,66;zoom,0.8;strokecolor,Color("Black");))(self)
				end;
			};
		};
		t[#t+1]=opdCard;
	end;
	
	return t
end;

local xwideset = WideScale(SCREEN_CENTER_X+180,SCREEN_CENTER_X+210);
t[#t+1] = Def.Quad{
	InitCommand=cmd(Center;zoomto,SCREEN_WIDTH,SCREEN_HEIGHT;diffuse,color("0,0,0,0.5"););
	OnCommand=cmd(diffusealpha,0;decelerate,0.15;diffusealpha,0.5;);
};

t[#t+1] = Def.ActorFrame {
	InitCommand=cmd(visible,true;x,xwideset;y,SCREEN_CENTER_Y;);
	Def.Quad{
		InitCommand=cmd(zoomto,84,SCREEN_HEIGHT;diffuse,color("0,0,0,0.65"););
		OnCommand=cmd(diffusealpha,0;croptop,1;decelerate,0.15;diffusealpha,0.65;croptop,0;);
	};
	Def.Quad{
		InitCommand=cmd(zoomto,84,72;diffuse,color("1,0.2,0,0.8");fadetop,0.1;fadebottom,0.1;);
		OnCommand=cmd(cropleft,1;accelerate,0.2;cropleft,0;);
	};
};

t[#t+1] = Def.ActorFrame {
	InitCommand=cmd(x,xwideset;);
	Def.ActorScroller{
		Name = 'Scroller';
		NumItemsToDraw=10;
		OnCommand=function(self)
			self:clearzbuffer(true);
			self:zwrite(true);
			self:zbuffer(true);
			self:ztest(true);
			self:z(0);
			(cmd(y,SCREEN_CENTER_Y+72;SetFastCatchup,true;SetSecondsPerItem,0.15;SetDestinationItem,curIndex;))(self)
		end;
		TransformFunction=function(self, offset, itemIndex, numItems)
			self:visible(false);
			self:x(0);
			self:y(math.floor( offset*space ));
		end;
		DirectionButtonMessageCommand=function(self, params)
			self:SetDestinationItem( curIndex );
		end;
		children = GetAvatar();
	};
};

t[#t+1] = Def.ActorFrame {
	-- sounds
	LoadActor( THEME:GetPathS("MusicWheel","expand") )..{
		ExpandButtonMessageCommand=cmd(play);
	};
};

--20160417
function inputs(event)
	local button = event.GameButton
	if key_open == 0 then
		if button == 'MenuUp' or button == 'MenuLeft' then
			if curIndex > 1 then
				if event.type ~= "InputEventType_Release" then
					curIndex = curIndex - 1;
					MESSAGEMAN:Broadcast("DirectionButton");
				end;
			end;
		end;
		if button == 'MenuDown' or button == 'MenuRight' then
			if curIndex < #cset then
				if curIndex > 0 then
					if event.type ~= "InputEventType_Release" then
						curIndex = curIndex + 1;
						MESSAGEMAN:Broadcast("DirectionButton");
					end;
				end;
			end;
		end;
		if event.type == "InputEventType_FirstPress" then
			if button == 'Start' or button == 'Center' then
				key_open = 1;
				if ProfIDPrefCheck("ProfAvatar",profile_id,"Off") ~= csetdir[curIndex] then
					SetAdhocPref("ProfAvatar",csetdir[curIndex],profile_id );
				end;
				MESSAGEMAN:Broadcast("StartButton",{State = "AvatarSet"});
				SCREENMAN:GetTopScreen():PostScreenMessage('SM_GoToNextScreen',0.5);
			end;
			if button == "Back" then
				key_open = 1;
				SOUND:PlayOnce(THEME:GetPathS("_Screen","cancel"));
				SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToPrevScreen");
			end;
		end;
		--SCREENMAN:SystemMessage(getenv("opst")[1].." : "..getenv("opst")[2]);
	end;
end;
t[#t+1] = Def.ActorFrame {
	OnCommand=function(self)
		SCREENMAN:GetTopScreen():lockinput(0.25);
		SCREENMAN:GetTopScreen():AddInputCallback(inputs);
	end;
};

return t;
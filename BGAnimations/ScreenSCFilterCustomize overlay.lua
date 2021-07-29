
function GetXmlTag(path,section,getdata)
	local gpath;
	if FILEMAN:DoesFileExist(path) then
		gpath = path;
	else return "";
	end;
	local f = RageFileUtil.CreateRageFile();
	f:Open(gpath,1);
	if not f then
		return "";
	end;
	local sc = section;
	if not section then
		sc = "GeneralData";
	end;
	local scl = string.lower(sc);
	local l;
	local ll;
	local lll;
	local pstr = "";
	local checkf = false;
	local checkr = false;
	local gdsl;
	local gds;
	local linenum = 0;
	if getdata then
		gdsl = string.lower(getdata);
		gds = split(",",gdsl);
		f:Seek(0);
		while true do
			local l = f:GetLine();
			local ll = string.lower(l);
			if string.find(ll,"^<"..scl..">") then
				checkf = true;
			else linenum = linenum + 1;
			end;
			if checkf then
				if string.find(ll,"^</"..scl..">") then
					checkr = true;
					break;
				end;
			end;
			if (checkf and checkr) or f:AtEOF() then
				break;
			end;
		end;

		if checkf and checkr then
			f:Seek(linenum);
			while true do
				local l = f:GetLine();
				local ll = string.lower(l);
				for i=1,#gds do
					if string.find(ll,"^<"..gds[i]..">") then
						lll = string.gsub(ll,"<"..gds[i]..">","");
						pstr = string.gsub(lll,"</"..gds[i]..">","");
						break;
					end;
				end;
				if pstr ~= "" or f:AtEOF() then
					break;
				end;
			end;
		end;
	end;
	f:Close();
	f:destroy();
	return pstr;
end;
--------------------------------------------------------------------------------------------
local profile= GAMESTATE:GetEditLocalProfile()
local profile_id= GAMESTATE:GetEditLocalProfileID();

local nstable = NOTESKIN:GetNoteSkinNames();
local sttable = {
	dance = 'StepsType_Dance_Single',
	pump = 'StepsType_Pump_Single',
};
if vcheck() == "5_2_0" then
	nstable = NEWSKIN:get_skin_names_for_stepstype(sttable[CurGameName()]);
end;
local cnoteskin = "default";
local noteset = ProfIDPrefCheck("NoteSkinSet",profile_id,"default,0");
local notstr = split(",",noteset);
if tonumber(notstr[2]) == 1 then
	if cnoteskin ~= notstr[1] then 
		cnoteskin = notstr[1];
	end;
else
	local profilefile = PROFILEMAN:LocalProfileIDToDir(profile_id).."Stats.xml";
	local defaultmod = PREFSMAN:GetPreference('DefaultModifiers');
	if vcheck() ~= "5_2_0" then
		if GetXmlTag( profilefile,"GeneralData","DefaultModifiers,"..CurGameName() ) ~= "" then
			defaultmod = GetXmlTag( profilefile,"GeneralData","DefaultModifiers,"..CurGameName() );
		end;
	else
		defaultmod = profile:get_preferred_noteskin(sttable[CurGameName()]);
	end;
	local dnmods = split(", ",defaultmod);
	for m=1,#dnmods do
		local check = false;
		for n=1,#nstable do
			if dnmods[m] == nstable[n] then
				cnoteskin = dnmods[m];
				check = true;
				break;
			end;
		end;
		if check then break;
		end;
	end;
end;
--SCREENMAN:SystemMessage(GetXmlTag(profilefile,"GeneralData","DefaultModifiers,dance"));

local filter = ProfIDPrefCheck("ScreenFilterV2",profile_id,"Off,Black,Off");
local filters = split(",",filter);
local filter_v1 = ProfIDPrefCheck("ScreenFilter",profile_id,"Off");
local position = math.floor(scale((2.28/3),0,1,SCREEN_LEFT,SCREEN_RIGHT));
local aystandard = THEME:GetMetric("Player","ReceptorArrowsYStandard");
local one = tonumber(THEME:GetMetric("ArrowEffects","ArrowSpacing"));
local arrowx = {
	dance = {
		Left  = -96,
		Down  = -32,
		Up    = 32,
		Right = 96,
	},

	pump = {
		DownLeft = -100,
		UpLeft = -50,
		Center = 0,
		UpRight = 50,
		DownRight = 100,
	},
};

local t = Def.ActorFrame{};

--20160418
local arrows = Def.ActorFrame{
	Name = "Arrows";
	InitCommand=cmd(x,position;y,(SCREEN_CENTER_Y+aystandard));
	OnCommand=cmd(diffusealpha,0;sleep,0.25;linear,0.25;diffusealpha,1);
};

local lnote = "Receptor";
if CurGameName() == "pump" then
	lnote = "Ready Receptor";
end;

local tnote = "Tap Note";
if CurGameName() == "pump" then
	tnote = "Tap Note";
end;

local arrowy4th = 64;
--local arrowy8th = 32;
local tmpnote = 0;
local tempnt = 0;

if vcheck() ~= "5_2_0" then
	for nt=1,#nstable do
		if tempnt ~= nt then
			tempnt = nt;
			tmpnote = 0;
		end;
		for button,location in pairs( arrowx[ CurGameName() ] ) do
			if not NOTESKIN:GetPathForNoteSkin( button, lnote, nstable[nt] ) then
				cnoteskin = "default";
			end;
			arrows[#arrows+1] = NOTESKIN:LoadActorForNoteSkin( button, lnote, nstable[nt] )..{
				InitCommand=function(self)
					self:x(location);
					self:visible(false);
					if nstable[nt] == cnoteskin then
						self:visible(true);
					end;
				end;
				DirectionButtonMessageCommand=function(self,param)
					self:visible(false);
					if nstable[nt] == param.NoteSkin then
						self:visible(true);
					end;
				end;
			};

			arrows[#arrows+1] = NOTESKIN:LoadActorForNoteSkin( button, tnote, nstable[nt] )..{
				InitCommand=function(self)
					self:x(location);
					if tempnt ~= nt then
						tempnt = nt;
						tmpnote = 0;
					else tmpnote = tmpnote +1;
					end;
					self:y(one+(arrowy4th*tmpnote));
					self:visible(false);
					if nstable[nt] == cnoteskin then
						self:visible(true);
					end;
				end;
				DirectionButtonMessageCommand=function(self,param)
					self:visible(false);
					if nstable[nt] == param.NoteSkin then
						self:visible(true);
					end;
				end;
			};
		end;
	end;
	--[[
	t.DirectionButtonMessageCommand=function(self,param)
		SCREENMAN:SystemMessage(param.NoteSkin);
	end;
	]]
	t[#t+1] = arrows;
end;

local lrcheck = true;
local basex = 150;
local basey = SCREEN_CENTER_Y-30;
local basespace = 40;
local key_open = 0;
local space = 138;
local rsetnum = 5;
local curIndex = {1,1,1,1,1,1};	--thindex,noteskin,alpha,color,line,cursorflag
local xwideset = WideScale(SCREEN_CENTER_X-180,SCREEN_CENTER_X-210);

local alltable = {
	{
		Name = "NoteSkin",
		Num = 1,
		Set = nstable,
		Acsettable = {},
	},
	{
		Name = "Alpha",
		Num = 2,
		Set = {"Off","25%","50%","75%","100%"},
		Acsettable = {0,0.25,0.5,0.75,1},
	},
	{
		Name = "Color",
		Num = 3,
		Set = {"Black","White","Blue","Green","Yellow","Orange","Purple"},
		Acsettable = {},
	},
	{
		Name = "Line",
		Num = 4,
		Set = {"Off","On"},
		Acsettable = {},
	},
	{
		Name = "exit",
		Num = 5,
		Set = {},
		Acsettable = {},
	}
};
if CurGameName() == "pump" then
	alltable[5].Num = 4;
	table.remove(alltable,4);
end;

function SetT(num)
	local sett = {};

	for x = 1,#alltable[num].Set do
		local ss = Def.ActorFrame {
			LoadFont("Common Normal") .. {
				InitCommand=cmd(playcommand,"Set";);
				SetCommand=function(self)
					self:shadowlength(2);
					--self:settext("aaaaaaaaaaaaaaaaaaaaaaaaaaaa");
					self:settext(alltable[num].Set[x]);
					if num == 1 then
						self:strokecolor(Color("Black"));
						if cnoteskin then
							if cnoteskin == alltable[num].Set[x] then
								curIndex[num+1] = x;
							end;
						end;
					elseif num == 2 then
						self:strokecolor(Color("Black"));
						if GetAdhocPref("ScreenFilterV2",profile_id) then
							if tonumber(filters[num-1]) == alltable[num].Acsettable[x] then
								curIndex[num+1] = x;
							end;
						else
							if filter_v1 ~= "Off" then
								if tonumber(filter_v1) == alltable[num].Acsettable[x] then
									curIndex[num+1] = x;
								end;
							end;
						end;
					elseif num == 3 then
						if GetAdhocPref("ScreenFilterV2",profile_id) then
							if filters[num-1] == alltable[num].Set[x] then
								curIndex[num+1] = x;
							end;
						end;
						self:diffuse(Color[alltable[num].Set[x]]);
						if alltable[num].Set[x] == "Black" or alltable[num].Set[x] == "Purple" then
							self:strokecolor(Color("White"));
						else self:strokecolor(Color("Black"));
						end;
					elseif CurGameName() == "dance" and num == 4 then
						self:strokecolor(Color("Black"));
						if GetAdhocPref("ScreenFilterV2",profile_id) then
							if filters[num-1] == alltable[num].Set[x] then
								curIndex[num+1] = x;
							end;
						end;
					end;
					(cmd(horizalign,left;maxwidth,160;x,basex;y,-7;zoom,0.8;))(self)
				end;
			};
		};
		sett[#sett+1]=ss;
	end;

	return sett
end;

t[#t+1] = Def.ActorFrame {
	Def.Quad{
		Name="Cursor";
		InitCommand=function(self)
			local yset = 0;
			if curIndex[1] == 1 then
				yset = 50;
			end;
			(cmd(horizalign,left;y,basey+(basespace*(curIndex[1]-1)-4)-yset;diffuse,color("1,0.5,0,0.5");
			diffuserightedge,color("1,1,0,0");zoomtowidth,SCREEN_WIDTH*0.525;zoomtoheight,20;))(self)
		end;
		DirectionButtonMessageCommand=function(self)
			local yset = 0;
			if curIndex[1] == 1 then
				yset = 50;
			end;
			self:finishtweening();
			self:linear(0.1);
			self:y(basey+(basespace*(curIndex[1]-1)-4)-yset);
		end;
	};
};

t[#t+1] = Def.ActorFrame {
	InitCommand=cmd(x,xwideset;);
	Def.Quad{
		Name="LeftMask";
		InitCommand=cmd(x,8;y,SCREEN_CENTER_Y;zoomto,SCREEN_WIDTH,SCREEN_HEIGHT;horizalign,right;clearzbuffer,true;zwrite,true;blend,Blend.NoEffect;);
	};

	Def.Quad{
		Name="RightMask";
		InitCommand=cmd(x,144;y,SCREEN_CENTER_Y;zoomto,SCREEN_WIDTH,SCREEN_HEIGHT;horizalign,left;clearzbuffer,false;zwrite,true;blend,Blend.NoEffect;);
	};
};

t[#t+1] = LoadFont("Common Normal") .. {
	InitCommand=cmd(x,xwideset-120;y,basey;shadowlength,2;);
	OnCommand=function(self)
		local Title = THEME:GetString( Var "LoadingScreen" , "ScreenFilter" );
		self:settext(Title);
		--self:settext("aaaaaaaaaaaaaaaaaaaaaaaaaaaa");
		(cmd(horizalign,left;maxwidth,320;zoom,0.8;))(self)
		self:diffuse(color("1,0.65,0,1"));
		self:strokecolor(Color("Black"));
	end;
};

for idx, cat in pairs(alltable) do
	t[#t+1] = Def.ActorFrame {
		InitCommand=function(self)
			local yset = 0;
			if cat.Num == 1 then
				yset = 50;
			end;
			(cmd(x,xwideset;y,basey+((cat.Num-1)*basespace)-yset;))(self)
		end;
		LoadActor(THEME:GetPathG("EditMenu","left"))..{
			InitCommand=cmd(x,-4;y,-4;shadowlength,2;);
			OnCommand=cmd(playcommand,"Set";);
			SetCommand=function(self)
				--self:animate(false);
				self:visible(false);
				if cat.Name ~= "exit" and curIndex[1] == cat.Num then
					self:visible(true);
					if curIndex[cat.Num+1] <= 1 then
						--self:animate(false);
						self:glow(color("0,0,0,0.5"));
					else
						--self:animate(true);
						self:glow(color("0,0,0,0"));
					end;
				end;
			end;
			DirectionButtonMessageCommand=cmd(playcommand,"Set";);
		};
		LoadActor(THEME:GetPathG("EditMenu","right"))..{
			InitCommand=cmd(x,156;y,-4;shadowlength,2;);
			OnCommand=cmd(playcommand,"Set";);
			SetCommand=function(self)
				--self:animate(false);
				self:visible(false);
				if cat.Name ~= "exit" and curIndex[1] == cat.Num then
					self:visible(true);
					if curIndex[cat.Num+1] >= #cat.Set then
						--self:animate(false);
						self:glow(color("0,0,0,0.5"));
					else
						--self:animate(true);
						self:glow(color("0,0,0,0"));
					end;
				end;
			end;
			DirectionButtonMessageCommand=cmd(playcommand,"Set";);
		};
		
		LoadFont("Common Normal") .. {
			InitCommand=cmd(shadowlength,2;x,-120);
			OnCommand=function(self)
				local Title = THEME:GetString( Var "LoadingScreen" , cat.Name );
				self:settext(Title);
				--self:settext("aaaaaaaaaaaaaaaaaaaaaaaaaaaa");
				(cmd(horizalign,left;maxwidth,120;y,-7;zoom,0.8;))(self)
				if cat.Name == "exit" then
					self:diffuse(color("0,1,1,1"));
					self:strokecolor(ColorDarkTone(color("1,0.5,0,1")));
				else
					self:diffuse(color("1,0.65,0,1"));
					self:strokecolor(Color("Black"));
				end;
			end;
		};

		Def.ActorScroller{
			Name = 'Scroller'..cat.Name;
			NumItemsToDraw=3;
			InitCommand=function(self)
				self:clearzbuffer(true);
				self:zwrite(true);
				self:zbuffer(true);
				self:ztest(true);
				self:z(0);
				(cmd(SetFastCatchup,true;SetSecondsPerItem,0.001;SetDestinationItem,curIndex[cat.Num+1];))(self)
			end;
			TransformFunction=function(self, offset, itemIndex, numItems)
				self:visible(false);
				self:x(math.floor( offset*space ));
				self:y(0);
			end;
			DirectionButtonMessageCommand = function(self, params)
				self:SetDestinationItem( curIndex[cat.Num+1] );
			end;
			children = SetT(cat.Num);
		};
	};
end;

t[#t+1]=LoadFont("_shared2") .. {
	InitCommand=function(self)
		self:settext( profile:GetDisplayName() );
		(cmd(horizalign,left;x,SCREEN_LEFT+60;y,SCREEN_TOP+70;maxwidth,250;zoom,0.9;strokecolor,Color("Black");))(self)
	end;
};

--[[
	t[#t+1] = LoadFont("Common Normal") .. {
		Text= #arrows;
		InitCommand=function(self)
			(cmd(maxwidth,150;x,82;y,100;zoom,0.8;))(self)
			self:diffuse(Color("White"));
			self:strokecolor(Color("Black"));
		end;
		DirectionButtonMessageCommand=function(self)
			self:settext(#arrows);
		end;
	};
]]

t[#t+1] = Def.ActorFrame {
	OffCommand=cmd(sleep,5);
	-- sounds
	LoadActor( THEME:GetPathS("MusicWheel","expand") )..{
		ExpandButtonMessageCommand=cmd(play);
	};
};

--20160417
function inputs(event)
	local button = event.GameButton
	if key_open == 0 then
		if event.type ~= "InputEventType_Release" then
			if button == 'MenuLeft' or button == 'MenuRight' then
				if button == 'MenuLeft' then
					if curIndex[alltable[curIndex[1]].Num+1] > 1 then
						if curIndex[alltable[curIndex[1]].Num+1] <= #alltable[curIndex[1]].Set then
							curIndex[alltable[curIndex[1]].Num+1] = curIndex[alltable[curIndex[1]].Num+1] - 1;
							SOUND:PlayOnce(THEME:GetPathS("_common","value"));
						end;
					end;
				end;
				if button == 'MenuRight' then
					if curIndex[alltable[curIndex[1]].Num+1] > 0 then
						if curIndex[alltable[curIndex[1]].Num+1] < #alltable[curIndex[1]].Set then
							curIndex[alltable[curIndex[1]].Num+1] = curIndex[alltable[curIndex[1]].Num+1] + 1;
							SOUND:PlayOnce(THEME:GetPathS("_common","value"));
						end;
					end;
				end;
				MESSAGEMAN:Broadcast("DirectionButton",
				{NoteSkin = alltable[1].Set[curIndex[2]],Alpha = alltable[2].Acsettable[curIndex[3]],Ccolor = alltable[3].Set[curIndex[4]],Cline = alltable[4].Set[curIndex[5]]});
			end;
			if button == 'MenuDown' or button == 'MenuUp' then
				if button == 'MenuDown' then
					if alltable[curIndex[1]].Num >= 1 and alltable[curIndex[1]].Num < #alltable then
						curIndex[1] = alltable[curIndex[1]].Num + 1;
						SOUND:PlayOnce(THEME:GetPathS("_common","row"));
					end;
				end;
				if button == 'MenuUp' then
					if alltable[curIndex[1]].Num > 1 and alltable[curIndex[1]].Num <= #alltable then
						curIndex[1] = alltable[curIndex[1]].Num - 1;
						SOUND:PlayOnce(THEME:GetPathS("_common","row"));
					end;
				end;
				MESSAGEMAN:Broadcast("DirectionButton",
				{NoteSkin = alltable[1].Set[curIndex[2]],Alpha = alltable[2].Acsettable[curIndex[3]],Ccolor = alltable[3].Set[curIndex[4]],Cline = alltable[4].Set[curIndex[5]]});
			end;
		end;
		if event.type == "InputEventType_FirstPress" then
			if alltable[curIndex[1]].Name == "exit" then
				if button == 'Start' or button == 'Center' then
					key_open = 1;
					MESSAGEMAN:Broadcast("StartButton");
					SOUND:PlayOnce(THEME:GetPathS("Common","start"));
					SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToNextScreen");
					SetAdhocPref("NoteSkinSet",alltable[1].Set[curIndex[2]]..",1",profile_id);
					if CurGameName() == "dance" then
						SetAdhocPref("ScreenFilterV2",alltable[2].Acsettable[curIndex[3]]..","..alltable[3].Set[curIndex[4]]..","..alltable[4].Set[curIndex[5]],profile_id);
					else SetAdhocPref("ScreenFilterV2",alltable[2].Acsettable[curIndex[3]]..","..alltable[3].Set[curIndex[4]]..","..filters[3],profile_id);
					end;
				end;
			end;
			if button == "Back" then
				key_open = 1;
				MESSAGEMAN:Broadcast("BackButton");
				SOUND:PlayOnce(THEME:GetPathS("_Screen","cancel"));
				SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToPrevScreen");
			end;
		end;
	end;
end;
t[#t+1] = Def.ActorFrame {
	OnCommand=function(self)
		SCREENMAN:GetTopScreen():lockinput(0.5);
		SCREENMAN:GetTopScreen():AddInputCallback(inputs);
	end;
};

return t;
--20160629
local sname = ...;
assert(sname)

local t = Def.ActorFrame{};

t[#t+1] = LoadActor( THEME:GetPathB("","_cfopen") )..{
};

local setop = {
	[THEME:GetString("OptionTitles","Key/Input/Sound Options")] = "IC",
	[THEME:GetString("OptionTitles","Display/Background Options")] = "DB",
	[THEME:GetString("OptionTitles","Gameplay/Life/Judge/Section Options")] = "GJ",
	[THEME:GetString("OptionTitles","Options")] = "ST"
};
local cr_check = false;
if GetAdhocPref("CSLTiCreditFlag") then
	if tonumber(GetAdhocPref("CSLTiCreditFlag")) >= 1 then
		cr_check = true;
	end;
elseif getenv("CSLTiCreditFlag") then
	if tonumber(getenv("CSLTiCreditFlag")) >= 1 then
		cr_check = true;
	end;
end;
if cr_check then
	setop[THEME:GetString("OptionTitles","Credits Select")] = "SC";
end;
setmetatable( setop, { __index = function() return "" end; } );

local scset = "";
local key_count = 0;
local key_c_count = 0;
if not getenv("opst") then
	setenv("opst",{"",""});
end;

t[#t+1] = Def.ActorFrame{
	OnCommand=function(self)
		SCREENMAN:GetTopScreen():AddInputCallback(inputs);
		--SCREENMAN:GetTopScreen():lockinput(1);
		if getenv("opst")[1] ~= "" then
			key_c_count = 2;
			SCREENMAN:AddNewScreenToTop(sname);
		end;
		--SCREENMAN:SystemMessage(getenv("opst")[1].." : "..getenv("opst")[2]);
	end;
	EnvSetCommand=function(self)
		SCREENMAN:SetNewScreen(scset);
	end;
	KOpenMessageCommand=function(self)
		key_count = 2;
		key_c_count = 2;
	end;
	KResetMessageCommand=function(self)
		key_count = 0;
	end;
};

t[#t+1] = Def.ActorFrame {
	InitCommand=cmd(visible,false;);
	NScreenCommand=cmd(visible,true;);
	Def.Quad{
		NScreenCommand=cmd(Center;diffuse,color("0,1,1,0.4");zoomtowidth,SCREEN_WIDTH;zoomtoheight,0;fadetop,0.2;fadebottom,0.2;
				decelerate,0.2;fadetop,0;fadebottom,0;zoomtoheight,SCREEN_HEIGHT;linear,0.2;diffuse,color("0,0,0,0"););
	};
	
	Def.Quad{
		NScreenCommand=cmd(Center;diffuse,color("0,1,0.85,0.2");zoomtowidth,SCREEN_WIDTH;zoomtoheight,0;fadetop,0.4;fadebottom,0.4;
				decelerate,0.2;fadetop,0;fadebottom,0;zoomtoheight,SCREEN_HEIGHT;linear,0.2;diffuse,color("0,0,0,0"););
	};

	Def.Quad{
		NScreenCommand=cmd(diffuse,color("0,0,0,0");x,SCREEN_CENTER_X;y,SCREEN_TOP;vertalign,top;zoomtowidth,SCREEN_WIDTH;zoomtoheight,0;
				accelerate,0.2;diffuse,color("0,0,0,1");zoomtowidth,SCREEN_WIDTH;zoomtoheight,SCREEN_HEIGHT/2+10);
	};

	Def.Quad{
		NScreenCommand=cmd(diffuse,color("0,0,0,0");x,SCREEN_CENTER_X;y,SCREEN_BOTTOM;vertalign,bottom;zoomtowidth,SCREEN_WIDTH;zoomtoheight,0;
				accelerate,0.2;diffuse,color("0,0,0,1");zoomtowidth,SCREEN_WIDTH;zoomtoheight,SCREEN_HEIGHT/2+10);
	};

};

function inputs(event)
	local top_screen = SCREENMAN:GetTopScreen();
	local op_row = top_screen:GetCurrentRowIndex(GAMESTATE:GetMasterPlayerNumber());
	local op_title = top_screen:GetOptionRow(op_row):GetRowTitle();
	local pn= event.PlayerNumber
	if not pn then return false end
	local button = event.GameButton
	if event.type == "InputEventType_FirstPress" then
		if button == 'Start' or button == 'Center' then
			if setop[op_title] ~= "" then 
				key_c_count = 1;
				setenv("opst",{setop[op_title],""});
				if key_c_count == 1 then
					key_c_count = 2;
					SCREENMAN:AddNewScreenToTop(sname);
				end;
			else setenv("opst",{"",""});
			end;
		end;
	end;
	--SCREENMAN:SystemMessage(getenv("opst")[1].." : "..getenv("opst")[2]);
end;

local function update(self)
	--[ja] 20160311修正
	if getenv("opst") then
		if string.find(getenv("opst")[2],"^Screen.*") then
			if key_count == 2 then
				key_count = 3;
				key_c_count = 2;
				self:playcommand("NScreen");
				--self:sleep(0.2);
				self:queuecommand("EnvSet");
				scset = getenv("opst")[2];
				setenv("opst",{getenv("opst")[1],""});
			end;
		end;
	end;
end;

t.InitCommand=cmd(SetUpdateFunction,update;);


return t;
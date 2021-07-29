-- the return of dubaiOne's custom OptionsIcons.

local Player = ...;
assert(Player);
local pname = pname(Player);

local spacingX = THEME:GetMetric("ModIconRowSelectMusic","SpacingX");
local spacingY = THEME:GetMetric("ModIconRowSelectMusic","SpacingY");

--local numRows = 1;
local numCols = THEME:GetMetric("ModIconRowSelectMusic","NumModIcons");

local p = ( (Player == "PlayerNumber_P1") and 1 or 2 );
local pstr = ProfIDSet(p);
local hsp = ProfIDPrefCheck("CAppearance",pstr,"Off");
--[ja] 20150619修正
local chp = ProfIDPrefCheck("CHide",pstr,"No,No,No,No");
local chps = split(",",chp);
local darkstr = "";
local coverstr = "";
local blindstr = "";


for d=1,#chps do
	if chps[d] == "Dark" then
		darkstr = "Dark";
	end;
	if chps[d] == "Cover" then
		coverstr = "Cover";
	end;
	if chps[d] == "Blind" then
		blindstr = "Blind";
	end;
end;

local c;
local u = Def.ActorFrame{
	Name="OptionIconRow"..pname;
	OnCommand=cmd(playcommand,"Update");
	UpdateCommand=function(self)
		local PlayerState = GAMESTATE:GetPlayerState(Player);
		local options = PlayerState:GetPlayerOptionsString('ModsLevel_Preferred');

		local listOfOptions = split(", ", options);
		local numOptions = #listOfOptions;

		local iconMain, iconImage, iconText;
		local stext = 1;
		local apflag = 0;
		local darkflag = 0;
		local coverflag = 0;
		local blindflag = 0;
		--for row=1,numRows do
			for i=1,numCols do
				iconMain = self:GetChild( pname.."ModIcon"..i );
				iconImage = iconMain:GetChild("Icon");
				iconText = iconMain:GetChild("Label");
			
				local text = listOfOptions[i] or "";
				if text == "Hidden" or text == "Sudden" or 
				text == "Stealth" or text == "Blink" then
					apflag = 1;
				end;
				if text == "Dark" then darkflag = 1;
				end;
				if text == "Cover" then coverflag = 1;
				end;
				if text == "Blind" then blindflag = 1;
				end;
				if text == "" and stext == 1 then
					if apflag == 0 then
						if hsp ~= "Off" then
							text = hsp;
						end;
					end;
					stext = 2;
				end;
				if text == "" and stext == 2 then
					if darkflag == 0 then
						if darkstr == "Dark" then
							text = darkstr;
						end;
					end;
					stext = 3;
				end;
				if text == "" and stext == 3 then
					if coverflag == 0 then
						if coverstr == "Cover" then
							text = coverstr;
						end;
					end;
					stext = 4;
				end;
				if text == "" and stext == 4 then
					if blindflag == 0 then
						if blindstr == "Blind" then
							text = blindstr;
						end;
					end;
					stext = 0;
				end;
				if text == "" then
					iconImage:Load(THEME:GetPathG("ModIcon","Empty"));
				else
					iconImage:Load(THEME:GetPathG("ModIcon","Filled"));
				end;
				--20180210
				if #text > 7 then iconText:settext(string.sub(text,1,6).."...");
				else iconText:settext(text);
				end;
			end;
		--end;
	end;
	PlayerOptionsChangedMessageCommand=function(self,param)
		if param.PlayerNumber == Player then
			self:playcommand("Update");
		end;
	end;
};

local function MakeIcons()
	for i=1,numCols do
		u[#u+1] = Def.ActorFrame{
			Name=pname.."ModIcon"..i;
			InitCommand=cmd(x,((i-1) * spacingX);y,0;);
			LoadActor(THEME:GetPathG("ModIcon","Empty"))..{
				Name="Icon";
			};
			LoadFont("OptionIcon text")..{
				Name="Label";
				Text="";
				InitCommand=cmd(diffuse,color("1,1,1,1");maxwidth,36);
				OnCommand=THEME:GetMetric(Var "LoadingScreen","ModIconTextOnCommand");
			};
		};
	end;
end;

u.InitCommand=MakeIcons();

return u;
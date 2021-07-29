--[ja] New表示確認
local fctext = "";
if GetAdhocPref("Fctext") then
	if GetAdhocPref("Fctext") ~= "" then
		fctext = GetAdhocPref("Fctext");
	end;
end;
local fctext_s;
if fctext then
	fctext_s = split(",",fctext);
end;

local gf_s = split(",",SelectFrameSet());

local f_set = {};
if fctext_s then
	for k = 1, #fctext_s do
		for f = 1, #gf_s do
			if fctext_s[k] == gf_s[f] then
				f_set[#f_set+1] = fctext_s[k];
				break;
			end;
		end;
	end;
end;
function ftable(ftable)
	if ftable then
		return table.concat(ftable,",");
	end;
	return "";
end;
SetAdhocPref("Fctext", ftable(f_set));
SetAdhocPref("I_Fctext", ftable(f_set));

local gc = Var("GameCommand");
local s = THEME:GetString("ScreenTitleMenu",gc:GetText());
local t = Def.ActorFrame {
	LoadFont("_titleMenu_scroller") ..{
		InitCommand=cmd(uppercase,true;settext,s;horizalign,right;shadowlength,3;zoom,0.8;strokecolor,color("0,0,0,1"));
		GainFocusCommand=cmd(stoptweening;diffuseshift;effectperiod,0.4;effectcolor1,color("1,1,0,1");effectcolor2,color("1,0.4,0,1");linear,0.15;zoomx,0.8;zoomy,1;);
		LoseFocusCommand=cmd(stoptweening;stopeffect;linear,0.15;zoom,0.8;diffuse,color("0.75,0.75,0.75,1"));
		DisabledCommand=cmd(diffuse,color("0.5,0.5,0.5,1"));
	};

	LoadFont("Common Normal") ..{
		InitCommand=function(self)
			local check = false;
			if s == THEME:GetString("ScreenTitleMenu","Options") then
				if GetAdhocPref("CSLCreditFlag") then
					if tonumber(GetAdhocPref("CSLCreditFlag")) == 1 then
						check = true;
					end;
				elseif getenv("CSLCreditFlag") then
					if tonumber(getenv("CSLCreditFlag")) == 1 then
						check = true;
					end;
				end;
				if GetAdhocPref("CSLTiCreditFlag") then
					if tonumber(GetAdhocPref("CSLTiCreditFlag")) == 1 then
						check = true;
					end;
				elseif getenv("CSLTiCreditFlag") then
					if tonumber(getenv("CSLTiCreditFlag")) == 1 then
						check = true;
					end;
				end;
				if GetAdhocPref("Fctext") ~= "" then
					check = true;
				end;
				if check then
					(cmd(visible,true;uppercase,true;settext,"New!";addx,2;addy,-6;horizalign,left;
					shadowlength,2;diffuse,color("1,0,1,1");strokecolor,color("1,1,0,1");zoom,0.45;))(self)
				else self:visible(false);
				end;
			end;
		end;
		DisabledCommand=cmd(diffuse,color("0.5,0.5,0.5,1"));
	};
	
	LoadFont("Common Normal") ..{
		InitCommand=function(self)
			if s == THEME:GetString("ScreenTitleMenu","Information") then
				if GetAdhocPref("I_Fctext") ~= "" then
					self:visible(true);
					(cmd(uppercase,true;settext,"New!";addx,2;addy,-6;horizalign,left;
					shadowlength,2;diffuse,color("1,0,1,1");strokecolor,color("1,1,0,1");zoom,0.45;))(self)
				else self:visible(false);
				end;
			end;
		end;
		DisabledCommand=cmd(diffuse,color("0.5,0.5,0.5,1"));
	};
};

return t;

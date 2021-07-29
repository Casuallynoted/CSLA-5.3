-- sm-ssc Default Theme Preferences Handler

-- Example usage of new system (not really implemented yet)
local Prefs =
{
	AutoSetStyle =
	{
		Default = false,
		Choices = { "ON", "OFF" },
		Values = { true, false }
	},
}

ThemePrefs.InitAll(Prefs)

function InitUserPrefs()
	local Prefs = {
		UserPrefScoringMode = 'Hybrid',
		UserPrefShowLotsaOptions = true,
		UserPrefComboOnRolls = false,
		UserPrefProtimingP1 = false,
		UserPrefProtimingP2 = false,
		FlashyCombos = false,
		UserPrefComboUnderField = true,
	}
	for k, v in pairs(Prefs) do
		-- kind of xxx
		local GetPref = type(v) == "boolean" and GetUserPrefB or GetUserPref
		if GetPref(k) == nil then
			SetUserPref(k, v)
		end
	end
end

function InitUserScorePrefs()
	if GetUserPref("UserPrefScoringMode") == nil then
		SetUserPref("UserPrefScoringMode", 'Hybrid');
	end;
end;

function GetProTiming(pn)
	local pname = ToEnumShortString(pn)
	if GetUserPrefB("ProTiming"..pname) then
		return GetUserPrefB("ProTiming"..pname)
	else
		SetUserPref("ProTiming"..pname,false)
		return false
	end
end

function GameModeChoiceSet()
	local base = "1,2"
	local allCourses = SONGMAN:GetAllCourses(PREFSMAN:GetPreference("AutogenGroupCourses"));
	local c_non = true;
	local c_cha =true;
	local c_end = true;
	local c_c = {};
	for q=1, #allCourses do
		if allCourses[q]:GetCourseType() == 'CourseType_Nonstop' and c_non then
			c_c[1] = "3";
			c_non = false;
		end;
		if (allCourses[q]:GetCourseType() == 'CourseType_Oni' or 
		allCourses[q]:GetCourseType() == 'CourseType_Survival') and c_cha then
			c_c[2] = "4";
			c_cha = false;
		end;
		if allCourses[q]:GetCourseType() == 'CourseType_Endless' and c_end then
			c_c[3] = "5";
			c_end = false;
		end;
		if #c_c >= 3 then
			break;
		end;
	end
	if c_c then
		return base..","..table.concat(c_c,",");
	else return base;
	end
end
function GetInitialOptionLines()
	local LineSets = {
		"DataMigration",
		"Use3D,Jacket,MeterType",
	};
	local Lines = LineSets[2]
	if FILEMAN:DoesFileExist( "Data/UserPrefs/CyberiaStyle8/" ) then
		local file = FILEMAN:GetDirListing( "Data/UserPrefs/CyberiaStyle8/" )
		if #file > 0 then Lines = LineSets[1]
		end
	end
	return Lines
end

--20160821
function GetDefaultOptionLines(song)
	local numpn = GAMESTATE:GetNumPlayersEnabled()
	local LineSets = { -- none of these include characters yet.
		"1,SG,CMS,2,3,4,5,6,Hsp,8,9,10,CHide,12,13", -- All
		"1,SG,CCM,2,3,4,5,6,Hsp,8,9,10,CHide,12,13", -- Course Steps
		"1,SG,2,3,4,5,6,Hsp,8,9,10,CHide,12,13", -- Non Steps
		"1,SG,CMS,2,3,6,Hsp,10,CHide,12", -- DDR Essentials ( no turns, fx )
		"1,SG,CCM,2,3,6,Hsp,10,CHide,12", -- DDR Essentials Course Steps ( no turns, fx )
		"1,SG,2,3,6,Hsp,10,CHide,12" -- DDR Essentials Non Steps ( no turns, fx )
	};
	local function IsCourse()
		if GAMESTATE:IsCourseMode() then return true
		else return false
		end
	end
	local function IsExtra()
		if GAMESTATE:IsExtraStage() then return true
		else return false
		end
	end
	local function IsExtra2()
		if GAMESTATE:IsExtraStage2() then return true
		else return false
		end
	end
	local function CheckCC(mods)
		local nmod = ""
		local dmod = ""
		local gmod = ""
		local crmod = ""
		local cmod = ""
		csets = split(",", CGraphicList());
		local st = GAMESTATE:GetCurrentStyle();
		--local sttype = split("_",st:GetStepsType());
		gmod = gmod..",17"
		--if sttype[2] == "Dance" then
			local gmodcheck = false;
			for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
				if IsCourse() then
					if not GAMESTATE:GetCurrentCourse():IsAutogen() and 
					GAMESTATE:GetCurrentCourse():GetCourseType() ~= 'CourseType_Endless' and
					GAMESTATE:GetCurrentCourse():GetCourseType() ~= 'CourseType_Survival' then
						--if not IsNetConnected() then
							gmod = gmod..","..ToEnumShortString(pn).."Graph";
						--end;
						gmodcheck = true;
					end
				else
					--if not IsNetConnected() then
						gmod = gmod..","..ToEnumShortString(pn).."Graph";
					--end;
					gmodcheck = true;
				end
			end
			if gmodcheck then
				gmod = gmod..",GraphType";
			end;
		--end

		if vcheck() == "5_2_0" then
			nmod = nmod..",NNS,18"
		else nmod = nmod..",15,18"
		end;
		if CHARMAN:GetCharacterCount() > 0 then
			crmod = ",16"
		end
		if not IsCourse() then
			--if GetUserPrefB("UserPrefShowLotsaOptions") == true then
				if not IsExtra() and not IsExtra2() then
					dmod = dmod..",19,20"
				end
			--end
		else
			if GAMESTATE:GetCurrentCourse():GetCourseType() ~= 'CourseType_Oni' and
			GAMESTATE:GetCurrentCourse():GetCourseType() ~= 'CourseType_Survival' then
				--if GetUserPrefB("UserPrefShowLotsaOptions") == true then
					dmod = dmod..",19,20"
				--end
			end
		end
		dmod = dmod .. ",22"
		if #csets >= 2 then
			cmod = cmod..",CCover"
		end
		if IsNetConnected() then
			nmod = nmod..",CR,CL"
		end;
		return mods .."".. dmod .."".. gmod .."".. cmod .."".. crmod .."".. nmod
	end
	
	modLines = LineSets[2]
	if not song then 
		string.sub(modLines,1,-4)
	end
	if IsCourse() then
		if GetUserPrefB("UserPrefShowLotsaOptions") == true then
			modLines = LineSets[2];
		else modLines = LineSets[5];
		end
	else
		if IsExtra2() or IsNetConnected() then
			if GetUserPrefB("UserPrefShowLotsaOptions") == true then
				modLines = LineSets[3];
			else modLines = LineSets[6];
			end
		end
		if not IsExtra2() and not IsNetConnected() then
			if GetUserPrefB("UserPrefShowLotsaOptions") == true then
				modLines = LineSets[1];
			else modLines = LineSets[4];
			end
			if not song then 
				string.sub(modLines,1,-5)
			end
		end
	end
	return CheckCC(modLines)
end

function GetDefaultOptionRaveLines()
	local LineSets = {
		"1,SG,CMS,Hsp,8,12,15,17,18",
	};
	
	local function CheckCC(mods)
		local cmod = ""
		local crmod = ""
		csets = split(",", CGraphicList());
		if #csets >= 2 then
			cmod = ",CCover"
		end
		if CHARMAN:GetCharacterCount() > 0 then
			crmod = ",16"
		end
		return mods .. crmod .."".. cmod
	end
	return CheckCC(LineSets[1])
end

function GetDefaultOptionRaveLines()
	local LineSets = {
		"1,SG,CMS,Hsp,8,12,15,17,18",
	};
	
	local function CheckCC(mods)
		local cmod = ""
		local crmod = ""
		csets = split(",", CGraphicList());
		if #csets >= 2 then
			cmod = ",CCover"
		end
		if CHARMAN:GetCharacterCount() > 0 then
			crmod = ",16"
		end
		return mods .. crmod .."".. cmod
	end
	return CheckCC(LineSets[1])
end

--20161109
function GetDefaultSongOptionLines()
	local FTypeSet = "4,"
	local LineSets = "5,6,7,8,9,10,11"
	local function IsCourse()
		if GAMESTATE:IsCourseMode() then return true
		else return false
		end
	end
	if IsCourse() then
		if GAMESTATE:GetCurrentCourse():GetCourseType() ~= 'CourseType_Nonstop' then
			FTypeSet = ""
		end
	end
	return FTypeSet .. LineSets
end

function GetOptionLines()
	local LineSets = "1,IC,DB,GJ,12"

	local opdfile = FILEMAN:GetDirListing( "CSRealScore/*" )
	local rs = ""
--[[
	if #opdfile > 0 then rs = ",RS"
	end
]]
	local fs = ""
	if SelectFrameSet() ~= "" and SelectFrameSet() ~= nil then
		fs = ",FS"
	end
	
	local cc = ""
	if GetAdhocPref("CSLTiCreditFlag") then
		if tonumber(GetAdhocPref("CSLTiCreditFlag")) >= 1 then
			cc = ",SC"
		end
	elseif getenv("CSLTiCreditFlag") then
		if tonumber(getenv("CSLTiCreditFlag")) >= 1 then
			cc = ",SC"
		end
	end
	if cc == "" then
		if GetAdhocPref("CSLCreditFlag") then
			if tonumber(GetAdhocPref("CSLCreditFlag")) >= 1 then
				cc = ",CC"
			end
		elseif getenv("CSLCreditFlag") then
			if tonumber(getenv("CSLCreditFlag")) >= 1 then
				cc = ",CC"
			end
		end
	end
	return LineSets..""..rs..""..fs..",CS,13,14,MO"..cc;
end

function AppearanceOptionsLines()
	local GLineSets = {
		"1,2,3,4,5,6,7,8,9", --5_0_5
		"1,2,3,4,5,6,7,8,9,32,ECPT" --5_0_7
	}
	if vcheck() == "beta4" or vcheck() == "5_0_5" then
		return GLineSets[1]
	else return GLineSets[2]
	end
end

function MachineOptionsLines()
	local GLineSets = {
		"1,2,3,4,5,6,7,13,14,Score,CJudge,11,CCombo,ComboRolls,HJudge,HBreak", --5_0_5
		"1,2,3,4,5,6,7,Score,CJudge,CCombo,ComboRolls,HJudge,HBreak" --beta4
	}
	if vcheck() ~= "beta4" then
		return GLineSets[1]
	else return GLineSets[2]
	end
end

function GameplayOptionsLines()
	local GLineSets = {
		"1,MeterType,3,4,SI,SM,FlashyC,ComboUnderF,2,8,9,10,12,16,17", --5_0_5
		"1,MeterType,3,4,SI,SM,FlashyC,ComboUnderF,2,8" --beta4
	}
	if vcheck() ~= "beta4" then
		return GLineSets[1]
	else return GLineSets[2]
	end
end

--20180218
function SectionOptionsLines()
	local GLineSets = {
		"1,2,SNSort,Jacket,3,15,4,6,7,OptLotsa,9,DAnim,CSLAEE", --5_0_5
		"1,2,SNSort,Jacket,3,4,6,7,OptLotsa,9,DAnim,CSLAEE" --beta4
	}
	if vcheck() ~= "beta4" then
		return GLineSets[1]
	else return GLineSets[2]
	end
end

function SoundOptionsLines()
	local GLineSets = {
		"1,2,3,4,5,6,8,9,10,11,12", --5_0_5
		"1,2,3,4,5,6,8,9,10,11" --beta4
	}
	if vcheck() ~= "beta4" then
		return GLineSets[1]
	else return GLineSets[2]
	end
end

--20160420
function CoinOptionsLines()
	local GLineSets = {
		"CC,2,3,4,5",	--online
		"1,2,3,4,5"		--offline
	}
	if IsNetConnected() then
		return GLineSets[1]
	else return GLineSets[2]
	end
end

--20160821
function GraphicOptionsLines()
	local GLineSets = {
		"1,2,3,4,5,6,Use3D,7,8,9,10,11,12,13,FNR,14,16", --5_0_5
		"DM,AR,DR,RR,5,6,Use3D,7,8,9,10,11,12,13,FNR,14,16" --5_2_0
	}
	if vcheck() ~= "5_2_0" then
		return GLineSets[1]
	else return GLineSets[2]
	end
end

--option rows 
function OptionRowProTiming()
	local t = {
		Name = "ProTiming",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = false,
		ExportOnChange = false,
		Choices = { 'Off','On' },
		LoadSelections = function(self, list, pn)
			if GetUserPrefB("UserPrefProtiming" .. ToEnumShortString(pn)) then
				local bShow = GetUserPrefB("UserPrefProtiming" .. ToEnumShortString(pn))
				if bShow then
					list[2] = true
				else
					list[1] = true
				end
			else
				WritePrefToFile("UserPrefProtiming", false)
				list[1] = true
			end
		end,
		SaveSelections = function(self, list, pn)
			local bSave = list[2] and true or false
			SetUserPref("UserPrefProtiming" .. ToEnumShortString(pn), bSave)
		end
	}
	setmetatable(t, t)
	return t
end

function UserPrefShowLotsaOptions()
	local t = {
		Name = "UserPrefShowLotsaOptions",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = true,
		ExportOnChange = false,
		Choices = { 'Many','Few' },
		LoadSelections = function(self, list, pn)
			if ReadPrefFromFile("UserPrefShowLotsaOptions") ~= nil then
				if GetUserPrefB("UserPrefShowLotsaOptions") then
					list[1] = true
				else
					list[2] = true
				end
			else
				WritePrefToFile("UserPrefShowLotsaOptions", false)
				list[2] = true
			end
		end,
		SaveSelections = function(self, list, pn)
			local val = list[1] and true or false
			WritePrefToFile("UserPrefShowLotsaOptions", val)
			MESSAGEMAN:Broadcast("PreferenceSet", { Message == "Set Preference" })
			THEME:ReloadMetrics()
		end
	}
	setmetatable(t, t);
	return t
end

function UserPrefComboOnRolls()
	local t = {
		Name = "UserPrefComboOnRolls",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = true,
		ExportOnChange = false,
		Choices = { 'Off','On' },
		LoadSelections = function(self, list, pn)
			if ReadPrefFromFile("UserPrefComboOnRolls") ~= nil then
				if GetUserPrefB("UserPrefComboOnRolls") then
					list[2] = true;
				else
					list[1] = true;
				end;
			else
				WritePrefToFile("UserPrefComboOnRolls",false);
				list[1] = true;
			end;
		end,
		SaveSelections = function(self, list, pn)
			local val = list[2] and true or false
			WritePrefToFile("UserPrefComboOnRolls", val)
			MESSAGEMAN:Broadcast("PreferenceSet", { Message == "Set Preference" })
			THEME:ReloadMetrics()
		end
	}
	setmetatable(t, t)
	return t
end

function UserPrefFlashyCombo()
	local t = {
		Name = "UserPrefFlashyCombo",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = true,
		ExportOnChange = false,
		Choices = { 'Off','On' },
		LoadSelections = function(self, list, pn)
			if ReadPrefFromFile("UserPrefFlashyCombo") ~= nil then
				if GetUserPrefB("UserPrefFlashyCombo") then
					list[2] = true
				else
					list[1] = true
				end
			else
				WritePrefToFile("UserPrefFlashyCombo", false)
				list[1] = true
			end
		end,
		SaveSelections = function(self, list, pn)
			local val = list[2] and true or false
			WritePrefToFile("UserPrefFlashyCombo", val)
			MESSAGEMAN:Broadcast("PreferenceSet", { Message == "Set Preference" })
			THEME:ReloadMetrics()
		end
	}
	setmetatable(t, t)
	return t
end

function UserPrefComboUnderField()
	local t = {
		Name = "UserPrefComboUnderField",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = true,
		ExportOnChange = false,
		Choices = { 'Off','On' },
		LoadSelections = function(self, list, pn)
			if ReadPrefFromFile("UserPrefComboUnderField") ~= nil then
				if GetUserPrefB("UserPrefComboUnderField") then
					list[2] = true
				else
					list[1] = true
				end
			else
				WritePrefToFile("UserPrefComboUnderField", true)
				list[2] = true
			end
		end,
		SaveSelections = function(self, list, pn)
			local val = list[2] and true or false
			WritePrefToFile("UserPrefComboUnderField", val)
			MESSAGEMAN:Broadcast("PreferenceSet", { Message == "Set Preference" })
			THEME:ReloadMetrics()
		end
	}
	setmetatable(t, t)
	return t;
end

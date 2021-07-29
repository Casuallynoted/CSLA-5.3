--[[ custom ]]
-- based on scripts by aj kelly; ad-hoc userprefs by asg

local prefBasePath = "Save/UserPrefs/CyberiaStyle_LA/";
local prefOldPath = "Data/UserPrefs/CyberiaStyle8/";

cap_old_path = "CSDataSave/0001_cc CSApp";
cc_old_path = "CSDataSave/0001_cc CSCountExt";
cap_path = "CSDataSave/0001_cc CSLApp";
cc_path = "CSDataSave/0001_cc CSLCountExt";

envTable = GAMESTATE:Env()
-- env
function setenv(name,value) envTable[name] = value end
function getenv(name) return envTable[name] end

-- sodasweets2
-- file (assume stepmania 4 alpha 5)
function WriteFile(path,buf)
	local f = RageFileUtil.CreateRageFile()
	if f:Open(path, 2) then
		f:Write( tostring(buf) )
		f:destroy()
		return true
	else
		Trace( "[FileUtils] Error writing to ".. path ..": ".. f:GetError() )
		f:ClearError()
		f:destroy()
		return false
	end
end

function ReadFile(path)
	local f = RageFileUtil.CreateRageFile()
	local ret = ""
	if f:Open(path, 1) then
		ret = tostring( f:Read() )
		f:destroy()
		return ret
	else
		Trace( "[FileUtils] Error reading from ".. path ..": ".. f:GetError() )
		f:ClearError()
		f:destroy()
		return nil
	end
end

-- ad-hoc userprefs implementatio

function SetAdhocPref(pref,val,prof)
	if prof then
		if #FILEMAN:GetDirListing(PROFILEMAN:LocalProfileIDToDir(prof)) > 0 then
			--20160720
			WriteFile(PROFILEMAN:LocalProfileIDToDir(prof).."CS_Settings/"..pref,val)
			setenv(pref..prof,val)
		else
			WriteFile(prefBasePath..pref..prof,val)
			setenv(pref..prof,val)
		end
	else
		WriteFile(prefBasePath..pref,val)
		setenv(pref,val)
	end
end

function GetAdhocPref(pref,prof)
	if prof then
		if getenv(pref..prof) ~= nil then
			return getenv(pref..prof)
		else
			--20160720
			if ReadFile(PROFILEMAN:LocalProfileIDToDir(prof).."CS_Settings/"..pref) ~= nil then
				return ReadFile(PROFILEMAN:LocalProfileIDToDir(prof).."CS_Settings/"..pref)
			else return ReadFile(prefBasePath..pref..prof)
			end
		end
	else
		if getenv(pref) ~= nil then
			return getenv(pref)
		else
			local res = ReadFile(prefBasePath..pref)
			return res
		end
	end
end

--[[
function SetAdhocPref(pref,val)
	WriteFile(prefBasePath..pref,val)
	setenv(pref,val)
end

function GetAdhocPref(pref)
	if getenv(pref) ~= nil then
		return getenv(pref)
	else
		local res = ReadFile(prefBasePath..pref)
		return res
	end
end
]]

--[ja] Save\LocalProfiles\********\CS_Settingsにセーブデータをコピー
function PrefCopy(profileid)
	local file = FILEMAN:GetDirListing( prefBasePath );
	if #file > 0 then
		for j=1, #file do
			if string.find(file[j],".*"..profileid) then
				--20160720
				local setname = PROFILEMAN:LocalProfileIDToDir(profileid).."CS_Settings/"..string.sub(file[j],1,#file[j]-#profileid);
				if not FILEMAN:DoesFileExist( setname ) then
					local read_f = ReadFile( prefBasePath..file[j] );
					WriteFile( PROFILEMAN:LocalProfileIDToDir(profileid).."CS_Settings/"..string.sub(file[j],1,#file[j]-#profileid), read_f );
				end;
			end;
		end;
	end;
end;

function InitPrefsFail()
	local fail = "FailImmediate";
	local check = false;
	if vcheck() ~= "beta4" then
		local dmods = split(", ",PREFSMAN:GetPreference("DefaultModifiers"));
		for i=1,#dmods do
			if dmods[i] == "FailImmediateContinue" or dmods[i] == "FailOff" then
				fail = dmods[i];
				check = true;
			--[ja] 20160322修正
			elseif dmods[i] == "FailAtEnd" then
				fail = "FailEndOfSong";
				check = true;
			end;
			if check then
				break;
			end;
		end;
	else
		fail = "Fail"..ToEnumShortString(PREFSMAN:GetPreference("DefaultFailtype"));
	end;
	return fail;
end

function InitPrefsCS()
	--[ja] 毎回イニシャライズしない項目
	local prefs = {
		Enable3DModels = 'Off',
		ShowJackets = 'On',
		WheelGraphics = 'Banner',
		CustomSpeed = 'CS6',
		UserMeterType = 'Default',
		DiffListAnimation = '0.001',
		CSLAEasterEggs = true,
		HoldArrowJudge = '1Point',
		HoldAllowComboBreak = false,
		GoodCombo = 'TapNoteScore_W3',
		CComboCount = false,
		CSScoringMode = 'Hybrid',
		BGScale = 'Fit',
		CSLCreditFlag = '0',
		CSLTiCreditFlag = '0',
		FrameSet = 'Default',
		CSSetApp = '15135419',
		CSLSetApp = '71569484',
		P_ADCheck = 'NG',
		InfoChoice = 'Frame1',
		CSLInfoChoice = 'Frame1',
		CSLInitialFlag = '0',
		ReadMeCSLFirst = false,
		CSLV2Flag = '0',
		--20180218
		SCustomNemeSort = false
	}
	--[ja] 毎回イニシャライズする項目
	local cprefs = {
		SLoadCheckFlag = '2',
		CRate = '1',
		CBGMode = 'Default',
		IngameStatsP1 = 'Off',
		IngameStatsP2 = 'Off',
		ScreenFilterV2P1 = 'Off,Black,Off',
		ScreenFilterV2P2 = 'Off,Black,Off',
		GraphDistanceP1 = 'Far',
		GraphDistanceP2 = 'Far',
		GraphTypeP1 = 'CS',
		GraphTypeP2 = 'CS',
		ScoreGraphP1 = 'Off',
		ScoreGraphP2 = 'Off',
		CAppearanceP1 = 'Off',
		CAppearanceP2 = 'Off',
		CCoverP1 = 'Off',
		CCoverP2 = 'Off',
		CCoverStrP1 = '_blank',
		CCoverStrP2 = '_blank',
		CharacterSetP1 = 'default,1',
		CharacterSetP2 = 'default,1',
		JudgeSetP1 = 'ntype',
		JudgeSetP2 = 'ntype',
		CHideP1 = 'No,No,No,No',
		CHideP2 = 'No,No,No,No',
		CProTimingP1 = 'No,No,No',
		CProTimingP2 = 'No,No,No',
		--CNoteSizeP1 = 'New,0',
		--CNoteSizeP2 = 'New,0',
		GamePlaySpeedIncrementP1 = '25',
		GamePlaySpeedIncrementP2 = '25',
		Fctext = '',
		I_Fctext = '',
		SRivalOpenP1 = 1,
		SRivalOpenP2 = 1,
		--20171229
		LastSortChP1 = 'Group,ntype',
		LastSortChP2 = 'Group,ntype',
		--20180207
		FavoriteCountP1 = '1',
		FavoriteCountP2 = '1'
	}
	if string.find(themeInfo["Version"],"^.*Precedence distribution version") then
		prefs["CSLSetApp"] = '00000001';
	end;
	if GetAdhocPref("ShowJackets") == 'On' then
		prefs["WheelGraphics"] = 'Default'
	elseif GetAdhocPref("ShowJackets") == 'Off' then
		prefs["WheelGraphics"] = 'Banner'
	end;

	if tonumber(GetAdhocPref("CSLCreditFlag")) == 1 then
		SetAdhocPref("CSLCreditFlag","2");
	end;
	if tonumber(GetAdhocPref("CSLTiCreditFlag")) == 1 then
		SetAdhocPref("CSLTiCreditFlag","2");
	end;

	for k,pv in pairs(prefs) do
--[[
		if GetAdhocPref(k) then
			Trace("SetAdhocAA : "..k..":"..GetAdhocPref(k));
		else Trace("SetAdhocAB : "..k..":".."nil");
		end;
]]
		if not GetAdhocPref(k) then
			SetAdhocPref(k,pv)
		end
	end
	for n,cpv in pairs(cprefs) do
		Trace("SetAdhoc : "..n);
		SetAdhocPref(n,cpv)
	end
	SetAdhocPref("ShowJackets","OK")
--[[
	if File.Read( cap_old_path ) then SetAdhocPref("CSSetApp","00000001")
	end
]]
end

function InitPrefsP()
	SetAdhocPref("ProfIDSetP1","P1");
	SetAdhocPref("ProfIDSetP2","P2");
end

--20160718
function InitPrefsOldP()
	if GetAdhocPref("ProfIDSetP1") ~= "P1" then
		SetAdhocPref("ProfOldIDSetP1",GetAdhocPref("ProfIDSetP1"));
	else SetAdhocPref("ProfOldIDSetP1","Prof");
	end;
	if GetAdhocPref("ProfIDSetP2") ~= "P2" then
		SetAdhocPref("ProfOldIDSetP2",GetAdhocPref("ProfIDSetP2"));
	else SetAdhocPref("ProfOldIDSetP2","Prof");
	end;
end

InitPrefsCS();

function DataMigration()
	local t = {
		Name = "DataMigration",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = true,
		ExportOnChange = false,
		Choices = { 'Yes','No' },
		LoadSelections = function(self, list, pn)
			list[1] = true
		end;
		SaveSelections = function(self, list, pn)
			if list[1] then
				local file = FILEMAN:GetDirListing( prefOldPath )
				if #file > 0 then
					for j=1, #file do
						local sfile = split("/",file[j])
						local rfile = ReadFile(prefOldPath..file[j])
						SetAdhocPref(file[j],rfile)
					end
				end
			end
			MESSAGEMAN:Broadcast("PreferenceSet", { Message == "Set Preference" })
			THEME:ReloadMetrics()
		end;
	};
	setmetatable( t, t )
	return t
end

function OptionRow3DModels()
	local t = {
		Name = "Enable3DModels";
		LayoutType = "ShowAllInRow";
		SelectType = "SelectOne";
		OneChoiceForAllPlayers = true;
		ExportOnChange = false;
		Choices = { 'Off','On' },
		LoadSelections = function(self, list, pn)
			if GetAdhocPref("Enable3DModels") ~= nil then
				local curSet = GetAdhocPref("Enable3DModels")
				if curSet == 'Off' then
					list[1] = true
				elseif curSet == 'On' then
					list[2] = true
				else
					list[1] = true
				end;
			else
				list[1] = true
			end
		end;
		SaveSelections = function(self, list, pn)
			local tChoices = { 'Off','On' }
			local val
			if list[1] then
				val = tChoices[1]
			elseif list[2] then
				val = tChoices[2]
			else
				val = tChoices[1]
			end
			SetAdhocPref("Enable3DModels",val)
			MESSAGEMAN:Broadcast("PreferenceSet", { Message == "Set Preference" })
			THEME:ReloadMetrics()
		end;
	};
	setmetatable( t, t )
	return t;
end;

function ShowJackets()
	local t = {
		Name = "ShowJackets",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = true,
		ExportOnChange = false,
		Choices = { 'Off','On' },
		LoadSelections = function(self, list, pn)
			if GetAdhocPref("ShowJackets") ~= nil then
				local curSet = GetAdhocPref("ShowJackets")
				if curSet == 'Off' then
					list[1] = true
				elseif curSet == 'On' then
					list[2] = true
				elseif curSet == 'OK' then
					list[2] = true
				else
					list[1] = true
				end;
			else
				list[1] = true
			end
		end;
		SaveSelections = function(self, list, pn)
			local tChoices = { 'Off','On' }
			local val
			if list[1] then
				val = tChoices[1]
			elseif list[2] then
				val = tChoices[2]
			else
				val = tChoices[1]
			end
			SetAdhocPref("ShowJackets",val)
			MESSAGEMAN:Broadcast("PreferenceSet", { Message == "Set Preference" })
			THEME:ReloadMetrics()
		end;
	};
	setmetatable( t, t )
	return t
end

function WheelGraphics()
	local t = {
		Name = "WheelGraphics",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = true,
		ExportOnChange = false,
		Choices = { 'Off','Banner','Default','Jacket','BackGround' },
		LoadSelections = function(self, list, pn)
			if GetAdhocPref("WheelGraphics") ~= nil or GetAdhocPref("ShowJackets") ~= nil then
				local curSetW = GetAdhocPref("WheelGraphics")
				if curSetW == 'Off' then
					list[1] = true
				elseif curSetW == 'Banner' then
					list[2] = true
				elseif curSetW == 'Default' then
					list[3] = true
				elseif curSetW == 'Jacket' then
					list[4] = true
				elseif curSetW == 'BackGround' then
					list[5] = true
				else
					list[1] = true
				end;
			else
				list[2] = true
			end
		end;
		SaveSelections = function(self, list, pn)
			local tChoices = { 'Off','Banner','Default','Jacket','BackGround' }
			local val
			if list[1] then
				val = tChoices[1]
			elseif list[2] then
				val = tChoices[2]
			elseif list[3] then
				val = tChoices[3]
			elseif list[4] then
				val = tChoices[4]
			elseif list[5] then
				val = tChoices[5]
			else
				val = tChoices[1]
			end
			SetAdhocPref("WheelGraphics",val)
			MESSAGEMAN:Broadcast("PreferenceSet", { Message == "Set Preference" })
			THEME:ReloadMetrics()
		end;
	};
	setmetatable( t, t )
	return t
end

function UserPrefCustomSpeed()
	local t = {
		Name = "CustomSpeed",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = true,
		ExportOnChange = false,
		Choices = { 'CS6','Custom' },
		LoadSelections = function(self, list, pn)
			if GetAdhocPref("CustomSpeed") ~= nil then
				local curSet = GetAdhocPref("CustomSpeed")
				if curSet == 'CS6' then
					list[1] = true
				elseif curSet == 'Custom' then
					list[2] = true
				else
					list[1] = true
				end
			else
				SetAdhocPref("CustomSpeed",'CS6')
				list[1] = true
			end
		end,
		SaveSelections = function(self, list, pn)
			local tChoices = { 'CS6','Custom' }
			local val
			if list[1] then
				val = tChoices[1]
			elseif list[2] then
				val = tChoices[2]
			else
				val = tChoices[1]
			end
			SetAdhocPref("CustomSpeed",val)
			MESSAGEMAN:Broadcast("PreferenceSet", { Message == "Set Preference" })
			THEME:ReloadMetrics()
		end,
	}
	setmetatable( t, t )
	return t
end

function MeterType()
	local t = {
		Name = "MeterType",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = true,
		ExportOnChange = false,
		Choices = { 'Default','CSStyle' },
		LoadSelections = function(self, list, pn)
			if GetAdhocPref("UserMeterType") ~= nil then
				local curSet = GetAdhocPref("UserMeterType")
				if curSet == 'Default' then
					list[1] = true
				elseif curSet == 'CSStyle' then
					list[2] = true
				else
					list[1] = true
				end
			else
				SetAdhocPref("UserMeterType",'Default')
				list[1] = true
			end
		end,
		SaveSelections = function(self, list, pn)
			local tChoices = { 'Default','CSStyle' }
			local val
			if list[1] then
				val = tChoices[1]
			elseif list[2] then
				val = tChoices[2]
			else
				val = tChoices[1]
			end
			SetAdhocPref("UserMeterType",val)
			MESSAGEMAN:Broadcast("PreferenceSet", { Message == "Set Preference" })
			THEME:ReloadMetrics()
		end,
	}
	setmetatable( t, t )
	return t
end

function HoldArrowJudge()
	local t = {
		Name = "HoldArrowJudge",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = true,
		ExportOnChange = false,
		Choices = { '1Point','2Points' },
		LoadSelections = function(self, list, pn)
			if GetAdhocPref("HoldArrowJudge") ~= nil then
				local curSet = GetAdhocPref("HoldArrowJudge")
				if curSet == '1Point' then
					list[1] = true
				elseif curSet == '2Points' then
					list[2] = true
				else
					list[1] = true
				end
			else
				SetAdhocPref("HoldArrowJudge",'1Point')
				list[1] = true
			end
		end,
		SaveSelections = function(self, list, pn)
			local tChoices = { '1Point','2Points' }
			local val
			if list[1] then
				val = tChoices[1]
			elseif list[2] then
				val = tChoices[2]
			else
				val = tChoices[1]
			end
			SetAdhocPref("HoldArrowJudge",val)
			MESSAGEMAN:Broadcast("PreferenceSet", { Message == "Set Preference" })
			THEME:ReloadMetrics()
		end,
	}
	setmetatable( t, t )
	return t
end

function ComboJudge()
	local t = {
		Name = "GoodCombo",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = true,
		ExportOnChange = false,
		Choices = { 'Off','On' },
		LoadSelections = function(self, list, pn)
			if GetAdhocPref("GoodCombo") ~= nil then
				local curSet = GetAdhocPref("GoodCombo")
				if curSet == 'TapNoteScore_W3' then
					list[1] = true
				elseif curSet == 'TapNoteScore_W4' then
					list[2] = true
				else
					list[1] = true
				end;
			else
				list[1] = true
			end
		end;
		SaveSelections = function(self, list, pn)
			local tChoices = { 'TapNoteScore_W3','TapNoteScore_W4' }
			local val
			if list[1] then
				val = tChoices[1]
			elseif list[2] then
				val = tChoices[2]
			else
				val = tChoices[1]
			end
			SetAdhocPref("GoodCombo",val)
			MESSAGEMAN:Broadcast("PreferenceSet", { Message == "Set Preference" })
			THEME:ReloadMetrics()
		end;
	};
	setmetatable( t, t )
	return t
end

function CComboIsPerRow()
	local t = {
		Name = "CComboIsPerRow",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = true,
		ExportOnChange = false,
		Choices = { 'More than 2Combos','1Combo' },
		LoadSelections = function(self, list, pn)
			if GetAdhocPref("CComboCount") ~= nil then
				local curSet = GetAdhocPref("CComboCount")
				if tostring(curSet) == "false" then
					list[1] = true
				elseif tostring(curSet) == "true" then
					list[2] = true		
				else
					list[1] = true
				end;
			else
				list[1] = true
			end
		end;
		SaveSelections = function(self, list, pn)
			local tChoices = { false,true }
			local val
			if list[1] then
				val = tChoices[1]
			elseif list[2] then
				val = tChoices[2]
			else
				val = tChoices[1]
			end
			SetAdhocPref("CComboCount",val)
			MESSAGEMAN:Broadcast("PreferenceSet", { Message == "Set Preference" })
			THEME:ReloadMetrics()
		end;
	};
	setmetatable( t, t )
	return t
end

function ComboHMissBreak()
	local t = {
		Name = "ComboHMissBreak",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = true,
		ExportOnChange = false,
		Choices = { 'Off','On' },
		LoadSelections = function(self, list, pn)
			if GetAdhocPref("HoldAllowComboBreak") ~= nil then
				local curSet = GetAdhocPref("HoldAllowComboBreak")
				if tostring(curSet) == "false" then
					list[1] = true
				elseif tostring(curSet) == "true" then
					list[2] = true		
				else
					list[1] = true
				end;
			else
				list[1] = true
			end
		end;
		SaveSelections = function(self, list, pn)
			local tChoices = { false,true }
			local val
			if list[1] then
				val = tChoices[1]
			elseif list[2] then
				val = tChoices[2]
			else
				val = tChoices[1]
			end
			SetAdhocPref("HoldAllowComboBreak",val)
			MESSAGEMAN:Broadcast("PreferenceSet", { Message == "Set Preference" })
			THEME:ReloadMetrics()
		end;
	};
	setmetatable( t, t )
	return t
end

--BGMode
function BGMode()
	local t = {
		Name = "BGScale",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = true,
		ExportOnChange = false,
		Choices = { 'Fit','Cover','WindowFull' },
		LoadSelections = function(self, list, pn)
			if GetAdhocPref("BGScale") ~= nil then
				local bShow = GetAdhocPref("BGScale")
				if bShow == 'Fit' then
					list[1] = true
				elseif bShow == 'Cover' then
					list[2] = true
				elseif bShow == 'WindowFull' then
					list[3] = true
				else
					list[1] = true
				end;
			else
				SetAdhocPref("BGScale",'Fit')
				list[1] = true
			end
		end,
		SaveSelections = function(self, list, pn)
			local bSave;
			if list[1] then
				bSave='Fit';
			elseif list[2] then
				bSave='Cover';
			elseif list[3] then
				bSave='WindowFull';
			end;
			SetAdhocPref("BGScale", bSave)
		end,
	}
	setmetatable(t, t)
	return t
end

function ScreenFilter()
	local t = {
		Name = "ScreenFilter",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = false,
		ExportOnChange = false,
		Choices = { 'Off','25%','50%','75%','100%' },
		LoadSelections = function(self, list, pn)
			local bShow
			if GetAdhocPref("ScreenFilterV2",GetAdhocPref("ProfIDSet" .. ToEnumShortString(pn))) then
				local filters = split(",",ProfIDPrefCheck("ScreenFilterV2",GetAdhocPref("ProfIDSet" .. ToEnumShortString(pn)),"Off,Black,Off"))
				bShow = filters[1]
			else bShow = ProfIDPrefCheck("ScreenFilter",GetAdhocPref("ProfIDSet" .. ToEnumShortString(pn)),"Off")
			end;
			if bShow ~= "no" then
				if bShow == 'nil' then
					list[1] = true
				elseif bShow == 'Off' then
					list[1] = true
				elseif bShow == '0.25' then
					list[2] = true
				elseif bShow == '0.5' then
					list[3] = true
				elseif bShow == '0.75' then
					list[4] = true
				elseif bShow == '1' then
					list[5] = true
				else
					list[1] = true
				end;
			else
				list[1] = true
			end
		end,
		SaveSelections = function(self, list, pn)
			local bSave
			if list[1] then
				bSave='Off'
			elseif list[2] then
				bSave='0.25'
			elseif list[3] then
				bSave='0.5'
			elseif list[4] then
				bSave='0.75'
			elseif list[5] then
				bSave='1'
			end;
			local filters = split(",",ProfIDPrefCheck("ScreenFilterV2",GetAdhocPref("ProfIDSet" .. ToEnumShortString(pn)),"Off,Black,Off"))
			SetAdhocPref("ScreenFilterV2",bSave..","..filters[2]..","..filters[3],GetAdhocPref("ProfIDSet" .. ToEnumShortString(pn)))
		end,
	}
	setmetatable(t, t)
	return t
end

function GraphType()
	local t = {
		Name = "GraphType",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = false,
		ExportOnChange = false,
		Choices = { 'CS','SM' },
		LoadSelections = function(self, list, pn)
			local bShow = ProfIDPrefCheck("GraphType",GetAdhocPref("ProfIDSet" .. ToEnumShortString(pn)),"no")
			if bShow ~= "no" then
				if bShow == 'false' then
					list[1] = true
				elseif bShow == 'nil' then
					list[1] = true
				elseif bShow == 'CS' then
					list[1] = true
				elseif bShow == 'SM' then
					list[2] = true
				else
					list[1] = true
				end;
			else
				list[1] = true
			end
		end,
		SaveSelections = function(self, list, pn)
			local bSave
			if list[1] then
				bSave='CS'
			elseif list[2] then
				bSave='SM'
			end;
			SetAdhocPref("GraphType",bSave,GetAdhocPref("ProfIDSet" .. ToEnumShortString(pn)))
		end,
	}
	setmetatable(t, t)
	return t
end

-- score graph
function P1ScoreGraph()
	local pl = PLAYER_1;
	local ttable = rtableset(pl);
	local t = {
		Name = "P1ScoreGraph",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = false,
		ExportOnChange = false,
		EnabledForPlayers= function(self) return {pl} end,
		Choices = ttable.base,
		LoadSelections = function(self, list, pn)
			local set = true
			local bShow = ProfIDPrefCheck("ScoreGraph",GetAdhocPref("ProfIDSet" .. ToEnumShortString(pl)),"")
			for h=1,#ttable.base do
				if ttable.savebase[h] == bShow then
					list[h] = true
					set = false
					break
				end
			end
			if set == true then
				list[1] = true
			end;
		end,
		SaveSelections= function(self, list, pn)
			if pn == pl then
				local bSave
				for k=1, #ttable.base do
					if list[k] == true then
						bSave = ttable.savebase[k]
						break
					end;
				end;
				SetAdhocPref("ScoreGraph",bSave,GetAdhocPref("ProfIDSet" .. ToEnumShortString(pl)))
				if IsNetConnected() then
					local p = ( (pn == "PlayerNumber_P1") and 1 or 2 );
					setenv("scoregraphp"..p,bSave);
				end;
			end
		end
	}
	setmetatable(t, t)
	return t
end

function P2ScoreGraph()
	local pl = PLAYER_2;
	local ttable = rtableset(pl);
	local t = {
		Name = "P2ScoreGraph",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = false,
		ExportOnChange = false,
		EnabledForPlayers= function(self) return {pl} end,
		Choices = ttable.base,
		LoadSelections = function(self, list, pn)
			local set = true
			local bShow = ProfIDPrefCheck("ScoreGraph",GetAdhocPref("ProfIDSet" .. ToEnumShortString(pl)),"")
			for h=1,#ttable.base do
				if ttable.savebase[h] == bShow then
					list[h] = true
					set = false
					break
				end
			end
			if set == true then
				list[1] = true
			end;
		end,
		SaveSelections= function(self, list, pn)
			if pn == pl then
				local bSave
				for k=1, #ttable.base do
					if list[k] == true then
						bSave = ttable.savebase[k]
						break
					end;
				end;
				SetAdhocPref("ScoreGraph",bSave,GetAdhocPref("ProfIDSet" .. ToEnumShortString(pl)))
			end
		end
	}
	setmetatable(t, t)
	return t
end

-- stats display
function OptionShowStats()
	local t = {
		Name = "IngameStats",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = false,
		ExportOnChange = false,
		Choices = { 'Off','On' },
		LoadSelections = function(self, list, pn)
			local bShow = ProfIDPrefCheck("IngameStats",GetAdhocPref("ProfIDSet" .. ToEnumShortString(pn)),"no")
			if bShow ~= "no" then
				if bShow == 'false' then
					list[1] = true
				elseif bShow == 'nil' then
					list[1] = true
				elseif bShow == 'Off' then
					list[1] = true
				elseif bShow == 'On' then
					list[2] = true
				else
					list[1] = true
				end;
			else
				list[1] = true
			end
		end,
		SaveSelections = function(self, list, pn)
			local bSave
			if list[1] then
				bSave='Off'
			elseif list[2] then
				bSave='On'
			end;
			SetAdhocPref("IngameStats",bSave,GetAdhocPref("ProfIDSet" .. ToEnumShortString(pn)))
		end,
	}
	setmetatable(t, t)
	return t
end

-- custom appearance
function CAppearance()
	local t = {
		Name = "CAppearance",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = false,
		ExportOnChange = false,
		Choices = { 'Off','Hidden','Sudden','Hidden+','Sudden+','Hid++Sud+','Stealth','Blink' },
		LoadSelections = function(self, list, pn)
			local bShow = ProfIDPrefCheck("CAppearance",GetAdhocPref("ProfIDSet" .. ToEnumShortString(pn)),"no")
			if bShow ~= "no" then
				if bShow == 'nil' then
					list[1] = true
				elseif bShow == 'Off' then
					list[1] = true
				elseif bShow == 'Hidden' then
					list[2] = true
				elseif bShow == 'Sudden' then
					list[3] = true
				elseif bShow == 'Hidden+' then
					list[4] = true
				elseif bShow == 'Sudden+' then
					list[5] = true
				elseif bShow == 'Hid++Sud+' then
					list[6] = true
				elseif bShow == 'Stealth' then
					list[7] = true
				elseif bShow == 'Blink' then
					list[8] = true
				else
					list[1] = true
				end;
			else
				list[1] = true
			end
		end,
		SaveSelections = function(self, list, pn)
			local bSave;
			if list[1] then
				bSave='Off'
			elseif list[2] then
				bSave='Hidden'
			elseif list[3] then
				bSave='Sudden'
			elseif list[4] then
				bSave='Hidden+'
			elseif list[5] then
				bSave='Sudden+'
			elseif list[6] then
				bSave='Hid++Sud+'
			elseif list[7] then
				bSave='Stealth'
			elseif list[8] then
				bSave='Blink'
			end;
			SetAdhocPref("CAppearance",bSave,GetAdhocPref("ProfIDSet" .. ToEnumShortString(pn)))
		end,
	}
	setmetatable(t, t)
	return t
end

-- custom cover
function CCover()
	-- [ja] テーブルに項目をに入れる
	local Choices = {}	-- [ja] 選択項目用テーブル
	local csets = split(",", CGraphicList())
	for i=1,#csets do
		Choices[#Choices+1] = csets[i]
	end
	local ChoicesStr = {}	-- [ja] ファイル一覧用テーブル
	local csstrsets = split(",", CGraphicFile())
	for i=1,#csstrsets do
		ChoicesStr[#ChoicesStr+1] = csstrsets[i]
	end
	local t = {
		Name = "CCover",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = false,
		ExportOnChange = false,
		Choices = Choices,
		LoadSelections = function(self, list, pn)
			local bShow = ProfIDPrefCheck("CCover",GetAdhocPref("ProfIDSet" .. ToEnumShortString(pn)),"")
			local set = true
			for k=1, #Choices do
				if Choices[k] == bShow then
					list[k] = true
					set = false
					break
				end;
			end;
			if set == true then
				list[1] = true
			end;
		end,
		SaveSelections = function(self, list, pn)
			local bSave
			local bbSave
			for l=1, #Choices do
				if list[l] == true then
					bSave=Choices[l]
					--if l >= 2 then
					-- [ja] OFFとRANDOMを除外
					if l >= 2 and l <= #Choices - 1 then
						if ChoicesStr[l-1] then
							bbSave=ChoicesStr[l-1]
						end;
					end;
					break
				end;
			end;
			SetAdhocPref("CCover",bSave,GetAdhocPref("ProfIDSet" .. ToEnumShortString(pn)))
			SetAdhocPref("CCoverStr",bbSave,GetAdhocPref("ProfIDSet" .. ToEnumShortString(pn)))
		end,
	}
	setmetatable(t, t)
	return t
end

local dnum = {
	Difficulty_Beginner	= 1,
	Difficulty_Easy		= 2,
	Difficulty_Medium	= 3,
	Difficulty_Hard		= 4,
	Difficulty_Challenge	= 5,
	Difficulty_Edit		= 6
};
local diff = {
	'Difficulty_Beginner',
	'Difficulty_Easy',
	'Difficulty_Medium',
	'Difficulty_Hard',
	'Difficulty_Challenge'
};
-- custom meter steps
function CMSteps()
	local curStyle = GAMESTATE:GetCurrentStyle();
	local stepsType = curStyle:GetStepsType();
	local Choices = {}	-- [ja] 選択項目ソート用テーブル
	local CChoices = {}	-- [ja] 設定保存用テーブル
	local SChoices = {}	-- [ja] 選択項目用テーブル
	local song = GAMESTATE:GetCurrentSong();
	local ss;
	if song then
		ss = song:GetStepsByStepsType( stepsType );
	end
	local editcount = 0;
	local meter = 0;
	local randomtext = THEME:GetString("MusicWheel","CustomItemRandomText");
	if getenv("exflag") == "csc" then
		-- [ja] csc用選択可能難易度チェック
		if song then
			for difflist = 1, #diff do
				local dif_unlock = getenv("difunlock_flag");
				if song:HasStepsTypeAndDifficulty(stepsType,diff[difflist]) then
					meter = song:GetOneSteps(stepsType,diff[difflist]):GetMeter();
					if dif_unlock[difflist] then
						if getenv("rnd_song") == 1 then
							table.insert(Choices,{ THEME:GetString("Difficulty",ToEnumShortString(diff[difflist])),dnum[diff[difflist]] } )
						else
							if GetAdhocPref("UserMeterType") == "CSStyle" then
								meter = GetConvertDifficulty(song,diff[difflist])
							end;
							table.insert(Choices,{ THEME:GetString("Difficulty",ToEnumShortString(diff[difflist])).." "..meter,dnum[diff[difflist]] } )
						end;
						table.insert(CChoices,{ diff[difflist],dnum[diff[difflist]] } )
					end;
				end;
			end;
		else
			table.insert(Choices,{ " "," " } )
			table.insert(CChoices,{ " "," " } )
		end;
	else
		if ss then
			for i,s in pairs(ss) do
				meter = s:GetMeter();
				--20180210
				if s:GetDifficulty() == 'Difficulty_Edit' then
					if getenv("wheelsectioncsc") ~= randomtext then
						local text = s:GetChartName() ~= "" and s:GetChartName() or s:GetDescription() 
						if #text > 15 then
							text = string.sub(text,1,15).."..."
						end;
						if GetAdhocPref("UserMeterType") == "CSStyle" then
							meter = GetConvertDifficulty(song,"Difficulty_Edit",s)
						end;
						table.insert(Choices,{ text.." "..meter,dnum[s:GetDifficulty()]+editcount } )
						table.insert(CChoices,{ s:GetDescription(),dnum[s:GetDifficulty()]+editcount } )
						editcount = editcount + 1
					end
				else
					if getenv("wheelsectioncsc") == randomtext then		--[ja] ランダム選曲時はメーター数値を追加しない
						table.insert(Choices,{ THEME:GetString("Difficulty",ToEnumShortString(s:GetDifficulty())),dnum[s:GetDifficulty()] } )
					else
						if GetAdhocPref("UserMeterType") == "CSStyle" then
							meter = GetConvertDifficulty(song,s:GetDifficulty())
						end
						table.insert(Choices,{ THEME:GetString("Difficulty",ToEnumShortString(s:GetDifficulty())).." "..meter,dnum[s:GetDifficulty()] } )
					end
					table.insert(CChoices,{ s:GetDifficulty(),dnum[s:GetDifficulty()] } )
				end;
			end;
		else
			table.insert(Choices,{ " "," " } )
			table.insert(CChoices,{ " "," " } )
		end;
	end;

	table.sort(Choices,
		function(a, b)
			if a[2] < b[2] then
				return true
			end;
		end
	);
	table.sort(CChoices,
		function(a, b)
			if a[2] < b[2] then
				return true
			end;
		end
	);
	local CCstr = "";
	for j=1, #Choices do
		table.remove(Choices[j],2)
		-- [ja] ここではテーブルの中のテーブルはnilで読み込めないので一旦結合
		if j == #Choices then
			CCstr = CCstr..""..table.concat(Choices[j])
		else
			CCstr = CCstr..""..table.concat(Choices[j])..","
		end;
		local Cstr = split(",",CCstr);
		-- [ja] 改めて選択項目用テーブルに項目を入れる
		table.insert(SChoices,Cstr[j] )
	end;
	local t = {
		Name = "CMSteps",
		LayoutType = "ShowOneInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = false,
		ExportOnChange = false,
		Choices = SChoices,
		LoadSelections = function(self, list, pn)
			if song then
				local bShow = GAMESTATE:GetCurrentSteps(pn):GetDifficulty()
				if GAMESTATE:GetCurrentSteps(pn):GetDifficulty() == 'Difficulty_Edit' then
					bShow = GAMESTATE:GetCurrentSteps(pn):GetDescription()
				end;
				local set = true
				for k=1, #Choices do
					if CChoices[k][1] == bShow then
						list[k] = true
						set = false
						break
					end;
				end;
				if set == true then
					list[1] = true
				end;
			else list[1] = true
			end;
		end,
		SaveSelections = function(self, list, pn)
			local newstep
			local bSave
			for m=1, #Choices do
				if list[m] == true then
					bSave = CChoices[m][1]
					break
				end;
			end;
			SetAdhocPref("CMSteps",bSave,GetAdhocPref("ProfIDSet" .. ToEnumShortString(pn)))
			-- [ja] 難易度セット
			if song then
				if bSave == 'Difficulty_Beginner' or bSave == 'Difficulty_Easy' or bSave == 'Difficulty_Medium' or 
				bSave == 'Difficulty_Hard' or bSave == 'Difficulty_Challenge' then
					newstep = song:GetOneSteps(stepsType,bSave);
				else
					for o,s in pairs(ss) do
						if s:GetDifficulty() == 'Difficulty_Edit' then
							if bSave == s:GetDescription() then
								newstep = s;
								break
							end;
						end;
					end;
				end;
				GAMESTATE:SetCurrentSteps(pn,newstep);
			end;
			local speed, mode= GetSpeedModeAndValueFromPoptions(pn);
			MESSAGEMAN:Broadcast("SpeedChoiceChanged", {pn= pn, mode= mode, speed= speed, step= GAMESTATE:GetCurrentSteps(pn)})
			MESSAGEMAN:Broadcast("StepChanged", {pn= pn, step= GAMESTATE:GetCurrentSteps(pn)})
		end,
	}
	setmetatable(t, t)
	return t
end

-- custom meter steps(course)
function CCMSteps()
	local curStyle = GAMESTATE:GetCurrentStyle();
	local stepsType = curStyle:GetStepsType();
	local Choices = {}	-- [ja] 選択項目ソート用テーブル
	local CChoices = {}	-- [ja] 設定保存用テーブル
	local SChoices = {}	-- [ja] 選択項目用テーブル
	local course = GAMESTATE:GetCurrentCourse();
	local song;
	local ss;
	local t_num = {};
	if course then
		for k=1, #course:GetAllTrails() do
			ss = course:GetAllTrails()[k];
			if ss:GetStepsType() == GAMESTATE:GetCurrentStyle():GetStepsType() then
				local meter = 0;
				local randomtext = THEME:GetString("MusicWheel","CustomItemRandomText");
				local mcheck = true;
				if ss then
					if ss:GetTrailEntries() then
						if GetAdhocPref("UserMeterType") == "CSStyle" then
							for te=1,#ss:GetTrailEntries() do
								if not course:GetCourseEntries()[te]:IsSecret() then
									song = course:GetCourseEntries()[te]:GetSong();
									if ss:GetTrailEntries()[te]:GetSteps():GetDifficulty() == 'Difficulty_Edit' then
										meter = meter + GetConvertDifficulty(song,"Difficulty_Edit",ss:GetTrailEntries()[te]:GetSteps());
									else
										meter = meter + GetConvertDifficulty(song,ss:GetTrailEntries()[te]:GetSteps():GetDifficulty());
									end;
								else
									mcheck = false;
									break;
								end;
							end;
							--[ja] 20150922修正
							meter = math.round(meter / #ss:GetTrailEntries());
						else meter = ss:GetMeter();
						end;
					end;
					if mcheck then
						table.insert(Choices,{ THEME:GetString("Difficulty",ToEnumShortString(ss:GetDifficulty())).." "..meter,dnum[ss:GetDifficulty()] } );
					else table.insert(Choices,{ THEME:GetString("Difficulty",ToEnumShortString(ss:GetDifficulty())),dnum[ss:GetDifficulty()] } );
					end;
					table.insert(CChoices,{ ss:GetDifficulty(),dnum[ss:GetDifficulty()] } )
					t_num[#t_num+1] = k;
				else
					table.insert(Choices,{ " "," " } )
					table.insert(CChoices,{ " "," " } )
					t_num[#t_num+1] = 1;
				end;
			end;
		end;
	else
		table.insert(Choices,{ " "," " } )
		table.insert(CChoices,{ " "," " } )
		t_num[#t_num+1] = 1;
	end;
	table.sort(Choices,
		function(a, b)
			if a[2] < b[2] then
				return true
			end;
		end
	);
	table.sort(CChoices,
		function(a, b)
			if a[2] < b[2] then
				return true
			end;
		end
	);
	local CCstr = "";
	for j=1, #Choices do
		table.remove(Choices[j],2)
		-- [ja] ここではテーブルの中のテーブルはnilで読み込めないので一旦結合
		if j == #Choices then
			CCstr = CCstr..""..table.concat(Choices[j])
		else
			CCstr = CCstr..""..table.concat(Choices[j])..","
		end;
		local Cstr = split(",",CCstr);
		-- [ja] 改めて選択項目用テーブルに項目を入れる
		table.insert(SChoices,Cstr[j] )
	end;
	local t = {
		Name = "CMSteps",
		LayoutType = "ShowOneInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = tobool(PREFSMAN:GetPreference("LockCourseDifficulties")),
		ExportOnChange = false,
		Choices = SChoices,
		LoadSelections = function(self, list, pn)
			if course then
				local bShow = GAMESTATE:GetCurrentTrail(pn):GetDifficulty()
				local set = true
				for k=1, #Choices do
					if CChoices[k][1] == bShow then
						list[k] = true
						set = false
						break
					end;
				end;
				if set == true then
					list[1] = true
				end;
			else list[1] = true
			end;
		end,
		SaveSelections = function(self, list, pn)
			local newstep
			local bSave
			for m=1, #Choices do
				if list[m] == true then
					bSave = CChoices[m][1]
					newstep = course:GetAllTrails()[t_num[m]];
					break
				end;
			end;
			if PREFSMAN:GetPreference("LockCourseDifficulties") then
				for cpn in ivalues(GAMESTATE:GetHumanPlayers()) do
					SetAdhocPref("CCMSteps",bSave,GetAdhocPref("ProfIDSet" .. ToEnumShortString(cpn)))
					-- [ja] 難易度セット
					if course and newstep then
						GAMESTATE:SetCurrentTrail(cpn,newstep);
					end;
					local speed, mode= GetSpeedModeAndValueFromPoptions(cpn);
					MESSAGEMAN:Broadcast("SpeedChoiceChanged", {pn= cpn, mode= mode, speed= speed, step= GAMESTATE:GetCurrentTrail(cpn)})
					MESSAGEMAN:Broadcast("StepChanged", {pn= cpn, step= GAMESTATE:GetCurrentTrail(cpn)})
				end
			else
				SetAdhocPref("CCMSteps",bSave,GetAdhocPref("ProfIDSet" .. ToEnumShortString(pn)))
				-- [ja] 難易度セット
				if course and newstep then
					GAMESTATE:SetCurrentTrail(pn,newstep);
				end;
				local speed, mode= GetSpeedModeAndValueFromPoptions(pn);
				MESSAGEMAN:Broadcast("SpeedChoiceChanged", {pn= pn, mode= mode, speed= speed, step= GAMESTATE:GetCurrentTrail(pn)})
				MESSAGEMAN:Broadcast("StepChanged", {pn= pn, step= GAMESTATE:GetCurrentTrail(pn)})
			end
		end,
	}
	setmetatable(t, t)
	return t
end

-- custom hide
--[ja] 20150619修正 Combo非表示追加
function CHide()
	local t = {
		Name = "CHide",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectMultiple",
		OneChoiceForAllPlayers = false,
		ExportOnChange = false,
		Choices = { 'Dark','Blind','Cover','Combo' },
		LoadSelections = function(self, list, pn)
			local bShow = ProfIDPrefCheck("CHide",GetAdhocPref("ProfIDSet" .. ToEnumShortString(pn)),"")
			local bShowS = split(",",bShow);
			for m=1, #bShowS do
				if bShowS[m] ~= nil then
					if bShowS[m] == 'Dark' then
						list[1] = true
					end
					if bShowS[m] == 'Blind' then
						list[2] = true
					end
					if bShowS[m] == 'Cover' then
						list[3] = true
					end
					if bShowS[m] == 'Combo' then
						list[4] = true
					end
				end
			end
		end,
		SaveSelections = function(self, list, pn)
			local bSave = {"No","No","No","No"};
			if list[1] then bSave[1] = "Dark" end
			if list[2] then bSave[2] = "Blind" end
			if list[3] then bSave[3] = "Cover" end
			if list[4] then bSave[4] = "Combo" end
			SetAdhocPref("CHide",bSave[1]..","..bSave[2]..","..bSave[3]..","..bSave[4],GetAdhocPref("ProfIDSet" .. ToEnumShortString(pn)))
		end,
	}
	setmetatable(t, t)
	return t
end


-- custom protiming
function CProTiming()
	local t = {
		Name = "CProTiming",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectMultiple",
		OneChoiceForAllPlayers = false,
		ExportOnChange = false,
		Choices = { 'ProTiming','FAST/SLOW','JudgeTable' },
		LoadSelections = function(self, list, pn)
			local bShow = ProfIDPrefCheck("CProTiming",GetAdhocPref("ProfIDSet" .. ToEnumShortString(pn)),"")
			local bShowS = split(",",bShow);
			for m=1, #bShowS do
				if bShowS[m] ~= nil then
					if bShowS[m] == 'ProTiming' then
						list[1] = true
					end
					if bShowS[m] == 'FAST/SLOW' then
						list[2] = true
					end
					if bShowS[m] == 'JudgeTable' then
						list[3] = true
					end
				end
			end
		end,
		SaveSelections = function(self, list, pn)
			local bSet
			if GetAdhocPref("ProfIDSet" .. ToEnumShortString(pn)) then
				bSet = "CProTiming" .. GetAdhocPref("ProfIDSet" .. ToEnumShortString(pn))
			else
				bSet = "CProTiming" .. ToEnumShortString(pn)
			end
			local bSave = {"No","No","No"};
			if list[1] then bSave[1] = "ProTiming" end
			if list[2] then bSave[2] = "FAST/SLOW" end
			if list[3] then bSave[3] = "JudgeTable" end
			SetAdhocPref("CProTiming",bSave[1]..","..bSave[2]..","..bSave[3],GetAdhocPref("ProfIDSet" .. ToEnumShortString(pn)))
		end,
	}
	setmetatable(t, t)
	return t
end

local default_speed_increment= 25
local default_speed_inc_large= 100

local function get_speed_increment()
	local increment= default_speed_increment
	if ReadGamePrefFromFile("SpeedIncrement") then
		increment= tonumber(GetGamePref("SpeedIncrement")) or default_speed_increment
	else
		WriteGamePrefToFile("SpeedIncrement", increment)
	end
	return increment
end

local function get_speed_inc_large()
	local inc_large= default_speed_inc_large
	if ReadGamePrefFromFile("SpeedIncLarge") then
		inc_large= tonumber(GetGamePref("SpeedIncLarge")) or default_speed_inc_large
	else
		WriteGamePrefToFile("SpeedIncLarge", inc_large)
	end
	return inc_large
end


function SpeedModGamePlayInc()
	local increment= get_speed_increment()
	local inc_large= get_speed_inc_large()
	local ret= {
		Name= "GamePlaySpeedIncrement",
		LayoutType= "ShowAllInRow",
		SelectType= "SelectMultiple",
		OneChoiceForAllPlayers= false,
		LoadSelections= function(self, list, pn)
			if pn == PLAYER_1 or self.NumPlayers == 1 then
				list[1]= true
			else
				list[2]= true
			end
		end,
		SaveSelections= function(self, list, pn)
			local val= self.CurValues[pn]
			if val.set > 0 then
				val.set= math.round(val.set)
				if val.set >= 500 then val.set= 500
				end
			end
			SetAdhocPref("GamePlaySpeedIncrement",val.set,GetAdhocPref("ProfIDSet" .. ToEnumShortString(pn)))
		end,
		NotifyOfSelection= function(self, pn, choice)
			local real_choice= choice - self.NumPlayers
			if real_choice < 1 then return true end
			local val= self.CurValues[pn]
			if real_choice < 5 then
				local incs= {inc_large, increment, -increment, -inc_large}
				local new_val= val.set + incs[real_choice]
				if new_val > 0 then
					val.set= math.round(new_val)
					if val.set >= 500 then val.set= 500
					end
				end
			end
			self:GenChoices()
			return true
		end,
		GenChoices= function(self)
			local inc= tostring(increment)
			local big_inc= tostring(inc_large)
			self.Choices= {"+"..big_inc,"+"..inc,"-"..inc,"-"..big_inc}
			for i, pn in ipairs({PLAYER_2, PLAYER_1}) do
				local val= self.CurValues[pn]
				if val then
					table.insert(self.Choices, 1, val.set)
				end
			end
		end,
		CurValues= {},
		NumPlayers= 0
	}
	for i, pn in ipairs(GAMESTATE:GetEnabledPlayers()) do
		if GAMESTATE:IsHumanPlayer(pn) then
			local set = math.round(tonumber( ProfIDPrefCheck("GamePlaySpeedIncrement",GetAdhocPref("ProfIDSet" .. ToEnumShortString(pn)),default_speed_increment) ))
			if set then
				ret.CurValues[pn]= {set= set}
				ret.NumPlayers= ret.NumPlayers + 1
			end
		end
	end
	ret:GenChoices()
	return ret
end

-- custom failtype
function CFailType()
	local t = {
		Name = "CFailType",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = false,
		ExportOnChange = false,
		Choices = {'Immediate','ImmediateContinue','EndOfSong','Off'},
		LoadSelections = function(self, list, pn)
			local lset = GAMESTATE:GetPlayerState(pn):GetPlayerOptions("ModsLevel_Preferred"):FailSetting():sub(10)
			local set = true
			for i, c in ipairs(self.Choices) do
				if c == lset then
					list[i] = true
					set = false
					break
				end
			end
			if set == true then
				list[1] = true
			end;
		end,
		SaveSelections= function(self, list, pn)
			for i, c in ipairs(self.Choices) do
				if list[i] then
					--[ja] 20150514修正
					local mlevel = "ModsLevel_Preferred"
					GAMESTATE:GetPlayerState(pn):GetPlayerOptions(mlevel):FailSetting("FailType_" .. c)
				end
			end
		end
	}
	setmetatable(t, t)
	return t
end

-- custom lifetype
function CLifeType()
	local t = {
		Name = "CLifeType",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = false,
		ExportOnChange = false,
		Choices = GAMESTATE:IsCourseMode() and {'Bar','Battery','Time'} or {'Bar','Battery'},
		LoadSelections = function(self, list, pn)
			local lset = GAMESTATE:GetPlayerState(pn):GetPlayerOptions("ModsLevel_Preferred"):LifeSetting():sub(10)
			local set = true
			for i, c in ipairs(self.Choices) do
				if c == lset then
					list[i] = true
					set = false
					break
				end
			end
			if set == true then
				list[1] = true
			end;
		end,
		SaveSelections= function(self, list, pn)
			for i, c in ipairs(self.Choices) do
				if list[i] then
					--[ja] 20150514修正
					local mlevel = "ModsLevel_Preferred"
					GAMESTATE:GetPlayerState(pn):GetPlayerOptions(mlevel):LifeSetting("LifeType_" .. c)
				end
			end
		end
	}
	setmetatable(t, t)
	return t
end

-- custom bardrain
function CBarDrain()
	local t = {
		Name = "CBarDrain",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = false,
		ExportOnChange = false,
		--Choices = GAMESTATE:IsCourseMode() and {'Normal','NoRecover','SuddenDeath','Battery','Time'} or {'Normal','NoRecover','SuddenDeath','Battery'},
		Choices = {'Normal','NoRecover','SuddenDeath','Battery'},
		LoadSelections = function(self, list, pn)
			local dtype = GAMESTATE:GetPlayerState(pn):GetPlayerOptions("ModsLevel_Preferred"):DrainSetting():sub(11)
			local lset = GAMESTATE:GetPlayerState(pn):GetPlayerOptions("ModsLevel_Preferred"):LifeSetting():sub(10)
			local set = true
			for i, c in ipairs(self.Choices) do
				if lset == "Battery" then
					if c == lset then
						list[i] = true
						set = false
						break
					end
				end
				if lset == "Time" then
					if c == lset then
						list[i] = true
						set = false
						break

					end
				end
				if lset == "Bar" then
					if c == dtype then
						list[i] = true
						set = false
						break

					end
				end
			end
			if set == true then
				list[1] = true
			end;
		end,
		SaveSelections= function(self, list, pn)
			for i, c in ipairs(self.Choices) do
				if list[i] then
					--[ja] 20150514修正
					local mlevel = "ModsLevel_Preferred"
					if c ~= "Battery" and c ~= "Time" then
						GAMESTATE:GetPlayerState(pn):GetPlayerOptions(mlevel):LifeSetting("LifeType_Bar")
						GAMESTATE:GetPlayerState(pn):GetPlayerOptions(mlevel):DrainSetting("DrainType_" .. c)
					else
						GAMESTATE:GetPlayerState(pn):GetPlayerOptions(mlevel):LifeSetting("LifeType_" .. c)
					end
				end
			end
		end
	}
	setmetatable(t, t)
	return t
end

-- custom batlives
function CBatLives()
	local increment= 1
	local ret= {
		Name= "CBatLives",
		LayoutType= "ShowAllInRow",
		SelectType= "SelectMultiple",
		OneChoiceForAllPlayers= false,
		LoadSelections= function(self, list, pn)
			-- The first values display the current status of the speed mod.
			if pn == PLAYER_1 or self.NumPlayers == 1 then
				list[1]= true
			else
				list[2]= true
			end
		end,
		SaveSelections= function(self, list, pn)
			local val= self.CurValues[pn]
			local poptions= GAMESTATE:GetPlayerState(pn):GetPlayerOptions("ModsLevel_Preferred")
			local stoptions= GAMESTATE:GetPlayerState(pn):GetPlayerOptions("ModsLevel_Stage")
			local soptions= GAMESTATE:GetPlayerState(pn):GetPlayerOptions("ModsLevel_Song")
			local coptions= GAMESTATE:GetPlayerState(pn):GetPlayerOptions("ModsLevel_Current")
			if val.set > 0 then
				val.set= math.round(val.set)
				if val.set > 9 then val.set= 10
				end
			end
			poptions:BatteryLives(val.set)
			stoptions:BatteryLives(val.set)
			soptions:BatteryLives(val.set)
			coptions:BatteryLives(val.set)
		end,
		NotifyOfSelection= function(self, pn, choice)
			-- Adjust for the status elements
			local real_choice= choice - self.NumPlayers
			-- return true even though we didn't actually change anything so that
			-- the underlines will stay correct.
			if real_choice < 1 then return true end
			local val= self.CurValues[pn]
			if real_choice < 5 then
				local incs= {increment,-increment}
				local new_val= val.set + incs[real_choice]
				if new_val > 0 then
					val.set= math.round(new_val)
					if new_val > 9 then val.set= 10
					end
				end
			end
			self:GenChoices()
			return true
		end,
		GenChoices= function(self)
			local inc= tostring(increment)
			self.Choices= {"+"..inc, "-"..inc}
			-- Insert the status element for P2 first so it will be second
			for i, pn in ipairs({PLAYER_2, PLAYER_1}) do
				local val= self.CurValues[pn]
				if val then
					table.insert(self.Choices, 1, val.set)
				end
			end
		end,
		CurValues= {}, -- for easy tracking of what speed the player wants
		NumPlayers= 0 -- for ease when adjusting for the status elements.
	}
	for i, pn in ipairs(GAMESTATE:GetEnabledPlayers()) do
		if GAMESTATE:IsHumanPlayer(pn) then
			local set= 1
			--[ja] 20150514修正
			local mlevel = "ModsLevel_Preferred"
			local op= GAMESTATE:GetPlayerState(pn):GetPlayerOptions(mlevel)
			if op:BatteryLives() > 0 then
				set= math.round(GAMESTATE:GetPlayerState(pn):GetPlayerOptions(mlevel):BatteryLives())
			end
			ret.CurValues[pn]= {set= set}
			ret.NumPlayers= ret.NumPlayers + 1
		end
	end
	ret:GenChoices()
	return ret
end

function MiPiCheck()
	local mipl = { "-","+"}
	local mpcheck = mipl[math.random(#mipl)]
	return mpcheck
end
function HNumCheck()
	local num = {"0.1","0.2","0.3","0.4","0.5","0.6","0.7","0.8","0.9","1"}
	local numcheck = num[math.random(#num)]
	return numcheck
end

-- custom rate
function CRate()
	local increment= 1
	if GetAdhocPref("CRate") ~= nil then
		increment= GetAdhocPref("CRate")
	end
	local hset = ""
	if tonumber(increment) > 3 then
		hset= "Haste"
		increment= 3.05
	end
	local ret= {
		Name= "Rate",
		LayoutType= "ShowAllInRow",
		SelectType= "SelectMultiple",
		OneChoiceForAllPlayers= true,
		LoadSelections= function(self, list, pn)
			list[1]= true
		end,
		SaveSelections= function(self, list, pn)
			local so = GAMESTATE:GetDefaultSongOptions();
			local poptions= GAMESTATE:GetSongOptionsObject("ModsLevel_Preferred")
			local stoptions= GAMESTATE:GetSongOptionsObject("ModsLevel_Stage")
			local soptions= GAMESTATE:GetSongOptionsObject("ModsLevel_Song")
			local coptions= GAMESTATE:GetSongOptionsObject("ModsLevel_Current")
			--20161026
			if tonumber(round2(increment,3)) > 0 then
				if tonumber(round2(increment,3)) > 3.01 then
					hset= "Haste"
					increment= 3.05
				else
					hset= ""
					if tonumber(increment) < 0.1 then
						if round2(increment,3) > 0.05 then increment= 0.1
						elseif round2(increment,3) <= 0.05 then increment= 0.05
						end
					end
				end
			else increment= 0.05
			end
			local bSave= increment
			if hset == "Haste" then
				poptions:MusicRate(1)
				stoptions:MusicRate(1)
				soptions:MusicRate(1)
				coptions:MusicRate(1)
				if MiPiCheck() == "-" then
					poptions:Haste(-tonumber(HNumCheck()))
					stoptions:Haste(-tonumber(HNumCheck()))
					soptions:Haste(-tonumber(HNumCheck()))
					coptions:Haste(-tonumber(HNumCheck()))
				else
					poptions:Haste(tonumber(HNumCheck()))
					stoptions:Haste(tonumber(HNumCheck()))
					soptions:Haste(tonumber(HNumCheck()))
					coptions:Haste(tonumber(HNumCheck()))
				end;
			else
				--20161026
				local cm_rate= round2(increment,3)
				poptions:MusicRate(cm_rate)
				stoptions:MusicRate(cm_rate)
				soptions:MusicRate(cm_rate)
				coptions:MusicRate(cm_rate)
				poptions:Haste(0)
				stoptions:Haste(0)
				soptions:Haste(0)
				coptions:Haste(0)
			end
			SetAdhocPref("CRate", bSave)
		end,
		NotifyOfSelection= function(self, pn, choice)
			if choice == 1 then return true end
			local incs= {0.1, 0.05, -0.05, -0.1}
			local new_val= tonumber(increment) + incs[choice-1]
			if new_val > 0 then
				increment= new_val
				if new_val > 3.01 then
					hset= "Haste"
					increment= 3.05
				else
					hset= ""
					if new_val < 0.1 then
						if new_val > 0.05 then increment= 0.1
						elseif new_val <= 0.05 then increment= 0.05
						end
					end
				end
			end
			self:GenChoices()
			return true
		end,
		GenChoices= function(self)
			--20161026
			local set= tonumber(round(increment,3))
			if set > 3.01 then
				set= "Haste"
			end
			if hset == "Haste" then
				set= "Haste"
			end
			if set ~= "Haste" then
				set= tostring(round2(set,3)).."x"
			end
			self.Choices= {set, "+0.1", "+0.05", "-0.05", "-0.1"}
		end
	}
	ret:GenChoices()
	return ret
end

-- fix bgmode
function CBackground()
	local t = {
		Name = "CBackground",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = true,
		ExportOnChange = false,
		Choices = {'Default','Static Background','Random Background'},
		LoadSelections = function(self, list, pn)
			local set = true
			local mode = "Default"
			if GetAdhocPref("CBGMode") ~= nil then
				mode = GetAdhocPref("CBGMode")
			end
			for i, c in ipairs(self.Choices) do
				if c == mode then
					list[i] = true
					set = false
					break
				end
			end
			if set == true then
				list[1] = true
			end;
		end,
		SaveSelections= function(self, list, pn)
			for i, c in ipairs(self.Choices) do
				if list[i] then
					--[ja] 20150514修正
					local mlevel = "ModsLevel_Preferred"
					if c == "Static Background" then
						GAMESTATE:GetSongOptionsObject(mlevel):RandomBGOnly(false)
						GAMESTATE:GetSongOptionsObject(mlevel):StaticBackground(true)
						SetAdhocPref("CBGMode", "Static Background")
					elseif c == "Random Background" then
						GAMESTATE:GetSongOptionsObject(mlevel):RandomBGOnly(true)
						GAMESTATE:GetSongOptionsObject(mlevel):StaticBackground(false)
						SetAdhocPref("CBGMode", "Random Background")
					else
						GAMESTATE:GetSongOptionsObject(mlevel):RandomBGOnly(false)
						GAMESTATE:GetSongOptionsObject(mlevel):StaticBackground(false)
						SetAdhocPref("CBGMode", "Default")
					end
				end
			end
		end
	}
	setmetatable(t, t)
	return t
end

function GamePrefDefaultFail2()
	local t = {
		Name = "GamePrefDefaultFail2";
		LayoutType = "ShowAllInRow";
		SelectType = "SelectOne";
		OneChoiceForAllPlayers = true;
		ExportOnChange = false;
		Choices = { "Immediate","ImmediateContinue", "EndOfSong", "Off" };
		LoadSelections = function(self, list, pn)
			local set = true
			for i, c in ipairs(self.Choices) do
				if InitPrefsFail() ~= GetAdhocPref("TempDefaultFail") then
					if "Fail"..c == GetAdhocPref("TempDefaultFail") then
						list[i] = true
						set = false
						break
					end
				else
					if "Fail"..c == InitPrefsFail() then
						list[i] = true
						set = false
						break
					end
				end
			end
			if set == true then
				list[1] = true
			end;
		end;
		SaveSelections = function(self, list, pn)
			for i, c in ipairs(self.Choices) do
				if list[i] then
					SetAdhocPref("TempDefaultFail","Fail"..c)
				end
			end
			MESSAGEMAN:Broadcast("PreferenceSet", { Message == "Set Preference" } )
			THEME:ReloadMetrics()
		end;
	};
	setmetatable( t, t );
	return t;
end

--[ja] 20150602修正
-- custom noteskin
function CEditorNoteSkins()
	local t = {
		Name = "NoteSkins",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = false,
		ExportOnChange = false,
		Choices = NOTESKIN:GetNoteSkinNames(),
		LoadSelections = function(self, list, pn)
			local e_pnnote = PREFSMAN:GetPreference('EditorNoteSkin'..ToEnumShortString(pn));
			local poptions= GAMESTATE:GetPlayerState(pn):GetPlayerOptions("ModsLevel_Preferred")
			local set = true
			for i, c in ipairs(self.Choices) do
				if string.lower(c) == string.lower(e_pnnote) then
					list[i] = true
					set = false
					break
				else
					if string.lower(c) == string.lower(poptions:NoteSkin()) then
						list[i] = true
						set = false
						break
					end
				end
			end
			if set == true then
				list[1] = true
			end;
		end,
		SaveSelections= function(self, list, pn)
			local poptions= GAMESTATE:GetPlayerState(pn):GetPlayerOptions("ModsLevel_Preferred")
			local stoptions= GAMESTATE:GetPlayerState(pn):GetPlayerOptions("ModsLevel_Stage")
			local soptions= GAMESTATE:GetPlayerState(pn):GetPlayerOptions("ModsLevel_Song")
			local coptions= GAMESTATE:GetPlayerState(pn):GetPlayerOptions("ModsLevel_Current")
			for i, c in ipairs(self.Choices) do
				if list[i] then
					poptions:NoteSkin(c)
					stoptions:NoteSkin(c)
					soptions:NoteSkin(c)
					coptions:NoteSkin(c)
				end
			end
		end
	}
	setmetatable(t, t)
	return t
end

-- custom mini
--[[
function CMini()
	local increment= 1
	local inc_large= 10
	local hset = ""
	local ret= {
		Name= "MiniList",
		LayoutType= "ShowAllInRow",
		SelectType= "SelectMultiple",
		OneChoiceForAllPlayers= false,
		LoadSelections= function(self, list, pn)
			if pn == PLAYER_1 or self.NumPlayers == 1 then
				list[1]= true
			else
				list[2]= true
			end
		end,
		SaveSelections= function(self, list, pn)
			local val= self.CurValues[pn]
			local poptions= GAMESTATE:GetPlayerState(pn):GetPlayerOptions("ModsLevel_Preferred")
			local stoptions= GAMESTATE:GetPlayerState(pn):GetPlayerOptions("ModsLevel_Stage")
			local soptions= GAMESTATE:GetPlayerState(pn):GetPlayerOptions("ModsLevel_Song")
			local coptions= GAMESTATE:GetPlayerState(pn):GetPlayerOptions("ModsLevel_Current")
			local mset = scale(val.set,-100,100,1,-1);
			poptions:Mini(mset)
			stoptions:Mini(mset)
			soptions:Mini(mset)
			coptions:Mini(mset)
			SetAdhocPref("CNoteSize",val.mode..","..val.set,GetAdhocPref("ProfIDSet" .. ToEnumShortString(pn)))
		end,
		NotifyOfSelection= function(self, pn, choice)
			hset= ""
			local real_choice= choice - self.NumPlayers
			if real_choice < 1 then return true end
			local val= self.CurValues[pn]
			if real_choice < 5 then
				local incs= {inc_large, increment, -increment, -inc_large}
				local new_val= val.set + incs[real_choice]
				if new_val >= 100 then
					new_val= 100
					hset = "Big";
				else
					if new_val == 0 then hset = "Normal"; end;
					if new_val == -65 then hset = "Mini"; end;
					if new_val < -100 then new_val= -100; end;
				end
				val.set= new_val
			elseif real_choice >= 5 then
				val.mode= ({"New", "Old"})[real_choice - 4]
			end
			self:GenChoices()
			return true
		end,
		GenChoices= function(self)
			local big_inc= inc_large
			local small_inc= increment
			big_inc= tostring(big_inc)
			small_inc= tostring(increment)
			self.Choices= {
				"+" .. big_inc, "+" .. small_inc, "-" .. small_inc, "-" .. big_inc,
				"New", "Old"}
			for i, pn in ipairs({PLAYER_2, PLAYER_1}) do
				local val= self.CurValues[pn]
				if val then
					local sset= tonumber(val.set)
					if sset >= 100 then sset= "Big"; end;
					if sset == -65 then sset= "Mini"; end;
					if sset == 0 then sset = "Normal"; end;
					if hset == "Big" then sset= "Big"; end;
					if hset == "Mini" then sset= "Mini"; end;
					if sset ~= "Big" and sset ~= "Mini" and sset ~= "Normal" then
						sset= tostring(val.set)
					end
					table.insert(self.Choices, 1, val.mode.." : "..sset)
				end
			end
		end,
		CurValues= {},
		NumPlayers= 0
	}
	for i, pn in ipairs(GAMESTATE:GetEnabledPlayers()) do
		if GAMESTATE:IsHumanPlayer(pn) then
			local csize = split(",",ProfIDPrefCheck("CNoteSize",GetAdhocPref("ProfIDSet" .. ToEnumShortString(pn)),"New,0"))
			local mode = csize[1]
			local set = tonumber(csize[2])
			ret.CurValues[pn]= {mode= mode, set= set}
			ret.NumPlayers= ret.NumPlayers + 1
		end
	end
	ret:GenChoices()
	return ret
end
]]

--[ja] 20160129修正
function DiffListAnimation()
	local t = {
		Name = "DiffListAnimation";
		LayoutType = "ShowAllInRow";
		SelectType = "SelectOne";
		OneChoiceForAllPlayers = true;
		ExportOnChange = false;
		Choices = { 'Off','On' },
		LoadSelections = function(self, list, pn)
			if GetAdhocPref("DiffListAnimation") ~= nil then
				local curSet = GetAdhocPref("DiffListAnimation")
				if curSet == '0.001' then
					list[1] = true
				elseif curSet == '0.15' then
					list[2] = true
				else
					list[1] = true
				end;
			else
				list[1] = true
			end
		end;
		SaveSelections = function(self, list, pn)
			local tChoices = { '0.001','0.15' }
			local val
			if list[1] then
				val = tChoices[1]
			elseif list[2] then
				val = tChoices[2]
			else
				val = tChoices[1]
			end
			SetAdhocPref("DiffListAnimation",val)
			MESSAGEMAN:Broadcast("PreferenceSet", { Message == "Set Preference" })
			THEME:ReloadMetrics()
		end;
	};
	setmetatable( t, t )
	return t;
end;

function CSLAEasterEggs()
	local t = {
		Name = "CSLAEasterEggs";
		LayoutType = "ShowAllInRow";
		SelectType = "SelectOne";
		OneChoiceForAllPlayers = true;
		ExportOnChange = false;
		Choices = { 'Off','On' },
		LoadSelections = function(self, list, pn)
			if GetAdhocPref("CSLAEasterEggs") ~= nil then
				local curSet = GetAdhocPref("CSLAEasterEggs")
				if tostring(curSet) == "false" then
					list[1] = true
				elseif tostring(curSet) == "true" then
					list[2] = true
				else
					list[1] = true
				end;
			else
				list[1] = true
			end
		end;
		SaveSelections = function(self, list, pn)
			local tChoices = { false,true }
			local val
			if list[1] then
				val = tChoices[1]
			elseif list[2] then
				val = tChoices[2]
			else
				val = tChoices[1]
			end
			SetAdhocPref("CSLAEasterEggs",val)
			MESSAGEMAN:Broadcast("PreferenceSet", { Message == "Set Preference" })
			THEME:ReloadMetrics()
		end;
	};
	setmetatable( t, t )
	return t;
end;

--20160418
function EditorDefaultNoteSkins()
	local t = {
		Name = "EditorDefaultNoteskin",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = true,
		ExportOnChange = false,
		Choices = NOTESKIN:GetNoteSkinNames(),
		LoadSelections = function(self, list, pn)
			local set = true
			local e_pnnote = PREFSMAN:GetPreference("EditorNoteSkinP1") or
				PREFSMAN:GetPreference("EditorNoteSkinP2") or
				THEME:GetMetric("Common", "DefaultNoteSkinName")
			for i, c in ipairs(self.Choices) do
				if string.lower(c) == string.lower(e_pnnote) then
					list[i] = true
					set = false
					break
				end
			end
			if set == true then
				list[1] = true
			end;
		end,
		SaveSelections = function(self, list, pn)
			for i, c in ipairs(self.Choices) do
				if list[i] then
					PREFSMAN:SetPreference("EditorNoteSkinP1", c)
					PREFSMAN:SetPreference("EditorNoteSkinP2", c)
					break
				end
			end
		end,
	}
	return t;
end;
--20160420
function CustomCoinMode()
	local t = {
		Name = "CustomCoinMode",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = true,
		ExportOnChange = false,
		Choices = { 'Home','Free Play' },
		LoadSelections = function(self, list, pn)
			local cmode = ToEnumShortString(PREFSMAN:GetPreference("CoinMode"))
			if cmode == "Home" then
				list[1] = true
			elseif cmode == "Free" then
				list[2] = true
			else list[2] = true
			end;
		end,
		SaveSelections = function(self, list, pn)
			local tChoices = { 'Home','Free' }
			for i, c in ipairs(tChoices) do
				if list[i] then
					PREFSMAN:SetPreference("CoinMode", "CoinMode_"..c)
					break
				end
			end
			THEME:ReloadMetrics()
		end;
	};
	setmetatable( t, t )
	return t
end;
--20161109
function CLyrics()
	local t = {
		Name = "CLyrics",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = true,
		ExportOnChange = false,
		Choices = { 'Hide','Show' },
		LoadSelections = function(self, list, pn)
			local clyric = tobool(PREFSMAN:GetPreference("ShowLyrics"))
			if clyric == true then
				list[2] = true
			else list[1] = true
			end;
		end,
		SaveSelections = function(self, list, pn)
			local tChoices = { false,true }
			for i, c in ipairs(tChoices) do
				if list[i] then
					PREFSMAN:SetPreference("ShowLyrics", c)
					break
				end
			end
			THEME:ReloadMetrics()
		end;
	};
	setmetatable( t, t )
	return t
end;
--20180218
function SNSort()
	local t = {
		Name = "SNSort",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = true,
		ExportOnChange = false,
		Choices = { 'Off','On' },
		LoadSelections = function(self, list, pn)
			local snsort = tobool(GetAdhocPref("SCustomNemeSort"))
			if snsort == true then
				list[2] = true
			else list[1] = true
			end;
		end,
		SaveSelections = function(self, list, pn)
			local tChoices = { false,true }
			for i, c in ipairs(tChoices) do
				if list[i] then
					SetAdhocPref("SCustomNemeSort", c)
					break
				end
			end
			THEME:ReloadMetrics()
		end;
	};
	setmetatable( t, t )
	return t
end;
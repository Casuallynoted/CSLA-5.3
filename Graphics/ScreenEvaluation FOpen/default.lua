local t = Def.ActorFrame{};

local psStats = STATSMAN:GetPlayedStageStats(1);
local g_group = "false";
if GetAdhocPref("G_Group") then
	g_group = GetAdhocPref("G_Group");
end;
local groupstringset = g_group;
local sectioncolorlist = getenv("sectioncolorlist");
local sectionsubnamelist = getenv("sectionsubnamelist");
if sectionsubnamelist[g_group] then
	groupstringset = sectionsubnamelist[g_group];
end;

local csffex = g_group ~= "false" and psStats:GetStage() == "Stage_Extra2"; 
local checktable = {
	{ Name = "Sco" , Count = 0 , Flagcount = 0 },
	{ Name = "Lco" , Count = 0 , Flagcount = 0 },
	{ Name = "Non" , Count = 0 , Flagcount = 0 },
	{ Name = "Cha" , Count = 0 , Flagcount = 0 },
	{ Name = "End" , Count = 0 , Flagcount = 0 },
	{ Name = "Rav" , Count = 0 , Flagcount = 0 },
	{ Name = "Ecco" , Count = 0 , Flagcount = 0 },
	{ Name = "Esco" , Count = 0 , Flagcount = 0 },
	{ Name = "Ccco" , Count = 0 , Flagcount = 0 },
	{ Name = "Csco" , Count = 0 , Flagcount = 0 },
	{ Name = "Elco" , Count = 0 , Flagcount = 0 },
};
local ecftable = {
	{ Name = "R7-4thMix" , Count = 0 , Flagcount = 0 },
};

if getenv("evacheckflag") == 1 then
	--[ja] デバッグ時は"CSLSetApp"チェック
	local cf_flag = "";
	local ef_flag = "";
	if getenv("ffset")[1] then
		cf_flag = split(":",getenv("ffset")[1]);
	end;
	if getenv("ffset")[2] then
		ef_flag = split(":",getenv("ffset")[2]);
	end;
	local k = 0;
	local text_k = {};
	local text = {};
	local ccpoint = {};
	local ecpoint = {};
	local cf_point;
	local ecffc = 0;
	if csffex then
		text_k[#text_k+1] = g_group;
	end;
	local csl_c = GetAdhocPref("CSLSetApp") ~= "00000001" and GetAdhocPref("CSLSetApp") ~= "32594786";
	if FILEMAN:DoesFileExist( cc_path ) then
		for idx, cat in pairs(checktable) do
			local ccName = cat.Name;
			local ccCount = cat.Count;
			local ccFcount = cat.Flagcount;
			if #cf_flag > 0 then
				for cfpp=1,#cf_flag do
					if cf_flag[cfpp] ~= "" then
						cf_point = split(",",cf_flag[cfpp]);
						if #cf_point >= 3 then
							if cf_point[1] == ccName then
								if tonumber(cf_point[2]) then
									ccCount = cf_point[2];
								end;
								if tonumber(cf_point[3]) then
									ccFcount = cf_point[3]
								end;
								if ccName == "Sco" then
									if (tonumber(ccCount) >= 1 and tonumber(ccCount) < 20) and tonumber(ccFcount) == 0 then
										if csl_c then
											text[#text+1] = "Regular";
										end;
										ccFcount = 1;
									elseif (tonumber(ccCount) >= 20 and tonumber(ccCount) < 50) and tonumber(ccFcount) == 1 then
										text[#text+1] = "White";
										ccFcount = 2;
									elseif (tonumber(ccCount) >= 50 and tonumber(ccCount) < 100) and tonumber(ccFcount) == 2 then
										text[#text+1] = "Black";
										ccFcount = 3;
									elseif (tonumber(ccCount) >= 100 and tonumber(ccCount) < 200) and tonumber(ccFcount) == 3 then
										text[#text+1] = "Gold";
										ccFcount = 4;
									elseif tonumber(ccCount) >= 200 and tonumber(ccFcount) == 4 then
										text[#text+1] = "Metal";
										ccFcount = 5;
									end;
								elseif ccName == "Lco" then
									if tonumber(ccCount) >= 50 and tonumber(ccFcount) == 0 then
										text[#text+1] = "Cutie";
										ccFcount = 1;
									end;
								elseif ccName == "Ecco" then
									if tonumber(ccCount) >= 5 and tonumber(ccFcount) == 0 then
										text[#text+1] = "Extra";
										ccFcount = 1;
									end;
								elseif ccName == "Esco" then
									if tonumber(ccCount) >= 5 and tonumber(ccFcount) == 0 then
										text[#text+1] = "Special";
										ccFcount = 1;
									end;
								elseif ccName == "Ccco" then
									if tonumber(ccCount) >= 5 and tonumber(ccFcount) == 0 then
										text[#text+1] = "Cyan";
										ccFcount = 1;
									end;
								elseif ccName == "Csco" then
									if tonumber(ccCount) >= 5 and tonumber(ccFcount) == 0 then
										text[#text+1] = "Cyan_Special";
										ccFcount = 1;
									end;
								elseif ccName == "Elco" then
									if tonumber(ccCount) == 1 and tonumber(ccFcount) == 0 then
										text[#text+1] = "Cs1";
										ccFcount = 1;
									elseif tonumber(ccCount) >= 2 and tonumber(ccFcount) == 1 then
										text[#text+1] = "Cs6";
										ccFcount = 2;
									end;
								elseif ccName == "Non" then
									if tonumber(ccCount) >= 3 and tonumber(ccFcount) == 0 then
										if csl_c then
											text[#text+1] = "Nonstop";
										end;
										ccFcount = 1;
									end;
								elseif ccName == "Cha" then
									if tonumber(ccCount) >= 3 and tonumber(ccFcount) == 0 then
										if csl_c then
											text[#text+1] = "Challenge";
										end;
										ccFcount = 1;
									end;
								elseif ccName == "End" then
									if tonumber(ccCount) >= 1 and tonumber(ccFcount) == 0 then
										if csl_c then
											text[#text+1] = "Endless";
										end;
										ccFcount = 1;
									end;
								elseif ccName == "Rav" then
									if tonumber(ccCount) >= 20 and tonumber(ccFcount) == 0 then
										if csl_c then
											text[#text+1] = "Rave";
										end;
										ccFcount = 1;
									end;
								end;
							end;
						elseif #cf_point == 2 then
							if tonumber(cf_point[2]) then
								ccCount = cf_point[2];
							end;
						end;
					end;
				end;
			end;
			ccpoint[#ccpoint+1] = { ""..ccName..","..ccCount..","..ccFcount..":" };
		end;
		for idx, cat in pairs(ecftable) do
			local ecName = cat.Name;
			local ecCount = cat.Count;
			local ecFcount = cat.Flagcount;
			if #ef_flag > 0 then
				for efpp=1,#ef_flag do
					if ef_flag[efpp] ~= "" then
						ef_point = split(",",ef_flag[efpp]);
						if #ef_point >= 3 then
							if ef_point[1] == ecName then
								if tonumber(ef_point[2]) then
									ecCount = ef_point[2];
								end;
								if tonumber(ef_point[3]) then
									ecFcount = ef_point[3]
								end;
								if ecName == "R7-4thMix" then
									if tonumber(ecCount) > 0 and tonumber(ecFcount) == 0 then
										text[#text+1] = "R7-4thMix";
										ecFcount = 1;
									end;
								end;
							end;
						elseif #ef_point == 2 then
							if tonumber(ef_point[2]) then
								ecCount = ef_point[2];
							end;
						end;
					end;
				end;
			end;
			ecffc = ecffc + 1;
			ecpoint[#ecpoint+1] = { ""..ecName..","..ecCount..","..ecFcount..":" };
		end;
--[[
	else

		for idx, cat in pairs(checktable) do
			local ccName = cat.Name;
			local ccCount = cat.Count;
			local ccFcount = cat.Flagcount;
			ccpoint[#ccpoint+1] = { ""..ccName..","..ccCount..","..ccFcount..":" };
		end;
		for idx, cat in pairs(ecftable) do
			local ecF = cat.Ecf;
			local ecName = cat.Name;
			local ecCount = cat.Count;
			local ecFcount = cat.Flagcount;
			ecpoint[#ecpoint+1] = { ""..ecName..","..ecCount..","..ecFcount..":" };
		end;
]]
	end;

	local ccptext = "#Status:";
	local ecptext = "#e_Status:";
	local cgptext = "#cGp:";
	for m=1, #checktable do
		if ccpoint[m] then
			ccptext = ccptext..""..table.concat(ccpoint[m]);
		else
			ccptext = ccptext;
		end;
	end;
	for n=1, #ecftable do
		if ecpoint[n] then
			ecptext = ecptext..""..table.concat(ecpoint[n]);
		else
			ecptext = ecptext;
		end;
	end;
	ccptext = string.sub(ccptext,1,-2);
	ecptext = string.sub(ecptext,1,-2);
	if getenv("ffset")[3] then
		cgptext = cgptext..""..getenv("ffset")[3];
	end;
	ccptext = ccptext..";\r\n"..ecptext..";\r\n"..cgptext..";\r\n";
	File.Write( cc_path , ccptext );
	
	local fctext = "";
	if GetAdhocPref("Fctext") then
		if GetAdhocPref("Fctext") ~= "" then
			fctext = GetAdhocPref("Fctext");
		end;
	end;

	if #text_k > 0 then
		t[#t+1] = Def.ActorFrame{
			InitCommand=cmd(y,SCREEN_TOP);
			OnCommand=cmd(sleep,5;linear,0.2;zoomy,0;);
			Def.Quad{
				InitCommand=cmd(horizalign,left;y,36;cropright,1;cropbottom,1;zoomtowidth,SCREEN_WIDTH;zoomtoheight,38*0.8;
							diffuse,color("0,0,0,0.8");diffuserightedge,color("0,0.5,0.5,0.8"););
				OnCommand=cmd(sleep,0.5+0.25;linear,0.1;cropright,0;cropbottom,0;);
			};
			Def.Quad{
				InitCommand=cmd(x,(SCREEN_WIDTH*0.1)-20;y,36;zoomtowidth,78*0.8;zoomtoheight,28*0.8;diffuse,color("0,1,1,0.3");croptop,1;);
				OnCommand=cmd(sleep,0.5+0.25;linear,0.25;croptop,0;);
			};
			
			Def.ActorFrame{
				InitCommand=cmd(x,(SCREEN_WIDTH*0.1)-20;y,36;zoom,0.8;);
				LoadActor(THEME:GetPathG("_MusicWheelItem","parts/key"))..{
					InitCommand=cmd(cropleft,1;);
					OnCommand=cmd(sleep,0.5+0.25;linear,0.25;cropleft,0;);
				};
				LoadActor(THEME:GetPathG("_MusicWheelItem","parts/blur"))..{
					InitCommand=function(self)
						if sectioncolorlist[g_group] then
							self:glow(color(sectioncolorlist[g_group]));
						end;
						(cmd(x,7;y,-9;shadowlength,2;cropleft,1;))(self)
					end;
					OnCommand=cmd(sleep,0.5+0.25;linear,0.25;cropleft,0;);
				};
			};

			LoadFont("_Shared2") .. {
				InitCommand=function(self)
					(cmd(x,(SCREEN_WIDTH*0.1)+20;horizalign,left;zoom,0.8;y,36-2;diffuse,color("1,1,0,1");strokecolor,Color("Black")))(self)
					self:settext(string.format( THEME:GetString("ScreenEvaluation","Added2"),groupstringset ));
				end;
				OnCommand=cmd(maxwidth,SCREEN_WIDTH*1.05;cropright,1;sleep,0.5+0.25;decelerate,0.35;cropright,0;diffusealpha,1;);
			};
		};
	end;

	for i = 1, #text do
		t[#t+1] = Def.ActorFrame{
			InitCommand=cmd(y,SCREEN_TOP);
			OnCommand=cmd(sleep,5;linear,0.2;zoomy,0;);
			Def.Quad{
				InitCommand=cmd(horizalign,left;y,36*(#text_k + i);cropright,1;cropbottom,1;zoomtowidth,SCREEN_WIDTH;zoomtoheight,38*0.8;
							diffuse,color("0,0,0,0.8");diffuserightedge,color("0,0.5,0.5,0.8"););
				OnCommand=cmd(sleep,0.5+((#text_k + i)*0.25);linear,0.1;cropright,0;cropbottom,0;);
			};
			Def.Quad{
				InitCommand=cmd(x,(SCREEN_WIDTH*0.1)-20;y,36*(#text_k + i);zoomtowidth,78*0.8;zoomtoheight,28*0.8;diffuse,color("0,1,1,0.3");croptop,1;);
				OnCommand=cmd(sleep,0.5+((#text_k + i)*0.25);linear,0.25;croptop,0;);
			};
			Def.Sprite{
				InitCommand=function(self)
					local getf = text[i];
					if text[i] == "Challenge" then getf = "Oni";
					elseif text[i] == "Cyan" then getf = "CSC_Normal";
					elseif text[i] == "Cyan_Special" then getf = "CSC_Special";
					end;
					self:Load(THEME:GetPathG("","GameFSet/Icon/_"..getf));
					(cmd(x,(SCREEN_WIDTH*0.1)-20;y,36*(#text_k + i);zoom,0.8;cropleft,1;))(self)
				end;
				OnCommand=cmd(sleep,0.5+((#text_k + i)*0.25);linear,0.25;cropleft,0;);
			};
			LoadFont("_Shared2") .. {
				InitCommand=function(self)
					(cmd(x,(SCREEN_WIDTH*0.1)+20;horizalign,left;zoom,0.8;y,(36*(#text_k + i))-2;diffuse,color("1,1,0,1");strokecolor,Color("Black")))(self)
					self:settext(string.format( THEME:GetString("ScreenEvaluation","Added1"),THEME:GetString("OptionTitles","Select Game Frame"),text[i] ));
				end;
				OnCommand=cmd(maxwidth,SCREEN_WIDTH*1.05;cropright,1;sleep,0.5+((#text_k + i)*0.25);decelerate,0.35;cropright,0;diffusealpha,1;);
			};
		};
		if text[i] then
			local fctext_s;
			if fctext then
				fctext_s = split(",",fctext);
			end;
			local check = true;
			if fctext_s then
				for k = 1, #fctext_s do
					if text[i] == fctext_s[k] then
						check = false;
						break;
					end;
				end;
			end;
			if check then
				if fctext ~= "" then
					fctext = fctext..","..text[i];
				else fctext = text[i];
				end;
			end;
		end;
	end;

	--Sound
	if #text_k + #text > 0 then
		t[#t+1] = Def.Sound {
			InitCommand=function(self)
				self:load(THEME:GetPathS("","_frame_open"));
				self:stop();
				self:sleep(0.65);
				self:queuecommand("Play");
			end;
			PlayCommand=cmd(play);
		};
	end;

	SetAdhocPref("Fctext",fctext);
	SetAdhocPref("I_Fctext",fctext);
	--Trace("fctext : "..fctext);
	
	setenv("ffset","");
	setenv("evacheckflag",0);
end;

return t;

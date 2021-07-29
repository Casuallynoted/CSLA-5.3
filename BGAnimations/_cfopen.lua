
local csl_c = GetAdhocPref("CSLSetApp") == "00000001" or GetAdhocPref("CSLSetApp") == "32594786";
local ccc = false;
if FILEMAN:DoesFileExist( cap_path ) then
	ccc = true;
else
	if GetAdhocPref("CSLSetApp") then
		if csl_c then
			ccc = true;
		end;
	end;
end;

local fset = {};
local vfset = {};

function CheckCountFlag(ccname,cpoint)
	local ccCount = cpoint;
	--up	-----------------------------------------
	if ccc then
		if ccname == "Sco" then
			if tonumber( ccCount ) < 1 then
				ccCount = 1;
				fset[#fset+1] = "Regular";
			end;
		elseif ccname == "Non" then
			if tonumber( ccCount ) < 3 then
				ccCount = 3;
				fset[#fset+1] = "Nonstop";
			end;
		elseif ccname == "Cha" then
			if tonumber( ccCount ) < 3 then
				ccCount = 3;
				fset[#fset+1] = "Challenge";
			end;
		elseif ccname == "Rav" then
			if tonumber( ccCount ) < 20 then
				ccCount = 20;
				fset[#fset+1] = "Endless";
			end;
		elseif ccname == "End" then
			if tonumber( ccCount ) < 1 then
				ccCount = 1;
				fset[#fset+1] = "Rave";
			end;
		end;
	end;
	return ccCount;
end;

function eCheckCountFlag(cpoint)
	local ecCount = cpoint;
	return ecCount;
end;

function FlagUpper(cname,ccount,cfcount)
	local ecCount = cfcount;
	if ccc then
		if cname == "Sco" then
			if tonumber( ccount ) >= 1 and tonumber( ccount ) < 20 then
				ecCount = 1;
			end;
		elseif cname == "Non" then
			if tonumber( ccount ) >= 3 then
				ecCount = 1;
			end;
		elseif cname == "Cha" then
			if tonumber( ccount ) >= 3 then
				ecCount = 1;
			end;
		elseif cname == "Rav" then
			if tonumber( ccount ) >= 20 then
				ecCount = 1;
			end;
		elseif cname == "End" then
			if tonumber( ccount ) >= 1 then
				ecCount = 1;
			end;
		end;
	end;
	return ecCount;
end;

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

function GetCheckCount(setc)
	local cpoint = {};
	local f_point;
	local settable;
	local f_flag = "";
	if GetCCParameter(setc) ~= "" then
		f_flag = split(":",GetCCParameter(setc));
	end;
	if setc == "Status" then
		settable = checktable;
	elseif setc == "e_Status" then
		settable = ecftable;
	end;
	if FILEMAN:DoesFileExist( cc_path ) then
		for idx, cat in pairs(settable) do
			local cName = cat.Name;
			local cCount = cat.Count;
			local cFcount = cat.Flagcount;
			local check = 1;
			if #f_flag > 0 then
				for fp=1,#f_flag do
					if f_flag[fp] ~= "" then
						f_point = split(",",f_flag[fp]);
						if #f_point >= 2 then
							if f_point[1] == cName then
								if tonumber(f_point[2]) then
									if tonumber(f_point[2]) <= 100001 then
										if tonumber(f_point[2]) >= tonumber(cCount) then
											if setc == "Status" then
												cCount = CheckCountFlag(cName,f_point[2]);
											elseif setc == "e_Status" then
												cCount = eCheckCountFlag(f_point[2]);
											end;
										end;
									else
										cCount = 100001;
									end;
								else
									if setc == "Status" then
										cCount = CheckCountFlag(cName,0);
									elseif setc == "e_Status" then
										cCount = eCheckCountFlag(0);
									end;
								end;
								if tonumber(f_point[3]) then
									cFcount = FlagUpper(cName,cCount,f_point[3]);
								end;
								check = 0;
							end;
						end;
					end;
				end;
			end;
			--[ja] 記述がないとフラグ確認せず0を書き込んで終了だったので20140831修正
			if check == 1 then
				if setc == "Status" then
					cCount = CheckCountFlag(cName,0);
				elseif setc == "e_Status" then
					cCount = eCheckCountFlag(0);
				end;
				cFcount = FlagUpper(cName,cCount,0);
			end;
			cpoint[#cpoint+1] = { ""..cName..","..cCount..","..cFcount..":" };
		end;
	else
		for idx, cat in pairs(settable) do
			local cF = "";
			if setc == "e_Status" then
				cF = cat.Ecf;
			end;
			local cName = cat.Name;
			local cCount = cat.Count;
			local cFcount = cat.Flagcount;
			if setc == "Status" then
				cCount = CheckCountFlag(cName,0);
			elseif setc == "e_Status" then
				cCount = eCheckCountFlag(0);
			end;
			cFcount = FlagUpper(cName,cCount,0);
			cpoint[#cpoint+1] = { ""..cName..","..cCount..","..cFcount..":" };
		end;
	end;
	return cpoint;
end;
local CCList = GetCheckCount("Status");
local ccptext = "#Status:";
local ECList = GetCheckCount("e_Status");
local ecptext = "#e_Status:";

for i=1, #checktable do
	if CCList[i] then
		ccptext = ccptext..""..table.concat(CCList[i]);
	else ccptext = ccptext;
	end;
end;
for j=1, #ecftable do
	if ECList[j] then
		ecptext = ecptext..""..table.concat(ECList[j]);
	else ecptext = ecptext;
	end;
end;
ccptext = string.sub(ccptext,1,-2);
ecptext = string.sub(ecptext,1,-2);

local cgptext = "#cGp:";
if GetCCParameter("cGp") ~= "" then
	cgptext = cgptext..""..GetCCParameter("cGp");
end;

ccptext = ccptext..";\r\n"..ecptext..";\r\n"..cgptext..";\r\n";
File.Write( cc_path , ccptext );

function fcc(ffset)
	if ffset then
		return table.concat(ffset,",")
	end;
end;

local t = Def.ActorFrame{};

local setstring = "";
local set_y = 0;
local sleep_set = 0;
if #fset > 0 then
	set_y = 100;
	sleep_set = 0.25;
	t[#t+1] = Def.ActorFrame{
		InitCommand=cmd(y,SCREEN_TOP);
		OnCommand=cmd(sleep,5;linear,0.2;zoomy,0;);
		Def.Quad{
			InitCommand=cmd(horizalign,left;y,68;cropright,1;cropbottom,1;zoomtowidth,SCREEN_WIDTH;zoomtoheight,118*0.8;
						diffuse,color("0,0,0,0.8");diffuserightedge,color("0,0.5,0.5,0.8"););
			OnCommand=cmd(sleep,0.5;linear,0.1;cropright,0;cropbottom,0;);
		};
	};

	for i = 1, #fset do
		t[#t+1] = Def.ActorFrame{
			InitCommand=cmd(y,SCREEN_TOP);
			OnCommand=cmd(sleep,5;linear,0.2;zoomy,0;);
			Def.Quad{
				InitCommand=function(self)
					(cmd(x,SCREEN_LEFT;zoomtowidth,72*0.8;zoomtoheight,28*0.8;diffuse,color("0,1,1,0.3");croptop,1;))(self)
					if i >=4 then
						self:x((i-3)*62);
						self:y(66+26);
					else
						self:x(i*62);
						self:y(66);
					end;
				end;
				OnCommand=cmd(sleep,0.5;linear,0.25;croptop,0;);
			};
			Def.Sprite{
				InitCommand=function(self)
					(cmd(x,SCREEN_LEFT;zoom,0.8;cropleft,1;))(self)
					if i >=4 then
						self:x((i-3)*62);
						self:y(66+26);
					else
						self:x(i*62);
						self:y(66);
					end;
					if fset[i] == "Challenge" then
						self:Load(THEME:GetPathG("","GameFSet/Icon/_Oni"));
					else self:Load(THEME:GetPathG("","GameFSet/Icon/_"..fset[i]));
					end;
				end;
				OnCommand=cmd(sleep,0.5;linear,0.25;cropleft,0;);
			};
		};
		
		if i == 3 then
			setstring = setstring.."[ "..fset[i].." ]\n";
		elseif i == 5 then
			setstring = setstring.."[ "..fset[i].." ]";
		else
			setstring = setstring.."[ "..fset[i].." ] ";
		end;
	end;
	
	t[#t+1] = Def.ActorFrame{
		InitCommand=cmd(y,SCREEN_TOP;);
		OnCommand=cmd(sleep,5;linear,0.2;zoomy,0;);
		LoadFont("_Shared2") .. {
			InitCommand=function(self)
				(cmd(x,SCREEN_LEFT+30;horizalign,left;zoom,0.8;y,36;diffuse,color("1,0.5,0,1");strokecolor,Color("Black")))(self)
				self:settext(THEME:GetString("ScreenOptionsFrameSet","Added1"));
			end;
			OnCommand=cmd(maxwidth,SCREEN_WIDTH*1.2-30;cropright,1;sleep,0.5;decelerate,0.35;cropright,0;diffusealpha,1;);
		};
	};
	
	t[#t+1] = Def.ActorFrame{
		InitCommand=cmd(y,SCREEN_TOP;);
		OnCommand=cmd(sleep,5;linear,0.2;zoomy,0;);
		LoadFont("_Shared2") .. {
			InitCommand=function(self)
				(cmd(x,SCREEN_LEFT+(62*3)+46;horizalign,left;zoom,0.8;y,78;diffuse,color("1,1,0,1");strokecolor,Color("Black")))(self)
				self:settext(string.format( THEME:GetString("ScreenOptionsFrameSet","Added2"),
				THEME:GetString("OptionTitles","Select Game Frame"),setstring ));
			end;
			OnCommand=cmd(maxwidth,SCREEN_WIDTH*0.87;cropright,1;sleep,0.5;decelerate,0.35;cropright,0;diffusealpha,1;);
		};
	};

	--Sound
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

if vnumcheck("20150816") and tonumber(GetAdhocPref("CSLV2Flag")) == 0 then
	fset[#fset+1] = "Ocean";

	t[#t+1] = Def.ActorFrame{
		InitCommand=cmd(y,SCREEN_TOP);
		OnCommand=cmd(sleep,5;linear,0.2;zoomy,0;);
		Def.Quad{
			InitCommand=cmd(horizalign,left;y,36+set_y;cropright,1;cropbottom,1;zoomtowidth,SCREEN_WIDTH;zoomtoheight,38*0.8;
						diffuse,color("0,0,0,0.8");diffuserightedge,color("0,0.5,0.5,0.8"););
			OnCommand=cmd(sleep,0.5+sleep_set;linear,0.1;cropright,0;cropbottom,0;);
		};
		Def.Quad{
			InitCommand=cmd(x,(SCREEN_WIDTH*0.1)-20;y,36+set_y;zoomtowidth,78*0.8;zoomtoheight,28*0.8;diffuse,color("0,1,1,0.3");croptop,1;);
			OnCommand=cmd(sleep,0.5+sleep_set;linear,0.25;croptop,0;);
		};
		Def.Sprite{
			InitCommand=function(self)
				local getf = "Ocean";
				self:Load(THEME:GetPathG("","GameFSet/Icon/_"..getf));
				(cmd(x,(SCREEN_WIDTH*0.1)-20;y,36+set_y;zoom,0.8;cropleft,1;))(self)
			end;
			OnCommand=cmd(sleep,0.5+sleep_set;linear,0.25;cropleft,0;);
		};
		LoadFont("_Shared2") .. {
			InitCommand=function(self)
				(cmd(x,(SCREEN_WIDTH*0.1)+20;horizalign,left;zoom,0.8;y,(36+set_y)-2;diffuse,color("1,1,0,1");strokecolor,Color("Black")))(self)
				self:settext(string.format( THEME:GetString("ScreenEvaluation","Added1"),THEME:GetString("OptionTitles","Select Game Frame"),"Ocean" ));
			end;
			OnCommand=cmd(maxwidth,SCREEN_WIDTH*1.05;cropright,1;sleep,0.5+sleep_set;decelerate,0.35;cropright,0;diffusealpha,1;);
		};
	};
	SetAdhocPref("CSLV2Flag", "1");
end;

if #fset > 0 then
	SetAdhocPref("Fctext", fcc(fset));
end;

if ccc then
	if not FILEMAN:DoesFileExist( cap_path ) then
		File.Write( cap_path , "00000001" );
	end;
end;

return t;

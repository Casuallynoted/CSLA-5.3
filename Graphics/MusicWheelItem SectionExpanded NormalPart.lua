local sectioncolorlist = getenv("sectioncolorlist");
local sectiontextlist = getenv("sectionsubnamelist");
local showjacket = GetAdhocPref("WheelGraphics");
local f_jacket = THEME:GetPathG("","_MusicWheelItem parts/_fallback_jacket_low");
local favorite_s_jacket = THEME:GetPathG("","_MusicWheelItem parts/favorite_jacket");
local sctext = getenv("SortCh");
local drawindex = 0;
local ac = 1;
local items = THEME:GetMetric( "MusicWheel","NumWheelItems" ) + 2;
setenv("i_c_setting",{f_jacket,Color("White")});

local t = Def.ActorFrame{
	OnCommand=function(self)
		if THEME:GetMetric( Var "LoadingScreen","ScreenType") == 0 then
			(cmd(linear,0.4;playcommand,"Flag"))(self)
		else (cmd(playcommand,"Flag"))(self)
		end;
	end;
	FlagCommand=function(self) ac = 0;
	end;
	
	LoadActor(THEME:GetPathG("_MusicWheelItem","parts/section_back"))..{
		Name="jacket_back";
	};
	LoadActor(THEME:GetPathG("_MusicWheelItem","parts/section_back"))..{
		Name="jacket_under";
	};

	Def.Sprite {
		Name="jacket_mirror";
		InitCommand=cmd(rotationy,180;rotationz,180;);
	};

	Def.Sprite {
		Name="jacket";
	};
	
	Def.Sprite{
		Name="tierimage";
		InitCommand=cmd(y,25;diffuse,Color("White"););
	};
--20180209
	Def.ActorFrame {
		Name="A_Star";
		InitCommand=cmd(x,48;y,32;);
		LoadActor( THEME:GetPathG("","star") )..{
			Name="Image";
			InitCommand=cmd(shadowlength,3;zoom,1.25;);
		};
		LoadFont("Common Normal") .. {
			Name="Num";
			InitCommand=cmd(x,14;y,6;settext,"";diffuse,Color("White");strokecolor,color("0,0,0,1");shadowlength,4;zoom,1.25;);
		};
	};
	
	LoadFont("Common Normal")..{
		Name="stext";
		InitCommand=cmd(y,22;shadowlength,0);
	};
	
	LoadActor(THEME:GetPathG("_MusicWheelItem","parts/s_count"))..{
		InitCommand=cmd(x,30;y,-72;diffusealpha,0.8;);
	};

	Def.Quad {
		InitCommand=cmd(x,20;y,-100;zoomtowidth,140;zoomtoheight,12;diffuse,color("0.4,0.4,0.4,0.85");fadeleft,0.1;faderight,0.1;);
	};

	Def.ActorFrame{
		Def.Quad{
			InitCommand=cmd(y,109;diffuse,color("1,0.5,0,0");diffusetopedge,color("1,0.5,0,0.1");
						diffusebottomedge,color("1,0.5,0,0");zoomtowidth,174;zoomtoheight,174/4;);
		};

		Def.Quad{
			InitCommand=cmd(diffuse,color("1,0.5,0,0.1");diffusetopedge,color("1,0.5,0,0.1");
						diffusebottomedge,color("1,0.5,0,0.4");zoomtowidth,174;zoomtoheight,174;);
		};
	};
	
	LoadFont("_cml")..{
		InitCommand=cmd(x,68;y,-73;shadowlength,0;zoom,0.675;horizalign,right;maxwidth,100;diffuse,color("0.6,1,1,1");strokecolor,color("0,0,0,0.6"););
		SetMessageCommand=function(self,params)
			local sectionCount = self:GetParent():GetParent():GetChild("SectionCount");
			if tonumber(sectionCount:GetText()) then
				setenv("sectionCount",sectionCount:GetText());
				self:settextf("%04i",sectionCount:GetText());
			end;
		end;
	};

	
	LoadActor(THEME:GetPathG("_MusicWheelItem","parts/expand_label"))..{
		Name="exp_label";
		InitCommand=cmd(shadowlength,0;x,44;y,-100;diffuse,color("1,1,0,0.8"););
	};
	
	LoadActor(THEME:GetPathG("_MusicWheelItem","parts/down_folder"))..{
		Name="down_folder";
		InitCommand=cmd(x,-45;y,-88;);
	};
	
	LoadActor(THEME:GetPathG("_MusicWheelItem","parts/up_folder"))..{
		Name="up_folder";
		InitCommand=cmd(x,-45;y,-88;);
	};
	
	LoadFont("_shared2")..{
		Name="grouptext";
		InitCommand=cmd(y,100;zoomy,0.9;maxwidth,156;shadowlength,0;strokecolor,Color("Black"););
	};
	
	SetMessageCommand=function(self, params)
		local sort_sst = ToEnumShortString(GAMESTATE:GetSortOrder());
		local image_set = f_jacket;
		local color_set = Color("White");
		local pt_text = params.Text;
		local pt_path = SONGMAN:GetSongGroupBannerPath(pt_text);
		local pt_text_strf = split("-",pt_text);
	
		local jacket_back = self:GetChild('jacket_back');
		local jacket_under = self:GetChild('jacket_under');
		local jacket_mirror = self:GetChild('jacket_mirror');
		local jacket = self:GetChild('jacket');
		local tierimage = self:GetChild('tierimage');
		local stext = self:GetChild('stext');
		local down_folder = self:GetChild('down_folder');
		local up_folder = self:GetChild('up_folder');
		local grouptext = self:GetChild('grouptext');

		local a_star = self:GetChild('A_Star');
		local a_star_i = self:GetChild('A_Star'):GetChild('Image');
		local a_star_in = self:GetChild('A_Star'):GetChild('Index');
		local a_star_n = self:GetChild('A_Star'):GetChild('Num');
		a_star:visible(false);
		
		drawindex = params.DrawIndex;
		incommandset(self,ac,items,drawindex);

		tierimage:visible(false);
		stext:visible(false);
		grouptext:visible(false);
		down_folder:blend('BlendMode_Add');
		(cmd(stoptweening;y,0;zoomy,2;fadetop,0.75;fadebottom,0.4;))(jacket_back);
		--20160718
if params.DrawIndex then
		if drawindex > math.floor(items / 2) or drawindex < math.floor(items / 2) then
			if drawindex > math.floor(items / 2) then jacket_back:z(5);
			elseif drawindex < math.floor(items / 2) then jacket_back:z(-5);
			end;
		else
			jacket_back:z(0);
			--if getenv("wheelstop") == 1 then
				jacket_back:zoomy(1.15);
			--end;
		end;
end;
		(cmd(y,10;diffuse,color("0,1,0.85,1");diffusetopedge,color("0,0.85,0.7,1");diffusebottomedge,color("0,0.85,0.7,0.7");))(jacket_under);

		local path_check = false;
		local gradestr = "None";
		if pt_text then
			grouptext:visible(true);
			if pt_text == THEME:GetString("MusicWheel","Empty") then
				image_set = f_jacket;
				grouptext:diffuse(color("1,0.1,0.4,1"));
			else
				--20180209
				if sort_sst ~= 'Nonstop' and sort_sst ~= 'Oni' and sort_sst ~= 'Endless' then
					if sort_sst ~= 'Title' and sort_sst ~= 'Artist' and sctext ~= 'Title' and sctext ~= 'Artist' then
						if sort_sst == 'Group' or sctext == "Group" or string.find(sctext,"^UserCustom.*") or 
						string.find(sctext,"^Favorite.*") then
							if showjacket ~= "Off" then
								for i=1,#extension do
									if string.find(sctext,"^UserCustom.*") or string.find(sctext,"^Favorite.*") then
										if string.find(sctext,"^UserCustom.*") then
											image_set = prof_custom_imagedir(ProfIDSet(csort_pset()),"CustomSort/_",pt_text,extension[i],f_jacket);
										else image_set = prof_custom_imagedir(ProfIDSet(csort_pset()),"CS_Favorite/_",pt_text,extension[i],favorite_s_jacket);
										end;
										if image_set then
											path_check = true;
											break;
										end;
									else
										if FILEMAN:DoesFileExist("/Songs/"..pt_text.."/jacket."..extension[i]) then
											image_set = "/Songs/"..pt_text.."/jacket."..extension[i];
											path_check = true;
											do break; end;
										elseif FILEMAN:DoesFileExist("/AdditionalSongs/"..pt_text.."/jacket."..extension[i]) then
											image_set = "/AdditionalSongs/"..pt_text.."/jacket."..extension[i];
											path_check = true;
											break;
										end;
									end;
								end;
								if not path_check then
									if pt_path ~= "" then
										image_set = pt_path;
									end;
								end;
							else
								if pt_path ~= "" then
									image_set = pt_path;
								end;
							end;
						else
							if sort_sst == 'BPM' or sctext == 'BPM' then
								image_set = THEME:GetPathG("_MusicWheelItem","parts/sortsection_mono_jacket_BPM");
								for j=1, #bnum do
									if bnum[j][1] == pt_text then
										color_set = HSVA( math.min(359.999999,(360/bpmseccount)*j),0.5,1,1 );
										break;
									end;
								end;
								(cmd(visible,true;maxwidth,88;zoom,1.8;))(stext);
								stext:settext(pt_text_strf[1].."-");
								if pt_text_strf[3] then
									if pt_text_strf[1] == "" then stext:settext("-"..pt_text_strf[2].."-");
									end;
								end;
							elseif sort_sst == 'Length' or sctext == 'Length' then
								image_set = THEME:GetPathG("_MusicWheelItem","parts/sortsection_mono_jacket_Length");
								for k=1, #lnum do
									if lnum[k][1] == pt_text then
										color_set = HSVA( math.min(359.999999,(360/lengthseccount)*k),0.5,1,1 );
										break;
									end;
								end;
								(cmd(visible,true;maxwidth,88;zoom,1.8;))(stext);
								stext:settext(pt_text_strf[1].."-");
								if pt_text_strf[3] then
									if pt_text_strf[1] == "" then stext:settext("-"..pt_text_strf[2].."-");
									end;
								end;
							elseif sort_sst == 'Genre' or sctext == 'Genre' then
								image_set = THEME:GetPathG("_MusicWheelItem","parts/sortsection_mono_jacket_Genre");
								for l=1, #gnum do
									if gnum[l][1] == pt_text then
										color_set = HSVA( math.min(359.999999,(360/genrecount)*l),0.5,1,1 );
										break;
									end;
								end;
								(cmd(visible,true;maxwidth,110;zoom,1.4;))(stext);
								stext:settext(pt_text);
							elseif sort_sst == 'TopGrades' or string.find(sctext,"^TopGrades.*") then
								stext:visible(false);
								image_set = THEME:GetPathG("_MusicWheelItem","parts/sortsection_mono_jacket_TopGrades");
								if string.find(pt_text,THEME:GetString("Grade","Tier01"),0,true) then
									color_set = Colors.Grade["Tier01"];
									gradestr = "Tier01";
								elseif string.find(pt_text,THEME:GetString("Grade","Tier02"),0,true) then
									color_set = Colors.Grade["Tier02"];
									gradestr = "Tier02";
								elseif string.find(pt_text,THEME:GetString("Grade","Tier03"),0,true) then
									color_set = Colors.Grade["Tier03"];
									gradestr = "Tier03";
								elseif string.find(pt_text,THEME:GetString("Grade","Tier04"),0,true) then
									color_set = Colors.Grade["Tier04"];
									gradestr = "Tier04";
								elseif string.find(pt_text,THEME:GetString("Grade","Tier05"),0,true) then
									color_set = Colors.Grade["Tier05"];
									gradestr = "Tier05";
								elseif string.find(pt_text,THEME:GetString("Grade","Tier06"),0,true) then
									color_set = Colors.Grade["Tier06"];
									gradestr = "Tier06";
								elseif string.find(pt_text,THEME:GetString("Grade","Tier07"),0,true) then
									color_set = Colors.Grade["Tier07"];
									gradestr = "Tier07";
								elseif string.find(pt_text,THEME:GetString("Grade","Failed"),0,true) then
									color_set = Colors.Grade["Failed"];
									gradestr = "Failed";
								else
									color_set = Colors.Grade["None"];
									(cmd(visible,true;maxwidth,88;zoom,1.8;))(stext);
								end;
								tierimage:visible(true);
								tierimage:Load(THEME:GetPathG("","GradeDisplayEval "..gradestr));
								stext:settext(pt_text);
							else
								(cmd(visible,true;maxwidth,50;zoom,2.75;))(stext);
								if string.find(sctext,"^.*Meter") then
									color_set = Colors.Difficulty[string.sub(sctext,1,-6)];
									image_set = THEME:GetPathG("_MusicWheelItem","parts/sortsection_mono_jacket_"..sctext);
								elseif string.find(sort_sst,"^.*Meter") then
									color_set = Colors.Difficulty[string.sub(sort_sst,1,-6)];
									image_set = THEME:GetPathG("_MusicWheelItem","parts/sortsection_mono_jacket_"..sort_sst);
								end;
								stext:settext(pt_text);
							end;
						end;
					elseif sort_sst == 'Title' or sctext == 'Title' or sort_sst == 'Artist' or sctext == 'Artist' then
						if pt_text == '0-9' then
							color_set = HSVA( (360/28)*1,0.5,1,1 );
						elseif pt_text == THEME:GetString("Sort","Other") then
							color_set = HSVA( math.min(359.999999,(360/28)*28),0.5,1,1 );
						else
							if setdiffuse[pt_text] then
								color_set = setdiffuse[pt_text];
							end;
						end;
						image_set = THEME:GetPathG("_MusicWheelItem","parts/sortsection_mono_jacket_"..sort_sst);
						(cmd(visible,true;maxwidth,50;zoom,2.75;))(stext);
						stext:settext(pt_text);
					end;
				--20180209
					if sort_sst == 'Group' or sctext == "Group" or string.find(sctext,"^UserCustom.*") or string.find(sctext,"^Favorite.*") then
						local pt_setting = pt_text;
						if string.find(sctext,"^UserCustom.*") then
							sectioncolorlist = getenv("csort_sectioncolorlist");
							pt_setting = "csort_"..string.lower(""..pt_text);
						end;
						if sectioncolorlist ~= "" and sectioncolorlist[pt_setting] then
							color_set = color(sectioncolorlist[pt_setting]);
						end;
						if pt_text ~= THEME:GetString("Sort","NotAvailable") then
							if sectiontextlist ~= "" then
								if sectiontextlist[pt_setting] then
									pt_text = sectiontextlist[pt_setting];
								end;
							end;
						end;
						jacket_mirror:diffuse(Color("White"));
						jacket:diffuse(Color("White"));
						if string.find(sctext,"^Favorite.*") then
							a_star:visible(true);
							if tonumber(string.sub(pt_text,-1)) then
								a_star_i:diffuse(f_color_set[tonumber(string.sub(pt_text,-1))]);
								if image_set == favorite_s_jacket then
									jacket_mirror:diffuse(f_color_set[tonumber(string.sub(pt_text,-1))]);
									jacket:diffuse(f_color_set[tonumber(string.sub(pt_text,-1))]);
									jacket:diffuse(f_color_set[tonumber(string.sub(pt_text,-1))]);
								end;
								color_set = f_color_set[tonumber(string.sub(pt_text,-1))];
							end;
							a_star_n:settext(string.sub(pt_text,-1));
						end;
					else
						jacket_mirror:diffuse(color_set);
						jacket:diffuse(color_set);
					end;
				end;
			end;
		end;
		jacket_mirror:diffusealpha(0.2);
		jacket_mirror:diffusetopedge(color("0,0,0,0"));
		jacket_mirror:Load(image_set);
		jacket_mirror:scaletofit(0,0,174,174);
		jacket_mirror:zoomtoheight(174*0.3);
		jacket_mirror:x(0);
		jacket_mirror:y(113);

		jacket:diffusealpha(0.875);
		jacket:Load(image_set);
		jacket:scaletofit(0,0,174,174);
		jacket:x(0);
		jacket:y(0);
		
		jacket_back:diffuse(color_set);
		
		grouptext:settextf("%s",pt_text);
		if #pt_text >= 21 then
			if #pt_text > 22 then
				grouptext:settextf("%s",string.sub(pt_text,1,strchk(21,36,pt_text)).." ..." );
			end;
		end;
		down_folder:glow(color_set);
		up_folder:diffuse(color_set);
		stext:diffuse(color_set);
		grouptext:diffuse(color_set);
		setenv("i_c_setting",{image_set,color_set});
		setenv("wheelnotsectiontext",pt_text);
		setenv("wheelnotsectioncolor",color_set);
	end;

	SectionSetRMessageCommand=function(self)
		local jacket_back = self:GetChild('jacket_back');
		local jacket_mirror = self:GetChild('jacket_mirror');
		local exp_label = self:GetChild('exp_label');
		local down_folder = self:GetChild('down_folder');
		(cmd(stoptweening;diffuse,color("0.5,0.5,0.5,1");y,0-100;accelerate,0.1;y,0;))(jacket_back);
		(cmd(stoptweening;y,113+8;linear,0.1;y,113;))(jacket_mirror);
		(cmd(stoptweening;x,44+16;cropleft,1;decelerate,0.1;x,44;cropleft,0;))(exp_label);
		(cmd(stoptweening;cropbottom,1;linear,0.1;cropbottom,0;))(down_folder);
	end;
};

t[#t+1] = wheel_kset(sort_sst,sctext,color_set);

return t;
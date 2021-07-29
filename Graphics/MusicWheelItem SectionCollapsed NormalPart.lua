local sectioncolorlist = getenv("sectioncolorlist");
local sectiontextlist = getenv("sectionsubnamelist");
local cjacket = THEME:GetPathG("","_MusicWheelItem parts/_fallback_jacket_low");
local favorite_s_jacket = THEME:GetPathG("","_MusicWheelItem parts/favorite_jacket");
local sctext = getenv("SortCh");
local drawindex = 0;
local sectioncolor;

local ac = 1;
local items = THEME:GetMetric( "MusicWheel","NumWheelItems" ) + 2;

local t = Def.ActorFrame{
	OnCommand=function(self)
		if THEME:GetMetric( Var "LoadingScreen","ScreenType") == 0 then
			(cmd(linear,0.4;playcommand,"Flag"))(self)
		else (cmd(playcommand,"Flag"))(self)
		end;
	end;
	FlagCommand=function(self) ac = 0;
	end;

	LoadActor(THEME:GetPathG("_MusicWheelItem","parts/jacket_back"))..{
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
		InitCommand=cmd(y,25;diffuse,color("1,1,1,0.7"););
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
	
	LoadFont("_cml")..{
		InitCommand=cmd(x,68;y,-73;shadowlength,0;zoom,0.675;horizalign,right;maxwidth,100;diffuse,color("0.6,1,1,1");strokecolor,color("0,0,0,0.6"););
		SetMessageCommand=function(self,params)
			local sectionCount = self:GetParent():GetParent():GetChild("SectionCount");
			if tonumber(sectionCount:GetText()) then
				self:settextf("%04i",sectionCount:GetText());
			end;
		end;
	};
	
	Def.Quad {
		InitCommand=cmd(x,20;y,-100;zoomtowidth,140;zoomtoheight,12;diffuse,color("0.4,0.4,0.4,0.85");fadeleft,0.1;faderight,0.1;);
	};

	LoadActor(THEME:GetPathG("_MusicWheelItem","parts/up_folder"))..{
		Name="up_folder";
		InitCommand=cmd(x,-45;y,-88;);
	};
	
	LoadActor(THEME:GetPathG("_MusicWheelItem","parts/section_label"))..{
		InitCommand=cmd(shadowlength,0;x,44;y,-100;diffuse,color("1,0.5,0,0.8"););
	};

	LoadFont("_shared2")..{
		Name="grouptext";
		InitCommand=cmd(y,100;zoomy,0.9;maxwidth,156;shadowlength,0;strokecolor,Color("Black"););
	};
	
	SetMessageCommand=function(self, params)
		local sort_sst = ToEnumShortString(GAMESTATE:GetSortOrder());
		local image_set = getenv("i_c_setting")[1];
		local color_set = getenv("i_c_setting")[2];
		local pt_text = params.Text;
		local pt_path = SONGMAN:GetSongGroupBannerPath(pt_text);
		local pt_text_strf = split("-",pt_text);
		local sectiontext = getenv("wheelnotsectiontext");
		local sectioncolor = getenv("wheelnotsectioncolor");
		
		local jacket_back = self:GetChild('jacket_back');
		local jacket_under = self:GetChild('jacket_under');
		local jacket_mirror = self:GetChild('jacket_mirror');
		local jacket = self:GetChild('jacket');
		local tierimage = self:GetChild('tierimage');
		local stext = self:GetChild('stext');
		local up_folder = self:GetChild('up_folder');
		local grouptext = self:GetChild('grouptext');
	--20180209
		local a_star = self:GetChild('A_Star');
		local a_star_i = self:GetChild('A_Star'):GetChild('Image');
		local a_star_in = self:GetChild('A_Star'):GetChild('Index');
		local a_star_n = self:GetChild('A_Star'):GetChild('Num');
		a_star:visible(false);
		
		drawindex = params.DrawIndex;
		tierimage:visible(false);
		stext:visible(false);
		grouptext:visible(false);
		
		if params.HasFocus then
			setenv("sectionCount",0);
		end;

		incommandset(self,ac,items,drawindex);
if params.DrawIndex then
		if params.DrawIndex > math.floor(items / 2) then jacket_back:z(5);
		elseif params.DrawIndex < math.floor(items / 2) then jacket_back:z(-5);
		else jacket_back:z(0);
		end;
end;

		(cmd(y,10;diffuse,color("0.5,0.5,0.5,0.5");))(jacket_under);
		(cmd(y,22;diffuse,color("0.5,0.5,0.5,0.5");diffusetopedge,color("0.5,0.5,0.5,1");))(jacket_back);
		jacket_mirror:diffuse(color_set);
		jacket:diffuse(color_set);
		grouptext:diffuse(color_set);
		up_folder:diffuse(color_set);

		local gradestr = "None";
		if pt_text then
			grouptext:visible(true);
			if pt_text ~= THEME:GetString("MusicWheel","Empty") then
				--20180209
				if sort_sst ~= 'Title' and sort_sst ~= 'Artist' and sctext ~= 'Title' and sctext ~= 'Artist' then
					if sort_sst == 'Group' or sctext == "Group" or string.find(sctext,"^UserCustom.*") or 
					string.find(sctext,"^Favorite.*") then
						jacket_under:diffusebottomedge(ColorDarkTone(sectioncolor));
						jacket_back:diffusetopedge(ColorDarkTone(sectioncolor));
						jacket_mirror:diffuse(Color("White"));
						jacket:diffuse(Color("White"));
					else
						stext:visible(true);
						stext:diffuse(color_set);
						stext:settext(pt_text);
						if params.HasFocus then
							setenv("wheelsectiongroup",pt_text);
						else
							grouptext:diffuse(color_set);
							grouptext:settextf("%s",pt_text);
						end;
						if sort_sst == 'BPM' or sctext == 'BPM' then
							(cmd(visible,true;maxwidth,88;zoom,1.8;))(stext);
							stext:settext(pt_text_strf[1].."-");
							if pt_text_strf[3] then
								if pt_text_strf[1] == "" then stext:settext("-"..pt_text_strf[2].."-");
								end;
							end;
						elseif sort_sst == 'Length' or sctext == 'Length' then
							(cmd(visible,true;maxwidth,88;zoom,1.8;))(stext);
							stext:settext(pt_text_strf[1].."-");
							if pt_text_strf[3] then
								if pt_text_strf[1] == "" then stext:settext("-"..pt_text_strf[2].."-");
								end;
							end;
						elseif sort_sst == 'Genre' or sctext == 'Genre' then
							(cmd(maxwidth,110;zoom,1.4;))(stext);
							stext:settext(pt_text);
						elseif sort_sst == 'TopGrades' or string.find(sctext,"^TopGrades.*") then
							stext:visible(false);
							image_set = THEME:GetPathG("_MusicWheelItem","parts/sortsection_mono_jacket_TopGrades");
							if string.find(pt_text,THEME:GetString("Grade","Tier01"),0,true) then
								gradestr = "Tier01";
							elseif string.find(pt_text,THEME:GetString("Grade","Tier02"),0,true) then
								gradestr = "Tier02";
							elseif string.find(pt_text,THEME:GetString("Grade","Tier03"),0,true) then
								gradestr = "Tier03";
							elseif string.find(pt_text,THEME:GetString("Grade","Tier04"),0,true) then
								gradestr = "Tier04";
							elseif string.find(pt_text,THEME:GetString("Grade","Tier05"),0,true) then
								gradestr = "Tier05";
							elseif string.find(pt_text,THEME:GetString("Grade","Tier06"),0,true) then
								gradestr = "Tier06";
							elseif string.find(pt_text,THEME:GetString("Grade","Tier07"),0,true) then
								gradestr = "Tier07";
							elseif string.find(pt_text,THEME:GetString("Grade","Failed"),0,true) then
								gradestr = "Failed";
							else (cmd(visible,true;maxwidth,88;zoom,1.8;))(stext);
							end;
							tierimage:visible(true);
							tierimage:Load(THEME:GetPathG("","GradeDisplayEval "..gradestr));
							stext:settext(pt_text);
						else
							(cmd(visible,true;maxwidth,50;zoom,2.75;))(stext);
							stext:settext(pt_text);
						end;
					end;
				elseif sort_sst == 'Title' or sctext == 'Title' or sort_sst == 'Artist' or sctext == 'Artist' then
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
						sectioncolor = color(sectioncolorlist[pt_setting]);
					end;
					if pt_text ~= THEME:GetString("Sort","NotAvailable") then
						if sectiontextlist ~= "" then
							if sectiontextlist[pt_setting] then
								pt_text = sectiontextlist[pt_setting];
							end;
						end;
					end;
					if params.HasFocus then
						if pt_text ~= "" and pt_text ~= THEME:GetString("Sort","NotAvailable") then
							setenv("wheelsectiongroup",pt_text);
							setenv("wheelnotsectionfocus",sectiontext);
							if sectioncolor ~= nil then
								setenv("wheelnotsectioncolorfocus",sectioncolor);
							end;
						else
							setenv("wheelsectiongroup","");
							setenv("wheelnotsectionfocus","");
							setenv("wheelnotsectioncolorfocus","");
						end;
					else
						setenv("wheelnotsectiontextfocus","");
						if pt_text ~= "" and pt_text ~= THEME:GetString("Sort","NotAvailable") then
							if sectioncolor ~= nil then
								grouptext:visible(true);
								grouptext:diffuse( sectioncolor );
								grouptext:settextf("%s",sectiontext);
							end;
						end;
					end;
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
					if params.HasFocus then
						setenv("wheelsectiongroup",pt_text);
					else
						grouptext:diffuse(color_set);
						grouptext:settextf("%s",pt_text);
					end;
				end;
				if sectioncolor ~= nil then up_folder:diffuse( sectioncolor );
				else up_folder:diffuse(color_set);
				end;
			else
				grouptext:diffuse(color("1,0.1,0.4,1"));
				grouptext:settextf("%s",pt_text);
				setenv("wheelsectiongroup",pt_text);
			end;
		end;

		jacket_mirror:diffusealpha(0.2);
		jacket_mirror:diffusetopedge(color("0,0,0,0"));
		jacket_mirror:Load(image_set);
		jacket_mirror:scaletofit(0,0,174,174);
		jacket_mirror:zoomtoheight(174*0.3);
		jacket_mirror:x(0);
		jacket_mirror:y(113);
		
		jacket:diffusealpha(0.775);
		jacket:Load(image_set);
		jacket:scaletofit(0,0,174,174);
		jacket:x(0);
		jacket:y(0);
		
		grouptext:settextf("%s",pt_text);
		if #pt_text >= 21 then
			if #pt_text > 22 then
				grouptext:settextf("%s",string.sub(pt_text,1,strchk(21,36,pt_text)).." ..." );
			end;
		end;
		stext:diffuse(color_set);
	end;

--[[	
	LoadFont("_shared2")..{
		InitCommand=cmd(maxwidth,146;shadowlength,0;strokecolor,Color("Black"););
		SetMessageCommand=function(self,params)
			self:settext(params.Index);
		end;
	};
]]
};

t[#t+1] = wheel_kset(sort_sst,sctext,color_set);

return t;
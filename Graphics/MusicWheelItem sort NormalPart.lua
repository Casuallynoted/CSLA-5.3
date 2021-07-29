if GAMESTATE:GetCurrentStyle() then
local st = GAMESTATE:GetCurrentStyle():GetStepsType();
end;
local pm = GAMESTATE:GetPlayMode();
local eset = false;
if GAMESTATE:GetCurrentStyle() then
local st = GAMESTATE:GetCurrentStyle():GetStepsType();
end;
--setenv("sortset","")
local oldSort = nil;
local ac = 1;
local drawindex = 0;
--local limit = getenv("Timer") + 1;
local key_count = 0;
local csctext = THEME:GetString("MusicWheel","CustomItemCSCText");
local randomtext = THEME:GetString("MusicWheel","CustomItemRandomText");

local t = Def.ActorFrame{};

t[#t+1] = Def.ActorFrame{
	OnCommand=cmd(linear,0.4;playcommand,"Flag";);
	FlagCommand=function(self) ac = 0;
	end;
	SetMessageCommand=function(self, params)
		local items = THEME:GetMetric( "MusicWheel","NumWheelItems" ) + 2;
		drawindex = params.DrawIndex;
		incommandset(self,ac,items,drawindex);
	end;
	LoadActor(THEME:GetPathG("_MusicWheelItem","parts/section_back"))..{
		InitCommand=cmd(y,10;diffuse,color("0.5,0.5,0.5,1");diffusetopedge,color("0.5,1,0.1,1");
					diffusebottomedge,color("0.5,0.5,0.5,0.8"););
	};
	Def.Sprite {
		Name="SongJacket";
		InitCommand=cmd(diffusealpha,1;y,109;rotationy,180;rotationz,180;);
		SetMessageCommand=function(self, params)
			self:diffusetopedge(color("0,0,0,0"));
			self:diffusebottomedge(color("1,1,1,0.7"));
			local sortmenu = params.Label;
			if sortmenu then
				local secname = "None";
				if sortmenu == THEME:GetString("ScreenSort","Group") then
					secname = "Group"
				elseif sortmenu == THEME:GetString("ScreenSort","Title") then
					secname = "Title"
				elseif sortmenu == THEME:GetString("ScreenSort","Artist") then
					secname = "Artist"
				elseif sortmenu == THEME:GetString("ScreenSort","Bpm") then
					secname = "BPM"
				elseif sortmenu == THEME:GetString("ScreenSort","Popularity") then
					secname = "Popularity"
				elseif sortmenu == THEME:GetString("ScreenSort","BeginnerMeter") then
					secname = "BeginnerMeter"
				elseif sortmenu == THEME:GetString("ScreenSort","EasyMeter") then
					secname = "EasyMeter"
				elseif sortmenu == THEME:GetString("ScreenSort","MediumMeter") then
					secname = "MediumMeter"
				elseif sortmenu == THEME:GetString("ScreenSort","HardMeter") then
					secname = "HardMeter"
				elseif sortmenu == THEME:GetString("ScreenSort","ChallengeMeter") then
					secname = "ChallengeMeter"
				elseif sortmenu == THEME:GetString("ScreenSort","Genre") then
					secname = "Genre"
				elseif sortmenu == THEME:GetString("ScreenSort","TopGrades") then
					secname = "TopGradesNone"
				elseif sortmenu == THEME:GetString("ScreenSort","TopGradesBeginner") then
					secname = "TopGradesBeginner"
				elseif sortmenu == THEME:GetString("ScreenSort","TopGradesEasy") then
					secname = "TopGradesEasy"
				elseif sortmenu == THEME:GetString("ScreenSort","TopGradesMedium") then
					secname = "TopGradesMedium"
				elseif sortmenu == THEME:GetString("ScreenSort","TopGradesHard") then
					secname = "TopGradesHard"
				elseif sortmenu == THEME:GetString("ScreenSort","TopGradesChallenge") then
					secname = "TopGradesChallenge"
				elseif sortmenu == THEME:GetString("ScreenSort","Length") then
					secname = "Length"
				elseif sortmenu == THEME:GetString("ScreenSort","Recent") then
					secname = "Recent"
				end;
				self:Load( THEME:GetPathG("_MusicWheelItem","parts/sortsection_jacket_"..secname) );
				
				self:zoomtowidth(174);
				self:zoomtoheight(174/4);
			end;
		end;
	};
	
	Def.Sprite {
		Name="SongJacket";
		InitCommand=cmd(diffusealpha,1;);
		SetMessageCommand=function(self, params)
			local sortmenu = params.Label;
			if sortmenu then
				local secname = "None";
				if sortmenu == THEME:GetString("ScreenSort","Group") then
					secname = "Group"
				elseif sortmenu == THEME:GetString("ScreenSort","Title") then
					secname = "Title"
				elseif sortmenu == THEME:GetString("ScreenSort","Artist") then
					secname = "Artist"
				elseif sortmenu == THEME:GetString("ScreenSort","Bpm") then
					secname = "BPM"
				elseif sortmenu == THEME:GetString("ScreenSort","Popularity") then
					secname = "Popularity"
				elseif sortmenu == THEME:GetString("ScreenSort","BeginnerMeter") then
					secname = "BeginnerMeter"
				elseif sortmenu == THEME:GetString("ScreenSort","EasyMeter") then
					secname = "EasyMeter"
				elseif sortmenu == THEME:GetString("ScreenSort","MediumMeter") then
					secname = "MediumMeter"
				elseif sortmenu == THEME:GetString("ScreenSort","HardMeter") then
					secname = "HardMeter"
				elseif sortmenu == THEME:GetString("ScreenSort","ChallengeMeter") then
					secname = "ChallengeMeter"
				elseif sortmenu == THEME:GetString("ScreenSort","Genre") then
					secname = "Genre"
				elseif sortmenu == THEME:GetString("ScreenSort","TopGrades") then
					secname = "TopGradesNone"
				elseif sortmenu == THEME:GetString("ScreenSort","TopGradesBeginner") then
					secname = "TopGradesBeginner"
				elseif sortmenu == THEME:GetString("ScreenSort","TopGradesEasy") then
					secname = "TopGradesEasy"
				elseif sortmenu == THEME:GetString("ScreenSort","TopGradesMedium") then
					secname = "TopGradesMedium"
				elseif sortmenu == THEME:GetString("ScreenSort","TopGradesHard") then
					secname = "TopGradesHard"
				elseif sortmenu == THEME:GetString("ScreenSort","TopGradesChallenge") then
					secname = "TopGradesChallenge"
				elseif sortmenu == THEME:GetString("ScreenSort","Length") then
					secname = "Length"
				elseif sortmenu == THEME:GetString("ScreenSort","Recent") then
					secname = "Recent"
				end;
				self:Load( THEME:GetPathG("_MusicWheelItem","parts/sortsection_jacket_"..secname) );
				self:zoomtowidth(174);
				self:zoomtoheight(174);
			end;
		end;
	};

	Def.Quad {
		InitCommand=cmd(y,-77;zoomtowidth,174;zoomtoheight,20;diffuse,color("0,0,0,0.9"););
	};

	Def.ActorFrame{
		InitCommand=cmd(x,-45;y,-88;);
		SetMessageCommand=function(self, params)
			local sortmenu = params.Label;
			if sortmenu then
				self:diffuse(color("0.5,1,0.1,0.8"));
			end;
		end;
		
		LoadActor(THEME:GetPathG("_MusicWheelItem","parts/down_folder"))..{
			SetMessageCommand=function(self, params)
				local sortmenu = params.Label;
				if sortmenu then
					self:diffusetopedge(color("0.5,1,0.1,0.8"));
					self:diffusebottomedge(color("0.5,1,0.1,0"));
				end;
			end;
		};

		LoadActor(THEME:GetPathG("_MusicWheelItem","parts/up_folder"))..{
		};
	};
	
	LoadFont("_shared2")..{
		InitCommand=cmd(zoomy,0.9;maxwidth,156;y,104;shadowlength,0;strokecolor,Color("Black"););
		SetMessageCommand=function(self,params)
			local sortmenu = params.Label;
			if sortmenu then
				self:visible(true);
				self:diffusealpha(1);
				self:settextf("%s",params.Label);
				self:diffuse(GetSortColor(sortmenu));
			else
				self:visible(false);
				self:diffusealpha(0);
			end;
		end;
		UpdateCommand=cmd(playcommand,"SetMessage";);
		CurrentSongChangedMessageCommand=cmd(playcommand,"SetMessage");
		CurrentCourseChangedMessageCommand=cmd(playcommand,"SetMessage");
	};
	
	LoadActor(THEME:GetPathG("_MusicWheelItem","parts/sort_label"))..{
		InitCommand=cmd(shadowlength,0;x,-51;y,-77;diffuse,color("0.5,1,0.1,0.4"););
	};
};

--local sortst;
--sortst = Def.ActorFrame{

t[#t+1] = Def.ActorFrame{ 
	LoadFont("_shared2")..{
		InitCommand=cmd(zoomy,0.9;maxwidth,225;y,90;shadowlength,0;strokecolor,Color("Black"););
		SetMessageCommand=function(self,params)
			local sortmenu = params.Label;
			self:visible(false);
			local sortm = GAMESTATE:GetSortOrder();
			if sortmenu and sortm == 'SortOrder_ModeMenu' then
				if params.HasFocus then
					self:visible(false);
					if sortmenu ~= "" and sortmenu ~= THEME:GetString("Sort","NotAvailable") then
						setenv("wheelsectionsort",params.Label);
					else
						setenv("wheelsectionsort","");
					end;
				else
				
				end;
			else
				self:visible(false);
			end;
		end;
		UpdateCommand=cmd(playcommand,"SetMessage";);
		CurrentSongChangedMessageCommand=cmd(playcommand,"SetMessage");
		CurrentCourseChangedMessageCommand=cmd(playcommand,"SetMessage");
	};
};


--[[
local function Update(self)
	local newSort = getenv("sortset");
	if newSort ~= oldSort then
		MESSAGEMAN:Broadcast("SetMessage", { Label = newSort });
	end;
	newSort = oldSort;
end;

sortst.InitCommand=cmd(SetUpdateFunction,Update)
t[#t+1] = sortst;

]]
	
return t;
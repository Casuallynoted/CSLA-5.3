local t = Def.ActorFrame{};

local selmusic_s = {
	{"SelectMusicScreen"},
	{"ItemSelect","ItemSelectWarp","DifficultySelect","Decide","","EnteringOptions",
	"SortMenu","SectionClose","GradeSelect","","RivalData","RivalDataSelect"}
};

local net_selmusic_s = {
	{"SelectMusicScreen (Network)"},
	{"ItemSelect","ItemSelectWarp","NetDifficultySelect","NetDecide","",
	"NetEnteringOptions","NetSortMenu","GradeSelect","","RivalData","RivalDataSelect"}
};

local selcourse_s = {
	{"SelectCourseScreen"},
	{"ItemSelect","ItemSelectWarp","DifficultySelect","Decide","","EnteringOptions",
	"GradeSelect","","RivalData","RivalDataSelect"}
};

local gameplay_s = {
	{"PlayScreen"},
	{"SpeedChangeDown","SpeedChangeUp","","ReverseOn","ReverseOff",
	"","StepLaneCoverUp","StepLaneCoverDown","StepLaneCoverVisible",
	"","Assist","AutoPlaySet","AutoPlayCPUSet"}
};

local etc_s = {
	{"Etc"},
	{"Operator","","F2","ShiftF2","","ScreenShot","ScreenShotHigh",
	"","EditMouseLeft","EditMouseRight"}
};

local settable = {selmusic_s,net_selmusic_s,selcourse_s,gameplay_s,etc_s};
local cursor = 1;
local key_open = 0;
local steplanecover_str_y = 0;
local edit_str_y = 0;
local screen_str_y = SCREEN_TOP+86;
local smeu_color = "0,0.6,0.6,0.7";
local cs_color = "1,0.8,0,0.7";

t[#t+1] = Def.Quad{
	InitCommand=cmd(x,SCREEN_LEFT;y,screen_str_y;zoomtowidth,SCREEN_WIDTH;
				diffuse,color("0,0.6,0.6,0.45");fadetop,0.1;fadebottom,0.1;);
	OnCommand=cmd(horizalign,left;zoomtoheight,0;decelerate,0.5;zoomtoheight,36;);
};

for st=1,#settable do
	local stt = settable[st];
	for i=1,#stt[2] do
		if stt[2][i] == "StepLaneCoverVisible" then
			steplanecover_str_y = SCREEN_TOP+100+(i*22) + 18;
		end;
		if stt[2][i] == "EditMouseRight" then
			edit_str_y = SCREEN_TOP+100+(i*22) + 18;
		end;
		t[#t+1] = Def.ActorFrame{
			InitCommand=function(self)
				(cmd(x,SCREEN_CENTER_X;y,SCREEN_TOP+100+(i*22)))(self);
				self:visible(false);
				if settable[cursor][1][1] == stt[1][1] then self:visible(true);
				end;
			end;
			DirectionButtonMessageCommand=function(self)
				--SCREENMAN:SystemMessage(settable[cursor][1][1] ..",".. stt[1][1]);
				self:visible(false);
				if settable[cursor][1][1] == stt[1][1] then self:visible(true);
				end;
			end;
			
			LoadActor(THEME:GetPathG("OptionRow","Frame/bullet1"))..{
				InitCommand=cmd(horizalign,right;x,-94;y,4;zoom,0.8;shadowlength,2;);
				OnCommand=function(self)
					self:visible(false);
					self:stoptweening();
					self:glow(color("0,0,0,0"));
					if stt[2][i] ~= "" then
						self:visible(true);
						(cmd(diffusealpha,0;sleep,i*0.015;linear,0.15;diffusealpha,1;))(self)
						if op_optionrowcolorcheck(stt[2][i]) then
							self:glow(color(cs_color));
						else self:glow(color("0,0.4,0.4,0.3"));
						end;
					end;
				end;
				DirectionButtonMessageCommand=cmd(playcommand,"On";);
			};

			LoadActor(THEME:GetPathG("OptionRow","Frame/bullet2"))..{
				InitCommand=cmd(horizalign,right;x,-94;y,4;zoom,0.8;);
				OnCommand=function(self)
					self:visible(false);
					self:stoptweening();
					self:glow(color("0,0,0,0"));
					if stt[2][i] ~= "" then
						self:visible(true);
						(cmd(diffusealpha,0;sleep,i*0.015;linear,0.15;diffusealpha,1;))(self)
						if op_optionrowcolorcheck(stt[2][i]) then
							self:glow(color("0,1,1,0.5"));
						end;
					end;
				end;
				DirectionButtonMessageCommand=cmd(playcommand,"On";);
			};

			LoadFont("Common Normal") .. {
				InitCommand=function(self)
					if stt[2][i] ~= "" then
						self:settext( THEME:GetString("ScreenOperation",stt[2][i] ));
					end;
					self:x(-110);
					(cmd(shadowlength,2;horizalign,right;zoom,0.75;maxwidth,SCREEN_WIDTH*0.375;diffuse,Color("Orange");strokecolor,Color("Black")))(self)
				end;
				OnCommand=cmd(stoptweening;diffusealpha,0;sleep,i*0.015;linear,0.15;diffusealpha,1;);
				DirectionButtonMessageCommand=cmd(playcommand,"On";);
			};
			LoadFont("Common Normal") .. {
				InitCommand=function(self)
					if stt[2][i] ~= "" then
						self:settext( THEME:GetString("ScreenOperation",stt[2][i].."Help" ));
					end;
					self:x(-84);
					(cmd(shadowlength,2;horizalign,left;zoom,0.75;maxwidth,SCREEN_WIDTH*0.8;strokecolor,Color("Black")))(self)
				end;
				OnCommand=cmd(stoptweening;cropright,1;sleep,i*0.005;linear,0.25;cropright,0;);
				DirectionButtonMessageCommand=cmd(playcommand,"On";);
			};
		};
	end;
	t[#t+1] = LoadFont("_Shared2") .. {
		InitCommand=function(self)
			self:visible(false);
			if settable[cursor][1][1] == stt[1][1] then self:visible(true);
			end;
			if stt[1][1] ~= "" then
				self:settext( THEME:GetString("ScreenOperation",stt[1][1] ));
			end;
			self:x(SCREEN_LEFT+70);
			self:y(screen_str_y-6);
		end;
		OnCommand=cmd(stoptweening;shadowlength,2;horizalign,left;strokecolor,Color("Black");
					cropright,1;sleep,0.05;decelerate,0.15;cropright,0;);
		DirectionButtonMessageCommand=function(self)
			self:visible(false);
			if settable[cursor][1][1] == stt[1][1] then self:visible(true);
			end;
			self:playcommand("On");
		end;
	};
end;

t[#t+1] = LoadFont("_Shared2") .. {
	InitCommand=cmd(horizalign,right;x,SCREEN_RIGHT-70;y,screen_str_y-12;zoom,0.65;settext,cursor.."/"..#settable;);
	OnCommand=cmd(stoptweening;shadowlength,2;strokecolor,Color("Black");zoomy,0;sleep,0.25;decelerate,0.15;zoomy,0.65;);
	DirectionButtonMessageCommand=cmd(settext,cursor.."/"..#settable;);
};

--[ja] レーンカバーインフォ
t[#t+1] = LoadFont("Common Normal") .. {
	InitCommand=function(self)
		self:visible(false);
		(cmd(x,SCREEN_CENTER_X-240;))(self);
		(cmd(shadowlength,2;horizalign,left;zoom,0.5;maxwidth,SCREEN_WIDTH*1.65;strokecolor,Color("Black")))(self)
	end;
	OnCommand=cmd(stoptweening;shadowlength,2;horizalign,left;strokecolor,Color("Black");
				cropright,1;sleep,0.15;decelerate,0.15;cropright,0;);
	DirectionButtonMessageCommand=function(self)
		self:visible(false);
		self:stoptweening();
		if settable[cursor][1][1] == gameplay_s[1][1] then
			self:visible(true);
			self:y(steplanecover_str_y);
			self:settext( THEME:GetString("ScreenOperation","StepLaneCoverInfo" ));
		elseif settable[cursor][1][1] == etc_s[1][1] then
			self:visible(true);
			self:y(edit_str_y);
			self:settext( THEME:GetString("ScreenOperation","EditInfo" ));
		end;
		self:playcommand("On");
	end;
};

t[#t+1] = LoadFont("Common Normal") .. {
	InitCommand=function(self)
		self:settext( THEME:GetString("ScreenOperation","EffectKeyInfo" ));
		(cmd(x,SCREEN_LEFT+60;y,SCREEN_BOTTOM-40))(self);
		(cmd(shadowlength,2;horizalign,left;zoom,0.5;maxwidth,SCREEN_WIDTH*1.75;strokecolor,Color("Black")))(self)
	end;
	OnCommand=cmd(stoptweening;cropright,1;sleep,0.1;linear,0.25;cropright,0;);
};

function inputs(event)
	local button = event.GameButton
	if key_open == 0 then
		if button == 'MenuUp' or button == 'MenuLeft' then
			if cursor > 1 and (event.type == "InputEventType_FirstPress" or event.type == "InputEventType_Repeat") then
				cursor = math.max(cursor - 1,1);
				SOUND:PlayOnce(THEME:GetPathS("_common","row"));
				MESSAGEMAN:Broadcast("DirectionButton");
				MESSAGEMAN:Broadcast("Previous");
			end;
		end;
		if button == 'MenuDown' or button == 'MenuRight' then
			if cursor < #settable and (event.type == "InputEventType_FirstPress" or event.type == "InputEventType_Repeat") then
				cursor = math.min(cursor + 1,#settable);
				SOUND:PlayOnce(THEME:GetPathS("_common","row"));
				MESSAGEMAN:Broadcast("DirectionButton");
				MESSAGEMAN:Broadcast("Next");
			end;
		end;
		if button == 'Start' or button == 'Center' or button == "Back" then
			key_open = 1;
			if button == 'Start' or button == 'Center' then
				SOUND:PlayOnce(THEME:GetPathS("Common","start"));
			else SOUND:PlayOnce(THEME:GetPathS("_Screen","cancel"));
			end;
			SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToNextScreen");
		end;
	end;
end;

t[#t+1] = Def.ActorFrame {
	OnCommand=function(self)
		SCREENMAN:GetTopScreen():lockinput(0.5);
		SCREENMAN:GetTopScreen():AddInputCallback(inputs);
		SOUND:PlayOnce(THEME:GetPathS("","_swoosh.ogg"));
	end;
};


local function cursorset(self,n,i)
	if n == "Left" then
		self:visible(true);
		if i <= 1 then
			self:visible(false);
		end;
	else
		self:visible(true);
		if i >= #settable then
			self:visible(false);
		end;
	end;
	return self;
end;

t[#t+1] = Def.ActorFrame {
	InitCommand=function(self)
		self:y(screen_str_y);
	end;
	Def.ActorFrame{
		InitCommand=function(self) cursorset(self,"Left",cursor); end;
		DirectionButtonMessageCommand=function(self) cursorset(self,"Left",cursor); end;
		PreviousMessageCommand=cmd(stoptweening;glow,color("1,1,0,1");x,12;decelerate,0.25;glow,color("0,0,0,0");x,0;);
	
		LoadActor( THEME:GetPathB("","arrow") )..{
			OnCommand=cmd(x,SCREEN_LEFT+26;rotationy,180;diffusealpha,0;sleep,0.3;queuecommand,"Repeat";);
			RepeatCommand=cmd(addx,16;diffusealpha,1;glow,color("1,0.7,0,1");linear,0.8;glow,color("0,0,0,0");addx,-16;diffusealpha,0;sleep,0.2;queuecommand,"Repeat";);
			OffCommand=cmd(stoptweening;);
		};
	};
	Def.ActorFrame{
		InitCommand=function(self) cursorset(self,"Right",cursor); end;
		DirectionButtonMessageCommand=function(self) cursorset(self,"Right",cursor); end;
		NextMessageCommand=cmd(stoptweening;glow,color("1,1,0,1");x,-12;decelerate,0.25;glow,color("0,0,0,0");x,0;);
	
		LoadActor( THEME:GetPathB("","arrow") )..{
			OnCommand=cmd(x,SCREEN_RIGHT-26;diffusealpha,0;sleep,0.3;queuecommand,"Repeat";);
			RepeatCommand=cmd(addx,-16;diffusealpha,1;glow,color("1,0.7,0,1");linear,0.8;glow,color("0,0,0,0");addx,16;diffusealpha,0;sleep,0.2;queuecommand,"Repeat";);
			OffCommand=cmd(stoptweening;);
		};
	};
};
	
return t;

local profile= GAMESTATE:GetEditLocalProfile()
local profile_id= GAMESTATE:GetEditLocalProfileID();

local cc = ProfIDPrefCheck("CCover",profile_id,"Off");
local cco = ProfIDPrefCheck("CCoverStr",profile_id,"_blank");
local arrowsStandard = THEME:GetMetric("Player","ReceptorArrowsYStandard");

local t = Def.ActorFrame{};

local s_hidden = true;
local lrcheck = true;
local basex = 264;
local basey = SCREEN_CENTER_Y+100;
local basespace = 40;
local key_open = 0;
local space = 210;
local rsetnum = 5;
local curIndex = {1,1,1,1,1};	--thindex,alpha,color,line,cursorflag
local xwideset = WideScale(SCREEN_CENTER_X-180,SCREEN_CENTER_X-210);
local ccraphics = split(",",CGraphicList());
local cgrtable = {};
for i=1,#ccraphics do
	cgrtable[i] = ccraphics[i];
	Trace("cgrtable : "..cgrtable[i]);
end;
local cscraphics = split(",",CGraphicFile());
local csgrtable = {"Off"};
for i=1,#cscraphics do
	csgrtable[i+1] = cscraphics[i];
	if csgrtable[i+1] then
		Trace("csgrtable : "..csgrtable[i+1]);
	end;
end;
csgrtable[#csgrtable+1] = "Random";

--20160701
local cpstyle = {
	dance = {"Single","Solo","Double"},
	pump = {"Single","Halfdouble","Double"},
};

local alltable = {
	{
		Name = "Cover",
		Num = 1,
		Set = cgrtable,
		Acsettable = csgrtable,
	},
	{
		Name = "Preview",
		Num = 2,
		Set = cpstyle[CurGameName()],
		Acsettable = {},
	},
	{
		Name = "exit",
		Num = 3,
		Set = {},
		Acsettable = {},
	}
};

function SetT(num)
	local sett = {};

	for x = 1,#alltable[num].Set do
		local ss = Def.ActorFrame {
			LoadFont("Common Normal") .. {
				InitCommand=cmd(playcommand,"Set";);
				SetCommand=function(self)
					self:strokecolor(Color("Black"));
					self:shadowlength(2);
					--self:settext("aaaaaaaaaaaaaaaaaaaaaaaaaaaa");
					self:settext(alltable[num].Set[x]);
					if num == 1 then
						if cc then
							if cc == alltable[num].Set[x] then
								curIndex[num+1] = x;
							end;
						end;
					end;
					(cmd(horizalign,left;maxwidth,200;x,basex;y,-7;zoom,0.8;))(self)
				end;
				DirectionButtonMessageCommand=cmd(visible,s_hidden;);
			};
		};
		sett[#sett+1]=ss;
	end;
	
	return sett
end;

t[#t+1] = Def.ActorFrame {
	Def.Quad{
		InitCommand=cmd(horizalign,left;vertalign,top;y,basey-26;diffuse,color("0,0,0,0.75");
					faderight,0.3;zoomtowidth,SCREEN_WIDTH;zoomtoheight,(basespace*#alltable)+20;);
		DirectionButtonMessageCommand=cmd(visible,s_hidden;);
	};
};

t[#t+1] = Def.ActorFrame {
	Def.Quad{
		Name="Cursor";
		InitCommand=cmd(horizalign,left;y,basey+(basespace*(curIndex[1]-1)-4);diffuse,color("1,0.5,0,0.5");
					diffuserightedge,color("1,1,0,0");zoomtowidth,SCREEN_WIDTH*0.65;zoomtoheight,20;);
		DirectionButtonMessageCommand=function(self)
			self:visible(false);
			if s_hidden then
				self:visible(s_hidden);
				self:finishtweening();
				self:linear(0.1);
				self:y(basey+(basespace*(curIndex[1]-1)-4));
			end;
		end;
	};
};

t[#t+1] = Def.ActorFrame {
	InitCommand=cmd(x,xwideset;);
	Def.Quad{
		Name="LeftMask";
		InitCommand=cmd(x,50+30;y,SCREEN_CENTER_Y;zoomto,SCREEN_WIDTH,SCREEN_HEIGHT;horizalign,right;clearzbuffer,true;zwrite,true;blend,Blend.NoEffect;);
	};

	Def.Quad{
		Name="RightMask";
		InitCommand=cmd(x,220+30;y,SCREEN_CENTER_Y;zoomto,SCREEN_WIDTH,SCREEN_HEIGHT;horizalign,left;clearzbuffer,false;zwrite,true;blend,Blend.NoEffect;);
	};
};

for idx, cat in pairs(alltable) do
	t[#t+1] = Def.ActorFrame {
		InitCommand=cmd(x,xwideset;y,basey+((cat.Num-1)*basespace););
		
		LoadActor(THEME:GetPathG("EditMenu","left"))..{
			InitCommand=cmd(x,36+30;y,-4;shadowlength,2;);
			OnCommand=cmd(playcommand,"Set";);
			SetCommand=function(self)
				self:visible(s_hidden);
				if s_hidden then
					self:visible(false);
					if cat.Name ~= "exit" and curIndex[1] == cat.Num then
						self:visible(true);
						if curIndex[cat.Num+1] <= 1 then
							self:glow(color("0,0,0,0.5"));
						else self:glow(color("0,0,0,0"));
						end;
					end;
				else self:visible(false);
				end;
			end;
			DirectionButtonMessageCommand=cmd(playcommand,"Set";);
		};
		LoadActor(THEME:GetPathG("EditMenu","right"))..{
			InitCommand=cmd(x,234+30;y,-4;shadowlength,2;);
			OnCommand=cmd(playcommand,"Set";);
			SetCommand=function(self)
				if s_hidden then
					self:visible(false);
					if cat.Name ~= "exit" and curIndex[1] == cat.Num then
						self:visible(true);
						if curIndex[cat.Num+1] >= #cat.Set then
							self:glow(color("0,0,0,0.5"));
						else self:glow(color("0,0,0,0"));
						end;
					end;
				else self:visible(false);
				end;
			end;
			DirectionButtonMessageCommand=cmd(playcommand,"Set";);
		};
		
		LoadFont("Common Normal") .. {
			InitCommand=cmd(shadowlength,2;x,-WideScale(100,150));
			OnCommand=function(self)
				local Title = THEME:GetString( Var "LoadingScreen" , cat.Name );
				self:settext(Title);
				--self:settext("aaaaaaaaaaaaaaaaaaaaaaaaaaaa");
				(cmd(horizalign,left;maxwidth,170;y,-7;zoom,0.8;))(self)
				if cat.Name == "exit" then
					self:diffuse(color("0,1,1,1"));
					self:strokecolor(ColorDarkTone(color("1,0.5,0,1")));
				else
					self:diffuse(color("1,0.65,0,1"));
					self:strokecolor(Color("Black"));
				end;
			end;
			DirectionButtonMessageCommand=cmd(visible,s_hidden;);
		};

		Def.ActorScroller{
			Name = 'Scroller'..cat.Name;
			NumItemsToDraw=3;
			InitCommand=function(self)
				self:clearzbuffer(true);
				self:zwrite(true);
				self:zbuffer(true);
				self:ztest(true);
				self:z(0);
				(cmd(SetFastCatchup,true;SetSecondsPerItem,0.001;SetDestinationItem,curIndex[cat.Num+1];))(self)
			end;
			TransformFunction=function(self, offset, itemIndex, numItems)
				self:visible(false);
				self:x(math.floor( offset*space )+30);
				self:y(0);
			end;
			DirectionButtonMessageCommand = function(self, params)
				self:SetDestinationItem( curIndex[cat.Num+1] );
			end;
			children = SetT(cat.Num);
		};
	};
end;

t[#t+1]=LoadFont("_shared2") .. {
	InitCommand=function(self)
		self:settext( profile:GetDisplayName() );
		(cmd(horizalign,left;x,SCREEN_LEFT+60;y,SCREEN_TOP+70;maxwidth,250;zoom,0.9;strokecolor,Color("Black");))(self)
	end;
};

--[[
	t[#t+1] = LoadFont("Common Normal") .. {
		Text= #csgrtable;
		InitCommand=function(self)
			(cmd(horizalign,left;x,82;y,100;zoom,0.8;))(self)
			self:diffuse(Color("White"));
			self:strokecolor(Color("Black"));
		end;
		DirectionButtonMessageCommand=function(self,param)
			self:settext(curIndex[2]..","..param.Cover..","..param.CoverSS);
		end;
	};
]]

t[#t+1] = Def.ActorFrame {
	-- sounds
	LoadActor( THEME:GetPathS("MusicWheel","expand") )..{
		ExpandButtonMessageCommand=cmd(play);
	};
};

--20160417
function inputs(event)
	local button = event.GameButton
	if key_open == 0 then
		if event.type ~= "InputEventType_Release" then
			if (button == 'MenuLeft' or button == 'MenuRight') and s_hidden then
				if button == 'MenuLeft' then
					if curIndex[alltable[curIndex[1]].Num+1] > 1 then
						if curIndex[alltable[curIndex[1]].Num+1] <= #alltable[curIndex[1]].Set then
							curIndex[alltable[curIndex[1]].Num+1] = curIndex[alltable[curIndex[1]].Num+1] - 1;
							SOUND:PlayOnce(THEME:GetPathS("_common","value"));
						end;
					end;
				end;
				if button == 'MenuRight' then
					if curIndex[alltable[curIndex[1]].Num+1] > 0 then
						if curIndex[alltable[curIndex[1]].Num+1] < #alltable[curIndex[1]].Set then
							curIndex[alltable[curIndex[1]].Num+1] = curIndex[alltable[curIndex[1]].Num+1] + 1;
							SOUND:PlayOnce(THEME:GetPathS("_common","value"));
						end;
					end;
				end;
				MESSAGEMAN:Broadcast("DirectionButton",
				{Cover = alltable[1].Set[curIndex[2]],CoverSS = alltable[1].Acsettable[curIndex[2]],Style = alltable[2].Set[curIndex[3]]});
			end;
			if (button == 'MenuDown' or button == 'MenuUp') and s_hidden then
				if button == 'MenuDown' then
					if alltable[curIndex[1]].Num >= 1 and alltable[curIndex[1]].Num < #alltable then
						curIndex[1] = alltable[curIndex[1]].Num + 1;
						SOUND:PlayOnce(THEME:GetPathS("_common","row"));
					end;
				end;
				if button == 'MenuUp' then
					if alltable[curIndex[1]].Num > 1 and alltable[curIndex[1]].Num <= #alltable then
						curIndex[1] = alltable[curIndex[1]].Num - 1;
						SOUND:PlayOnce(THEME:GetPathS("_common","row"));
					end;
				end;
				MESSAGEMAN:Broadcast("DirectionButton",
				{Cover = alltable[1].Set[curIndex[2]],CoverSS = alltable[1].Acsettable[curIndex[2]],Style = alltable[2].Set[curIndex[3]]});
			end;
		end;
		if event.type == "InputEventType_FirstPress" then
			if button == 'Select' then
				if s_hidden then
					s_hidden = false;
				else s_hidden = true;
				end;
				SOUND:PlayOnce(THEME:GetPathS("_common","value"));
				MESSAGEMAN:Broadcast("DirectionButton",
				{Cover = alltable[1].Set[curIndex[2]],CoverSS = alltable[1].Acsettable[curIndex[2]],Style = alltable[2].Set[curIndex[3]]});
			end;
			if alltable[curIndex[1]].Name == "exit" and s_hidden then
				if button == 'Start' or button == 'Center' then
					key_open = 1;
					MESSAGEMAN:Broadcast("StartButton");
					SOUND:PlayOnce(THEME:GetPathS("Common","start"));
					SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToNextScreen");
					SetAdhocPref("CCover",alltable[1].Set[curIndex[2]],profile_id);
					SetAdhocPref("CCoverStr",alltable[1].Acsettable[curIndex[2]],profile_id);
				end;
			end;
			if button == "Back" then
				key_open = 1;
				MESSAGEMAN:Broadcast("BackButton");
				SOUND:PlayOnce(THEME:GetPathS("_Screen","cancel"));
				SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToPrevScreen");
			end;
		end;
	end;
end;
t[#t+1] = Def.ActorFrame {
	OnCommand=function(self)
		SCREENMAN:GetTopScreen():lockinput(0.25);
		SCREENMAN:GetTopScreen():AddInputCallback(inputs);
	end;
};

return t;
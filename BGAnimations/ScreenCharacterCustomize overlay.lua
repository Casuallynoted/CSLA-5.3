
local profile= GAMESTATE:GetEditLocalProfile();
local profile_id= GAMESTATE:GetEditLocalProfileID();
local chera = profile:GetCharacter();
local ctable = {"Off"};
for i=1,#CHARMAN:GetAllCharacters() do
	ctable[#ctable+1] = CHARMAN:GetAllCharacters()[i];
end;


local t = Def.ActorFrame{};

local lrcheck = true;
local basex = 220;
local basey = SCREEN_CENTER_Y+30;
local basespace = 40;
local key_open = 0;
local space = 208;
local rsetnum = 5;
local curIndex = {1,1,1};	--thindex,character,cursorflag
local xwideset = WideScale(SCREEN_CENTER_X-250,SCREEN_CENTER_X-280);

local alltable = {
	{
		Name = "Character",
		Num = 1,
		Set = ctable,
		Acsettable = {},
	},
	{
		Name = "exit",
		Num = 2,
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
					self:shadowlength(2);
					--self:settext("aaaaaaaaaaaaaaaaaaaaaaaaaaaa");
					self:strokecolor(Color("Black"));
					if num == 1 then
						if alltable[num].Set[x] == "Off" then
							local Title = THEME:GetString( "ScreenCharacterCustomize" , "Off" );
							self:settext(Title);
						else
							self:settext(alltable[num].Set[x]:GetDisplayName());
							
							if #ctable > 0 then
								if chera:GetDisplayName() == alltable[num].Set[x]:GetDisplayName() then
									curIndex[num+1] = x;
								end;
							end;
						end;
					end;
					(cmd(horizalign,left;maxwidth,260;x,basex;y,-7;zoom,0.8;))(self)
				end;
			};
		};
		sett[#sett+1]=ss;
	end;

	return sett
end;

t[#t+1] = Def.ActorFrame {
	Def.Quad{
		Name="Cursor";
		InitCommand=function(self)
			local yset = 0;
			if curIndex[1] == 1 then
				yset = 50;
			end;
			(cmd(horizalign,left;y,basey+(basespace*(curIndex[1]-1)-4)-yset;diffuse,color("1,0.5,0,0.5");
			diffuserightedge,color("1,1,0,0");zoomtowidth,SCREEN_WIDTH*0.525;zoomtoheight,20;))(self)
		end;
		DirectionButtonMessageCommand=function(self)
			local yset = 0;
			if curIndex[1] == 1 then
				yset = 50;
			end;
			self:finishtweening();
			self:linear(0.1);
			self:y(basey+(basespace*(curIndex[1]-1)-4)-yset);
		end;
	};
};

t[#t+1] = Def.ActorFrame {
	InitCommand=cmd(x,xwideset;);
	Def.Quad{
		Name="LeftMask";
		InitCommand=cmd(x,8;y,SCREEN_CENTER_Y;zoomto,SCREEN_WIDTH,SCREEN_HEIGHT;horizalign,right;clearzbuffer,true;zwrite,true;blend,Blend.NoEffect;);
	};

	Def.Quad{
		Name="RightMask";
		InitCommand=cmd(x,214;y,SCREEN_CENTER_Y;zoomto,SCREEN_WIDTH,SCREEN_HEIGHT;horizalign,left;clearzbuffer,false;zwrite,true;blend,Blend.NoEffect;);
	};
};

t[#t+1] = LoadFont("Common Normal") .. {
	InitCommand=cmd(x,xwideset;y,basey-100;shadowlength,2;);
	OnCommand=function(self)
		local Title = THEME:GetString( Var "LoadingScreen" , "Character" );
		self:settext(Title);
		--self:settext("aaaaaaaaaaaaaaaaaaaaaaaaaaaa");
		(cmd(horizalign,left;maxwidth,320;zoom,0.8;))(self)
		self:diffuse(color("1,0.65,0,1"));
		self:strokecolor(Color("Black"));
	end;
};

for idx, cat in pairs(alltable) do
	t[#t+1] = Def.ActorFrame {
		InitCommand=function(self)
			local yset = 0;
			if cat.Num == 1 then
				yset = 50;
			end;
			(cmd(x,xwideset;y,basey+((cat.Num-1)*basespace)-yset;))(self)
		end;
		LoadActor(THEME:GetPathG("EditMenu","left"))..{
			InitCommand=cmd(x,-4;y,-4;shadowlength,2;);
			OnCommand=cmd(playcommand,"Set";);
			SetCommand=function(self)
				--self:animate(false);
				self:visible(false);
				if cat.Name ~= "exit" and curIndex[1] == cat.Num then
					self:visible(true);
					if curIndex[cat.Num+1] <= 1 then
						--self:animate(false);
						self:glow(color("0,0,0,0.5"));
					else
						--self:animate(true);
						self:glow(color("0,0,0,0"));
					end;
				end;
			end;
			DirectionButtonMessageCommand=cmd(playcommand,"Set";);
		};
		LoadActor(THEME:GetPathG("EditMenu","right"))..{
			InitCommand=cmd(x,226;y,-4;shadowlength,2;);
			OnCommand=cmd(playcommand,"Set";);
			SetCommand=function(self)
				--self:animate(false);
				self:visible(false);
				if cat.Name ~= "exit" and curIndex[1] == cat.Num then
					self:visible(true);
					if curIndex[cat.Num+1] >= #cat.Set then
						--self:animate(false);
						self:glow(color("0,0,0,0.5"));
					else
						--self:animate(true);
						self:glow(color("0,0,0,0"));
					end;
				end;
			end;
			DirectionButtonMessageCommand=cmd(playcommand,"Set";);
		};
		
		LoadFont("Common Normal") .. {
			InitCommand=cmd(shadowlength,2;);
			OnCommand=function(self)
				if cat.Name == "exit" then
					local Title = THEME:GetString( Var "LoadingScreen" , cat.Name );
					self:settext(Title);
					--self:settext("aaaaaaaaaaaaaaaaaaaaaaaaaaaa");
					(cmd(horizalign,left;maxwidth,120;y,-7;zoom,0.8;))(self)
					self:diffuse(color("0,1,1,1"));
					self:strokecolor(ColorDarkTone(color("1,0.5,0,1")));
				end;
			end;
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
				self:x(math.floor( offset*space ));
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
		Text= #arrows;
		InitCommand=function(self)
			(cmd(maxwidth,150;x,82;y,100;zoom,0.8;))(self)
			self:diffuse(Color("White"));
			self:strokecolor(Color("Black"));
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
			if button == 'MenuLeft' or button == 'MenuRight' then
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
				MESSAGEMAN:Broadcast("DirectionButton",{Character = alltable[1].Set[curIndex[2]]});
			end;
			if button == 'MenuDown' or button == 'MenuUp' then
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
				MESSAGEMAN:Broadcast("DirectionButton",{Character = alltable[1].Set[curIndex[2]]});
			end;
		end;
		if event.type == "InputEventType_FirstPress" then
			if alltable[curIndex[1]].Name == "exit" then
				if button == 'Start' or button == 'Center' then
					key_open = 1;
					MESSAGEMAN:Broadcast("StartButton");
					SOUND:PlayOnce(THEME:GetPathS("Common","start"));
					SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToNextScreen");
					if alltable[1].Set[curIndex[2]] ~= "Off" then
						profile:SetCharacter(alltable[1].Set[curIndex[2]]:GetCharacterID());
						SetAdhocPref("CharacterSet",alltable[1].Set[curIndex[2]]:GetCharacterID()..",1",profile_id);
					else
						profile:SetCharacter("default");
						SetAdhocPref("CharacterSet","default,1",profile_id);
					end;
					PROFILEMAN:SaveLocalProfile(profile_id);
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
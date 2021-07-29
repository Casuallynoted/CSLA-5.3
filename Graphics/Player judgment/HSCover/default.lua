--[[HSCover]]

local pn = ...
assert(pn,"Must pass in a player, dingus");

--local csize = split(",",ProfIDPrefCheck("CNoteSize",GetAdhocPref("ProfIDSet" .. ToEnumShortString(pn)),"New,0"))
 --[ja] NoteFieldレイヤーはminiなどの倍率が反映されるけど、Playerレイヤーは1倍以上は反映されないので対策
 --[ja] Player.cpp 858～860行
local mlevel = GAMESTATE:IsCourseMode() and "ModsLevel_Stage" or "ModsLevel_Preferred";
local mini_set = GAMESTATE:GetPlayerState(pn):GetPlayerOptions(mlevel):Mini();
local tiny_set = GAMESTATE:GetPlayerState(pn):GetPlayerOptions(mlevel):Tiny();
if tiny_set == 1 then
	tiny_set = scale(mini_set,0.98,-1,0.5,1.5);
end;
local cover_zoom = 1;
local judgmentzoom = scale(mini_set+tiny_set,0.98,-1,0.5,1.5);
if judgmentzoom > 1 then
	cover_zoom = judgmentzoom;
end;
--[[
if csize[1] == "Old" and judgmentzoom < 0.99494 then
	cover_zoom = scale(mini_set+tiny_set,0.98,0,2,1);
end;
]]
local t = Def.ActorFrame{
	BeginCommand=function(self)
		self:visible(GAMESTATE:IsHumanPlayer(pn));
	end;
	PlayerJoinedMessageCommand=function(self,param)
		if param.Player == pn then
			self:visible(true);
		end;
	end;
	PlayerUnjoinedMessageCommand=function(self,param)
		if param.Player == pn then
			self:visible(false);
		end;
	end;
};
--[[
local op = string.lower(GAMESTATE:GetPlayerState(pn):GetPlayerOptionsString('ModsLevel_Preferred'));
local opsp = split(",",op);
local ministate = 0;
for i=1,#opsp do
	if string.find(opsp[i],"mini") then
		local minisp = split(" ",opsp[i]);
		ministate = string.sub(minisp[2],1,-2);
		break;
	end;
end;
]]
local p = ( (pn == PLAYER_1) and 1 or 2 );
local str = ProfIDSet(p);

local coverpos = 140;
local coverset = 0;
local coverhidden = 0;
local setcount = 4;
local jtransform = 30;

local hsp = ProfIDPrefCheck("CAppearance",str,"Off");
local cc = ProfIDPrefCheck("CCover",str,"Off");
local cco = ProfIDPrefCheck("CCoverStr",str,"_blank");

if pn then
	if getenv("coverpos"..str) then
		coverpos = getenv("coverpos"..str);
	elseif ProfIDPrefCheck("CoverPos",str,"") ~= "" then
		coverpos = ProfIDPrefCheck("CoverPos",str,"");
	end;
	setenv("coverpos"..str,tonumber(coverpos));
	SetAdhocPref("CoverPos",tonumber(coverpos),str);
	--local csets = split(",", CGraphicList())
end;

local hss = 0;
if hsp == "Hidden+" then
	hss = 1;
elseif hsp == "Sudden+" then
	hss = 2;
elseif hsp == "Hid++Sud+" then
	hss = 3;
end;

if tonumber(coverpos) then
	if tonumber(coverpos) < 0 then
		coverpos = 0;
	elseif tonumber(coverpos) > 480 then
		coverpos = 480;
	end;
else coverpos = 140;
end;
if hss == 3 then
	if tonumber(coverpos) > 240 then
		coverpos = 240;
	end;
end;

local minicv = false;
local ps = GAMESTATE:GetPlayerState(pn);
local po = ps:GetPlayerOptions("ModsLevel_Preferred");
local modstr = "default, " .. ps:GetPlayerOptionsString("ModsLevel_Preferred");
--Trace("Option : "..modstr);
if string.find(modstr,"^.*Reverse.*") then
	jtransform = -20;
	if hsp == "Hidden+" then
		hss = 2;
	elseif hsp == "Sudden+" then
		hss = 1;
	end;
else
	jtransform = 30;
	if hsp == "Hidden+" then
		hss = 1;
	elseif hsp == "Sudden+" then
		hss = 2;
	end;
end;
if judgmentzoom < 1 then
	minicv = true;
end;

t[#t+1] = Def.ActorFrame{
	InitCommand=cmd(visible,false);
	CodeMessageCommand=function(self,params)
		if params.PlayerNumber == pn then
			if params.Name == "CoverUp" then
				if coverhidden == 0 then
					self:finishtweening();
					coverset = 1;
					coverpos = tonumber(coverpos) + setcount;
					setenv("coverpos"..str,coverpos);
				end;
			elseif params.Name == "CoverDown" then
				if coverhidden == 0 then
					self:finishtweening();
					coverset = 1;
					coverpos = tonumber(coverpos) - setcount;
					setenv("coverpos"..str,coverpos);
				end;
			elseif params.Name == "CoverHidden" then
				coverset = 0;
				if coverhidden == 0 then
					coverhidden = 1;
				else
					coverhidden = 0;
				end;
			elseif params.Name == "ScrollNomal" or params.Name == "ScrollNomal2" then
				if coverhidden == 0 then
					coverset = 1;
					if hsp == "Hidden+" then
						hss = 1;
					elseif hsp == "Sudden+" then
						hss = 2;
					end;
				end;
				jtransform = 30;
			elseif params.Name == "ScrollReverse" or params.Name == "ScrollReverse2" then
				if coverhidden == 0 then
					coverset = 1;
					if hsp == "Hidden+" then
						hss = 2;
					elseif hsp == "Sudden+" then
						hss = 1;
					end;
				end;
				jtransform = -20;
			elseif params.Name == "HiSpeedUp" or params.Name == "HiSpeedUp2" then
				if coverhidden == 0 then
					coverset = 1;
				end;
			elseif params.Name == "HiSpeedDown" or params.Name == "HiSpeedDown2" then
				if coverhidden == 0 then
					coverset = 1;
				end;
			end;
		end;
	end;
};

--hid
t[#t+1] = Def.ActorFrame{
	InitCommand=function(self)
		self:zoom(cover_zoom);
		self:y(jtransform);
		self:playcommand("Set");
	end;
	SetCommand=function(self)
		self:y(jtransform);
	end;
	CodeMessageCommand=function(self,params)
		self:playcommand("Set");
	end;

	Def.ActorFrame{
		InitCommand=function(self)
			if hss == 1 or hss == 3 then
				self:visible(true);
			else self:visible(false);
			end;
			self:rotationx(180);
			self:y(-SCREEN_HEIGHT+tonumber(coverpos));
			self:vertalign(top);
			self:playcommand("Set");
		end;
		SetCommand=function(self)
			if hss == 1 or hss == 3 then
				self:stoptweening();
				if coverset == 0 then
					if coverhidden == 0 then
						self:visible(true);
					elseif coverhidden == 1 then
						self:visible(false);
					end;
				else
					self:visible(true);
					self:accelerate(0.05);
					self:y(-SCREEN_HEIGHT+tonumber(coverpos));
				end;
			else self:visible(false);
			end;
		end;
		CodeMessageCommand=function(self,params)
			if hss == 1 then
				if params.PlayerNumber == pn then
					if tonumber(coverpos) <= 0 then
						coverpos = 0;
					elseif tonumber(coverpos) >= 480 then
						coverpos = 480;
					end;
					self:playcommand("Set");
				end;
			elseif hss == 3 then
				if params.PlayerNumber == pn then
					if tonumber(coverpos) <= 0 then
						coverpos = 0;
					elseif tonumber(coverpos) >= 240 then
						coverpos = 240;
					end;
					self:playcommand("Set");
				end;
			else
				if params.PlayerNumber == pn then
					self:playcommand("Set");
				end;
			end;
		end;
		Def.Quad{
			InitCommand=function(self)
				self:visible(minicv);
				self:x(0.5);
				self:y(480);
				self:zoomtowidth(ColumnChecker()+20);
				self:zoomtoheight(scale(mini_set+tiny_set,0.98,-1,480,0));
				self:diffuse(color("0,0,0,1"));
			end;
		};
		LoadActor("cover_center_width")..{
			InitCommand=function(self)
				self:x(0);
				self:zoomtowidth(ColumnChecker());
			end;
		};
		Def.ActorFrame{
			InitCommand=function(self)
				self:horizalign(right);
			end;
			LoadActor("cover_side")..{
				InitCommand=function(self)
					self:x(-(ColumnChecker()/2)-4+1-2);
				end;
			};
			LoadActor("cover_center_main")..{
				InitCommand=function(self)
					self:horizalign(left);
					self:x(-(ColumnChecker()/2)+1-2);
				end;
			};
		};
		Def.ActorFrame{
			InitCommand=function(self)
				self:horizalign(left);
			end;
			LoadActor("cover_side")..{
				InitCommand=function(self)
					self:rotationy(180);
					self:x((ColumnChecker()/2)+4+2);
				end;
			};
			LoadActor("cover_center_main")..{
				InitCommand=function(self)
					self:rotationy(180);
					self:horizalign(left);
					self:x((ColumnChecker()/2)+2);
				end;
			};
		};
		Def.Sprite{
			InitCommand=function(self)
				coverseta(self,"nil",cc,cco);
			end;
		};
		Def.Sprite{
			InitCommand=function(self)
				coversetb(self,"nil",cc,cco);
			end;
		};
		LoadFont("_um") .. {
			InitCommand=function(self)
				self:x(0);
				self:y(-234);
				self:zoom(0.5);
				self:strokecolor(color("0,0,0,1"));
				self:rotationx(180);
				self:settext(tonumber(coverpos));
				self:playcommand("Set2");
			end;
			Set2Command=function(self)
				self:finishtweening();
				self:diffusealpha(1);
				self:settext(tonumber(coverpos));
				self:sleep(2);
				self:diffusealpha(0);
			end;
			CodeMessageCommand=function(self,params)
				if hss == 1 or hss == 3 then
					if params.PlayerNumber == pn then
						self:playcommand("Set2");
					end;
				end;
			end;
		};
	};
	--sud
	Def.ActorFrame{
		InitCommand=function(self)
			if hss == 2 or hss == 3 then
				self:visible(true);
			else self:visible(false);
			end;
			self:y(SCREEN_HEIGHT-tonumber(coverpos));
			self:vertalign(bottom);
			self:playcommand("Set");
		end;
		SetCommand=function(self)
			if hss == 2 or hss == 3 then
				self:stoptweening();
				if coverset == 0 then
					if coverhidden == 0 then
						self:visible(true);
					elseif coverhidden == 1 then
						self:visible(false);
					end;
				else
					self:visible(true);
					self:accelerate(0.05);
					self:y(SCREEN_HEIGHT-tonumber(coverpos));
				end;
			else self:visible(false);
			end;
		end;
		CodeMessageCommand=function(self,params)
			if hss == 2 then
				if params.PlayerNumber == pn then
					if tonumber(coverpos) <= 0 then
						coverpos = 0;
					elseif tonumber(coverpos) >= 480 then
						coverpos = 480;
					end;
					self:playcommand("Set");
				end;
			elseif hss == 3 then
				if params.PlayerNumber == pn then
					if tonumber(coverpos) <= 0 then
						coverpos = 0;
					elseif tonumber(coverpos) >= 240 then
						coverpos = 240;
					end;
					self:playcommand("Set");
				end;
			else
				if params.PlayerNumber == pn then
					self:playcommand("Set");
				end;
			end;
		end;

		Def.Quad{
			InitCommand=function(self)
				self:visible(minicv);
				self:x(0.5);
				self:y(480);
				self:zoomtowidth(ColumnChecker()+20);
				self:zoomtoheight(scale(mini_set+tiny_set,0.98,-1,480,0));
				self:diffuse(color("0,0,0,1"));
			end;
		};
		LoadActor("cover_center_width")..{
			InitCommand=function(self)
				self:x(0);
				self:zoomtowidth(ColumnChecker());
			end;
		};
		Def.ActorFrame{
			InitCommand=function(self)
				self:horizalign(right);
			end;
			LoadActor("cover_side")..{
				InitCommand=function(self)
					self:x(-(ColumnChecker()/2)-4+1-2);
				end;
			};
			LoadActor("cover_center_main")..{
				InitCommand=function(self)
					self:horizalign(left);
					self:x(-(ColumnChecker()/2)+1-2);
				end;
			};
		};
		Def.ActorFrame{
			InitCommand=function(self)
				self:horizalign(left);
			end;
			LoadActor("cover_side")..{
				InitCommand=function(self)
					self:rotationy(180);
					self:x((ColumnChecker()/2)+4+2);
				end;
			};
			LoadActor("cover_center_main")..{
				InitCommand=function(self)
					self:rotationy(180);
					self:horizalign(left);
					self:x((ColumnChecker()/2)+2);
				end;
			};
		};
		Def.Sprite{
			InitCommand=function(self)
				coverseta(self,"nil",cc,cco);
			end;
		};
		Def.Sprite{
			InitCommand=function(self)
				coversetb(self,"nil",cc,cco);
			end;
		};
		LoadFont("_um") .. {
			InitCommand=function(self)
				self:x(0);
				self:y(-228);
				self:zoom(0.5);
				self:strokecolor(color("0,0,0,1"));
				self:settext(tonumber(coverpos));
				self:playcommand("Set2");
			end;
			Set2Command=function(self)
				self:finishtweening();
				self:diffusealpha(1);
				self:settext(tonumber(coverpos));
				self:sleep(2);
				self:diffusealpha(0);
			end;
			CodeMessageCommand=function(self,params)
				if hss == 2 or hss == 3 then
					if params.PlayerNumber == pn then
						self:playcommand("Set2");
					end;
				end;
			end;
		};
	};
};

return t;
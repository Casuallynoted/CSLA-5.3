--[[ScreenOptionsRivalSet overlay]]

--[ja] ここでリロードしないとライバル反映されない
THEME:ReloadMetrics();

local t = Def.ActorFrame {
};

local profile= GAMESTATE:GetEditLocalProfile();
local profile_id= GAMESTATE:GetEditLocalProfileID();
local pid_name = profile:GetGUID().."_"..profile:GetDisplayName();

local key_open = 0;
local tpwidth = 240;
local space = 76;
local rsetnum = rival_set_count();
local curIndex = 1;

local rivalset = rival_table(profile_id,profile,"");

local open_rival = OpdName(profile,"index");
local plus_exit = OpdName(profile,"index");
plus_exit[#plus_exit+1] = "Exit";

local fileadd = {};
local countfileadd = {};
--local sys_tt;
--local sys_tt_s;
local sys_tp_s = {};
local sys_tp = {};
local sys_ps = {};
local filecheck = {};
local mtp = {};

for b = 1,#open_rival do
	if plus_exit[b] ~= "MyBest_"..b then
		fileadd[plus_exit[b]] = "CSRealScore/"..open_rival[b].."/0002_dt "..CurGameName();
		--SCREENMAN:SystemMessage(fileadd[plus_exit[b]]);
		countfileadd[plus_exit[b]] = "CSRealScore/"..open_rival[b].."/0002_dt count";
		filecheck[plus_exit[b]] = false;
		if FILEMAN:DoesFileExist( fileadd[plus_exit[b]] ) then
			if FILEMAN:DoesFileExist( countfileadd[plus_exit[b]] ) then
				sys_tp_s[plus_exit[b]] = GetFileParameter(OpenFile(countfileadd[plus_exit[b]]) ,"tp");
			end;
			if sys_tp_s[plus_exit[b]] and sys_tp_s[plus_exit[b]] ~= "" then
				sys_tp[plus_exit[b]] = split(":",sys_tp_s[plus_exit[b]]);
				if FILEMAN:DoesFileExist( countfileadd[plus_exit[b]] ) then
					if GetFileParameter(OpenFile(countfileadd[plus_exit[b]]) ,"ps") ~= "" then
						sys_ps[plus_exit[b]] = split(":",GetFileParameter( OpenFile(countfileadd[plus_exit[b]]) ,"ps"));
					end;
				end;
				filecheck[plus_exit[b]] = true;
			else
				sys_tp_s[plus_exit[b]] = GetFileParameter( OpenFile(fileadd[plus_exit[b]]) ,"tp");
				if sys_tp_s[plus_exit[b]] ~= "" then
					sys_tp[plus_exit[b]] = split(":",sys_tp_s[plus_exit[b]]);
					if GetFileParameter(OpenFile(fileadd[plus_exit[b]]) ,"ps") ~= "" then
						sys_ps[plus_exit[b]] = split(":",GetFileParameter( OpenFile(fileadd[plus_exit[b]]) ,"ps"));
					end;
				end;
				filecheck[plus_exit[b]] = true;
			end;
		end;
	end;
end;

function GetOtherProfiles()
	local t = {};
	for x = 1,#plus_exit do
--[[
		if plus_exit[x] == "MyBest_"..x+1 then
			local bCard = Def.ActorFrame {};
			bCard[#bCard+1]= Def.ActorFrame {
				LoadActor("noback")..{
				};
				LoadFont("_shared2") .. {
					Name = 'Name';
					Text= "MyBest "..FormatNumberAndSuffix(x+1);
					InitCommand=cmd(horizalign,right;maxwidth,250;x,110+6;y,11;zoom,0.8;diffuse,color("0,1,1,1");strokecolor,Color("Black"););
				};
				
				LoadFont("_shared2") .. {
					Name = 'MyBestS2';
					Text= profile:GetDisplayName().." :";
					InitCommand=cmd(horizalign,right;maxwidth,250;x,110+6;y,-10;zoom,0.8;diffuse,Color("White");strokecolor,Color("Black"););
				};
			};
			t[#t+1]=bCard;
		else
]]
			local opdCard = Def.ActorFrame {};
			if x <= #open_rival then
				if filecheck[open_rival[x]] and #sys_tp[open_rival[x]] == 7 then
					mtp[open_rival[x]] = heigest_status(sys_tp[open_rival[x]]);
				end;

				opdCard[#opdCard+1]= Def.ActorFrame {
					LoadActor("opback")..{
					};
					--20161123
					Def.Sprite {
						Name="avatar";
						InitCommand=function(self)
							(cmd(horizalign,left;stoptweening;))(self)
							self:visible(false);
							local s_pid;
							local s_file;
							if open_rival[x] then
								s_pid = open_rival[x];
								s_file = cs_avatar_set({"",s_pid},open_rival,profile,profile_id);
							end;
							if s_pid and FILEMAN:DoesFileExist( s_file ) then
								self:visible(true);
								self:Load(s_file);
								self:scaletofit(-120,0,37,37);
								self:y(-16);
							end;
						end;
					};
					LoadFont("_shared2") .. {
						Name = 'Name';
						Text= string.sub(open_rival[x],18);
						InitCommand=cmd(horizalign,right;maxwidth,130;x,110+6;y,-32;zoom,0.8;strokecolor,Color("Black"););
					};
					
					LoadFont("_shared2") .. {
						Text= sys_ps[open_rival[x]][1] .. " 曲";
						InitCommand=cmd(horizalign,right;maxwidth,130;x,110+6;y,-7;zoom,0.8;strokecolor,Color("Black"););
					};
				
				--[ja] プレイ傾向グラフ
					Def.ActorFrame {
						InitCommand=cmd(x,-128+6;y,31;);
						LoadActor(THEME:GetPathB("ScreenEvaluation","decorations/judgegraph"))..{
							InitCommand=function(self)
								self:zoomtowidth(tpwidth);
								(cmd(horizalign,left;zoomtoheight,5;diffuse,color("0.5,0.5,0.5,1")))(self)
							end;
						};
						LoadActor(THEME:GetPathB("ScreenEvaluation","decorations/judgegraph"))..{
							InitCommand=function(self)
								local cwx = 0;
								self:x( tpwidth * (cwx / sys_tp[open_rival[x]][7]) );
								self:zoomtowidth( tpwidth * (sys_tp[open_rival[x]][1] / sys_tp[open_rival[x]][7]) );
								(cmd(horizalign,left;zoomtoheight,5;diffuse,Colors.Judgment["JudgmentLine_W2"]))(self)
							end;
						};
						LoadActor(THEME:GetPathB("ScreenEvaluation","decorations/judgegraph"))..{
							InitCommand=function(self)
								local cwx = sys_tp[open_rival[x]][1];
								self:x( tpwidth * (cwx / sys_tp[open_rival[x]][7]) );
								self:zoomtowidth( tpwidth * (sys_tp[open_rival[x]][2] / sys_tp[open_rival[x]][7]) );
								(cmd(horizalign,left;zoomtoheight,5;diffuse,Colors.Judgment["JudgmentLine_W1"]))(self)
							end;
						};
						LoadActor(THEME:GetPathB("ScreenEvaluation","decorations/judgegraph"))..{
							InitCommand=function(self)
								local cwx = sys_tp[open_rival[x]][1] + sys_tp[open_rival[x]][2];
								self:x( tpwidth * (cwx / sys_tp[open_rival[x]][7]) );
								self:zoomtowidth( tpwidth * (sys_tp[open_rival[x]][3] / sys_tp[open_rival[x]][7]) );
								(cmd(horizalign,left;zoomtoheight,5;diffuse,Colors.Judgment["JudgmentLine_W3"]))(self)
							end;
						};
						LoadActor(THEME:GetPathB("ScreenEvaluation","decorations/judgegraph"))..{
							InitCommand=function(self)
								local cwx = sys_tp[open_rival[x]][1] + sys_tp[open_rival[x]][2] + sys_tp[open_rival[x]][3];
								self:x( tpwidth * (cwx / sys_tp[open_rival[x]][7]) );
								self:zoomtowidth( tpwidth * (sys_tp[open_rival[x]][4] / sys_tp[open_rival[x]][7]) );
								(cmd(horizalign,left;zoomtoheight,5;diffuse,Colors.Judgment["JudgmentLine_W4"]))(self)
							end;
						};
						LoadActor(THEME:GetPathB("ScreenEvaluation","decorations/judgegraph"))..{
							InitCommand=function(self)
								local cwx = sys_tp[open_rival[x]][1] + sys_tp[open_rival[x]][2] + sys_tp[open_rival[x]][3] + sys_tp[open_rival[x]][4];
								self:x( tpwidth * (cwx / sys_tp[open_rival[x]][7]) );
								self:zoomtowidth( tpwidth * (sys_tp[open_rival[x]][5] / sys_tp[open_rival[x]][7]) );
								(cmd(horizalign,left;zoomtoheight,5;diffuse,Colors.Judgment["JudgmentLine_Miss"]))(self)
							end;
						};
						LoadActor(THEME:GetPathB("ScreenEvaluation","decorations/judgegraph"))..{
							InitCommand=function(self)
								local cwx = sys_tp[open_rival[x]][1] + sys_tp[open_rival[x]][2] + sys_tp[open_rival[x]][3] + sys_tp[open_rival[x]][4] + sys_tp[open_rival[x]][5];
								self:x( tpwidth * (cwx / sys_tp[open_rival[x]][7]) );
								self:zoomtowidth( tpwidth * (sys_tp[open_rival[x]][6] / sys_tp[open_rival[x]][7]) );
								(cmd(horizalign,left;zoomtoheight,5;diffuse,Colors.Judgment["JudgmentLine_W5"]))(self)
							end;
						};
					};
					
				--[ja] プレイ傾向肩書き
					LoadFont("_shared2") .. {
						InitCommand=function(self)
							local set_sc = "";
							if sstext( mmtext(sys_tp[open_rival[x]],mtp[open_rival[x]]),sys_ps[open_rival[x]][1] ) then
								set_sc = THEME:GetString( "ScreenSelectProfile",sstext( mmtext(sys_tp[open_rival[x]],mtp[open_rival[x]]) , sys_ps[open_rival[x]][1] ) );
							end;
							self:settext( mmtext(sys_tp[open_rival[x]],mtp[open_rival[x]])..set_sc );
							(cmd(ztest,true;horizalign,right;maxwidth,210;x,110+6;y,14;zoom,0.8;strokecolor,Color("Black");))(self)
						end;
					};
				};
			else
				opdCard[#opdCard+1]= Def.ActorFrame {
					LoadActor("noback")..{
					};
					LoadFont("Common Normal") .. {
						Text= THEME:GetString("ScreenTitleMenu","Exit");
						InitCommand=cmd(uppercase,true;maxwidth,300;strokecolor,color("0,0,0,1");zoom,1.4;
									diffuse,color("0,1,1,1");strokecolor,ColorDarkTone(color("1,0.5,0,1")););
					};
				};
			end;
			t[#t+1]=opdCard;
		--end;
	end;
	
	return t
end;

local xwideset = WideScale(SCREEN_CENTER_X+180,SCREEN_CENTER_X+210);
t[#t+1] = Def.ActorFrame {
	InitCommand=cmd(visible,true;x,xwideset+50;y,SCREEN_CENTER_Y+8;zoom,1.5;);
	LoadActor("whiteback")..{
		InitCommand=cmd(diffuse,color("1,0.4,0,0.8");fadetop,0.2;fadebottom,0.2;diffuserightedge,color("1,0.4,0,0.3"););
		OnCommand=cmd(cropleft,1;accelerate,0.3;cropleft,0;);
	};
};

for g=1,rsetnum do
	local xset = WideScale(SCREEN_CENTER_X-140,SCREEN_CENTER_X-160);
	local yset = SCREEN_CENTER_Y-116;

	t[#t+1] = Def.ActorFrame {
		InitCommand=cmd(visible,true;x,xset;y,yset+(space*(g-1)););
		SetCommand=function(self)
			self:visible(true);
			if rivalset[g] then self:visible(false);
			end;
		end;
		LoadActor("noback")..{
		};
		LoadFont("Common Normal") .. {
			Text= "Rival "..g;
			InitCommand=cmd(maxwidth,300;strokecolor,color("0,0,0,1");zoom,1.4;);
		};
	};

--[[
	t[#t+1] = Def.ActorFrame {
		InitCommand=cmd(visible,true;x,xset;y,yset+(space*(g-1)););
		SetCommand=function(self)
			self:visible(false);
			if rivalset[g] and string.find(rivalset[g],"^MyBest.*") then
				self:visible(true);
			end;
		end;
		LoadActor("noback")..{
		};
		LoadFont("_shared2") .. {
			Name = 'MyBestS2';
			InitCommand=cmd(horizalign,right;maxwidth,250;x,110+6;y,-10;zoom,0.8;diffuse,Color("White");strokecolor,Color("Black"););
			SetCommand=function(self)
				self:settext("");
				if rivalset[g] and string.find(rivalset[g],"^MyBest.*") then self:settext(profile:GetDisplayName().." :");
				end;
			end;
		};
		LoadFont("_shared2") .. {
			Name = 'MyBestS3';
			InitCommand=cmd(horizalign,right;maxwidth,250;x,110+6;y,11;zoom,0.8;diffuse,color("0,1,1,1");strokecolor,Color("Black"););
			SetCommand=function(self)
				self:settext("");
				if rivalset[g] and string.find(rivalset[g],"^MyBest.*") then
					local mb_s = split("_",rivalset[g]);
					self:settext(mb_s[1].." "..FormatNumberAndSuffix(mb_s[2]));
				end;
			end;
		};
	};
]]
	
	t[#t+1] = Def.ActorFrame {
		InitCommand=cmd(visible,false;x,xset;y,yset+(space*(g-1)););
		SetCommand=function(self)
			self:visible(false);
			if rivalset[g] and not string.find(rivalset[g],"^MyBest.*") then self:visible(true);
			end;
		end;
	
		LoadActor("opback")..{
		};
		--20161123
		Def.Sprite {
			Name="avatar";
			SetCommand=function(self)
				(cmd(horizalign,left;stoptweening;))(self)
				self:visible(false);
				local pid;
				local file;
				if rivalset[g] then
					pid = rivalset[g];
					file = cs_avatar_set({"",pid},rivalset,profile,profile_id);
				end;
				if pid and FILEMAN:DoesFileExist( file ) then
					self:visible(true);
					self:Load(file);
					self:scaletofit(-120,0,37,37);
					self:y(-16);
				end;
			end;
		};
		LoadFont("_shared2") .. {
			Name = 'Name';
			SetCommand=function(self)
				self:visible(false);
				self:settext("");
				if rivalset[g] and not string.find(rivalset[g],"^MyBest.*") then
					self:visible(true);
					self:settext(string.sub(rivalset[g],18));
					(cmd(horizalign,right;maxwidth,130;x,110+6;y,-32;zoom,0.8;strokecolor,Color("Black");))(self)
				end;
			end;
		};
		
		LoadFont("_shared2") .. {
			SetCommand=function(self)
				self:visible(false);
				self:settext("");
				if rivalset[g] and not string.find(rivalset[g],"^MyBest.*") then
					self:visible(true);
					self:settext(sys_ps[rivalset[g]][1] .. " 曲");
					(cmd(horizalign,right;maxwidth,130;x,110+6;y,-7;zoom,0.8;strokecolor,Color("Black");))(self)
				end;
			end;
		};
	
	--[ja] プレイ傾向グラフ
		Def.ActorFrame {
			InitCommand=cmd(x,-128+6;y,31;);
			LoadActor(THEME:GetPathB("ScreenEvaluation","decorations/judgegraph"))..{
				SetCommand=function(self)
					self:visible(false);
					if rivalset[g] and not string.find(rivalset[g],"^MyBest.*") then
						self:visible(true);
						self:zoomtowidth(tpwidth);
						(cmd(horizalign,left;zoomtoheight,5;diffuse,color("0.5,0.5,0.5,1")))(self)
					end;
				end;
			};
			LoadActor(THEME:GetPathB("ScreenEvaluation","decorations/judgegraph"))..{
				SetCommand=function(self)
					self:visible(false);
					if rivalset[g] and not string.find(rivalset[g],"^MyBest.*") then
						self:visible(true);
						local cwx = 0;
						self:x( tpwidth * (cwx / sys_tp[rivalset[g]][7]) );
						self:zoomtowidth( tpwidth * (sys_tp[rivalset[g]][1] / sys_tp[rivalset[g]][7]) );
						--SCREENMAN:SystemMessage(sys_tp[rivalset[g]][1]);
						(cmd(horizalign,left;zoomtoheight,5;diffuse,Colors.Judgment["JudgmentLine_W2"]))(self)
					end;
				end;
			};
			LoadActor(THEME:GetPathB("ScreenEvaluation","decorations/judgegraph"))..{
				SetCommand=function(self)
					self:visible(false);
					if rivalset[g] and not string.find(rivalset[g],"^MyBest.*") then
						self:visible(true);
						local cwx = sys_tp[rivalset[g]][1];
						self:x( tpwidth * (cwx / sys_tp[rivalset[g]][7]) );
						self:zoomtowidth( tpwidth * (sys_tp[rivalset[g]][2] / sys_tp[rivalset[g]][7]) );
						(cmd(horizalign,left;zoomtoheight,5;diffuse,Colors.Judgment["JudgmentLine_W1"]))(self)
					end;
				end;
			};
			LoadActor(THEME:GetPathB("ScreenEvaluation","decorations/judgegraph"))..{
				SetCommand=function(self)
					self:visible(false);
					if rivalset[g] and not string.find(rivalset[g],"^MyBest.*") then
						self:visible(true);
						local cwx = sys_tp[rivalset[g]][1] + sys_tp[rivalset[g]][2];
						self:x( tpwidth * (cwx / sys_tp[rivalset[g]][7]) );
						self:zoomtowidth( tpwidth * (sys_tp[rivalset[g]][3] / sys_tp[rivalset[g]][7]) );
						(cmd(horizalign,left;zoomtoheight,5;diffuse,Colors.Judgment["JudgmentLine_W3"]))(self)
					end;
				end;
			};
			LoadActor(THEME:GetPathB("ScreenEvaluation","decorations/judgegraph"))..{
				SetCommand=function(self)
					self:visible(false);
					if rivalset[g] and not string.find(rivalset[g],"^MyBest.*") then
						self:visible(true);
						local cwx = sys_tp[rivalset[g]][1] + sys_tp[rivalset[g]][2] + sys_tp[rivalset[g]][3];
						self:x( tpwidth * (cwx / sys_tp[rivalset[g]][7]) );
						self:zoomtowidth( tpwidth * (sys_tp[rivalset[g]][4] / sys_tp[rivalset[g]][7]) );
						(cmd(horizalign,left;zoomtoheight,5;diffuse,Colors.Judgment["JudgmentLine_W4"]))(self)
					end;
				end;
			};
			LoadActor(THEME:GetPathB("ScreenEvaluation","decorations/judgegraph"))..{
				SetCommand=function(self)
					self:visible(false);
					if rivalset[g] and not string.find(rivalset[g],"^MyBest.*") then
						self:visible(true);
						local cwx = sys_tp[rivalset[g]][1] + sys_tp[rivalset[g]][2] + sys_tp[rivalset[g]][3] + sys_tp[rivalset[g]][4];
						self:x( tpwidth * (cwx / sys_tp[rivalset[g]][7]) );
						self:zoomtowidth( tpwidth * (sys_tp[rivalset[g]][5] / sys_tp[rivalset[g]][7]) );
						(cmd(horizalign,left;zoomtoheight,5;diffuse,Colors.Judgment["JudgmentLine_Miss"]))(self)
					end;
				end;
			};
			LoadActor(THEME:GetPathB("ScreenEvaluation","decorations/judgegraph"))..{
				SetCommand=function(self)
					self:visible(false);
					if rivalset[g] and not string.find(rivalset[g],"^MyBest.*") then
						self:visible(true);
						local cwx = sys_tp[rivalset[g]][1] + sys_tp[rivalset[g]][2] + sys_tp[rivalset[g]][3] + sys_tp[rivalset[g]][4] + sys_tp[rivalset[g]][5];
						self:x( tpwidth * (cwx / sys_tp[rivalset[g]][7]) );
						self:zoomtowidth( tpwidth * (sys_tp[rivalset[g]][6] / sys_tp[rivalset[g]][7]) );
						(cmd(horizalign,left;zoomtoheight,5;diffuse,Colors.Judgment["JudgmentLine_W5"]))(self)
					end;
				end;
			};
		};
		
	--[ja] プレイ傾向肩書き
		LoadFont("_shared2") .. {
			SetCommand=function(self)
				self:visible(false);
				if rivalset[g] and not string.find(rivalset[g],"^MyBest.*") then
					self:visible(true);
					local set_sc = "";
					if sstext( mmtext(sys_tp[rivalset[g]],mtp[rivalset[g]]),sys_ps[rivalset[g]][1] ) then
						set_sc = THEME:GetString( "ScreenSelectProfile",sstext( mmtext(sys_tp[rivalset[g]],mtp[rivalset[g]]),sys_ps[rivalset[g]][1] ) );
					end;
					self:settext( mmtext(sys_tp[rivalset[g]],mtp[rivalset[g]])..set_sc );
					(cmd(ztest,true;horizalign,right;maxwidth,210;x,110+6;y,14;zoom,0.8;strokecolor,Color("Black");))(self)
				end;
			end;
		};
	};
end;

t[#t+1] = Def.ActorFrame {
	InitCommand=cmd(x,xwideset;);
	Def.Quad{
		Name="TopMask";
		InitCommand=cmd(x,-2;y,SCREEN_TOP+64;zoomto,320,160;valign,1;clearzbuffer,true;zwrite,true;blend,Blend.NoEffect;);
	};

	Def.Quad{
		Name="BottomMask";
		InitCommand=cmd(x,-2;y,SCREEN_BOTTOM-44;zoomto,320,160;valign,0;clearzbuffer,false;zwrite,true;blend,Blend.NoEffect;);
	};

	Def.ActorScroller{
		Name = 'Scroller';
		NumItemsToDraw=10;
		InitCommand=function(self)
			self:clearzbuffer(true);
			self:zwrite(true);
			self:zbuffer(true);
			self:ztest(true);
			self:z(0);
			(cmd(y,SCREEN_CENTER_Y+88;SetFastCatchup,true;SetSecondsPerItem,0.15;SetDestinationItem,curIndex;))(self)
		end;
		TransformFunction=function(self, offset, itemIndex, numItems)
			self:visible(false);
			self:x(0);
			self:y(math.floor( offset*space ));
		end;
		DirectionButtonMessageCommand = function(self, params)
			self:SetDestinationItem( curIndex );
		end;
		children = GetOtherProfiles();
	};
};

--20160417
function inputs(event)
	local button = event.GameButton
	if key_open == 0 then
		if event.type ~= "InputEventType_Release" then
			if button == 'MenuLeft' or button == 'MenuUp' then
				if curIndex > 1 then
					curIndex = curIndex - 1;
					SOUND:PlayOnce(THEME:GetPathS("_common","row"));
					MESSAGEMAN:Broadcast("DirectionButton");
					MESSAGEMAN:Broadcast("Previous");
				end;
			end;
			if button == 'MenuRight' or button == 'MenuDown' then
				if curIndex < #plus_exit then
					if curIndex > 0 then
						curIndex = curIndex + 1;
						SOUND:PlayOnce(THEME:GetPathS("_common","row"));
						MESSAGEMAN:Broadcast("DirectionButton");
						MESSAGEMAN:Broadcast("Next");
					end;
				end;
			end;
		end;
		if event.type == "InputEventType_FirstPress" then
			if button == 'Start' or button == 'Center' then
				if (#rivalset <= rsetnum) and (curIndex < #plus_exit) then
					local set = 0;
					if #rivalset == 0 then
						rivalset[#rivalset+1] = open_rival[curIndex];
						SOUND:PlayOnce(THEME:GetPathS("MusicWheel","expand"));
						MESSAGEMAN:Broadcast("ExpandButton");
					else
						for k=1,#rivalset do
							if rivalset[k] == open_rival[curIndex] then
								set = 1;
								table.remove(rivalset,k);
								SOUND:PlayOnce(THEME:GetPathS("MusicWheel","expand"));
								MESSAGEMAN:Broadcast("ExpandButton");
								break;
							end;
						end;
						if set == 0 and #rivalset < rsetnum then
							rivalset[#rivalset+1] = open_rival[curIndex];
							SOUND:PlayOnce(THEME:GetPathS("MusicWheel","expand"));
							MESSAGEMAN:Broadcast("ExpandButton");
						end;
					end;
				elseif #rivalset + 1 == rsetnum + 1 then
				end;
				if curIndex == #plus_exit then
					key_open = 1;
					MESSAGEMAN:Broadcast("StartButton");
					SOUND:PlayOnce(THEME:GetPathS("Common","start"));
					SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToNextScreen");
					SetAdhocPref("RivalSet",table.concat(rivalset,"||"),profile_id);
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

local function cursorset(self,n,i)
	if n == "Up" then
		self:visible(true);
		if i <= 1 then
			self:visible(false);
		end;
	else
		self:visible(true);
		if i >= #plus_exit then
			self:visible(false);
		end;
	end;
	return self;
end;

t[#t+1] = Def.ActorFrame {
	InitCommand=function(self)
		self:x(SCREEN_CENTER_X+WideScale(80,110));
		self:y(SCREEN_CENTER_Y);
	end;
	Def.ActorFrame{
		InitCommand=function(self) cursorset(self,"Up",curIndex); end;
		DirectionButtonMessageCommand=function(self) cursorset(self,"Up",curIndex); end;
		PreviousMessageCommand=cmd(stoptweening;glow,color("1,1,0,1");y,12;decelerate,0.25;glow,color("0,0,0,0");y,0;);
	
		LoadActor( THEME:GetPathB("","arrow") )..{
			OnCommand=cmd(y,-60;rotationz,270;diffusealpha,0;sleep,0.3;queuecommand,"Repeat";);
			RepeatCommand=cmd(addy,16;diffusealpha,1;glow,color("1,0.7,0,1");linear,0.8;glow,color("0,0,0,0");addy,-16;diffusealpha,0;sleep,0.2;queuecommand,"Repeat";);
			OffCommand=cmd(stoptweening;);
		};
	};
	Def.ActorFrame{
		InitCommand=function(self) cursorset(self,"Down",curIndex); end;
		DirectionButtonMessageCommand=function(self) cursorset(self,"Down",curIndex); end;
		NextMessageCommand=cmd(stoptweening;glow,color("1,1,0,1");y,-12;decelerate,0.25;glow,color("0,0,0,0");y,0;);
	
		LoadActor( THEME:GetPathB("","arrow") )..{
			OnCommand=cmd(y,60;rotationz,90;diffusealpha,0;sleep,0.3;queuecommand,"Repeat";);
			RepeatCommand=cmd(addy,-16;diffusealpha,1;glow,color("1,0.7,0,1");linear,0.8;glow,color("0,0,0,0");addy,16;diffusealpha,0;sleep,0.2;queuecommand,"Repeat";);
			OffCommand=cmd(stoptweening;);
		};
	};
};

t.OnCommand=cmd(stoptweening;playcommand,"Set");
t.ExpandButtonMessageCommand=function(self)
	if key_open == 0 then
		self:playcommand("Set");
	end;
end;
--[[
	t.OffCommand=function(self)
		SetAdhocPref("RivalSet",table.concat(rivalset,"||"),profile_id);
	end;
]]

t[#t+1]=LoadFont("_shared2") .. {
	InitCommand=function(self)
		self:settext( profile:GetDisplayName() );
		(cmd(horizalign,left;x,SCREEN_LEFT+60;y,SCREEN_TOP+70;maxwidth,250;zoom,0.9;strokecolor,Color("Black");))(self)
	end;
};
--[[
for zx = 1,#open_rival do
	t[#t+1]=LoadFont("Common Normal") .. {
		InitCommand=function(self)
			self:settext( open_rival[zx] );
			(cmd(strokecolor,color("0,0,0,1");x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y+(20*(zx-1))))(self)
		end;
	};
end;
]]	

return t;
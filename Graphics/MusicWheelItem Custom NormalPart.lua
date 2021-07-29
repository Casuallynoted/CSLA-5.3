--20180208 favorite
--local limit = getenv("Timer") + 1;
setenv("csflag",0);
local ac = 1;
local drawindex = 0;
local favorite_s_jacket = THEME:GetPathG("","_MusicWheelItem parts/favorite_jacket");
local csctext = THEME:GetString("MusicWheel","CustomItemCSCText");
local randomtext = THEME:GetString("MusicWheel","CustomItemRandomText");
local pstr = ProfIDSet(csort_pset());
local csccolor = THEME:GetMetric("MusicWheel","CSCColor");
local randomcolor = THEME:GetMetric("MusicWheel","RandomColor");
local set;

local t = Def.ActorFrame{};

t[#t+1] = Def.ActorFrame {
	OnCommand=function(self)
		if THEME:GetMetric( Var "LoadingScreen","ScreenType") == 0 then
			(cmd(linear,0.4;playcommand,"Flag"))(self)
		else (cmd(playcommand,"Flag"))(self)
		end;
	end;
	FlagCommand=function(self) ac = 0;
	end;
	SetMessageCommand=function(self, params)
		local items = THEME:GetMetric( "MusicWheel","NumWheelItems" ) + 2;
		drawindex = params.DrawIndex;
		incommandset(self,ac,items,drawindex);
		if params.Label == csctext then set = "csc";
		elseif params.Label == randomtext then set = "random";
		elseif string.find(params.Label,"^Favorite.*") then set = "favorite";
		end;
	end;
	LoadActor(THEME:GetPathG("_MusicWheelItem","parts/section_back"))..{
		InitCommand=cmd(y,10;shadowlengthy,4;diffuse,color("0.5,0.5,0.5,1");diffusetopedge,color("0.5,0.5,0.5,1");
					diffusebottomedge,color("0.5,0.5,0.5,0.8"););
		SetMessageCommand=function(self,params)
			if params.Label then
				if set == "csc" then
					(cmd(diffuse,color("0,1,0.8,1");diffusetopedge,color("0,1,0.8,1");
					diffusebottomedge,color("0.5,0.5,0.5,0.8")))(self);
				elseif set == "random" then
					(cmd(diffuse,color("1,0.1,0.4,1");diffusetopedge,color("1,0.1,0.4,1");
					diffusebottomedge,color("0.5,0.5,0.5,0.8")))(self);
				elseif set == "favorite" and tonumber(string.sub(params.Label,-1)) then
					(cmd(diffuse,BoostColor(f_color_set[tonumber(string.sub(params.Label,-1))],2);
					diffusetopedge,f_color_set[tonumber(string.sub(params.Label,-1))];
					diffusebottomedge,color("0.5,0.5,0.5,0.8")))(self);
				end;
			end;
		end;
		SectionSetRMessageCommand=cmd(stoptweening;y,2;zoomy,0;decelerate,0.1;y,10;zoomy,1;);
	};

	Def.Sprite {
		InitCommand=cmd(y,100;rotationy,180;rotationz,180;diffuse,color("0.4,0.4,0.4,0.7");
					diffusetopedge,color("0,0,0,0");diffusebottomedge,color("0.4,0.4,0.4,0.7"););
		SetMessageCommand=function(self,params)
			self:diffuse(color("0.4,0.4,0.4,0.7"));
			local screen = SCREENMAN:GetTopScreen();
			if screen then
				local musicwheel = screen:GetChild('MusicWheel');
				self:visible(false);
				if params.Label then
					if set then
						local image_set;
						if set == "favorite" and tonumber(string.sub(params.Label,-1)) then
							for i=1,#extension do
								image_set = prof_custom_imagedir(pstr,"CS_Favorite/_",params.Label,extension[i],favorite_s_jacket);
								if image_set then break;
								end;
							end;
							if image_set == favorite_s_jacket then
								self:diffuse(f_color_set[tonumber(string.sub(params.Label,-1))]);
							end;
							self:diffusealpha(0.7);
						end;
						if not image_set then
							image_set = THEME:GetPathG("_MusicWheelItem","parts/"..set.."_jacket");
						end;
						self:visible(true);
						self:Load(image_set);
						(cmd(zoomto,174,174*0.3;))(self)
					end;
				end;
			end;
		end;
	};

	Def.Sprite {
		SetMessageCommand=function(self,params)
			self:diffuse(Color("White"));
			local screen = SCREENMAN:GetTopScreen();
			if screen then
				local musicwheel = screen:GetChild('MusicWheel');
				self:visible(false);
				if params.Label then
					if set then
						local image_set;
						if set == "favorite" and tonumber(string.sub(params.Label,-1)) then
							for i=1,#extension do
								image_set = prof_custom_imagedir(pstr,"CS_Favorite/_",params.Label,extension[i],favorite_s_jacket);
								if image_set then break;
								end;
							end;
							if image_set == favorite_s_jacket then
								self:diffuse(BoostColor(f_color_set[tonumber(string.sub(params.Label,-1))],0.75));
							end;
						end;
						if not image_set then
							image_set = THEME:GetPathG("_MusicWheelItem","parts/"..set.."_jacket");
						end;
						self:visible(true);
						self:Load(image_set);
						self:scaletofit(-87,-87,87,87);
					end;
				end;
			end;
		end;
		SectionSetRMessageCommand=cmd(stoptweening;croptop,1;linear,0.1;croptop,0;);
	};

	LoadActor(THEME:GetPathG("_MusicWheelItem","parts/que"))..{
		InitCommand=cmd(zoomto,160,28;fadeleft,0.15;faderight,0.15;texcoordvelocity,-0.25,0;diffuse,color("1,0.1,0.4,1"));
		SetMessageCommand=function(self,params)
			self:visible(false);
			if set == "random" then
				self:visible(true);
			end;
		end;
	};
	
	Def.ActorFrame {
		InitCommand=cmd(x,48;y,-52;);
		SetMessageCommand=function(self,params)
			self:visible(false);
			if set == "favorite" then
				self:visible(true);
			end;
		end;
		LoadActor( THEME:GetPathG("","star") )..{
			InitCommand=cmd(shadowlength,3;zoom,1.25;);
			SetMessageCommand=function(self,params)
				if tonumber(string.sub(params.Label,-1)) then
					self:diffuse(f_color_set[tonumber(string.sub(params.Label,-1))]);
				end;
			end;
		};
		LoadFont("Common Normal") .. {
			InitCommand=cmd(x,14;y,6;settext,"";diffuse,Color("White");strokecolor,color("0,0,0,1");shadowlength,4;zoom,1.25;);
			SetMessageCommand=function(self,params)
				if params.Label then
					self:settext(string.sub(params.Label,-1));
				end;
			end;
		};
	};
	
	LoadFont("_shared2")..{
		InitCommand=cmd(zoomy,0.9;maxwidth,156;y,100;shadowlength,0;diffuse,color("1,1,0.1,1");strokecolor,Color("Black"););
		SetMessageCommand=function(self,params)
			self:visible(true);
			if params.Label then
				self:settext(params.Label);
				if set == "csc" then self:diffuse(csccolor);
				elseif set == "random" then self:diffuse(randomcolor);
				elseif set == "favorite" and tonumber(string.sub(params.Label,-1)) then
					self:diffuse(f_color_set[tonumber(string.sub(params.Label,-1))]);
				end;
				if params.HasFocus then
					local screen = SCREENMAN:GetTopScreen();
					if screen then
						local musicwheel = screen:GetChild('MusicWheel');
						if musicwheel then
							if musicwheel:GetSelectedType() == 'WheelItemDataType_Custom' then
								if params.Label == csctext and not IsNetConnected() then
									setenv("wheelsectioncsc",csctext);
								elseif params.Label == randomtext and not IsNetConnected() then
									setenv("wheelsectioncsc",randomtext);
								elseif string.find(params.Label,"^Favorite.*") and tonumber(string.sub(params.Label,-1)) then
									setenv("wheelsectioncsc",
									THEME:GetString("MusicWheel","CustomItemFavorite"..string.sub(params.Label,-1).."Text"));
								end;
							else
								setenv("wheelsectioncsc","");
							end;
						end;
					end;
				end;
			end;
		end;
	};
};

return t;
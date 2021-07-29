local t = Def.ActorFrame{};

local profile= GAMESTATE:GetEditLocalProfile();
local profile_id= GAMESTATE:GetEditLocalProfileID();

local position = SCREEN_RIGHT-WideScale(30,80);
local coverpos = 340;
local coverset = 0;
local coverhidden = 0;
local setcount = 4;
local jtransform = SCREEN_CENTER_Y+30;

local cc = ProfIDPrefCheck("CCover",profile_id,"Off");
local cco = ProfIDPrefCheck("CCoverStr",profile_id,"_blank");

--hid
t[#t+1] = Def.ActorFrame{
	InitCommand=function(self)
		self:x(position-(ColumnChecker("nil")/2));
		self:horizalign(right);
		self:y(jtransform);
		self:playcommand("Set");
	end;
	SetCommand=function(self)
		self:y(jtransform);
	end;
	DirectionButtonMessageCommand=function(self,param)
		self:playcommand("Set");
		self:x(position-(ColumnChecker(param.Style)/2));
	end;

	Def.ActorFrame{
		InitCommand=function(self)
			self:visible(true);
			self:rotationx(180);
			self:vertalign(top);
			self:playcommand("Set");
		end;
		OnCommand=cmd(y,-SCREEN_HEIGHT+tonumber(coverpos)-400;decelerate,0.25;y,-SCREEN_HEIGHT+tonumber(coverpos)-200;);
		SetCommand=function(self)
			self:stoptweening();
			self:visible(true);
		end;
		DirectionButtonMessageCommand=function(self,params)
			self:playcommand("Set");
		end;
		Def.Quad{
			InitCommand=function(self)
				self:x(0.5);
				self:y(480);
				self:zoomtowidth(ColumnChecker("nil")+20);
				self:zoomtoheight(480);
				self:diffuse(color("0,0,0,1"));
			end;
			DirectionButtonMessageCommand=function(self,param)
				self:zoomtowidth(ColumnChecker(param.Style)+20);
			end;
		};
		LoadActor(THEME:GetPathG("Player","judgment/HSCover/cover_center_width"))..{
			InitCommand=function(self)
				self:x(0);
				self:zoomtowidth(ColumnChecker("nil"));
			end;
			DirectionButtonMessageCommand=function(self,param)
				self:zoomtowidth(ColumnChecker(param.Style));
			end;
		};
		Def.ActorFrame{
			InitCommand=function(self)
				self:horizalign(right);
			end;
			LoadActor(THEME:GetPathG("Player","judgment/HSCover/cover_side"))..{
				InitCommand=function(self)
					self:x(-(ColumnChecker("nil")/2)-4+1-2);
				end;
				DirectionButtonMessageCommand=function(self,param)
					self:x(-(ColumnChecker(param.Style)/2)-4+1-2);
				end;
			};
			LoadActor(THEME:GetPathG("Player","judgment/HSCover/cover_center_main"))..{
				InitCommand=function(self)
					self:horizalign(left);
					self:x(-(ColumnChecker("nil")/2)+1-2);
				end;
				DirectionButtonMessageCommand=function(self,param)
					self:x(-(ColumnChecker(param.Style)/2)+1-2);
				end;
			};
		};
		Def.ActorFrame{
			InitCommand=function(self)
				self:horizalign(left);
			end;
			LoadActor(THEME:GetPathG("Player","judgment/HSCover/cover_side"))..{
				InitCommand=function(self)
					self:rotationy(180);
					self:x((ColumnChecker("nil")/2)+4+2);
				end;
				DirectionButtonMessageCommand=function(self,param)
					self:x((ColumnChecker(param.Style)/2)+4+2);
				end;
			};
			LoadActor(THEME:GetPathG("Player","judgment/HSCover/cover_center_main"))..{
				InitCommand=function(self)
					self:rotationy(180);
					self:horizalign(left);
					self:x((ColumnChecker("nil")/2)+2);
				end;
				DirectionButtonMessageCommand=function(self,param)
					self:x((ColumnChecker(param.Style)/2)+2);
				end;
			};
		};
		Def.Sprite{
			InitCommand=function(self)
				coverseta(self,"nil",cc,cco);
			end;
			DirectionButtonMessageCommand=function(self,param)
				coverseta(self,param,cc,cco);
			end;
		};
		Def.Sprite{
			InitCommand=function(self)
				coversetb(self,"nil",cc,cco);
			end;
			DirectionButtonMessageCommand=function(self,param)
				coversetb(self,param,cc,cco);
			end;
		};
	};
	--sud
	Def.ActorFrame{
		InitCommand=function(self)
			self:visible(true);
			self:vertalign(bottom);
			self:playcommand("Set");
		end;
		OnCommand=cmd(y,SCREEN_HEIGHT-tonumber(coverpos)+200;decelerate,0.25;y,SCREEN_HEIGHT-tonumber(coverpos););
		SetCommand=function(self)
			self:stoptweening();
			self:visible(true);
		end;
		DirectionButtonMessageCommand=function(self,params)
			self:playcommand("Set");
		end;

		Def.Quad{
			InitCommand=function(self)
				self:x(0.5);
				self:y(480);
				self:zoomtowidth(ColumnChecker("nil")+20);
				self:zoomtoheight(480);
				self:diffuse(color("0,0,0,1"));
			end;
			DirectionButtonMessageCommand=function(self,param)
				self:zoomtowidth(ColumnChecker(param.Style)+20);
			end;
		};
		LoadActor(THEME:GetPathG("Player","judgment/HSCover/cover_center_width"))..{
			InitCommand=function(self)
				self:x(0);
				self:zoomtowidth(ColumnChecker("nil"));
			end;
			DirectionButtonMessageCommand=function(self,param)
				self:zoomtowidth(ColumnChecker(param.Style));
			end;
		};
		Def.ActorFrame{
			InitCommand=function(self)
				self:horizalign(right);
			end;
			LoadActor(THEME:GetPathG("Player","judgment/HSCover/cover_side"))..{
				InitCommand=function(self)
					self:x(-(ColumnChecker("nil")/2)-4+1-2);
				end;
				DirectionButtonMessageCommand=function(self,param)
					self:x(-(ColumnChecker(param.Style)/2)-4+1-2);
				end;
			};
			LoadActor(THEME:GetPathG("Player","judgment/HSCover/cover_center_main"))..{
				InitCommand=function(self)
					self:horizalign(left);
					self:x(-(ColumnChecker("nil")/2)+1-2);
				end;
				DirectionButtonMessageCommand=function(self,param)
					self:x(-(ColumnChecker(param.Style)/2)+1-2);
				end;
			};
		};
		Def.ActorFrame{
			InitCommand=function(self)
				self:horizalign(left);
			end;
			LoadActor(THEME:GetPathG("Player","judgment/HSCover/cover_side"))..{
				InitCommand=function(self)
					self:rotationy(180);
					self:x((ColumnChecker("nil")/2)+4+2);
				end;
				DirectionButtonMessageCommand=function(self,param)
					self:x((ColumnChecker(param.Style)/2)+4+2);
				end;
			};
			LoadActor(THEME:GetPathG("Player","judgment/HSCover/cover_center_main"))..{
				InitCommand=function(self)
					self:rotationy(180);
					self:horizalign(left);
					self:x((ColumnChecker("nil")/2)+2);
				end;
				DirectionButtonMessageCommand=function(self,param)
					self:x((ColumnChecker(param.Style)/2)+2);
				end;
			};
		};
		Def.Sprite{
			InitCommand=function(self)
				coverseta(self,"nil",cc,cco);
			end;
			DirectionButtonMessageCommand=function(self,param)
				coverseta(self,param,cc,cco);
			end;
		};
		Def.Sprite{
			InitCommand=function(self)
				coversetb(self,"nil",cc,cco);
			end;
			DirectionButtonMessageCommand=function(self,param)
				coversetb(self,param,cc,cco);
			end;
		};
	};
};
--[[
	t[#t+1] = LoadFont("Common Normal") .. {
		Text= asety[2];
		InitCommand=function(self)
			(cmd(horizalign,left;x,82;y,100;zoom,0.8;))(self)
			self:diffuse(Color("White"));
			self:strokecolor(Color("Black"));
		end;
		DirectionButtonMessageCommand=function(self,param)
			self:settext(asety[2]);
		end;
	};
]]
return t;
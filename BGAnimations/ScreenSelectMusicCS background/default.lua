--[[ScreenSelectMusicCS background]]

local ssStats = STATSMAN:GetPlayedStageStats(1);
local group;
if ssStats then
	group = ssStats:GetPlayedSongs()[1]:GetGroupName();
else group = "Beginner's Package";
end;

local t = Def.ActorFrame{};

t[#t+1] = Def.ActorFrame{
	Def.Quad {
		InitCommand=cmd(FullScreen;diffuse,color("0,1,1,0.5");diffuserightedge,color("0,1,1,0"););
	};
};

local bg = GetGroupParameter(group,"Extra1BackGround");
local fn = "";
if bg ~= "" then
	fn = split("%.",bg);
end;
if bg~="" then
	if group == "FIXED Project 5 -waiei Extended-" then
		t[#t+1] = Def.ActorFrame{
			InitCommand=cmd(fov,100;);
			OnCommand=cmd(zoom,1.5;sleep,0.2;decelerate,0.5;zoom,1;);
			Def.Quad{
				Name="TopMask";
				InitCommand=function(self)
					self:MaskSource();
					(cmd(vertalign,bottom;x,SCREEN_WIDTH*0.5;y,SCREEN_CENTER_Y-WideScale(38,20);
					zoomto,SCREEN_WIDTH*2,SCREEN_HEIGHT/3;rotationx,200;rotationy,-130;rotationz,-150;))(self)
				end;
			};
			Def.Quad{
				Name="BottomMask";
				InitCommand=function(self)
					self:MaskSource();
					(cmd(vertalign,top;x,SCREEN_WIDTH*0.5;y,SCREEN_CENTER_Y+WideScale(90,109);
					zoomto,SCREEN_WIDTH*2,SCREEN_HEIGHT/3;rotationx,200;rotationy,-130;rotationz,-150;))(self)
				end;
			};
			Def.Quad{
				Name="LeftMask";
				InitCommand=function(self)
					self:MaskSource();
					(cmd(horizalign,left;x,SCREEN_WIDTH*0.5-42;y,SCREEN_CENTER_Y;
					zoomto,SCREEN_WIDTH,SCREEN_HEIGHT*2;rotationx,200;rotationy,-130;rotationz,-150;))(self)
				end;
			};
			Def.Quad{
				Name="RightMask";
				InitCommand=function(self)
					self:MaskSource();
					(cmd(horizalign,right;x,SCREEN_WIDTH*0.5-500;y,SCREEN_CENTER_Y;
					zoomto,SCREEN_WIDTH,SCREEN_HEIGHT*2;rotationx,200;rotationy,-130;rotationz,-150;))(self)
				end;
			};
		};
	end;
	if FILEMAN:DoesFileExist("/Songs/"..group.."/"..bg)  then
		t[#t+1] = Def.ActorFrame{
			InitCommand=cmd(fov,100;);
			LoadActor("/Songs/"..group.."/"..bg) .. {
				InitCommand=function(self)
					self:MaskDest();
					if string.lower(fn[#fn])~="lua" then
						(cmd(x,SCREEN_WIDTH*0.5;y,SCREEN_CENTER_Y;rotationx,200;rotationy,-130;rotationz,-150;
						diffusealpha,0.9;diffuserightedge,color("0.9,0.9,0.9,0")))(self)
					else
						(cmd(rotationx,200;rotationy,-130;rotationz,-150;
						diffusealpha,0.9;diffuserightedge,color("0.9,0.9,0.9,0")))(self)
					end;
				end;
				OnCommand=cmd(zoom,1.5;sleep,0.2;decelerate,0.5;zoom,0.75;);
			};
		};
	elseif FILEMAN:DoesFileExist("/AdditionalSongs/"..group.."/"..bg)  then
		t[#t+1] = Def.ActorFrame{
			InitCommand=cmd(fov,100;);
			LoadActor("/AdditionalSongs/"..group.."/"..bg) .. {
				InitCommand=function(self)
					self:MaskDest();
					if string.lower(fn[#fn])~="lua" then
						(cmd(x,SCREEN_WIDTH*0.5;y,SCREEN_CENTER_Y;rotationx,200;rotationy,-130;rotationz,-150;
						diffusealpha,0.9;diffuserightedge,color("0.9,0.9,0.9,0")))(self)
					else
						(cmd(rotationx,200;rotationy,-130;rotationz,-150;
						diffusealpha,0.9;diffuserightedge,color("0.9,0.9,0.9,0")))(self)
					end;
				end;
				OnCommand=cmd(zoom,1.5;sleep,0.2;decelerate,0.5;zoom,0.75;);
			};
		};
	end;
end;

t[#t+1] = Def.ActorFrame{
	InitCommand=cmd(fov,100;x,SCREEN_CENTER_X+300;y,SCREEN_CENTER_Y;rotationx,-10;rotationy,-10;rotationz,10;);
	OnCommand=cmd(zoom,1.5;decelerate,0.5;zoom,1;);
	LoadActor("cs_o")..{
		InitCommand=function(self)
			(cmd(fadeleft,0.2;faderight,0.2;diffuseshift;effectcolor1,color("0,0.3,0.4,0.8");effectcolor2,color("0,0.8,0.9,0.8");effectperiod,12))(self)
		end;
	};
};

t[#t+1] = Def.ActorFrame{
	LoadActor("11")..{
		InitCommand=cmd(x,SCREEN_RIGHT-50;CenterY;diffusealpha,0.7;zoomto,14,SCREEN_HEIGHT;customtexturerect,0,0,1,SCREEN_HEIGHT/self:GetHeight());
		OnCommand=cmd(texcoordvelocity,0,0.05;);
	};

	LoadActor("12")..{
		InitCommand=cmd(x,SCREEN_RIGHT-56;CenterY;diffusealpha,0.5;zoomto,14,SCREEN_HEIGHT;customtexturerect,0,0,1,SCREEN_HEIGHT/self:GetHeight());
		OnCommand=cmd(texcoordvelocity,0,0.2;);
	};

	LoadActor("13")..{
		InitCommand=cmd(x,SCREEN_RIGHT-30;CenterY;diffusealpha,0.8;zoomto,14,SCREEN_HEIGHT;customtexturerect,0,0,1,SCREEN_HEIGHT/self:GetHeight());
		OnCommand=cmd(texcoordvelocity,0,-0.15;);
	};
};

if bUse3dModels() == 'On' then
	t[#t+1] = Def.ActorFrame{
		Def.ActorFrame{
			InitCommand=cmd(fov,100;x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y+50;rotationy,-30;);
			OnCommand=cmd(zoom,3;decelerate,0.75;zoom,2.5;rotationx,0;rotationz,40;rotationy,30;);
			
			LoadActor( THEME:GetPathB("_shared","models/_08_line") )..{
				InitCommand=function(self)
					self:ztest(true);
					self:ztestmode("ZTestMode_Off");
					(cmd(zwrite,false;diffuse,color("0,1,1,0.5");queuecommand,"Repeat";))(self)
				end;
				RepeatCommand=cmd(spin;effectmagnitude,0,13,-2;);
			};
		};
	};
end;

t[#t+1] = LoadActor( THEME:GetPathB("","underlay") )..{
};



return t;
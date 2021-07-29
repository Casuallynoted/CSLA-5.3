local t = Def.ActorFrame{};
--[ja] 20150815修正

local key_open = 0;
local icon_set_table = {"Yes","No"};
local selection = icon_set_table[2];
local sflag = icon_set_table[1];
local x_set = SCREEN_CENTER_X+100;
local function icon_set(icon,selection)
	return Def.ActorFrame{
		Name="icon_"..icon;
		InitCommand=function(self)
			self:y(34);
			if icon == icon_set_table[1] then
				x_set = SCREEN_CENTER_X-100;
			else x_set = SCREEN_CENTER_X+100;
			end;
			self:x(x_set);
		end;
		LoadActor("cursor_high")..{
			InitCommand=cmd(blend,'BlendMode_Add';diffuseshift;effectcolor1,color("1,0.5,0,0.5");effectcolor2,color("1,1,0,1");effectperiod,2.5;);
			GainFocusCommand=cmd(diffusealpha,1;);
			LoseFocusCommand=cmd(diffusealpha,0;);
			OnCommand=function(self)
				if selection == icon then
					(cmd(diffusealpha,0;decelerate,0.3;diffusealpha,1;))(self)
				else self:diffusealpha(0);
				end;
			end;
			OffCommand=cmd(finishtweening;diffusealpha,0;);
		};
		
		LoadActor("cursor_back")..{
			InitCommand=cmd(diffuse,color("0,0,0,0.75"););
			GainFocusCommand=cmd(diffuse,color("0.7,0.5,0,0.75"););
			LoseFocusCommand=cmd(diffuse,color("0,0,0,0.75"););
			OnCommand=function(self)
				if selection == icon then
					(cmd(diffusealpha,0;decelerate,0.3;diffuse,color("0.7,0.5,0,0.75");))(self)
				else (cmd(diffusealpha,0;decelerate,0.3;diffuse,color("0,0,0,0.75");))(self)
				end;
			end;
			OffCommand=cmd(finishtweening;diffusealpha,0;);
		};

		LoadFont("_Shared2")..{
			InitCommand=cmd(zoom,0.9;diffuse,color("0.75,0.35,0,1");strokecolor,Color("Black");
						settext,THEME:GetString("MusicWheel",icon.."Text"););
			GainFocusCommand=cmd(diffuse,color("0,1,1,1"););
			LoseFocusCommand=cmd(diffuse,color("1,0.5,0,1"););
			OnCommand=function(self)
				if selection == icon then
					(cmd(diffusealpha,0;decelerate,0.3;diffuse,color("0,1,1,1");))(self)
				else (cmd(diffusealpha,0;decelerate,0.3;diffuse,color("1,0.5,0,1");))(self)
				end;
			end;
			OffCommand=cmd(finishtweening;diffusealpha,0;);
		};
	};
end;

t[#t+1] =Def.ActorFrame{
	InitCommand=cmd(y,SCREEN_CENTER_Y+120;);
	OnCommand=function(self)
		SOUND:PlayOnce(THEME:GetPathS("","_swoosh"));
		SCREENMAN:GetTopScreen():AddInputCallback(inputs);
	end;
	LimitCommand=function(self)
		key_open = 4;
		self:playcommand("Off");
		SCREENMAN:GetTopScreen():PostScreenMessage('SM_GoToPrevScreen',1);
	end;
	CCancelMessageCommand=function(self)
		self:playcommand("Off");
	end;
	Def.Quad{
		InitCommand=cmd(CenterX;diffuse,color("0,0,0,1");diffusebottomedge,color("0,0.5,0.5,1");diffusealpha,0;zoomtowidth,SCREEN_WIDTH;zoomtoheight,0;);
		OnCommand=cmd(zoomtoheight,0;accelerate,0.2;zoomtoheight,120;diffusealpha,0.85;);
		OffCommand=cmd(finishtweening;zoomtoheight,140;decelerate,0.3;zoomtoheight,SCREEN_HEIGHT/2;diffusealpha,0;);
	};
	LoadActor("t_line")..{
		InitCommand=cmd(CenterX;y,-60;diffuse,color("1,0.75,0,1");diffusebottomedge,color("1,1,0,1");diffusealpha,0;zoomtowidth,0;);
		OnCommand=cmd(accelerate,0.2;zoomtowidth,SCREEN_WIDTH;diffusealpha,1;);
		OffCommand=cmd(finishtweening;decelerate,0.3;zoomtowidth,0;diffusealpha,0;);
	};
	LoadActor("u_line")..{
		InitCommand=cmd(CenterX;y,60;diffuse,color("1,0.75,0,1");diffusetopedge,color("1,1,0,1");diffusealpha,0;zoomtowidth,0;);
		OnCommand=cmd(accelerate,0.2;zoomtowidth,SCREEN_WIDTH;diffusealpha,1;);
		OffCommand=cmd(finishtweening;decelerate,0.3;zoomtowidth,0;diffusealpha,0;);
	};
	LoadActor("attention")..{
		InitCommand=cmd(CenterX;y,-60;diffusealpha,0;zoomy,1;);
		OnCommand=cmd(zoomx,10;decelerate,0.2;zoomx,1;diffusealpha,1;glow,color("1,0.5,0,1");linear,0.3;glow,color("0,0,0,0"););
		OffCommand=cmd(finishtweening;linear,0.2;zoomy,0;);
	};
	
	Def.ActorFrame{
		InitCommand=cmd(y,-22;);
		LoadFont("_Shared2")..{
			InitCommand=cmd(zoom,0.9;x,SCREEN_CENTER_X-10;y,-13;diffuse,color("1,0.5,0,1");diffusetopedge,color("1,1,0.2,1");strokecolor,Color("Black");maxwidth,SCREEN_WIDTH*0.95;
						settext,""..THEME:GetString("MusicWheel","CustomItemCSCText").." "..THEME:GetString("MusicWheel","Att1Text").."";);
			OnCommand=cmd(diffusealpha,0;visible,true;decelerate,0.3;x,SCREEN_CENTER_X;diffusealpha,1;);
			OffCommand=cmd(finishtweening;visible,false;diffusealpha,0;);
		};
		
		LoadFont("_Shared2")..{
			InitCommand=cmd(zoom,0.9;x,SCREEN_CENTER_X+10;y,13;diffuse,color("1,1,1,1");strokecolor,Color("Black");maxwidth,SCREEN_WIDTH*0.95;
						settext,""..THEME:GetString("MusicWheel","Att2Text").."";);
			OnCommand=cmd(diffusealpha,0;visible,true;decelerate,0.3;x,SCREEN_CENTER_X;diffusealpha,1;);
			OffCommand=cmd(finishtweening;visible,false;diffusealpha,0;);
		};
	};
	icon_set("Yes",selection);
	icon_set("No",selection);
	
	CodeMessageCommand=function(self,params)
		local icon_a = self:GetChild('icon_'..icon_set_table[1]);
		local icon_b = self:GetChild('icon_'..icon_set_table[2]);

		if params.Name == "Right" or params.Name == "Right2" or params.Name == "Right3" then
			if key_open < 3 then
				icon_a:playcommand("LoseFocus");
				if selection == icon_set_table[1] then
					SOUND:PlayOnce(THEME:GetPathS("ScreenTitleMenu","change"));
					icon_b:playcommand("GainFocus");
				end;
				selection = icon_set_table[2];
			else selection = icon_set_table[2];
			end;
		elseif params.Name == "Left" or params.Name == "Left2" or params.Name == "Left3" then
			if key_open < 3 then
				icon_b:playcommand("LoseFocus");
				if selection == icon_set_table[2] then
					SOUND:PlayOnce(THEME:GetPathS("ScreenTitleMenu","change"));
					icon_a:playcommand("GainFocus");
				end;
				selection = icon_set_table[1];
			else selection = icon_set_table[2];
			end;
		end;
	end;
};

function inputs(event)
	local pn= event.PlayerNumber
	if not pn then return false end
	local button = event.GameButton
	if event.type == "InputEventType_FirstPress" then
		if selection == icon_set_table[1] then
			if getenv("csflag") == 1 then
				if button == 'Start' or button == 'Center' then
					MESSAGEMAN:Broadcast("StartButton");
					setenv("csflag",2);
					SCREENMAN:GetTopScreen():PostScreenMessage('SM_GoToPrevScreen',0);
				end;
			end;
		else
			if button == 'Start' or button == 'Center' then
				if getenv("csflag") == 1 then
					key_open = 3;
					SOUND:PlayOnce(THEME:GetPathS("","_swoosh"));
				end;
				setenv("csflag",0);
				MESSAGEMAN:Broadcast("CCancel");
				SCREENMAN:GetTopScreen():PostScreenMessage('SM_GoToPrevScreen',1);
			end;
		end;

		if button == "Back" then
			setenv("csflag",0);
			key_open = 3;
			MESSAGEMAN:Broadcast("CCancel");
			SCREENMAN:GetTopScreen():PostScreenMessage('SM_GoToPrevScreen',1);
		end;
	end;
end;

local function update(self)
	local limit = getenv("Timer") + 1;
	if limit > 0 then
		if limit <= csc_close_time_limit() then
			if key_open < 4 then
				self:playcommand("Limit");
			end;
		else SCREENMAN:GetTopScreen():PostScreenMessage( 'SM_MenuTimer', ( string.format("%2i", getenv("Timer") ) ) );	
		end;
	end;
end;

t.InitCommand=cmd(SetUpdateFunction,update;);

return t;
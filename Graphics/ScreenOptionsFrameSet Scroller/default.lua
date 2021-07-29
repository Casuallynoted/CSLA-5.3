--[[ScreenOptionsFrameSet Scroller]]
SetAdhocPref("FrameSet",frameGetCheck());

local name = Var("GameCommand"):GetName();
local setname = "Regular";

if name == "Default" then setname = "Regular";
elseif name == "Challenge" then setname = "Oni"
elseif name == "Cyan" then setname = "CSC_Normal"
elseif name == "Cyan_Special" then setname = "CSC_Special"
else setname = name;
end;

local focus = false;
local nset = 0;
local fctext;
if GetAdhocPref("Fctext") then
	if GetAdhocPref("Fctext") ~= "" then
		fctext = split(",",GetAdhocPref("Fctext"));
	end;
end;
if fctext then
	for n=1,#fctext do
		if fctext[n] == name then
			nset = n;
			break;
		end;
	end;
end;

local t = Def.ActorFrame{};

t[#t+1] = Def.ActorFrame{
	InitCommand=cmd(x,SCREEN_LEFT+(SCREEN_WIDTH*0.125);y,SCREEN_CENTER_Y+14;);
	GainFocusCommand=cmd(zoom,1;);
	LoseFocusCommand=cmd(zoom,0.8;);

	Def.Quad{
		InitCommand=cmd(x,-33;y,4;zoomtowidth,78;zoomtoheight,28;diffuse,color("0,0,0,0.5"););
	};
	
	LoadActor(THEME:GetPathG("","GameFSet/Icon/_"..setname))..{
		InitCommand=function(self)
			(cmd(x,-32;y,4;))(self)
		end;
	};

	LoadFont("_Shared2") .. {
		Text=name;
		InitCommand=function(self)
			(cmd(x,12;horizalign,left;zoom,0.95;strokecolor,Color("Black");))(self)
			if name == "Default" then self:diffuse(color("0,1,1,1"));
			else self:diffuse(color("1,1,0,1"));
			end;
		end;
		OnCommand=cmd(cropright,1;sleep,0.001;decelerate,0.2;cropright,0;diffusealpha,1;);
		GainFocusCommand=cmd(finishtweening;visible,true;cropright,1;sleep,0.001;decelerate,0.2;cropright,0;diffusealpha,1;y,-4;);
		LoseFocusCommand=cmd(y,0;);
	};
	LoadFont("Common Normal") .. {
		InitCommand=function(self)
			if name == "Default" then self:diffuse(color("0,1,1,1"));
			else self:diffuse(color("1,1,0,1"));
			end;
			if GetAdhocPref("FrameSet") == name then
				focus = true;
			end;
			(cmd(visible,true;x,12;horizalign,left;maxwidth,SCREEN_WIDTH;zoom,0.5;y,12;strokecolor,color("0,0,0,1");))(self)
		end;
		OnCommand=cmd(cropright,1;sleep,0.001;decelerate,0.2;cropright,0;diffusealpha,1;);
		GainFocusCommand=function(self)
			self:diffusealpha(1);
			focus = true;
			if name == "Default" then self:settext( THEME:GetString("ScreenOptionsFrameSet","InfoDefault") );
			else self:settext(string.format( THEME:GetString("ScreenOptionsFrameSet","InfoOther"),name ));
			end;
			(cmd(finishtweening;cropright,1;sleep,0.001;decelerate,0.2;cropright,0;diffusealpha,1;))(self)
		end;
		LoseFocusCommand=function(self)
			focus = false;
			self:diffusealpha(0);
		end;
		SelectNMessageCommand=function(self)
			if focus then
				SetAdhocPref("FrameSet", name);
				Trace("FrameSet : "..name);
			end;
		end;
	};
};

function ctable(ft)
	if ft then
		return table.concat(ft,",");
	end;
	return "";
end;

if nset > 0 then
	t[#t+1] = Def.ActorFrame{
		InitCommand=cmd(x,SCREEN_LEFT+(SCREEN_WIDTH*0.0375)y,SCREEN_CENTER_Y+3;);
		SelectNMessageCommand=function(self)
			if focus then
				if fctext[nset] then
					table.remove(fctext,nset);
				end;
				SetAdhocPref("Fctext", ctable(fctext));
				Trace("fctext : "..GetAdhocPref("Fctext"));
			end;
		end;
		LoadFont("Common Normal") ..{
			InitCommand=function(self)
				(cmd(visible,true;uppercase,true;settext,"New!";horizalign,left;
				shadowlength,2;diffuse,color("1,0,1,1");strokecolor,color("1,1,0,1");zoom,0.45;))(self)
			end;
			GainFocusCommand=cmd(stoptweening;sleep,0.001;accelerate,0.05;x,-6;y,-3;);
			LoseFocusCommand=cmd(stoptweening;sleep,0.001;accelerate,0.05;x,6;y,3;);
		};
	};
end;

return t;
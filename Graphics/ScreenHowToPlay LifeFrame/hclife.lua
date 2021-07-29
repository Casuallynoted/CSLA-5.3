
local t = Def.ActorFrame{};

local meterwidth = math.min(216,WideScale(213,216));
local meterheight = 14;

local mframe;
mframe = Def.ActorFrame{
	Def.Quad{
		Name="Meterback";
		InitCommand=cmd(zoomto,meterwidth,meterheight;diffuse,color("0,0,0,0.7"));
		BeginCommand=cmd(horizalign,right);
		ShowCommand=cmd(diffuse,color("0,0,0,1");diffuseshift;effectperiod,0.5;effectcolor1,color("0.6,0,0,1");effectcolor2,color("0,0,0,1"););
		HideCommand=cmd(stopeffect;stoptweening;diffuse,color("0,0,0,0.6"););
	};
	
	LoadActor(THEME:GetPathG("","GameFSet/Life/normalover"))..{
		Name="Meter";
		InitCommand=function(self)
			(cmd(visible,true;setsize,meterwidth,meterheight;diffuse,color("1,1,0,1");
			diffuserightedge,color("1,0.3,0,1");diffusetopedge,color("0.8,0.5,0,1");blend,"BlendMode_Add";))(self)
		end;
		BeginCommand=cmd(horizalign,right);
		ShowCommand=cmd(finishtweening;diffuse,color("1,1,1,1");diffusetopedge,color("0.5,0.5,0.5,1"););
		HideCommand=cmd(diffuse,color("0,1,1,1");diffusetopedge,color("0,0.5,0.7,1"););
	};
	
	LoadActor(THEME:GetPathG("","GameFSet/Life/hotover"))..{
		Name="Lifehot";
		InitCommand=cmd(visible,true;setsize,meterwidth,meterheight;diffusealpha,0;blend,'BlendMode_Add';); 
		BeginCommand=cmd(horizalign,right);
		ShowCommand=cmd(diffusealpha,1;finishtweening;diffuse,color("0.6,0.6,0.6,0.5");rainbow;effectperiod,3;);
		HideCommand=cmd(stopeffect;stoptweening;linear,0.1;diffusealpha,0);
	};
};

local function update(self)
	local meterback = self:GetChild("Meterback");
	local hotline = self:GetChild("Lifehot");
	local normalline = self:GetChild("Meter");
	local bpmnormalmove = 0;
	local bpmhotmove = 0;
	local songPosition = GAMESTATE:GetSongPosition();
	local bpm = songPosition:GetCurBPS() * 60;
	local stop = songPosition:GetFreeze();
	local cbpm = bpm;
	if stop then cbpm = 0;
	end;
	local screen = SCREENMAN:GetTopScreen();
	local htplife;

	bpmnormalmove = (cbpm/60)/3.5;
	bpmhotmove = (cbpm/60)/3;
	
	normalline:stoptweening();
	normalline:texcoordvelocity(bpmnormalmove,0);
	hotline:texcoordvelocity(bpmhotmove,0);
	
	if screen then
		htplife = screen:GetLifeMeter();
		if htplife:IsHot() then
			(cmd(finishtweening;diffuse,color("1,1,1,1");diffusetopedge,color("0.5,0.5,0.5,1");diffuserightedge,color("1,1,1,1");))(normalline);
			hotline:playcommand("Show");
		elseif htplife:IsInDanger() then
			(cmd(finishtweening;diffuse,color("1,1,0,1");diffusetopedge,color("0.8,0.5,0,1");diffuserightedge,color("1,0.3,0,1");))(normalline);
			meterback:playcommand("Show");
			hotline:playcommand("Hide");
		else
			(cmd(finishtweening;diffuse,color("1,1,0,1");diffusetopedge,color("0.8,0.5,0,1");diffuserightedge,color("1,0.3,0,1");))(normalline);
			meterback:playcommand("Hide");
			hotline:playcommand("Hide");
		end;
		normalline:bounceend(0.15);
		normalline:cropright(1 - htplife:GetLife());
	end;
end;

mframe.InitCommand=cmd(SetUpdateFunction,update;);

t[#t+1] = mframe;

return t;
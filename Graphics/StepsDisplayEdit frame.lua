--20160504
local t = Def.ActorFrame{};

local CustomDifficultyToState = {
	Beginner		= 0,
	Easy			= 2,
	Medium		= 4,
	Hard			= 6,
	Challenge		= 8,
	Edit			= 10,
	Crazy		= 6,
	HalfDouble		= 4,
	Routine		= 2,
	Freestyle		= 4,
	Nightmare		= 6
};

t[#t+1] = Def.ActorFrame{
	InitCommand=cmd(zoom,0.8;);
	
	Def.Quad {
		Name="line";
		InitCommand=cmd(x,-180;y,14;horizalign,left;zoomto,240,1;diffuse,Color("Black"););
	};
	LoadActor(THEME:GetPathB("ScreenStageInformation","in/diffback"))..{
		Name="diffback";
		InitCommand=cmd(x,98;y,4;);
	};
	
	LoadActor(THEME:GetPathG("DiffDisplay","frame/frame"))..{
		Name="difftable";
		InitCommand=cmd(x,70;animate,false;);
	};
	
	LoadFont("StepsDisplay meter")..{
		Name="tmeter";
		InitCommand=cmd(x,160;y,-2;horizalign,right;maxwidth,60;zoom,0.875;skewx,-0.5;);
	};
	
	LoadFont("_Shared2")..{
		Name="description";
		InitCommand=cmd(x,-180;horizalign,left;zoom,0.75;maxwidth,160);
	};
	
	SetCommand=function(self, param)
		local line = self:GetChild('line');
		local diffback = self:GetChild('diffback');
		local difftable = self:GetChild('difftable');
		local tmeter = self:GetChild('tmeter');
		local description = self:GetChild('description');
		local step;
		local meter;
		local cdiff = param.CustomDifficulty;
		self:stoptweening();
		line:visible(false);
		diffback:visible(false);
		difftable:visible(false);
		tmeter:visible(false);
		description:visible(false);
		if cdiff then
			step = param.Steps;
			meter = param.Meter;
			line:visible(true);
			diffback:visible(true);
			difftable:visible(true);
			difftable:setstate(CustomDifficultyToState[cdiff]);
			tmeter:visible(true);
			tmeter:diffuse(CustomDifficultyToColor(cdiff));
			tmeter:strokecolor(CustomDifficultyToDarkColor(cdiff));
			if step then
				diffback:diffuse(Color("White"));
				difftable:diffuse(Color("White"));
				description:visible(true);
				description:diffuse(CustomDifficultyToColor(cdiff));
				description:strokecolor(Color("Black"));
				--20180210
				description:settext(step:GetChartName() ~= "" and step:GetChartName() or step:GetDescription() );
				tmeter:settext(meter);
			else
				diffback:diffuse(color("0.3,0.3,0.3,1"));
				difftable:diffuse(color("0.5,0.5,0.5,1"));
				tmeter:settext("?");
				tmeter:diffuse(CustomDifficultyToDarkColor(cdiff));
				tmeter:strokecolor(color("0,0,0,0"));
			end;
		else tmeter:settext("");
		end;
	end;
};

return t;
local ShowFlashyCombo = GetUserPrefB("UserPrefFlashyCombo");
local screen = SCREENMAN:GetTopScreen();

local t = Def.ActorFrame{};

if screen then
	if screen:GetName() ~= "ScreenGameplaySyncMachine" then
		if ShowFlashyCombo then
			t[#t+1] = Def.ActorFrame{
				Def.Quad{
					InitCommand=cmd(x,-(ColumnChecker()/2)-20;horizalign,right;zoomtoheight,0;zoomtowidth,20;diffuse,color("0,1,1,1");blend,'BlendMode_Add';);
					MilestoneCommand=cmd(zoomtowidth,0;zoomtoheight,0;fadeleft,0.5;diffusealpha,1;accelerate,0.35;
									zoomtowidth,20;zoomtoheight,SCREEN_HEIGHT*2;diffusealpha,0.75;linear,1.65;fadeleft,1;diffusealpha,0);
				};
				Def.Quad {
					InitCommand=cmd(x,(ColumnChecker()/2)+20;horizalign,left;zoomtoheight,0;zoomtowidth,20;diffuse,color("0,1,1,1");blend,'BlendMode_Add';);
					MilestoneCommand=cmd(zoomtowidth,0;zoomtoheight,0;faderight,0.5;diffusealpha,1;accelerate,0.35;
									zoomtowidth,20;zoomtoheight,SCREEN_HEIGHT*2;diffusealpha,0.75;linear,1.65;faderight,1;diffusealpha,0);
				};
			};
		end;
	end;
end;

return t;

local t = Def.ActorFrame {
};

t[#t+1] = LoadActor(THEME:GetPathG("","header"))..{
	KResetMessageCommand=cmd(stoptweening;zoomx,1;zoomy,1;sleep,0.4;accelerate,0.1;zoomx,10;zoomy,0;x,-300;y,30;);
};

return t;
--[[ScreenSelectStyle scroller]]
--[ja] 20160629 OnCommandをBeginCommandに修正 画面遷移速度向上対策
local gc = Var "GameCommand";
local stf = "";
if CurGameName() ~= "dance" then stf = "_"..CurGameName();
end;

local s_table = {
	--num,Premium_Off,Premium_DoubleFor1Credit,2P,command,exp
	Single	= {1,1,1,0,"Lose","allmode"},
	Solo		= {2,1,1,0,"Lose","notbattle"},
	Versus	= {3,0,0,1,"Lose","allmode"},
	Double	= {4,0,1,1,"Lose","notbattle"},
	HalfDouble	= {5,0,1,1,"Lose","notbattle"}
};
local choice = "Single";

local function setgl(self,choice)
	local back = self:GetChild('Back');
	local under_1 = self:GetChild('Explanation'):GetChild('Under_1');
	local under_2 = self:GetChild('Explanation'):GetChild('Under_2');
	local style_s = self:GetChild('Explanation'):GetChild('Style');
	local m_back = self:GetChild('Main'):GetChild('M_back');
	local i_back = m_back:GetChild('I_back');
	local n_back = m_back:GetChild('N_back');
	local label = self:GetChild('Main'):GetChild('Label');
	local exp_2 = self:GetChild('Main'):GetChild('Exp_2');
	local exp_1 = self:GetChild('Main'):GetChild('Exp_1');
	local exp_0 = self:GetChild('Main'):GetChild('Exp_0');
	local text_s = self:GetChild('Main'):GetChild('Text_s');
	
	local pay = GAMESTATE:GetCoinMode() == 'CoinMode_Pay';
	local premium = GAMESTATE:GetPremium();
	if #GAMESTATE:GetHumanPlayers() == 1 then
		if pay then
			if premium == 'Premium_Off' then
				if s_table[choice][2] == 0 then
					s_table[choice][5] = "Lose";
				elseif s_table[choice][5] ~= "Gain" then
					s_table[choice][5] = "Lose";
				end;
			elseif premium == 'Premium_DoubleFor1Credit' then
				if s_table[choice][3] == 0 then
					s_table[choice][5] = "Lose";
				elseif s_table[choice][5] ~= "Gain" then
					s_table[choice][5] = "Lose";
				end;
			else
				if s_table[choice][5] ~= "Gain" then
					s_table[choice][5] = "Lose";
				end;
			end;
		else
			if s_table[choice][5] ~= "Gain" then
				s_table[choice][5] = "Lose";
			end;
		end;
	else
		if s_table[choice][4] == 0 then
			s_table[choice][5] = "Lose";
		elseif s_table[choice][5] ~= "Gain" then
			s_table[choice][5] = "Lose";
		end;
	end;
	back:playcommand(s_table[choice][5]);
	under_1:playcommand(s_table[choice][5]);
	under_2:playcommand(s_table[choice][5]);
	style_s:playcommand(s_table[choice][5]);
	m_back:playcommand(s_table[choice][5]);
	i_back:playcommand(s_table[choice][5]);
	n_back:playcommand(s_table[choice][5]);
	label:playcommand(s_table[choice][5]);
	exp_2:playcommand(s_table[choice][5]);
	exp_1:playcommand(s_table[choice][5]);
	exp_0:playcommand(s_table[choice][5]);
	text_s:playcommand(s_table[choice][5]);
	return self;
end;


local t = Def.ActorFrame{};

t[#t+1] = Def.ActorFrame{
	InitCommand=cmd(fov,100;);

	Def.Quad{
		Name="Back";
		InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y-60;zoomto,SCREEN_WIDTH,220;diffuse,color("0,0,0,0.2"););
		BeginCommand=cmd(zoomtoheight,0;glow,color("1,0.6,0,0.2");linear,0.4;zoomtoheight,220;glow,color("1,0.6,0,0"););
		GainCommand=cmd(stoptweening;zoomtoheight,220;glow,color("1,0.6,0,0.2");linear,0.4;glow,color("1,0.6,0,0");diffusealpha,0;);
		LoseCommand=cmd(stoptweening;zoomtoheight,220;glow,color("1,0.6,0,0");diffusealpha,0;);
		OffFocusedCommand=cmd(stoptweening;zoomtoheight,220;glow,color("1,0.6,0,0");diffusealpha,0;);
	};

	--explanation
	--20170617
	Def.ActorFrame{
		Name="Explanation";
		InitCommand=cmd(x,SCREEN_CENTER_X-198;y,SCREEN_CENTER_Y-148+10;);
		OnCommand=cmd(playcommand,"Begin");
		BeginCommand=cmd(zoomy,5;decelerate,0.45;zoomy,1;);
		LoadActor(THEME:GetPathG("","stylemodeback/explanationunder"))..{
			Name="Under_1";
			BeginCommand=cmd(diffusealpha,0;glow,color("0,1,1,0");zoomy,1.5;y,-10;sleep,0.3;glow,color("0,1,1,1");
							decelerate,0.5;zoomy,1;diffusealpha,1;y,0;glow,color("0,1,1,0"););
			OffFocusedCommand=cmd(stoptweening;);
		};

		LoadActor(THEME:GetPathG("","stylemodeback/explanationunder"))..{
			Name="Under_2";
			BeginCommand=cmd(zoomx,0.2;zoom,3;decelerate,0.25;zoom,1;diffusealpha,0);
			OffFocusedCommand=cmd(finishtweening;);
		};

		LoadActor(THEME:GetPathG("","stylemodeback/explanationstyle"))..{
			Name="Style";
			InitCommand=cmd(x,12;y,-3;);
			BeginCommand=cmd(diffusealpha,0;glow,color("0,1,1,0");zoomy,1.5;x,12+30;sleep,0.1;glow,color("0,1,1,1");
							decelerate,0.5;zoomy,1;diffusealpha,1;x,12;glow,color("0,1,1,0");queuecommand,"Repeat";);
			RepeatCommand=cmd(diffusealpha,1;sleep,8;glow,color("0,1,1,0");linear,0.05;glow,color("0,1,1,1");
							decelerate,0.5;glow,color("0,1,1,0");queuecommand,"Repeat";);
			OffFocusedCommand=cmd(stoptweening;);
		};
	};
	
	Def.ActorFrame{
		Name="Main";
		InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;);
		OnCommand=cmd(playcommand,"Begin");
		BeginCommand=cmd(zoomx,10;sleep,0.1;accelerate,0.2;zoomx,1;);

		Def.ActorFrame{
			Name="M_back";
			LoadActor(THEME:GetPathG("","stylemodeback/info_back"))..{
				Name="I_back";
				InitCommand=cmd(x,-124;y,-10;);
				BeginCommand=cmd(croptop,1;decelerate,0.45;croptop,0;);
				GainCommand=cmd(stoptweening;croptop,1;decelerate,0.45;croptop,0;);
				LoseCommand=cmd(stoptweening;croptop,1;);
				OffFocusedCommand=cmd(stoptweening;);
			};
	
			LoadActor(THEME:GetPathG("","stylemodeback/name_back"))..{
				Name="N_back";
				InitCommand=cmd(x,-134;y,-86;);
				BeginCommand=cmd(cropleft,1;glow,color("1,0.7,0,0.6");accelerate,0.55;cropleft,0;linear,0.1;glow,color("0,0,0,0"););
				GainCommand=cmd(stoptweening;cropleft,1;glow,color("1,0.7,0,0.6");
								accelerate,0.55;cropleft,0;linear,0.1;glow,color("0,0,0,0"););
				LoseCommand=cmd(stoptweening;cropleft,1;glow,color("0,0,0,0"););
				OffFocusedCommand=cmd(stoptweening;);
			};
		};

		LoadActor(stf.."_"..gc:GetName().."_label")..{
			Name="Label";
			InitCommand=cmd(x,130;y,50;vertalign,bottom;);
			BeginCommand=cmd(x,130+10;diffusealpha,0.8;cropbottom,1;decelerate,0.4;x,130;cropbottom,0;
							glow,color("0.6,0.25,0.1,1");linear,0.025;glow,color("1,0.5,0,0"););
			GainCommand=cmd(stoptweening;x,130+10;diffusealpha,0.8;cropbottom,1;decelerate,0.4;
							x,130;cropbottom,0;glow,color("0.6,0.25,0.1,1");linear,0.025;glow,color("1,0.5,0,0"););
			LoseCommand=cmd(stoptweening;cropbottom,1;glow,color("0,0,0,0"););
			OffFocusedCommand=cmd(stoptweening;);
		};

		LoadActor(stf.."_"..gc:GetName().."_explain2")..{
			Name="Exp_2";
			InitCommand=cmd(x,-118;y,-19;);
			BeginCommand=cmd(diffusealpha,0;y,-19-5;sleep,0.5;linear,0.2;y,-19;diffusealpha,1;glow,color("1,1,1,0");
							linear,0.05;glow,color("1,1,1,0.5");linear,0.05;glow,color("1,1,1,0"););
			GainCommand=cmd(stoptweening;diffusealpha,0;y,-19-5;sleep,0.1;linear,0.2;y,-19;diffusealpha,1;
							glow,color("1,1,1,0");linear,0.05;glow,color("1,1,1,0.5");linear,0.05;glow,color("1,1,1,0"););
			LoseCommand=cmd(stoptweening;diffusealpha,0;glow,color("0,0,0,0"););
			OffFocusedCommand=cmd(stoptweening;);
		};
	
		LoadActor(stf.."_"..gc:GetName().."_explain1")..{
			Name="Exp_1";
			InitCommand=cmd(x,-104;y,-88+10;);
			BeginCommand=cmd(diffusealpha,0.5;x,-104+20;zoomx,210;zoomy,1;decelerate,0.35;zoomx,1.75;
						glow,color("0,1,1,0.5");x,-104;zoomx,1;linear,0.05;glow,color("1,1,0,1");diffusealpha,1;decelerate,0.1;glow,color("0,1,1,0"));
			GainCommand=cmd(stoptweening;diffusealpha,0.5;x,-104+20;zoomx,210;zoomy,1;decelerate,0.35;zoomx,1.75;
						glow,color("0,1,1,0.5");x,-104;zoomx,1;linear,0.05;glow,color("1,1,0,1");diffusealpha,1;decelerate,0.1;glow,color("0,1,1,0"));
			LoseCommand=cmd(stoptweening;zoom,1;diffusealpha,0;glow,color("0,0,0,0"););
			OffFocusedCommand=cmd(stoptweening;);
		};

		Def.Sprite{
			Name="Exp_0";
			InitCommand=function(self)
				self:x(-122);
				self:y(2);
				if IsNetConnected() then
					self:Load(THEME:GetPathG("ScreenSelectStyle","scroller/explain_net"));
				else
					if s_table[gc:GetName()][6] ~= nil and s_table[gc:GetName()][6] ~= "" then
						self:Load(THEME:GetPathG("ScreenSelectStyle","scroller/explain_"..s_table[gc:GetName()][6]));
					end;
				end;
			end;
			BeginCommand=cmd(diffusealpha,0;x,-122+5;sleep,0.5;linear,0.2;x,-122;diffusealpha,1;glow,color("1,1,1,0");linear,0.05;
							glow,color("1,1,1,0.5");linear,0.05;glow,color("1,1,1,0"););
			GainCommand=cmd(stoptweening;diffusealpha,0;x,-122+5;sleep,0.1;linear,0.2;x,-122;diffusealpha,1;
							glow,color("1,1,1,0");linear,0.05;glow,color("1,1,1,0.5");linear,0.05;glow,color("1,1,1,0"););
			LoseCommand=cmd(stoptweening;diffusealpha,0;glow,color("0,0,0,0"););
			OffFocusedCommand=cmd(stoptweening;);
		};

		LoadFont("_titleMenu_scroller") .. {
			Name="Text_s";
			Text="Which GameStyle matches you?";
			InitCommand=cmd(x,-208;y,-110;diffuse,color("0,0,0,1");strokecolor,color("1,0.6,0,1");shadowlength,1;zoom,0.4;);
			BeginCommand=cmd(cropright,1;sleep,0.1;linear,0.35;cropright,0;diffusealpha,1;);
			GainCommand=cmd(stoptweening;cropright,1;sleep,0.1;linear,0.35;cropright,0;diffusealpha,1;);
			LoseCommand=cmd(stoptweening;cropright,1;diffusealpha,0;);
			OffFocusedCommand=cmd(stoptweening;);
		};
	};
	
	BeginCommand=cmd(playcommand,"Set";);
	SetCommand=function(self)
		choice = gc:GetName();
		setgl(self,choice);
	end;
	PlayerJoinedMessageCommand=cmd(playcommand,"Set";);
	PlayerUnjoinedMessageCommand=cmd(playcommand,"Set";);
	RefreshCreditTextMessageCommand=cmd(playcommand,"Set";);
	GainFocusCommand=function(self)
		choice = gc:GetName();
		if s_table[choice][5] == "Lose" then
			s_table[choice][5] = "Gain";
		end;
		--SCREENMAN:SystemMessage(choice..","..s_table["Versus"][5]);
		setgl(self,choice);
	end;
	LoseFocusCommand=function(self)
		if s_table[choice][5] == "Gain" then
			s_table[choice][5] = "Lose";
		end;
		setgl(self,choice);
	end;
};

return t;
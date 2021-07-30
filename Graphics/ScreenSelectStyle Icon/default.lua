--[[ScreenSelectStyle Icon]]
--20180110

local gc = Var "GameCommand";
local stf = "";
if CurGameName() ~= "dance" then stf = CurGameName().."_";
end;

local s_table = {
	--num,Premium_Off,Premium_DoubleFor1Credit,2P,command,slsec
	Single	= {1,1,1,0,"Lose",0},
	Solo		= {2,1,1,0,"Lose",0.065},
	Versus	= {3,0,0,1,"Lose",0.13},
	Double	= {4,0,1,1,"Lose",0.175},
	HalfDouble	= {3,0,1,1,"Lose",0.13}
};

if CurGameName() == "dance" then
	table.remove(s_table["HalfDouble"]);
elseif CurGameName() == "pump" then
	s_table["Versus"][1] = 2;
	table.remove(s_table["Solo"]);
end;


local choice = "Single";

local slsec = s_table[gc:GetName()][6];

local function setgl(self,choice)
	local decide1 = self:GetChild('Decide_1'):GetChild('Decide1');
	local decide4 = self:GetChild('Decide_4'):GetChild('Decide4');
	local base = self:GetChild('Under'):GetChild('Base');
	local c_glow = self:GetChild('Under'):GetChild('Glow');
	local decide2 = self:GetChild('Decide2');
	
	local pay = GAMESTATE:GetCoinMode() == 'CoinMode_Pay';
	local premium = GAMESTATE:GetPremium();
	if #GAMESTATE:GetHumanPlayers() == 1 then
		if pay then
			if premium == 'Premium_Off' then
				if s_table[choice][2] == 0 then
					s_table[choice][5] = "None";
				elseif s_table[choice][5] ~= "Gain" then
					s_table[choice][5] = "Lose";
				end;
			elseif premium == 'Premium_DoubleFor1Credit' then
				if s_table[choice][3] == 0 then
					s_table[choice][5] = "None";
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
			--s_table[choice][5] = "None";
		elseif s_table[choice][5] ~= "Gain" then
			s_table[choice][5] = "Lose";
		end;
	end;
	decide1:playcommand(s_table[choice][5]);
	decide4:playcommand(s_table[choice][5]);
	base:playcommand(s_table[choice][5]);
	c_glow:playcommand(s_table[choice][5]);
	decide2:playcommand(s_table[choice][5]);
	return self;
end;

if CurGameName() == "pump" then
	if gc:GetName() == "Versus" then slsec = slsec / 2;
	end;
end;


local t = Def.ActorFrame{};

t[#t+1] = Def.ActorFrame{
	Def.ActorFrame{
		Name="Decide_1";
		OnCommand=cmd(diffusealpha,0;addx,50;addy,-50;sleep,tonumber(slsec);decelerate,0.2;diffusealpha,1;addx,-50;addy,50;);
		LoadActor("icon_decide1")..{
			Name="Decide1";
			GainCommand=cmd(stoptweening;diffusealpha,1;cropright,1;linear,0.4;cropright,0;);
			LoseCommand=cmd(stoptweening;cropright,1;diffusealpha,0;);
			NoneCommand=cmd(stoptweening;cropright,1;diffusealpha,0;);
		};
	};
	
	Def.ActorFrame{
		Name="Decide_4";
		OnCommand=cmd(addx,-24;zoomy,0;sleep,tonumber(slsec);decelerate,0.45;addx,24;zoomy,1;);
		LoadActor("icon_decide4")..{
			Name="Decide4";
			InitCommand=cmd(y,2;);
			GainCommand=cmd(stoptweening;visible,true;diffusealpha,1;croptop,1;linear,0.2;croptop,0;
							glowshift;effectcolor1,color("1,0,0,1");effectcolor2,color("0,1,0.9,0.7");effectperiod,1);
			LoseCommand=cmd(stoptweening;croptop,1);
			NoneCommand=cmd(stoptweening;croptop,1;);
		};
	};
	
	Def.ActorFrame{
		Name="Under";
		OnCommand=cmd(addx,14;addy,14;diffusealpha,0;rotationy,50;sleep,tonumber(slsec);decelerate,0.45;addx,-14;addy,-14;diffusealpha,1;rotationy,0;);
		--iconbase
		LoadActor(stf..""..gc:GetName())..{
			Name="Base";
			GainCommand=cmd(stoptweening;linear,0.2;diffuse,color("1,1,1,1"););
			LoseCommand=cmd(stoptweening;linear,0.1;diffuse,color("0.45,0.45,0.45,1"););
			NoneCommand=cmd(stoptweening;linear,0.1;diffuse,color("0.15,0.15,0.15,1"););
		};

		--iconfocusglow
		LoadActor(stf..""..gc:GetName())..{
			Name="Glow";
			GainCommand=function(self)
				(cmd(stoptweening;diffusealpha,1;glow,color("1,0.5,0,0.5");croptop,1;cropbottom,1;linear,0.4;croptop,0;
				linear,0.2;cropbottom,0;linear,0.2;croptop,1;))(self)
				if s_table[choice][5] == "Gain" then
					self:queuecommand("Sleep");
				else self:queuecommand("Lose");
				end;
			end;
			SleepCommand=cmd(sleep,4;queuecommand,"Check");
			CheckCommand=function(self)
				if s_table[choice][5] == "Gain" then
					self:queuecommand("Gain");
				else self:queuecommand("Lose");
				end;
			end;
			LoseCommand=cmd(stoptweening;croptop,1;);
			NoneCommand=cmd(stoptweening;croptop,1;);
		};
	};

	LoadActor(THEME:GetPathG("","stylemodeback/icon_decide2"))..{
		Name="Decide2";
		InitCommand=cmd(x,-28;y,-45;diffusealpha,0;sleep,tonumber(slsec);decelerate,0.3;diffusealpha,1;addx,-16;addy,16;);
		GainCommand=cmd(stoptweening;diffusealpha,1;finishtweening;cropbottom,1;decelerate,0.35;cropbottom,0;
						glowshift;effectcolor1,color("1,1,0,0.8");effectcolor2,color("0,1,0.9,0.4");effectperiod,0.75);
		LoseCommand=cmd(stoptweening;cropbottom,1;);
		NoneCommand=cmd(stoptweening;cropbottom,1;);
	};
	
	OnCommand=cmd(playcommand,"Set";);
	SetCommand=function(self)
		choice = gc:GetName();
		setgl(self,choice);
	end;
	PlayerJoinedMessageCommand=function(self)
		choice = gc:GetName();
		if s_table[choice][4] == 0 then
			s_table[choice][5] = "None";
		end;
		setgl(self,choice);
	end;
	PlayerUnjoinedMessageCommand=cmd(playcommand,"Set";);
	RefreshCreditTextMessageCommand=cmd(playcommand,"Set";);
	GainFocusCommand=function(self)
		choice = gc:GetName();
		if s_table[choice][5] == "Lose" then
			s_table[choice][5] = "Gain";
		end;
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
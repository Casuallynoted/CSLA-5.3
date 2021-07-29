
local t = Def.ActorFrame {};

local pm = GAMESTATE:GetPlayMode();
local stageindex = GAMESTATE:GetCurrentStageIndex();

if pm == 'PlayMode_Battle' or pm == 'PlayMode_Rave' then
	for i=1,2 do
		local pwcount = {0,0};
		local wcountp = "";
		if THEME:GetMetric( Var "LoadingScreen","Summary" ) == false then
			if getenv("WinCheckP"..i) ~= "" then
				wcountp = split(":",getenv("WinCheckP"..i));
				for j=2,#wcountp do
					if wcountp[j] ~= "" then
						pwcount[i] = pwcount[i] + wcountp[j];
					end;
				end;
			end;
			for tipset=1,5 do
				t[#t+1] = LoadActor(THEME:GetPathB("ScreenEvaluationSummary","overlay/win_tip"))..{
					InitCommand=cmd(CenterX;);
					OnCommand=function(self)
						self:y(34);
						if i == 1 then
							self:addx(-284+((tipset-1)*33)+80);
							(cmd(diffusealpha,0;sleep,0.2*tipset;decelerate,0.3;addx,-80;diffusealpha,1;))(self)
						else
							self:addx(284-((tipset-1)*33)-80);
							(cmd(rotationy,180;diffusealpha,0;sleep,0.2*tipset;decelerate,0.3;addx,80;diffusealpha,1;))(self)
						end;
						if tipset == stageindex then
							if GAMESTATE:IsWinner('PlayerNumber_P'..i) then self:diffuse(color("1,1,1,1"));
							elseif GAMESTATE:IsDraw() then self:diffuse(color("1,0.5,0,1"));
							else self:diffuse(color("1,0,0.4,1"));
							end;
						else
							if wcountp[tipset+1] == "1" then self:diffuse(color("1,1,1,1"));
							elseif wcountp[tipset+1] == "0" then self:diffuse(color("1,0.5,0,1"));
							elseif wcountp[tipset+1] == nil then self:diffuse(color("0.5,0.5,0.5,1"));
							else self:diffuse(color("1,0,0.4,1"));
							end;
						end;
					end;
				};
			end;
		end;

		t[#t+1] = Def.Sprite{
			InitCommand=function(self)
				local fir = pwcount[1];
				local sec = pwcount[2];
				if i == 1 then
					self:x(SCREEN_CENTER_X*0.45);
				else
					self:x(SCREEN_CENTER_X*1.55);
					fir = pwcount[2];
					sec = pwcount[1];
				end;
				if THEME:GetMetric( Var "LoadingScreen","Summary" ) == false then
					if GAMESTATE:IsWinner('PlayerNumber_P'..i) then
						self:Load(THEME:GetPathG("ScreenEvaluation","WinDisplay/win"));
					elseif GAMESTATE:IsDraw() then
						self:Load(THEME:GetPathG("ScreenEvaluation","WinDisplay/draw"));
					else
						self:Load(THEME:GetPathG("ScreenEvaluation","WinDisplay/lose"));
					end;
				else
					self:y(-10);
					if fir > sec then
						self:Load(THEME:GetPathG("ScreenEvaluation","WinDisplay/win"));
					elseif fir < sec then
						self:Load(THEME:GetPathG("ScreenEvaluation","WinDisplay/lose"));
					else
						if GAMESTATE:IsWinner('PlayerNumber_P'..i) then
							self:Load(THEME:GetPathG("ScreenEvaluation","WinDisplay/win"));
						elseif GAMESTATE:IsDraw() then
							self:Load(THEME:GetPathG("ScreenEvaluation","WinDisplay/draw"));
						else
							self:Load(THEME:GetPathG("ScreenEvaluation","WinDisplay/lose"));
						end;
					end;
				end;
				(cmd(horizalign,center;vertalign,bottom;))(self)
			end;
			OnCommand=cmd(zoom,0;sleep,2;zoomx,1;zoomy,5;accelerate,0.15;zoomy,1;);
			OffCommand=function(self)
				--if THEME:GetMetric( Var "LoadingScreen","Summary" ) == false then
					local setst = getenv("WinCheckP"..i);
					if GAMESTATE:IsWinner('PlayerNumber_P'..i) then
						setenv("WinCheckP"..i,setst..":1")
					elseif GAMESTATE:IsDraw() then
						setenv("WinCheckP"..i,setst..":0")
					else
						setenv("WinCheckP"..i,setst..":-1")
					end;
				--end;
			end;
		};
	end;
end;

return t;

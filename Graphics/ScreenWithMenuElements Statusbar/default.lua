--[[ ScreenWithMenuElements Statusbar ]]

local t = Def.ActorFrame{
	InitCommand=function(self)
		if getenv("ReloadAnimFlag") == 1 then self:playcommand("NoAnim");
		else self:playcommand("Anim");
		end;
	end;
};

for i=1,2 do
	local setx = SCREEN_CENTER_X*0.575-34;
	local player = PLAYER_1;
	if i == 2 then
		player = PLAYER_2;
		setx = SCREEN_CENTER_X*1.425+21;
	end;
	if not GAMESTATE:IsHumanPlayer(player) then
		t[#t+1] = Def.Sprite{
			InitCommand=function(self)
				self:x(setx-80);
				self:y(SCREEN_BOTTOM-46);
				self:Load(THEME:GetPathG("ScreenWithMenuElements","Statusbar/no_at"));
			end;
			AnimCommand=cmd(cropright,1;sleep,0.3;linear,0.3;cropright,0;);
			NoAnimCommand=cmd(diffusealpha,1;zoom,1;);
			OffCommand=cmd(stoptweening;cropright,0;decelerate,0.3;cropright,1;);
		};
	else
		t[#t+1] = Def.ActorFrame{
			InitCommand=cmd(x,setx;y,SCREEN_BOTTOM-46;);
			LoadActor("at")..{
				InitCommand=cmd(x,-10;);
				AnimCommand=cmd(cropright,1;sleep,0.3;linear,0.3;cropright,0;);
				NoAnimCommand=cmd(diffusealpha,1;zoom,1;);
				OffCommand=cmd(stoptweening;cropright,0;decelerate,0.3;cropright,1;);
			};

			Def.ActorFrame{
				PlayerJoinedMessageCommand=function(self, params)
					if params.Player == pn then
						self:visible(true);
					end;
				end;
				PlayerUnjoinedMessageCommand=function(self, params)
					if params.Player == pn then
						self:visible(false);
					end;
				end;
				LoadActor("lamp")..{
					InitCommand=cmd(x,-10;y,30;);
					AnimCommand=cmd(diffusealpha,0;zoomx,1.35;sleep,0.3;decelerate,0.3;diffusealpha,1;zoom,1;queuecommand,"Repeat";);
					NoAnimCommand=cmd(diffusealpha,1;zoom,1;queuecommand,"Repeat";);
					RepeatCommand=cmd(sleep,6;linear,0.05;glow,color("1,0.5,0,1");decelerate,2.5;glow,color("0,0,0,0");queuecommand,"Repeat";);
					OffCommand=cmd(stoptweening;cropright,0;decelerate,0.3;cropright,1;);
				};
				LoadActor(ToEnumShortString(player))..{
					InitCommand=cmd(x,-103;y,12;);
					AnimCommand=cmd(croptop,1;sleep,0.2;decelerate,0.3;croptop,0;zoom,1;);
					NoAnimCommand=cmd(diffusealpha,1;zoom,1;);
					OffCommand=cmd(stoptweening;cropright,0;decelerate,0.3;cropright,1;);
				};
			};
		};
	end;
end;

return t;
local num_players = GAMESTATE:GetHumanPlayers();
local function PositionItem(i,max)
	local x_spacing = 220; 
	return x_spacing * (i-(max-1)/2);
end


local t = Def.ActorFrame {
	FOV=90;
	--
	Def.Quad {
		InitCommand=cmd(zoomto,SCREEN_WIDTH,180);
		OnCommand=cmd(diffuse,Color.Black;diffusealpha,0.75;fadetop,40/SCREEN_CENTER_Y;fadebottom,40/SCREEN_CENTER_Y);
	};
};
--
for i=1,#num_players do
	local f = Def.ActorFrame {
		InitCommand=cmd(x,-220+PositionItem(i,#num_players));
		UnchosenCommand=cmd(finishtweening;decelerate,0.2;zoomy,1);
		ChosenCommand=cmd(stoptweening;accelerate,0.2;zoomy,0);
		--
		StepsChosenMessageCommand=function( self, param ) 
			if param.Player ~= num_players[i] then return end;
			self:playcommand("Chosen");
		end;
		StepsUnchosenMessageCommand=function( self, param ) 
			if param.Player ~= num_players[i] then return end;
			self:playcommand("Unchosen");
		end;
		Def.Quad {
			InitCommand=cmd(y,-35);
			OnCommand=cmd(diffuse,PlayerColor(num_players[i]);shadowlength,1;linear,0.25;zoomtowidth,80;fadeleft,0.5;faderight,0.5);
		};
		LoadFont("_Shared2") .. {
			Text=ToEnumShortString(num_players[i]);
			InitCommand=cmd(y,-48);
			OnCommand=cmd(diffuse,PlayerColor(num_players[i]);strokecolor,Color("Black"););
		};
		LoadFont("_Shared2") .. {
			Text="PRESS";
			InitCommand=cmd(y,-20);
			OnCommand=cmd(strokecolor,Color("Black");diffuseshift;effectcolor1,color("1,0.5,0,1");effectcolor2,color("1,1,1,1");effectperiod,1);
		};
		LoadFont("_Shared2") .. {
			Text="TO START";
			InitCommand=cmd(y,58);
			OnCommand=cmd(zoom,0.75;strokecolor,Color("Black"););
		};
	};
	if CurGameName() == "pump" then
		local ns = num_players[i] == PLAYER_1 and RoutineSkinP1() or RoutineSkinP2()
		f[#f+1] = LoadActor( NOTESKIN:GetPathForNoteSkin("Center","Tap",ns) ) .. {
			InitCommand=cmd(y,20);
		}
	end
	t[#t+1] = f;
end
-- Lock input for half a second so that players don't accidentally start a song
t[#t+1] = Def.Actor { 
	StartSelectingStepsMessageCommand=function() SCREENMAN:GetTopScreen():lockinput(0.5); end;
};

--
t.InitCommand=cmd(Center;x,SCREEN_CENTER_X*1.5;diffusealpha,0);
t.StartSelectingStepsMessageCommand=cmd(stoptweening;linear,0.2;diffusealpha,1);
t.SongUnchosenMessageCommand=cmd(stoptweening;linear,0.2;diffusealpha,0);


return t;

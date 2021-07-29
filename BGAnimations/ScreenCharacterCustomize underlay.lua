local t = Def.ActorFrame{};

local profile= GAMESTATE:GetEditLocalProfile();
local position = math.floor(scale((2.28/3),0,1,SCREEN_LEFT,SCREEN_RIGHT));

local chera = profile:GetCharacter();
local ctable = CHARMAN:GetAllCharacters();

t[#t+1] = Def.ActorFrame{
	Def.Sprite{
		InitCommand=cmd(Center;);
		OnCommand=function(self)
			self:Load( THEME:GetPathG("Common fallback","background") );
			self:scale_or_crop_background();
			self:cropleft(0.5);
			(cmd(diffusealpha,0;sleep,0.3;linear,0.25;diffusealpha,1))(self)
			self:glow(color("0,0,0,"..1*tonumber(PREFSMAN:GetPreference("BGBrightness"))));
		end;
	};
};

for ca=1,#ctable do
	t[#t+1] = Def.ActorFrame{
		InitCommand=cmd(x,position;y,SCREEN_CENTER_Y+160);
		OnCommand=cmd(diffusealpha,0;sleep,0.3;linear,0.25;diffusealpha,1);
		Def.Model{
			Materials = ctable[ca]:GetModelPath(),
			Meshes = ctable[ca]:GetModelPath(),
			Bones = ctable[ca]:GetRestAnimationPath(),
			Name="Character";
			InitCommand=function(self)
				self:visible(false);
				if chera:GetCharacterID() == ctable[ca]:GetCharacterID() then
					self:visible(true);
				end;
				(cmd(zoom,15;cullmode,'CullMode_None';cullmode,'CullMode_None';rate,1))(self)
			end;
			OnCommand=cmd(stoptweening;queuecommand,"RepeatF");
			RepeatFCommand=cmd(stoptweening;cullmode,'CullMode_Front';rotationy,180;linear,3.5;rotationy,359.9;queuecommand,"RepeatR");
			RepeatRCommand=cmd(stoptweening;cullmode,'CullMode_Front';rotationy,0;linear,3.5;rotationy,179.9;queuecommand,"RepeatF");
			DirectionButtonMessageCommand=function(self,param)
				self:visible(false);
				if param.Character ~= "Off" then
					if ctable[ca]:GetCharacterID() == param.Character:GetCharacterID() then
						self:visible(true);
					end;
				end;
			end;
		};
	};
end;

return t;
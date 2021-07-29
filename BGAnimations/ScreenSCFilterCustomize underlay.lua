local t = Def.ActorFrame{};

local profile= GAMESTATE:GetEditLocalProfile();
local profile_id= GAMESTATE:GetEditLocalProfileID();
local position = math.floor(scale((2.28/3),0,1,SCREEN_LEFT,SCREEN_RIGHT));
local one = tonumber(THEME:GetMetric("ArrowEffects","ArrowSpacing"));
local cp = {
	dance = 4,
	pump = 5,
}

function ColumnCheckerSC()
	local width = cp[CurGameName()]*one;
	--[ja] オブジェがかぶるので横幅が縮む分の計算
	if CurGameName() == "pump" then
		width = cp[CurGameName()]*(one*0.8);
	end;
	width = round(width + (width % 2),5);
	return width;
end;

local filter = ProfIDPrefCheck("ScreenFilterV2",profile_id,"Off,Black,Off");
local filters = split(",",filter);
local filter_v1 = ProfIDPrefCheck("ScreenFilter",profile_id,"Off");
local diffusea = 0;
local ldiffusea = 0;

function DarkColor( color ) 
	local c = color
	return { c[1]*0.6, c[2]*0.6, c[3]*0.6, c[4] }
end

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

t[#t+1] = Def.Quad{
	Name="Filter";
	InitCommand=function(self)
		self:visible(true);
		self:x(position);
		self:zoomto(ColumnCheckerSC()+40,SCREEN_HEIGHT);
		self:fadeleft(1/32);
		self:faderight(1/32);
		self:y(SCREEN_CENTER_Y);
		if GetAdhocPref("ScreenFilterV2",profile_id) then
			if tonumber(filters[1]) then
				diffusea = filters[1];
			end;
			if filters[2] == "Black" or filters[2] == "White" then
				self:diffuse(Color[filters[2]]);
			else self:diffuse(DarkColor(Color[filters[2]]));
			end;
		else
			if tonumber(filter_v1) then
				self:diffuse(Color["Black"]);
				if tonumber(filter_v1) then
					diffusea = filter_v1;
				end;
			end;
		end;
		(cmd(diffusealpha,0;sleep,0.3;linear,0.25;diffusealpha,diffusea))(self)
	end;
	DirectionButtonMessageCommand=function(self,param)
		self:stoptweening();
		self:accelerate(0.15);
		if param then
			if param.Ccolor then
				if param.Ccolor == "Black" or param.Ccolor == "White" then
					self:diffuse(Color[param.Ccolor]);
				else self:diffuse(DarkColor(Color[param.Ccolor]));
				end;
			end;
			if param.Alpha then
				self:diffusealpha(param.Alpha);
			else self:diffusealpha(diffusea);
			end;
		end;
	end;
};

if CurGameName() == "dance" then
	for l = 0, cp[CurGameName()] do
		t[#t+1] = Def.ActorFrame {
			InitCommand=cmd(x,position - (ColumnCheckerSC() / 2););
			Def.Quad{
				Name="Line";
				InitCommand=function(self)
					self:visible(false);
					self:x(one * l);
					self:zoomto(1.5,SCREEN_HEIGHT);
					if l == 0 or l == cp[CurGameName()] then
						if l == 0 then
							self:x((one * l) - 1);
						elseif l == cp[CurGameName()] then
							self:x((one * l) + 1);
						end;
						self:zoomto(2.5,SCREEN_HEIGHT);
					end;
					self:y(SCREEN_CENTER_Y);
					if GetAdhocPref("ScreenFilterV2",profile_id) then
						if filters[3] and filters[3] ~= "Off" then
							self:visible(true);
							self:diffuse(Color["White"]);
							if filters[2] == "White" then
								self:diffuse(Color["Black"]);
							end;
							ldiffusea = diffusea + 0.35;
							(cmd(diffusealpha,0;sleep,0.3;linear,0.25;diffusealpha,math.min(1,ldiffusea)))(self)
						end;
					end;
				end;
				DirectionButtonMessageCommand=function(self,param)
					self:stoptweening();
					self:accelerate(0.15);
					if param then
						if param.Cline ~= "Off" then
							self:visible(true);
							self:diffuse(Color["White"]);
							if param.Ccolor then
								if param.Ccolor == "White" then
									self:diffuse(Color["Black"]);
								end;
							end;
							if param.Alpha then
								ldiffusea = param.Alpha + 0.35
								self:diffusealpha(math.min(1,ldiffusea));
							else
								ldiffusea = diffusea + 0.35
								self:diffusealpha(math.min(1,ldiffusea));
							end;
						else
							ldiffusea = 0;
							self:diffusealpha(ldiffusea);
						end;
					end;
				end;
			};
		};
	end;
end;

return t;
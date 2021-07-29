--20180209 favorite
local sctext = getenv("SortCh");
local gsetc = split(",",GetAdhocPref("SortGsetCheck"));
local basezoom = 0.45;
local basewidth = 110;
local gset_width = 180;
if #GAMESTATE:GetHumanPlayers() > 1 then
	gset_width = 130;
end;
local tg_gset_width = 0;
local ntable = {ntype = "CSGrade",default = "SMGrade"};
--local envgroup = getenv("wheelsectiongroup");

local function animcheck(self)
	self:playcommand("Anim");
	--if getenv("ReloadAnimFlag") == 1 then self:playcommand("NoAnim");
	--else self:playcommand("Anim");
	--end;
end;
local a_commandset = cmd(addx,6;addy,6;diffusealpha,0;sleep,0.9;decelerate,0.4;addx,-6;addy,-6;diffusealpha,1);
local n_commandset = cmd(diffusealpha,1);

local function f_f_check()
	if string.find(sctext,"^Favorite.*") then
		local scstr = string.sub(sctext,-1);
		if scstr == "1" or scstr == "2" then
			local pstr = ProfIDSet(string.sub(scstr,-1));
			if GetAdhocPref("FavoriteCount",pstr) then
				return GetAdhocPref("FavoriteCount",pstr);
			end;
		end;
	end;
	return false;
end;

local t = Def.ActorFrame {
	LoadFont("_Shared4")..{
		Name="sortset_pnset";
		InitCommand=cmd(horizalign,left;zoom,basezoom;y,-8;maxwidth,basewidth);
		OnCommand=function(self)
			animcheck(self);
		end;
		AnimCommand=a_commandset;
		NoAnimCommand=n_commandset;
	};
	LoadFont("_Shared4")..{
		Name="sortset_gset";
		InitCommand=cmd(horizalign,left;zoom,basezoom;y,-8;maxwidth,gset_width;strokecolor,color("0.3,0.3,0.3,1"););
		OnCommand=function(self)
			animcheck(self);
		end;
		AnimCommand=a_commandset;
		NoAnimCommand=n_commandset;
	};
	Def.Sprite{
		Name="sort_image";
		InitCommand=cmd(horizalign,left;);
		OnCommand=function(self)
			animcheck(self);
		end;
		AnimCommand=a_commandset;
		NoAnimCommand=n_commandset;
	};
	Def.ActorFrame {
		Name="A_Star";
		InitCommand=cmd(x,10;y,3;);
		OnCommand=function(self)
			if string.find(sctext,"^Favorite.*") then
				self:visible(true);
				animcheck(self);
			else self:visible(false);
			end;
		end;
		AnimCommand=a_commandset;
		NoAnimCommand=n_commandset;
		LoadActor( THEME:GetPathG("","star") )..{
			Name="Image";
			InitCommand=cmd(zoom,0.4;shadowlength,1;);
		};
		LoadFont("Common Normal") .. {
			Name="Num";
			InitCommand=cmd(x,4;y,0;horizalign,left;maxwidth,50;zoom,0.6;settext,0;strokecolor,color("0,0,0,1");shadowlength,2;);
		};
	};
	BeginCommand=cmd(playcommand,"SetGraphic");

	SetGraphicCommand=function(self)
		local sort_image = self:GetChild('sort_image');
		local sortset_pnset = self:GetChild('sortset_pnset');
		local sortset_gset = self:GetChild('sortset_gset');
		local a_star_i = self:GetChild('A_Star'):GetChild('Image');
		local a_star_n = self:GetChild('A_Star'):GetChild('Num');
		local so = GAMESTATE:GetSortOrder();
		if so then
			local sort = ToEnumShortString(so);
			if so == "SortOrder_Preferred" then
				if string.find(sctext,"^Group$") or string.find(sctext,"^.*Meter") or string.find(sctext,"^SongBranch$") then
					sort_image:Load(THEME:GetPathG("","_SortDisplay/_"..sctext));
				elseif string.find(sctext,"^TopGrades.*") or string.find(sctext,"^UserCustom.*") or string.find(sctext,"^Favorite.*") then
					sort_image:Load(THEME:GetPathG("","_SortDisplay/_"..string.sub(sctext,1,-3)));
					if string.find(sctext,"^Favorite.*") and f_f_check() then
						a_star_i:diffuse(f_color_set[tonumber(f_f_check())]);
						a_star_n:settext(f_f_check());
					end;
				else sort_image:Load(THEME:GetPathG("","_SortDisplay/_"..sort));
				end;
			else
				if sort == "TopGrades" then
					sort_image:Load(THEME:GetPathG("","_SortDisplay/_TopGradesNormal"));
				else sort_image:Load(THEME:GetPathG("","_SortDisplay/_"..sort));
				end;
			end;

			sortset_pnset:visible(false);
			sortset_gset:visible(false);
			sort_image:y(0);
			--20180208
			if string.find(sctext,"^TopGrades.*") or string.find(sctext,"^UserCustom.*") or string.find(sctext,"^Favorite.*") then
				if #GAMESTATE:GetHumanPlayers() > 1 then
					sort_image:y(4);
					if gsetc[1] == "P1" or gsetc[1] == "P2" then
						sortset_pnset:visible(true);
						sortset_pnset:diffuse(Color("Black"));
						if gsetc[1] == "P1" then
							sortset_pnset:settext("PLAYER 1");
							sortset_pnset:strokecolor(PlayerColor(PLAYER_1));
						else
							sortset_pnset:settext("PLAYER 2");
							sortset_pnset:strokecolor(PlayerColor(PLAYER_2));
						end;
						tg_gset_width = math.min(sortset_pnset:GetWidth()*basezoom,basewidth*basezoom);
					end;
				end;
				if string.find(sctext,"^TopGrades.*") then
					sort_image:y(4);
					if gsetc[2] == "ntype" or gsetc[2] == "default" then
						sortset_gset:visible(true);
						if gsetc[2] == "ntype" then
							sortset_gset:diffuse(color("1,1,0,1"));
						else sortset_gset:diffuse(color("0,1,1,1"));
						end;
						sortset_gset:settext(" "..THEME:GetString( "OptionExplanations",ntable[gsetc[2]] ));
						sortset_gset:x(tg_gset_width);
					end;
				end;
			end;
		end;
	end;
	SortOrderChangedMessageCommand=cmd(playcommand,"SetGraphic";);
};

return t;
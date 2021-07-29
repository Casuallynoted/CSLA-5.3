local t = Def.ActorFrame{};

--[ja] 選曲画面でタイムのフラグとして使います
setenv("sortflag",0);
for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
	local p = ( (pn == "PlayerNumber_P1") and 1 or 2 );
	sc_change_diff_set(pn,p);
end;

if GAMESTATE:IsExtraStage() and getenv("exflag") == "csc" then
	t[#t+1] = LoadActor(THEME:GetPathB("ScreenSelectMusicCS","background"))..{
	};
elseif GAMESTATE:IsExtraStage() and getenv("exflag") ~= "csc" then
	t[#t+1] = LoadActor("extra1")..{
	};
elseif GAMESTATE:IsExtraStage2() then
	t[#t+1] = LoadActor("extra2")..{
	};
else
	if GAMESTATE:IsCourseMode() then
		t[#t+1] = LoadActor(THEME:GetPathB("ScreenSelectCourse","background"))..{
		};
	else
		t[#t+1] = LoadActor(THEME:GetPathB("ScreenSelectMusic","background"))..{
		};
	end;
end;

local brlist;
local songtitle;
local songartist;
local song = GAMESTATE:GetCurrentSong();
t[#t+1] = LoadActor( THEME:GetPathB("","eva_back") )..{
	OnCommand=function(self)
		local screen = SCREENMAN:GetTopScreen();
		self:visible(true);
		--[ja] 20150414修正
		if screen then
			if THEME:GetMetric( screen:GetName(), "Class" ) ~= "ScreenEvaluation" then
				if GAMESTATE:IsExtraStage() and getenv("exflag") == "csc" and song then
					brlist = GetGroupParameter(song:GetGroupName(),"Extra1Songs");
					songtitle = b_s_pr(brlist,song,"Title");
					songartist = b_s_pr(brlist,song,"Artist");
					if getenv("rnd_song") == 1 then
						if songtitle or songartist then
							self:visible(false);
						end;
					end;
				else
					if getenv("rnd_song") == 1 and song then
						brlist = GetGroupParameter(song:GetGroupName(),"BranchList");
						songtitle = b_s_pr(brlist,song,"Title");
						songartist = b_s_pr(brlist,song,"Artist");
						if songtitle or songartist then
							self:visible(false);
						end;
					else
						self:visible(SelOptionsTitleShow());
					end;
				end;
			end;
		end;
	end;
};

return t;
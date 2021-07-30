
local t = Def.ActorFrame{};

local CustomDifficultyToState = {
	Beginner		= 0,
	Easy			= 1,
	Medium		= 2,
	Hard			= 3,
	Challenge		= 4,
	Edit			= 5,
	Crazy		= 3,
	HalfDouble		= 2,
	Routine		= 1,
	Freestyle		= 2,
	Nightmare		= 3
};

--20160821
t[#t+1] = Def.ActorFrame{
	LoadActor(THEME:GetPathG("", "_difftable"))..{
		Name="difftable";
		InitCommand=cmd(animate,false);
	};
	
	Def.RollingNumbers {
		File=THEME:GetPathF("StepsDisplay","meter");
		Name="tmeter";
		InitCommand=function(self)
			(cmd(x,-1;y,40;shadowlength,3;rotationz,90;horizalign,right;maxwidth,66;zoom,0.875;skewx,-0.5))(self)
			if vcheck() ~= "5_2_0" then
				(cmd(Load,"RollingNumbersMeter";))(self)
			else
				self:set_chars_wide(1);
				self:set_text_format("%.0f");
				self:set_approach_seconds(dfApproachSeconds());
			end;
		end;
	};
	
	LoadFont("_Shared2")..{
		Name="description";
		InitCommand=cmd(x,21;y,44;shadowlength,0;rotationz,90;horizalign,right;zoom,0.5;maxwidth,160);
	};
	Def.BitmapText{
		Name="styletext",
		Font="_Shared2"
	},
	SetCommand=function(self, param)
		local difftable = self:GetChild('difftable');
		local tmeter = self:GetChild('tmeter');
		local description = self:GetChild('description');
		local styletext = self:GetChild('styletext')
		local song = "";
		local step;
		local meter;
		local cdiff = param.CustomDifficulty;
		self:stoptweening();
		difftable:visible(false);
		tmeter:visible(false);
		if cdiff then
			step = param.Steps;
			meter = param.Meter;
			difftable:visible(true);
			difftable:setstate(CustomDifficultyToState[cdiff]);
			styletext:settext(step:GetChartStyle())
			--if getenv("wheelstop") == 1 and getenv("rnd_song") == 0 then
			if getenv("wheelstop") == 1 then
				song = GAMESTATE:GetCurrentSong();
				if GetAdhocPref("UserMeterType") == "CSStyle" then
					if song then
						if cdiff ~= "Edit" then
							meter = GetConvertDifficulty(song,"Difficulty_"..cdiff);
						else meter = GetConvertDifficulty(song,"Difficulty_Edit",step);
						end;
					end;
				end;
				
				description:visible(false);
				if cdiff == "Edit" then
					description:visible(true);
					description:diffuse(CustomDifficultyToColor(cdiff));
					description:strokecolor(Color("Black"));
				--20180210
					description:settext(step:GetChartName() ~= "" and step:GetChartName() or step:GetDescription());
					if description:GetText() == "" then
						description:settext("Edit");
					elseif #description:GetText() > 10 then
						description:settext( string.format("%-9s",string.sub(description:GetText(),1,9)).." ..." )
					end;
				end;
			else
				song = "";
				description:visible(false);
			end;
			if meter then
				tmeter:visible(true);
				--if getenv("rnd_song") == 0 then
				--	tmeter:settextf("%d",meter);
				--else tmeter:settext("?");
				--end;
				tmeter:strokecolor(CustomDifficultyToDarkColor(cdiff));
				if vcheck() ~= "5_2_0" then
					tmeter:targetnumber(meter);
					tmeter:diffuse(CustomDifficultyToColor(cdiff));
				else
					tmeter:set_leading_attribute{Diffuse= CustomDifficultyToColor(cdiff)};
					tmeter:set_number_attribute{Diffuse= CustomDifficultyToColor(cdiff)};
					tmeter:target_number(meter);
				end;
			end;
		else tmeter:targetnumber(0);
		end;
	end;
};

return t;
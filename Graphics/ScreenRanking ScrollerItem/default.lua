
local HighScoresType = THEME:GetMetric( Var "LoadingScreen" , "HighScoresType" );
SnamecolorSet("course");

local t = Def.ActorFrame{
	InitCommand=cmd(runcommandsonleaves,cmd(ztest,true));
	LoadActor("_song frame");

	Def.Banner{
		InitCommand=cmd(x,-264;halign,0;scaletoclipped,138,40;diffusealpha,1;fadeleft,0.5);
		SetCommand=function(self, params)
			if params.Song then
				self:LoadFromSong( params.Song );
			else self:LoadFromCourse( params.Course );
			end;
		end;
	};

	LoadFont("_shared2")..{
		InitCommand=cmd(x,-294;y,0;halign,0;zoom,0.6;shadowlength,2;maxwidth,270;maxheight,58;strokecolor,Color("Black"););
		SetCommand=function(self, params)
			if params.Song then
				if params.Song:GetDisplaySubTitle() ~= "" then
					self:y(4);
					self:settext( params.Song:GetDisplayMainTitle() );
					self:diffuse( colorcheck(params.Song,"Song") );
				else
					self:y(14);
					self:settext( params.Song:GetDisplayFullTitle() );
					self:diffuse( colorcheck(params.Song,"Song")  );
				end
			else
				self:y(14);
				self:settext( params.Course:GetDisplayFullTitle() );
				self:diffuse( colorcheck(params.Course,"Course")  );
			end
		end;
	};
	
	LoadFont("_shared2")..{
		InitCommand=cmd(x,-294;y,14;halign,0;zoom,0.4;shadowlength,2;maxwidth,376;maxheight,58;strokecolor,Color("Black"););
		SetCommand=function(self, params)
			self:visible(false);
			if params.Song then
				if params.Song:GetDisplaySubTitle() ~= "" then
					self:settext( params.Song:GetDisplaySubTitle() );
					self:diffuse( colorcheck(params.Song,"Song") );
					self:visible(true);
				end
			end
		end;
	};
};

local c
local Scores = Def.ActorFrame{
	InitCommand=function(self) c = self:GetChildren(); end;
};

for i=1,4 do
	Scores[#Scores+1] = LoadFont("_ScreenRanking common")..{
		Name="Name"..i;
		InitCommand=cmd(x,scale(i,1,4,-48,240);y,-8;zoom,0.55;shadowlength,2;maxwidth,120;);
	};
	Scores[#Scores+1] = LoadFont("_um")..{
		Name="Score"..i;
		InitCommand=cmd(x,scale(i,1,4,-48,240);y,12;zoom,0.65;shadowlength,2;maxwidth,120;strokecolor,color("0,0,0,1"));
	};
end

Scores.SetCommand=function(self,param)
	local profile = PROFILEMAN:GetMachineProfile();
	for name, child in pairs(c) do child:visible(false); end
	local sel;
	if param.Song then
		sel = param.Song;
	else sel = param.Course;
	end;
	if not sel then return end

	for i, item in pairs(param.Entries) do
		if item then
			local hsl = profile:GetHighScoreList(sel, item);
			local hs = hsl and hsl:GetHighScores();

			assert(c["Name"..i])
			assert(c["Score"..i])

			c["Name"..i]:visible(true)
			c["Score"..i]:visible(true)
			if hs and #hs > 0 then
				if hs[1]:GetPercentDP()*100.0 == 100 then
					c["Name"..i]:settext( hs[1]:GetName() );
					c["Name"..i]:diffuse(color("1,1,1,1"));
					c["Score"..i]:settext( "100%" );
					c["Score"..i]:diffuse(color("1,1,1,1"));
				elseif (hs[1]:GetPercentDP()*100.0 >= 80.0) then
					c["Name"..i]:settext( hs[1]:GetName() );
					c["Name"..i]:diffuse(color("1,1,0,1"));
					c["Score"..i]:settext( FormatPercentScore( hs[1]:GetPercentDP() ) );
					c["Score"..i]:diffuse(color("1,1,0,1"));
				else
					c["Name"..i]:settext( hs[1]:GetName() );
					c["Name"..i]:diffuse(color("0.775,0.775,0,1"));
					c["Score"..i]:settext( FormatPercentScore( hs[1]:GetPercentDP() ) );
					c["Score"..i]:diffuse(color("0.775,0.775,0,1"));
				end
			else
				c["Name"..i]:settext( "---" );
				c["Name"..i]:diffuse(color("1,1,0,0.75"));
				c["Score"..i]:settext( "0%");
				c["Score"..i]:diffuse(color("1,1,0,0.75"));
			end
		end
	end
end;

t[#t+1] = Scores

return t
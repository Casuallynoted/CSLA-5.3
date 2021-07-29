
function heigest_status(tp)
	return math.max(
		(math.floor((tp[1] / tp[7] * 100) + 0.5)),
		(math.floor((tp[2] / tp[7] * 100) + 0.5)),
		(math.floor((tp[3] / tp[7] * 100) + 0.5)),
		(math.floor((tp[4] / tp[7] * 100) + 0.5)),
		(math.floor((tp[5] / tp[7] * 100) + 0.5)),
		(math.floor((tp[6] / tp[7] * 100) + 0.5))
	);
end

function cal_flag_check(tp,weight)
	if weight > 0 then
		local mtpp = math.max(0,
			(math.floor((tp[1] / tp[7] * 100) + 0.5)),
			(math.floor((tp[2] / tp[7] * 100) + 0.5)),
			(math.floor((tp[3] / tp[7] * 100) + 0.5)),
			(math.floor((tp[4] / tp[7] * 100) + 0.5)),
			(math.floor((tp[5] / tp[7] * 100) + 0.5))
		);
		if tonumber(tp[6]) > 0 and tonumber(tp[7]) > 0 then
			if math.floor((tp[6] / tp[7] * 100) + 0.5) > mtpp then
				return false;
			end;
		end;
		return true;
	end;
	return false;
end

function mmtext(sys_tp,mtp)
	local mtextrt = {
		{ mrtext = THEME:GetString("ScreenSelectProfile","Jump") },
		{ mrtext = THEME:GetString("ScreenSelectProfile","Lift") },
		{ mrtext = THEME:GetString("ScreenSelectProfile","Hold") },
		{ mrtext = THEME:GetString("ScreenSelectProfile","Roll") },
		{ mrtext = THEME:GetString("ScreenSelectProfile","Mine") },
		{ mrtext = THEME:GetString("ScreenSelectProfile","Hand") },
	};
	setmetatable( mtextrt, { __index = function() return { mrtext = "???"} end; } ); 
	if mtp == 0 then return "???";
	end;
	local totalnum = 0;
	if #sys_tp == 7 then
		if tonumber(sys_tp[7]) then
			totalnum = tonumber(sys_tp[7]);
		end;
		for i=1,#mtextrt do
			if math.floor((tonumber(sys_tp[i]) / totalnum * 100) + 0.5) == tonumber(mtp) then
				return mtextrt[i].mrtext;
			else
				if i == #mtextrt then
					return "???";
				end;
			end;
		end;
	end;
	return "???";
end;

function sstext(mtext,pmcount)
	local stextrt = {
		{ UpperLimit = 49, srtext = "One" },
		{ UpperLimit = 199, srtext = "Two" },
		{ UpperLimit = 999, srtext = "Three" },
		{ UpperLimit = 2999, srtext = "Four" },
		{ UpperLimit = 19999, srtext = "Five" },
		{ UpperLimit = 49999, srtext = "Six" },
		{ UpperLimit = 50000, srtext = "Seven" },
	};
	setmetatable( stextrt, { __index = function()
		return { UpperLimit = 49, srtext = THEME:GetString("ScreenSelectProfile","One") }
	end; } ); 
	if mtext ~= "???" then
		for i=1,#stextrt do
			if tonumber(pmcount) <= 0 then
				return nil;
			else
				if i < #stextrt then
					if tonumber(pmcount) <= stextrt[i].UpperLimit then
						return stextrt[i].srtext;
					end;
				else
					if tonumber(pmcount) >= stextrt[i].UpperLimit then
						return stextrt[i].srtext;
					end;
				end;
			end;
		end;
	end;
	return nil;
end;

function sscolor(tp,plus,mtext,pmcount)
	local check = {
		One		= 50,
		Two		= 200,
		Three	= 1000,
		Four		= 3000,
		Five		= 20000,
		Six		= 50000,
	};
	setmetatable( check, { __index = function() return 0 end; } );
	if sstext(mtext,pmcount) and sstext(mtext,pmcount) ~= "" and sstext(mtext,pmcount) ~= "Seven" then
		local count = check[sstext(mtext,pmcount)];
		--SCREENMAN:SystemMessage(tonumber(tp)..","..plus..","..sstext(mtext,pmcount));
		if count > 0 and plus > 0 and tonumber(tp) + plus >= count then
			return true
		end;
	end;
	return false
end

function prof_card_set(sc,profile,profileid,sys_tt,sys_tp,sys_ps,tt,tp,mtp,plus,tpwidth,weightset,totalcalories,todaycalories)
	--[ja] sys系はファイルから読み出し。Afterはsys系はとノーマルが系入れ替わって入ってくる
	local a_set_x = 0;
	local a_set_y = 0;
	if sc == "After" then
		a_set_x = 16;
		a_set_y = -208;
	end;

	local op_set = Def.ActorFrame {};
--[ja] プロファイル名・プレイ曲数
	op_set[#op_set+1]=Def.ActorFrame {
		LoadFont("_shared2") .. {
			Text=profile:GetDisplayName();
			InitCommand=cmd(horizalign,right;maxwidth,150;x,94+a_set_x;y,74+a_set_y;zoom,0.9;strokecolor,Color("Black"););
		};

		LoadFont("_shared2") .. {
			InitCommand=function(self)
				self:diffuse(Color("White"));
				if sc == "After" and plus > 0 then
					self:diffuse(color("1,1,0,1"));
				end;
				self:settext(profile:GetNumTotalSongsPlayed().." 曲");
				(cmd(horizalign,right;maxwidth,150;x,96+a_set_x;y,110+a_set_y;zoom,0.8;strokecolor,Color("Black");))(self)
			end;
		};
	};
	
	if sc == "After" and plus > 0 then
		op_set[#op_set+1]=LoadFont("_um") .. {
			InitCommand=function(self)
				self:settext("+"..plus);
				(cmd(ztest,true;horizalign,right;maxwidth,80;x,-30;y,123+a_set_y;zoom,0.5;strokecolor,Color("Black");))(self)
			end;
		};
	end;

--[ja] 達成率
	op_set[#op_set+1]=Def.ActorFrame {
		Def.Sprite {
			InitCommand=function(self)
				(cmd(x,18+a_set_x;y,244+a_set_y;))(self)
				--20160418
				self:visible(false);
				if CurGameName() == "dance" or CurGameName() == "pump" then
					self:visible(true);
					self:Load(THEME:GetPathB("ScreenSelectProfile","overlay/_"..CurGameName()));
				end;
			end;
		};
		LoadFont("_shared2") .. {
			InitCommand=function(self)
				local text = 0
				--20161130
				if tonumber(sys_tt[4]) and not isnan(sys_tt[4]) then
					text = tonumber(math.min(100,math.max(0,(sys_tt[4] * 100) / 3)));
				end;
				if text >= 100 then
					self:settext("100%");
				elseif text <= 0 then
					self:settext("0%");
				else self:settext(string.format("%.2f%%", text));
				end;
				(cmd(horizalign,right;maxwidth,150;x,96+a_set_x;y,222+a_set_y;zoom,0.8;strokecolor,Color("Black");))(self)
				if sc == "After" then
					if tonumber(string.sub(sys_tt[4],1,12)) ~= tonumber(string.sub(tt[4],1,12)) then
						self:diffuse(color("1,1,0,1"));
					else self:diffuse(color("1,1,1,1"));
					end;
				end;
			end;
		};
	};
	for i=1,3 do
		local c_xset = {-13,45,103.5};
		local c_yset = 257;
		op_set[#op_set+1]=LoadFont("_um") .. {
			InitCommand=function(self)
				local text = 0;
				--20161130
				if tonumber(sys_tt[i]) and not isnan(sys_tt[i]) then
					text = tonumber(math.min(100,math.max(0,sys_tt[i] * 100)));
				end;
				if text >= 100 then
					self:settext("100%");
				elseif text <= 0 then
					self:settext("0%");
				else self:settext(string.format("%.2f%%", text));
				end;
				(cmd(ztest,true;horizalign,right;maxwidth,110;x,c_xset[i]+a_set_x;y,c_yset+a_set_y;zoom,0.45;strokecolor,Color("Black");))(self)
			end;
		};
	end;

--[ja] プレイ傾向グラフ
	op_set[#op_set+1]=LoadActor(THEME:GetPathB("ScreenEvaluation","decorations/judgegraph"))..{
		InitCommand=cmd(horizalign,left;x,-139+a_set_x;y,166+a_set_y;
					diffuse,color("0.5,0.5,0.5,1");zoomtowidth,tpwidth;zoomtoheight,10;);
	};

	local cwx = 0;
	for i=1,#sys_tp-1 do
		local g_c_table = {
			"JudgmentLine_W2",
			"JudgmentLine_W1",
			"JudgmentLine_W3",
			"JudgmentLine_W4",
			"JudgmentLine_Miss",
			"JudgmentLine_W5"
		};
		op_set[#op_set+1]=LoadActor(THEME:GetPathB("ScreenEvaluation","decorations/judgegraph"))..{
			InitCommand=function(self)
				(cmd(horizalign,left;x,-139+a_set_x+(tpwidth*(cwx / sys_tp[7]));y,166+a_set_y;zoomtoheight,10;))(self)
				if #sys_tp == 7 then
					self:zoomtowidth( tpwidth * (sys_tp[i] / sys_tp[7]) );
					(cmd(diffuse,Colors.Judgment[g_c_table[i]]))(self)
				end;
				cwx = cwx + sys_tp[i];
			end;
		};
	end;

--[ja] プレイ傾向テキスト
	for i=1,#sys_tp-1 do
		local p_x = 40*(i-1);
		op_set[#op_set+1]=LoadFont("_um") .. {
			InitCommand=function(self)
				local text = (math.floor((sys_tp[i] / sys_tp[7] * 100) + 0.5));
				self:settext(string.format("%u%%", text));
				if text >= 100 then
					self:settext("100%");
				elseif text <= 0 then
					self:settext("0%");
				end;
				(cmd(ztest,true;horizalign,right;maxwidth,80;x,-102+p_x+a_set_x;y,186+a_set_y;zoom,0.45;strokecolor,Color("Black");))(self)
			end;
		};
	end;

--[ja] プレイ傾向肩書き
	op_set[#op_set+1]=LoadFont("_shared2") .. {
		InitCommand=function(self)
			(cmd(ztest,true;horizalign,right;maxwidth,210;x,96+a_set_x;y,140+a_set_y;zoom,0.8;strokecolor,Color("Black");))(self)
			local set_sc = "";
			if sc == "After" then
				if mmtext(tp,mtp) ~= mmtext(sys_tp,mtp) or sscolor(sys_ps[1],plus,mtext,sys_ps[1]) then
					self:diffuse(color("1,1,0,1"));
				else self:diffuse(Color("White"));
				end;
			end;
			if sstext( mmtext(sys_tp,mtp) , sys_ps[1] ) then
				set_sc = THEME:GetString( "ScreenSelectProfile",sstext( mmtext(sys_tp,mtp) , sys_ps[1] ) );
			end;
			self:settext( mmtext(sys_tp,mtp)..set_sc );
		end;
	};

--[ja] 消費カロリー
	if weightset then
		for i=1,2 do
			local set_text = {
				{ "TotalCalories" , totalcalories , 0 },
				{ "TodayCalories" , todaycalories , 13 }
			};
			op_set[#op_set+1]=Def.ActorFrame {
				LoadFont("_shared2") .. {
					InitCommand=function(self)
						self:settext(THEME:GetString("ScreenSelectProfile",set_text[i][1]).." :");
						(cmd(ztest,true;horizalign,left;maxwidth,200;x,-136+a_set_x;y,290+set_text[i][3]+a_set_y;zoom,0.5;strokecolor,Color("Black");))(self)
					end;
				};
				LoadFont("_um") .. {
					InitCommand=function(self)
						self:settext(string.format("%.2f",set_text[i][2]));
						(cmd(ztest,true;horizalign,right;maxwidth,180;x,76+a_set_x;y,295+set_text[i][3]+a_set_y;zoom,0.55;strokecolor,Color("Black");))(self)
					end;
				};
				LoadFont("_shared2") .. {
					InitCommand=function(self)
						self:settext("kcal");
						(cmd(ztest,true;horizalign,left;maxwidth,120;x,80+a_set_x;y,291+set_text[i][3]+a_set_y;zoom,0.45;strokecolor,Color("Black");))(self)
					end;
				};
			};
		end;
	end;
	return op_set;
end;
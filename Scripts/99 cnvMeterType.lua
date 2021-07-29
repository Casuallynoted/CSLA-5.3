--[ja] 参考ソース
--[[waiei  - (99 cnvMeterType)]]

--[ja]参考サイト
--[[DanceDanceRevolution SP総合wiki グルーブレーダー計算式考察 (X2) - http://www21.atwiki.jp/asigami/pages/706.html]]
--[[BEMANIWiki 2nd - http://bemaniwiki.com/index.php?DanceDanceRevolution%20X3%20VS%202ndMIX%2F%B5%EC%B6%CA%A5%EA%A5%B9%A5%C8]]
--[[monoglider : ddrlv - http://monoglider.web.fc2.com/ddrlv/index.html]]

local tapsp2x={
	 0.5, 0.6, 0.9, 1.1, 1.2, 1.4, 1.7, 2.1, 2.4, 2.8,
	 3.1, 3.4, 3.7, 3.9, 4.1, 4.3, 4.5, 4.6, 4.8, 5.1,
	 5.5, 5.8, 6.2, 6.5, 6.7, 6.9, 7.2, 7.5, 7.8, 8.2,
	 8.5, 8.9, 9.2, 9.4, 9.6, 9.7, 9.8,10.1,10.5,10.6,
	10.8,11.0,11.2,11.4,11.7,12.0,12.3,12.4,12.6,12.8,
	13.0,13.2,13.3,13.4,13.5,13.8,14.0,14.1,14.3,14.5,
	14.6,14.7,14.9,15.1,15.3,15.6,16.1,16.5,16.7,16.9,
	17.0,17.1,17.2,17.3,17.3,17.3,17.4,17.5,17.5,17.5,
	17.6,17.7,17.7,17.8,17.9,17.9,18.0,18.0,18.0,18.0,
	18.0,18.1,18.2,18.3,18.4,18.6,18.9,19.1,19.3,19.5
};
local tapsp2lv100={
	 0.5,0.55, 0.6,0.65, 0.7,0.75, 0.8,0.85, 0.9,0.95,
	 1.0, 1.2, 1.4, 1.6, 1.7, 1.8, 1.9, 2.0, 2.2, 2.3,
	 2.5, 2.6, 3.0, 3.3, 3.4, 3.9, 4.3, 4.4, 4.6, 4.8,
	 5.0, 5.2, 5.4, 5.9, 6.4, 6.7, 7.0, 7.2, 7.4, 7.6,
	 7.8, 8.0, 8.3, 8.6, 9.0, 9.2, 9.4, 9.6, 9.8,10.0,
	10.2,10.5,10.7,11.0,11.3,11.6,12.0,12.0,12.2,12.4,
	12.6,12.8,13.0,13.0,13.3,13.5,13.7,14.0,14.2,14.4,
	14.5,14.5,14.6,14.8,15.0,15.2,15.4,15.6,15.8,16.0,
	16.2,16.4,16.6,16.8,17.0,17.2,17.4,17.6,17.8,18.0,
	18.2,18.4,18.6,18.8,19.0,19.2,19.4,19.6,19.8,20.0,
	20.2,20.4,20.6,20.8,21.0,21.2,21.4,21.6,21.8,22.0,
	22.2,22.4,22.6,22.8,23.0,23.2,23.4,23.6,23.8,24.0,
	24.2,24.4,24.6,24.8,25.0,25.2,25.4,25.6,25.8,26.0,
	26.2,26.4,26.6,26.8,27.0,27.2,27.4,27.6,27.8,28.0,
	28.2,28.4,28.6,28.8,29.0,29.2,29.4,29.6,29.8,30.0,
	30.2,30.4,30.6,30.8,31.0,31.2,31.4,31.6,31.8,32.0,
	32.2,32.4,32.6,32.8,33.0,33.2,33.4,33.6,33.8,34.0,
	34.2,34.4,34.6,34.8,35.0,35.2,35.4,35.6,35.8,36.0,
	36.4,36.8,37.2,37.6,38.0,38.4,38.8,39.2,39.6,40.0,
	40.5,41.0,41.5,42.0,42.5,43.0,43.5,44.0,44.5,45.0,
	45.5,46.0,46.5,47.0,47.5,48.0,48.5,49.0,49.5,50.0
};

function GetConvertDifficulty(song,dif,pstep)
	local meter = 0;
	if song then
		local songlen = math.max(song:GetLastSecond(),1);
		local songbeat = math.max(song:GetLastBeat(),1);
		local st = GAMESTATE:GetCurrentStyle():GetStepsType();
		local mplayer = GAMESTATE:GetMasterPlayerNumber();
		local step;
		
		if dif == 'Difficulty_Crazy' then dif = 'Difficulty_Hard' end;
		if dif == 'Difficulty_Freestyle' then dif = 'Difficulty_Medium' end;
		if dif == 'Difficulty_Nightmare' then dif = 'Difficulty_Hard' end;
		if dif == 'Difficulty_HalfDouble' then dif = 'Difficulty_Medium' end;
		if dif ~= 'Difficulty_Edit' then
			step = song:GetOneSteps(st,dif);
		else
			step = pstep;
		end;

		if step then
			meter = step:GetMeter();
			local bpms = step:GetTimingData():GetActualBPM();
			local bpmav = 60 * songbeat / songlen;
			local tapspoint = step:GetRadarValues(mplayer):GetValue('RadarCategory_TapsAndHolds');
			local slenpoint = 0.01 * songlen;
			tapspoint = tapspoint / slenpoint;

			local voltage = step:GetRadarValues(mplayer):GetValue('RadarCategory_Voltage');
			local stream = step:GetRadarValues(mplayer):GetValue('RadarCategory_Stream');
			local jump = step:GetRadarValues(mplayer):GetValue('RadarCategory_Jumps');
			local air = step:GetRadarValues(mplayer):GetValue('RadarCategory_Air');
			local freeze = step:GetRadarValues(mplayer):GetValue('RadarCategory_Freeze');
			local chaos = step:GetRadarValues(mplayer):GetValue('RadarCategory_Chaos');
			local hand = step:GetRadarValues(mplayer):GetValue('RadarCategory_Hands');
			
			local stops = step:GetTimingData():GetStops();
			--[ja] 平均BPM判定
			if bpmav < 300 then
				tapspoint = step:GetRadarValues(mplayer):GetValue('RadarCategory_Mines') * 0.6 + tapspoint;
				tapspoint = step:GetRadarValues(mplayer):GetValue('RadarCategory_Rolls') / 4 + tapspoint;
				tapspoint = freeze * (100/2) + tapspoint;
				--[ja] さらに低めのBPMの場合こちらも判定
				if bpmav <= 250 then
					tapspoint = voltage * (100/3) + tapspoint;
					tapspoint = stream * (100/3) + tapspoint;
				end;
				--[ja] 指譜面
				if jump + hand >= 420 then
					tapspoint = (hand * 1.85) + tapspoint;
					tapspoint = (jump * 0.8) + tapspoint;
				else
					--[jp] voltageとstreamで判定
					tapspoint = (hand * 1.5) + tapspoint;
					if (voltage * 100) + (stream * 100) >= 146 then
						--[jp] 曲の30%が早いBPMの方か判定
						if bpms[2] >= 300 and (songlen * (bpms[2] / 60)) * 0.3 <= songbeat then
							if air * 100 >= freeze * 100 then
								tapspoint = (air * 100) + tapspoint;
							else
								tapspoint = (freeze * 100) + tapspoint;
							end;
						else
							if air * 100 >= chaos * 100 then
								tapspoint = (air * (100 * 0.7)) + tapspoint;
							else
								tapspoint = (chaos * (100 * 0.3)) + tapspoint;
							end;
						end;
					elseif (voltage * 100) + (stream * 100) <= 140 then
						tapspoint = (freeze * 100) + tapspoint;
						if air * 100 >= chaos * 100 then
							tapspoint = (air * (100 * 0.7)) + tapspoint;
						else
							tapspoint = (chaos * (100 * 0.3)) + tapspoint;
						end;
					end;
				end;
			else
				tapspoint = tapspoint * 1.3;
				tapspoint = (hand * 1.5) + tapspoint;
			end;
			--[ja] 停止譜面判定
			if stops then
				if #stops >= 5 then tapspoint = #stops * 3 + tapspoint;
				end;
			end;
			tapspoint = math.round(tapspoint/10);
			tapspoint = math.max(tapspoint,1);
			if math.floor((tapspoint + 2) + 0.5) > 100 then
				meter = math.min((tapspoint / 2),#tapsp2lv100);
				tapspoint = math.max(tapspoint+1,1);
				tapspoint = math.min(tapspoint,#tapsp2lv100);
				meter = tapsp2lv100[math.max(meter,1)];
				meter = math.floor(tapsp2lv100[tapspoint] + 0.5);
			else
				meter = math.max(math.floor(tapsp2x[tapspoint+2] + 0.5),meter);
			end;
		end;
		--meter = math.floor(tapspoint + 0.5);
	end;
	return meter;
end;

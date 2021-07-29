function SelectProfileKeys()
	sGame = CurGameName()
	if sGame == "pump" then
		return "Up,Down,Left,Right,Start,Back,Select,Center,DownLeft,DownRight"
	elseif sGame == "dance" then
		return "Up,Down,Left,Right,Start,Back,Select,Up2,Down2,Left2,Right2"
	else
		return "Up,Down,Left,Right,Start,Back,Select"
	end
end

function SelectAProfileKeys()
	sGame = CurGameName()	
	if sGame == "pump" then
		return "Start,Center"
	elseif sGame == "dance" then
		return "Start"
	else
		return "Start"
	end
end

function SelectMusicKeys()
	sGame = CurGameName()
	if sGame == "pump" then
		return "Start,Center,SelectSort2,SelectSort3,JudgeChange,RivalOpen3,TargetSetOpen3,TargetSet1,TargetSet2"
	elseif sGame == "dance" then
		return "Start,SelectSort1,SelectSort2,JudgeChange,RivalOpen1,TargetSetOpen1,TargetSet1,TargetSet2"
	else
		return "Start,SelectSort1,SelectSort2,JudgeChange,RivalOpen1,TargetSetOpen1,TargetSet1,TargetSet2"
	end
end

function SelectMusicCSKeys()
	--[ja] 20160416修正
	sGame = CurGameName()
	if sGame == "pump" then
		return "JudgeChange,RivalOpen3,TargetSetOpen3,TargetSet1,TargetSet2,SetState,Start,Back,Center,Up,Down"
	elseif sGame == "dance" then
		return "JudgeChange,RivalOpen1,TargetSetOpen1,TargetSet1,TargetSet2,SetState,Start,Back,Up,Up2,Down,Down2"
	else
		return "JudgeChange,RivalOpen1,TargetSetOpen1,TargetSet1,TargetSet2,SetState,Start,Back,Up,Up2,Down,Down2"
	end
end

function EvaluationKeys()
	--[ja] 20160416修正
	sGame = CurGameName()
	if sGame == "pump" then
		return "Start,JudgeChange,RivalOpen3,Screenshot1,Screenshot2,Screenshot3,Screenshot4"
	elseif sGame == "dance" then
		return "Start,JudgeChange,RivalOpen1,Screenshot1,Screenshot2,Screenshot3,Screenshot4"
	else
		return "Start,JudgeChange,RivalOpen1,Screenshot1,Screenshot2,Screenshot3,Screenshot4"
	end
end

function SelectCSCKeys()
	sGame = CurGameName()
	if sGame == "pump" then
		return "Start,Back,Center,Left,Left3,Right,Right3"
	elseif sGame == "dance" then
		return "Start,Back,Left,Left2,Right,Right2"
	else
		return "Start,Back,Left,Left2,Right,Right2"
	end
end

function SelectSortKeys()
	sGame = CurGameName()
	if sGame == "pump" then
		return "Start,Back,Center"
	elseif sGame == "dance" then
		return "Start,Back"
	else
		return "Start,Back"
	end
end

function SelectGameplayKeys()
	--20160701
	sGame = CurGameName()
	if sGame == "pump" then
		return "ScrollNomal2,ScrollReverse2,HiSpeedUp2,HiSpeedDown2,GraphRight,GraphLeft,CoverUp,CoverDown,CoverHidden"
	elseif sGame == "dance" then
		return "ScrollNomal,ScrollReverse,HiSpeedUp,HiSpeedDown,GraphRight,GraphLeft,CoverUp,CoverDown,CoverHidden"
	else
		return "ScrollNomal,ScrollReverse,HiSpeedUp,HiSpeedDown,GraphRight,GraphLeft,CoverUp,CoverDown,CoverHidden"
	end
end

function CodeSetStateKey()
	sGame = CurGameName()
	if sGame == "pump" then
		return "@Select-UpLeft,@Select-DownLeft,@Select-DownRight,@Select-UpRight,@Select-UpRight,@Select-DownRight,@Select-DownLeft,@Select-UpLeft"
	elseif sGame == "dance" then
		return "@Select-Up,@Select-Left,@Select-Down,@Select-Right,@Select-Right,@Select-Down,@Select-Left,@Select-Up"
	else
		return "@Select-Up,@Select-Left,@Select-Down,@Select-Right,@Select-Right,@Select-Down,@Select-Left,@Select-Up"
	end
end


function csc_close_time_limit()
	return 5;
end;
function s_v2_close_time_limit()
	return 10;
end;

function incommandset(self,ac,items,drawindex)
	if ac == 1 then
 if drawindex then
		if drawindex > math.floor(items / 2) then
			(cmd(addy,100;zoomx,0;decelerate,math.min(0.4,(items -1 - drawindex)*0.07);addy,-100;rotationz,0;zoomx,1;))(self);
		elseif drawindex < math.floor(items / 2) then
			(cmd(addy,100;zoomx,0;decelerate,math.min(0.4,drawindex*0.07);addy,-100;rotationz,0;zoomx,1;))(self);
		elseif drawindex == math.floor(items / 2) then
			(cmd(addy,-100;zoomy,0;decelerate,0.2;addy,100;zoomy,1;))(self);
		end;
end;
	end;
	return self
end

function wheel_kset(sort_sst,sctext,color_set)
	return Def.ActorFrame{
		InitCommand=cmd(x,-50;y,-58;visible,false);
		SetMessageCommand=function(self,params)
			if sort_sst == 'Group' or sctext == "Group" then
				local pt_text = params.Text;
				if getenv("cgptable") then
					if getenv("cgptable")[pt_text] == pt_text then
						self:visible(true);
					else self:visible(false);
					end;
				else self:visible(false);
				end;
			else self:visible(false);
			end;
		end;
		LoadActor(THEME:GetPathG("_MusicWheelItem","parts/key"))..{
			InitCommand=cmd(shadowlength,2;);
		};
		LoadActor(THEME:GetPathG("_MusicWheelItem","parts/blur"))..{
			InitCommand=cmd(x,7;y,-9;shadowlength,2);
			SetMessageCommand=function(self,params)
				local pt_text = params.Text;
				local sort_sst = ToEnumShortString(GAMESTATE:GetSortOrder());
				local sectioncolor = getenv("wheelnotsectioncolor");
				if sectioncolor ~= nil then self:glow( sectioncolor );
				else self:glow(color_set);
				end;
			end;
		};
	};
end;

function wheel_s_bar_set(musicwheel,button,event)
	local expsc = GAMESTATE:GetExpandedSectionName();
	if musicwheel:GetSelectedType() == 'WheelItemDataType_Section' then
		if button == "Start" then
			if musicwheel:IsSettled() then
				MESSAGEMAN:Broadcast("SectionSet");
				if not IsNetConnected() then
					if event == "InputEventType_FirstPress" then
						MESSAGEMAN:Broadcast("SectionSetF");
						if expsc ~= "" then
							MESSAGEMAN:Broadcast("SectionSetR");
						end;
					end;
				end;
			end;
		end;
	end;
end;

--20180222
function wheel_shortcut(musicwheel,n_button)
	local function w_shortcut(b)
		local num = 2;
		if vcheck() ~= "5_2_0" and vcheck() ~= "5_1_0" and vcheck() ~= "5_0_10" then
			num = 1;
		end;
		if b == "EffectUp" then
			return {"NextSong",num}
		else return {"PreviousSong",-num}
		end
	end;
	if getenv("wheelstop") == 1 then
		MESSAGEMAN:Broadcast(w_shortcut(n_button)[1]);
	end;
	--if musicwheel:IsSettled() then
		musicwheel:Move(5*w_shortcut(n_button)[2]);
		musicwheel:Move(0);
	--end;
end;

function wheel_movecursor()
	local c = Def.ActorFrame{};
	c[#c+1] = Def.ActorFrame{
		InitCommand=function(self)
			self:x(SCREEN_CENTER_X);
			self:y(SCREEN_CENTER_Y-6);
		end;
		OnCommand=function(self)
			if getenv("ReloadAnimFlag") == 1 then self:playcommand("NoAnim");
			else self:playcommand("Anim");
			end;
		end;
		Def.ActorFrame{
			PreviousSongMessageCommand=cmd(stoptweening;glow,color("1,1,0,1");x,12;decelerate,0.25;glow,color("0,0,0,0");x,0;);
			-- left
			LoadActor( THEME:GetPathB("","arrow") )..{
				AnimCommand=cmd(x,-120-16;rotationz,180;diffusealpha,0;sleep,1;queuecommand,"Repeat";);
				NoAnimCommand=cmd(x,-120-16;rotationz,180;diffusealpha,0;queuecommand,"Repeat";);
				RepeatCommand=cmd(addx,12;diffusealpha,1;glow,color("1,0.7,0,1");linear,1;glow,color("0,0,0,0");addx,-12;diffusealpha,0;queuecommand,"Repeat";);
				OffCommand=cmd(stoptweening;);
			};
		
			LoadActor( THEME:GetPathB("","arrow") )..{
				AnimCommand=cmd(x,-120;rotationz,180;diffusealpha,0;sleep,1.11;queuecommand,"Repeat";);
				NoAnimCommand=cmd(x,-120;rotationz,180;diffusealpha,0;sleep,0.11;queuecommand,"Repeat";);
				RepeatCommand=cmd(addx,16;diffusealpha,1;glow,color("1,0.7,0,1");linear,0.8;glow,color("0,0,0,0");addx,-16;diffusealpha,0;sleep,0.2;queuecommand,"Repeat";);
				OffCommand=cmd(stoptweening;);
			};
		};
		Def.ActorFrame{
			NextSongMessageCommand=cmd(stoptweening;glow,color("1,1,0,1");x,-12;decelerate,0.25;glow,color("0,0,0,0");x,0;);
			-- right
			LoadActor( THEME:GetPathB("","arrow") )..{
				AnimCommand=cmd(x,120+16;diffusealpha,0;sleep,1;queuecommand,"Repeat";);
				NoAnimCommand=cmd(x,120+16;diffusealpha,0;queuecommand,"Repeat";);
				RepeatCommand=cmd(addx,-12;diffusealpha,1;glow,color("1,0.7,0,1");linear,1;glow,color("0,0,0,0");addx,12;diffusealpha,0;queuecommand,"Repeat";);
				OffCommand=cmd(stoptweening;);
			};
		
			LoadActor( THEME:GetPathB("","arrow") )..{
				AnimCommand=cmd(x,120;diffusealpha,0;sleep,1.11;queuecommand,"Repeat";);
				NoAnimCommand=cmd(x,120;diffusealpha,0;sleep,0.11;queuecommand,"Repeat";);
				RepeatCommand=cmd(addx,-16;diffusealpha,1;glow,color("1,0.7,0,1");linear,0.8;glow,color("0,0,0,0");addx,16;diffusealpha,0;sleep,0.2;queuecommand,"Repeat";);
				OffCommand=cmd(stoptweening;);
			};
		};
	};
	return c;
end;

--20180127
function rsettingset(sc)
	local rset;
	local prof_sortfiledir = PROFILEMAN:LocalProfileIDToDir(ProfIDSet(csort_pset())).."CustomSort/SongManager ";
	local prof_fsortfiledir = PROFILEMAN:LocalProfileIDToDir(ProfIDSet(csort_pset())).."CS_Favorite/SongManager ";
	local sortfiledir = THEME:GetCurrentThemeDirectory().."Other/SongManager ";
	if string.find(sc,"^UserCustom.*") then
		if FILEMAN:DoesFileExist( prof_sortfiledir.."CustomSort.txt" ) then
			rset = prof_sortfiledir.."CustomSort.txt";
			
		end;
	elseif string.find(sc,"^Favorite.*") then
		local fc_pref = ProfIDPrefCheck("FavoriteCount",ProfIDSet(csort_pset()),"1");
		if FILEMAN:DoesFileExist( prof_fsortfiledir.."Favorite"..fc_pref..".txt" ) then
			rset = prof_fsortfiledir.."Favorite"..fc_pref..".txt";
		end;
	elseif sc == "SongBranch" then
		if FILEMAN:DoesFileExist( sortfiledir.."B_Music_New.txt" ) then
			rset = sortfiledir.."B_Music_New.txt";
		end;
	end;
	return rset;
end;

--20160416
function next_s_check(p_check,event,pn,p,so)
	local button = event.GameButton;
	local locktime = 0.2;
	if CurGameName() == "pump" then
		if button == "Start" or button == "Center" then
			if p_check[p] == 0 then
				if event.type == "InputEventType_FirstPress" then
					p_check[1] = math.max(p_check[1],1);
					p_check[2] = math.max(p_check[2],1);
					MESSAGEMAN:Broadcast("StartSelectingSteps");
					if so == "play" then
						SOUND:PlayOnce(THEME:GetPathS("Common","start"));
					end;
				end;
			else
				if event.type == "InputEventType_FirstPress" then
					if p_check[p] == 1 then
						MESSAGEMAN:Broadcast("StepsChosen",{Player = pn});
						SOUND:PlayOnce(THEME:GetPathS("Common","start"));
					end;
					p_check[p] = 2;
				end;
				if p_check[1] == 2 and p_check[2] == 2 then
					MESSAGEMAN:Broadcast("SongUnchosen");
					if p_check[3] == 0 then
						SCREENMAN:GetTopScreen():lockinput(0.1);
						MESSAGEMAN:Broadcast("SelectO");
						MESSAGEMAN:Broadcast("ShowPSFO");
						p_check[3] = 1;
					elseif p_check[3] == 1 then
						if event.type == "InputEventType_FirstPress" then
							MESSAGEMAN:Broadcast("ShowEO");
							SOUND:PlayOnce(THEME:GetPathS("Common","start"));
							p_check[3] = 3;
						elseif event.type == "InputEventType_Repeat" then
							SCREENMAN:GetTopScreen():lockinput(locktime);
							p_check[3] = 2;
						end;
					elseif p_check[3] == 2 then
						MESSAGEMAN:Broadcast("ShowEO");
						SOUND:PlayOnce(THEME:GetPathS("Common","start"));
						p_check[3] = 3;
					end;
				else
					if p_check[p] == 2 then
						MESSAGEMAN:Broadcast("StartSelectingSteps");
					end;
				end;
			end;
		else p_check = next_unc(p_check);
		end;
	else
		if button == "Start" or button == "Center" then
			if p_check[3] == 0 then
				if event.type == "InputEventType_FirstPress" then
					SCREENMAN:GetTopScreen():lockinput(0.1);
					MESSAGEMAN:Broadcast("SelectO");
					MESSAGEMAN:Broadcast("ShowPSFO");
					if so == "play" then
						SOUND:PlayOnce(THEME:GetPathS("Common","start"));
					end;
					p_check[3] = 1;
				end;
			elseif p_check[3] == 1 then
				if event.type == "InputEventType_FirstPress" then
					MESSAGEMAN:Broadcast("ShowEO");
					if so == "play" then
						SOUND:PlayOnce(THEME:GetPathS("Common","start"));
					end;
					p_check[3] = 3;
				elseif event.type == "InputEventType_Repeat" then
					SCREENMAN:GetTopScreen():lockinput(locktime);
					p_check[3] = 2;
				end;
			elseif p_check[3] == 2 then
				MESSAGEMAN:Broadcast("ShowEO");
				SOUND:PlayOnce(THEME:GetPathS("Common","start"));
				p_check[3] = 3;
			end;
		else p_check[3] = 0;
		end;
	end;
	return p_check;
end;

function next_unc(p_check,kp)
	if CurGameName() == "pump" then
		if p_check[1] == 1 or p_check[2] == 1 then
			MESSAGEMAN:Broadcast("SongUnchosen");
		end;
		if p_check[1] < 2 and GAMESTATE:IsHumanPlayer(PLAYER_1) then p_check[1] = 0; end;
		if p_check[2] < 2 and GAMESTATE:IsHumanPlayer(PLAYER_2) then p_check[2] = 0; end;
	end;
	if kp == "kp" then
		if p_check[3] > 0 then p_check[3] = 0; end;
	end;
	return p_check;
end;

--[[ScreenPrompt]]
--[[ScreenTextEntry]]
local t = Def.ActorFrame {
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y);

	Def.Quad{
		BeginCommand=function(self)
			self:visible(true);
			self:zoomtowidth(SCREEN_WIDTH);
			self:zoomtoheight(SCREEN_HEIGHT);
			self:diffuse(color("0,0,0,0"));
			self:linear(0.1);
			self:diffuse(color("0.025,0.21,0.2,0.75"));
		end;
		OffCommand=function(self)
			local scf = {"None","Prof_Prof",0,{{0,0,0,0,0},{0,0,0,0,0}},{0,0,0,0,0},"Default"};
			s_envcheck(scf);
			local screen = SCREENMAN:GetTopScreen();
			if screen then
				--[ja] EDITデータを変更して保存したか
				--Trace("Question: "..screen:GetChild("Question"):GetText());
				--20170902
				if screen:GetChild("Question") then
					if screen:GetChild("Question"):GetText() == THEME:GetString("ScreenEdit","Save successful.") or 
					screen:GetChild("Question"):GetText() == THEME:GetString("ScreenEdit","Saved as SM and DWI.") or 
					screen:GetChild("Question"):GetText() == THEME:GetString("ScreenEdit","Saved as SM.") or 
					screen:GetChild("Question"):GetText() == THEME:GetString("ScreenEdit","Autosave successful.") then
						--20160718
						scf[3] = 1;
						scf[5] = {1,1,1,1,1};
						setenv("sloadcheckflag",{scf[1],scf[2],scf[3],scf[4],scf[5],scf[6]});
					end;
				end;
			end;
		end;
	};
}

return t;


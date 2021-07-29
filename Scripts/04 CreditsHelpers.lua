local function Fooled()
	local phrases = {
		"hornswaggled",
		"bamboozled",
		"hoodwinked",
		"swindled",
		"duped",
		"hoaxed",
		"fleeced",
		"shafted",
		"caboodled",
		"beguiled",
		"finagled",
		"two-timed",
		"suckered",
		"flimflammed",
		"generous"
	}
	return phrases[math.random(#phrases)]
end

local line_height= 30 -- so that actor logos can use it.

local stepmania_credits= {
	{
		{type= "c_subsection", name= "CyberiaStyle LAST APPROACH Staff"},"",
	},
	{
		{type= "cc_subsection", name= "Planner & Director"},"",
		"yukt",
	},
	{
		{type= "cc_subsection", name= "Graphic Design"},"",
		"Doctor.G","",
		"J-ed","",
		"TRIPLE:o","",
		"NEgi-MAgi","",
		"FX edge","",
		"Electric Vision","",
		"*Vertex*","",
		'tate '..'"'..'pakopako'..'"'..' 結希',"",
	},
	{
		{type= "cc_subsection", name= "Game Design"},"",
		"Tomoki.ex","",
		"QP-six","",
		"tani","",
		"クラッカーMK2","",
		"Instant_Yellow","",
		"多方 Pro","",
		"j-wat","",
		"Electric Vision","",
	},
	{
		{type= "cc_subsection", name= "Programming"},"",
		"ELEE.C","",
		"多方 Pro","",
		"うえポン","",
		"U-1K","",
		'tate '..'"'..'pakopako'..'"'..' 結希',"",
	},
	{
		{type= "cc_subsection", name= "Special Thanks To"},"",
		"ssc",{type= "minisection", name= "http://ssc.ajworld.net".."\n"},"",
		"A.C",{type= "minisection", name= "http://waiei.net".."\n"},"",
		"CL","",
		"hanubeki",{type= "minisection", name= "http://www.geocities.jp/cbrk803832".."\n"},"",
		"iF",{type= "minisection", name= "http://z-siecle.net".."\n".."”Mercurio”"},"","",
		"FLESH&BONE",{type= "minisection", name= "http://www.fleshbone.com".."\n".."”splash_intro”・”free your feeling”・”tramp”・”flash & burn”・”with imagination”・”how deep”・”grand blue”・”next stage”"},"","",
		"近未来的音楽素材屋 3104式",{type= "minisection", name= "http://cyber-rainforce.net".."\n".."“return to the earth”・”separation”"},"","",
		"サンガレ -SOUND GARAGE-",{type= "minisection", name= "http://commons.nicovideo.jp/user/23369".."\n".."”Delusion”"},"","",
		"ニコニ・コモンズ",{type= "minisection", name= "http://commons.nicovideo.jp".."\n".."”nc31896”・”nc32289”・”nc32411”"},"","",
		"studio7.com",{type= "minisection", name= "http://www.naotyu-studio7.com".."\n".."“Champ Car”・“Good Bye W.McL...”"},"","",
		"TAM Music Factory",{type= "minisection", name= "http://www.tam-music.com".."\n".."“Dilemma”"},"","",
		"Rave-SLave",{type= "minisection", name= "“The Five”".."\n"},"",
		"GURI-GURI.com",{type= "minisection", name= "http://www.guri-guri.com".."\n".."“TIMEREMIT”・“TREERUN_1”・“HIGHWAY”"},"","",
		"ザ・マッチメイカァズ",{type= "minisection", name= "http://osabisi.sakura.ne.jp/m2".."\n"},"",
		"R U S H",{type= "minisection", name= "http://rush.kiy.jp".."\n"},"",
		"propan_mode",{type= "minisection", name= "http://propanmode.net".."\n"},"",
		"soundoffice.com",{type= "minisection", name= "http://www.soundoffice.com/se".."\n"},"",
		"ASOBEAT",{type= "minisection", name= "http://www.yonao.com/asobeat".."\n"},"",
		"細田美装","",
		"04",{type= "minisection", name= "http://04.jp.org".."\n"},"",
		"CFONT",{type= "minisection", name= "http://cfont.jp".."\n"},"",
		"Typodermic Fonts",{type= "minisection", name= "http://typodermicfonts.com".."\n"},"",
		"Magique Fonts","",
		"Iconian Fonts",{type= "minisection", name= "http://iconian.com".."\n"},"",
		"BitmapMania",{type= "minisection", name= "http://bitmapmania.m78.com".."\n"},"",
		"Lovedesign co.",{type= "minisection", name= "http://www.lovedesign.tv".."\n"},"",
		"9031",{type= "minisection", name= "http://www.9031.com".."\n"},"",
		"Neogrey Creative",{type= "minisection", name= "http://www.neogrey.com".."\n"},"",
		"onezero","",
		"ÆNIGMA FONTS","",
		"CGTextures","",
		"Sean Liew","",
		"Factor I","",
		"TYPODOG",{type= "minisection", name= "http://www.typodog.com".."\n"},"",
		"Information-technology Promotion Agency Japan (IPA)",{type= "minisection", name= "http://ossipedia.ipa.go.jp/ipafont".."\n"},"",
		"M+ Font Project",{type= "minisection", name= "http://mplus-fonts.sourceforge.jp".."\n"},"",
		"WenQuanYi",{type= "minisection", name= "http://wenq.org/wqy2/index.cgi?MicroHei".."\n"},"",
		"Nanum font",{type= "minisection", name= "http://hangeul.naver.com/index.nhn".."\n"},"",
		"SWFTE International, Ltd.","",
		"Metamorphosis Professional","",
		"Kees Gajentaan","",
		"Tom C. Lai","",
	},
	{
		"",
	},
	{
		"",
	},
	{
		{type= "m_subsection", name= "StepMania 5 Staff"},"",
	},
	{
		{type= "mm_subsection", name= "the spinal shark collective (project lead)"},"",
		"AJ Kelly as freem","",
		"Jonathan Payne (Midiman)","",
		"Colby Klein (shakesoda)","",
	},
	{
		{type= "mm_subsection", name= "sm-ssc Team"},"",
		"Jason Felds (wolfman2000)","", -- Timing Segments, Split Timing, optimization
		"Thai Pangsakulyanont (theDtTvB)","", -- BMS, Split Timing, optimization
		"Alberto Ramos (Daisuke Master)","",
		"Jack Walstrom (FSX)","",
	},
	{
		{type= "mm_subsection", name= "StepMania Team"},"",
		"Chris Danford","",
		"Glenn Maynard","",
		"Steve Checkoway","",
		-- and various other contributors
	},
	{
		{type= "mm_subsection", name= "OpenITG Team"},"",
		"infamouspat","",
		"Mark Cannon (vyhd)","",
	},
	{
		{type= "mm_subsection", name= "Translators"},"",
		"John Reactor (Polish)","",
		"DHalens (Spanish)","",
		"@Niler_jp (Japanese)","",
		"Deamon007 (Dutch)","",
		{type= "mm_subsection", name= "5.0.5 update"},"",
		"Kevin O. (Thumbsy) (Dutch)","",
		"Grégory Doche (French)","",
		"Jarosław Pietras (Polish)","",
		"Alejandro G. de la Muñoza (Spanish)","",
	},
	{
		{type= "mm_subsection", name= "Other Contributors"},"",
		"Aldo Fregoso (Aldo_MX)","", -- delays and much more. StepMania AMX creator
		"A.C/@waiei","", -- custom scoring fixes + Hybrid scoring
		"cerbo","", -- lua bindings and other fun stuff
		"cesarmades","", -- pump/cmd* noteskins
		"Chris Eldridge (kurisu)","", -- dance-threepanel stepstype support
		"Christophe Goulet-LeBlanc (Kommisar)","", -- songs
		"corec","", -- various fixes
		"cybik","", -- Android port
		"dbk2","", -- mac builds, a couple actor behavior fixes, new lua bindings
		"djpohly","", -- piuio kernel module, XML compatibility, other useful stuff
		"galopin","", -- piu PlayStation2 usb mat support
		"gholms","", -- automake 1.11 support
		"juanelote","", -- SongManager:GetSongGroupByIndex, JumpToNext/PrevGroup logic mods
		"Kaox","", -- pump/default noteskin
		-- Add Graphics/CreditsLogo name.png and change your entry to a table like this to look super pro.
		{logo= "kyzentun", name= "Kyzentun"},"", -- new lua bindings, theme documentation
		"Mad Matt","", -- new lua bindings
		"NitroX72","", -- pump/frame noteskin
		"Petriform","", -- default theme music
		"桜為小鳩/Sakurana-Kobato (@sakuraponila)","", -- custom scoring fixes
		"Samuel Kim (1a2a3a2a1a)","", -- various beat mode fixes
		"hanubeki (@803832)","", -- beginner helper fix, among various other things
		"v1toko","", -- x-mode from StepNXA
		"Alfred Sorenson","", -- new lua bindings
	},
	{
		{type= "mm_subsection", name= "Special Thanks"},"",
		"A Pseudonymous Coder","", -- support
		"Bill Shillito (DM Ashura)","", -- Music (not yet though)
		"cpubasic13","", -- testing (a lot)
		"Dreamwoods","",
		"Jason Bolt (LightningXCE)","",
		"Jousway","", -- Noteskins
		"Luizsan","", -- creator of Delta theme
		"Matt1360","", -- Automake magic + oitg bro
		"Renard","",
		"Ryan McKanna (Plaguefox)","",
		"Sta Kousin","", --help with Japanese bug reports
	},
	{
		{type= "mm_subsection", name= "Shoutouts"},"",
		"The Lua team","", -- lua project lead or some shit. super nerdy but oh hell.
		{logo= "mojang", name= "Mojang AB"},"", -- minecraft forever -freem
		"Wolfire Games","", -- piles of inspiration
		"NAKET Coder","",
		"Ciera Boyd","", -- you bet your ass I'm putting my girlfriend in the credits -shakesoda
		"#KBO","",
		"Celestia Radio","", -- LOVE AND TOLERANCE
		"You showed us... your ultimate dance","",
	},
	{
		"",
	},
	{
		"Powered by Stepmania","","","",
		{logo= "stepmania_logo", name= "stepmania_logo"},"",
	},
	{
		"Copyright","",
		"StepMania is released under the terms of the MIT license.","",
		"If you paid for the program you've been " .. Fooled() .. ".","",
		"All content is the sole property of their respectful owners."
	},
	{
		"","","","",
		{logo= "ssc_logo", name= "ssc_logo"},"","","",
	},
	{
		"(C) 2004-2015 Cyberia Style Project","","","","",
		{logo= "cs_logo", name= "cs_logo"},"",
	},
}

local kyzentuns_fancy_value= 16
local special_logos= {
	kyzentun= Def.ActorMultiVertex{
		Name= "logo",
		Texture= THEME:GetPathG("CreditsLogo", "kyzentun"),
		OnCommand= function(self)
			self:SetDrawState{Mode= "DrawMode_Quads"}
			kyzentuns_fancy_value= math.random(2, 32)
			self:playcommand("fancy", {state= 0})
			self:queuecommand("normal_state")
		end,
		fancyCommand= function(self, params)
			local verts= {}
			local rlh= line_height - 2
			local sx= rlh * -1
			local sy= rlh * -.5
			local sp= rlh / kyzentuns_fancy_value
			local spt= 1 / kyzentuns_fancy_value
			local c= color("#ffffff")
			for x= 1, kyzentuns_fancy_value do
				local lx= sx + (sp * (x-1))
				local rx= sx + (sp * x)
				local ltx= spt * (x-1)
				local rtx= spt * x
				for y= 1, kyzentuns_fancy_value do
					local ty= sy + (sp * (y-1))
					local by= sy + (sp * y)
					local tty= spt * (y-1)
					local bty= spt * y
					if params.state == 1 then
						ltx= 0
						rtx= 1
						tty= 0
						bty= 1
					end
					verts[#verts+1]= {{lx, ty, 0}, {ltx, tty}, c}
					verts[#verts+1]= {{rx, ty, 0}, {rtx, tty}, c}
					verts[#verts+1]= {{rx, by, 0}, {rtx, bty}, c}
					verts[#verts+1]= {{lx, by, 0}, {ltx, bty}, c}
				end
			end
			self:SetVertices(verts)
		end,
		normal_stateCommand= function(self)
			self:linear(1)
			self:playcommand("fancy", {state= 0})
			self:queuecommand("split_state")
		end,
		split_stateCommand= function(self)
			self:linear(1)
			self:playcommand("fancy", {state= 1})
			self:queuecommand("normal_state")
		end,
	},
	mojang= Def.Actor{
		Name= "logo",
		OnCommand= function(self)
			self:GetParent():GetChild("name"):distort(.25) -- minecraft is broken, -kyz
		end
	},
	stepmania_logo= Def.Sprite{
		Name= "logo",
		OnCommand= function(self)
			self:Load(THEME:GetPathB("ScreenCompany","overlay/stepmania"));
			self:zoom(0.8);
			if (SCREENMAN:GetTopScreen():GetName() == "ScreenTTCredits" or SCREENMAN:GetTopScreen():GetName() == "ScreenTTTiCredits") then
				self:horizalign(left);
			end;
		end
	},
	ssc_logo= Def.ActorFrame{
		Name= "logo",
		Def.Quad{
			OnCommand=function(self)
				(cmd(zoomto,256*0.8,96*0.8;))(self)
				if (SCREENMAN:GetTopScreen():GetName() == "ScreenTTCredits" or SCREENMAN:GetTopScreen():GetName() == "ScreenTTTiCredits") then
					self:horizalign(left);
				end;
			end;
		};		
		LoadActor("../../_fallback/BGAnimations/ScreenInit background/ssc")..{
			OnCommand= function(self)
				self:zoom(0.8);
				if (SCREENMAN:GetTopScreen():GetName() == "ScreenTTCredits" or SCREENMAN:GetTopScreen():GetName() == "ScreenTTTiCredits") then
					self:horizalign(left);
				end;
			end
		};
	},
	cs_logo= Def.Sprite{
		Name= "logo",
		OnCommand= function(self)
			self:Load(THEME:GetPathB("ScreenCompany","overlay/cstylepro"));
			self:zoom(0.8);
			if (SCREENMAN:GetTopScreen():GetName() == "ScreenTTCredits" or SCREENMAN:GetTopScreen():GetName() == "ScreenTTTiCredits") then
				self:horizalign(left);
			end;
		end
	},
}

-- Go through the credits and swap in the special logos.
for section in ivalues(stepmania_credits) do
	for entry in ivalues(section) do
		if type(entry) == "table" and special_logos[entry.logo] then
			entry.logo= special_logos[entry.logo]
		end
	end
end

local function position_logo(self)
	local name= self:GetParent():GetChild("name")
	local name_width= name:GetZoomedWidth()
	local logo_width= self:GetZoomedWidth()
	if name:GetHAlign() == 0 then
		self:x(name:GetX() - 4 - (logo_width / 2))
	else
		self:x(name:GetX() - (name_width / 2) - 4 - (logo_width / 2))
	end
end

StepManiaCredits= {
	AddSection= function(section, pos, insert_before)
		if not section.name then
			lua.ReportScriptError("A section being added to the credits must have a name field.")
			return
		end
		if #section < 1 then
			lua.ReportScriptError("Adding a blank section to the credits doesn't make sense.")
			return
		end
		if type(pos) == "string" then
			for i, section in ipairs(stepmania_credits) do
				if section.name == pos then
					pos= i -- insert_after is default behavior
				end
			end
		end
		if pos and type(pos) ~= "number" then
			lua.ReportScriptError("Credits section '" .. tostring(pos) .. " not found, cannot use position to add new section.")
			return
		end
		pos= pos or #stepmania_credits
		if insert_before then
			pos= pos - 1
		end
		-- table.insert does funny things if you pass an index <= 0
		if pos < 1 then
			lua.ReportScriptError("Cannot add credits section at position " .. tostring(pos) .. ".")
			return
		end
		table.insert(stepmania_credits, pos, section)
	end,
	AddLineToScroller= function(scroller, text, command)
		if type(scroller) ~= "table" then
			lua.ReportScriptError("scroller passed to AddLineToScroller must be an actor table.")
			return
		end
		local actor_to_insert
		if type(text) == "string" or not text then
			actor_to_insert= Def.ActorFrame{
				Def.BitmapText{
					Font= "Common Normal",
					Text = text or "";
					OnCommand = command or lineOn;
				}
			}
		elseif type(text) == "table" then
			if text.type == "c_subsection" or text.type == "cc_subsection" or 
			text.type == "m_subsection" or text.type == "mm_subsection" then
				actor_to_insert= Def.ActorFrame{
					Def.BitmapText{
						Name= "name", Font= "_titleMenu_scroller",
						InitCommand = function(self)
							self:settext("");
							if text.name ~= "stepmania_logo" and text.name ~= "ssc_logo" and text.name ~= "cs_logo" then
								if text.name then
									self:settext(text.name);
								end;
							end;
							if command then
								(command)(self)
							else (lineOn)(self);
							end;
						end;
					},
				}
			else
				actor_to_insert= Def.ActorFrame{
					Def.BitmapText{
						Name= "name", Font= "Common Normal",
						Text = text.name or "",
						InitCommand = function(self)
							self:settext("");
							if text.name ~= "stepmania_logo" and text.name ~= "ssc_logo" and text.name ~= "cs_logo" then
								if text.name then
									self:settext(text.name);
								end;
							end;
							if command then
								(command)(self)
							else (lineOn)(self);
							end;
						end;
					},
				}
			end;
			if text.logo then
				if type(text.logo) == "string" then
					actor_to_insert[#actor_to_insert+1]= Def.Sprite{
						Name= "logo",
						InitCommand= function(self)
							-- Use LoadBanner to disable the odd dimension warning.
							self:LoadBanner(THEME:GetPathG("CreditsLogo", text.logo))
							-- Scale to slightly less than the line height for padding.
							local yscale= (line_height-2) / self:GetHeight()
							self:zoom(yscale)
							-- Position logo to the left of the name.
							if text.name ~= "stepmania_logo" and text.name ~= "ssc_logo" and text.name ~= "cs_logo" then
								position_logo(self)
							end
						end
					}
				else -- assume logo is an actor
					-- Insert positioning InitCommand.
					text.logo.InitCommand= function(self)
						if text.name ~= "stepmania_logo" and text.name ~= "ssc_logo" and text.name ~= "cs_logo" then
							position_logo(self)
						end
					end
					actor_to_insert[#actor_to_insert+1]= text.logo
				end
			end
		end
		table.insert(scroller, actor_to_insert)
	end,
	Get= function()
		-- Copy the base credits and add the copyright message at the end.
		local ret= DeepCopy(stepmania_credits)
		return ret
	end,
	SetLineHeight= function(height)
		if type(height) ~= "number" then
			lua.ReportScriptError("height passed to StepManiaCredits.SetLineHeight must be a number.")
			return
		end
		line_height= height
	end
}

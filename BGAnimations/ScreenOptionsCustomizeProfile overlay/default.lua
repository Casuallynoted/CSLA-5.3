--20160824
--[[ScreenOptionsCustomizeProfile overlay]]

-- Pester Kyzentun for an explanation if you need to customize this screen.
-- Also, this might be rewritten to us a proper customizable lua menu system
-- in the future.

-- Copy this file into your theme, then modify as needed to suit your theme.
-- Each of the things on this list has a comment marking it, so you can
-- quickly find it by searching.
-- Things you will want to change:
-- 1.  The Numpad
-- 2.  The Cursor
-- 3.  The Menu Items
-- 4.  The Menu Values
-- 4.1  The L/R indicators
-- 5.  The Menu Fader

local profile= GAMESTATE:GetEditLocalProfile();
local profile_id= GAMESTATE:GetEditLocalProfileID();

local cursor_width_padding = 16
local cursor_spacing_value = 30
local key_open = 0;

local kp_pref = ProfIDPrefCheck("KP_Setting",profile_id,"pounds");
local function kp_change(kp)
	if kp == "pounds" then
		return "kg"
	end
	return "pounds"
end;
function kp_set(kp,kps)
	if not kp then return 0 end;
	if kps == "kp" then
		return math.round(kp * 2.20462262);
	end
	return math.round(kp * 0.45359237);
end;

-- 1.  The Numpad
-- This is what sets up how the numpad looks.  See Scripts/04 NumPadEntry.lua
-- for a full description of how to customize a NumPad.
-- Note that if you provide a custom prompt actor for the NumPad, it must
-- have a SetCommand because the NumPad is used any time the player needs to
-- enter a number, and the prompt is updated by running its SetCommand.
local number_entry= new_numpad_entry{
	Name= "number_entry",
	InitCommand= cmd(diffusealpha, 0; xy, _screen.cx, _screen.cy * 1.5),
	value = LoadFont("Common Normal") .. {
		InitCommand=cmd(xy,0,-64),
		OnCommand=cmd(shadowlength,2;diffuse,color("1,0.5,0,1");strokecolor,ColorDarkTone(color("0,1,1,1")));
		SetCommand=function(self, param)
			self:maxwidth(100);
			self:zoom(1.25);
			self:settext(param[1])
		end,
	},
	button = LoadFont("Common Normal") ..{
		SetCommand=function(self, param)
			self:settext(param[1])
		end,
		OnCommand=cmd(diffuse,color("1,1,1,1");strokecolor,color("0,0,0,1");zoom,0.875),
		GainFocusCommand=cmd(finishtweening;decelerate,0.125;zoom,1;diffuse,color("1,1,1,1");strokecolor,color("0,0,0,1");),
		LoseFocusCommand=cmd(finishtweening;smooth,0.1;zoom,0.875;diffuse,color("1,1,1,1");strokecolor,color("0,0,0,1");)
	},
	button_positions = {{-cursor_spacing_value, -cursor_spacing_value}, {0, -cursor_spacing_value}, {cursor_spacing_value, -cursor_spacing_value},
		{-cursor_spacing_value, 0},   {0, 0},   {cursor_spacing_value, 0},
		{-cursor_spacing_value, cursor_spacing_value}, {0, cursor_spacing_value},   {cursor_spacing_value, cursor_spacing_value},
		{-cursor_spacing_value, cursor_spacing_value*2}, {0, cursor_spacing_value*2},   {cursor_spacing_value, cursor_spacing_value*2}},
	cursor = Def.ActorFrame {
		-- Move whole container
		MoveCommand=function(self, param)
			self:stoptweening()
			self:decelerate(0.15)
			self:xy(param[1], param[2])
			if param[3] then
				self:z(param[3])
			end
		end,
		Def.Quad {
			InitCommand=cmd(xy, 0, 2;zoomto,24,24;diffuse,color("1,0.5,0,1");diffusebottomedge,ColorDarkTone(color("1,0.5,0,0.5"));)
		}
	},
	cursor_draw= "first",
	prompt = LoadFont("Common Normal") .. {
		Name="prompt",
		InitCommand=cmd(xy,0,-96);
		OnCommand=cmd(maxwidth,130;shadowlength,2;diffuse,color("1,0.5,0,1");strokecolor,color("0,0,0,1"););
		SetCommand= function(self, params)
			self:settext(params[1])
			--20171010
			if params[1] == THEME:GetString("ScreenOptionsCustomizeProfile", "weight") then
				self:settext(params[1].."("..kp_pref..")")
			end
		end
	},
	Def.Quad {
		InitCommand=cmd(xy, 0, -12;diffuse,color("0,0,0,0.675");zoomto,140,204;)
	}
}

local function calc_list_pos(value, list)
	for i, entry in ipairs(list) do
		if entry.setting == value then
			return i
		end
	end
	return 1
end

local function item_value_to_text(item, value)
	if item.name == "weight" then
		if kp_pref == "pounds" then
			value = string.format("%s pounds (%s kg)", value, kp_set(value,"pk"));
		else value = string.format("%s kg (%s pounds)", kp_set(value,"pk"), value);
		end
	end
	if item.item_type == "bool" then
		if value then
			value= THEME:GetString("ScreenOptionsCustomizeProfile", item.true_text)
		else
			value= THEME:GetString("ScreenOptionsCustomizeProfile", item.false_text)
		end
	elseif item.item_type == "list" then
		local pos= calc_list_pos(value, item.list)
		return item.list[pos].display_name
	end
	return value
end

local char_list= {}
do
	local all_chars= CHARMAN:GetAllCharacters()
	--20161102
	--for i, char in ipairs(char_list) do
	for i, char in ipairs(all_chars) do
		char_list[#char_list+1]= {
			setting= char:GetCharacterID(), display_name= char:GetDisplayName()}
	end
end

-- Uncomment this section if you need to test the behavior of actors in the
-- character list but don't have any duncing characters to test with.
--[=[
local fake_profile_mt= {__index= {}}
local val_list= {}
local function get_set_pair(name, default)
	fake_profile_mt.__index["Get"..name]= function(self)
		return self[name]
	end
	fake_profile_mt.__index["Set"..name]= function(self, val)
		self[name]= val
	end
	val_list[#val_list+1]= {name, default}
end
get_set_pair("WeightPounds", 0)
get_set_pair("Voomax", 0)
get_set_pair("BirthYear", 0)
get_set_pair("IgnoreStepCountCalories", false)
get_set_pair("IsMale", true)
get_set_pair("Character", "dietlinde")
fake_profile_mt.__index.init= function(self)
	for i, vald in ipairs(val_list) do
		self[vald[1]]= vald[2]
	end
end

profile= setmetatable({}, fake_profile_mt)
profile:init()

char_list= {
	{setting= "shake", display_name= "soda"},
	{setting= "freem", display_name= "inc"},
	{setting= "midi", display_name= "man"},
	{setting= "kyz", display_name= "zentun"},
	{setting= "mad", display_name= "matt"},
	{setting= "db", display_name= "k2"},
}
--]=]
--20171010
--[ja] maxは7桁目まで!
local menu_items= {
	{name= "weight", get= "GetWeightPounds", set= "SetWeightPounds",
	 item_type= "number", auto_done= 100 , max= 9999999},
	{name= "voomax", get= "GetVoomax", set= "SetVoomax", item_type= "number",
	 auto_done= 10 , max= 9999999},
	{name= "birth_year", get= "GetBirthYear", set= "SetBirthYear",
	 item_type= "number", auto_done= 1000 , max= 9999},
	{name= "calorie_calc", get= "GetIgnoreStepCountCalories",
	 set= "SetIgnoreStepCountCalories", item_type= "bool",
	 true_text= "use_heart", false_text= "use_steps"},
	{name= "gender", get= "GetIsMale", set= "SetIsMale", item_type= "bool",
	 true_text= "male", false_text= "female"},
	{name= "avatar", item_type= "bool",
	 true_text= "", false_text= ""},
	{name= "scfilter", item_type= "bool",
	 true_text= "", false_text= ""},
	{name= "lccover", item_type= "bool",
	 true_text= "", false_text= ""}
}

if #char_list > 0 then
	menu_items[#menu_items+1]= {
	name= "character", item_type= "bool",
	 true_text= "", false_text= ""}
end

menu_items[#menu_items+1] = 
{name= "f_fol_setting", item_type= "bool",
 true_text= "", false_text= ""}

--if CurGameName() == "dance" then
	if #OpdName(profile,"index") > 0 then
		menu_items[#menu_items+1] = 
		{name= "rival", item_type= "bool",
		 true_text= "", false_text= ""}
	end;
	menu_items[#menu_items+1] = 
	{name= "r_file_create", item_type= "bool",
	 true_text= "", false_text= ""}
--end;

menu_items[#menu_items+1]= {name= "exit", item_type= "exit"}

local menu_cursor
local helpst
local menu_pos= 1
local menu_start= SCREEN_TOP + 70+60
if #menu_items > 6 then
	menu_start= SCREEN_TOP + 34+60
end
local menu_x= ( SCREEN_CENTER_X * 0.25 ) + 20
local value_x= ( SCREEN_CENTER_X * 0.25 ) + 276
local fader
local cursor_on_menu= "main"
local menu_item_actors= {}
local menu_values= {}
local list_pos= 0
local active_list= {}
local left_showing= false
local right_showing= false

local function fade_actor_to(actor, alf)
	actor:stoptweening()
	actor:smooth(.15)
	actor:diffusealpha(alf)
end

local function update_menu_cursor()
	local item= menu_item_actors[menu_pos]
	menu_cursor:playcommand("Move", {item:GetX(), item:GetY()})
	menu_cursor:playcommand("Fit", item)
	helpst:playcommand("Set")
end

local function update_list_cursor()
	local valactor= menu_values[menu_pos]
	valactor:playcommand("Set", {active_list[list_pos].display_name})
	if list_pos > 1 then
		if not left_showing then
			valactor:playcommand("ShowLeft")
			left_showing= true
		end
	else
		if left_showing then
			valactor:playcommand("HideLeft")
			left_showing= false
		end
	end
	if list_pos < #active_list then
		if not right_showing then
			valactor:playcommand("ShowRight")
			right_showing= true
		end
	else
		if right_showing then
			valactor:playcommand("HideRight")
			right_showing= false
		end
	end
end

local function input(event)
	local pn= event.PlayerNumber
	if not pn then return false end
	if event.type == "InputEventType_Release" then return false end
	local button= event.GameButton
	if key_open == 0 and event.type == "InputEventType_FirstPress" then
		key_open = 1;
	end
	if key_open == 1 then
		local item= menu_items[menu_pos]
		if cursor_on_menu == "main" then
			if button == "Start" then
				if item.item_type == "bool" then
					if item.name == "rival" then
						MESSAGEMAN:Broadcast("StartButton");
						SCREENMAN:SetNewScreen("ScreenOptionsManageProfilesPLoad");
					elseif item.name == "r_file_create" then
						MESSAGEMAN:Broadcast("StartButton");
						SCREENMAN:SetNewScreen("ScreenOptionsRFileCreate");
					elseif item.name == "f_fol_setting" then
						MESSAGEMAN:Broadcast("StartButton");
						SCREENMAN:SetNewScreen("ScreenFavoriteSetting");
					elseif item.name == "avatar" then
						MESSAGEMAN:Broadcast("StartButton");
						SCREENMAN:AddNewScreenToTop("ScreenSelectAvatar");
					elseif item.name == "scfilter" then
						MESSAGEMAN:Broadcast("StartButton");
						SCREENMAN:SetNewScreen("ScreenSCFilterCustomize");
					elseif item.name == "lccover" then
						MESSAGEMAN:Broadcast("StartButton");
						SCREENMAN:SetNewScreen("ScreenLCoverCustomize");
					elseif item.name == "character" then
						MESSAGEMAN:Broadcast("StartButton");
						SCREENMAN:SetNewScreen("ScreenCharacterCustomize");
					else
						MESSAGEMAN:Broadcast("DirectionRButton");
						local value= not profile[item.get](profile)
						menu_values[menu_pos]:playcommand(
							"Set", {item_value_to_text(item, value)})
						profile[item.set](profile, value)
					end;
				elseif item.item_type == "number" then
					--fade_actor_to(fader, .8)
					fade_actor_to(number_entry.container, 1)
					if item.name == "weight" and kp_pref == "kg" then
						number_entry.value= kp_set(profile[item.get](profile),"pk")
					else number_entry.value= profile[item.get](profile)
					end
					number_entry.value_actor:playcommand("Set", {number_entry.value,item.name})
					number_entry.auto_done_value= item.auto_done
					number_entry.max_value= item.max
					number_entry:update_cursor(number_entry.cursor_start)
					MESSAGEMAN:Broadcast("StartButton");
					number_entry.prompt_actor:playcommand(
						"Set", {THEME:GetString("ScreenOptionsCustomizeProfile", item.name)})
					cursor_on_menu= "numpad"
				elseif item.item_type == "list" then
					cursor_on_menu= "list"
					active_list= menu_items[menu_pos].list
					list_pos= calc_list_pos(
						profile[menu_items[menu_pos].get](profile), active_list)
					update_list_cursor()
				elseif item.item_type == "exit" then
					PROFILEMAN:SaveLocalProfile(profile_id);
					MESSAGEMAN:Broadcast("StartButton");
					SetAdhocPref("KP_Setting",kp_pref,profile_id );
					SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToNextScreen")
				end
			elseif button == "Back" then
				MESSAGEMAN:Broadcast("BackButton");
				SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToPrevScreen")
			elseif button == "Select" then
				kp_pref = kp_change(kp_pref);
				--if item.name == "weight" then
					local item= menu_items[1]
					if item.get then
						local value_text = item_value_to_text(item, profile[item.get](profile))
						--SCREENMAN:SystemMessage(item.name.." / "..value_text)
						menu_values[1]:playcommand(
							"Set", {item_value_to_text(value_text, value_text)})
					end;
					MESSAGEMAN:Broadcast("DirectionButton");
				--end;
			else
				if button == "MenuLeft" or button == "MenuUp" then
					MESSAGEMAN:Broadcast("DirectionButton");
					if menu_pos > 1 then menu_pos= menu_pos - 1 end
					update_menu_cursor()
				elseif button == "MenuRight" or button == "MenuDown" then
					MESSAGEMAN:Broadcast("DirectionButton");
					if menu_pos < #menu_items then menu_pos= menu_pos + 1 end
					update_menu_cursor()
				end
			end
		elseif cursor_on_menu == "numpad" then
			local done= number_entry:handle_input(button)
			if done then
				local item= menu_items[menu_pos]
				if item.name == "weight" and kp_pref == "kg" then
					profile[item.set](profile, kp_set(number_entry.value,"kp"))
					menu_values[menu_pos]:playcommand(
						"Set", {item_value_to_text(item, kp_set(number_entry.value,"kp"))})
				else
					profile[item.set](profile, number_entry.value)
					menu_values[menu_pos]:playcommand(
						"Set", {item_value_to_text(item, number_entry.value)})
				end
				--fade_actor_to(fader, 0)
				MESSAGEMAN:Broadcast("StartButton");
				fade_actor_to(number_entry.container, 0)
				cursor_on_menu= "main"
			else
				MESSAGEMAN:Broadcast("DirectionButton");
				--SCREENMAN:SystemMessage(kp_pref)
			end
		elseif cursor_on_menu == "list" then
			if button == "MenuLeft" or button == "MenuUp" then
				MESSAGEMAN:Broadcast("DirectionButton");
				if list_pos > 1 then list_pos= list_pos - 1 end
				update_list_cursor()
				menu_values[menu_pos]:playcommand("PressLeft")
			elseif button == "MenuRight" or button == "MenuDown" then
				MESSAGEMAN:Broadcast("DirectionButton");
				if list_pos < #active_list then list_pos= list_pos + 1 end
				update_list_cursor()
				menu_values[menu_pos]:playcommand("PressRight")
			elseif button == "Start" then
				MESSAGEMAN:Broadcast("DirectionRButton");
				profile[menu_items[menu_pos].set](profile, active_list[list_pos].setting)
				local valactor= menu_values[menu_pos]
				left_showing= false
				right_showing= false
				valactor:playcommand("HideLeft")
				valactor:playcommand("HideRight")
				cursor_on_menu= "main"
			end
		end
	end
end

local args= {
	Def.Actor{
		OnCommand= function(self)
			update_menu_cursor()
			SCREENMAN:GetTopScreen():AddInputCallback(input)
		end;
		StartButtonMessageCommand=function(self)
			SOUND:PlayOnce(THEME:GetPathS("Common","start"));
		end;
		BackButtonMessageCommand=function(self)
			SOUND:PlayOnce(THEME:GetPathS("_Screen","cancel"));
		end;
		DirectionButtonMessageCommand=function(self)
			SOUND:PlayOnce(THEME:GetPathS("_common","value"));
		end;
		DirectionRButtonMessageCommand=function(self)
			SOUND:PlayOnce(THEME:GetPathS("_common","row"));
		end;
	};
}
-- 2.  The Cursor
-- This is the cursor on the main portion of the menu.
-- It needs to have Move and Fit commands for when it's moved to a new
-- item on the list.
args[#args+1]=Def.ActorFrame {
	Name= "menu_cursor", InitCommand= function(self)
		menu_cursor= self
	end,
	-- Move whole container
	MoveCommand=function(self, param)
		self:stoptweening()
		self:decelerate(0.05)
		self:xy(SCREEN_CENTER_X+((SCREEN_WIDTH/6)/2), param[2])
		if param[3] then
			self:z(param[3])
		end
	end,
	--
	Def.Quad {
		InitCommand=cmd(y,3;diffuse,color("1,0.5,0,0.5");diffuserightedge,color("1,1,0,0");
					zoomtowidth,SCREEN_WIDTH+(SCREEN_WIDTH/6);zoomtoheight,20;)
	};

};

args[#args+1]=Def.ActorFrame {
	InitCommand=cmd(playcommand,"Set");
	LoadActor( THEME:GetPathB("ScreenSelectProfile","overlay/avatar_frame") )..{
		Name="a_frame";
		InitCommand=cmd(x,SCREEN_LEFT+60;y,SCREEN_TOP+112;zoomx,-1;shadowlength,2;);
	};
	Def.Sprite{
		Name="a_image";
		OnCommand=cmd(croptop,1;decelerate,0.15;croptop,0;);
	};
	SetCommand=function(self)
		local a_frame = self:GetChild('a_frame');
		local a_image = self:GetChild('a_image');
		a_frame:visible(false);
		a_image:visible(false);
		if FILEMAN:DoesFileExist( ProfIDPrefCheck("ProfAvatar",profile_id,"Off") ) then 
			a_frame:visible(true);
			a_image:visible(true);
			a_image:Load( ProfIDPrefCheck("ProfAvatar",profile_id,"Off") );
			(cmd(stoptweening;scaletofit,0,0,60,60;x,SCREEN_LEFT+50;y,SCREEN_TOP+96;croptop,1;decelerate,0.15;croptop,0;))(a_image)
		end;
	end;
	StartButtonMessageCommand=function(self,params)
		if params then
			if params.State == "AvatarSet" then
				self:playcommand("Set");
			end;
		end;
	end;
};

-- Note that the "character" item in the menu only shows up if there are
-- characters to choose from.  You might want to adjust positioning for that.
for i, item in ipairs(menu_items) do
	local item_y= menu_start + ((i-1) * 22)
	-- 3.  The Menu Items
	-- This creates the actor that will be used to show each item on the menu.
	args[#args+1]= Def.BitmapText{
		Name= "menu_" .. item.name, Font= "Common Normal",
		Text= THEME:GetString("ScreenOptionsCustomizeProfile", item.name),
		InitCommand= function(self)
			-- Note that the item adds itself to the list menu_item_actors.  This
			-- is so that when the cursor is moved, the appropriate item can be
			-- easily fetched for positioning and sizing the cursor.
			-- Note the ActorFrames have a width of 1 unless you set it, so when
			-- you change this from an BitmapText to a ActorFrame, you will have
			-- to make the FitCommand of your cursor look at the children.
			menu_item_actors[i]= self
			self:xy(menu_x, item_y)
			self:zoom(0.8);
			self:maxwidth(260);
			self:shadowlength(2);
			if item.name == "exit" then
				self:diffuse(color("0,1,1,1"));
				self:strokecolor(ColorDarkTone(color("1,0.5,0,1")));
			else
				self:diffuse(color("1,0.65,0,1"));
				self:strokecolor(Color("Black"));
			end;
			self:horizalign(left)
		end
	}
	if item.get then
		local value_text= item_value_to_text(item, profile[item.get](profile))
		-- 4.  The Menu Values
		-- Each of the values needs to have a SetCommand so it can be updated
		-- when the player changes it.
		-- And ActorFrame is used because values for list items need to have
		-- left/right indicators for when the player is making a choice.
		local value_args= {
			Name= "value_" .. item.name,
			InitCommand= function(self)
				-- Note that the ActorFrame is being added to the list menu_values
				-- so it can be easily fetched and updated when the value changes.
				menu_values[i]= self
				self:xy(value_x, menu_start + ((i-1) * 22))
			end,
			Def.BitmapText{
				Name= "val", Font= "Common Normal", Text= value_text,
				InitCommand= function(self)
					self:zoom(0.8);
					self:shadowlength(2);
					self:diffuse(color("1,1,1,1"));
					self:strokecolor(color("0,0,0,1"));
					self:horizalign(left)
				end,
				SetCommand= function(self, param)
					self:settext(param[1])
				end,
			}
		}
		if item.item_type == "list" then
			-- 4.1  The L/R indicators
			-- The L/R indicators are there to tell the player when there is a
			-- choice to the left or right of the choice they are on.
			-- Note that they are placed inside the ActorFrame for the value, so
			-- when commands are played on the ActorFrame, they are played for the
			-- indicators too.
			-- The commands are ShowLeft, HideLeft, PressLeft, and the same for
			-- Right.
			-- Note that the right indicator has a SetCommand so it sees when the
			-- value changes and checks the new width to position itself.
			-- Show/Hide is only played when the indicator changes state.
			-- Command execution order: Set, Show/Hide (if change occurred), Press
			value_args[#value_args+1]= Def.ActorMultiVertex{
				InitCommand= function(self)
					self:SetVertices{
						{{-10, 0, 0}, color("0,1,1,1")}, {{0, -10, 0}, color("0,1,1,1")},
						{{0, 10, 0}, color("0,1,1,1")}}
					self:SetDrawState{Mode= "DrawMode_Triangles"}
					self:x(-8)
					self:y(3)
					self:visible(false)
					self:playcommand("Set", {value_text})
				end,
				ShowLeftCommand= cmd(visible, true),
				HideLeftCommand= cmd(visible, false),
				PressLeftCommand= cmd(stoptweening;zoom,1.25;linear,0.05;zoom,1),
			}
			value_args[#value_args+1]= Def.ActorMultiVertex{
				InitCommand= function(self)
					self:SetVertices{
						{{10, 0, 0}, color("0,1,1,1")}, {{0, -10, 0}, color("0,1,1,1")},
						{{0, 10, 0}, color("0,1,1,1")}}
					self:SetDrawState{Mode= "DrawMode_Triangles"}
					self:y(3)
					self:visible(false)
				end,
				SetCommand= function(self)
					local valw= self:GetParent():GetChild("val"):GetWidth()
					self:x(valw+7)
				end,
				ShowRightCommand= cmd(visible, true),
				HideRightCommand= cmd(visible, false),
				PressRightCommand= cmd(stoptweening;zoom,1.25;linear,0.05;zoom,1),
			}
		end
		args[#args+1]= Def.ActorFrame(value_args)
	end
end

local _height = (#menu_items) * 24

args[#args+1]=LoadFont("Common Normal") .. {
	Name= "helpst";
	InitCommand= function(self)
		helpst= self;
	end;
	SetCommand=function(self)
		(cmd(stoptweening;horizalign,left;x,WideScale(SCREEN_CENTER_X * 0.1,SCREEN_CENTER_X * 0.25);y,SCREEN_BOTTOM-80;
		maxwidth,(SCREEN_WIDTH*1.575-10);zoom,0.575;strokecolor,color("0,0,0,1");))(self)
		--self:settext("");
		--if param[1] then
			self:settext( THEME:GetString("ScreenOptionsCustomizeProfile", menu_items[menu_pos].name.."help") );
		--end;
	end;
};

args[#args+1]= number_entry:create_actors()
--Trace("CGraphicFile : "..CGraphicFile());

args[#args+1]=LoadFont("_shared2") .. {
	InitCommand=function(self)
		self:settext( profile:GetDisplayName() );
		--self:settext( CAvatarFile2() );
		(cmd(horizalign,left;x,SCREEN_LEFT+100;y,SCREEN_TOP+70;maxwidth,250;zoom,0.9;strokecolor,Color("Black");))(self)
	end;
};

return Def.ActorFrame(args)

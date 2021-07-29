local t = Def.ActorFrame{};
local count = tonumber(GetAdhocPref("CSLCreditFlag"));

-- To add a section to the credits, use the following:
-- local theme_credits= {
-- 	name= "Theme Credits", -- the name of your section
-- 	"Me", -- The people you want to list in your section.
-- 	"Myself",
-- 	"My other self",
--  {logo= "pro_dude", name= "Pro self"}, -- Someone who has a logo image.
--     -- This logo image would be "Graphics/CreditsLogo pro_dude.png".
-- }
-- StepManiaCredits.AddSection(theme_credits)
--
-- If you want to add your section after an existing section, use the following:
-- StepManiaCredits.AddSection(theme_credits, 7)
--
-- Or position can be the name of a section to insert after:
-- StepManiaCredits.AddSection(theme_credits, "Special Thanks")
--
-- Or if you want to add your section before a section:
-- StepManiaCredits.AddSection(theme_credits, "Special Thanks", true)

-- StepManiaCredits is defined in _fallback/Scripts/04 CreditsHelpers.lua.

local line_on = cmd(maxwidth,SCREEN_WIDTH*1.15-110;zoom,0.875;strokecolor,color("#000000");)
local section_on = cmd(maxwidth,SCREEN_WIDTH-100;diffuse,color("#00FFFF");strokecolor,color("#FF660066");shadowlengthx,0;shadowlengthy,2;)
local minisection_on = cmd(maxwidth,SCREEN_WIDTH*2-120;y,7;zoom,0.45;diffuse,color("#CCCCCC");strokecolor,color("#000000");)
local c_subsection_on = cmd(maxwidth,SCREEN_WIDTH-100;diffuse,color("#00FFFF");strokecolor,color("#FF660066");shadowlengthx,0;shadowlengthy,2;)
local cc_subsection_on = cmd(maxwidth,SCREEN_WIDTH-100;diffuse,color("#00FFFF");strokecolor,color("#00000066");shadowlengthx,0;shadowlengthy,2;)
local m_subsection_on = cmd(maxwidth,SCREEN_WIDTH-100;diffuse,color("#FFFF00");strokecolor,color("#FF660066");shadowlengthx,0;shadowlengthy,2;)
local mm_subsection_on = cmd(maxwidth,SCREEN_WIDTH-100;diffuse,color("#FFFF00");strokecolor,color("#00000066");shadowlengthx,0;shadowlengthy,2;)
local item_padding_start = 20;
local line_height= 16
-- Tell the credits table the line height so it can use it for logo sizing.
StepManiaCredits.SetLineHeight(line_height)

local creditScroller = Def.ActorScroller {
	SecondsPerItem = 0.325;
	NumItemsToDraw = 50;
	TransformFunction = function( self, offset, itemIndex, numItems)
		if type(self) == "string" then
			line_height= 16
		end;
		self:y(line_height*offset)
	end;
	OnCommand = cmd(scrollwithpadding,item_padding_start,70);
}

-- Add sections with padding.
for section in ivalues(StepManiaCredits.Get()) do
	StepManiaCredits.AddLineToScroller(creditScroller, section.name, section_on)
	for name in ivalues(section) do
		if name.type == "c_subsection" then
			StepManiaCredits.AddLineToScroller(creditScroller, name, c_subsection_on)
		elseif name.type == "cc_subsection" then
			StepManiaCredits.AddLineToScroller(creditScroller, name, cc_subsection_on)
		elseif name.type == "m_subsection" then
			StepManiaCredits.AddLineToScroller(creditScroller, name, m_subsection_on)
		elseif name.type == "mm_subsection" then
			StepManiaCredits.AddLineToScroller(creditScroller, name, mm_subsection_on)
		elseif name.type == "minisection" then
			StepManiaCredits.AddLineToScroller(creditScroller, name, minisection_on)
		else
			StepManiaCredits.AddLineToScroller(creditScroller, name, line_on)
		end
	end
	StepManiaCredits.AddLineToScroller(creditScroller)
	StepManiaCredits.AddLineToScroller(creditScroller)
end

local timer = (creditScroller.SecondsPerItem * (#creditScroller + item_padding_start) + 15)
creditScroller.BeginCommand=function(self)
	SCREENMAN:GetTopScreen():PostScreenMessage( 'SM_MenuTimer', timer );
end;

t[#t+1] = Def.Quad{
	InitCommand=cmd(Center;FullScreen;diffuse,color("0,0,0,1"););
	OnCommand=cmd(sleep,2;linear,2;diffusealpha,0;sleep,timer-8;linear,2;diffusealpha,1);
};

t[#t+1] = Def.ActorFrame{
	creditScroller..{
		InitCommand=cmd(CenterX;y,SCREEN_BOTTOM-130),
	};
	LoadFont("Common Normal") .. {
		OnCommand=cmd(Center;zoomx,1.175;diffuse,color("1,0.1,0.2,1");strokecolor,color("1,1,1,1");diffusealpha,0;
					sleep,timer-8;linear,0.5;diffusealpha,1;settext,"THANK YOU FOR USING!";);
	};
};

if count < 2 then
	--local topScreenName = SCREENMAN:GetTopScreen():GetName();
	setenv("CSLCreditFlag",tonumber(GetAdhocPref("CSLCreditFlag")));
	if tonumber(getenv("CSLCreditFlag")) == 0 then
		t[#t+1] = Def.ActorFrame{
			InitCommand=cmd(y,SCREEN_TOP);
			OnCommand=cmd(sleep,4;linear,0.2;zoomy,0;);
			Def.Quad{
				InitCommand=cmd(horizalign,left;y,32;cropright,1;cropbottom,1;zoomtowidth,SCREEN_WIDTH;zoomtoheight,40*0.75;
							diffuse,color("0,0.5,0.5,0.5");diffuseleftedge,color("0,0,0,0.8"););
				OnCommand=cmd(sleep,0.5+0.25;linear,0.1;cropright,0;cropbottom,0;);
			};
			LoadFont("_Shared2") .. {
				InitCommand=function(self)
					(cmd(x,(SCREEN_WIDTH*0.1)+24;horizalign,left;zoom,0.65;y,32-2;maxwidth,SCREEN_WIDTH*1.35-40;diffuse,color("1,1,0,1");strokecolor,Color("Black");))(self)
					self:settext(string.format( THEME:GetString("ScreenCredits","Added1"),THEME:GetString("OptionTitles","Credits") ));
				end;
				OnCommand=cmd(cropright,1;sleep,0.5+0.25;decelerate,0.35;cropright,0;diffusealpha,1;);
			};
		};
		setenv("CSLCreditFlag",count + 1);
	end;
	SetAdhocPref("CSLCreditFlag",count + 1);
end;

return t;

--20160420
local t = Def.ActorFrame {};

t[#t+1] = Def.ActorFrame {
	LoadFont("_shared4") .. {
		Name="State";
		InitCommand=cmd(uppercase,true;zoom,0.65;horizalign,left;shadowlength,1;maxwidth,SCREEN_WIDTH;diffuse,color("0,0,0,1"));
	};
	LoadFont("_shared4") .. {
		Name="ServerName";
		InitCommand=cmd(y,14;horizalign,left;zoom,0.475;shadowlength,1;maxwidth,SCREEN_WIDTH;diffuse,color("0,0,0,1");strokecolor,color("1,1,0,1"));
	};
	BeginCommand=function(self)
		local state = self:GetChild('State');
		local servername = self:GetChild('ServerName');
		if IsNetConnected() then
			state:strokecolor( color("1,1,0,1") );
			state:settext( THEME:GetString("ScreenTitleMenu","Network OK") );
			servername:visible(true);
			servername:settext(  string.format(THEME:GetString("ScreenTitleMenu","Connected to %s"), GetServerName()) );
			GAMESTATE:SetTemporaryEventMode(true);
		else
			state:strokecolor( color("0.75,0.75,0.75,1") );
			state:settext( THEME:GetString("ScreenTitleMenu","Offline") );
			servername:visible(false);
			servername:settext("");
			GAMESTATE:SetTemporaryEventMode(false);
		end;
	end;
	--netstatecheck()
	NetConnectionSuccessMessageCommand=function(self)
		local state = self:GetChild('State');
		local servername = self:GetChild('ServerName');
		state:strokecolor( color("1,1,0,1") );
		state:settext( THEME:GetString("ScreenTitleMenu","Network OK") );
		servername:visible(true);
		servername:settext(  string.format(THEME:GetString("ScreenTitleMenu","Connected to %s"), GetServerName()) );
	end;
	NetConnectionFailedMessageCommand=function(self)
		local state = self:GetChild('State');
		local servername = self:GetChild('ServerName');
		state:strokecolor( color("0.75,0.75,0.75,1") );
		state:settext( THEME:GetString("ScreenTitleMenu","Offline") );
		servername:visible(false);
		servername:settext("");
		GAMESTATE:SetTemporaryEventMode(false);
	end;
};

return t;
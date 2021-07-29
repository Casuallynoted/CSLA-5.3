
local pay = GAMESTATE:GetCoinMode() == 'CoinMode_Pay';
local premium = GAMESTATE:GetPremium();
local stf = "";
if CurGameName() ~= "dance" then stf = CurGameName().."_";
end;

local t = Def.ActorFrame{};

if pay then
	if premium == 'Premium_DoubleFor1Credit' or premium == 'Premium_2PlayersFor1Credit' then
		t[#t+1] = LoadActor("premium_back")..{
			InitCommand=cmd(CenterX;y,SCREEN_BOTTOM-120+5;zoomtowidth,SCREEN_WIDTH);
			OnCommand=cmd(diffuseshift;effectcolor1,color("0.4,0.4,0.4,0.4");effectcolor2,color("0.8,0.8,0.8,0.8");effectperiod,3);
		};
		t[#t+1] = LoadActor("information")..{
			InitCommand=cmd(CenterX;y,SCREEN_BOTTOM-132+5;zoomto,SCREEN_WIDTH,18;customtexturerect,0,0,SCREEN_WIDTH/self:GetWidth(),1;ztest,true);
			OnCommand=cmd(texcoordvelocity,0.15,0;diffuseshift;effectcolor1,color("0,1,1,1");effectcolor2,color("1,1,0,0.75");effectperiod,4);
		};
		if premium == 'Premium_DoubleFor1Credit' then
			t[#t+1] = LoadActor(stf.."doubles_premium")..{
				InitCommand=cmd(CenterX;y,SCREEN_BOTTOM-112+5;zoomto,SCREEN_WIDTH,24;customtexturerect,0,0,SCREEN_WIDTH/self:GetWidth(),1;ztest,true);
				OnCommand=cmd(texcoordvelocity,0.1,0;diffuseshift;effectcolor1,color("0.75,0.75,0.75,0.75");effectcolor2,color("1,1,1,1");effectperiod,3);
			};
		elseif premium == 'Premium_2PlayersFor1Credit' then
			t[#t+1] = LoadActor("joint_premium")..{
				InitCommand=cmd(CenterX;y,SCREEN_BOTTOM-112+5;zoomto,SCREEN_WIDTH,24;customtexturerect,0,0,SCREEN_WIDTH/self:GetWidth(),1;ztest,true);
				OnCommand=cmd(texcoordvelocity,0.1,0;diffuseshift;effectcolor1,color("0.75,0.75,0.75,0.75");effectcolor2,color("1,1,1,1");effectperiod,3);
			};
		end;
	end;
end;

return t;
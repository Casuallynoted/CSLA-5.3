local t = Def.ActorFrame{
	Def.ActorFrame {
		Condition=GAMESTATE:GetPlayMode() ~= 'PlayMode_Battle' and GAMESTATE:GetPlayMode() ~= 'PlayMode_Rave';

		Def.ActorFrame{
			Condition=not GAMESTATE:HasEarnedExtraStage();
			LoadActor("normal")..{
			};
		};

		Def.ActorFrame{
			Condition=GAMESTATE:HasEarnedExtraStage() and GAMESTATE:IsExtraStage() and not GAMESTATE:IsExtraStage2();
			LoadActor("extra")..{
			};
		};
		
		Def.ActorFrame{
			Condition=GAMESTATE:HasEarnedExtraStage() and GAMESTATE:IsExtraStage2() and not GAMESTATE:IsExtraStage();
			LoadActor("extra")..{
			};
		};
	};

	Def.ActorFrame {
		Condition=GAMESTATE:GetPlayMode() == 'PlayMode_Battle' or GAMESTATE:GetPlayMode() == 'PlayMode_Rave';

		LoadActor("normal")..{
		};
	};
};

return t;
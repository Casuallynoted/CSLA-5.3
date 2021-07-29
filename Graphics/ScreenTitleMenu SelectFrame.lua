return LoadFont("_shared4") .. {
	InitCommand=function(self)
		self:settextf( Screen.String("SelectFrame"), GetAdhocPref('FrameSet') );
	end
};
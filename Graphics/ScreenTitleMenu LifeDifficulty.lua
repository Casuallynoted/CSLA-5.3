return LoadFont("_titleMenu_scroller")..{
	Text=LifeDiffSetStr();
	AltText="";
	BeginCommand=function(self)
		self:settextf( Screen.String("LifeDifficulty"), LifeDiffSetStr() );
	end
};
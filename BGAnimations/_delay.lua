local seconds = ...;
assert(seconds)
return Def.Actor{
	OnCommand=cmd(sleep,seconds);
};
-- theme identification:
themeInfo = {
	ProductCode = "CSL-001",
	Name = "CyberiaStyle LAST APPROACH",
	CSLVerStr = "CSL VERSION",
	Version = "L-12",	--[ja] 必ず 「L-」 をつける
	Rev = 2,			--[ja] 修正版revision 修正版01
	Dev = false,		--[ja] Development 開発中
	Pdv = false,		--[ja] Precedence distribution version 先行配布版
	Date = "20180314",
	Revision = string.format("%03i", 37),
};
--format ex : "Version L-2_Rev 01 Development",
--format ex : "Rev 03 Precedence distribution version",

function GetThemeInfo(status)
	return themeInfo[status];
end;

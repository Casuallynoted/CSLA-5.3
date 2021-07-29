local cset;
local ctable = {};
local rgset;
cset = split(",", CGraphicFile());
if #cset > 0 then
	for i=1,#cset do
		table.insert(ctable,cset[i])
	end;
	rgset = ctable[math.random(#ctable)];
end;
local asety = 0;

function covermirror(self,styles)
	local yset = 24;
	--[ja] 2つにして反転表示
	local set_wzoom = (ColumnChecker(styles)/2) / self:GetWidth();
	local set_height = self:GetHeight() * set_wzoom;
	--[ja] 横がカバーサイズよりも大きい
	if self:GetWidth() > ColumnChecker(styles)/2 then
		self:cropright(1-(ColumnChecker(styles)/2)/self:GetWidth());
	end;
	--[ja] 縦がカバーサイズより大きい
	if self:GetHeight() >= 480 then
		self:y(math.max(0,(set_height - 480))/2 + yset);
	else
	--[ja] それ以外
		self:y(-(math.max(0,(480 - self:GetHeight()))/2) + yset);
	end;
end;

function coverseta(self,param,cc,cco)
	local yset = 24;
	local av = false;
	self:zoomx(1);
	self:zoom(1);
	self:cropleft(0);
	self:cropright(0);
	self:horizalign(center);
	self:x(0.5);
	self:y(yset);
	local setcc = cc;
	local setcco = cco;
	local setst = "Single";
	if param ~= "nil" then
		if param.Cover then
			setcc = param.Cover;
		end;
		if param.CoverSS then
			setcco = param.CoverSS;
		end;
		if param.Style then
			setst = param.Style;
		end;
	end;
	local cstyle = GAMESTATE:GetCurrentStyle();
	if cstyle then
		local st = GAMESTATE:GetCurrentStyle():GetStepsType();
		if st then
			local sts = split("_",st);
			setst = sts[3];
		end;
	end;
	if setcc ~= "Random" and setcc ~= "Off" then
		if FILEMAN:DoesFileExist("CSCoverGraphics/"..setcco) then
			av = true;
			self:Load("CSCoverGraphics/"..setcco);
		end;
	elseif setcc == "Random" then
		if FILEMAN:DoesFileExist("CSCoverGraphics/"..rgset) then
			av = true;
			self:Load("CSCoverGraphics/"..rgset);
		end;
	end;
	local set_wzoom = ColumnChecker(setst) / self:GetWidth();
	local set_hzoom = 480/self:GetHeight();
	local set_width = self:GetWidth() * set_hzoom;
	local set_height = self:GetHeight() * set_wzoom;
	local width_a = 0;
	self:visible(av);
	if av then
		--[ja] 横がカバーサイズよりも小さい
		if self:GetWidth() < ColumnChecker(setst) then
			--[ja] 2つにして反転表示
			self:horizalign(left);
			covermirror(self,setst);
		else
			--[ja] 縦横どちらもカバーサイズより大きい
			if set_hzoom < 1 and set_width > ColumnChecker(setst) then
				self:zoom(set_hzoom);
				width_a = set_width - ColumnChecker(setst);
				self:cropleft(width_a/set_width/2);
				self:cropright(width_a/set_width/2);
			else
			--[ja] 横だけカバーサイズより大きい
				if self:GetWidth() > ColumnChecker(setst) then
					self:zoom(set_wzoom);
				end;
			end;
			--[ja] 縦だけカバーサイズより大きい
			if self:GetHeight() > 480 then
				self:y(math.max(0,(set_height - 480))/2 + yset);
			else
			--[ja] それ以外
				self:y(-(math.max(0,(480 - set_height))/2) + yset);
			end;
		end;
	end;
	asety = self:GetY();
	--Trace("asety : "..self:GetY())
end;

function coversetb(self,param,cc,cco)
	local yset = 24;
	local bv = false;
	local pic_load = false;
	self:zoomx(1);
	self:zoom(1);
	self:cropleft(0);
	self:cropright(0);
	self:horizalign(center);
	self:x(0.5);
	self:y(yset);
	local setcc = cc;
	local setcco = cco;
	local setst = "Single";
	if param ~= "nil" then
		if param.Cover then
			setcc = param.Cover;
		end;
		if param.CoverSS then
			setcco = param.CoverSS;
		end;
		if param.Style then
			setst = param.Style;
		end;
	end;
	local cstyle = GAMESTATE:GetCurrentStyle();
	if cstyle then
		local st = GAMESTATE:GetCurrentStyle():GetStepsType();
		if st then
			local sts = split("_",st);
			setst = sts[3];
		end;
	end;
	if setcc ~= "Random" and setcc ~= "Off" then
		if FILEMAN:DoesFileExist("CSCoverGraphics/"..setcco) then
			self:Load("CSCoverGraphics/"..setcco);
			pic_load = true;
		end;
	elseif setcc == "Random" then
		if FILEMAN:DoesFileExist("CSCoverGraphics/"..rgset) then
			self:Load("CSCoverGraphics/"..rgset);
			pic_load = true;
		end;
	end;
	local set_wzoom = ColumnChecker(setst) / self:GetWidth();
	local set_hzoom = 480/self:GetHeight();
	local set_width = self:GetWidth() * set_hzoom;
	local set_height = self:GetHeight() * set_wzoom;
	local width_a = 0;
	if pic_load then
		bv = pic_load;
		self:visible(bv);
		--[ja] 横がカバーサイズよりも小さい
		if self:GetWidth() < ColumnChecker(setst) then
			self:zoomx(-1);
			self:horizalign(left);
			covermirror(self,setst);
		else
			--[ja] 縦横どちらもカバーサイズより大きい
			if set_hzoom < 1 and set_width > ColumnChecker(setst) then
				self:zoom(set_hzoom);
				width_a = set_width - ColumnChecker(setst);
				self:cropleft(width_a/set_width/2);
				self:cropright(width_a/set_width/2);
			else
			--[ja] 横だけカバーサイズより大きい
				if self:GetWidth() > ColumnChecker(setst) then
					self:zoom(set_wzoom);
				end;
			end;
			--20171010
			--[ja] 縦だけカバーサイズより大きい
			if self:GetHeight() > 480 then
				self:linear(0.0005);
				self:y(asety + (self:GetHeight() * self:GetZoom()));
			else
			--[ja] それ以外
				self:linear(0.0005);
				self:y(asety + (self:GetHeight() * self:GetZoom()));
			end;
		end;
	else self:visible(bv);
	end;
end;
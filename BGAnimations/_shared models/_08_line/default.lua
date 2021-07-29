
return Def.Model{
	Meshes=THEME:GetPathB("_shared","models/_08_line/08_line_mesh.txt"),
	Materials=THEME:GetPathB("_shared","models/_08_line/08_line_materials.txt"),
	Bones=THEME:GetPathB("_shared","models/_08_line/08_line_bones.txt"),
	InitCommand=function(self)
		if bUse3dModels() == 'On' then
			self:visible(true);
		else
			self:visible(false);
		end;
	end;
};
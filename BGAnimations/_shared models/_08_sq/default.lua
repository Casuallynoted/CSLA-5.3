
return Def.Model{
	Meshes=THEME:GetPathB("_shared","models/_08_sq/08_sq_mesh.txt"),
	Materials=THEME:GetPathB("_shared","models/_08_sq/08_sq_materials.txt"),
	Bones=THEME:GetPathB("_shared","models/_08_sq/08_sq_bones.txt"),
	InitCommand=function(self)
		if bUse3dModels() == 'On' then
			self:visible(true);
		else
			self:visible(false);
		end;
	end;
};
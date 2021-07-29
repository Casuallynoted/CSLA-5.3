
return Def.Model{
	Meshes=THEME:GetPathB("_shared","models/_08_sr/08_sr_mesh.txt"),
	Materials=THEME:GetPathB("_shared","models/_08_sr/08_sr_materials.txt"),
	Bones=THEME:GetPathB("_shared","models/_08_sr/08_sr_bones.txt"),
	InitCommand=function(self)
		if bUse3dModels() == 'On' then
			self:visible(true);
		else
			self:visible(false);
		end;
	end;
};
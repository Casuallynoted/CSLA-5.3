
return Def.Model{
	Meshes=THEME:GetPathB("_shared","models/_l_wall1/l_wall2_mesh.txt"),
	Materials=THEME:GetPathB("_shared","models/_l_wall2/l_wall2_p2_materials.txt"),
	Bones=THEME:GetPathB("_shared","models/_l_wall1/l_wall2_bones.txt"),
	InitCommand=function(self)
		if bUse3dModels() == 'On' then
			self:visible(true);
		else
			self:visible(false);
		end;
	end;
};
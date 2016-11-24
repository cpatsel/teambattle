function SetWaypointOnGameLoad()
	
	if (LocalPlayer:GetValue("isingame") == true) and (LocalPlayer:GetValue("setwp") == false) then
	--	print("Setting wp to "..LocalPlayer:GetValue("wp"))
		Waypoint:SetPosition(LocalPlayer:GetValue("wp"))
		LocalPlayer:SetValue("setwp",true)
	elseif (LocalPlayer:GetValue("isingame") == false) and (LocalPlayer:GetValue("setwp") == true)  then
		LocalPlayer:SetValue("setwp",false)
	end
	
end

Events:Subscribe("PostTick",SetWaypointOnGameLoad)
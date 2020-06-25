local enableids = true
local playerDistances = {}


Citizen.CreateThread(function()
    while true do 
        if IsControlJustPressed(0, Config.ToggleKey) then
            enableids = not enableids
            Wait(50)
        end
        Wait(0)
    end
end)

Citizen.CreateThread(function()
    while true do
		local players = GetPlayers()
		
		for _,v in pairs(players) do
		
			if enableids then
				local ped = PlayerPedId()
				x1, y1, z1 = table.unpack(GetEntityCoords(ped, true))
				x2, y2, z2 = table.unpack(GetEntityCoords(GetPlayerPed(v), true))
				distance = math.floor(Vdist(x1,  y1,  z1,  x2,  y2,  z2))
				playerDistances[v] = distance
			end
		end
		Citizen.Wait(1000)
    end
end)

-- ID's thread.
Citizen.CreateThread(function()
    while true do 
        Wait(5) 
        if enableids then
            local ped = PlayerPedId()

            local players = GetPlayers()

            for _,v in pairs(players) do
                local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(v)))
				if (playerDistances[v] < Config.radiousDisPlayerNames) then
					if GetPlayerPed(v) ~=  ped then
						DrawText3D(x, y, z+1, tostring(GetPlayerServerId(v)))
					end
				end
            end
        end
    end
end)

function GetPlayers()
    local players = {}
	
    for i = 0, 31 do
        if NetworkIsPlayerActive(i) then
            table.insert(players, i)
        end
    end

    return players
end

function DrawText3D(x, y, z, text)
    local onScreen,_x,_y=GetScreenCoordFromWorldCoord(x, y, z)
    local px,py,pz=table.unpack(GetGameplayCamCoord())
    
    SetTextScale(0.35, 0.35)
    SetTextFontForCurrentCommand(1)
    SetTextColor(255, 255, 255, 215)
    local str = CreateVarString(10, "LITERAL_STRING", text, Citizen.ResultAsLong())
    SetTextCentre(1)
    DisplayText(str,_x,_y)
    local factor = (string.len(text)) / 150
	if Config.useBg then
		DrawSprite("generic_textures", "hud_menu_4a", _x, _y+0.0125,0.015+ factor, 0.03, 0.1, 100, 1, 1, 190, 0)
	end
end
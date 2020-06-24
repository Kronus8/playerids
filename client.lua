local enableids = true

-- ID's thread.
Citizen.CreateThread(function()
    while true do 
        Wait(5) 
        if enableids then
            local ped = PlayerPedId()

            local players = GetPlayers()

            for _,v in pairs(players) do
                local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(v)))
                if GetPlayerPed(v) ~= GetPlayerPed(-1) then
                    DrawText3D(x, y, z, tostring(GetPlayerServerId(v)))
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
    DrawSprite("generic_textures", "hud_menu_4a", _x, _y+0.0125,0.015+ factor, 0.03, 0.1, 100, 1, 1, 190, 0)
end
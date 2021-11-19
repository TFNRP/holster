local lastWeapon = nil
local lastDrawable = nil
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(1e4)
    local ped = PlayerPedId()
    local hash = GetEntityModel(ped)
    if Config.Peds[hash] then
      repeat
        local currentWeapon = GetSelectedPedWeapon(ped)
        if currentWeapon ~= lastWeapon then
          for component, holsters in pairs(Config.Peds[hash]) do
            if Config.Weapons[currentWeapon] then
              local drawable = GetPedDrawableVariation(ped, component)
              local texture = GetPedTextureVariation(ped, component)
              if holsters[drawable] then
                lastDrawable = drawable
                SetPedComponentVariation(ped, component, holsters[drawable], texture, 0)
                break
              end
            elseif Config.Weapons[lastWeapon] then
              local drawable = GetPedDrawableVariation(ped, component)
              if lastDrawable ~= drawable then
                local texture = GetPedTextureVariation(ped, component)
                SetPedComponentVariation(ped, component, lastDrawable, texture, 0)
                break
              end
            end
          end
        end
        lastWeapon = currentWeapon
        Citizen.Wait(200)
        ped = PlayerPedId()
      until not Config.Peds[GetEntityModel(ped)]
    end
  end
end)
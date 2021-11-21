local lastWeapon = nil
local lastDrawable = nil
local lastComponent = nil
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(1e4)
    local ped = PlayerPedId()
    local hash = GetEntityModel(ped)
    if Config.Peds[hash] then
      repeat
        local currentWeapon = GetSelectedPedWeapon(ped)
        if currentWeapon ~= lastWeapon then
          if Config.Weapons[lastWeapon] and lastComponent then
            local drawable = GetPedDrawableVariation(ped, lastComponent)
            if lastDrawable ~= drawable then
              local texture = GetPedTextureVariation(ped, lastComponent)
              SetPedComponentVariation(ped, lastComponent, lastDrawable, texture, 0)
            end
          elseif Config.Weapons[currentWeapon] then
            for component, holsters in pairs(Config.Peds[hash]) do
              local drawable = GetPedDrawableVariation(ped, component)
              local texture = GetPedTextureVariation(ped, component)
              if holsters[drawable] then
                lastDrawable = drawable
                lastComponent = component
                SetPedComponentVariation(ped, component, holsters[drawable], texture, 0)
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
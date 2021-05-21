ESX                           = nil
local PlayerData              = {}

Citizen.CreateThread(function ()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(0)
 	  PlayerData = ESX.GetPlayerData()
  end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(5)

    ped = PlayerPedId()
    coords = GetEntityCoords(ped)

    for k,v in pairs(Config.DutyLocations) do
      local dist = #(coords - v.Coords)
      if dist < v.DrawRange then
        if CheckPlayerJob(v.Jobs) then
          if string.match(PlayerData.job.name, 'off') ~= nil then
            exports.fu_text:drawHologram(v.Coords.x, v.Coords.y, v.Coords.z + 1.25, '[~b~E~w~] Inklokken')
            if dist < v.InteractRange then
              if IsControlJustReleased(0, 38) then
                TriggerServerEvent('duty:changejob')
                exports["rp-radio"]:GivePlayerAccessToFrequencies(1)
                sendNotification('Je bent in dienst gegaan.', 'success', 2500)
              end
            end
          else
            exports.fu_text:drawHologram(v.Coords.x, v.Coords.y, v.Coords.z + 1.25, '[~b~E~w~] Uitklokken')
            if dist < v.InteractRange then
              if IsControlJustReleased(0, 38) then
                TriggerServerEvent('duty:changejob')
                exports["rp-radio"]:RemovePlayerAccessToFrequencies(1)
                sendNotification('Je bent uit dienst gegaan.', 'success', 2500)
              end
            end
          end
        end
      end
    end
  end
end)

function CheckPlayerJob(jobList)
  if PlayerData.job ~= nil then
    for k,v in pairs(jobList) do
      if PlayerData.job.name == v then
        return true
      end
    end
  end
end

function sendNotification(message, messageType, messageTimeout)
	TriggerEvent("pNotify:SendNotification", {
		text = message,
		type = messageType,
		queue = "duty",
		timeout = messageTimeout,
		layout = "bottomCenter"
	})
end
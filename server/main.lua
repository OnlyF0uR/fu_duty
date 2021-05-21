ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('duty:changejob')
AddEventHandler('duty:changejob', function(job)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    if string.match(xPlayer.job.name, 'off') ~= nil then
        -- Inklokken
        jobName = xPlayer.job.name:sub(4)
        xPlayer.setJob(jobName, xPlayer.job.grade)
    else
        -- Uitklokken
        if xPlayer.job.name == 'police' then
            removePoliceItems(xPlayer)
        end

        if xPlayer.job.name == 'ambulance' then
            removeAmbulanceItems(xPlayer)
        end

        jobName = 'off' .. xPlayer.job.name
        xPlayer.setJob(jobName, xPlayer.job.grade)
    end
end)

function removePoliceItems(xPlayer)
    xPlayer.removeWeapon("WEAPON_NIGHTSTICK", 1)
    xPlayer.removeWeapon("WEAPON_COMBATPISTOL", 1)
    xPlayer.removeWeapon("WEAPON_CARBINERIFLE", 1)
    xPlayer.removeWeapon("WEAPON_STUNGUN", 1)
    xPlayer.removeWeapon("WEAPON_FIREEXTINGUISHER", 1)
    xPlayer.removeWeapon("WEAPON_SMG", 1)
end

function removeAmbulanceItems(xPlayer)
    medikitAmount = xPlayer.getInventoryItem("medikit").count
    bandageAmount = xPlayer.getInventoryItem("bandage").count

    if medikitAmount > 0 then
        xPlayer.removeInventoryItem("medikit", medikitAmount)
    end

    if bandageAmount > 0 then
        xPlayer.removeInventoryItem("bandage", bandageAmount)
    end
end
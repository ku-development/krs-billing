local QBCore = exports["qb-core"]:GetSharedObject()

TSE = function (event, ...)
    TriggerServerEvent(event, ...)
end

local OpenUi = function(data)
    SetNuiFocus(true, true)
    SendNUIMessage({
        type = 'openMe',
        data = data
    })
end

RegisterNetEvent('krs-billing:openBillingMenu', function(data)
    SetNuiFocus(true, true)
    SendNUIMessage({
        type = "openMe",
        data = data
    })
end)

RegisterNUICallback('krs-billing:callback:refundBill', function(data, cb)
    local billId = data.billId
    TriggerServerEvent('krs-billing:refundBill', billId)
    cb('ok')
end)

RegisterNUICallback('close', function()
    SetNuiFocus(false, false)
end)

RegisterNUICallback('krs-billing:nui:callback:billPlayer', function (data, cb)
    TSE('krs-billing:server:billPlayer', data)
    cb("ok")
end)

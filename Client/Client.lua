TSE = function (event, ...)
    TriggerServerEvent(event, ...)
end

local OpenUi = function(data)
    SendNUIMessage({
        type = 'openMe',
        data = data
    })
end

RegisterNUICallback('krs-billing:nui:callback:billPlayer', function (data, cb)
    TSE('krs-billing:server:billPlayer', data)
    
    cb("ok")
end)
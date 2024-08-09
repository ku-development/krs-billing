local OpenUi = function(data)
    SendNUIMessage({
        type = 'openMe',
        data = data
    })
end
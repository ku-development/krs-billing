---@diagnostic disable: undefined-global

function sendToDiscord(title, message)
    local webhookURL = "YOUR_WEBHOOK_URL"
    local data = {
        {
            ["title"] = title,
            ["description"] = message,
            ["color"] = 3447003
        }
    }
    PerformHttpRequest(webhookURL, function(err, text, headers) end, 'POST', json.encode({username = "Billing System", embeds = data}), { ['Content-Type'] = 'application/json' })
end


function GetPlayerBills(cid)
    local unpaidBills = {}
    local billingHistory = {}
    local billResults = MySQL.query.await("SELECT * FROM `bills` WHERE receiver_cid = @receiver_cid", {['@receiver_cid'] = cid})

    for _, bill in pairs(billResults) do
        local receiverData = MySQL.query.await("SELECT charinfo, job FROM `players` WHERE citizenid = @receiver_cid", {['@receiver_cid'] = bill.receiver_cid})
        local senderData = MySQL.query.await("SELECT charinfo FROM `players` WHERE citizenid = @sender_cid", {['@sender_cid'] = bill.sender_cid})

        local receiverCharinfo = json.decode(receiverData[1].charinfo)
        local receiverJob = json.decode(receiverData[1].job)

        local senderCharinfo = json.decode(senderData[1].charinfo)

        local receiverName = receiverCharinfo.firstname .. " " .. receiverCharinfo.lastname
        local senderName = senderCharinfo.firstname .. " " .. senderCharinfo.lastname

        local billData = {
            id = bill.id,
            amount = bill.amount,
            reason = bill.reason,
            sender = senderName,
            receiver = receiverName,
            job = receiverJob.name,
            date = bill.date,
            time = bill.time,
            paid = bill.paid,
            sender_cid = bill.sender_cid,
            receiver_cid = bill.receiver_cid
        }

        if bill.paid then
            table.insert(billingHistory, billData)
        else
            table.insert(unpaidBills, billData)
        end
    end

    return unpaidBills, billingHistory
end

function GetSocietyBills(job)
    local societyBills = {}
    local billResults = MySQL.query.await("SELECT * FROM `bills` WHERE sender_job = @sender_job", {['@sender_job'] = job})

    for _, bill in pairs(billResults) do
        local receiverData = MySQL.query.await("SELECT charinfo, job FROM `players` WHERE citizenid = @receiver_cid", {['@receiver_cid'] = bill.receiver_cid})
        local senderData = MySQL.query.await("SELECT charinfo FROM `players` WHERE citizenid = @sender_cid", {['@sender_cid'] = bill.sender_cid})

        local receiverCharinfo = json.decode(receiverData[1].charinfo)
        local receiverJob = json.decode(receiverData[1].job)

        local senderCharinfo = json.decode(senderData[1].charinfo)

        local receiverName = receiverCharinfo.firstname .. " " .. receiverCharinfo.lastname
        local senderName = senderCharinfo.firstname .. " " .. senderCharinfo.lastname

        local billData = {
            id = bill.id,
            amount = bill.amount,
            reason = bill.reason,
            sender = senderName,
            receiver = receiverName,
            job = receiverJob.name,
            date = bill.date,
            time = bill.time,
            paid = bill.paid,
            sender_cid = bill.sender_cid,
            receiver_cid = bill.receiver_cid
        }

        table.insert(societyBills, billData)
    end

    return societyBills
end



RegisterNetEvent("krs-billing:server:billPlayer", function(data)
    local cid = data.cid
    local targetCid = data.targetCid
    local reason = data.reason
    local amount = data.amount

    local Player = QBCore.Functions.GetPlayerByCitizenId(cid)
    local TargetPlayer = QBCore.Functions.GetPlayerByCitizenId(targetCid)
    local job = Player.PlayerData.job

    local JobName = job.name
    
    local query = MySQL.query.await("INSERT INTO bills (amount, reason, job, sender_cid, receiver_cid, date, time, paid) VALUES (?, ?, ?, ?, ?, ?, ?, ?)", {
        amount, 
        reason,
        JobName,
        cid, 
        targetCid, 
        os.date("%Y-%m-%d"), 
        os.date("%H:%M:%S"), 
        false
    })
end)

RegisterNetEvent('krs-billing:payBill', function(billId, payFromJobAccount)
    local src = source
    local xPlayer = QBCore.Functions.GetPlayer(src)
    local bill = MySQL.Sync.fetchAll('SELECT * FROM billing WHERE id = @id', {
        ['@id'] = billId
    })

    if not bill[1] then
        TriggerClientEvent('QBCore:Notify', src, 'Bill not found', 'error')
        return
    end

    local amount = bill[1].amount

    if payFromJobAccount then
        if xPlayer.PlayerData.job.isboss then
            TriggerEvent('qb-bossmenu:server:removeAccountMoney', xPlayer.PlayerData.job.name, amount, function(success)
                if success then
                    MySQL.Async.execute('UPDATE billing SET paid = @paid WHERE id = @id', {
                        ['@paid'] = true,
                        ['@id'] = billId
                    })
                    TriggerClientEvent('QBCore:Notify', src, 'Bill paid from job account', 'success')
                    sendToDiscord("Bill Paid", "Bill ID: "..billId.." of $"..amount.." paid by "..xPlayer.PlayerData.name.." from the job account")
                else
                    TriggerClientEvent('QBCore:Notify', src, 'Not enough funds in job account', 'error')
                end
            end)
        else
            TriggerClientEvent('QBCore:Notify', src, 'You do not have permission to pay from job account', 'error')
        end
    else
        if xPlayer.Functions.RemoveMoney('cash', amount) then
            MySQL.Async.execute('UPDATE billing SET paid = @paid WHERE id = @id', {
                ['@paid'] = true,
                ['@id'] = billId
            })
            TriggerClientEvent('QBCore:Notify', src, 'Bill paid from your cash', 'success')
            sendToDiscord("Bill Paid", "Bill ID: "..billId.." of $"..amount.." paid by "..xPlayer.PlayerData.name.." from cash")
        else
            TriggerClientEvent('QBCore:Notify', src, 'Not enough cash to pay the bill', 'error')
        end
    end
end)


RegisterNetEvent('krs-billing:refundBill', function(billId, jobName)
    local src = source
    local xPlayer = QBCore.Functions.GetPlayer(src)
    
    if xPlayer.PlayerData.job.name == jobName and xPlayer.PlayerData.job.isboss then
        MySQL.Async.execute('UPDATE billing SET paid = @paid WHERE id = @id', {
            ['@paid'] = true,
            ['@id'] = billId
        })
        
        TriggerClientEvent('QBCore:Notify', src, 'Bill refunded successfully', 'success')
        sendToDiscord("Bill Refunded", "A bill has been refunded by "..xPlayer.PlayerData.name)
    else
        TriggerClientEvent('QBCore:Notify', src, 'You do not have permission to refund this bill', 'error')
    end
end)

---@diagnostic disable: undefined-global

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
    
    local query = MySQL.query.await("INSERT ")

end)
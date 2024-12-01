local wallet = {}

function wallet.load()
    wallet.balance = 0
end

function wallet.add(amount)
    if amount > 0 then
        wallet.balance = wallet.balance + amount
    end
end

function wallet.spend(amount)
    if amount > 0 and wallet.balance >= amount then
        wallet.balance = wallet.balance - amount
        return true
    else
        return false
    end
end

function wallet.draw()
end

return wallet

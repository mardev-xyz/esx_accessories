RegisterNetEvent('esx_accessories:pay', function()
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeMoney(Config.Price, "Accessory Purchase")
	TriggerClientEvent('esx:showNotification', source, TranslateCap('you_paid', ESX.Math.GroupDigits(Config.Price)))
end)

RegisterNetEvent('esx_accessories:save', function(skin, accessory)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	local lowerAccessory = accessory:lower()

	TriggerEvent('esx_datastore:getDataStore', ('user_%s'):format(lowerAccessory), xPlayer.identifier, function(store)
		store.set('has' .. accessory, true)

		store.set('skin', {
			[('%s_1'):format(lowerAccessory)] = skin[('%s_1'):format(lowerAccessory)],
			[('%s_2'):format(lowerAccessory)] = skin[('%s_2'):format(lowerAccessory)],
		})
	end)
end)

ESX.RegisterServerCallback('esx_accessories:get', function(source, cb, accessory)
	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_datastore:getDataStore', ('user_%s'):format(accessory:lower()), xPlayer.identifier, function(store)
		local hasAccessory = (store.get(('has%s'):format(accessory)) and store.get('has' .. ('has%s'):format(accessory)) or false)
		local skin = (store.get('skin') and store.get('skin') or {})

		cb(hasAccessory, skin)
	end)

end)

ESX.RegisterServerCallback('esx_accessories:checkMoney', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	cb(xPlayer.getMoney() >= Config.Price)
end)
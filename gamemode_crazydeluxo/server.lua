
function TellClientUpdateRecords(source,mode)
	local data = {
		mode = mode
	
	}
	MySQL.Async.fetchAll('SELECT playername, scores, @curRank := @curRank + 1 AS rank FROM ranking, (SELECT @curRank := 0) r WHERE `mode` = @mode ORDER BY scores desc', {mode = data.mode}, function(records)
		--[[
		for i,v in pairs(records) do 
			print(i,v.rank)
			print(i,v.playername)
			print(i,v.scores)
		end 
		--]]
		TriggerClientEvent("nbk_crazydeluxo_images:updateRecords",source,mode,records)
	end)
end 
RegisterNetEvent('es_ranking_db:getRecords', function(mode)
	
	if source then 
		TellClientUpdateRecords(source,mode)
	end 
end)
RegisterNetEvent('es_ranking_db:createRecord', function(scores,mode,playername)
	if scores and scores > 0 then 
		local user = {
			scores = scores,
			mode = mode,
			playername = playername or "Unknown"
		}
		if scores and mode and playername then 
			MySQL.Async.execute('INSERT INTO ranking (`scores`, `mode`,  `playername`) VALUES (@scores, @mode, @playername);',
			{
				scores = user.scores,
				mode = user.mode,
				playername = user.playername
			}, function(rowsChanged)
				if source then 
				TellClientUpdateRecords(source,mode)
				end 
			end)
		end 
	end 
end)
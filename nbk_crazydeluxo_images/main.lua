load(LoadResourceFile("tasksync", 'tasksync_with_scaleform.lua.sourcecode'))()
load(LoadResourceFile("tasksync", 'tasksync_with_drawtext.lua.sourcecode'))()
AddEventHandler('nbk_crazydeluxo_draw:getcoin', function(txt)
	--https://github.com/negbook/nbk_damagemessage_freeversion 
	DrawText2D = function(text,scale,x,y,a,r,g,b)
		SetTextScale(scale/24, scale/24)
		SetTextFont(0)
		SetTextColour(r,g,b, a)
		SetTextCentre(true)
		BeginTextCommandDisplayText('STRING')
		AddTextComponentSubstringPlayerName(text)
		EndTextCommandDisplayText(x, y)
		ClearDrawOrigin()
	end
	DrawText2DTweenUp = function(text,scale,x,y,moveheight,speed,r,g,b)
		CreateThread(function()
			local height = y
			local total_ = height - (y-moveheight) 
			local total = height - (y-moveheight) 
			while height > y-moveheight do 
				DrawText2D(text,scale,x,height,math.floor(255* (total/total_)),r,g,b)
				height = height - 0.003*speed
				total = total - 0.003*speed
				Wait(0)
			end 
			return 
		end)
	end 
	DrawText2DTweenUp(txt,12,0.5,0.45,0.1,0.5,255,255,0)
end)
local handle_HeadNumber
local handle_Timeleft
local handle_Timeleftbg
local handle_TotalEarn
local handle_TotalEarnbg
local handle_Fare
local handle_Farebg
local handle_CrazyDrift
local handle_Combo
local handle_Combobg
local handle_Warning
Records = {}
Records["arcade"] = {}
Records["original"] = {}
ShowRecord = false 

CreateThread(function()
	--//////////////D//R//A//W//////////--
	if not handle_HeadNumber then 
		handle_HeadNumber = TextDrawCreate(0.5,0.5,"")
		TextDrawTextSize(handle_HeadNumber,30/24,30/24)
		TextDrawUseBox(handle_HeadNumber,false)
		TextDrawFont(handle_HeadNumber,2)
		TextDrawColor(handle_HeadNumber,0x00ff00ff)
		TextDrawSetOutline(handle_HeadNumber,false)
	end 
	if not handle_Timeleft then 
		handle_Timeleft = TextDrawCreate(0.1,0.005,"")
		TextDrawTextSize(handle_Timeleft,120/24,120/24)
		TextDrawUseBox(handle_Timeleft,false)
		TextDrawFont(handle_Timeleft,2)
		TextDrawColor(handle_Timeleft,0xffff00ff)
		TextDrawSetOutline(handle_Timeleft,true)
		
		handle_Timeleftbg = TextDrawCreate(0.15,0.26,"<b><i>game time</i></b>")
		TextDrawColor(handle_Timeleftbg,0xffff00ff)
		TextDrawUseBox(handle_Timeleftbg,false)
		TextDrawSetOutline(handle_Timeleftbg,true)
	end 
	if not handle_TotalEarn then 
		handle_TotalEarn = TextDrawCreate(0.9,0.065,"<font face='$Font2_cond'>$</font>"..string.gsub(string.format("%.2f",0),"%.","<font face='$Font2_cond'>.</font>"))
		TextDrawTextSize(handle_TotalEarn,24/24,24/24)
		TextDrawUseBox(handle_TotalEarn,false)
		TextDrawFont(handle_TotalEarn,2)
		TextDrawColor(handle_TotalEarn,0x00ff00ff)
		TextDrawSetOutline(handle_TotalEarn,true)
		--TextDrawShow(handle_TotalEarn)
		handle_TotalEarnbg = TextDrawCreate(0.9,0.015,"Total Earned")
		TextDrawTextSize(handle_TotalEarnbg,24/24,24/24)
		TextDrawUseBox(handle_TotalEarnbg,false)
		TextDrawFont(handle_TotalEarnbg,2)
		TextDrawColor(handle_TotalEarnbg,0xeeeeeeff)
		TextDrawSetOutline(handle_TotalEarnbg,true)
		--TextDrawShow(handle_TotalEarnbg)
	end 
	if not handle_Fare then 
		handle_Fare = TextDrawCreate(0.9,0.165,"<font face='$Font2_cond'>$</font>"..string.gsub(string.format("%.2f",0),"%.","<font face='$Font2_cond'>.</font>"))
		TextDrawTextSize(handle_Fare,24/24,24/24)
		TextDrawUseBox(handle_Fare,false)
		TextDrawFont(handle_Fare,2)
		TextDrawColor(handle_Fare,0x00ff00ff)
		TextDrawSetOutline(handle_Fare,true)
		--TextDrawShow(handle_Fare)
		handle_Farebg = TextDrawCreate(0.9,0.115,"FARE")
		TextDrawTextSize(handle_Farebg,24/24,24/24)
		TextDrawUseBox(handle_Farebg,false)
		TextDrawFont(handle_Farebg,2)
		TextDrawColor(handle_Farebg,0xff96e1ff)
		TextDrawSetOutline(handle_Farebg,true)
		--TextDrawShow(handle_Farebg)
	end 
	if not handle_CrazyDrift then 
		handle_CrazyDrift = TextDrawCreate(0.85,0.245,"<i>Crazy shuffle</i>")
		TextDrawTextSize(handle_CrazyDrift,16/24,16/24)
		TextDrawUseBox(handle_CrazyDrift,false)
		TextDrawFont(handle_CrazyDrift,2)
		TextDrawColor(handle_CrazyDrift,0xffff00ff)
		TextDrawSetOutline(handle_CrazyDrift,true)
		
	end 
	if not handle_Combobg then 
		handle_Combobg = TextDrawCreate(0.875,0.295,"Combo x")
		TextDrawTextSize(handle_Combobg,16/24,16/24)
		TextDrawUseBox(handle_Combobg,false)
		TextDrawFont(handle_Combobg,2)
		TextDrawColor(handle_Combobg,0xffff00ff)
		TextDrawSetOutline(handle_Combobg,true)
		
		handle_Combo = TextDrawCreate(0.95,0.215,"999")
		TextDrawTextSize(handle_Combo,60/24,60/24)
		TextDrawUseBox(handle_Combo,false)
		TextDrawFont(handle_Combo,2)
		TextDrawColor(handle_Combo,0xffff00ff)
		TextDrawSetOutline(handle_Combo,true)
		
	end 
	if not handle_Warning then 
		handle_Warning = TextDrawCreate(0.5,0.05,"stop at the mark")
		TextDrawTextSize(handle_Warning,50/24,50/24)
		TextDrawUseBox(handle_Warning,false)
		TextDrawFont(handle_Warning,2)
		TextDrawColor(handle_Warning,0xff0000ff)
		TextDrawSetOutline(handle_Warning,false)
		
	end 
end)
AddEventHandler('nbk_crazydeluxo_draw:setHeadNumber', function(num,xper,yper)
	if not handle_HeadNumber then return end 
	if tonumber(num) > 0 then 
		TextDrawShow(handle_HeadNumber)
		TextDrawSetString(handle_HeadNumber,"<b><i>"..num.."</i></b>")
		TextDrawSetPosition(handle_HeadNumber,xper,yper-0.1)
	else 
		TextDrawHide(handle_HeadNumber)
	end 
end)
AddEventHandler('nbk_crazydeluxo_draw:setTimeleft', function(txt)
	if not handle_Timeleft then return end 
    if tonumber(txt) > 0 then 
		TextDrawShow(handle_Timeleftbg)
		TextDrawShow(handle_Timeleft)
		TextDrawShow(handle_TotalEarnbg)
		TextDrawShow(handle_TotalEarn)
		TextDrawShow(handle_Farebg)
		TextDrawShow(handle_Fare)
		TextDrawShow(handle_CrazyDrift)
		TextDrawSetString(handle_Timeleft,"<b><i>"..txt.."</i></b>")
	else 
		TextDrawHide(handle_Timeleftbg)
		TextDrawHide(handle_Timeleft)
		TextDrawHide(handle_TotalEarnbg)
		TextDrawHide(handle_TotalEarn)
		TextDrawHide(handle_Farebg)
		TextDrawHide(handle_Fare)
		TextDrawHide(handle_CrazyDrift)
		TextDrawHide(handle_HeadNumber)
	end 
end)

AddEventHandler('nbk_crazydeluxo_draw:setTotalEarned', function(text)
	if not handle_TotalEarn then return end 
    if tonumber(text) > 0 then 
		
		TextDrawSetString(handle_TotalEarn,"<font face='$Font2_cond'>$</font>"..string.gsub(string.format("%.2f",tonumber(text)),"%.","<font face='$Font2_cond'>.</font>"))
	else 
		
	end 
end)

AddEventHandler('nbk_crazydeluxo_draw:setFares', function(text)
	if not handle_Fare then return end 
    if tonumber(text) > 0 then 
		TextDrawSetString(handle_Fare,"<font face='$Font2_cond'>$</font>"..string.gsub(string.format("%.2f",tonumber(text)),"%.","<font face='$Font2_cond'>.</font>"))
	else 
		
	end 
end)

AddEventHandler('nbk_crazydeluxo_draw:setCrazyText', function(text)
	if not handle_CrazyDrift then return end 
	text = string.gsub(text,"%.","<font face='$Font2_cond'>.</font>")
	text = string.gsub(text,"!","<font face='$Font2_cond'>!</font>")
   	TextDrawSetString(handle_CrazyDrift,text)
end)


AddEventHandler('nbk_crazydeluxo_draw:setCombo', function(num)
	if not handle_Combo then return end 
	 if tonumber(num) > 0 then 
		TextDrawShow(handle_Combobg)
		TextDrawShow(handle_Combo)
		TextDrawSetString(handle_Combo,tonumber(num))
	else 
		TextDrawHide(handle_Combobg)
		TextDrawHide(handle_Combo)
	end 
		
end)

AddEventHandler('nbk_crazydeluxo_draw:showWarning', function(bool)
	if not handle_Warning then return end 
    if bool then 
		TextDrawShow(handle_Warning) 
	else 
		TextDrawHide(handle_Warning)
	end 
end)

AddEventHandler('nbk_crazydeluxo_images:draw', function(txt)
	if not Tasksync.ScaleformIsDrawing('nbk_crazydeluxo_images') then 
    Tasksync.ScaleformDraw('nbk_crazydeluxo_images',nil,5)
	end 
end)
AddEventHandler('nbk_crazydeluxo_images:end', function(txt)
    Tasksync.ScaleformEnd('nbk_crazydeluxo_images')
end)
AddEventHandler('nbk_crazydeluxo_images:selection_arcade', function(txt)
    Tasksync.ScaleformCall('nbk_crazydeluxo_images',function(run)
        run("SELECTION_ARCADE")
    end)
end)
AddEventHandler('nbk_crazydeluxo_images:selection_original', function(txt)
    Tasksync.ScaleformCall('nbk_crazydeluxo_images',function(run)
        run("SELECTION_ORIGINAL")
    end)
end)
AddEventHandler('nbk_crazydeluxo_images:selection_records', function(txt)
    Tasksync.ScaleformCall('nbk_crazydeluxo_images',function(run)
        run("SELECTION_RECORDS")
    end)
end)
AddEventHandler('nbk_crazydeluxo_images:selection_quit', function(txt)
    Tasksync.ScaleformCall('nbk_crazydeluxo_images',function(run)
        run("SELECTION_QUIT")
    end)
end)
AddEventHandler('nbk_crazydeluxo_images:show_home', function(txt)
    Tasksync.ScaleformCall('nbk_crazydeluxo_images',function(run)
        run("SHOW_HOME")
		nowselection = 1
    end)
end)
AddEventHandler('nbk_crazydeluxo_images:show_result', function(txt)
    Tasksync.ScaleformCall('nbk_crazydeluxo_images',function(run)
        run("SHOW_RESULT")
    end)
end)
AddEventHandler('nbk_crazydeluxo_images:show_records', function(txt)
    Tasksync.ScaleformCall('nbk_crazydeluxo_images',function(run)
        run("SHOW_RECORDS")
    end)
end)
AddEventHandler('nbk_crazydeluxo_images:set_records_arcade', function(rank,name,scores)
	--print(rank,name,scores)
    Tasksync.ScaleformCall('nbk_crazydeluxo_images',function(run)
        run("SET_RECORDS_ARCADE",tonumber(rank),"name",name)
		run("SET_RECORDS_ARCADE",tonumber(rank),"scores",scores)
    end)
end)
AddEventHandler('nbk_crazydeluxo_images:set_records_original', function(rank,name,scores)
    Tasksync.ScaleformCall('nbk_crazydeluxo_images',function(run)
        run("SET_RECORDS_ORIGINAL",tonumber(rank),"name",name)
		run("SET_RECORDS_ORIGINAL",tonumber(rank),"scores",scores)
    end)
end)
AddEventHandler('nbk_crazydeluxo_images:setCustomers', function(num)
    Tasksync.ScaleformCall('nbk_crazydeluxo_images',function(run)
        run("SET_CUSTOMERS",num)
    end)
end)
AddEventHandler('nbk_crazydeluxo_images:setTotalEarned', function(num)
    Tasksync.ScaleformCall('nbk_crazydeluxo_images',function(run)
        run("SET_TOTALEARNED",num)
    end)
end)

AddEventHandler('nbk_crazydeluxo_images:setRanking', function(txt,nowmode,total)
    Tasksync.ScaleformCall('nbk_crazydeluxo_images',function(run)
        run("SET_RANKING",txt)
		if nowmode and total then 
			SetRankIntoResult(nowmode,total)
		end 
    end)
end)
AddEventHandler('nbk_crazydeluxo_images:setClass', function(txt)
    Tasksync.ScaleformCall('nbk_crazydeluxo_images',function(run)
        run("SET_CLASS",txt)
    end)
end)

function SetRankIntoResult(mode,total)
	CreateThread(function()
		TriggerServerEvent("es_ranking_db:getRecords","arcade")
		TriggerServerEvent("es_ranking_db:getRecords","original")
		Wait(2000)
		local nowranking = 0
		--print(mode,#Records[mode])
		if Records[mode] and Records[mode][1] then 
			for i=1,#Records[mode] do 
				--print(TotalEarned,Records[mode][i].scores,i)
				if tonumber(total) <= tonumber(Records[mode][i].scores) then 
					nowranking = i;
				end 
			end 
		else 
			nowranking = "???"
		end 
		--print(nowranking)
		TriggerEvent("nbk_crazydeluxo_images:setRanking",nowranking)
	end )
end 
RegisterNetEvent("nbk_crazydeluxo_images:updateRecords", function(mode,records)
	
    Records[mode] = records
	
	if Records then 
		if mode == "arcade" then 
			for i=1,#Records["arcade"] do 
				if i <= 5 then 
				TriggerEvent("nbk_crazydeluxo_images:set_records_arcade",i,Records["arcade"][i].playername,"$"..Records["arcade"][i].scores)
				end 
			end 
		end 
		if mode == "original" then 
			for i=1,#Records["original"] do 
				if i <= 5 then 
				TriggerEvent("nbk_crazydeluxo_images:set_records_original",i,Records["original"][i].playername,"$"..Records["original"][i].scores)
				end 
			end 
		end 
	end 
end)

Tasksync.addloop("hud",0,function()
	HideHudComponentThisFrame( 1 ) -- Wanted Stars
	HideHudComponentThisFrame( 2 ) -- Weapon Icon
	HideHudComponentThisFrame( 3 ) -- Cash
	HideHudComponentThisFrame( 4 ) -- MP Cash
	--HideHudComponentThisFrame( 6 ) -- Vehicle Name
	--HideHudComponentThisFrame( 7 ) -- Area Name
	--HideHudComponentThisFrame( 8 ) -- Vehicle Class      
	--HideHudComponentThisFrame( 9 ) -- Street Name
	HideHudComponentThisFrame( 13 ) -- Cash Change
	--HideHudComponentThisFrame( 17 ) -- Save Game  
	HideHudComponentThisFrame( 20 ) -- Weapon Stats 
	if ShowRecord == true then 
		if IsControlJustReleased(0--[[control type]],  177--[[control index]]) then 
			TriggerEvent("gamemode_crazydeluxo:reload")
			TriggerEvent("nbk_crazydeluxo_images:draw")
			TriggerEvent("nbk_crazydeluxo_images:show_home")
			TriggerEvent("nbk_crazydeluxo_images:selection_arcade")
			ShowRecord = false 
		end 
	end 
	-- ungly menu code
	if nowselection ~= nil and nowselection ~= -1 then 
		if IsControlJustReleased(0--[[control type]],  22--[[control index]]) or IsControlJustReleased(0--[[control type]],  23--[[control index]]) or IsControlJustReleased(0--[[control type]],  21--[[control index]]) then
			if nowselection == 1 then 
				TriggerEvent('gamemode_crazydeluxo:arcade')
				--print('arcade')
				TriggerEvent("nbk_crazydeluxo_images:end")
				nowselection = -1
			elseif nowselection == 2 then 
				TriggerEvent('gamemode_crazydeluxo:original')
				--print('original')
				TriggerEvent("nbk_crazydeluxo_images:end")
				nowselection = -1
			elseif nowselection == 3 then 
				ShowRecord = true 
				TriggerEvent("nbk_crazydeluxo_images:show_records")
				TriggerServerEvent("es_ranking_db:getRecords","arcade")
				TriggerServerEvent("es_ranking_db:getRecords","original")
				
				if Records and Records["arcade"] and Records["arcade"] then 
					for i=1,#Records["arcade"] do 
						if i <= 5 then 
						TriggerEvent("nbk_crazydeluxo_images:set_records_arcade",i,Records["arcade"][i].playername,"$"..Records["arcade"][i].scores)
						end 
					end 
					for i=1,#Records["original"] do 
						if i <= 5 then 
						TriggerEvent("nbk_crazydeluxo_images:set_records_original",i,Records["original"][i].playername,"$"..Records["original"][i].scores)
						end 
					end 
				end 
				--nowselection = -1
			elseif nowselection == 4 then 
				RestartGame()
				--print('quit')
				TriggerEvent("nbk_crazydeluxo_images:end")
				nowselection = -1
			end 
		end
		if IsControlJustReleased(0--[[control type]],  172--[[control index]]) then --up 
			if nowselection == 1 then 
				nowselection = 4
				TriggerEvent("nbk_crazydeluxo_images:selection_quit")
			elseif nowselection == 2 then
				nowselection = 1
				TriggerEvent("nbk_crazydeluxo_images:selection_arcade")
			elseif nowselection == 3 then
				nowselection = 2
				TriggerEvent("nbk_crazydeluxo_images:selection_original")	
			elseif nowselection == 4 then
				nowselection = 3
				TriggerEvent("nbk_crazydeluxo_images:selection_records")
			end 
		end
		if IsControlJustReleased(0--[[control type]],  173--[[control index]]) then --down
			if nowselection == 1 then 
				nowselection = 2
				TriggerEvent("nbk_crazydeluxo_images:selection_original")
			elseif nowselection == 2 then
				nowselection = 3
				TriggerEvent("nbk_crazydeluxo_images:selection_records")
			elseif nowselection == 3 then
				nowselection = 4
				TriggerEvent("nbk_crazydeluxo_images:selection_quit")
			elseif nowselection == 4 then
				nowselection = 1
				TriggerEvent("nbk_crazydeluxo_images:selection_arcade")
			end 
		end
	elseif nowselection == -1 then  
		TriggerEvent("nbk_crazydeluxo_images:end")
		nowselection = nil 
	end 
end) 
TriggerServerEvent("es_ranking_db:getRecords","arcade")
TriggerServerEvent("es_ranking_db:getRecords","original")
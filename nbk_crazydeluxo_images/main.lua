loop_newthread = function (duration,fn,fnclose)
    local duration = duration 
    local loopend = false 
    local fn = fn 
    local fnclose = fnclose
    local fns = nil
    local newthread = function() end 
    local localcb = function(action,value) 
        if action == "break" or action == "kill" then 
            loopend = true
        elseif action == "inserttask" then 
            local insertfn = value
            if fns == nil then 
                fns = {fn}
            end 
            table.insert(fns,insertfn)
        elseif action == "removetask" then 
            local idx = value
            table.remove(fns,idx)
        elseif action == "set" then 
            duration = value
        elseif action == "get" then 
            return duration
        elseif action == "restart" then 
            loopend = false
            return newthread()
        end 
    end
    newthread = function() 
        CreateThread(function()
            while not loopend do  Wait(duration)
                if fns then 
                    for i=1,#fns do 
                        fns[i](localcb,i)
                    end 
                else 
                    fn(localcb)
                end 
            end 
            if fnclose then fnclose() end
            return 
        end) 
        return localcb
    end 
    return newthread()
end 

PrepareMusicEvent("FRA1_SPEED");

AddEventHandler('nbk_crazydeluxo_draw:getcoin', function(txt)
	PlaySoundFrontend(-1, "PICK_UP", "HUD_FRONTEND_DEFAULT_SOUNDSET", true);
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
	if not ScaleformIsDrawing('nbk_crazydeluxo_images') then 
    ScaleformDraw('nbk_crazydeluxo_images',nil,5)
	end 
end)
AddEventHandler('nbk_crazydeluxo_images:end', function(txt)
    ScaleformEnd('nbk_crazydeluxo_images')
end)
AddEventHandler('nbk_crazydeluxo_images:selection_arcade', function(txt)
    ScaleformCall('nbk_crazydeluxo_images',function(run)
        run("SELECTION_ARCADE")
    end)
end)
AddEventHandler('nbk_crazydeluxo_images:selection_original', function(txt)
    ScaleformCall('nbk_crazydeluxo_images',function(run)
        run("SELECTION_ORIGINAL")
    end)
end)
AddEventHandler('nbk_crazydeluxo_images:selection_records', function(txt)
    ScaleformCall('nbk_crazydeluxo_images',function(run)
        run("SELECTION_RECORDS")
    end)
end)
AddEventHandler('nbk_crazydeluxo_images:selection_quit', function(txt)
    ScaleformCall('nbk_crazydeluxo_images',function(run)
        run("SELECTION_QUIT")
    end)
end)
AddEventHandler('nbk_crazydeluxo_images:show_home', function(txt)
    ScaleformCall('nbk_crazydeluxo_images',function(run)
        run("SHOW_HOME")
		nowselection = 1
		
		TriggerMusicEvent("FRA1_SPEED");
		
    end)
end)
AddEventHandler('nbk_crazydeluxo_images:show_result', function(txt)
    ScaleformCall('nbk_crazydeluxo_images',function(run)
        run("SHOW_RESULT")
    end)
end)
AddEventHandler('nbk_crazydeluxo_images:show_records', function(txt)
    ScaleformCall('nbk_crazydeluxo_images',function(run)
        run("SHOW_RECORDS")
    end)
end)
AddEventHandler('nbk_crazydeluxo_images:set_records_arcade', function(rank,name,scores)
	--print(rank,name,scores)
    ScaleformCall('nbk_crazydeluxo_images',function(run)
        run("SET_RECORDS_ARCADE",tonumber(rank),"name",name)
		run("SET_RECORDS_ARCADE",tonumber(rank),"scores",scores)
    end)
end)
AddEventHandler('nbk_crazydeluxo_images:set_records_original', function(rank,name,scores)
    ScaleformCall('nbk_crazydeluxo_images',function(run)
        run("SET_RECORDS_ORIGINAL",tonumber(rank),"name",name)
		run("SET_RECORDS_ORIGINAL",tonumber(rank),"scores",scores)
    end)
end)
AddEventHandler('nbk_crazydeluxo_images:setCustomers', function(num)
    ScaleformCall('nbk_crazydeluxo_images',function(run)
        run("SET_CUSTOMERS",num)
    end)
end)
AddEventHandler('nbk_crazydeluxo_images:setTotalEarned', function(num)
    ScaleformCall('nbk_crazydeluxo_images',function(run)
        run("SET_TOTALEARNED",num)
    end)
end)

AddEventHandler('nbk_crazydeluxo_images:setRanking', function(txt,nowmode,total)
    ScaleformCall('nbk_crazydeluxo_images',function(run)
        run("SET_RANKING",txt)
		if nowmode and total then 
			SetRankIntoResult(nowmode,total)
		end 
    end)
end)
AddEventHandler('nbk_crazydeluxo_images:setClass', function(txt)
    ScaleformCall('nbk_crazydeluxo_images',function(run)
        run("SET_CLASS",txt)
    end)
end)
local AwaitingResult = nil 
function SetRankIntoResult(mode,total)
	CreateThread(function()
		TriggerServerEvent("es_ranking_db:getRecords",mode)
		AwaitingResult = promise.new()
      local recordsresult = Citizen.Await(AwaitingResult)
		local nowranking = 0
		--print(mode,#Records[mode])
		if recordsresult[1] then 
			for i=1,#recordsresult do 
				--print(TotalEarned,recordsresult[i].scores,i)
				if tonumber(total) <= tonumber(recordsresult[i].scores) then 
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
	if AwaitingResult then AwaitingResult:resolve(Records[mode]) end
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
PlayMusic = function(p_0,p_1,p_2)
	if (p_0 == 0) then
		TriggerMusicEvent("MP_MC_START");
	
	elseif (p_0 == 1) then
		TriggerMusicEvent("MP_MC_START_CITY");
	
	elseif (p_0 == 2) then
		TriggerMusicEvent("MP_MC_START_COUNTRY");
	
	elseif (p_0 == 3) then
		TriggerMusicEvent("MP_MC_START");
	
	elseif (p_0 == 4) then
		TriggerMusicEvent("MP_MC_START_CAR_STEAL_CHIPS_2");
	
	elseif (p_0 == 5) then
		TriggerMusicEvent("MP_MC_START_EYE_IN_SKY_3");
	
	elseif (p_0 == 6) then
		TriggerMusicEvent("MP_MC_START_FUNK_JAM_3");
	
	elseif (p_0 == 7) then
		TriggerMusicEvent("MP_MC_START_FUNK_JAM_TWO_4");
	
	elseif (p_0 == 8) then
		TriggerMusicEvent("MP_MC_START_BEYOND_4");
	
	elseif (p_0 == 9) then
		TriggerMusicEvent("MP_MC_START_BURNING_BAR_8");
	
	elseif (p_0 == 10) then
		TriggerMusicEvent("MP_MC_START_PB1_8");
	
	elseif (p_0 == 11) then
		TriggerMusicEvent("MP_MC_START_DARK_ROBBERY_8");
	
	elseif (p_0 == 12) then
		TriggerMusicEvent("MP_MC_START_DIAMOND_DIARY_8");
	
	elseif (p_0 == 13) then
		TriggerMusicEvent("MP_MC_START_DEBUNKED_8");
	
	elseif (p_0 == 14) then
		TriggerMusicEvent("MP_MC_START_PB2_PUSSYFACE_8");
	
	elseif (p_0 == 15) then
		TriggerMusicEvent("MP_MC_START_DR_DESTRUCTO_8");
	
	elseif (p_0 == 16) then
		TriggerMusicEvent("MP_MC_START_DRAGONER_8");
	
	elseif (p_0 == 17) then
		TriggerMusicEvent("MP_MC_START_GREYHOUND_8");
	
	elseif (p_0 == 18) then
		TriggerMusicEvent("MP_MC_START_MEATY_8");
	
	elseif (p_0 == 19) then
		TriggerMusicEvent("MP_MC_START_MISSION_SEVEN_8");
	
	elseif (p_0 == 20) then
		TriggerMusicEvent("MP_MC_START_NINE_BLURT_8");
	
	elseif (p_0 == 21) then
		TriggerMusicEvent("MP_MC_START_SCRAP_YARD_8");
	
	elseif (p_0 == 22) then
		TriggerMusicEvent("MP_MC_START_SILVER_PUSSY_8");
	
	elseif (p_0 == 23) then
		TriggerMusicEvent("MP_MC_START_VODKA_8");
	
	elseif (p_0 == 24) then
		TriggerMusicEvent("MP_MC_START_STREETS_OF_FORTUNE_8");
	
	elseif (p_0 == 25) then
		TriggerMusicEvent("MP_MC_START_TRACK_EIGHT_8");
	
	elseif (p_0 == 26) then
		TriggerMusicEvent("MP_MC_START_VACUUM_8");
	
	elseif (p_0 == 27) then
		TriggerMusicEvent("MP_MC_START_VINEGAR_TITS_8");
	
	elseif (p_0 == 28) then
		TriggerMusicEvent("MP_MC_START_CITY_8");
	
	elseif (p_0 == 29) then
		TriggerMusicEvent("MP_MC_START_GUN_NOVEL_8");
	
	elseif (p_0 == 30) then
		TriggerMusicEvent("MP_MC_START_CHOP_8");
	
	elseif (p_0 == 31) then
		TriggerMusicEvent("MP_MC_START_NT_ELC_8");
	
	elseif (p_0 == 32) then
		TriggerMusicEvent("MP_MC_START_NT_DEF_8");
	
	elseif (p_0 == 35) then
		TriggerMusicEvent("MP_MC_START_NT_TKB_4");
	
	elseif (p_0 == 33) then
		TriggerMusicEvent("MP_MC_START_HEIST_4");
	
	elseif (p_0 == 34) then
		TriggerMusicEvent("MP_MC_START_HEIST_8");
	
	elseif (p_0 == 36) then
		TriggerMusicEvent("MP_MC_START_HEIST_FIN_NEW");
	
	elseif (p_0 == 37) then
		TriggerMusicEvent("MP_MC_START_HEIST_PREP_NEW");
	
	elseif (p_0 == 39) then
		TriggerMusicEvent("START_RANDOM");
	
	elseif (p_0 == 40) then
		TriggerMusicEvent("START_URBAN");
	
	elseif (p_0 == 41) then
		TriggerMusicEvent("START_ROCK");
	
	elseif (p_0 == 42) then
		TriggerMusicEvent("START_ELECTRONIC");
	
	elseif (p_0 == 43) then
		TriggerMusicEvent("LOWRIDER_START_MUSIC");
	
	elseif (p_0 == 44) then
		TriggerMusicEvent("LOWRIDER_FINALE_START_MUSIC");
	
	elseif (p_0 == 45) then
		TriggerMusicEvent("HALLOWEEN_START_MUSIC");
	
	elseif (p_0 == 46) then
		if (not p_2) then
			TriggerMusicEvent("EXEC1_MP_MC_START_CITY");
		
		else
			TriggerMusicEvent("EXEC1_MP_MC_START_CITY_STA");
		
		end
	elseif (p_0 == 47) then
		TriggerMusicEvent("EXEC1_START_BESPOKE_BROKE");
	
	elseif (p_0 == 48) then
		TriggerMusicEvent("EXEC1_START_CAR_STEAL");
	
	elseif (p_0 == 49) then
		TriggerMusicEvent("EXEC1_START_CLIFF12");
	
	elseif (p_0 == 50) then
		TriggerMusicEvent("EXEC1_START_CLIFF18");
	
	elseif (p_0 == 51) then
		TriggerMusicEvent("EXEC1_START_CLIFF19");
	
	elseif (p_0 == 52) then
		TriggerMusicEvent("EXEC1_START_CLIFF33");
	
	elseif (p_0 == 53) then
		TriggerMusicEvent("EXEC1_START_GET_ON_THE_MOVE");
	
	elseif (p_0 == 54) then
		TriggerMusicEvent("EXEC1_START_PSYCHOPATH");
	
	elseif (p_0 == 55) then
		TriggerMusicEvent("EXEC1_START_RED_SQUARE");
	
	elseif (p_0 == 56) then
		TriggerMusicEvent("EXEC1_START_WHO_CALLED_POPO");
	
	elseif (p_0 == 57) then
		TriggerMusicEvent("BKR_GS_START");
	
	elseif (p_0 == 58) then
		TriggerMusicEvent("BKR_DEADLINE_START_MUSIC");
	
	elseif (p_0 == 59) then
		TriggerMusicEvent("BA_METZ_DEBUNKED");
	
	elseif (p_0 == 60) then
		TriggerMusicEvent("BIKER_LAD_START");
	
	elseif (p_0 == 61) then
		TriggerMusicEvent("IE_TW_START");
	
	elseif (p_0 == 62) then
		TriggerMusicEvent("IE_SVM_START");
	
	elseif (p_0 == 63) then
		TriggerMusicEvent("MP_MC_GR_START");
	
	elseif (p_0 == 64) then
		TriggerMusicEvent("MP_MC_SMG_START");
	
	elseif (p_0 == 65) then
		TriggerMusicEvent("MP_MC_SMGH_START");
	
	elseif (p_0 == 66) then
		TriggerMusicEvent("MP_MC_CMH_START");
	
	elseif (p_0 == 67) then
		TriggerMusicEvent("MP_MC_CMH_SUB_PREP_START");
	
	elseif (p_0 == 68) then
		TriggerMusicEvent("MP_MC_CMH_SUB_FINALE_START");
	
	elseif (p_0 == 69) then
		TriggerMusicEvent("MP_MC_CMH_SILO_PREP_START");
	
	elseif (p_0 == 70) then
		TriggerMusicEvent("MP_MC_CMH_SILO_FINALE_START");
	
	elseif (p_0 == 71) then
		TriggerMusicEvent("MP_MC_CMH_IAA_PREP_START");
	
	elseif (p_0 == 72) then
		TriggerMusicEvent("MP_MC_CMH_IAA_FINALE_START");
	
	elseif (p_0 == 73) then
		TriggerMusicEvent("CMH_ADV_START");
	
	elseif (p_0 == 74) then
		TriggerMusicEvent("MP_MC_ASSAULT_ADV_START");
	
	elseif (p_0 == 75) then
		TriggerMusicEvent("MP_MC_CASINO_BRAWL_START");
	
	elseif (p_0 == 76) then
		TriggerMusicEvent("MP_CHF_START");
	
	elseif (p_0 == 77) then
		TriggerMusicEvent("MP_MC_SUM20_START");
	
	elseif (p_0 == 78) then
		TriggerMusicEvent("HEI4_FIN_START_STA");
	
	elseif (p_0 == 79) then
		TriggerMusicEvent("MP_MC_TUNER_START_MUSIC");
	
	elseif (p_0 == 80) then
		TriggerMusicEvent("MP_MC_FIXER_HOLDOUT_START");
	
	elseif (p_0 == 81) then
		TriggerMusicEvent("MP_MC_FIXER_START_MUSIC");
	
	elseif (p_0 == 82) then
		TriggerMusicEvent("DATA_LEAK_GOLF_START_MUSIC");
	
	elseif (p_0 == 83) then
		TriggerMusicEvent("DATA_LEAK_PARTY_PROMO_START_MUSIC");
	
	elseif (p_0 == 84) then
		TriggerMusicEvent("DATA_LEAK_BILLIONAIRE_START_MUSIC");
	
	elseif (p_0 == 85) then
		TriggerMusicEvent("DATA_LEAK_HOOD_PASS_START_MUSIC");
	
	elseif (p_0 == 86) then
		TriggerMusicEvent("DATA_LEAK_FIRE_START_MUSIC");
	
	elseif (p_0 == 87) then
		TriggerMusicEvent("DATA_LEAK_DFWD_START_MUSIC");
	else
		TriggerMusicEvent("MP_MC_START");
	end 
end

loop_newthread(0,function()
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
			PlaySoundFrontend(-1, "PICK_UP", "HUD_FRONTEND_DEFAULT_SOUNDSET", true);
		end 
	end 
	-- ungly menu code
	if nowselection ~= nil and nowselection ~= -1 then 
		if IsControlJustReleased(0--[[control type]],  22--[[control index]]) or IsControlJustReleased(0--[[control type]],  23--[[control index]]) or IsControlJustReleased(0--[[control type]],  21--[[control index]]) then
			PlaySoundFrontend(-1, "PICK_UP", "HUD_FRONTEND_DEFAULT_SOUNDSET", true);
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
			PlaySoundFrontend(-1, "PICK_UP", "HUD_FRONTEND_DEFAULT_SOUNDSET", true);
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
			PlaySoundFrontend(-1, "PICK_UP", "HUD_FRONTEND_DEFAULT_SOUNDSET", true);
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
		PlaySoundFrontend(-1, "PICK_UP", "HUD_FRONTEND_DEFAULT_SOUNDSET", true);
		TriggerMusicEvent("FRA1_MISSION_FAIL");
		CancelMusicEvent("FRA1_SPEED")
		
		
		nowselection = nil 
		
	end 
	
end) 
TriggerServerEvent("es_ranking_db:getRecords","arcade")
TriggerServerEvent("es_ranking_db:getRecords","original")
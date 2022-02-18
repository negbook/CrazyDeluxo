LastCustomer = nil 
CurrentCustomer = nil 
Called = {}
NowTargetPosition = nil 
PreLoadCall = false 
CustomerWaitingBlips = {}
TimeLeft = 0
Fares = 0
Combo = 0
TotalEarned = 0
HeadNumber = -1
NowTargetCheckpoint = nil 
Ready = false 
TotalPassengers = 0
LastVehicle = nil 
nowselection = -1
nowmode = nil
EndGame = false 
Records = {}
Records["arcade"] = {}
Records["original"] = {}
ShowRecord = false 
function SetLessBudget()
	SetPedPopulationBudget(0);
	SetVehiclePopulationBudget(0);
	SetReducePedModelBudget(1);
	SetReduceVehicleModelBudget(1);
end
function SetMoreBudget()
	SetPedPopulationBudget(3);
	SetVehiclePopulationBudget(3);
	SetReducePedModelBudget(0);
	SetReduceVehicleModelBudget(0);
end
function MaxOut(ped,veh)
if not veh then 
	veh = GetVehiclePedIsIn(ped, false)
end 
	SetVehicleHandlingFloat(veh,"CHandlingData","fDriveInertia",2.0)
	SetVehicleHandlingFloat(veh,"CHandlingData","fSteeringLock",55.0)
	SetVehicleHandlingFloat(veh,"CHandlingData","fLowSpeedTractionLossMult",-1.0)
	SetVehicleHandlingFloat(veh,"CHandlingData","fTractionSpringDeltaMax",1.0)
	SetVehicleHandlingFloat(veh,"CHandlingData","fTractionLossMult",0.0)
	SetVehicleHandlingFloat(veh,"CHandlingData","fAntiRollBarForce",1.4)
	--SetVehicleHandlingFloat(veh,"CHandlingData","fInitialDriveForce",0.9)
	--SetVehicleHandlingFloat(veh,"CHandlingData","fBrakeForce",1.0)
	SetVehicleHandlingFloat(veh,"CHandlingData","fInitialDriveMaxFlatVel",200.0)
    SetVehicleModKit(veh, 0)
    --SetVehicleWheelType(veh, 0) -- sport 
	--SetVehicleMod(veh, 23, 21, false) -- 超级五号
    SetVehicleMod(veh, 0, GetNumVehicleMods(veh, 0) - 1, false)
    SetVehicleMod(veh, 1, GetNumVehicleMods(veh, 1) - 1, false)
    SetVehicleMod(veh, 2, GetNumVehicleMods(veh, 2) - 1, false)
    SetVehicleMod(veh, 3, GetNumVehicleMods(veh, 3) - 1, false)
    SetVehicleMod(veh, 4, GetNumVehicleMods(veh, 4) - 1, false)
    SetVehicleMod(veh, 5, GetNumVehicleMods(veh, 5) - 1, false)
    SetVehicleMod(veh, 6, GetNumVehicleMods(veh, 6) - 1, false)
    SetVehicleMod(veh, 7, GetNumVehicleMods(veh, 7) - 1, false)
    SetVehicleMod(veh, 8, GetNumVehicleMods(veh, 8) - 1, false)
    SetVehicleMod(veh, 9, GetNumVehicleMods(veh, 9) - 1, false)
    SetVehicleMod(veh, 10, GetNumVehicleMods(veh, 10) - 1, false)
    SetVehicleMod(veh, 11, GetNumVehicleMods(veh, 11) - 1, false)
    SetVehicleMod(veh, 12, GetNumVehicleMods(veh, 12) - 1, false)
    SetVehicleMod(veh, 13, GetNumVehicleMods(veh, 13) - 1, false)
    SetVehicleMod(veh, 14, 16, false)
    SetVehicleMod(veh, 15, GetNumVehicleMods(veh, 15) - 2, false)
    SetVehicleMod(veh, 16, GetNumVehicleMods(veh, 16) - 1, false)
    ToggleVehicleMod(veh, 17, true)
    ToggleVehicleMod(veh, 18, true)
    ToggleVehicleMod(veh, 19, true)
    ToggleVehicleMod(veh, 20, true)
    ToggleVehicleMod(veh, 21, true)
    ToggleVehicleMod(veh, 22, true)
    SetVehicleMod(veh, 24, 1, false)
    SetVehicleMod(veh, 25, GetNumVehicleMods(veh, 25) - 1, false)
    SetVehicleMod(veh, 27, GetNumVehicleMods(veh, 27) - 1, false)
    SetVehicleMod(veh, 28, GetNumVehicleMods(veh, 28) - 1, false)
    SetVehicleMod(veh, 30, GetNumVehicleMods(veh, 30) - 1, false)
    SetVehicleMod(veh, 33, GetNumVehicleMods(veh, 33) - 1, false)
    SetVehicleMod(veh, 34, GetNumVehicleMods(veh, 34) - 1, false)
    SetVehicleMod(veh, 35, GetNumVehicleMods(veh, 35) - 1, false)
    SetVehicleMod(veh, 38, GetNumVehicleMods(veh, 38) - 1, true)
    SetVehicleWindowTint(veh, 1)
    SetVehicleTyresCanBurst(veh, false)
    SetVehicleNumberPlateTextIndex(veh, 5)
end
function Reload()
	LastCustomer = nil 
	CurrentCustomer = nil 
	Called = {}
	NowTargetPosition = nil 
	PreLoadCall = false 
	CustomerWaitingBlips = {}
	TimeLeft = 0
	Fares = 0
	Combo = 0
	TotalEarned = 0
	HeadNumber = -1
	NowTargetCheckpoint = nil 
	Ready = false 
	TotalPassengers = 0
	CheckTouch = false 
	nowselection = -1
	TriggerEvent("nbk_crazydeluxo_draw:setFares",0)
	TriggerEvent("nbk_crazydeluxo_draw:setCrazyText","")
	TriggerEvent("nbk_crazydeluxo_draw:setCombo",0)
	TriggerEvent("nbk_crazydeluxo_draw:setTotalEarned",0)
	TriggerEvent("nbk_crazydeluxo_draw:setHeadNumber",-1,0.8,0.8)
	while not AreAllNavmeshRegionsLoaded() do 
		Wait(500)
	end 
	function StartPlaybackRecordedVehicleUsingAi(veh,num,str,flo,style)
		return Citizen.InvokeNative(0x29DE5FA52D00428C,veh, num, str, flo, style);
	end 
	function StartPlaybackRecordedVehicleWithFlags(veh,num,str,flo,style)
		return Citizen.InvokeNative(0x7D80FD645D4DA346,veh, num, str, flo, style);
	end 
	function HasVehicleRecordingBeenLoaded(num,str)
		return Citizen.InvokeNative(0x300D614A4C785FC4,num,str)
	end 
	if DoesEntityExist(LastVehicle) then 
		DeleteEntity(LastVehicle)
	end 
	SetWaypointOff()
end 
function FoundCall(ped)
	for i = 1,#Called do 
		if Called[i] == ped then 
			return true 
		end 
	end 
	return false 
end 
function MakeCall(ped)
	if not FoundCall(ped) then 
		SetBlockingOfNonTemporaryEvents(ped, true)
		CustomerWaitingBlips[ped] = AddBlipForEntity(ped)
		SetBlipAsFriendly(CustomerWaitingBlips[ped], true)
		SetBlipColour(CustomerWaitingBlips[ped], 2)
		SetBlipCategory(CustomerWaitingBlips[ped], 3)
		SetBlipRoute(CustomerWaitingBlips[ped], true)
		local standTime = GetRandomIntInRange(60000, 180000)
		ClearPedTasksImmediately(ped)
		TaskStandGuard(ped,GetEntityCoords(ped),GetEntityHeading(ped),"WORLD_HUMAN_GUARD_STAND")
		table.insert(Called,ped)
	end 
end 
function DrawSub(msg, time)
	ClearPrints()
	BeginTextCommandPrint('STRING')
	AddTextComponentSubstringPlayerName(msg)
	EndTextCommandPrint(time, 1)
end
function MakeCurrentCustomerGone()
	if IsPedInAnyVehicle(CurrentCustomer, false) then 
		local vehicle = GetVehiclePedIsIn(CurrentCustomer--[[playerPed]],  false)
		LastCustomer = CurrentCustomer
		TaskLeaveVehicle(CurrentCustomer,  vehicle,  0)
		TriggerEvent("nbk_crazydeluxo_draw:showWarning",false)
		HeadNumber = -1
		TriggerEvent("nbk_crazydeluxo_draw:setHeadNumber",HeadNumber,0.5,0.5)
		if NowTargetCheckpoint then 
			DeleteCheckpoint(NowTargetCheckpoint)
			NowTargetCheckpoint = nil
		end 
		Citizen.Wait(1000)
    end 
	SetPedAsNoLongerNeeded(CurrentCustomer)
end 
toFixed = function(num, fractionDigits, round)
	local fractionDigits = fractionDigits or 2
      local pcs = 1;
      for i=1,fractionDigits,1 do 
         pcs = pcs * 10;
      end 
      return (not round and math.floor(num * pcs) or math.floor(num * pcs+0.5)) / pcs;
end 
CreateThread(function()
	SetWeatherOwnedByNetwork(
		false --[[ boolean ]]
	)
	while true do Wait(0)
		if ShowRecord == true then 
			if IsControlJustReleased(0--[[control type]],  177--[[control index]]) then 
				Reload()
				Selection()
				ShowRecord = false 
			end 
		end 
		if EndGame == true then 
			  DisableControlAction(0,21,true) -- disable sprint
			  DisableControlAction(0,24,true) -- disable attack
			  DisableControlAction(0,25,true) -- disable aim
			  DisableControlAction(0,47,true) -- disable weapon
			  DisableControlAction(0,58,true) -- disable weapon
			  DisableControlAction(0,263,true) -- disable melee
			  DisableControlAction(0,264,true) -- disable melee
			  DisableControlAction(0,257,true) -- disable melee
			  DisableControlAction(0,140,true) -- disable melee
			  DisableControlAction(0,141,true) -- disable melee
			  DisableControlAction(0,142,true) -- disable melee
			  DisableControlAction(0,143,true) -- disable melee
			  DisableControlAction(0,75,true) -- disable exit vehicle
			  DisableControlAction(27,75,true) -- disable exit vehicle
			  DisableControlAction(0,22,true) -- disable sprint
			  DisableControlAction(0,23,true) -- disable sprint
			if IsDisabledControlJustReleased(0--[[control type]],  22--[[control index]]) or IsDisabledControlJustReleased(0--[[control type]],  23--[[control index]]) or IsDisabledControlJustReleased(0--[[control type]],  21--[[control index]]) then
				TriggerEvent("nbk_crazydeluxo_images:show_home")
				TriggerEvent("nbk_crazydeluxo_images:end")
				EndGame = false 
				DoScreenFadeOut(1000)
				Citizen.Wait(1000)
				DoScreenFadeIn(1000)
				Selection()
				   DisableControlAction(0,21,false) -- disable sprint
				   DisableControlAction(0,24,false) -- disable attack
				   DisableControlAction(0,25,false) -- disable aim
				   DisableControlAction(0,47,false) -- disable weapon
				   DisableControlAction(0,58,false) -- disable weapon
				  DisableControlAction(0,263,false) -- disable melee
				  DisableControlAction(0,264,false) -- disable melee
				  DisableControlAction(0,257,false) -- disable melee
				  DisableControlAction(0,140,false) -- disable melee
				  DisableControlAction(0,141,false) -- disable melee
				  DisableControlAction(0,142,false) -- disable melee
				  DisableControlAction(0,143,false) -- disable melee
				   DisableControlAction(0,75,false) -- disable exit vehicle
				  DisableControlAction(27,75,false) -- disable exit vehicle
				   DisableControlAction(0,22,false) -- disable sprint
				   DisableControlAction(0,23,false) -- disable sprint
			end 
		end 
		if nowselection ~= nil and nowselection ~= -1 then 
			if IsControlJustReleased(0--[[control type]],  22--[[control index]]) or IsControlJustReleased(0--[[control type]],  23--[[control index]]) or IsControlJustReleased(0--[[control type]],  21--[[control index]]) then
				if nowselection == 1 then 
					Selected_Arcade()
					--print('arcade')
					TriggerEvent("nbk_crazydeluxo_images:end")
					nowselection = -1
				elseif nowselection == 2 then 
					Selected_Original()
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
		SetWeatherTypeNow(
			"EXTRASUNNY" --[[ string ]]
		)
		NetworkOverrideClockTime(
	16 --[[ integer ]], 
	0--[[ integer ]], 
	0 --[[ integer ]]
)
		SetMaxWantedLevel(0)
		ClearPlayerWantedLevel(PlayerId())
		if (HeadNumber > 0) and CurrentCustomer then 
			local RightHeadLight = GetWorldPositionOfEntityBone(CurrentCustomer, GetPedBoneIndex(CurrentCustomer, 0x796E))
			local bool,xper,yper = GetScreenCoordFromWorldCoord(RightHeadLight.x,RightHeadLight.y,RightHeadLight.z)
			if bool and CurrentCustomer then 
				TriggerEvent("nbk_crazydeluxo_draw:setHeadNumber",HeadNumber,xper,yper)
			end 
		end 
		for i=1,#Called do 
			local coords = GetEntityCoords(Called[i])
			DrawMarker(25, coords.x,coords.y,coords.z-0.9, 0, 0, 0, 0, 0, 0, 6.0, 6.0, 2.5, 0, 157, 0, 155, 0, 0, 2, 0, 0, 0, 0)
			local passenger = Called[i]
			local vehicle = GetVehiclePedIsIn(PlayerPedId(),  false)
			local maxSeats, freeSeat = GetVehicleMaxNumberOfPassengers(vehicle)
			for i=maxSeats - 1, 0, -1 do
				if IsVehicleSeatFree(vehicle, i) then
					freeSeat = i
					break
				end
			end
			for i=1,#Called do 
				if # (GetEntityCoords(Called[i]) - GetEntityCoords(PlayerPedId())) > 50.0 then 
					if DoesBlipExist(CustomerWaitingBlips[Called[i]]) then
						RemoveBlip(CustomerWaitingBlips[Called[i]])
						table.remove(Called,i)
					end
				end 
			end 
			if freeSeat and # (GetEntityCoords(passenger) - GetEntityCoords(PlayerPedId())) < 5.0 and GetEntitySpeed(GetVehiclePedIsIn(PlayerPedId())) < 3.0 then 
				--print("go")
				ClearPedTasks(passenger);
				SetPedCanBeKnockedOffVehicle(passenger, 1);
				TaskEnterVehicle(passenger, GetVehiclePedIsIn(PlayerPedId()), 5000,0,2.0,1,0);
				SetBlockingOfNonTemporaryEvents(passenger, true)
				local coords = GetClosestSidewalk(GetEntityCoords(PlayerPedId()) + vector3(GetRandomFloatInRange(-500.0,500.0),GetRandomFloatInRange(-500.0,500.0),GetRandomFloatInRange(-500.0,500.0)))
				--print(coords.x,coords.y,coords.z)
				--SetEntityCoords(vehicle,coords.x,coords.y,coords.z)
				NowTargetPosition = coords
				if NowTargetPosition then 
					NowTargetCheckpoint = CreateCheckpoint(45, NowTargetPosition.x,NowTargetPosition.y,NowTargetPosition.z, NowTargetPosition.x,NowTargetPosition.y,NowTargetPosition.z-9999.0, 50.0, 0, 128, 255, 255, 99)
					SetCheckpointCylinderHeight(NowTargetCheckpoint,5.0 ,5.0,50.0)
				end 
				SetNewWaypoint(NowTargetPosition.x,NowTargetPosition.y)
				local street = table.pack(GetStreetNameAtCoord(NowTargetPosition.x, NowTargetPosition.y, NowTargetPosition.z))
				local msg    = nil
				local streetname = GetStreetNameFromHashKey(street[1])
				if street[2] ~= 0 and street[2] ~= nil then
					msg = "目的地:"..GetStreetNameFromHashKey(street[1]) .. " 在".. GetStreetNameFromHashKey(street[2]).."的附近"
				else
					msg = "目的地:"..streetname
				end
				DrawSub(msg,5000)
				PreLoadCall = false 
				CurrentCustomer = passenger
				Fares = toFixed(#(NowTargetPosition - GetEntityCoords(PlayerPedId())) * 0.8)
				TriggerEvent("nbk_crazydeluxo_draw:setFares",Fares)
				HeadNumber = math.floor(#(NowTargetPosition - GetEntityCoords(PlayerPedId())) *0.07 + 10)
				for i=1,#Called do 
					if DoesBlipExist(CustomerWaitingBlips[Called[i]]) then
						RemoveBlip(CustomerWaitingBlips[Called[i]])
					end
				end 
				Called = {}
			end 
		end 
		if NowTargetPosition and # (NowTargetPosition - GetEntityCoords(PlayerPedId())) < 50.0 and #(vector3(0.0,0.0,NowTargetPosition.z) - vector3(0.0,0.0,GetEntityCoords(PlayerPedId()).z)) < 5.0  then
			SetWaypointOff()
			TriggerEvent("nbk_crazydeluxo_draw:showWarning",true)
			PreLoadCall = true 
			if IsEntityInAir(GetVehiclePedIsIn(PlayerPedId())) == false then 
				if GetEntitySpeed(GetVehiclePedIsIn(PlayerPedId())) < 3.0   then 
					if nowmode == "arcade" then 
						if HeadNumber > math.floor(#(NowTargetPosition - GetEntityCoords(PlayerPedId())) *0.07 + 10) * 0.75 then 
							TimeLeft = TimeLeft + 15
							DrawSub("已獲得獎勵秒數:".."15秒\n".."已获得奖励秒数:".."15秒",5000)
						elseif HeadNumber > math.floor(#(NowTargetPosition - GetEntityCoords(PlayerPedId())) *0.07 + 10) * 0.5 then 
							TimeLeft = TimeLeft + 10
							DrawSub("已獲得獎勵秒數:".."10秒\n".."已获得奖励秒数:".."10秒",5000)
						elseif HeadNumber > math.floor(#(NowTargetPosition - GetEntityCoords(PlayerPedId())) *0.07 + 10) * 0.25 then 
							TimeLeft = TimeLeft + 5
							DrawSub("已獲得獎勵秒數:".."5秒\n".."已获得奖励秒数:".."5秒",5000)
						end 
					end 
					NowTargetPosition = nil 
					TotalEarned = toFixed(TotalEarned + Fares)
					TotalPassengers = TotalPassengers + 1 
					TriggerEvent("nbk_crazydeluxo_draw:setTotalEarned",TotalEarned)
					Fares = 0
					if Combo > 0 then Combo = 0 end 
					TriggerEvent("nbk_crazydeluxo_draw:setCrazyText","")
					TriggerEvent("nbk_crazydeluxo_draw:setCombo",Combo)
					TriggerEvent("nbk_crazydeluxo_draw:setFares",Fares)
					MakeCurrentCustomerGone()
					FreshPed() 
				end 
			end 
		end 
	end 
end)
Ingores = {} 
function GetClosestPed()
    local closestPed = 0
	local pedPool = GetGamePool('CPed')
    for i=1,#pedPool do
		local ped = pedPool[i]
		SetEntityProofs(ped, true, true, true, true, true, true, true, true);
		if ped ~= PlayerPedId() then 
			local distanceCheck = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetEntityCoords(ped), true)
			if distanceCheck <= 30.0 and ped ~= PlayerPedId() and not IsPedInAnyVehicle(ped) and not IsEntityInAir(ped) and not FoundCall(ped) and (GetPedType(ped) == 4 or GetPedType(ped) == 5) and not (LastCustomer == ped) then
				closestPed = ped
				break
			end
		end 
    end
    return closestPed
end
function FreshPed() 
    local closestped = GetClosestPed( )
	ped = closestped
	if ped ~= PlayerPedId() and not IsPedInAnyVehicle(ped) and IsPedOnFoot(ped) and not FoundCall(ped) and (GetPedType(ped) == 3 or GetPedType(ped) == 4) and not (LastCustomer == ped) then 
	   if IsPedInAnyVehicle(PlayerPedId())  then 
		   MakeCall(ped)
	   end 
	end 
end 	
function SetRank(mode)
	CreateThread(function()
		TriggerServerEvent("es_ranking_db:getRecords","arcade")
		TriggerServerEvent("es_ranking_db:getRecords","original")
		Wait(2000)
		local nowranking = 0
		--print(mode,#Records[mode])
		for i=1,#Records[mode] do 
			--print(TotalEarned,Records[mode][i].scores,i)
			if tonumber(TotalEarned) <= tonumber(Records[mode][i].scores) then 
				nowranking = i;
			end 
		end 
		--print(nowranking)
		TriggerEvent("nbk_crazydeluxo_images:setRanking",nowranking)
	end )
end 
CreateThread(function()
	local retval --[[ Any ]], groupHash = AddRelationshipGroup("Enemy");
	local retval --[[ Any ]], groupHash2 = AddRelationshipGroup("Crew");
	SetRelationshipBetweenGroups(5, groupHash2, groupHash);
	SetRelationshipBetweenGroups(5, groupHash, groupHash2);
	while true do Wait(1000)
		SetPedRelationshipGroupHash(
	PlayerPedId() --[[ Ped ]], 
	groupHash2 --[[ Hash ]]
)
		--[[
		for ped in EnumeratePeds() do
			if ped ~= PlayerPedId() and IsPedInAnyVehicle(ped) and not IsPedAPlayer(ped) then 
				SetPedAsEnemy(ped, true);
				SetEntityIsTargetPriority(ped, true, 0.0);
				SetPedKeepTask(ped, true);
				SetPedConfigFlag(ped, 132, true);
				SetPedConfigFlag(ped, 188, true);
				SetPedRelationshipGroupHash(ped,groupHash)
			end 
		end 
		--]]
		if Ready then 
			if TimeLeft == 0 then 
				Ready = false
				TriggerEvent("nbk_crazydeluxo_draw:setTimeleft","0")
				DoScreenFadeOut(1000)
				Citizen.Wait(1000)
				DoScreenFadeIn(1000)
				TriggerEvent("nbk_crazydeluxo_images:draw")
				TriggerEvent("nbk_crazydeluxo_images:show_result")
				TriggerEvent("nbk_crazydeluxo_images:setCustomers",TotalPassengers)
				TriggerEvent("nbk_crazydeluxo_images:setTotalEarned",tostring(TotalEarned))
				--print(TotalEarned)
				TriggerServerEvent("es_ranking_db:createRecord",TotalEarned,nowmode,GetPlayerName(PlayerId()))
				TriggerEvent("nbk_crazydeluxo_images:setRanking","???")
				SetRank(nowmode)
				local class = "D"
				if nowmode == "arcade" then 
					if TotalEarned > 1000 then 
						class = "C"
					end 
					if TotalEarned > 1500 then 
						class = "B"
					end 
					if TotalEarned > 2000 then 
						class = "A"
					end 
					if TotalEarned > 2500 then 
						class = "S"
					end 
					if TotalEarned > 3000 then 
						class = "SS"
					end 
					if TotalEarned > 3500 then 
						class = "SSS"
					end 
				elseif nowmode == "original" then  
					if TotalEarned > 8000 then 
						class = "C"
					end 
					if TotalEarned > 10000 then 
						class = "B"
					end 
					if TotalEarned > 12000 then 
						class = "A"
					end 
					if TotalEarned > 14000 then 
						class = "S"
					end 
					if TotalEarned > 18000 then 
						class = "SS"
					end 
					if TotalEarned > 22000 then 
						class = "SSS"
					end 
				end 
				TriggerEvent("nbk_crazydeluxo_images:setClass",class)
				nowmode = nil
				EndGame = true 
				if DoesEntityExist(LastVehicle) then 
					DeleteEntity(LastVehicle)
				end 
			else 
				if (TimeLeft > 0) then 
					TimeLeft = TimeLeft - 1
					TriggerEvent("nbk_crazydeluxo_draw:setTimeleft",tostring(TimeLeft))
				end 
			end 
			if HeadNumber == 0 then 
				SetWaypointOff()
				PreLoadCall = true 
				NowTargetPosition = nil 
				Fares = 0
				if Combo > 0 then Combo = 0 end 
				TriggerEvent("nbk_crazydeluxo_draw:setCrazyText","")
				TriggerEvent("nbk_crazydeluxo_draw:setCombo",Combo)
				TriggerEvent("nbk_crazydeluxo_draw:setFares",Fares)
				MakeCurrentCustomerGone()
				FreshPed() 
				TaskVehicleTempAction(PlayerPedId() --[[ Ped ]],GetVehiclePedIsIn(PlayerPedId()) --[[ Vehicle ]],27 --[[ integer ]],5000 --[[ integer ]])
				--TriggerEvent("nbk_crazydeluxo_draw:setHeadNumber",HeadNumber,0.5,0.5)
			else 
				if (HeadNumber > 0) then 
					HeadNumber =  HeadNumber - 1
				end 
			end 
		end
	end 
end)
CreateThread(function()
	while true do Wait(100)
		--目的地和起點分別刷新
		if (NowTargetPosition == nil or PreLoadCall == true) and #Called <= 10 and Ready then 
			FreshPed()
		end 
	end 
end)
function Selection()
	--print('selection(')
	TriggerEvent("nbk_crazydeluxo_images:draw")
	TriggerEvent("nbk_crazydeluxo_images:show_home")
	nowselection = 1
	TriggerEvent("nbk_crazydeluxo_images:selection_arcade")
end 
function Selected_Arcade()
	--exports.spawnmanager:setAutoSpawn(true)
	exports.spawnmanager:spawnPlayer(1,SpawnCallback)
	nowmode = "arcade"
end 
function Selected_Original()
	--exports.spawnmanager:setAutoSpawn(true)
	exports.spawnmanager:spawnPlayer(1,SpawnCallback)
	nowmode = "original"
end 
AddEventHandler('onClientMapStart', function()
	--print('Map Start')
	exports.spawnmanager:setAutoSpawn(false)
	SpawnCallback = function()
		Reload()
		RequestModel(`deluxo`)
		--print('deluxo')
		while not HasModelLoaded(`deluxo`) do Wait(100) end 
		local retval --[[ boolean ]], heading --[[ number ]], unknown1
		local nthClosest = 1
		local coords = GetEntityCoords(PlayerPedId())+vector3(GetRandomIntInRange(-500,500),GetRandomIntInRange(-500,500),GetRandomIntInRange(-500,500))
		repeat
			if not retval  then
				retval --[[ boolean ]], coords --[[ vector3 ]], heading --[[ number ]], unknown1 = GetNthClosestVehicleNodeWithHeading(coords.x,coords.y,coords.z, nthClosest, 1, 1077936128, 0)
			end
			nthClosest=nthClosest+1;
			Wait(0)
		until retval or nthClosest > 25
		--print(retval,nthClosest)
		local vehicle = CreateVehicle(`deluxo`, coords.x,coords.y,coords.z, heading, 1, 0)
			SetVehicleColours(
			vehicle --[[ Vehicle ]], 
			88 --[[ integer ]], 
			88 --[[ integer ]]
		)
		SetEntityHeading(vehicle,heading)
		local rand
		rand = GetRandomIntInRange(20,30)
		--print(rand)
		RequestVehicleRecording(rand, "fm_taxi")
		while not HasVehicleRecordingBeenLoaded(rand, "fm_taxi") do 
		Wait(100)
		end 
		StartPlaybackRecordedVehicle(vehicle, rand, "fm_taxi", true);
		SetPlaybackSpeed(vehicle,0.8)
		SetVehicleActiveDuringPlayback(vehicle, true);
		if IsPlaybackGoingOnForVehicle(vehicle) then
			StopPlaybackRecordedVehicle(vehicle);
		end
		SetVehicleOnGroundProperly(vehicle)
		SetModelAsNoLongerNeeded(`deluxo`) -- deluxo,primo
		ClearPedTasks(PlayerPedId());
		SetPedCanBeKnockedOffVehicle(PlayerPedId(), 1);
		SetPedIntoVehicle(PlayerPedId(), vehicle, -1);
		SetEntityProofs(vehicle, true, true, true, true, true, true, true, true);
		SetEntityProofs(PlayerPedId(), true, true, true, true, true, true, true, true);
		LastVehicle = vehicle;
		SetVehicleAsNoLongerNeeded(vehicle)
		DrawSub("此載具可以變形為飛行/漂浮模式\n此载具可以变形为飞行/漂浮模式",5000)
		if GetVehicleWeaponCapacity(vehicle, 0) ~= 0 then
			SetVehicleWeaponCapacity(vehicle, 0, 0);
		end
		if GetVehicleWeaponCapacity(vehicle, 1) ~= 0 then
			SetVehicleWeaponCapacity(vehicle, 1, 0);
		end
		if not IsVehicleWeaponDisabled(`vehicle_weapon_deluxo_mg`, vehicle, PlayerPedId()) then
			DisableVehicleWeapon(true, `vehicle_weapon_deluxo_mg`, vehicle, PlayerPedId());
		end
		if not IsVehicleWeaponDisabled(`vehicle_weapon_deluxo_missile`, vehicle, PlayerPedId()) then
			DisableVehicleWeapon(true, `vehicle_weapon_deluxo_missile`, vehicle, PlayerPedId());
		end
		MaxOut(PlayerPedId(),vehicle)
		FreezeEntityPosition(vehicle, true);
		Ready = false
		TaskVehicleTempAction(PlayerPedId() --[[ Ped ]],vehicle --[[ Vehicle ]],30 --[[ integer ]],4000 --[[ integer ]])
		CreateThread(function()
			Wait(4000)
			FreezeEntityPosition(vehicle, false);
			Ready = true
			if nowmode == "arcade" then 
				TimeLeft = 120
			elseif nowmode == "original" then 
				TimeLeft = 900
			else 
				TimeLeft = 30
			end 
		end)
		Wait(500)
	end
	Reload()
	Selection()
end)
function GetGroundZ(input)
	local coords = input
    local x,y,z = coords.x,coords.y,coords.z 
    local bottom,top = GetHeightmapBottomZForPosition(x,y), GetHeightmapTopZForPosition(x,y)
    local steps = 10
	local updown = math.random(50,100)
	updown = updown > 50 and 1 or -1
    local foundGround
    local height = updown == 1 and bottom + 0.0 or top +0.0
    while not foundGround and height < top  do 
        foundGround, zPos = GetGroundZFor_3dCoord(x,y, height )
        height = height + steps*updown
    end 
	output = vector3(input.x,input.y,height)
	return output
end 
function GetClosestSidewalk(InputPos)
	local targetPos = InputPos and InputPos + 0.0 or GetEntityCoords(PlayerPedId())
	local bool, safe, safepos , finalpos, nthClosest
	nthClosest = 1;
	finalpos =  targetPos ;
	repeat
		if not bool or not safe then
			bool,finalpos = GetNthClosestVehicleNode(targetPos.x,targetPos.y,targetPos.z, nthClosest, 1, 1077936128, 0)
			safe,safepos = GetSafeCoordForPed(finalpos.x,finalpos.y,finalpos.z, true, 1);
		end
		nthClosest=nthClosest+1;
		Wait(0)
	until safe or nthClosest > 25
	if safe then finalpos = safepos end 
	local _, fincoords = bool,finalpos --GetNthClosestVehicleNode(targetPos.x, targetPos.y, targetPos.z,  1, 1077936128, 0)
	return fincoords
end  
AddEventHandler('populationPedCreating', function(x, y, z, model, setters)
end)
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
function IsAnyVehicleNearPlayer()
	local coords = GetEntityCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false))
	if IsAnyVehicleNearPoint(coords,5.0) then 
		local closestveh = GetClosestVehicle(coords,5.0, 0, 232319) --cars
		if closestveh == 0 then closestveh = GetClosestVehicle(coords, 5.0, 0, 392063)  end --airs 
		if closestveh ~= 0  then return true end
	end 
	return false,closestveh
end 
CreateThread(function()
	local function angle(veh)
		local GEV = GetEntityVelocity
		local GER = GetEntityRotation
		if not veh then return false end
		local vx,vy,vz = table.unpack(GEV(veh))
		local modV = math.sqrt(vx*vx + vy*vy)
		local rx,ry,rz = table.unpack(GER(veh,0))
		local sn,cs = -math.sin(math.rad(rz)), math.cos(math.rad(rz))
		if GetEntitySpeed(veh)* 3.6 < 30 or GetVehicleCurrentGear(veh) == 0 then return 0,modV end --speed over 30 km/h
		local cosX = (sn*vx + cs*vy)/modV
		if cosX > 0.966 or cosX < 0 then return 0,modV end
		return math.deg(math.acos(cosX))*0.5, modV
	end
	local drifting = false 
	local driftSet = false
	
	local driftingPoint = 0
	CreateThread(function()
		while true do Wait(50)
			local angle,velocity = angle(GetVehiclePedIsIn(PlayerPedId()))
			if angle ~= 0 then
				if driftingPoint > 10 then 
					drifting = true
					driftingPoint = 0
				end 
				driftingPoint = driftingPoint + 1
			end
			if angle == 0 then 
				drifting = false
				driftSet = false
				driftingPoint = 0
			end 
		end 
	end)
	while true do Wait(50)
		
		if HasEntityCollidedWithAnything(GetVehiclePedIsIn(PlayerPedId()))   then 
			--ClearEntityLastDamageEntity(GetVehiclePedIsIn(PlayerPedId()))

			if Combo > 0 then 
				Combo = 0 
				TriggerEvent("nbk_crazydeluxo_draw:setCrazyText","")
				TriggerEvent("nbk_crazydeluxo_draw:setCombo",Combo)
			end 
			
		end 
		if not GetIsTaskActive(PlayerPedId(),159) then 
			SetEntityVisible(PlayerPedId(),false, 0)
			if DoesEntityExist(LastVehicle) then 
				SetPedIntoVehicle(PlayerPedId(), LastVehicle, -1);
			end 
		end 
		if IsPedInAnyVehicle(PlayerPedId()) then 
			SetEntityVisible(PlayerPedId(),true, 0)
			SetMoreBudget()
			local near,veh = IsAnyVehicleNearPlayer()
			if IsPedInAnyVehicle(PlayerPedId()) and near and CheckTouch == false then 
				CheckTouch = true 
			elseif IsPedInAnyVehicle(PlayerPedId()) and not near and CheckTouch == true then
				CheckTouch = false
				if NowTargetPosition and GetEntitySpeed(GetVehiclePedIsIn(PlayerPedId())) > 25.0 then 
					--print("Get touch Fares") --撞擊後無法獲得分數
					local Gets = 0.25*Combo * (IsEntityInAir(GetVehiclePedIsIn(PlayerPedId())) and 2 or 5)
					Fares = Fares + Gets
					TriggerEvent("nbk_crazydeluxo_draw:setFares",Fares)
					if Gets > 0 then 
						TriggerEvent("nbk_crazydeluxo_draw:getcoin",Gets)
					end 
					TriggerEvent("nbk_crazydeluxo_draw:setCrazyText",IsEntityInAir(GetVehiclePedIsIn(PlayerPedId())) and "Crazy Shuffle Through!" or "Crazy Through!")
					Combo = Combo + 1
					TriggerEvent("nbk_crazydeluxo_draw:setCombo",Combo)
					--print(Combo)
				end 
			end 
			if GetEntitySpeed(GetVehiclePedIsIn(PlayerPedId())) > 20.0 and NowTargetPosition then 
				if NowTargetPosition and drifting and not driftSet then 
					driftSet = true 
					drifting = false
					local Gets = 0.25*Combo * (IsEntityInAir(GetVehiclePedIsIn(PlayerPedId())) and 2 or 5)
					Fares = Fares + Gets
					TriggerEvent("nbk_crazydeluxo_draw:setFares",Fares)
					if Gets > 0 then 
						TriggerEvent("nbk_crazydeluxo_draw:getcoin",Gets)
					end 
					TriggerEvent("nbk_crazydeluxo_draw:setCrazyText",IsEntityInAir(GetVehiclePedIsIn(PlayerPedId())) and "Crazy Shuffle!" or "Crazy Drift!")
					Combo = Combo + 1
					TriggerEvent("nbk_crazydeluxo_draw:setCombo",Combo)
				end 
			end 
		end 
	end 
end)
AddEventHandler('onResourceStart', function(resourceName)
  if (GetCurrentResourceName() == resourceName or resourceName == "nbk_crazydeluxo_images") then
      if IsScreenFadedOut() or IsScreenFadingOut() then DoScreenFadeIn(100) 
		if DoesEntityExist(LastVehicle) then DeleteEntity(LastVehicle);LastVehicle=nil end 
		Reload()
		Selection()
	  end
  end
end)
AddEventHandler('onResourceStop', function(resourceName)
  if (GetCurrentResourceName() == resourceName or resourceName == "nbk_crazydeluxo_images") then
	  if DoesEntityExist(LastVehicle) then DeleteEntity(LastVehicle);LastVehicle=nil end 
      DoScreenFadeOut(100)
  end
end)
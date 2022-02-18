CreateThread(function() while true do Wait(0)
		if EndGame == true then 
			    DisableControls()
			if IsDisabledControlJustReleased(0--[[control type]],  22--[[control index]]) or IsDisabledControlJustReleased(0--[[control type]],  23--[[control index]]) or IsDisabledControlJustReleased(0--[[control type]],  21--[[control index]]) then
				TriggerEvent("nbk_crazydeluxo_images:show_home")
				TriggerEvent("nbk_crazydeluxo_images:end")
				EndGame = false 
				DoScreenFadeOut(1000)
				Citizen.Wait(1000)
				DoScreenFadeIn(1000)
				Selection()
				EnableControls()
			end 
		end 
		SetWeatherTypeNow("EXTRASUNNY") -- keep sunny
		NetworkOverrideClockTime(16 , 0, 0 ) -- keep day time 
		SetMaxWantedLevel(0)
		ClearPlayerWantedLevel(PlayerId())
		if IsDuringJob() and (HeadNumber > 0) and CurrentCustomer then 
			local RightHeadLight = GetWorldPositionOfEntityBone(CurrentCustomer, GetPedBoneIndex(CurrentCustomer, 0x796E))
			local bool,xper,yper = GetScreenCoordFromWorldCoord(RightHeadLight.x,RightHeadLight.y,RightHeadLight.z)
			if bool and CurrentCustomer then 
				TriggerEvent("nbk_crazydeluxo_draw:setHeadNumber",HeadNumber,xper,yper)
			end 
		end 
		for i=1,#PedsWhoCalled do 
			local coords = GetEntityCoords(PedsWhoCalled[i])
			DrawMarker(25, coords.x,coords.y,coords.z-0.9, 0, 0, 0, 0, 0, 0, 6.0, 6.0, 2.5, 0, 157, 0, 155, 0, 0, 2, 0, 0, 0, 0)
			local passenger = PedsWhoCalled[i]
			local vehicle = GetVehiclePedIsIn(PlayerPedId(),  false)
			local maxSeats, freeSeat = GetVehicleMaxNumberOfPassengers(vehicle)
			for i=maxSeats - 1, 0, -1 do
				if IsVehicleSeatFree(vehicle, i) then
					freeSeat = i
					break
				end
			end
			for i=1,#PedsWhoCalled do 
				if # (GetEntityCoords(PedsWhoCalled[i]) - GetEntityCoords(PlayerPedId())) > 50.0 then 
					if DoesBlipExist(CustomerWaitingBlips[PedsWhoCalled[i]]) then
						RemoveBlip(CustomerWaitingBlips[PedsWhoCalled[i]])
						table.remove(PedsWhoCalled,i)
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
				JobTargetingPos = coords
				if JobTargetingPos then 
					NowTargetCheckpoint = CreateCheckpoint(45, JobTargetingPos.x,JobTargetingPos.y,JobTargetingPos.z, JobTargetingPos.x,JobTargetingPos.y,JobTargetingPos.z-9999.0, 50.0, 0, 128, 255, 255, 99)
					SetCheckpointCylinderHeight(NowTargetCheckpoint,5.0 ,5.0,50.0)
				end 
				SetNewWaypoint(JobTargetingPos.x,JobTargetingPos.y)
				local street = table.pack(GetStreetNameAtCoord(JobTargetingPos.x, JobTargetingPos.y, JobTargetingPos.z))
				local msg    = nil
				local streetname = GetStreetNameFromHashKey(street[1])
				if street[2] ~= 0 and street[2] ~= nil then
					msg = "目的地:"..GetStreetNameFromHashKey(street[1]) .. " 在".. GetStreetNameFromHashKey(street[2]).."的附近"
				else
					msg = "目的地:"..streetname
				end
				DrawSub(msg,5000)
				IsPrepareToCallingNextPed = false 
				CurrentCustomer = passenger
				Fares = math.fix(#(JobTargetingPos - GetEntityCoords(PlayerPedId())) * 0.8)
				TriggerEvent("nbk_crazydeluxo_draw:setFares",Fares)
				HeadNumber = math.floor(#(JobTargetingPos - GetEntityCoords(PlayerPedId())) *0.07 + 10)
				for i=1,#PedsWhoCalled do 
					if DoesBlipExist(CustomerWaitingBlips[PedsWhoCalled[i]]) then
						RemoveBlip(CustomerWaitingBlips[PedsWhoCalled[i]])
					end
				end 
				PedsWhoCalled = {}
			end 
		end 
		if JobTargetingPos and # (JobTargetingPos - GetEntityCoords(PlayerPedId())) < 50.0 and #(vector3(0.0,0.0,JobTargetingPos.z) - vector3(0.0,0.0,GetEntityCoords(PlayerPedId()).z)) < 5.0  then
			SetWaypointOff()
			TriggerEvent("nbk_crazydeluxo_draw:showWarning",true)
			IsPrepareToCallingNextPed = true 
			if IsEntityInAir(GetVehiclePedIsIn(PlayerPedId())) == false then 
				if GetEntitySpeed(GetVehiclePedIsIn(PlayerPedId())) < 3.0   then 
					if nowmode == "arcade" then 
						if HeadNumber > math.floor(#(JobTargetingPos - GetEntityCoords(PlayerPedId())) *0.07 + 10) * 0.75 then 
							TimeLeft = TimeLeft + 15
							DrawSub("已獲得獎勵秒數:".."15秒\n".."已获得奖励秒数:".."15秒",5000)
						elseif HeadNumber > math.floor(#(JobTargetingPos - GetEntityCoords(PlayerPedId())) *0.07 + 10) * 0.5 then 
							TimeLeft = TimeLeft + 10
							DrawSub("已獲得獎勵秒數:".."10秒\n".."已获得奖励秒数:".."10秒",5000)
						elseif HeadNumber > math.floor(#(JobTargetingPos - GetEntityCoords(PlayerPedId())) *0.07 + 10) * 0.25 then 
							TimeLeft = TimeLeft + 5
							DrawSub("已獲得獎勵秒數:".."5秒\n".."已获得奖励秒数:".."5秒",5000)
						end 
					end 
					JobTargetingPos = nil 
					TotalEarned = math.fix(TotalEarned + Fares)
					TotalPassengers = TotalPassengers + 1 
					TriggerEvent("nbk_crazydeluxo_draw:setTotalEarned",TotalEarned)
					Fares = 0
					if Combo > 0 then Combo = 0 end 
					TriggerEvent("nbk_crazydeluxo_draw:setCrazyText","")
					TriggerEvent("nbk_crazydeluxo_draw:setCombo",Combo)
					TriggerEvent("nbk_crazydeluxo_draw:setFares",Fares)
					MakeCurrentCustomerGone()
					SearchPed(function(ped)
						MakeCall(ped)
					end) 
				end 
			end 
		end 
end end)
CreateThread(function()
	local retval , groupHash = AddRelationshipGroup("Enemy");
	local retval , groupHash2 = AddRelationshipGroup("Crew");
	SetRelationshipBetweenGroups(5, groupHash2, groupHash);
	SetRelationshipBetweenGroups(5, groupHash, groupHash2);
	while true do Wait(1000)
		SetPedRelationshipGroupHash(
			PlayerPedId(), 
			groupHash2 
		)
		if IsPlaying then 
			if TimeLeft == 0 then 
				IsPlaying = false
				TriggerEvent("nbk_crazydeluxo_draw:setTimeleft","0")
				TriggerEvent("nbk_crazydeluxo_draw:setTimeleft","0",0.1,0.1)
				DoScreenFadeOut(1000)
				Citizen.Wait(1000)
				DoScreenFadeIn(1000)
				TriggerEvent("nbk_crazydeluxo_images:draw")
				TriggerEvent("nbk_crazydeluxo_images:show_result")
				TriggerEvent("nbk_crazydeluxo_images:setCustomers",TotalPassengers)
				TriggerEvent("nbk_crazydeluxo_images:setTotalEarned",tostring(TotalEarned))
				--print(TotalEarned)
				TriggerServerEvent("es_ranking_db:createRecord",TotalEarned,nowmode,GetPlayerName(PlayerId()))
				TriggerEvent("nbk_crazydeluxo_images:setRanking","???",nowmode,TotalEarned)
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
				IsPrepareToCallingNextPed = true 
				JobTargetingPos = nil 
				Fares = 0
				if Combo > 0 then Combo = 0 end 
				TriggerEvent("nbk_crazydeluxo_draw:setCrazyText","")
				TriggerEvent("nbk_crazydeluxo_draw:setCombo",Combo)
				TriggerEvent("nbk_crazydeluxo_draw:setFares",Fares)
				MakeCurrentCustomerGone()
				SearchPed(function(ped)
					MakeCall(ped)
				end) 
				TaskVehicleTempAction(PlayerPedId() --[[ Ped ]],GetVehiclePedIsIn(PlayerPedId()) --[[ Vehicle ]],27 --[[ integer ]],5000 --[[ integer ]])
				--TriggerEvent("nbk_crazydeluxo_draw:setHeadNumber",HeadNumber,0.5,0.5)
			else 
				if (HeadNumber > 0) then 
					HeadNumber =  HeadNumber - 1
				end 
			end 
		end
end end)
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
		IsPlaying = false
		TaskVehicleTempAction(PlayerPedId() --[[ Ped ]],vehicle --[[ Vehicle ]],30 --[[ integer ]],4000 --[[ integer ]])
		CreateThread(function()
			Wait(4000)
			FreezeEntityPosition(vehicle, false);
			IsPlaying = true
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
		if IsPauseMenuActive() then 
			SetFrontendActive(false);
			SetPauseMenuActive(false)
			Reload()
			Selection()
		end 
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
				CreateThread(function()
					while not (PrepareMusicEvent("FH2A_FINAL_DRIVE_RADIO")) do Wait(100)
						
					end 
					TriggerMusicEvent("FH2A_FINAL_DRIVE_RADIO");
					return
				end)
			end 
		end 
		if IsPedInAnyVehicle(PlayerPedId()) then 
			SetEntityVisible(PlayerPedId(),true, 0)
			SetMoreBudget()
			local isNearVehicle = IsAnyVehicleNearPlayer()
			if IsPedInAnyVehicle(PlayerPedId()) and isNearVehicle and CheckTouchNearVehicle == false then 
				CheckTouchNearVehicle = true 
			elseif IsPedInAnyVehicle(PlayerPedId()) and not isNearVehicle and CheckTouchNearVehicle == true then
				CheckTouchNearVehicle = false
				if IsDuringJob() and GetEntitySpeed(GetVehiclePedIsIn(PlayerPedId())) > 25.0 then 
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
			local isNearObject = IsAnyObjectNearPlayer()
			if IsPedInAnyVehicle(PlayerPedId()) and isNearObject and CheckTouchNearObject == false then 
				CheckTouchNearObject = true 
			elseif IsPedInAnyVehicle(PlayerPedId()) and not isNearObject and CheckTouchNearObject == true then
				CheckTouchNearObject = false
				if IsDuringJob() and GetEntitySpeed(GetVehiclePedIsIn(PlayerPedId())) > 25.0 then 
					--print("Get touch Fares") --撞擊後無法獲得分數
					local Gets = 0.25 * Combo * 1
					Fares = Fares + Gets
					TriggerEvent("nbk_crazydeluxo_draw:setFares",Fares)
					if Gets > 0 then 
						TriggerEvent("nbk_crazydeluxo_draw:getcoin",Gets)
					end 
					TriggerEvent("nbk_crazydeluxo_draw:setCrazyText","Crazy Dangerous Through!")
					Combo = Combo + 1
					TriggerEvent("nbk_crazydeluxo_draw:setCombo",Combo)
					--print(Combo)
				end 
			end 
			if GetEntitySpeed(GetVehiclePedIsIn(PlayerPedId())) > 20.0 and IsDuringJob() then 
				if drifting and not driftSet then 
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
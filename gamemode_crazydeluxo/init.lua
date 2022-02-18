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
function StartPlaybackRecordedVehicleUsingAi(veh,num,str,flo,style)
	return Citizen.InvokeNative(0x29DE5FA52D00428C,veh, num, str, flo, style);
end 
function StartPlaybackRecordedVehicleWithFlags(veh,num,str,flo,style)
	return Citizen.InvokeNative(0x7D80FD645D4DA346,veh, num, str, flo, style);
end 
function HasVehicleRecordingBeenLoaded(num,str)
	return Citizen.InvokeNative(0x300D614A4C785FC4,num,str)
end 
function DrawSub(msg, time)
	ClearPrints()
	BeginTextCommandPrint('STRING')
	AddTextComponentSubstringPlayerName(msg)
	EndTextCommandPrint(time, 1)
end
function IsAnyVehicleNearPlayer()
	local coords = GetEntityCoords(GetVehiclePedIsIn(GetPlayerPed(-1), false))
	if IsAnyVehicleNearPoint(coords,5.0) then 
		local closestveh = GetClosestVehicle(coords,5.0, 0, 232319) --cars
		if closestveh == 0 then closestveh = GetClosestVehicle(coords, 5.0, 0, 392063)  end --airs 
		if closestveh ~= 0  then return true end
	end 
	return false,closestveh
end 
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

math.fix = function(num, fractionDigits, round)
	local fractionDigits = fractionDigits or 2
      local pcs = 1;
      for i=1,fractionDigits,1 do 
         pcs = pcs * 10;
      end 
      return (not round and math.floor(num * pcs) or math.floor(num * pcs+0.5)) / pcs;
end 


function Reload(first)
	LastCustomer = nil 
	CurrentCustomer = nil 
	PedsWhoCalled = {}
	JobTargetingPos = nil 
	IsPrepareToCallingNextPed = false 
	CustomerWaitingBlips = {}
	TimeLeft = 0
	Fares = 0
	Combo = 0
	TotalEarned = 0
	HeadNumber = -1
	NowTargetCheckpoint = nil 
	IsPlaying = false 
	TotalPassengers = 0
	CheckTouch = false 
	if DoesEntityExist(LastVehicle) then 
		DeleteEntity(LastVehicle)
	end 
	LastVehicle = nil 
	TriggerEvent("nbk_crazydeluxo_draw:setTimeleft",0)
	TriggerEvent("nbk_crazydeluxo_draw:showWarning",false)
	TriggerEvent("nbk_crazydeluxo_draw:setFares",0)
	TriggerEvent("nbk_crazydeluxo_draw:setCrazyText","")
	TriggerEvent("nbk_crazydeluxo_draw:setCombo",0)
	TriggerEvent("nbk_crazydeluxo_draw:setTotalEarned",0)
	TriggerEvent("nbk_crazydeluxo_draw:setHeadNumber",-1,0.8,0.8)
	SetWaypointOff()

end 
Reload(true)

function IsDuringJob()
	return not not JobTargetingPos
end 

function FoundCall(ped)
	for i = 1,#PedsWhoCalled do 
		if PedsWhoCalled[i] == ped then 
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
		table.insert(PedsWhoCalled,ped)
	end 
end 

CreateThread(function()
	while true do Wait(100)
		--目的地和起點分別刷新
		if (IsPrepareToCallingNextPed or not IsDuringJob()) and #PedsWhoCalled <= 10 and IsPlaying then 
			SearchPed(function(ped)
				MakeCall(ped)
			end) 
		end 
	end 
end)

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

function SearchPed(cb) 
    local closestped = GetClosestPed( )
	ped = closestped
	if ped ~= PlayerPedId() and not IsPedInAnyVehicle(ped) and IsPedOnFoot(ped) and not FoundCall(ped) and (GetPedType(ped) == 3 or GetPedType(ped) == 4) and not (LastCustomer == ped) then 
	   if IsPedInAnyVehicle(PlayerPedId())  then 
		   if cb then cb(ped) end 
	   end 
	end 
end 	

CreateThread(function() --environment
	SetWeatherOwnedByNetwork(false)
end)


function DisableControls()
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
	DisableControlAction(0,22,true) -- disable sprint
	DisableControlAction(0,23,true) -- disable sprint
end 
function EnableControls()
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



AddEventHandler('onResourceStart', function(resourceName)
  if (GetCurrentResourceName() == resourceName or resourceName == "nbk_crazydeluxo_images") then
      if IsScreenFadedOut() or IsScreenFadingOut() then DoScreenFadeIn(100) end
	  if DoesEntityExist(LastVehicle) then DeleteEntity(LastVehicle);LastVehicle=nil end 
	  Reload()
	  Selection()
  end
end)
AddEventHandler('onResourceStop', function(resourceName)
  if (GetCurrentResourceName() == resourceName or resourceName == "nbk_crazydeluxo_images") then
	  if DoesEntityExist(LastVehicle) then DeleteEntity(LastVehicle);LastVehicle=nil end 
      DoScreenFadeOut(100)
  end
end)


-- 
function Selection()
	--print('selection(')
	TriggerEvent("nbk_crazydeluxo_images:draw")
	TriggerEvent("nbk_crazydeluxo_images:show_home")
	TriggerEvent("nbk_crazydeluxo_images:selection_arcade")
end 
AddEventHandler('gamemode_crazydeluxo:reload', function()
  Reload()
end)
AddEventHandler('gamemode_crazydeluxo:arcade', function()
	exports.spawnmanager:spawnPlayer(1,SpawnCallback)
	nowmode = "arcade"
end)
AddEventHandler('gamemode_crazydeluxo:original', function()
	exports.spawnmanager:spawnPlayer(1,SpawnCallback)
	nowmode = "original"
end)

local running = {} 
local looponce_newthread = function (name,duration,fn,fnclose)
    if not running[name] then
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
        running[name] = localcb 
            newthread = function() 
                CreateThread(function()
                    local _cb_ = running[name]
                    while not loopend do  Wait(duration)
                        if fns then 
                            for i=1,#fns do 
                                fns[i](_cb_,i)
                            end 
                        else 
                            fn(_cb_) 
                        end 
                    end 
                    if fnclose then fnclose() end
                    running[name] = nil
                    return 
                end) 
                return localcb
            end 
            return newthread()
         
    end 
end 
local looponce_newthread_delete = function(name)
   if running[name] then running[name]("break") end 
end 
local scaleformsHandle = {}
	local scaleformsDrawingFunctions = {}
	local scaleformsIsDrawing = {}
	local scaleformsLifeRemain = {}
	local _loadscaleform = function(scaleformName,cb)
		local handle = RequestScaleformMovie(scaleformName)
		while not HasScaleformMovieLoaded(handle) do
			Citizen.Wait(0)
		end
		scaleformsHandle[scaleformName] = handle
		local _sendscaleformvalues = function (...)
			local tb = {...}
			PushScaleformMovieFunction(scaleformsHandle[scaleformName],tb[1])
			for i=2,#tb do
				if type(tb[i]) == "number" then 
					if math.type(tb[i]) == "integer" then
							ScaleformMovieMethodAddParamInt(tb[i])
					else
							ScaleformMovieMethodAddParamFloat(tb[i])
					end
				elseif type(tb[i]) == "string" then ScaleformMovieMethodAddParamTextureNameString(tb[i])
				elseif type(tb[i]) == "boolean" then ScaleformMovieMethodAddParamBool(tb[i])
				end
			end 
			PopScaleformMovieFunctionVoid()
		end
		if cb then 
			cb(_sendscaleformvalues,function(x) return ScaleformDrawDuration(scaleformName,x) end)
		end 
	end
	ScaleformDrawingFunction = function(scaleformName,fn)
		scaleformsDrawingFunctions[scaleformName] = fn
	end 
	ScaleformIsDrawing = function(scaleformName)
		return scaleformsIsDrawing and  scaleformsIsDrawing[scaleformName]
	end 

	ScaleformDraw = function(scaleformName,cb, layer, alignx, aligny, align_p1, align_p2, align_p3, align_p4) 
		if not scaleformsIsDrawing[scaleformName] then 
			_loadscaleform(scaleformName,cb)
			if scaleformsHandle[scaleformName] then 
				scaleformsIsDrawing[scaleformName] = true  
				looponce_newthread('scaleforms:draw:'..scaleformName,0,function()
					local handle = scaleformsHandle[scaleformName]
					if handle then 
						if layer then SetScriptGfxDrawOrder(layer) end 
						if alignx and aligny then SetScriptGfxAlign(alignx, aligny) end 
						if align_p1 and align_p2 and align_p3 and align_p4 then SetScriptGfxAlignParams(align_p1, align_p2, align_p3, align_p4) end 
						if scaleformsDrawingFunctions[scaleformName] then scaleformsDrawingFunctions[scaleformName](handle) end 
						DrawScaleformMovieFullscreen(handle)
						if layer then ResetScriptGfxAlign() end
					else 
						looponce_newthread_delete('scaleforms:draw:'..scaleformName)
					end 
				end,function()
					scaleformsIsDrawing[scaleformName] = false 
					SetScaleformMovieAsNoLongerNeeded(scaleformsHandle[scaleformName])
				end)
			end 
		else 
			error("Duplicated Drawing Scaleform",2)
		end 
	end 
	ScaleformDrawMini = function(scaleformName, x ,y ,width ,height ,red ,green ,blue ,alpha ,unk, cb,layer) 
		if not scaleformsIsDrawing[scaleformName] then 
			_loadscaleform(scaleformName,cb)
			if scaleformsHandle[scaleformName] then 
				scaleformsIsDrawing[scaleformName] = true  
				looponce_newthread('scaleforms:draw:'..scaleformName,0,function()
					local handle = scaleformsHandle[scaleformName]
					if handle then 
						if layer then SetScriptGfxDrawOrder(layer) end 
						if scaleformsDrawingFunctions[scaleformName] then scaleformsDrawingFunctions[scaleformName](handle) end 
						DrawScaleformMovie(handle ,x ,y ,width ,height ,red ,green ,blue ,alpha ,unk )
						if layer then ResetScriptGfxAlign() end
					else 
						looponce_newthread_delete('scaleforms:draw:'..scaleformName)
					end 
				end,function()
					scaleformsIsDrawing[scaleformName] = false 
					SetScaleformMovieAsNoLongerNeeded(scaleformsHandle[scaleformName])
				end)
			end
		else 
			error("Duplicated Drawing Scaleform",2)
		end 
	end 
	ScaleformDrawDuration = function (scaleformName,duration,onOpen,onClose)
		CreateThread(function()
			if not scaleformsIsDrawing[scaleformName] then 
				_loadscaleform(scaleformName,cb)
				if scaleformsHandle[scaleformName] then 
					scaleformsIsDrawing[scaleformName] = true  
					looponce_newthread('scaleforms:drawwithendduration:'..scaleformName,0,function()
						local handle = scaleformsHandle[scaleformName]
						if handle then 
							if layer then SetScriptGfxDrawOrder(layer) end 
							DrawScaleformMovieFullscreen(handle)
							if layer then ResetScriptGfxAlign() end
						else 
							looponce_newthread_delete('scaleforms:drawwithendduration:'..scaleformName)
						end 
					end,function()
						scaleformsIsDrawing[scaleformName] = false 
						SetScaleformMovieAsNoLongerNeeded(scaleformsHandle[scaleformName])
					end)
				end 
			end 
			scaleformsLifeRemain[scaleformName] = GetGameTimer() + duration
			looponce_newthread("ScaleformDuration"..scaleformName,333,function()
				if scaleformsLifeRemain[scaleformName] and GetGameTimer() >= scaleformsLifeRemain[scaleformName] then 
					looponce_newthread_delete("ScaleformDuration"..scaleformName,333);
				end 
			end,function()
				ScaleformEnd(scaleformName);
				if onClose and type(onClose) == 'function' then 
					onClose()
				end 
			end)
		end)
	end
	ScaleformCall = function(scaleformName,cb) 
		if not cb then error("What is it you gonna call?",2) end 
		_loadscaleform(scaleformName,cb)
	end 
	ScaleformEnd = function(scaleformName,cb) 
		SetScaleformMovieAsNoLongerNeeded(scaleformsHandle[scaleformName])
		scaleformsHandle[scaleformName] = nil 
	end 
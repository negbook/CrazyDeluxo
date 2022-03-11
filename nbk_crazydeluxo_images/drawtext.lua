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

local HexToRGBA = function (hex,skipkeys)
		local r = hex >> 24
		local offset = hex - (r << 24)
		local g = offset >> 16
		local offset = offset - (g << 16)
		local b = offset >> 8
		local offset = offset - (b << 8)
		local a = offset
		return (not skipkeys and {r=r,g=g,b=b,a=a}) or {r,g,b,a};
	end 
	Draw3DTexts = {}
	Draw3DTextIndex = 0
	Delete3DTextLabel = function(handle)
		looponce_newthread_delete(Draw3DTexts[handle].actionname)
	end 
	DrawText3D = function(coords, text, textsizeX,textsizeY,width,height,font,color,outline,usebox,boxcolor)
		SetScriptGfxDrawOrder(1)
		SetTextScale(textsizeX, textsizeY)
		SetTextFont(font)
		SetTextColour(table.unpack(color))
		if outline > 0  then 
			SetTextOutline()
		end 
		SetTextCentre(true)
		BeginTextCommandDisplayText('STRING')
		AddTextComponentSubstringPlayerName(text)
		SetDrawOrigin(coords, 0)
		EndTextCommandDisplayText(0.0, 0.0)
		if usebox > 0  then 
			SetScriptGfxDrawOrder(0)
			DrawRect(0.0, 0.0+height/2+height/4,width,height,table.unpack(boxcolor))
		end 
		ClearDrawOrigin()
	end
	Create3DTextLabel = function(text, color, font, x, y, z, drawdistance, virtualworld, testLOS) --virtualworld : RoutingBucket
		local coords = vector3(x, y, z)
		Draw3DTextIndex = Draw3DTextIndex + 1
		local handle = Draw3DTextIndex
		local actionname = "Draw3DTextIndex"..Draw3DTextIndex
		local width
		BeginTextCommandGetWidth('STRING')
		AddTextComponentSubstringPlayerName(text)
		width = EndTextCommandGetWidth(1)
		local height = GetRenderedCharacterHeight(0.5,0)
		Draw3DTexts[handle] = {actionname =  actionname,attachentity = nil,drawdistance=drawdistance,coords=coords,textsizeX=0.5,textsizeY=0.5,width=width,height=height,text = text,font = 0,color={255,255,255,255},outline = 1,usebox = 1,boxcolor={255,255,255,255} }
		if not Draw3DTexts[handle].show then 
			looponce_newthread(Draw3DTexts[handle].actionname,0,function()
				local entity = Draw3DTexts[handle].attachentity
				if entity and DoesEntityExist(entity) then 
					Draw3DTexts[handle].coords = GetOffsetFromEntityInWorldCoords(entity ,offsetX ,offsetY ,offsetZ )
					if #(GetEntityCoords(PlayerPedId()) - Draw3DTexts[handle].coords) < Draw3DTexts[handle].drawdistance then 
						if not font then font = 0 end
						local scale = 1.0
						local height = GetRenderedCharacterHeight(Draw3DTexts[handle].textsizeY,0)
						DrawText3D(Draw3DTexts[handle].coords, Draw3DTexts[handle].text, Draw3DTexts[handle].textsizeX*scale,Draw3DTexts[handle].textsizeY*scale,Draw3DTexts[handle].width*scale,Draw3DTexts[handle].height*scale,Draw3DTexts[handle].font,Draw3DTexts[handle].color,Draw3DTexts[handle].outline,Draw3DTexts[handle].usebox,Draw3DTexts[handle].boxcolor)	
						Draw3DTexts[handle].show = true 
					end 
				else  
					local camCoords = GetGameplayCamCoords()
					local distance = #(coords - camCoords)
					if not font then font = 0 end
					local scale = (1 / distance) * 2
					local fov = (1 / GetGameplayCamFov()) * 100
					scale = scale * fov
					local height = GetRenderedCharacterHeight(Draw3DTexts[handle].textsizeY,0)
					DrawText3D(Draw3DTexts[handle].coords, Draw3DTexts[handle].text, Draw3DTexts[handle].textsizeX*scale,Draw3DTexts[handle].textsizeY*scale,Draw3DTexts[handle].width*scale,Draw3DTexts[handle].height*scale,Draw3DTexts[handle].font,Draw3DTexts[handle].color,Draw3DTexts[handle].outline,Draw3DTexts[handle].usebox,Draw3DTexts[handle].boxcolor)	
					Draw3DTexts[handle].show = true 
				end
			end)
		end 
		return handle
	end 
	Update3DTextLabelColor = function(handle,color) -- 0xff0000ff
		Draw3DTexts[handle].color = HexToRGBA(color,true) 
	end 
	Update3DTextLabelFont = function(handle,font)
		Draw3DTexts[handle].font = font
	end 
	Update3DTextLabelSetOutline = function(handle,isoutline)
		Draw3DTexts[handle].outline = isoutline and 1 or 0
	end 
	Update3DTextLabelUseBox = function(handle,isusebox)
		Draw3DTexts[handle].usebox = isusebox and 1 or 0
	end 
	Update3DTextLabelTextSize = function(handle,textsizeX,textsizeY) 
		Draw3DTexts[handle].textsizeX = textsizeX
		Draw3DTexts[handle].textsizeY = textsizeY
		local width
		BeginTextCommandGetWidth('STRING')
		AddTextComponentSubstringPlayerName(Draw3DTexts[handle].text)
		width = EndTextCommandGetWidth(1)
		Draw3DTexts[handle].width = width
		Draw3DTexts[handle].height = GetRenderedCharacterHeight(textsizeY,0)
	end 
	Update3DTextLabelBoxColor = function(handle,boxcolor) -- 0xff0000ff
		Draw3DTexts[handle].boxcolor = HexToRGBA(boxcolor,true)
	end 
	Update3DTextLabelSetString = function(handle,text)
		Draw3DTexts[handle].text = text
		local width
		BeginTextCommandGetWidth('STRING')
		AddTextComponentSubstringPlayerName(Draw3DTexts[handle].text)
		width = EndTextCommandGetWidth(1)
		Draw3DTexts[handle].width = width
		Draw3DTexts[handle].height = GetRenderedCharacterHeight(Draw3DTexts[handle].textsizeY,0)
	end 
	Attach3DTextLabelToEntity = function(handle,entity,offsetX,offsetY,offsetZ)
		Draw3DTexts[handle].attachentity = entity
	end 
	Attach3DTextLabelToPlayer = function(handle,playerid,...)
		return Attach3DTextLabelToEntity(handle,GetPlayerPed(playerid),...)
	end 
	Attach3DTextLabelToPed = Attach3DTextLabelToEntity
	Attach3DTextLabelToVehicle = Attach3DTextLabelToEntity
	Attach3DTextLabelToObject = Attach3DTextLabelToEntity
	local TextDraws = {}
	local TextDrawsIndex = 0
	local DrawText2D = function(text,x,y,textsizeX,textsizeY,width,height,font,color,outline,usebox,boxcolor)
		SetScriptGfxDrawOrder(1)
		SetTextScale(textsizeX, textsizeY)
		SetTextFont(font)
		SetTextColour(table.unpack(color))
		if outline > 0  then 
			SetTextOutline()
		end 
		SetTextCentre(true)
		BeginTextCommandDisplayText('STRING')
		AddTextComponentSubstringPlayerName(text)
		EndTextCommandDisplayText(x, y)
		if usebox > 0  then 
			SetScriptGfxDrawOrder(0)
			DrawRect(x, y+height/2+height/4,width,height,table.unpack(boxcolor))
		end 
		ClearDrawOrigin()
	end
	TextDrawDestroy = function(handle)
		looponce_newthread_delete(TextDraws[handle].actionname)
		TextDraws[handle] = nil
	end 
	TextDrawCreate = function(xper,yper,text)
		TextDrawsIndex = TextDrawsIndex + 1
		local handle = TextDrawsIndex
		local actionname = "TextDrawsIndex"..TextDrawsIndex
		local width
		BeginTextCommandGetWidth('STRING')
		AddTextComponentSubstringPlayerName(text)
		width = EndTextCommandGetWidth(1)
		local height = GetRenderedCharacterHeight(0.5,0)
		TextDraws[handle] = {actionname =  actionname,x = xper,y = yper,textsizeX=0.5,textsizeY=0.5,width=width,height=height,text = text,font = 0,color={255,255,255,255},outline = 1,usebox = 1,boxcolor={255,255,255,255} }
		return handle 
	end 
	TextDrawShow = function(handle)
		if TextDraws[handle].hide then 
			TextDraws[handle].hide = nil
		end 	
		if not TextDraws[handle].show then 
			looponce_newthread(TextDraws[handle].actionname,0,function()
				if not TextDraws[handle].hide then 
					TextDraws[handle].show = true 
					DrawText2D(TextDraws[handle].text,TextDraws[handle].x,TextDraws[handle].y,TextDraws[handle].textsizeX,TextDraws[handle].textsizeY,TextDraws[handle].width,TextDraws[handle].height,TextDraws[handle].font,TextDraws[handle].color,TextDraws[handle].outline,TextDraws[handle].usebox,TextDraws[handle].boxcolor)
				end 
			end)
		end 
	end 
	TextDrawSetPosition = function(handle,x,y)
		TextDraws[handle].x = x
		TextDraws[handle].y = y
	end 
	TextDrawHide = function(handle,color)
		TextDraws[handle].hide = true
	end 
	TextDrawColor = function(handle,color) -- 0xff0000ff
		TextDraws[handle].color = HexToRGBA(color,true) 
	end 
	TextDrawFont = function(handle,font)
		TextDraws[handle].font = font
	end 
	TextDrawSetOutline = function(handle,isoutline)
		TextDraws[handle].outline = isoutline and 1 or 0
	end 
	TextDrawUseBox = function(handle,isusebox)
		TextDraws[handle].usebox = isusebox and 1 or 0
	end 
	TextDrawTextSize = function(handle,textsizeX,textsizeY) 
		TextDraws[handle].textsizeX = textsizeX
		TextDraws[handle].textsizeY = textsizeY
		local width
		BeginTextCommandGetWidth('STRING')
		AddTextComponentSubstringPlayerName(TextDraws[handle].text)
		width = EndTextCommandGetWidth(1)
		TextDraws[handle].width = width
		TextDraws[handle].height = GetRenderedCharacterHeight(textsizeY,0)
	end 
	TextDrawBoxColor = function(handle,boxcolor) -- 0xff0000ff
		TextDraws[handle].boxcolor = HexToRGBA(boxcolor,true)
	end 
	TextDrawSetString = function(handle,text)
		TextDraws[handle].text = text
		local width
		BeginTextCommandGetWidth('STRING')
		AddTextComponentSubstringPlayerName(TextDraws[handle].text)
		width = EndTextCommandGetWidth(1)
		TextDraws[handle].width = width
		TextDraws[handle].height = GetRenderedCharacterHeight(TextDraws[handle].textsizeY,0)
	end 
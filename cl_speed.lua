local SpeedCheckInternval = Config.SpeedCheckInternval
local RenderInterval = Config.RenderInterval
local DefaultSpeedLimit = Config.DefaultSpeedLimit
local SpeedLimitFormat = Config.SpeedLimitFormat
local RenderSpeedInVehicleOnly = Config.RenderSpeedInVehicleOnly

local RenderX = Config.Render.X
local RenderY = Config.Render.Y
local RenderScaleX = Config.Render.ScaleX
local RenderScaleY = Config.Render.ScaleY

local SpeedLimits = Config.SpeedLimits

local _CitizenWait = Citizen.Wait
local _tostring = tostring

Citizen.CreateThread( function()
    while true do
        _CitizenWait( RenderInterval )

        local ped = PlayerPedId()

        if DoesEntityExist( ped ) then 
            if RenderSpeedInVehicleOnly and IsPedInAnyVehicle( ped ) then
                DrawTxt( SpeedLimitFormat:format( speedlimit ) )
            elseif not RenderSpeedInVehicleOnly then
                DrawTxt( SpeedLimitFormat:format( speedlimit ) )
            end
        end
    end
end )

Citizen.CreateThread( function()
    while true do
        _CitizenWait( SpeedCheckInternval )

        local playerloc = GetEntityCoords( PlayerPedId() )
        local streethash = GetStreetNameAtCoord( playerloc.x, playerloc.y, playerloc.z )
        local street = GetStreetNameFromHashKey( streethash )

        speedlimit = getSpeedLimit( street )
    end
end )

function getSpeedLimit( street )
    if SpeedLimits[ street ] then
        return _tostring( SpeedLimits[ street ] )
    else
        return DefaultSpeedLimit
    end
end

function DrawTxt( text )
    SetTextFont( 4 )
    SetTextProportional( 0 )
    SetTextScale( RenderScaleX, RenderScaleY )
    SetTextColour( 255, 255, 255, 255 )
    SetTextDropShadow( 0, 0, 0, 0, 255 )
    SetTextEdge( 2, 0, 0, 0, 255 )
    SetTextOutline()
    SetTextEntry( "STRING" )
    AddTextComponentString( text )
    DrawText( RenderX, RenderY )
end
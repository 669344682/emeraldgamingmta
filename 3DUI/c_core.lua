--[[
 _____                         _     _   _____                 _             
|  ___|                       | |   | | |  __ \               (_)            
| |__ _ __ ___   ___ _ __ __ _| | __| | | |  \/ __ _ _ __ ___  _ _ __   __ _ 
|  __| '_ ` _ \ / _ \ '__/ _` | |/ _` | | | __ / _` | '_ ` _ \| | '_ \ / _` |
| |__| | | | | |  __/ | | (_| | | (_| | | |_\ \ (_| | | | | | | | | | | (_| |
\____/_| |_| |_|\___|_|  \__,_|_|\__,_|  \____/\__,_|_| |_| |_|_|_| |_|\__, |
                                                                        __/ |
                                                                       |___/ 
______ _____ _      ___________ _       _____   __                           
| ___ \  _  | |    |  ___| ___ \ |     / _ \ \ / /                           
| |_/ / | | | |    | |__ | |_/ / |    / /_\ \ V /                            
|    /| | | | |    |  __||  __/| |    |  _  |\ /          Created by                   
| |\ \\ \_/ / |____| |___| |   | |____| | | || |            Skully          
\_| \_|\___/\_____/\____/\_|   \_____/\_| |_/\_/                             
                                                                             
Created for Emerald Gaming Roleplay, do not distribute - All rights reserved. ]]

gui = {}
gui.items = {}
gui.over = {}
gui.screen = Vector2(guiGetScreenSize())

--[[
gui.items["type:block:name"] = {
    name = "Test button",
    render = {
        size = Vector2(300, 50)
    },
    draw = {
        {funct = dxDrawRectangle, parameters = {0, 0, 300, 50, tocolor(30, 30, 30, 255)}},
        {funct = dxDrawText, parameters = {"Test Button" 60, 0, 240, 50, tocolor(200, 200, 200, 255), 1.3, "default", "left", "center"}},
    },
    matrix = {
        position = Vector3(0, 0, 4),
        rotation = 90,
        color = tocolor(255, 255, 255, 255)
    }
},
]]
 
function debugGui()
    local y = 45
    local i = 0
    for name, item in pairs(gui.items) do
        dxDrawText("Item: ".. name, 60, y, 30, 30, tocolor(255, 255, 255, 255), 1, "default")
        y = y + 15
        i = i + 1
    end
    dxDrawText("Total Items: ".. tostring(i), 30, 30, 30, 30, tocolor(255, 255, 255, 255), 1, "default")
end
--addEventHandler("onClientRender", root, debugGui)
 
function splitName(name)
    local s = split(name, ":")
    return unpack(s)
end
 
function render(deltaTime)
    for key, item in pairs(gui.items) do
        local _renderTarget = dxCreateRenderTarget(item.render.size, true)
        dxSetRenderTarget(_renderTarget)
        for _, draw in pairs(item.draw) do
            draw.funct(
                unpack(
                    draw.parameters
                )
            )
        end
        dxSetRenderTarget()
        dxDrawMaterialLine3D(
            item.matrix.position.x,
            item.matrix.position.y,
            item.matrix.position.z+((item.render.size.y/500)/2),
            item.matrix.position.x,
            item.matrix.position.y,
            item.matrix.position.z-((item.render.size.y/500)/2),
            _renderTarget,
            item.render.size.x / 500,
            item.matrix.color,
            item.matrix.position.x + 1 * math.cos(math.rad(item.matrix.rotation)),
            item.matrix.position.y + 1 * math.sin(math.rad(item.matrix.rotation)),
            item.matrix.position.z
           
        )
        destroyElement(_renderTarget)
    end
end
addEventHandler("onClientPreRender", root, render)
 
addEvent("on3DMouseEnter", true)
addEvent("on3DMouseLeave", true)
addEvent("on3DMouseClick", true)
 
function clickcheck(bind, state)
    local _cx, _cy = getCursorPosition()
    if (_cx) and (_cy) then
        _cx, _cy = _cx * gui.screen.x, _cy * gui.screen.y
        for key, item in pairs(gui.items) do
            local _center = Vector2(
                getScreenFromWorldPosition(
                    item.matrix.position
                )
            )
            if isPointInRectangle (_center.x, _center.y, 0, 0, gui.screen.x, gui.screen.y) then
                local _topLeft, _bottomLeft, _topRight, _bottomRight = getCorners(item.matrix.position, item.render.size, item.matrix.rotation)
                local _over = isPointInTriangle(
                    {_cx, _cy},
                    {_topLeft.x, _topLeft.y},
                    {_bottomLeft.x, _bottomLeft.y},
                    {_topRight.x, _topRight.y} 
                ) or isPointInTriangle(
                    {_cx, _cy},
                    {_bottomLeft.x, _bottomLeft.y},
                    {_bottomRight.x, _bottomRight.y},
                    {_topRight.x, _topRight.y} 
                )
                if (_over) then
                    triggerEvent("on3DMouseClick", root, key, bind, state)
                end
            end
        end
    end
end
bindKey("mouse1", "both", clickcheck)
bindKey("mouse2", "both", clickcheck)
bindKey("mouse3", "both", clickcheck)
 
function check()
    if isCursorShowing() then
        local _cx, _cy = getCursorPosition()
        local _sx, _sy = guiGetScreenSize()
        _cx, _cy = _cx * _sx, _cy * _sy
        for key, item in pairs(gui.items) do
            local _center = Vector2(
                getScreenFromWorldPosition(
                    item.matrix.position
                )
            )
            if isPointInRectangle (_center.x, _center.y, 0, 0, gui.screen.x, gui.screen.y) then
                local _topLeft, _bottomLeft, _topRight, _bottomRight = getCorners(item.matrix.position, item.render.size, item.matrix.rotation)
                local _over = isPointInTriangle(
                    {_cx, _cy},
                    {_topLeft.x, _topLeft.y},
                    {_bottomLeft.x, _bottomLeft.y},
                    {_topRight.x, _topRight.y} 
                ) or isPointInTriangle(
                    {_cx, _cy},
                    {_bottomLeft.x, _bottomLeft.y},
                    {_bottomRight.x, _bottomRight.y},
                    {_topRight.x, _topRight.y} 
                )
                if (_over) then
                    if not (gui.over[key]) then
                        gui.over[key] = true
                        triggerEvent("on3DMouseEnter", root, key)
                    end
                else
                    if (gui.over[key]) then
                        gui.over[key] = nil
                        triggerEvent("on3DMouseLeave", root, key)
                    end
                end
            end
        end
    end
end
addEventHandler("onClientCursorMove", root, check)
 
function getCorners(position, size, rotation)
    local _left = Vector3(
        position.x + ((size.x / 500) / 2) * math.cos(math.rad(rotation + 90)),
        position.y + ((size.x / 500) / 2) * math.sin(math.rad(rotation + 90)),
        position.z
    )
    local _right = Vector3(
        position.x + ((size.x / 500) / 2) * math.cos(math.rad(rotation - 90)),
        position.y + ((size.x / 500) / 2) * math.sin(math.rad(rotation - 90)),
        position.z
    )
    local _topLeft = Vector2(
        getScreenFromWorldPosition(
            _left.x,
            _left.y,
            _left.z + (size.y / 500) / 2,
            10000
        )
    )
    local _bottomLeft = Vector2(
        getScreenFromWorldPosition(
            _left.x,
            _left.y,
            _left.z - (size.y / 500) / 2,
            10000
        )
    )
    local _topRight = Vector2(
        getScreenFromWorldPosition(
            _right.x,
            _right.y,
            _right.z + (size.y / 500) / 2,
            10000
        )
    )
    local _bottomRight = Vector2(
        getScreenFromWorldPosition(
            _right.x,
            _right.y,
            _right.z - (size.y / 500) / 2,
            10000
        )
    )
    return _topLeft, _bottomLeft, _topRight, _bottomRight
end

function isPointInRectangle (pointX, pointY, x, y, width, height)
    local sx, sy = guiGetScreenSize()
    local cx, cy = getCursorPosition()
    local cx, cy = pointX, pointY
    if (cx >= x and cx <= x + width) and (cy >= y and cy <= y + height) then
        return true
    else
        return false
    end
end
 
function sign(p1, p2, p3)
    return (p1[1] - p3[1]) * (p2[2] - p3[2]) - (p2[1] - p3[1]) * (p1[2] - p3[2])
end
 
function isPointInTriangle(pt, v1, v2, v3)
    local b1, b2, b3
    b1 = sign(pt, v1, v2) < 0.0
    b2 = sign(pt, v2, v3) < 0.0
    b3 = sign(pt, v3, v1) < 0.0
    return ((b1 == b2) and (b2 == b3))
end
 
function findRotation(x1, y1, x2, y2)
    local t = -math.deg( math.atan2(x2 - x1, y2 - y1))
    return t < 0 and t + 360 or t
end
 
local anims, builtins = {}, {"Linear", "InQuad", "OutQuad", "InOutQuad", "OutInQuad", "InElastic", "OutElastic", "InOutElastic", "OutInElastic", "InBack", "OutBack", "InOutBack", "OutInBack", "InBounce", "OutBounce", "InOutBounce", "OutInBounce", "SineCurve", "CosineCurve"}
 
function table.find(t, v)
    for k, a in ipairs(t) do
        if a == v then
            return k
        end
    end
    return false
end
 
function animate(f, t, easing, duration, onChange, onEnd)
    assert(type(f) == "number", "Bad argument @ 'animate' [expected number at argument 1, got "..type(f).."]")
    assert(type(t) == "number", "Bad argument @ 'animate' [expected number at argument 2, got "..type(t).."]")
    assert(type(easing) == "string" or (type(easing) == "number" and (easing >= 1 or easing <= #builtins)), "Bad argument @ 'animate' [Invalid easing at argument 3]")
    assert(type(duration) == "number", "Bad argument @ 'animate' [expected function at argument 4, got "..type(duration).."]")
    assert(type(onChange) == "function", "Bad argument @ 'animate' [expected function at argument 5, got "..type(onChange).."]")
    table.insert(anims, {from = f, to = t, easing = table.find(builtins, easing) and easing or builtins[easing], duration = duration, start = getTickCount( ), onChange = onChange, onEnd = onEnd})
    return #anims
end
 
function destroyAnimation(a)
    if anims[a] then
        table.remove(anims, a)
    end
end
 
addEventHandler("onClientRender", root, function()
    local now = getTickCount()
    for k,v in ipairs(anims) do
        v.onChange(interpolateBetween(v.from, 0, 0, v.to, 0, 0, (now - v.start) / v.duration, v.easing))
        if now >= v.start+v.duration then
            if type(v.onEnd) == "function" then
                v.onEnd()
            end
            table.remove(anims, k)
        end
    end
end)
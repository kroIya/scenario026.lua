if not gadgetHandler:IsSyncedCode() then
	return
end

local titans = {
    {name = "armbanth", x = 12256, y = 47, z = 32, rot = 16384 , neutral = false, teamID = 2, queue = {
    {cmdID = CMD.MOVE, position = {px = 32, py = 38, pz = 32}},
    }},
    {name = "armbanth", x = 12256, y = 47, z = 1032, rot = 16384 , neutral = false, teamID = 2, queue = {
    {cmdID = CMD.MOVE, position = {px = 32, py = 38, pz = 1032}},
    }},
    {name = "armbanth", x = 12256, y = 47, z = 2032, rot = 16384 , neutral = false, teamID = 2, queue = {
    {cmdID = CMD.MOVE, position = {px = 32, py = 38, pz = 2032}},
    }},
    {name = "armbanth", x = 12256, y = 47, z = 3032, rot = 16384 , neutral = false, teamID = 2, queue = {
    {cmdID = CMD.MOVE, position = {px = 32, py = 38, pz = 3032}},
    }},
    {name = "armbanth", x = 12256, y = 47, z = 4032, rot = 16384 , neutral = false, teamID = 2, queue = {
    {cmdID = CMD.MOVE, position = {px = 32, py = 38, pz = 4032}},
    }},
    {name = "armbanth", x = 12256, y = 47, z = 5032, rot = 16384 , neutral = false, teamID = 2, queue = {
    {cmdID = CMD.MOVE, position = {px = 32, py = 38, pz = 5032}},
    }},
    {name = "armbanth", x = 12256, y = 47, z = 6032, rot = 16384 , neutral = false, teamID = 2, queue = {
    {cmdID = CMD.MOVE, position = {px = 32, py = 38, pz = 6032}},
    }},
    {name = "armbanth", x = 12256, y = 47, z = 7032, rot = 16384 , neutral = false, teamID = 2, queue = {
    {cmdID = CMD.MOVE, position = {px = 32, py = 38, pz = 7032}},
    }},
    {name = "armbanth", x = 12256, y = 47, z = 8032, rot = 16384 , neutral = false, teamID = 2, queue = {
    {cmdID = CMD.MOVE, position = {px = 32, py = 38, pz = 7632}},
    }},
    {name = "armbanth", x = 12256, y = 47, z = 9032, rot = 16384 , neutral = false, teamID = 2, queue = {
    {cmdID = CMD.MOVE, position = {px = 32, py = 38, pz = 9332}},
    }},
    {name = "armbanth", x = 12256, y = 47, z = 10032, rot = 16384 , neutral = false, teamID = 2, queue = {
    {cmdID = CMD.MOVE, position = {px = 32, py = 38, pz = 10032}},
    }},
    {name = "armbanth", x = 12256, y = 47, z = 11032, rot = 16384 , neutral = false, teamID = 2, queue = {
    {cmdID = CMD.MOVE, position = {px = 32, py = 38, pz = 11032}},
    }},
    {name = "armbanth", x = 12256, y = 47, z = 12032, rot = 16384 , neutral = false, teamID = 2, queue = {
    {cmdID = CMD.MOVE, position = {px = 32, py = 38, pz = 12032}},
    }},
}

local function Handicap() -- reads the player's handicap and stores the value
    local PlayerRules = {Spring.GetTeamInfo(0)}
    -- Spring.Echo(PlayerRules[7])
    if PlayerRules[7] == 1.001 then
        return 1
    elseif PlayerRules[7] == 1.002 then
        return 2
    elseif PlayerRules[7] == 1.003 then
        return 3
    elseif PlayerRules[7] == 1.004 then
        return 4
    elseif PlayerRules[7] == 1.005 then
        return 5
    end
end

local handicap = Handicap()

local function SpawnTitans() -- spawns titans at one end of the map and commands them to move to the other end
    for k , unit in pairs(titans) do
        if UnitDefNames[unit.name] then
        local unitID = Spring.CreateUnit(unit.name, unit.x, unit.y, unit.z, unit.rot, unit.teamID)
            for i = 1, #unit.queue do
                    local order = unit.queue[i]
                    local position = {order.position["px"], order.position["py"], order.position["pz"]}
                    Spring.GiveOrderToUnit(unitID, order.cmdID, position, CMD.OPT_SHIFT)
            end
        end
    end
end

--function checkSELFD(commands) -- SELFD does not remain as a command during the self-destruct sequence. Unlucky.
    --for _, command in ipairs(commands) do
        --if command.id == CMD.SELFD then
            --return true
        --end
    --end
    --return false
--end

function DeleteTitans() -- delete spawned titans once they reach the end of the map
    local units = Spring.GetTeamUnits(2)
    for _, unitID in ipairs(units) do
        local x, y, z = Spring.GetUnitPosition(unitID) 
        if x < 100 then
            Spring.DestroyUnit(unitID, false, true)
        end
    end
end


function DeleteEco() -- remove player metal producing buildings if difficulty > Novice
    if handicap > 2 then
        local eco = Spring.GetTeamUnits(0)
        for k, unitID in ipairs(eco) do
            local unitDefID = Spring.GetUnitDefID(unitID)
            if unitDefID then
                local name = UnitDefs[unitDefID].name
                if name == "armmex" or name == "armmoho" or name == "armamex" or name == "armmakr" or name == "armmmkr" then
                    Spring.Echo(UnitDefs[unitDefID].name .. " removed")
                    Spring.DestroyUnit(unitID)
                end
            end    
        end
    end
end

local function DeleteLOL() -- delete Ragnaroks for both teams if difficulty < Hard
    if handicap < 4 then
        local lol = Spring.GetTeamUnits(0)
        for k, unitID in ipairs(lol) do
            local unitDefID = Spring.GetUnitDefID(unitID)
            if unitDefID then
                local name = UnitDefs[unitDefID].name
                if name == "armvulc" then
                    Spring.Echo("Removed player Ragnarok")
                    Spring.DestroyUnit(unitID)
                end
            end    
        end
        local lol = Spring.GetTeamUnits(1)
        for k, unitID in ipairs(lol) do
            local unitDefID = Spring.GetUnitDefID(unitID)
            if unitDefID then
                local name = UnitDefs[unitDefID].name
                if name == "armvulc" then
                    Spring.Echo("Removed enemy Ragnarok")
                    Spring.DestroyUnit(unitID)
                end
            end    
        end        
    end
end

local function SwitchBARb() -- give BARb a commander and remove all SimpleAI units if the difficulty is Brutal
    if handicap == 5 then
        Spring.CreateUnit("armcom", 10709, 385, 4007, 0, 3)
        local SimpleAI = Spring.GetTeamUnits(1)
        for k, unitID in ipairs(SimpleAI) do
            local unitDefID = Spring.GetUnitDefID(unitID)
            Spring.DestroyUnit(unitID, false, true)
        end
    end
end



function gadget:GameFrame(frameNum) --fires off every frame
    DeleteTitans()
    DeleteEco()
    DeleteLOL()
    local n = frameNum
        if n<1 then
            SpawnTitans()
        end
        if n==10 then
            SwitchBARb()
        end
        if n>0 and n%2700 == 0 then 
            SpawnTitans()
        end
end


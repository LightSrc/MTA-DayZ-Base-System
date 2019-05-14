interiors = {

	["smallBase"] = {
		["x"] = 2062.3093261719,
		["y"] = -2520.2763671875,
		["z"] = 13.60000038147,
		["exitX"] = 2067.9650878906,
		["exitY"] = -2513.0854492188,
		["exitZ"] = 13.60000038147,
		["interior"] = 1
	},

	["mediumBase"] = {
		["x"] = 1970.1109619141,
		["y"] = -2383.8400878906,
		["z"] = 13.89999961853,
		["exitX"] = 1978.9654541016,
		["exitY"] = -2373.7419433594,
		["exitZ"] = 13.89999961853,
		["interior"] = 1
	},

	["bigBase"] = {
		["x"] = 1478.4293212891,
		["y"] = 1779.4885253906,
		["z"] = 11.10000038147,
		["exitX"] = 1486.7781982422,
		["exitY"] = 1794.9630126953,
		["exitZ"] = 11.10000038147,
		["interior"] = 1
	}
}

db = dbConnect("sqlite", "database.db")
last_id = 0

function startejam()
	dbExec(db, "CREATE TABLE IF NOT EXISTS bases(x, y, z, intX, intY, intZ, exitX, exitY, exitZ, dimension, interior, owner)");
	dbQuery(load_bases, {}, db, "SELECT * FROM `bases`");
	dbQuery(getLastID, {}, db, "SELECT id FROM bases ORDER BY id DESC LIMIT 1");
end
addEventHandler("onResourceStart", getResourceRootElement(getThisResource()), startejam)

setTimer(function()
	local players = getElementsByType("player")
	local canRestart = true
	for p, player in pairs( players ) do
		if getElementDimension(player) > 0 then
			canRestart = false
		end
	end

	if canRestart == true then
		restartResource(getThisResource())
	end

 end, 7200000, 0)

function load_bases(q)
	if (q) then
		local p = dbPoll(q, 0);
		if (#p > 0) then
			for _,d in pairs(p) do
				addInt(d["x"], d["y"], d["z"], d["intX"], d["intY"], d["intZ"], d["exitX"], d["exitY"], d["exitZ"], d["dimension"], d["interior"], d["owner"]);
			end
		end
	end
end

function getVehicleCountInBase ( baseid )
    rValue = 0
    for i, v in ipairs ( getElementsByType ( "vehicle" ) ) do
        if ( getElementDimension ( v ) == tonumber(baseid) ) then
            rValue = rValue +1
        end
    end
    return rValue
end

function createInterior(thePlayer, cmd, int, group)
	if isObjectInACLGroup( 'user.'..getAccountName( getPlayerAccount( thePlayer ) ), aclGetGroup( 'Admin' ) ) then
		if not (int) and not (group) then
			outputChatBox("SYNTAX: /" .. cmd .. " [Interior name] [group name]", thePlayer, 255, 194, 14)
		else
			if interiors[int] then
				local x, y, z = getElementPosition(thePlayer)
				local intD = interiors[int]
				dbQuery(getLastID, {}, db, "SELECT id FROM bases ORDER BY id DESC LIMIT 1");
				setTimer(function()
					dbExec(db, "INSERT INTO bases(x, y, z, intX, intY, intZ, exitX, exitY, exitZ, dimension, interior, owner) VALUES(?,?,?,?,?,?,?,?,?,?,?,?)",
					x, y, z, intD["x"], intD["y"], intD["z"], intD["exitX"], intD["exitY"], intD["exitZ"], last_id +1, intD["interior"], group);
					addInt(x, y, z, intD["x"], intD["y"], intD["z"], intD["exitX"], intD["exitY"], intD["exitZ"], last_id +1, intD["interior"], group)
					outputChatBox("Base successfully created with dimension " ..last_id +1, thePlayer, 0, 255, 0)
				end, 2000, 1)
			else
				outputChatBox("Interior doesn't exist, try /showbasenames", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("addBase", createInterior)

function getLastIDValue()
	return last_id
end

function createBase(x, y, z, int, group)
		if interiors[int] then
			local intD = interiors[int]
			dbQuery(getLastID, {}, db, "SELECT id FROM bases ORDER BY id DESC LIMIT 1");
			setTimer(function()
				dbExec(db, "INSERT INTO bases(x, y, z, intX, intY, intZ, exitX, exitY, exitZ, dimension, interior, owner) VALUES(?,?,?,?,?,?,?,?,?,?,?,?)",
				x, y, z, intD["x"], intD["y"], intD["z"], intD["exitX"], intD["exitY"], intD["exitZ"], last_id +1, intD["interior"], group);
				addInt(x, y, z, intD["x"], intD["y"], intD["z"], intD["exitX"], intD["exitY"], intD["exitZ"], last_id +1, intD["interior"], group)
			end, 2000, 1)
		end
end

function getLastID(q)
	if (q) then
		local p = dbPoll(q, 0);
		if (#p > 0) then
			for _,d in pairs(p) do
				last_id = d["id"] or 1
			end
		end
	end
end

function showbasenames()
	for k,v in pairs(interiors) do
		outputChatBox(k)
	end
end
addCommandHandler("showbasenames", showbasenames)

function addInt(x, y, z, intx, inty, intz, exitX, exitY, exitZ, dimension, interior, group)
	local in_marker = createMarker(x, y, z - 1, 'cylinder', 2.5, 255, 51, 36, 150 )
	setElementData(in_marker, "intEntranceData", {group, intx, inty, intz, dimension, interior})
	addEventHandler( 'onMarkerHit', in_marker, function( player )
		if getElementType ( player ) == "player" then
			if getElementData(player, "gang") == getElementData(in_marker, "intEntranceData")[1] or isObjectInACLGroup( 'user.'..getAccountName( getPlayerAccount( player ) ), aclGetGroup( 'Admin' ) ) then
				local theVehicle = getPedOccupiedVehicle ( player )
				if theVehicle then
					local intData = getElementData(in_marker, "intEntranceData")
					if tonumber(intData[2]) == 2062.309326 and tonumber(getVehicleCountInBase(intData[5])) >= 5 then
						outputChatBox("Too much vehicles in base! (Max 5)", player, 255, 0, 0)
						return false
					elseif tonumber(intData[2]) == 1970.110962 and tonumber(getVehicleCountInBase(intData[5])) >= 10 then
						outputChatBox("Too much vehicles in base! (Max 10)", player, 255, 0, 0)
						return false
					elseif tonumber(intData[2]) == 1478.429321 and tonumber(getVehicleCountInBase(intData[5])) >= 20 then
						outputChatBox("Too much vehicles in base! (Max 20)", player, 255, 0, 0)
						return false
					end
					for i = 0, getVehicleMaxPassengers( theVehicle ) do
						local player = getVehicleOccupant( theVehicle, i )
						if player then
							triggerClientEvent( player, "CantFallOffBike", player )
							setElementPosition(player, intData[2], intData[3], intData[4])
							setElementDimension(player, intData[5])
							setElementInterior(player, intData[6])
							setElementFrozen(player, true)
						end
					end

					setElementPosition(theVehicle, intData[2], intData[3], intData[4])
					setElementDimension(theVehicle, intData[5])
					setElementInterior(theVehicle, intData[6])
					setElementFrozen(theVehicle, true)

					local parent = getElementData(theVehicle, "parent")
					setElementDimension(parent, intData[5])
					setElementInterior(parent, intData[6])

					setTimer(function()
						for i = 0, getVehicleMaxPassengers( theVehicle ) do
							local player = getVehicleOccupant( theVehicle, i )
							if player then
								setElementFrozen(player, false)
							end
						end
						setElementFrozen(theVehicle, false)
					end, 2000, 1)
				else
					local intData = getElementData(in_marker, "intEntranceData")
					setElementPosition(player, intData[2], intData[3], intData[4])
					setElementDimension(player, intData[5])
					setElementInterior(player, intData[6])
					setElementFrozen(player, true)

					setTimer(function()
						setElementFrozen(player, false)
					end, 2000, 1)
				end
			end
		end
	end)

	local exit_marker = createMarker(exitX, exitY, exitZ - 1, 'cylinder', 1.25, 0, 153, 255, 150 )
	setElementDimension(exit_marker, dimension)
	setElementInterior(exit_marker, interior)
	setElementData(exit_marker, "intExitData", { x, y, z, dimension, group})
	addEventHandler( 'onMarkerHit', exit_marker, function( player, dimension )
			if getElementType(player) == "player" and dimension and not isPedInVehicle(player) then
				local intExData = getElementData(exit_marker, "intExitData")
				local pldim = getElementDimension(player)
				if tonumber(pldim) == tonumber(intExData[4]) then
					setElementPosition(player, intExData[1], intExData[2], intExData[3])
					setElementDimension(player, 0)
					setElementInterior(player, 0)
					setElementFrozen(player, true)
					triggerClientEvent ( player, "giveGodModeForPlayer", player)

					setTimer(function()
						setElementFrozen(player, false)
					end, 2000, 1)
				end
			end
	end)
end

function changeBaseGroup(thePlayer, commandName, id, groupName)
	if isObjectInACLGroup( 'user.'..getAccountName( getPlayerAccount( thePlayer ) ), aclGetGroup( 'Admin' ) ) then
		if not (id) or not (groupName) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Base id] [new Group]", thePlayer, 255, 194, 14)
		else
			local markers = getElementsByType("marker")
			for key, v in pairs( markers ) do
				local intData = getElementData(v, "intEntranceData")
				found = false
				if intData then
					if tonumber(intData[5]) == tonumber(id) then
						found = true
						dbExec(db, "UPDATE bases SET owner = ? WHERE dimension = ?", groupName, id)
						local insidem = getElementsByType("marker")
						for i, value in pairs( insidem ) do
							local intExData = getElementData(value, "intExitData")
							if intExData then
								if tonumber(intExData[4]) == tonumber(id) then
									setElementData(value, "intExitData", { intExData[1], intExData[2], intExData[3], intExData[4], groupName})
									break
								end
							end
						end
						setElementData(v, "intEntranceData", {groupName, intData[2], intData[3], intData[4], intData[5], intData[6]})
						break
					end
				end
			end
			if found == true then
				outputChatBox("Base with id " .. id .. " owner has changed to " .. groupName, thePlayer, 0 ,255, 0)
			else
				outputChatBox("Base not found with that id", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("changebasegroup", changeBaseGroup)

function nearbyInts(thePlayer, commandName)
	if isObjectInACLGroup( 'user.'..getAccountName( getPlayerAccount( thePlayer ) ), aclGetGroup( 'Admin' ) ) then
		local posX, posY, posZ = getElementPosition(thePlayer)
		local dimension = getElementDimension(thePlayer)
		local markers = getElementsByType("marker")
		for key, v in pairs( markers ) do
			local mx, my, mz = getElementPosition(v)
			local intData = getElementData(v, "intEntranceData")
			if mx and my and mz and intData then
			local distance = getDistanceBetweenPoints3D(posX, posY, posZ, mx, my, mz)
			if (distance <= 30) then
				local getIntId = intData[5]
				outputChatBox(" ID " .. getIntId)
			end
			end
		end
	end
end
addCommandHandler("nearbybases", nearbyInts)

function deleteBaseCMD(thePlayer, commandName, id)
	if isObjectInACLGroup( 'user.'..getAccountName( getPlayerAccount( thePlayer ) ), aclGetGroup( 'Admin' ) ) then
		if not (id) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Base id]", thePlayer, 255, 194, 14)
		else
			local markers = getElementsByType("marker")
			found = false
			for key, v in pairs( markers ) do
				local intData = getElementData(v, "intEntranceData")
				if intData then
					if tonumber(intData[5]) == tonumber(id) then
						found = true
						dbExec(db, "DELETE FROM bases WHERE dimension = ?", id)
						local insidem = getElementsByType("marker")
						for i, value in pairs( insidem ) do
							local intExData = getElementData(value, "intExitData")
							if intExData then
								if tonumber(intExData[4]) == tonumber(id) then
									destroyElement(value)
									break
								end
							end
						end
						destroyElement(v)
						break
					end
				end
			end
			if found == true then
				-- DELETE/RESPAWN VEHS
				for _,veh in ipairs(getElementsByType("vehicle")) do
					if (not getElementData(veh, "helicrash") and not getElementData(veh, "isExploded")) then
						local col = getElementData(veh, "parent")
						if (col and getElementType(col) == "colshape" and getElementData(col, "spawn")) then
							if getElementData(col, "spawn")[5] == tonumber(id) then
								destroyElement(veh)
								destroyElement(col)
							elseif tonumber(getElementDimension(veh)) ==  tonumber(id) then
								setElementPosition(veh, getElementData(col,"spawn")[2],getElementData(col,"spawn")[3],getElementData(col,"spawn")[4])
								setElementDimension(veh, getElementData(col, "spawn")[5])
								setElementInterior(veh, getElementData(col, "spawn")[6])

								setElementPosition(col, getElementData(col,"spawn")[2],getElementData(col,"spawn")[3],getElementData(col,"spawn")[4])
								setElementDimension(col, getElementData(col, "spawn")[5])
								setElementInterior(col, getElementData(col, "spawn")[6])
							end
						end
					end
				end
				-- DELETE TENTS
				for _,col in ipairs(getElementsByType("colshape")) do
					if (getElementData(col, "tent")) then
						local tent = getElementData(col, "parent")
						if tonumber(getElementDimension(tent)) == tonumber(id) then
							destroyElement(getElementData(col,"parent"))
							destroyElement(col)
						end
					end
				end
				outputChatBox("Base deleted", thePlayer, 0 ,255, 0)
			else
				outputChatBox("Base not found with that id", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("deletebase", deleteBaseCMD)

function deleteBase(id)
		if not (id) then
			return false
		else
			local markers = getElementsByType("marker")
			found = false
			for key, v in pairs( markers ) do
				local intData = getElementData(v, "intEntranceData")
				if intData then
					if tonumber(intData[5]) == tonumber(id) then
						found = true
						dbExec(db, "DELETE FROM bases WHERE dimension = ?", id)
						local insidem = getElementsByType("marker")
						for i, value in pairs( insidem ) do
							local intExData = getElementData(value, "intExitData")
							if intExData then
								if tonumber(intExData[4]) == tonumber(id) then
									destroyElement(value)
									break
								end
							end
						end
						destroyElement(v)
						break
					end
				end
			end
			if found == true then
				-- DELETE/RESPAWN VEHS
				for _,veh in ipairs(getElementsByType("vehicle")) do
					if (not getElementData(veh, "helicrash") and not getElementData(veh, "isExploded")) then
						local col = getElementData(veh, "parent")
						if (col and getElementType(col) == "colshape" and getElementData(col, "spawn")) then
							if getElementData(col, "spawn")[5] == tonumber(id) then
								destroyElement(veh)
								destroyElement(col)
							elseif tonumber(getElementDimension(veh)) ==  tonumber(id) then
								setElementPosition(veh, getElementData(col,"spawn")[2],getElementData(col,"spawn")[3],getElementData(col,"spawn")[4])
								setElementDimension(veh, getElementData(col, "spawn")[5])
								setElementInterior(veh, getElementData(col, "spawn")[6])

								setElementPosition(col, getElementData(col,"spawn")[2],getElementData(col,"spawn")[3],getElementData(col,"spawn")[4])
								setElementDimension(col, getElementData(col, "spawn")[5])
								setElementInterior(col, getElementData(col, "spawn")[6])
							end
						end
					end
				end
				-- DELETE TENTS
				for _,col in ipairs(getElementsByType("colshape")) do
					if (getElementData(col, "tent")) then
						local tent = getElementData(col, "parent")
						if tonumber(getElementDimension(tent)) == tonumber(id) then
							destroyElement(getElementData(col,"parent"))
							destroyElement(col)
						end
					end
				end
				--outputChatBox("Base deleted", thePlayer, 0 ,255, 0)
			else
				--outputChatBox("Base not found with that id", thePlayer, 255, 0, 0)
			end
		end
end

function gotoBase(thePlayer, cmd, base)
	if isObjectInACLGroup( 'user.'..getAccountName( getPlayerAccount( thePlayer ) ), aclGetGroup( 'Admin' ) ) then
		if not (base) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Base id]", thePlayer, 255, 194, 14)
		else
			local markers = getElementsByType("marker")
			for key, v in pairs( markers ) do
				local intData = getElementData(v, "intExitData")
				if(intData) then
					if tonumber(intData[4]) == tonumber(base) then
						setElementPosition(thePlayer, intData[1]+2, intData[2]+2, intData[3])
						setElementDimension(thePlayer, 0)
						setElementInterior(thePlayer, 0)
					end
				end
			end
		end
	end
end
addCommandHandler("gotobase", gotoBase)

function listAllBases(thePlayer, cmd)
	if isObjectInACLGroup( 'user.'..getAccountName( getPlayerAccount( thePlayer ) ), aclGetGroup( 'Admin' ) ) then
		local markers = getElementsByType("marker")
			for key, v in pairs( markers ) do
				if getElementData( v, 'intEntranceData' ) then
					local owner = getElementData( v, 'intEntranceData' )[1]
					local intID = getElementData( v, 'intEntranceData' )[5]
					outputChatBox(intID .. " -> " .. owner, thePlayer)
				end
			end
	end
end
addCommandHandler("listallbases", listAllBases)

function exitBase(thePlayer, cmd)
	local getdim = getElementDimension(thePlayer)
	if tonumber(getdim) > 0 then
		local theVehicle = getPedOccupiedVehicle ( thePlayer )
		if theVehicle then
			if isElementFrozen ( theVehicle ) == false then
				local markers = getElementsByType("marker")
				for keyy, va in pairs( markers ) do
					local intExData = getElementData(va, "intExitData")
					if intExData then
						if tonumber(getdim) == tonumber(intExData[4]) then
						for i = 0, getVehicleMaxPassengers( theVehicle ) do
							local player = getVehicleOccupant( theVehicle, i )
							if player then
								triggerClientEvent( player, "CantFallOffBike", player )
								setElementPosition(player, intExData[1], intExData[2], intExData[3])
								setElementDimension(player, 0)
								setElementInterior(player, 0)
								setElementFrozen(player, true)
							end
						end

							setElementPosition(theVehicle, intExData[1], intExData[2], intExData[3])
							setElementDimension(theVehicle, 0)
							setElementInterior(theVehicle, 0)
							setElementFrozen(theVehicle, true)

							local parent = getElementData(theVehicle, "parent")
							setElementDimension(parent, 0)
							setElementInterior(parent, 0)

							triggerClientEvent ( thePlayer, "giveGodModeForPlayer", thePlayer)

							setTimer(function()
								for i = 0, getVehicleMaxPassengers( theVehicle ) do
								local player = getVehicleOccupant( theVehicle, i )
									if player then
										setElementFrozen(player, false)
									end
								end
								setElementFrozen(theVehicle, false)
							end, 2000, 1)
						end
					end
				end
			else
				outputChatBox("Please remove brake (/brake)", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("exitbase", exitBase)

function freezeCar(source)
	if getElementDimension(source) > 0 then
		local theVehicle = getPedOccupiedVehicle(source)
		if theVehicle then
			if isElementFrozen ( theVehicle ) == true then
				setElementFrozen ( theVehicle, false )
				setVehicleDamageProof(theVehicle, false)
			else
				setElementFrozen ( theVehicle, true )
				setVehicleDamageProof(theVehicle, true)
			end
		end
	end
end
addCommandHandler("brake", freezeCar)
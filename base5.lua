local objects = 
{
createObject(10841,1983.0000000,-2383.1001000,20.5000000,0.0000000,0.0000000,270.0000000,1), --object(drydock1_sfse01,1), (2,1),
createObject(10841,1983.1000000,-2404.7000000,20.5000000,0.0000000,0.0000000,270.0000000,1), --object(drydock1_sfse01,1), (3,1),
createObject(10841,1972.6000000,-2414.8000000,20.5000000,0.0000000,0.0000000,178.0000000,1), --object(drydock1_sfse01,1), (4,1),
createObject(10841,1962.2000000,-2414.3000000,20.5000000,0.0000000,0.0000000,177.9950000,1), --object(drydock1_sfse01,1), (5,1),
createObject(10841,1951.3000000,-2403.0000000,20.5000000,0.0000000,0.0000000,89.9950000,1), --object(drydock1_sfse01,1), (6,1),
createObject(10841,1951.4004000,-2380.5996000,20.5000000,0.0000000,0.0000000,89.9950000,1), --object(drydock1_sfse01,1), (7,1),
createObject(10841,1962.1000000,-2370.7000000,20.5000000,0.0000000,0.0000000,355.9950000,1), --object(drydock1_sfse01,1), (8,1),
createObject(10841,1972.8000000,-2371.3000000,20.5000000,0.0000000,0.0000000,355.9900000,1), --object(drydock1_sfse01,1), (9,1),
createObject(4866,1929.2002000,-2388.7998000,12.9000000,0.0000000,0.0000000,0.0000000,1), --object(lasrnway1_las,1), (1,1),
createObject(18284,1956.3000000,-2380.6001000,15.8000000,0.0000000,0.0000000,0.0000000,1), --object(cw_tscanopy,1), (1,1),
createObject(18284,1956.4000000,-2397.1001000,15.8400000,0.0000000,0.0000000,0.0000000,1), --object(cw_tscanopy,1), (2,1),
createObject(18284,1956.4000000,-2402.7000000,15.8000000,0.0000000,0.0000000,0.0000000,1), --object(cw_tscanopy,1), (3,1),
createObject(5130,1965.8000000,-2400.5000000,15.9000000,0.0000000,0.0000000,316.0000000,1), --object(imcompstrs02,1), (1,1),
createObject(3934,1976.4000000,-2402.5000000,12.9000000,0.0000000,0.0000000,0.0000000,1), --object(helipad01,1), (1,1),
createObject(16773,1970.1000000,-2371.8999000,16.9000000,0.0000000,0.0000000,356.0000000,1), --object(door_savhangr1,1), (1,1),
createObject(1337,1922.5000000,-2321.3999000,34.5000000,0.0000000,0.0000000,0.0000000,1), --object(binnt07_la,1), (1,1),
createObject(2634,152.1000100,112.9000000,493.7000100,0.0000000,0.0000000,0.0000000,1), --object(ab_vaultdoor,1), (1,1),
createObject(1337,91.0000000,102.0000000,502.6409900,0.0000000,0.0000000,0.0000000,1), --object(binnt07_la,1), (2,1),
createObject(2959,1977.3000000,-2372.3999000,12.9000000,0.0000000,0.0000000,265.9950000,1), --object(rider1_door,1), (2,1),
createObject(2959,1980.3000000,-2372.4990000,12.9000000,0.0000000,0.0000000,87.9950000,1), --object(rider1_door,1), (3,1),
createObject(4866,1916.0000000,-2417.5000000,22.2000000,0.0000000,180.0000000,0.0000000,1), --object(lasrnway1_las,1), (2,1),
createObject(1723,1981.7000000,-2409.7000000,12.9000000,0.0000000,0.0000000,270.0000000,1), --object(mrk_seating1,1), (1,1),
createObject(1723,1980.3000000,-2412.5000000,12.9000000,0.0000000,0.0000000,178.0000000,1), --object(mrk_seating1,1), (2,1),
createObject(1723,1978.3000000,-2408.8999000,12.9000000,0.0000000,0.0000000,357.9950000,1), --object(mrk_seating1,1), (3,1),
createObject(1723,1976.8000000,-2411.8000000,12.9000000,0.0000000,0.0000000,87.9900000,1), --object(mrk_seating1,1), (4,1),
createObject(1827,1979.3000000,-2410.7000000,12.9000000,0.0000000,0.0000000,0.0000000,1), --object(man_sdr_tables,1), (1,1),
createObject(16151,1970.1000000,-2412.7000000,13.2000000,0.0000000,0.0000000,268.0000000,1) --object(ufo_bar,1), (1,1),
}

local col = createColSphere(1970.1109619141,-2383.8400878906,13.89999961853,50)

local function watchChanges( )
	if getElementDimension( getLocalPlayer( ) ) > 0 and getElementDimension( getLocalPlayer( ) ) ~= getElementDimension( objects[1] ) and getElementInterior( getLocalPlayer( ) ) == getElementInterior( objects[1] ) then
		for key, value in pairs( objects ) do
			setElementDimension( value, getElementDimension( getLocalPlayer( ) ) )
		end
	elseif getElementDimension( getLocalPlayer( ) ) == 0 and getElementDimension( objects[1] ) ~= 65535 then
		for key, value in pairs( objects ) do
			setElementDimension( value, 65535 )
		end
	end
end
addEventHandler( "onClientColShapeHit", col,
	function( element )
		if element == getLocalPlayer( ) then
			addEventHandler( "onClientRender", root, watchChanges )
		end
	end
)
addEventHandler( "onClientColShapeLeave", col,
	function( element )
		if element == getLocalPlayer( ) then
			removeEventHandler( "onClientRender", root, watchChanges )
		end
	end
)
-- Put them standby for now.
for key, value in pairs( objects ) do
	setElementDimension( value, 65535 )
end
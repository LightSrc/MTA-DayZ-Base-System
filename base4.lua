local objects = 
{
createObject(10841,2062.1001000,-2511.8000000,20.5000000,0.0000000,0.0000000,0.0000000,1), --object(drydock1_sfse01,1), (1,1),
createObject(10841,2051.8999000,-2522.2000000,20.5000000,0.0000000,0.0000000,270.0000000,1), --object(drydock1_sfse01,1), (3,1),
createObject(10841,2051.8000000,-2527.7000000,20.5000000,0.0000000,0.0000000,270.0000000,1), --object(drydock1_sfse01,1), (4,1),
createObject(10841,2062.8000000,-2538.8000000,20.5000000,0.0000000,0.0000000,178.0000000,1), --object(drydock1_sfse01,1), (5,1),
createObject(10841,2072.7000000,-2522.0000000,20.5000000,0.0000000,0.0000000,270.0000000,1), --object(drydock1_sfse01,1), (7,1),
createObject(10841,2072.8999000,-2529.1001000,20.5000000,0.0000000,0.0000000,270.0000000,1), --object(drydock1_sfse01,1), (8,1),
createObject(18284,2062.0000000,-2534.0000000,15.5000000,0.0000000,0.0000000,270.0000000,1), --object(cw_tscanopy,1), (1,1),
createObject(10245,2071.2000000,-2524.0000000,13.8000000,0.0000000,0.0000000,310.0000000,1), --object(ottos_ramp,1), (2,1),
createObject(4866,2122.1006000,-2536.7998000,12.6000000,0.0000000,0.0000000,0.0000000,1), --object(lasrnway1_las,1), (1,1),
createObject(4866,2015.5996000,-2535.2998000,22.3200000,0.0000000,179.9950000,0.0000000,1), --object(lasrnway1_las,1), (2,1),
createObject(16775,2059.8999000,-2512.3999000,16.6000000,0.0000000,0.0000000,0.0000000,1), --object(door_savhangr2,1), (2,1),
createObject(3109,2067.2000000,-2512.5000000,13.8000000,0.0000000,0.0000000,270.0000000,1), --object(imy_la_door,1), (1,1),
createObject(2315,2053.3000000,-2517.0000000,12.6000000,0.0000000,0.0000000,0.0000000,1), --object(cj_tv_table4,1), (1,1),
createObject(1723,2053.2000000,-2515.5000000,12.6000000,0.0000000,0.0000000,0.0000000,1), --object(mrk_seating1,1), (1,1),
createObject(1723,2055.0000000,-2518.3999000,12.6000000,0.0000000,0.0000000,180.0000000,1), --object(mrk_seating1,1), (2,1),
createObject(1724,2056.2000000,-2516.3999000,12.6000000,0.0000000,0.0000000,270.0000000,1) --object(mrk_seating1b,1), (1,1),

}

local col = createColSphere(2062.3093261719,-2520.2763671875,13.60000038147,50)

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
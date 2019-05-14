addEventHandler( 'onClientRender', root, function()
  for i, v in ipairs( getElementsByType( 'marker', getResourceRootElement(), true ) ) do
    if getElementData( v, 'intEntranceData' ) then
	local scX, scY = guiGetScreenSize();
      local x, y, z = getElementPosition( v );
      local cx, cy, cz = getCameraMatrix();
      if isLineOfSightClear( cx, cy, cz, x, y, z, false, false, false, false, false, false, false, v ) then
        local dist = getDistanceBetweenPoints3D( cx, cy, cz, x, y, z );
        if dist >= 5 and dist <= 15 then
          local px, py = getScreenFromWorldPosition( x, y, z + 1.8, 0.06 );
          if px then
            local owner = getElementData( v, 'intEntranceData' )[1];
            local intID = getElementData( v, 'intEntranceData' )[5];
            local r, g, b = getMarkerColor( v );
            if r == 0 and g == 153 and b == 255 then
              r, g, b = 255, 255, 255;
            end;
            if owner and intID then
              if owner == '' then owner = 'none'; end;
              dxDrawText( 'This Base owns: '..owner, px + 1, py + scY/38, px + 1, py + 1, tocolor( 0, 0, 0, 255 ), 1, 'default-bold', 'center', 'center', false, false );
              dxDrawText( 'This Base owns: '..owner, px, py + scY/38, px, py, tocolor( 255, 255, 255, 255 ), 1, 'default-bold', 'center', 'center', false, false );
              dxDrawText( 'Base ID: '..intID, px, py + 70, px, py, tocolor( 255, 255, 255, 255 ), 1, 'default-bold', 'center', 'center', false, false );
            end;
          end;
        end;
      end;
    end;
  end;
end );



addEventHandler( 'onClientRender', root, function()
  for i, v in ipairs( getElementsByType( 'marker', getResourceRootElement(), true ) ) do
    if getElementData( v, 'intExitData' ) then
	local scX, scY = guiGetScreenSize();
      local x, y, z = getElementPosition( v );
      local cx, cy, cz = getCameraMatrix();
      if isLineOfSightClear( cx, cy, cz, x, y, z, false, false, false, false, false, false, false, v ) then
        local dist = getDistanceBetweenPoints3D( cx, cy, cz, x, y, z );
        if dist >= 5 and dist <= 15 then
          local px, py = getScreenFromWorldPosition( x, y, z + 1.8, 0.06 );
          if px then
            local r, g, b = getMarkerColor( v );
            if r == 0 and g == 153 and b == 255 then
              r, g, b = 255, 255, 255;
            end;

              dxDrawText( 'Write /exitbase to get out with vehicle', px + 1, py + scY/38, px + 1, py + 1, tocolor( 255, 255, 255, 255 ), 1, 'default-bold', 'center', 'center', false, false );

        end;
      end;
    end;
  end;
end 
end);


addEvent( "CantFallOffBike", true )
addEventHandler( "CantFallOffBike", getLocalPlayer(),
	function( )
		setPedCanBeKnockedOffBike( getLocalPlayer(), false )
		setTimer( setPedCanBeKnockedOffBike, 1050, 1, getLocalPlayer(), true )
	end
)
local PANEL = {}
local map_renames = {
	{"ttt_clue", "Clue"},
	{"ttt_1337_donut_v2fix", "1337 Donut"},
	{"ttt_67thway_v3", "67thway"},
	{"ttt_abyss", "Abyss"},
	{"ttt_airbus_b3", "Airbus"},
	{"ttt_airship_b1", "Airship"},
	{"ttt_alt_borders_b13", "Borders-Alt"},
	{"ttt_amsterville_final2", "Amsterville"},
	{"ttt_anxiety", "Anxiety"},
	{"ttt_arctic_complex.bsp", "Arctic Complex"},
	{"ttt_biocube", "Biocube"},
	{"ttt_borders_b20", "Borders-Original"},
	{"ttt_camel_v1", "Camel"},
	{"ttt_canyon_a4", "Canyon"},
	{"ttt_castle_2011_v3_night", "Castle"},
	{"ttt_cloverfield_b4", "Cloverfield"},
	{"ttt_cluedo_b5", "Cluedo"},
	{"ttt_concentration_b2", "Concentration Camp"},
	{"ttt_cruise", "Cruise"},
	{"ttt_crummycradle_a4", "Crummy Cradle"},
	{"ttt_derelict_towerv1", "Derelict Tower"},
	{"ttt_diamondshoals_a2", "Diamond Shoals"},
	{"ttt_digdown_b1", "Dig Down"},
	{"ttt_district_a5", "District"},
	{"ttt_dolls", "Dolls"},
	{"ttt_dreamcruise_v1", "Dream Cruise"},
	{"ttt_earth_2074_v3", "Earth 2074"},
	{"ttt_enclave_b1", "Enclave"},
	{"ttt_erebus_r2", "Erebus"},
	{"ttt_forest_final", "Forest"},
	{"ttt_friedhouse_b6", "Fried House"},
	{"ttt_island17", "Island 17"},
	{"ttt_lost_temple_b3", "Lost Temple"},
	{"ttt_minecraft_b4", "Minecraft"},
	{"ttt_nexus_v2", "Nexus"},
	{"ttt_nipperhouse", "Nipperhouse-Summer"},
	{"ttt_xmas_nipperhouse", "Nipperhouse-Christmas"},
	{"ttt_parkhouse", "Parkhouse"},
	{"ttt_plaza_b2", "Plaza"},
	{"ttt_powerplant", "Power Plant"},
	{"ttt_richland", "Richland"},
	{"ttt_rooftops_a2", "Rooftops"},
	{"ttt_roy_the_ship", "Roy The Ship"},
	{"ttt_scarisland_b1", "Scar Island"},
	{"ttt_siege", "Seige"},
	{"ttt_ski_resort_a1", "Ski Resort"},
	{"ttt_stadium_v2", "Stadium"},
	{"ttt_thething_b3fix", "The Thing"},
	{"ttt_traitormotel_reloaded_b1", "Traitor Motel"},
	{"ttt_vessel", "Vessel"},
	{"ttt_whitehouse_b2", "Whitehouse"},
	{"cs_office", "Office"}
}

function PANEL:Init()

	self:SetSkin( GAMEMODE.HudSkin )
	self:ParentToHUD()
	
	self.ControlCanvas = vgui.Create( "Panel", self )
	self.ControlCanvas:MakePopup()
	self.ControlCanvas:SetKeyboardInputEnabled( false )
	
	self.lblCountDown = vgui.Create( "DLabel", self.ControlCanvas )
	self.lblCountDown:SetText( "60" )
	
	self.lblActionName = vgui.Create( "DLabel", self.ControlCanvas )
	
	self.ctrlList = vgui.Create( "DPanelList", self.ControlCanvas )
	self.ctrlList:SetDrawBackground( false )
	self.ctrlList:SetSpacing( 2 )
	self.ctrlList:SetPadding( 2 )
	self.ctrlList:EnableHorizontal( true )
	self.ctrlList:EnableVerticalScrollbar()
	
	self.Peeps = {}
	
	for i =1, MaxPlayers() do
	
		self.Peeps[i] = vgui.Create( "DImage", self.ctrlList:GetCanvas() )
		self.Peeps[i]:SetSize( 16, 16 )
		self.Peeps[i]:SetZPos( 1000 )
		self.Peeps[i]:SetVisible( false )
		self.Peeps[i]:SetImage( "gui/silkicons/emoticon_smile" )
	
	end

end

function PANEL:PerformLayout()
	
	local cx, cy = chat.GetChatBoxPos()
	
	self:SetPos( 0, 0 )
	self:SetSize( ScrW(), ScrH() )
	
	self.ControlCanvas:StretchToParent( 0, 0, 0, 0 )
	self.ControlCanvas:SetWide( 550 )
	self.ControlCanvas:SetTall( cy - 30 )
	self.ControlCanvas:SetPos( 0, 30 )
	self.ControlCanvas:CenterHorizontal();
	self.ControlCanvas:SetZPos( 0 )
	
	self.lblCountDown:SetFont( "FRETTA_MEDIUM_SHADOW" )
	self.lblCountDown:AlignRight()
	self.lblCountDown:SetTextColor( color_white )
	self.lblCountDown:SetContentAlignment( 6 )
	self.lblCountDown:SetWidth( 500 )
	
	self.lblActionName:SetFont( "FRETTA_LARGE_SHADOW" )
	self.lblActionName:AlignLeft()
	self.lblActionName:SetTextColor( color_white )
	self.lblActionName:SizeToContents()
	self.lblActionName:SetWidth( 500 )
	
	self.ctrlList:StretchToParent( 0, 60, 0, 0 )

end

function PANEL:ChooseGamemode()

	self.lblActionName:SetText( "Which Gamemode Next?" )
	self.ctrlList:Clear()
	
	for name, gamemode in RandomPairs( g_PlayableGamemodes ) do
	
		local lbl = vgui.Create( "DButton", self.ctrlList )
			lbl:SetText( gamemode.label )
		
			Derma_Hook( lbl, 	"Paint", 				"Paint", 	"GamemodeButton" )
			Derma_Hook( lbl, 	"ApplySchemeSettings", 	"Scheme", 	"GamemodeButton" )
			Derma_Hook( lbl, 	"PerformLayout", 		"Layout", 	"GamemodeButton" )
			
			lbl:SetTall( 24 )
			lbl:SetWide( 240 )
			
			local desc = tostring( gamemode.description );
			if ( gamemode.author ) then desc = desc .. "\n\nBy: " .. tostring( gamemode.author ) end
			if ( gamemode.authorurl ) then desc = desc .. "\n" .. tostring( gamemode.authorurl ) end

			lbl:SetTooltip( desc )
		
		lbl.WantName = name
		lbl.NumVotes = 0
		lbl.DoClick = function() if GetGlobalFloat( "VoteEndTime", 0 ) - CurTime() <= 0 then return end RunConsoleCommand( "votegamemode", name ) end
		
		self.ctrlList:AddItem( lbl )
	
	end

end

function PANEL:ChooseMap( gamemode )

	self.lblActionName:SetText( "Which Map?" )
	self:ResetPeeps()
	self.ctrlList:Clear()
	
	local gm = g_PlayableGamemodes[ gamemode ]
	if ( !gm ) then MsgN( "GAMEMODE MISSING, COULDN'T VOTE FOR MAP ", gamemode ) return end	
	
	local map_rename
	for id, mapname in RandomPairs( gm.maps ) do
		map_rename = mapname
		for i = 1, #map_renames do
			if mapname == map_renames[i][1] then
				map_rename = map_renames[i][2]
			end
		end
				
		local lbl = vgui.Create( "DButton", self.ctrlList )
			lbl:SetText( map_rename )
			
			Derma_Hook( lbl, 	"Paint", 				"Paint", 	"GamemodeButton" )
			Derma_Hook( lbl, 	"ApplySchemeSettings", 	"Scheme", 	"GamemodeButton" )
			Derma_Hook( lbl, 	"PerformLayout", 		"Layout", 	"GamemodeButton" )
			
			lbl:SetTall( 24 )
			lbl:SetWide( 240 )
			
		lbl.WantName = mapname
		lbl.NumVotes = 0
		
		local LAST_THREE_MAPS = string.Explode(" ", GetGlobalString("lastThreeMaps"))
		print(GetGlobalString("lastThreeMaps"))
		PrintTable(LAST_THREE_MAPS)
		local recently_played = 0
		for i = 1, #LAST_THREE_MAPS do
			if mapname == LAST_THREE_MAPS[i] then 
				print(mapname.."=="..LAST_THREE_MAPS[i])
				recently_played = 1 
				break
			end
		end
	
		if recently_played == 0 then
			lbl.DoClick = function() 
				if GetGlobalFloat( "VoteEndTime", 0 ) - CurTime() <= 0 then return end 
				RunConsoleCommand( "votemap", mapname ) 
			end
		else
			lbl.bgColor = Color(150,0,0)
			lbl.DoClick = function()
				LocalPlayer():PrintMessage( HUD_PRINTTALK, "Sorry this map was played recently :/" )
				surface.PlaySound( "Resource/warning.wav" )
			end
		end
		
		self.ctrlList:AddItem( lbl )
	
	end

end

function PANEL:ResetPeeps()

	for i=1, MaxPlayers() do
		self.Peeps[i]:SetPos( math.random( 0, 600 ), -16 )
		self.Peeps[i]:SetVisible( false )
		self.Peeps[i].strVote = nil
	end

end

function PANEL:FindWantBar( name )

	for k, v in pairs( self.ctrlList:GetItems() ) do
		if ( v.WantName == name ) then return v end
	end

end

function PANEL:PeepThink( peep, ent )

	if ( !IsValid( ent ) ) then 
		peep:SetVisible( false )
		return
	end
	
	peep:SetTooltip( ent:Nick() )
	peep:SetMouseInputEnabled( true )
	
	if ( !peep.strVote ) then
		peep:SetVisible( true )
		peep:SetPos( math.random( 0, 600 ), -16 )
		if ( ent == LocalPlayer() ) then
			peep:SetImage( "gui/silkicons/star" )
		end
	end

	peep.strVote = ent:GetNWString( "Wants", "" )
	local bar = self:FindWantBar( peep.strVote ) 
	if ( IsValid( bar ) ) then
	
		bar.NumVotes = bar.NumVotes + 1
		local vCurrentPos = Vector( peep.x, peep.y, 0 )
		local vNewPos = Vector( (bar.x + bar:GetWide()) - 15 * bar.NumVotes - 4, bar.y + ( bar:GetTall() * 0.5 - 8 ), 0 )
	
		if ( !peep.CurPos || peep.CurPos != vNewPos ) then
		
			peep:MoveTo( vNewPos.x, vNewPos.y, 0.2 )
			peep.CurPos = vNewPos
			
		end
		
	end

end

function PANEL:Think()

	local Seconds = GetGlobalFloat( "VoteEndTime", 0 ) - CurTime()
	if ( Seconds < 0 ) then Seconds = 0 end
	
	self.lblCountDown:SetText( Format( "%i", Seconds ) )
	
	for k, v in pairs( self.ctrlList:GetItems() ) do
		v.NumVotes = 0
	end
	
	for i=1, MaxPlayers() do
		self:PeepThink( self.Peeps[i], Entity(i) )
	end

end

function PANEL:Paint()

	Derma_DrawBackgroundBlur( self )
		
	local CenterY = ScrH() / 2.0
	local CenterX = ScrW() / 2.0
	
	surface.SetDrawColor( 0, 0, 0, 200 );
	surface.DrawRect( 0, 0, ScrW(), ScrH() );
	
end

function PANEL:FlashItem( itemname )

	local bar = self:FindWantBar( itemname )
	if ( !IsValid( bar ) ) then return end
	
	timer.Simple( 0.0, function() bar.bgColor = Color( 0, 255, 255 ) surface.PlaySound( "hl1/fvox/blip.wav" ) end )
	timer.Simple( 0.2, function() bar.bgColor = nil end )
	timer.Simple( 0.4, function() bar.bgColor = Color( 0, 255, 255 ) surface.PlaySound( "hl1/fvox/blip.wav" ) end )
	timer.Simple( 0.6, function() bar.bgColor = nil end )
	timer.Simple( 0.8, function() bar.bgColor = Color( 0, 255, 255 ) surface.PlaySound( "hl1/fvox/blip.wav" ) end )
	timer.Simple( 1.0, function() bar.bgColor = Color( 100, 100, 100 ) end )

end

derma.DefineControl( "VoteScreen", "", PANEL, "DPanel" )

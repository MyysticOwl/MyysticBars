-- Created by MyysticOwl
-- The use of this code requires the permission of the author.
-- Permission can be atained by contacting MyysticOwl at: TonicBars@gmail.com
--
-- RESPECT!

import "Turbine";
import "Turbine.UI";
import "Turbine.UI.Lotro";
import "Tonic.UI.AutoListBox";
import "Tonic.UI.MenuUtils";

TriggersPanel = class();

function TriggersPanel:Constructor( panel )
	self.eventService = SERVICE_CONTAINER:GetService(Tonic.TonicBars.Services.EventService);
	self.settingsService = SERVICE_CONTAINER:GetService(Tonic.TonicBars.Services.SettingsService);

	self.utils = Tonic.UI.MenuUtils();

	self.utils:AddCategoryBox(panel, LOCALESTRINGS.QuickslotsMenu["Triggers"]);

	self.triggerList = Tonic.UI.CheckedComboBox();
	self.triggerList:SetSize( 300, 20 );
	self.triggerList:SetParent( panel );
	panel:AddItem( self.triggerList );

	self.triggerList:AddItem( LOCALESTRINGS.QuickslotsDisplay["In Combat"], { "events", "displayInCombat" } );
	self.triggerList:AddItem( LOCALESTRINGS.QuickslotsDisplay["Out of Combat"], { "events", "displayNotInCombat" } );

	self.triggerList:AddItem( LOCALESTRINGS.QuickslotsDisplay["Mounted"], { "events", "displayWhileMounted" } );
	self.triggerList:AddItem( LOCALESTRINGS.QuickslotsDisplay["Not Mounted"], { "events", "displayWhileNotMounted" } );
	self.triggerList:AddItem( LOCALESTRINGS.QuickslotsDisplay["Combat Mounted"], { "events", "displayWhileCombatMounted" } );
	self.triggerList:AddItem( LOCALESTRINGS.QuickslotsDisplay["Not Combat Mounted"], { "events", "displayWhileNotCombatMounted" } );

	self.triggerList:AddItem( LOCALESTRINGS.QuickslotsDisplay["Ctrl Pressed"], { "events", "isControl" } );
	self.triggerList:AddItem( LOCALESTRINGS.QuickslotsDisplay["Alt Pressed"], { "events", "isAlt" } );
	self.triggerList:AddItem( LOCALESTRINGS.QuickslotsDisplay["Shift Pressed"], { "events", "isShift" } );

	local events = self.eventService:GetRegisteredEvents();
	for key, value in pairs (events.categories) do
		self.triggerList:AddItem( value.description, { "events", "categories", key } );
	end
	
	local box12 = self.utils:AddAutoListBox( panel, Turbine.UI.Orientation.Vertical, 0, 0, 0, 0 );
	
	local box6 = self.utils:AddAutoListBox( panel, Turbine.UI.Orientation.Horizontal, 0, 0, 0, 0 );
	self.healthTriggerCheckBox = self.utils:AddCheckBox( box12, LOCALESTRINGS.QuickslotsMenu["Health Drops Below this %:"], selectionWidth + 100, selectionHeight );
	self.utils:CreateCheckBoxCallback( self.healthTriggerCheckBox, { "events", "displayOnHealth" } );
	self.healthSB = self.utils:AddScrollBar( box6, 0, 0, 100, 200, selectionHeight + 20 );
	self.utils:CreateScrollBarCallback( self.healthSB, { "events", "healthTrigger" }, nil, 100 );
	box12:AddItem( box6 );
	
	local box7 = self.utils:AddAutoListBox( panel, Turbine.UI.Orientation.Horizontal, 0, 0, 0, 0 );
	self.powerTriggerCheckBox = self.utils:AddCheckBox( box12, LOCALESTRINGS.QuickslotsMenu["Power Drops Below this %:"], selectionWidth + 100, selectionHeight );
	self.utils:CreateCheckBoxCallback( self.powerTriggerCheckBox, { "events", "displayOnPower" } );
	self.powerSB = self.utils:AddScrollBar( box7, 0, 0, 100, 200, selectionHeight + 20 );
	self.utils:CreateScrollBarCallback( self.powerSB, { "events", "powerTrigger" }, nil, 100 );
	box12:AddItem( box7 );
	panel:AddItem( box12 );
	count = 0;
	box = nil;
end

function TriggersPanel:DisplaySettings()
	local localBarSettings = self.settingsService:GetBarSettings( menu:GetSelection() );
	if ( localBarSettings.events == nil ) then
		localBarSettings.events = { };
	end

	self.triggerList:ClearChecks();
	self.triggerList:SetSelections( localBarSettings.events, true );
	self.triggerList:SetSelections( localBarSettings.events.categories, true );


	self.healthTriggerCheckBox:SetChecked( localBarSettings.events.displayOnHealth );
	self.powerTriggerCheckBox:SetChecked( localBarSettings.events.displayOnPower );
	self.healthSB:SetValue( localBarSettings.events.healthTrigger * 100 );
	self.powerSB:SetValue( localBarSettings.events.powerTrigger * 100 );
end

function TriggersPanel:EnableTriggers( enabled )	
	self.healthTriggerCheckBox:SetDisabled( not enabled );
	self.powerTriggerCheckBox:SetDisabled( not enabled );
end

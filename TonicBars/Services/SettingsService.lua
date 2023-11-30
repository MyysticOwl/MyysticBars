-- CreaquickslotRowsted by MyysticOwl
-- The use of this code requires the permission of the author.
-- Permission can be atained by contacting MyysticOwl at: TonicBars@gmail.com
--
-- RESPECT!

import "Turbine";
import "Tonic.Utils.Class";
import "Tonic.Utils.Service";
import "Turbine.Gameplay";
import "Tonic.Utils.TableDeepCopy";

SettingsService = class( Tonic.Utils.Service );

function SettingsService:Constructor()
	self.barService = SERVICE_CONTAINER:GetService(Tonic.TonicBars.Services.BarService);
	self.playerService = SERVICE_CONTAINER:GetService(Tonic.TonicBars.Services.PlayerService);

	self.PARTIAL = 1;
	self.ALL = 2;
	self.BAR = 3;

	self:LoadSettings();

	local DISPLAYWIDTH = Turbine.UI.Display.GetWidth();
   	local DISPLAYHEIGHT = Turbine.UI.Display.GetHeight();

	if ( self.settings.bars ~= nil ) then
		for bKey, bValue in pairs (self.settings.bars) do
			if ( bValue.relationalX == nil or bValue.relationalY == nil ) then				
				bValue.relationalX = bValue.x / DISPLAYWIDTH;
				bValue.relationalY = bValue.y / DISPLAYHEIGHT;
			end

			bValue.x = math.floor(bValue.relationalX * DISPLAYWIDTH);
			bValue.y = math.floor(bValue.relationalY * DISPLAYHEIGHT);
		end
	end
	if ( self.settings.barMode ~= NORMAL_MODE ) then
		self.settings.barMode = NORMAL_MODE;
	end

end

function SettingsService:GetSettings()
	return self.settings;
end

function SettingsService:LoadSettings( profile )
	if ( profile == nil ) then
		self.profiles = Turbine.PluginData.Load( Turbine.DataScope.Server, "TonicBarSettings", function(args) end);
	else
		self.profiles = profile;
	end
	if ( self.profiles == nil ) then
		self.profiles = { };
	end

	local playerSettings = self.profiles[ self.playerService.player:GetName() ];
	if ( playerSettings == nil ) then
		self.profiles[ self.playerService.player:GetName() ] = { };
		playerSettings = self.profiles[ self.playerService.player:GetName() ];
	end

	if ( Turbine.Engine:GetLocale() == "de" or Turbine.Engine:GetLocale() == "fr" ) then
		self.settings = { };
		self:deepcopyLoadConvertInts( playerSettings, self.settings );
	else
		self.settings = playerSettings;
	end

	self.settings.version = THEVERSION;

	if ( self.settings.bars == nil ) then
		self.settings.bars = { };
	end
	if ( self.settings.menuLanguage == nil ) then
		self.settings.menuLanguage = Turbine.Engine:GetLocale();
	end
	if ( self.settings.nextBarId == nil ) then
		self.settings.nextBarId = 1;
	end
	if ( self.settings.mainMenuVisible ~= nil ) then
		self.settings.mainMenuVisible = nil;
	end
	if ( self.settings.selectedBar == nil )then
		self.settings.selectedBar = 0;
	end

	return self.settings;
end

function SettingsService:SaveSettings( profile )
	if ( Turbine.Engine:GetLocale() == "de" or Turbine.Engine:GetLocale() == "fr" ) then
		local temp = { };
		if ( profile == nil ) then
			self:deepcopySaveConvertInts( self.settings, temp );
			self.profiles[ self.playerService.player:GetName() ] = temp;
		else
			self:deepcopySaveConvertInts( profile, temp );
			Turbine.PluginData.Save( Turbine.DataScope.Server, "TonicBarSettings", temp, function () end);
		end
	else
		if ( profile == nil ) then
			self.profiles[ self.playerService.player:GetName() ] = self.settings;
		else
			Turbine.PluginData.Save( Turbine.DataScope.Server, "TonicBarSettings", profile, function () end);
		end
	end
	if ( profile == nil ) then
		Turbine.PluginData.Save( Turbine.DataScope.Server, "TonicBarSettings", self.profiles, function () end);
	end
end

function SettingsService:GetBars( localBarType )
	if ( localBarType == nil ) then
		return self.settings.bars
	else
		self.tempBars = { };
		local i = 1;
		for key, value in pairs (self.settings.bars) do
			if ( value.barType == localBarType and value ~= nil ) then
				self.tempBars[key] = {};
				self:deepcopy( self.settings.bars[key], self.tempBars[key] );
				i = i + 1;
			end
		end
		return self.tempBars;
	end
end

function SettingsService:GetBarSettings( barid )
	local bar = self.settings.bars[barid]
	if ( bar == nil ) then
		bar = { };
	end

	if ( bar.quickslots == nil ) then
		bar.quickslots = { };
	end

	if ( bar.x == nil )then
		bar.x = 103;
	end

	if ( bar.y == nil )then	
		bar.y = 161;
	end

	if ( bar.barType == nil )then	
		bar.barType = 1;
	end

	if ( bar.quickslotCount == nil )then	
		bar.quickslotCount = 5;
	end

	if ( bar.quickslotColumns == nil )then
		bar.quickslotColumns = 1;
	end

	if ( bar.quickslotRows == nil ) then
		bar.quickslotRows = bar.quickslotCount / bar.quickslotColumns;
	end

	if ( bar.visible == nil )then
		bar.visible = true;
	end

	if ( bar.locked == nil )then
		bar.locked = false;
	end

	if ( bar.onMouseOver == nil ) then
		bar.onMouseOver = SHOW_EXTENSIONS;
	end

	if ( bar.opacity == nil )then
		bar.opacity = 1.0;
	end

	if ( bar.quickslotSpacing == nil )then
		bar.quickslotSpacing = 1;
	end

	if ( bar.quickslotSize == nil )then
		bar.quickslotSize = 36;
	end

	if ( bar.useBackgroundColor == nil )then
		bar.useBackgroundColor = false;
	end	
	if ( bar.backgroundColorRed == nil )then
		bar.backgroundColorRed = 0;
	end
	if ( bar.backgroundColorGreen == nil )then
		bar.backgroundColorGreen = 0;
	end
	if ( bar.backgroundColorBlue == nil )then
		bar.backgroundColorBlue = 0;
	end
	if ( bar.useFading == nil )then
		bar.useFading = false;
	end	
	if ( bar.fadeOpacity == nil )then
		bar.fadeOpacity = 1;
	end
	if ( bar.events == nil ) then
		bar.events = { };
	end
	if ( bar.events.healthTrigger == nil )then
		bar.events.healthTrigger = 0.25;
	end
	if ( bar.events.powerTrigger == nil )then
		bar.events.powerTrigger = 0.25;
	end
	if ( bar.events.triggerOnClassBuffActive == nil ) then
		bar.events.triggerOnClassBuffActive = true;
	end
	if ( bar.events.inventory == nil )then
		bar.events.inventory = { };
	end
	if ( bar.events.inventory.quantity == nil )then
		bar.events.inventory.quantity = 50;
	end

	return bar
end

function SettingsService:SetBarSettings(barid, bar, doNotRefresh)
	if ( barid ~= nil ) then
		self.settings.bars[barid] = bar;

		self:SaveSettings();
		if ( doNotRefresh == nil and self.barService ~= nil ) then
			self.barService:RefreshBars();
		end
	end
end

function SettingsService:SaveQuickslots( bar, qSlots, save )
	if ( self.loading ) then
		return;
	end

	bar.quickslots = nil;
	bar.quickslots = { };

	for key, value in pairs (qSlots) do
		local shortcut = value:GetShortcut();
		if( shortcut:GetType() ~= 0 and shortcut:GetData() ~= "" ) then
			if ( bar.quickslots[key] == nil ) then
				bar.quickslots[key] = { };
			end
			bar.quickslots[key].Type = shortcut:GetType();
			bar.quickslots[key].Data = shortcut:GetData();
		end
	end
	if ( save == nil or save == false ) then
		self:SaveSettings();
	end
end

function SettingsService:LoadQuickslots( bar, qSlots )
	self.loading = true;
	for key, value in pairs (bar.quickslots) do
		if( value.Type ~= 0 and value.Data ~= "" ) then
			local shortcut = Turbine.UI.Lotro.Shortcut( value.Type, value.Data );
			if ( pcall( SetShortcut, shortcut, qSlots, key ) == false ) then
				value = nil;
				dirty = true;
			end
		end
	end
	self.loading = false;

	if (dirty == true) then
		self:SaveQuickslots( bar, qSlots )
	end
end

function SetShortcut( shortcut, qSlots, key )
	qSlots[key]:SetShortcut( shortcut );
end

function SettingsService:IncrementNextId()
	self.settings.nextBarId = self.settings.nextBarId + 1;
end

function SettingsService:LoadHelper()
end

function SettingsService:SetWrapperSettings( theWrapperSettings )
	self.settings.wrapperSettings = theWrapperSettings;
	self:SaveSettings();
end

function SettingsService:deepcopySaveConvertInts(a, b)
        if type(a) ~= "table" or type(b) ~= "table" then
                error("both parameters must be of type table but recieved " ..type(a)..
                        " and " .. type(b));
        else
                for k,v in pairs(a) do
                        -- if the type is a table, we'll need to recurse.
                        if type(v) ~= "table" then
							local l, y;
							if ( type( k ) == "number" ) then
								l = "INTEGER:" .. tostring( k );
							else
								l = k;
							end
							if ( type( v ) == "number" ) then
								y = "INTEGER:" .. tostring( v );
							else
								y = v;
							end
                            b[l] = y;
                        else
                            local x = {}
                            self:deepcopySaveConvertInts(v, x);

							local l;
							if ( type( k ) == "number" ) then
								l = "INTEGER:" .. tostring( k );
							else
								l = k;
							end
							b[l] = x;
                        end       
                end
        end
        return b;
end


function SettingsService:deepcopyLoadConvertInts(a, b)
        if type(a) ~= "table" or type(b) ~= "table" then
                error("both parameters must be of type table but recieved " ..type(a)..
                        " and " .. type(b));
        else
                for k,v in pairs(a) do
                        -- if the type is a table, we'll need to recurse.
                        if type(v) ~= "table" then
							local l, y;
							if ( type( k ) == "string" ) then
								local temp, count = string.gsub( k, "INTEGER:", "");
								if ( count > 0 ) then
									l = tonumber( temp );
								else
									l = temp;
								end
							else
								l = k;
							end
							if ( type( v ) == "string" ) then
								local temp, count = string.gsub( v, "INTEGER:", "");
								if ( count > 0 ) then
									y = tonumber( temp );
								else
									y = temp;
								end
							else
								y = v;
							end
                            b[l] = y;
                        else
                            local x = {}
                            self:deepcopyLoadConvertInts(v, x);

							local l;
							if ( type( k ) == "string" ) then
								local temp, count = string.gsub( k, "INTEGER:", "");
								if ( count > 0 ) then
									l = tonumber( temp );
								else
									l = temp;
								end
							else
								l = k;
							end
							b[l] = x;
                        end       
                end
        end
        return b;
end

function SettingsService:deepcopy(a, b)
        if type(a) ~= "table" or type(b) ~= "table" then
                error("both parameters must be of type table but recieved " ..type(a)..
                        " and " .. type(b));
        else
                for k,v in pairs(a) do
                        -- if the type is a table, we'll need to recurse.
                        if type(v) ~= "table" then
                                b[k] = v;
                        else
                                local x = {}
                                self:deepcopy(v, x);
                                b[k] = x;
                        end       
                end
        end
        return b;
end


function SettingsService:GetProfiles()
	return self.profiles;
end

function SettingsService:GetProfileBars( profile )
	return self.profiles[ profile ].bars;
end

function SettingsService:ResetAllBars()
	self:SaveSettings();
	if ( self.settings.bars == nil ) then
		self.settings.bars = { };
	end
	self.barService:Construct( self.settings.bars, true );

	local inventoryService = SERVICE_CONTAINER:GetService(Tonic.TonicBars.Services.InventoryService);
	inventoryService:NotifyClients();
end


function SettingsService:CopyProfile( profileToCopy, copyType, barid, myBar )
	if ( barid == nil ) then
		return;
	end

	self.profiles[ self.playerService.player:GetName() ] = self.settings;
	for key, value in opairs (self.barService:GetBars()) do
		self.barService:Remove( key, false );
	end
	self:CopyBars(profileToCopy, copyType, barid, myBar);

	self.settings = self.profiles[ self.playerService.player:GetName() ];
	self:ResetAllBars();
end

function SettingsService:CopyBars(profileToCopy, copyType, barid, myBar)
	local realProfile = nil;
	local copyProfile = nil;
	if ( myBar == true ) then
		realProfile = self.profiles[ self.playerService.player:GetName() ];
		copyProfile = self.profiles[ profileToCopy ];
	else
		realProfile = self.profiles[ profileToCopy ]; 
		copyProfile = self.profiles[ self.playerService.player:GetName() ];
	end

	self:CreatePath( copyProfile );

	self:deepcopy( realProfile.bars[barid], copyProfile.bars[ copyProfile.nextBarId ] );
	
	if ( copyType == self.PARTIAL ) then
		copyProfile.bars[ copyProfile.nextBarId ].quickslots = nil;
	end

	local newQuickslotBar = copyProfile.nextBarId;
	copyProfile.nextBarId = copyProfile.nextBarId + 1;

	if ( realProfile.bars[barid].barType == QUICKSLOTBAR ) then
		for key, value in opairs ( realProfile.bars ) do
			if ( value.barType == EXTENSIONBAR and value.connectionBarID == barid ) then
				self:CreatePath( copyProfile );
				self:deepcopy( realProfile.bars[key], copyProfile.bars[ copyProfile.nextBarId ] );
				copyProfile.bars[ copyProfile.nextBarId ].connectionBarID = newQuickslotBar;
				copyProfile.nextBarId = copyProfile.nextBarId + 1;				
			end
		end
	end
end

function SettingsService:CreatePath( copyProfile )
	if (  copyProfile == nil ) then
		 copyProfile = { };
	end
	if (  copyProfile.bars == nil ) then
		 copyProfile.bars = { };
	end
	if ( copyProfile.bars[ copyProfile.nextBarId ] == nil ) then
		copyProfile.bars[ copyProfile.nextBarId ] = { };
	end
end
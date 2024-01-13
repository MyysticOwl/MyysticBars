-- Created by MyysticOwl
-- The use of this code requires the permission of the author.
-- Permission can be atained by contacting MyysticOwl at: MyysticOwl@gmail.com
--
-- RESPECT!

WindowBarDecorator = class();

WindowBarDecorator.Log = MysticBars.Utils.Logging.LogManager.GetLogger("WindowBarDecorator");

function WindowBarDecorator:Constructor(childWindow, barSettings)
	self.Log:Debug("Constructor");

	self.childWindow = childWindow;
	self.barSettings = barSettings;

	self.watchSizeChanges = true;
	self.changingSizes = false;
end

function WindowBarDecorator:Create()
	self.Log:Debug("Create");

	self.counter = 0;

	self.mainWindow = MysticBars.Bars.Decorators.Window(self.barSettings);
	self.childWindow:SetParent(self.mainWindow);
	self.childWindow:SetPosition(8, 28);

	self.mainWindow:SetVisible(self.barSettings.visible);

	-- self.mainWindow.PositionChanged = self.PositionChanged;
	self.mainWindow:SetPosition(self.barSettings.x, self.barSettings.y);
	self.mainWindow:SetSize(self.childWindow.quickslotList:GetWidth(), self.childWindow.quickslotList:GetHeight());

	if (self.barSettings.barType == INVENTORY_BAR) then
		self.mainWindow.rightGrab.MouseDown = function(sender, args)
			sender.dragStartX = args.X;
			sender.dragStartY = args.Y;
			sender.dragging = true;
		end

		local count = SERVICE_CONTAINER:GetService(MysticBars.Services.InventoryService).count;

		self.mainWindow.rightGrab.MouseMove = function(sender, args)
			local width, height = self.mainWindow:GetSize();

			if (sender.dragging and self.mainWindow ~= nil and self.childWindow.quickslotList ~= nil and self.childWindow.quickslotList.count ~= nil) then
				local tempCols = width / self.barSettings.quickslotSize;
				if (tempCols <= 0) then
					tempCols = 1;
				end
				local tempRow = self.childWindow.quickslotList.count / tempCols;
				if (tempCols <= 0) then
					tempCols = 1;
				end
				tempCols = math.floor(tempCols);
				tempRow = math.ceil(self.childWindow.quickslotList.count / tempCols);

				self.barSettings.quickslotColumns = tempCols;
				self.barSettings.quickslotRows = tempRow;
				self.barSettings.quickslotCount = count;
				self.childWindow.quickslotList:SetMaxItemsPerLine(self.barSettings.quickslotColumns);
				self.childWindow.quickslotList:Refresh();
			end

			if (sender.dragging) then
				self.mainWindow:SetSize(width + (args.X - sender.dragStartX), self.barSettings.quickslotRows * self.barSettings.quickslotSize + 30);
			end
			self.counter = self.counter + 1;
		end

		self.mainWindow.rightGrab.MouseUp = function(sender, args)
			sender.dragging = false;
			local settingsService = SERVICE_CONTAINER:GetService(MysticBars.Services.SettingsService);
			settingsService:SetBarSettings(self.barSettings);
			self.mainWindow:SetSize(self.childWindow.quickslotList:GetWidth() + 16, self.childWindow.quickslotList:GetHeight() + 40);
		end
		self.mainWindow.right.MouseUp = self.mainWindow.rightGrab.MouseUp;
		self.mainWindow.right.MouseDown = self.mainWindow.rightGrab.MouseDown;
		self.mainWindow.right.MouseMove = self.mainWindow.rightGrab.MouseMove;
	end

	self.mainWindow.PositionChanged = function(sender, args)
		local settingsService = SERVICE_CONTAINER:GetService(MysticBars.Services.SettingsService);
		local settings = settingsService:GetSettings();

		--if ((self.childWindow.DragBar ~= nil and self.childWindow.DragBar:IsHUDVisible() == true)) then
			SERVICE_CONTAINER:GetService(MysticBars.Services.SettingsService):UpdateBarSettings(self.barSettings.id, function(barSettings)
				local x, y = self.mainWindow:GetPosition();

				barSettings.relationalX = x / DISPLAYWIDTH;
				barSettings.relationalY = y / DISPLAYHEIGHT;

				barSettings.x = math.floor(barSettings.relationalX * DISPLAYWIDTH);
				barSettings.y = math.floor(barSettings.relationalY * DISPLAYHEIGHT);

				return barSettings;
			end);
		--end
	end
end

function WindowBarDecorator:Refresh()
	self.Log:Debug("Refresh");

	if (self.mainWindow ~= nil) then
		self.mainWindow:SetVisible(self.barSettings.visible);
		self.mainWindow:Refresh(self.childWindow.barSettings);
		if (self.counter == 0) then
			self.mainWindow:SetSize(self.childWindow.quickslotList:GetWidth() + 16, self.childWindow.quickslotList:GetHeight() + 40);
		end
	end
end

-- function WindowBarDecorator:PositionChanged(sender, args)
-- 	SERVICE_CONTAINER:GetService(MysticBars.Services.SettingsService):UpdateBarSettings(self.barSettings.id, function(barSettings)
-- 		local x, y = self.mainWindow:GetPosition();

-- 		barSettings.relationalX = x / DISPLAYWIDTH;
-- 		barSettings.relationalY = y / DISPLAYHEIGHT;

-- 		barSettings.x = math.floor(barSettings.relationalX * DISPLAYWIDTH);
-- 		barSettings.y = math.floor(barSettings.relationalY * DISPLAYHEIGHT);
-- 		return barSettings;
-- 	end);
-- end

function WindowBarDecorator:SetBackColor(color)
	self.Log:Debug("SetBackColor");

	self.childWindow:SetBackColor(color);
end

function WindowBarDecorator:SetVisible(visible)
	if (self.mainWindow ~= nil) then
		self.mainWindow:SetVisible(visible);
	end
end

function WindowBarDecorator:SetBGColor(color)
	self.Log:Debug("SetBGColor");

	self.childWindow:SetBackColor(color);
end

function WindowBarDecorator:Remove()
	self.Log:Debug("Remove");

	self.mainWindow:SetVisible(false);
	self.childWindow:SetParent(nil);
	self.mainWindow = nil;
end

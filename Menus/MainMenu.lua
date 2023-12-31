-- Created by MyysticOwl
-- The use of this code requires the permission of the author.
-- Permission can be atained by contacting MyysticOwl at: MyysticOwl@gmail.com
--
-- RESPECT!

import "Turbine";
import "Turbine.UI";
import "Turbine.UI.Lotro";
import "MyysticUI.Utils.Class";
import "MyysticUI.Utils.Table";
import "MyysticUI.Menus.Core.UI.ComboBox";
import "MyysticUI.Menus.Core.UI.AutoListBox";
import "MyysticUI.Menus.Core.UI.MenuUtils";
import "MyysticUI.Menus.MainMenuItems";
import "MyysticUI.Menus.GeneralMenuPanel";
import "MyysticUI.Menus.EasyBars.EasyBarMenuItems";
import "MyysticUI.Menus.EasyBars.EasyBarPanel";
import "MyysticUI.Menus.InventoryBars.InventoryBarsMenuItems";
import "MyysticUI.Menus.InventoryBars.InventoryBarMenuPanel";
import "MyysticUI.Menus.InventoryBars.InventoryMenuPanel";
import "MyysticUI.Menus.ManagedBars.ExtensionsMenuPanel";
import "MyysticUI.Menus.ManagedBars.ExtensionBarMenuPanel";
import "MyysticUI.Menus.ManagedBars.ManageBarsMenuItems";
import "MyysticUI.Menus.ManagedBars.ManageBarsMenuPanel";
import "MyysticUI.Menus.Core.BaseTitleTreeNode";
import "MyysticUI.Menus.Core.TitleTreeNode";
import "MyysticUI.Menus.Core.BarsTitleTreeNode";

import "MyysticUI.Menus.Controls.BasePanel";
import "MyysticUI.Menus.Controls.ClassBuffPanel";
import "MyysticUI.Menus.Controls.ColorPanel";
import "MyysticUI.Menus.Controls.ExtensionGeneralPanel";
import "MyysticUI.Menus.Controls.InventoryPanel";
import "MyysticUI.Menus.Controls.PredefinedExtensionPanel";
import "MyysticUI.Menus.Controls.SlotsPanel";
import "MyysticUI.Menus.Controls.TriggersPanel";

windowHeight = 500;

selectionWidth = 160;
selectionHeight = 20;

SCREENWIDTH = Turbine.UI.Display.GetWidth();
SCREENHEIGHT = Turbine.UI.Display.GetHeight();

MainMenu = class( Turbine.UI.Control );

MainMenu.utils = MyysticUI.Menus.Core.UI.MenuUtils();

MainMenu.navigationWidth = 200;
MainMenu.tree = nil;
MainMenu.menuItems = MyysticUI.Menus.MainMenuItems();

MainMenu.menus = { };
MainMenu.menuSize = 0;
MainMenu.expandedMenus = nil;

function MainMenu:Constructor()
	Turbine.UI.Control.Constructor(self);

	self:SetHeight(windowHeight);

	self.editButton = Turbine.UI.Lotro.Button();
	self.editButton:SetParent(self);
	self.editButton:SetText( "Edit Mode" );
	self.editButton:SetSize( 100, 30 );
	self.editButton:SetMultiline(true);
	self.editButton:SetPosition(2, 20);

	self.tree = Turbine.UI.TreeView();
    self.tree:SetParent(self);
    self.tree:SetPosition(10, 50);
    self.tree:SetIndentationWidth(30);

	-- Give the tree view a scroll bar.
	self.scrollBar = Turbine.UI.Lotro.ScrollBar();
	self.scrollBar:SetOrientation(Turbine.UI.Orientation.Vertical);
	self.scrollBar:SetParent(self);
	self.scrollBar:SetPosition(0, 50);
	self.scrollBar:SetSize(10, windowHeight);

	self.tree:SetVerticalScrollBar(self.scrollBar);

	local treeRoot = self.tree:GetNodes();

	self.easyBars = MyysticUI.Menus.Core.TitleTreeNode("Easy Bars", 1);
	treeRoot:Add(self.easyBars);

	self.managedBars = MyysticUI.Menus.Core.TitleTreeNode("Quickslot Bars", 1, QUICKSLOTBAR);
	treeRoot:Add(self.managedBars);

	self.inventoryBars = MyysticUI.Menus.Core.TitleTreeNode("Inventory Bars", 1, TABBED_INV_BAR);
	treeRoot:Add(self.inventoryBars);

	MyysticUI.Menus.EasyBars.EasyBarMenuItems(self, self.easyBars);
	MyysticUI.Menus.ManagedBars.ManageBarsMenuItems(self, self.managedBars);
	MyysticUI.Menus.InventoryBars.InventoryBarsMenuItems(self, self.inventoryBars);

	self.editButton.MouseClick = function( sender, args )
		local settingsService = SERVICE_CONTAINER:GetService(MyysticUI.Services.SettingsService);
		local settings = settingsService:GetSettings();

		if ( settings.barMode == NORMAL_MODE and self.priorBarMode == nil ) then
			settings.barMode = EASYBAR_MODE;
		elseif ( settings.barMode == NORMAL_MODE and self.priorBarMode ~= nil ) then
			settings.barMode = self.priorBarMode;
		else
			self.priorBarMode = settings.barMode;
			settings.barMode = NORMAL_MODE;
		end

		local barService = SERVICE_CONTAINER:GetService(MyysticUI.Services.BarService);
		barService:RefreshBars();

	end

	self:Refresh();
end

function MainMenu:SizeChanged(args)
	self:Refresh();
end

function MainMenu:Refresh(destroy)
	local w,h = self:GetSize();

	if (destroy ~= nil) then
		self.easyBars:GetChildNodes():Clear();
		self.managedBars:GetChildNodes():Clear();
		self.inventoryBars:GetChildNodes():Clear();

		MyysticUI.Menus.EasyBars.EasyBarMenuItems(self, self.easyBars);
		MyysticUI.Menus.ManagedBars.ManageBarsMenuItems(self, self.managedBars);
		MyysticUI.Menus.InventoryBars.InventoryBarsMenuItems(self, self.inventoryBars);

		self.easyBars:SetExpanded(not self.easyBars:IsExpanded());
		self.easyBars:SetExpanded(not self.easyBars:IsExpanded());

		self.managedBars:SetExpanded(not self.managedBars:IsExpanded());
		self.managedBars:SetExpanded(not self.managedBars:IsExpanded());

		self.inventoryBars:SetExpanded(not self.inventoryBars:IsExpanded());
		self.inventoryBars:SetExpanded(not self.inventoryBars:IsExpanded());
	end

	self.tree:SetSize(w - 40, h);

	local root = self.tree:GetNodes();
	for i=1,self.tree:GetNodes():GetCount() do
		local node = root:Get(i);

		self:RefreshChildren(node, w - 50);
	end
end

function MainMenu:RefreshChildren(node, w)
	if (node:GetChildNodes():GetCount() > 0) then
		for i=1,node:GetChildNodes():GetCount() do
			local childNode = node:GetChildNodes():Get(i);

			self:RefreshChildren(childNode, w - 50);
			node:Refresh(w - 50);
		end
	else
		node:Refresh(w);
	end
end

function MainMenu:GetSelection()
	local settingsService = SERVICE_CONTAINER:GetService(MyysticUI.Services.SettingsService);
	return settingsService:GetSettings().selectedBar;
end

function MainMenu:EnableTriggers( enabled )

end

function MainMenu:Destroy(sender)
	self.editButton:SetParent(nil);
	self.editButton.MouseClick = nil;
	self.editButton:SetVisible(false);
	self.editButton = nil;

	self.tree:SetParent(nil);
	self.tree:SetVisible(false);
	self.tree = nil;

	self.scrollBar:SetParent(nil);
	self.scrollBar:SetVisible(false);
	self.scrollBar = nil;

	self.SizeChanged = nil;
	self:SetParent(nil);
	self:SetVisible(false);
	self = nil;
end
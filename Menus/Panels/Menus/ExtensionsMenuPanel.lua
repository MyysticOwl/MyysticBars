-- Created by MyysticOwl
-- The use of this code requires the permission of the author.
-- Permission can be atained by contacting MyysticOwl at: MyysticOwl@gmail.com
--
-- RESPECT!

import "Turbine";
import "MyysticUI.Utils.Class";
import "MyysticUI.UI.MenuUtils";

ExtensionsMenuPanel = class();

function ExtensionsMenuPanel:Draw()
	menu.contentBox:ClearItems();

	local title = MyysticUI.UI.AutoListBox();
	local utils = MyysticUI.UI.MenuUtils();

	utils:AddCategoryBox(title, "Extensions");
	utils:AddLabelBox( title, "Extensions work different than QuickBars. To add an Extension, just right click on the quickslot to extend. Then select the orientation.", selectionWidth + 250, selectionHeight + 20 );

	menu.contentBox:AddItem( title );
end

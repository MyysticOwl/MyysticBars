-- Created by MyysticOwl
-- The use of this code requires the permission of the author.
-- Permission can be atained by contacting MyysticOwl at: MyysticOwl@gmail.com
--
-- RESPECT!

MarinerTemplate = class();

function MarinerTemplate:Constructor()
	local templateService = SERVICE_CONTAINER:GetService(MyysticUI.Services.TemplateService);

	templateService:ConstructBars();
end
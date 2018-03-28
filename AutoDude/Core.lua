--Creates the frame of the addon
local UIConfig = CreateFrame("Frame", "TestFrame", UIParent, "BasicFrameTemplateWithInset");

UIConfig:SetSize(140,90); -- Width, Height
UIConfig:SetPoint("CENTER", UIParent, "CENTER"); -- Point, RelativeFrame, RelativePoint, xOffset, yOffset
UIConfig:EnableMouse(true);
UIConfig:SetMovable(true);
UIConfig:RegisterForDrag("LeftButton");
UIConfig:SetScript("OnDragStart", function(self) self:StartMoving() end);
UIConfig:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end);

--Title of the addon
UIConfig.title = UIConfig:CreateFontString(nil, "OVERLAY");
UIConfig.title:SetFontObject("GameFontHighlight");
UIConfig.title:SetPoint("LEFT", UIConfig.TitleBg, "LEFT", 10, -1);
UIConfig.title:SetText("AutoDude");
UIConfig.title:SetFont("Fonts\\skurri.ttf",15);

-- Checkboxes and text
--Checkbox for repair
local checkbxRepair = CreateFrame("CheckButton", nil, UIConfig, "UICheckButtonTemplate");
checkbxRepair:SetPoint("TOPLEFT", 10, -27);
checkbxRepair.text:SetText("Auto-Repair!");
checkbxRepair.text:SetFont("Fonts\\FRIZQT__.ttf",13);

--Checkbox for seller
local checkbxSell = CreateFrame("CheckButton", nil, UIConfig, "UICheckButtonTemplate");
checkbxSell:SetPoint("TOPLEFT", 10, -52);
checkbxSell.text:SetText("Auto-Sell!");
checkbxSell.text:SetFont("Fonts\\FRIZQT__.ttf",13);
checkbxSell.tooltip = "testtesttest";

--SlashCommands
SLASH_TOGGLE1 = "/AutoDude";
SLASH_TOGGLE2 = "/autodude";
SlashCmdList["TOGGLE"] = function(msg)
	UIConfig:Show();
	print("Type '/AutoDudeHelp' for help");
end
SLASH_HELP1 = "/AutoDudeHelp";
SLASH_HELP2 = "/autodudehelp";
SlashCmdList["HELP"] = function(msg)
	print("AutoDude is you automizer addon!");
	print("'/AutoDude' to open interface");
	print("Auto-repair repairs your gear with your own gold");
	print("Auto-sell sells all the grey/junk in your bag");
end

--Function to auto-sell when checkbox is checked
	local sellRepairFrame = CreateFrame("Frame");
	sellRepairFrame:RegisterEvent("MERCHANT_SHOW");
	sellRepairFrame:SetScript("OnEvent", function()

	local isSellChecked = checkbxSell:GetChecked();
		if isSellChecked == true then
		-- Auto Sell Grey/Junk Items
		totalPrice = 0
		for myBags = 0,4 do
			for bagSlots = 1, GetContainerNumSlots(myBags) do
				CurrentItemLink = GetContainerItemLink(myBags, bagSlots);
				if CurrentItemLink then
					_, _, itemRarity, _, _, _, _, _, _, _, itemSellPrice = GetItemInfo(CurrentItemLink);
					_, itemCount = GetContainerItemInfo(myBags, bagSlots);
					if itemRarity == 0 and itemSellPrice ~= 0 then
						totalPrice = totalPrice + (itemSellPrice * itemCount);
						UseContainerItem(myBags, bagSlots);
					end
				end
			end
		end
		if totalPrice ~= 0 then
			DEFAULT_CHAT_FRAME:AddMessage("Junk sold for: "..GetCoinTextureString(totalPrice), 255, 255, 255);
		end
	end

--Function for auto-repair to work when checkbox is checked
local isRepairChecked = checkbxRepair:GetChecked();
if isRepairChecked == true then
if CanMerchantRepair() then
		repairAllCost, canRepair = GetRepairAllCost();
		-- Checks if merchant can repair and if there is damaged gear
		if canRepair and repairAllCost > 0 then
			-- Checks if there is enough money in bag
			if repairAllCost <= GetMoney() then
				RepairAllItems(false);
				DEFAULT_CHAT_FRAME:AddMessage("Gear repaired for "..GetCoinTextureString(repairAllCost), 255, 255, 255);
			end
		end
	end
end
end);

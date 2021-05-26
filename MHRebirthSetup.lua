local FacBase 
		local TycooList = game.Workspace.Tycoons:GetChildren() 
		for _,v in next, TycooList do
			if v.Owner.Value == game.Players.LocalPlayer.Name then
				FacBase = v.Base
			end
		end
		
		local Tycoon = client.PlayerTycoon.Value 
		local PlaceRemote = game.ReplicatedStorage.PlaceItem 
		local BuyItem = game.ReplicatedStorage.BuyItem
		local PlrTycoon = workspace.Tycoons[tostring(Tycoon)]
		local PlrTycoonChildren = PlrTycoon:GetChildren()

		function PlaceItem(Item,Position,Base)
			game.ReplicatedStorage.PlaceItem:InvokeServer(Item, Position, Base) 
		end

		function getMoney()
			local Money = client.PlayerGui.GUI.Money.Value
			return Money
		end
		local function sqrtfac(RB)
			return math.floor(RB ^ 0.5714285714285714 * 38.48334897033503 / 1) * 0.00023999999999999998;
		end;
		function RebornPrice(RB)
			local n = RB;
			if not n then
				return;
			end;
			local RebirthValue = n;
			local eValue = 2.5E+19;
		    if game.Players.LocalPlayer:FindFirstChild("ThirdSacrifice") then
		        eValue = 2.5E+40
		    elseif RebirthValue < 40 then
				return eValue * (RebirthValue + 1);
			end;
			local v6 = RebirthValue <= 5000 and RebirthValue or 5000;
			if n >= 50000 then
				v6 = v6 + math.floor(n / 10000) * 100 / 2;
			end;
			local v7 = 0;
			if RebirthValue > 5000 then
				v7 = sqrtfac(RebirthValue) - sqrtfac(5000);
			end;
			local v8 = (eValue * ((math.floor(RebirthValue / 5) * 2 + 1) * (1 + math.floor(RebirthValue / 25) * 100) * (1 + math.floor(RebirthValue / 500) * 1000))) ^ (1 + math.floor(v6 / 1) * 0.00023999999999999998 + v7);
			return v8 <= 1E+241 and v8 or 1E+241;
		end;
		function getResearchPoints()
			local RP = client.Points.Value
			return RP
		end
		function Withdrawl()
			game.ReplicatedStorage.DestroyAll:InvokeServer()
			wait(1.5)
		end
		function getItemName(itemID)
			for i,v in next, game.ReplicatedStorage.Items:GetChildren() do
				if v:FindFirstChild("ItemId") and v.ItemId.Value == itemID then
					return v.Name
				end
			end
		end
		function validInInv_Name()
			local items = {}
			for i,v in next, client.PlayerGui.GUI.Inventory.Frame.Items:GetChildren() do
				if v:IsA("TextButton") and v.Visible == true then
					local ID = v.ItemId.Value
					table.insert(items, getItemName(ID))
				end
			end
			return items
		end
		function Pulse()
			if not table.find(validInInv_Name(), "Ore Pulsar") then
				BuyItem:InvokeServer("Ore Pulsar", 1)
				wait(0.01) 
			end
			PlaceRemote:InvokeServer("Ore Pulsar", CFrame.new(75, 5.00000381, 73.5000153, 1, 0, 0, 0, 1, 0, 0, 0, 1) + Tycoon.Base.Position, {FacBase}) 
			wait(0.5)
			game.ReplicatedStorage.Pulse:FireServer()
			wait(0.1)
			game:GetService("ReplicatedStorage").DestroyItem:InvokeServer(PlrTycoon["Ore Pulsar"])
		end

		local TouchDebounce
		function TouchLoop(Item, Cash, nextdest)
			local Upgrader
			local Conveyor
			local Destination
			if Cash ~= nil and Item ~= nil then
				for i,v in next, Item:GetDescendants() do
					if v:IsA("Part") and v.Name == "Upgrade" then
						Upgrader = v
					elseif v:IsA("Part") and v.Name == "Cannon" then
						Upgrader = v
					end
				end
				for i,v in next, Item:GetDescendants() do
					if v:IsA("Part") and v.Name == "Conv" then
						Conveyor = v
					end
				end
				Upgrader.Touched:connect(function(hit)
					if hit:FindFirstChild("Cash") then
						if hit.Cash.Value < Cash then
							local ConvCalc = Upgrader.CFrame + Vector3.new(0,1,0)
							hit.CFrame = ConvCalc - Upgrader.CFrame.lookVector * 1.8
						else
							for i,v in next, PlrTycoon:GetDescendants() do
								if v:IsA("Model") and v.Name == nextdest then
									print(v.Name)
									Destination = v
								end
							end
							local DestCalc = Destination.Model.Conv.CFrame + Vector3.new(0,1,0)
							hit.CFrame = DestCalc - Destination.Model.Conv.CFrame.lookVector * 1.8
						end
					end
				end)
			end
		end
		function TouchLoopAmount(Item, Amount, nextdest)
			local Upgrader
			local Conveyor
			local Destination
			local LoopCount
			if Amount ~= nil and Item ~= nil then
				for i,v in next, Item:GetDescendants() do
					if v:IsA("Part") and v.Name == "Upgrade" then
						Upgrader = v
					elseif v:IsA("Part") and v.Name == "Cannon" then
						Upgrader = v
					end
				end
				for i,v in next, Item:GetDescendants() do
					if v:IsA("Part") and v.Name == "Conv" then
						Conveyor = v
					end
				end

				Upgrader.Touched:connect(function(hit)
					if hit:FindFirstChild("Cash") and not hit:FindFirstChild("LoopCount") then
						LoopCount = Instance.new("IntValue")
						LoopCount.Name = "LoopCount"
						LoopCount.Parent = hit
						LoopCount.Value = Amount
						if hit.LoopCount.Value >= 1 then 
							local ConvCalc = Upgrader.CFrame + Vector3.new(0,1,0)
							hit.CFrame = ConvCalc - Upgrader.CFrame.lookVector * 1.8
							hit.LoopCount.Value = hit.LoopCount.Value - 1
						end
					end
					wait(0.05)
					if hit:FindFirstChild("Cash") and hit:FindFirstChild("LoopCount") then
						if hit.LoopCount.Value >= 1 then 
							local ConvCalc = Upgrader.CFrame + Vector3.new(0,1,0)
							hit.CFrame = ConvCalc - Upgrader.CFrame.lookVector * 1.8
							hit.LoopCount.Value = hit.LoopCount.Value - 1
							hit.Velocity = Vector3.new(0, 0, 0)
						else
							for i,v in next, PlrTycoon:GetDescendants() do
								if v:IsA("Model") and v.Name == nextdest then
									print(v.Name)
									Destination = v
								end
							end
							hit.LoopCount:Remove()
							hit.Velocity = Vector3.new(0, 0, 0)
							local DestCalc = Destination.Model.Conv.CFrame + Vector3.new(0,1,0)
							hit.CFrame = DestCalc - Destination.Model.Conv.CFrame.lookVector * 1.8
						end
					end
				end)
			end
		end
		function TPOre(Item, nextdest)
			local Upgrader
			local Conveyor
			local Destination
			if Item ~= nil then
				for i,v in next, Item:GetDescendants() do
					if v:IsA("Part") and v.Name == "Upgrade" then
						Upgrader = v
					elseif v:IsA("Part") and v.Name == "Cannon" then
						Upgrader = v
					end
				end
				for i,v in next, Item:GetDescendants() do
					if v:IsA("Part") and v.Name == "Conv" then
						Conveyor = v
					end
				end
				Upgrader.Touched:connect(function(hit)
					if hit:FindFirstChild("Cash") then
						for i,v in next, PlrTycoon:GetDescendants() do
							if v:IsA("Model") and v.Name == nextdest then
								print(v.Name)
								Destination = v
							end
						end
						wait(0.08)
						hit.Anchored = true
						if hit:FindFirstChild("RealBodyVelocity") then
							hit.RealBodyVelocity:Destroy()
						end
						hit.Velocity = Vector3.new(0, 0, 0)
						wait(0.08)
						local DestCalc = Destination.Model.Conv.CFrame + Vector3.new(0,2,0)
						hit.CFrame = DestCalc - Destination.Model.Conv.CFrame.lookVector * 2.5
						hit.Anchored = false
					end
				end)
			end
		end
		ProximityList = {
			"Plutonium Excavator"
		}
		CellListList = {
			"Cell Furnace",
			"Cell Incinerator",
			"Cell Processor",
		}

		if not NewSettings["FullSetup"] then
			FacBase.Parent.AdjustSpeed.Value = 1
		end
		while NewSettings["FullSetup"] do wait(2)
			FacBase.Parent.AdjustSpeed.Value = 2
			--Inital Setup (Life 1 - 100 )
			--game:GetService("Workspace").Tycoons.Factory1.AdjustSpeed < 5
			local OGLife
			local CurrentLife
			local SkippedCalc
			if getMoney() <= 1e6 then
				Withdrawl() 
					PlaceItem("Basic Furnace", CFrame.new(0, 3.50000381, -3.05175781e-05, -1, 0, 0, 0, 1, 0, 0, 0, -1) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceItem("Basic Iron Mine", CFrame.new(-7.5, 6.00000381, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceItem("Basic Iron Mine", CFrame.new(0, 5.00000381, 7.5, 0, 0, 1, 0, 1, -0, -1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceItem("Basic Iron Mine", CFrame.new(0, 5.00000381, -7.5, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceItem("Basic Iron Mine", CFrame.new(7.5, 5.00000381, 0, -1, 0, 0, 0, 1, 0, 0, 0, -1) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01)
					Notif("Waiting for your cash to be more than "..MoneyLibModule.HandleMoney(400),{"Sweet"},15)
					if table.find(validInInv_Name(), "Ninja Diamond Mine") and table.find(validInInv_Name(), "Scavenger's Loot Collector") then
						PlaceRemote:InvokeServer("Ninja Diamond Mine", CFrame.new(78, 5.00000381, 79.5, -1, 0, 0, 0, 1, 0, 0, 0, -1) + Tycoon.Base.Position, {FacBase}) 
						wait(0.01) 
						PlaceRemote:InvokeServer("Scavenger's Loot Collector", CFrame.new(69, 5.00000381, 75, 1, 0, 0, 0, 1, 0, 0, 0, 1) + Tycoon.Base.Position, {FacBase}) 
						wait(10) 
					elseif table.find(validInInv_Name(), "Ninja Diamond Mine") then
						PlaceItem("Ninja Diamond Mine", CFrame.new(9, 5.00000381, -1.5, -1, 0, 0, 0, 1, 0, 0, 0, -1) + Tycoon.Base.Position, {FacBase}) 
						wait(10)
					end	
				repeat if not NewSettings["FullSetup"] then return end wait(0.2) until getMoney() > 402
				Withdrawl() 
					BuyItem:InvokeServer("Remote Iron Mine", 1)
					wait(0.5)
					PlaceItem("Basic Furnace", CFrame.new(0, 3.50000381, -3.05175781e-05, -1, 0, 0, 0, 1, 0, 0, 0, -1) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceItem("Remote Iron Mine", CFrame.new(-7.5, 5.00000381, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1) + Tycoon.Base.Position, {FacBase}) 
				Notif("Waiting for your cash to be more than "..MoneyLibModule.HandleMoney(400),{"Sweet"},15)
				repeat wait(0.2) if not NewSettings["FullSetup"] then return end game.ReplicatedStorage.RemoteDrop:FireServer() until getMoney() > 402
					BuyItem:InvokeServer("Remote Iron Mine", 1)
					wait(0.5)
					PlaceItem("Remote Iron Mine", CFrame.new(0, 5.00000381, -7.5, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
				Notif("Waiting for your cash to be more than "..MoneyLibModule.HandleMoney(400),{"Sweet"},15)
				repeat wait(0.2) if not NewSettings["FullSetup"] then return end game.ReplicatedStorage.RemoteDrop:FireServer() until getMoney() > 402
					BuyItem:InvokeServer("Remote Iron Mine", 1)
					wait(0.5)
					PlaceItem("Remote Iron Mine", CFrame.new(7.5, 5.00000381, 0, -1, 0, 0, 0, 1, 0, 0, 0, -1) + Tycoon.Base.Position, {FacBase}) 
				Notif("Waiting for your cash to be more than "..MoneyLibModule.HandleMoney(400),{"Sweet"},15)
				repeat wait(0.2) if not NewSettings["FullSetup"] then return end game.ReplicatedStorage.RemoteDrop:FireServer() until getMoney() > 402
					BuyItem:InvokeServer("Remote Iron Mine", 1)
					wait(0.2) 
					PlaceItem("Remote Iron Mine", CFrame.new(0, 5.00000381, 7.5, 0, 0, 1, 0, 1, -0, -1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
				Notif("Waiting for your cash to be more than "..MoneyLibModule.HandleMoney(7500),{"Sweet"},15)
				repeat wait(0.2) if not NewSettings["FullSetup"] then return end game.ReplicatedStorage.RemoteDrop:FireServer() until getMoney() > 7550
				Withdrawl()
					BuyItem:InvokeServer("Cell Furnace", 1)
					wait(0.5)
					PlaceItem("Cell Furnace", CFrame.new(0, 5.00000381, -3.05175781e-05, -1, 0, 0, 0, 1, 0, 0, 0, -1) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceItem("Remote Iron Mine", CFrame.new(0, 5.00000381, 7.5, 0, 0, 1, 0, 1, -0, -1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceItem("Remote Iron Mine", CFrame.new(-7.5, 5.00000381, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceItem("Remote Iron Mine", CFrame.new(0, 5.00000381, -7.5, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceItem("Remote Iron Mine", CFrame.new(7.5, 5.00000381, 0, -1, 0, 0, 0, 1, 0, 0, 0, -1) + Tycoon.Base.Position, {FacBase}) 
				Notif("Waiting for your cash to be more than "..MoneyLibModule.HandleMoney(120000),{"Sweet"},15)
				repeat wait(0.2) if not NewSettings["FullSetup"] then return end game.ReplicatedStorage.RemoteDrop:FireServer() until getMoney() > 120500
				Withdrawl()
					BuyItem:InvokeServer("Remote Diamond Mine", 1)
					wait(0.5)
					PlaceItem("Cell Furnace", CFrame.new(0, 5.00000381, -3.05175781e-05, -1, 0, 0, 0, 1, 0, 0, 0, -1) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01)  
					PlaceItem("Remote Diamond Mine", CFrame.new(-9, 6.50000381, 1.49996948, 1, 0, 0, 0, 1, 0, 0, 0, 1) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
				Notif("Waiting for your cash to be more than "..MoneyLibModule.HandleMoney(120000),{"Sweet"},15)
				repeat wait(0.2) if not NewSettings["FullSetup"] then return end game.ReplicatedStorage.RemoteDrop:FireServer() until getMoney() > 120500
					BuyItem:InvokeServer("Remote Diamond Mine", 1)
					wait(0.2) 
					PlaceItem("Remote Diamond Mine", CFrame.new(1.50003052, 6.50000381, -9, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
				Notif("Waiting for your cash to be more than "..MoneyLibModule.HandleMoney(120000),{"Sweet"},15)
				repeat wait(0.2) if not NewSettings["FullSetup"] then return end game.ReplicatedStorage.RemoteDrop:FireServer() until getMoney() > 120500
					BuyItem:InvokeServer("Remote Diamond Mine", 1)
					wait(0.01) 
					PlaceItem("Remote Diamond Mine", CFrame.new(9, 6.50000381, 1.50003052, -1, 0, 0, 0, 1, 0, 0, 0, -1) + Tycoon.Base.Position, {FacBase})
				Notif("Waiting for your cash to be more than "..MoneyLibModule.HandleMoney(950000),{"Sweet"},15)
				repeat wait(0.2) if not NewSettings["FullSetup"] then return end game.ReplicatedStorage.RemoteDrop:FireServer() until getMoney() > 950500
			elseif getMoney() <= 1.0e10 then
				Withdrawl()
					BuyItem:InvokeServer("Cell Incinerator", 1)
					wait(0.2) 
					PlaceItem("Cell Incinerator", CFrame.new(3.05175781e-05, 5.00000381, 3, -1, 0, 0, 0, 1, 0, 0, 0, -1) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 	
					PlaceItem("Remote Diamond Mine", CFrame.new(-9, 6.50000381, 1.49996948, 1, 0, 0, 0, 1, 0, 0, 0, 1) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceItem("Remote Diamond Mine", CFrame.new(1.50003052, 6.50000381, -9, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceItem("Remote Diamond Mine", CFrame.new(9, 6.50000381, 1.50003052, -1, 0, 0, 0, 1, 0, 0, 0, -1) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
				Notif("Waiting for your cash to be more than "..MoneyLibModule.HandleMoney(1310000),{"Sweet"},15)
				repeat wait(0.2) if not NewSettings["FullSetup"] then return end game.ReplicatedStorage.RemoteDrop:FireServer() until getMoney() > 1310500
					BuyItem:InvokeServer("Cell Incinerator", 1)
					BuyItem:InvokeServer("Remote Diamond Mine", 3)
					wait(0.5)
					PlaceItem("Remote Diamond Mine", CFrame.new(1.49996948, 6.50000381, -21, 0, 0, 1, 0, 1, -0, -1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceItem("Remote Diamond Mine", CFrame.new(-9, 6.50000381, -31.5000305, 1, 0, 0, 0, 1, 0, 0, 0, 1) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01)
					PlaceItem("Remote Diamond Mine", CFrame.new(9, 6.50000381, -31.4999695, -1, 0, 0, 0, 1, 0, 0, 0, -1) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceItem("Cell Incinerator", CFrame.new(-3.05175781e-05, 5.00000381, -33, 1, 0, 0, 0, 1, 0, 0, 0, 1) + Tycoon.Base.Position, {FacBase}) 
				Notif("Waiting for your cash to be more than "..MoneyLibModule.HandleMoney(1310000),{"Sweet"},15)
				repeat wait(0.2) if not NewSettings["FullSetup"] then return end game.ReplicatedStorage.RemoteDrop:FireServer() until getMoney() > 1310500
					BuyItem:InvokeServer("Cell Incinerator", 1)
					BuyItem:InvokeServer("Remote Diamond Mine", 3)
					wait(0.2) 
					PlaceItem("Cell Incinerator", CFrame.new(-3.05175781e-05, 5.00000381, 15, 1, 0, 0, 0, 1, 0, 0, 0, 1) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceItem("Remote Diamond Mine", CFrame.new(-9, 6.50000381, 16.4999695, 1, 0, 0, 0, 1, 0, 0, 0, 1) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceItem("Remote Diamond Mine", CFrame.new(1.49996948, 6.50000381, 27, 0, 0, 1, 0, 1, -0, -1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceItem("Remote Diamond Mine", CFrame.new(9, 6.50000381, 16.5000305, -1, 0, 0, 0, 1, 0, 0, 0, -1) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
				Notif("Waiting for your cash to be more than "..MoneyLibModule.HandleMoney(500000000),{"Sweet"},15)
				repeat wait(0.2) if not NewSettings["FullSetup"] then return end game.ReplicatedStorage.RemoteDrop:FireServer() until getMoney() > 500005000 -- For Plutonium Excavator
				Withdrawl()
				wait(0.2) 
					BuyItem:InvokeServer("Plutonium Excavator", 1)
					wait(0.2) 
					PlaceItem("Cell Incinerator", CFrame.new(3.05175781e-05, 5.00000381, 3, -1, 0, 0, 0, 1, 0, 0, 0, -1) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01)  
					PlaceItem("Plutonium Excavator", CFrame.new(-9, 5.00000381, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
				Notif("Waiting for your cash to be more than "..MoneyLibModule.HandleMoney(500000000),{"Sweet"},15)
				repeat wait(0.05) checkPlayer()
					if not NewSettings["FullSetup"] then return end
					--pcall(function()
						client.Character.Humanoid:ChangeState(11)
						local PlrTycoon = workspace.Tycoons[tostring(client.PlayerTycoon.Value)]:GetChildren()
						for i,v in next, PlrTycoon do
							if v:IsA("Model") and v.Name == "Cell Incinerator" and v.Model:FindFirstChild("Lava") then
								game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.Model.Lava.CFrame + Vector3.new(0,6,0)
								wait(0.1)
							end 
							if v:IsA("Model") and table.find(ProximityList, v.Name) then 
								fireproximityprompt(v.Model.Internal["ProximityPrompt"], 100)
							end
						end
						client.Character.Humanoid:ChangeState(10)
					--end)
				until getMoney() > 500005000 -- For 2nd Plutonium Excavator
					BuyItem:InvokeServer("Plutonium Excavator", 1)
					wait(0.2) 
					PlaceItem("Cell Incinerator", CFrame.new(-3.05175781e-05, 5.00000381, -15, 1, 0, 0, 0, 1, 0, 0, 0, 1) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceItem("Plutonium Excavator", CFrame.new(-9, 5.00000381, -12, 1, 0, 0, 0, 1, 0, 0, 0, 1) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
				Notif("Waiting for your cash to be more than "..MoneyLibModule.HandleMoney(9.5e8),{"Sweet"},15)
				repeat wait(0.05) checkPlayer()
					if not NewSettings["FullSetup"] then return end 
					--pcall(function()
						client.Character.Humanoid:ChangeState(11)
						local PlrTycoon = workspace.Tycoons[tostring(client.PlayerTycoon.Value)]:GetChildren()
						for i,v in next, PlrTycoon do
							if v:IsA("Model") and v.Name == "Cell Incinerator" and v.Model:FindFirstChild("Lava") then
								game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.Model.Lava.CFrame + Vector3.new(0,6,0)
								wait(0.1)
							end 
							if v:IsA("Model") and table.find(ProximityList, v.Name) then 
								fireproximityprompt(v.Model.Internal["ProximityPrompt"], 100)
							end
						end
						client.Character.Humanoid:ChangeState(10)
					--end)
				until getMoney() > 950005000 -- For Cell Processor with 2 Plutonium Excavators
				BuyItem:InvokeServer("Cell Processor", 1)
				wait(0.2) 
				Withdrawl()
				wait(0.2) 
					wait(0.5)
					PlaceItem("Cell Processor", CFrame.new(0, 5.00000381, 0, -1, 0, 0, 0, 1, 0, 0, 0, -1) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceItem("Plutonium Excavator", CFrame.new(-9, 5.00000381, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceItem("Plutonium Excavator", CFrame.new(9, 5.00000381, 0, -1, 0, 0, 0, 1, 0, 0, 0, -1) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
				Notif("Waiting for your cash to be more than "..MoneyLibModule.HandleMoney(1.96e9),{"Sweet"},15)	
				repeat wait(0.05) checkPlayer()
					if not NewSettings["FullSetup"] then return end 
					client.Character.Humanoid:ChangeState(11)
						local PlrTycoon = workspace.Tycoons[tostring(client.PlayerTycoon.Value)]:GetChildren()
						for i,v in next, PlrTycoon do
							if v:IsA("Model") and v.Name == "Cell Processor" and v.Model:FindFirstChild("Lava") then
								game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.Model.Lava.CFrame + Vector3.new(0,6,0)
								wait(0.1)
							end 
							if v:IsA("Model") and table.find(ProximityList, v.Name) then 
								fireproximityprompt(v.Model.Internal["ProximityPrompt"], 100)
							end
						end
					client.Character.Humanoid:ChangeState(10)
				until getMoney() > 1.96e9 
					BuyItem:InvokeServer("Cell Processor", 1)
					BuyItem:InvokeServer("Plutonium Excavator", 2)
					wait(0.5)
					PlaceItem("Plutonium Excavator", CFrame.new(-9, 5, 18.0000153, 1, 0, 0, 0, 1, 0, 0, 0, 1) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceItem("Cell Processor", CFrame.new(0, 5, 18, 1, 0, 0, 0, 1, 0, 0, 0, 1) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceItem("Plutonium Excavator", CFrame.new(9, 5, 17.9999847, -1, 0, 0, 0, 1, 0, 0, 0, -1) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
				Notif("Waiting for your cash to be more than "..MoneyLibModule.HandleMoney(1.96e9),{"Sweet"},15)
				repeat wait(0.05) checkPlayer()
					if not NewSettings["FullSetup"] then return end 
					client.Character.Humanoid:ChangeState(11)
						local PlrTycoon = workspace.Tycoons[tostring(client.PlayerTycoon.Value)]:GetChildren()
						for i,v in next, PlrTycoon do
							if v:IsA("Model") and v.Name == "Cell Processor" and v.Model:FindFirstChild("Lava") then
								game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.Model.Lava.CFrame + Vector3.new(0,6,0)
								wait(0.1)
							end 
							if v:IsA("Model") and table.find(ProximityList, v.Name) then 
								fireproximityprompt(v.Model.Internal["ProximityPrompt"], 100)
							end
						end
					client.Character.Humanoid:ChangeState(10)
				until getMoney() > 1.96e9 
					BuyItem:InvokeServer("Cell Processor", 1)
					BuyItem:InvokeServer("Plutonium Excavator", 2)
					wait(0.5)
					PlaceItem("Plutonium Excavator", CFrame.new(-9, 5, -17.9999847, 1, 0, 0, 0, 1, 0, 0, 0, 1) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceItem("Cell Processor", CFrame.new(0, 5, -18, 1, 0, 0, 0, 1, 0, 0, 0, 1) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceItem("Plutonium Excavator", CFrame.new(9, 5, -18.0000153, -1, 0, 0, 0, 1, 0, 0, 0, -1) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
				Notif("Waiting for your cash to be more than "..MoneyLibModule.HandleMoney(1.1e10),{"Sweet"},15)
				repeat wait(0.05) checkPlayer()
					if not NewSettings["FullSetup"] then return end 
					client.Character.Humanoid:ChangeState(11)
						local PlrTycoon = workspace.Tycoons[tostring(client.PlayerTycoon.Value)]:GetChildren()
						for i,v in next, PlrTycoon do
							if v:IsA("Model") and v.Name == "Cell Processor" and v.Model:FindFirstChild("Lava") then
								game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.Model.Lava.CFrame + Vector3.new(0,6,0)
								wait(0.1)
							end 
							if v:IsA("Model") and table.find(ProximityList, v.Name) then 
								fireproximityprompt(v.Model.Internal["ProximityPrompt"], 100)
							end
						end
					client.Character.Humanoid:ChangeState(10)
				until getMoney() > 1.1e10 -- 11 billion
			elseif getMoney() <= 1e21 then
				BuyItem:InvokeServer("Portable Ore Advancer", 20)
					BuyItem:InvokeServer("Plasma Iron Polisher", 10)
					BuyItem:InvokeServer("Way-Up-High Upgrader", 1)
					BuyItem:InvokeServer("Plutonium Mine", 1)
					--BuyItem:InvokeServer("Conveyor Ramp", 1)
					BuyItem:InvokeServer("Ore Scanner", 2)
					BuyItem:InvokeServer("Raised Furnace", 1)
					BuyItem:InvokeServer("Military-Grade Conveyor", 1)
					Withdrawl()
					wait(0.2) 
					PlaceRemote:InvokeServer("Military-Grade Conveyor", CFrame.new(81, 2.00000381, -66, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceRemote:InvokeServer("Portable Ore Advancer", CFrame.new(67.5, 3.50000381, -75, -1.1920929e-07, 0, 1.00000012, 0, 1, 0, -1.00000012, 0, -1.1920929e-07) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceRemote:InvokeServer("Portable Ore Advancer", CFrame.new(58.5, 3.50000381, -75, -1.1920929e-07, 0, 1.00000012, 0, 1, 0, -1.00000012, 0, -1.1920929e-07) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceRemote:InvokeServer("Ore Scanner", CFrame.new(-6, 3.50000381, -66, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceRemote:InvokeServer("Ore Scanner", CFrame.new(6, 3.50000381, -66, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceRemote:InvokeServer("Plasma Iron Polisher", CFrame.new(15, 3.50000381, -66, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceRemote:InvokeServer("Plasma Iron Polisher", CFrame.new(21, 3.50000381, -66, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceRemote:InvokeServer("Portable Ore Advancer", CFrame.new(31.5, 3.50000381, -75, -1.1920929e-07, 0, 1.00000012, 0, 1, 0, -1.00000012, 0, -1.1920929e-07) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceRemote:InvokeServer("Portable Ore Advancer", CFrame.new(49.5, 3.50000381, -75, -1.1920929e-07, 0, 1.00000012, 0, 1, 0, -1.00000012, 0, -1.1920929e-07) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceRemote:InvokeServer("Plasma Iron Polisher", CFrame.new(63, 3.50000381, -66, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceRemote:InvokeServer("Plasma Iron Polisher", CFrame.new(57, 3.50000381, -66, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceRemote:InvokeServer("Portable Ore Advancer", CFrame.new(-13.5, 3.50000381, -57, -1.1920929e-07, 0, -1.00000012, 0, 1, 0, 1.00000012, 0, -1.1920929e-07) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceRemote:InvokeServer("Plasma Iron Polisher", CFrame.new(69, 3.50000381, -66, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceRemote:InvokeServer("Portable Ore Advancer", CFrame.new(49.5, 3.50000381, -57, -1.1920929e-07, 0, -1.00000012, 0, 1, 0, 1.00000012, 0, -1.1920929e-07) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceRemote:InvokeServer("Plasma Iron Polisher", CFrame.new(39, 3.50000381, -66, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceRemote:InvokeServer("Portable Ore Advancer", CFrame.new(22.5, 3.50000381, -57, -1.1920929e-07, 0, -1.00000012, 0, 1, 0, 1.00000012, 0, -1.1920929e-07) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceRemote:InvokeServer("Portable Ore Advancer", CFrame.new(40.5, 3.50000381, -57, -1.1920929e-07, 0, -1.00000012, 0, 1, 0, 1.00000012, 0, -1.1920929e-07) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceRemote:InvokeServer("Portable Ore Advancer", CFrame.new(58.5, 3.50000381, -57, -1.1920929e-07, 0, -1.00000012, 0, 1, 0, 1.00000012, 0, -1.1920929e-07) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceRemote:InvokeServer("Portable Ore Advancer", CFrame.new(-13.5, 3.50000381, -75, -1.1920929e-07, 0, 1.00000012, 0, 1, 0, -1.00000012, 0, -1.1920929e-07) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceRemote:InvokeServer("Basic Conveyor", CFrame.new(75, 2.00000381, -66, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceRemote:InvokeServer("Portable Ore Advancer", CFrame.new(4.5, 3.50000381, -75, -1.1920929e-07, 0, 1.00000012, 0, 1, 0, -1.00000012, 0, -1.1920929e-07) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceRemote:InvokeServer("Portable Ore Advancer", CFrame.new(40.5, 3.50000381, -75, -1.1920929e-07, 0, 1.00000012, 0, 1, 0, -1.00000012, 0, -1.1920929e-07) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceRemote:InvokeServer("Portable Ore Advancer", CFrame.new(-4.5, 3.50000381, -75, -1.1920929e-07, 0, 1.00000012, 0, 1, 0, -1.00000012, 0, -1.1920929e-07) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceRemote:InvokeServer("Portable Ore Advancer", CFrame.new(67.5, 3.50000381, -57, -1.1920929e-07, 0, -1.00000012, 0, 1, 0, 1.00000012, 0, -1.1920929e-07) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceRemote:InvokeServer("Portable Ore Advancer", CFrame.new(22.5, 3.50000381, -75, -1.1920929e-07, 0, 1.00000012, 0, 1, 0, -1.00000012, 0, -1.1920929e-07) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceRemote:InvokeServer("Plasma Iron Polisher", CFrame.new(33, 3.50000381, -66, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceRemote:InvokeServer("Plasma Iron Polisher", CFrame.new(27, 3.50000381, -66, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceRemote:InvokeServer("Portable Ore Advancer", CFrame.new(-4.5, 3.50000381, -57, -1.1920929e-07, 0, -1.00000012, 0, 1, 0, 1.00000012, 0, -1.1920929e-07) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceRemote:InvokeServer("Portable Ore Advancer", CFrame.new(13.5, 3.50000381, -75, -1.1920929e-07, 0, 1.00000012, 0, 1, 0, -1.00000012, 0, -1.1920929e-07) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceRemote:InvokeServer("Plasma Iron Polisher", CFrame.new(45, 3.50000381, -66, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceRemote:InvokeServer("Portable Ore Advancer", CFrame.new(31.5, 3.50000381, -57, -1.1920929e-07, 0, -1.00000012, 0, 1, 0, 1.00000012, 0, -1.1920929e-07) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceRemote:InvokeServer("Portable Ore Advancer", CFrame.new(13.5, 3.50000381, -57, -1.1920929e-07, 0, -1.00000012, 0, 1, 0, 1.00000012, 0, -1.1920929e-07) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceRemote:InvokeServer("Portable Ore Advancer", CFrame.new(4.5, 3.50000381, -57, -1.1920929e-07, 0, -1.00000012, 0, 1, 0, 1.00000012, 0, -1.1920929e-07) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceRemote:InvokeServer("Plasma Iron Polisher", CFrame.new(51, 3.50000381, -66, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceRemote:InvokeServer("Basic Conveyor", CFrame.new(57, 2.00000381, -33, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceRemote:InvokeServer("Way-Up-High Upgrader", CFrame.new(63, 5.00000381, -33, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceRemote:InvokeServer("Plutonium Mine", CFrame.new(64.5, 8.00000381, -42, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					if table.find(validInInv_Name(), "Sword Master's Spirit") then
						PlaceRemote:InvokeServer("Basic Conveyor", CFrame.new(-15, 2.00000381, -66, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
						wait(0.01)
						PlaceItem("Sword Master's Spirit", CFrame.new(-27.0000305, 5.00000381, -66, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					else
						BuyItem:InvokeServer("Conveyor Ramp", 1)
						wait(0.01)
						PlaceItem("Conveyor Ramp", CFrame.new(-15, 3.50000381, -66, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
						wait(0.01)
						PlaceItem("Raised Furnace", CFrame.new(-24, 5.00000381, -66.0000305, 1, 0, 0, 0, 1, 0, 0, 0, 1) + Tycoon.Base.Position, {FacBase}) 
					end
					if getResearchPoints() < 50000  then
						Notif("Farming server crates until RP is more than "..MoneyLibModule.HandleMoney(50000).." and Waiting for your cash to be more than "..MoneyLibModule.HandleMoney(1.5e12),{"Sweet"},10)
					else
						Notif("Waiting for your cash to be more than "..MoneyLibModule.HandleMoney(2e13),{"Sweet"},15)
					end
					TouchLoop(PlrTycoon["Way-Up-High Upgrader"], 1e9, "Military-Grade Conveyor")
				repeat checkPlayer() if not NewSettings["FullSetup"] then return end 
					if getResearchPoints() < 50000 then
						FarmCrates()
					end
					wait(0.05)
				until getResearchPoints() > 50000 and getMoney() > 2e13;
					BuyItem:InvokeServer("Sacrificial Altar", 1)
					BuyItem:InvokeServer("Advanced Ore Scanner", 2)
					BuyItem:InvokeServer("Painite Mine", 1)
					BuyItem:InvokeServer("Freon-Blast Upgrader", 1)
					Withdrawl()
					wait(0.4) 
					PlaceItem("Portable Ore Advancer", CFrame.new(34.5, 3.50000381, -18, -1.1920929e-07, 0, 1.00000012, 0, 1, 0, -1.00000012, 0, -1.1920929e-07) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceItem("Advanced Ore Scanner", CFrame.new(12, 5.00000381, -9, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceItem("Advanced Ore Scanner", CFrame.new(0, 5.00000381, -9, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01)
					PlaceItem("Portable Ore Advancer", CFrame.new(61.5, 3.50000381, 0, -1.1920929e-07, 0, -1.00000012, 0, 1, 0, 1.00000012, 0, -1.1920929e-07) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01)
					PlaceItem("Portable Ore Advancer", CFrame.new(43.5, 3.50000381, 0, -1.1920929e-07, 0, -1.00000012, 0, 1, 0, 1.00000012, 0, -1.1920929e-07) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01)
					PlaceItem("Portable Ore Advancer", CFrame.new(25.5, 3.50000381, 0, -1.1920929e-07, 0, -1.00000012, 0, 1, 0, 1.00000012, 0, -1.1920929e-07) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01)
					PlaceItem("Portable Ore Advancer", CFrame.new(16.5, 3.50000381, 0, -1.1920929e-07, 0, -1.00000012, 0, 1, 0, 1.00000012, 0, -1.1920929e-07) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceItem("Portable Ore Advancer", CFrame.new(7.5, 3.50000381, 0, -1.1920929e-07, 0, -1.00000012, 0, 1, 0, 1.00000012, 0, -1.1920929e-07) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceItem("Portable Ore Advancer", CFrame.new(52.5, 3.50000381, 0, -1.1920929e-07, 0, -1.00000012, 0, 1, 0, 1.00000012, 0, -1.1920929e-07) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceItem("Portable Ore Advancer", CFrame.new(-1.5, 3.50000381, 0, -1.1920929e-07, 0, -1.00000012, 0, 1, 0, 1.00000012, 0, -1.1920929e-07) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceItem("Portable Ore Advancer", CFrame.new(79.5, 3.50000381, 0, -1.1920929e-07, 0, -1.00000012, 0, 1, 0, 1.00000012, 0, -1.1920929e-07) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceItem("Plasma Iron Polisher", CFrame.new(75, 3.50000381, -9, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceItem("Portable Ore Advancer", CFrame.new(70.5, 3.50000381, 0, -1.1920929e-07, 0, -1.00000012, 0, 1, 0, 1.00000012, 0, -1.1920929e-07) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceItem("Portable Ore Advancer", CFrame.new(7.5, 3.50000381, -18, -1.1920929e-07, 0, 1.00000012, 0, 1, 0, -1.00000012, 0, -1.1920929e-07) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceItem("Plasma Iron Polisher", CFrame.new(27, 3.50000381, -9, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceItem("Portable Ore Advancer", CFrame.new(79.5, 3.50000381, -18, -1.1920929e-07, 0, 1.00000012, 0, 1, 0, -1.00000012, 0, -1.1920929e-07) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceItem("Portable Ore Advancer", CFrame.new(70.5, 3.50000381, -18, -1.1920929e-07, 0, 1.00000012, 0, 1, 0, -1.00000012, 0, -1.1920929e-07) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceItem("Portable Ore Advancer", CFrame.new(61.5, 3.50000381, -18, -1.1920929e-07, 0, 1.00000012, 0, 1, 0, -1.00000012, 0, -1.1920929e-07) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceItem("Portable Ore Advancer", CFrame.new(52.5, 3.50000381, -18, -1.1920929e-07, 0, 1.00000012, 0, 1, 0, -1.00000012, 0, -1.1920929e-07) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceItem("Portable Ore Advancer", CFrame.new(43.5, 3.50000381, -18, -1.1920929e-07, 0, 1.00000012, 0, 1, 0, -1.00000012, 0, -1.1920929e-07) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceItem("Portable Ore Advancer", CFrame.new(34.5, 3.50000381, 0, -1.1920929e-07, 0, -1.00000012, 0, 1, 0, 1.00000012, 0, -1.1920929e-07) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceItem("Portable Ore Advancer", CFrame.new(25.5, 3.50000381, -18, -1.1920929e-07, 0, 1.00000012, 0, 1, 0, -1.00000012, 0, -1.1920929e-07) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceItem("Portable Ore Advancer", CFrame.new(16.5, 3.50000381, -18, -1.1920929e-07, 0, 1.00000012, 0, 1, 0, -1.00000012, 0, -1.1920929e-07) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceItem("Plasma Iron Polisher", CFrame.new(69, 3.50000381, -9, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceItem("Plasma Iron Polisher", CFrame.new(63, 3.50000381, -9, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceItem("Plasma Iron Polisher", CFrame.new(45, 3.50000381, -9, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceItem("Plasma Iron Polisher", CFrame.new(51, 3.50000381, -9, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceItem("Plasma Iron Polisher", CFrame.new(39, 3.50000381, -9, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceItem("Portable Ore Advancer", CFrame.new(-1.5, 3.50000381, -18, -1.1920929e-07, 0, 1.00000012, 0, 1, 0, -1.00000012, 0, -1.1920929e-07) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceItem("Plasma Iron Polisher", CFrame.new(21, 3.50000381, -9, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceItem("Plasma Iron Polisher", CFrame.new(33, 3.50000381, -9, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceItem("Plasma Iron Polisher", CFrame.new(57, 3.50000381, -9, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceItem("Military-Grade Conveyor", CFrame.new(81, 2.00000381, -9, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceItem("Freon-Blast Upgrader", CFrame.new(60, 5.00000381, -42, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceItem("Basic Conveyor", CFrame.new(66, 2.00000381, -42, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceItem("Basic Conveyor", CFrame.new(72, 2.00000381, -42, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceItem("Painite Mine", CFrame.new(79.5, 8.00000381, -37.5, -1, 0, 0, 0, 1, 0, 0, 0, -1) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					if table.find(validInInv_Name(), "Sword Master's Spirit") then
						PlaceItem("Sword Master's Spirit", CFrame.new(-15.0000305, 5.00000381, -9, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					else
						PlaceItem("Sacrificial Altar", CFrame.new(-16.5, 8.00000381, -9.00003052, -1, 0, 0, 0, 1, 0, 0, 0, -1) + Tycoon.Base.Position, {FacBase}) 
					end
					TouchLoop(PlrTycoon["Freon-Blast Upgrader"], 1.25e11, "Military-Grade Conveyor")
					Notif("Waiting for your cash to be more than "..MoneyLibModule.HandleMoney(4e15),{"Sweet"},15)
				repeat checkPlayer() if not NewSettings["FullSetup"] then return end 
					if getResearchPoints() < 100000 then
						Notif("Farming server crates while we wait!",{"Sweet"},10)
						FarmCrates()
					end
					wait(0.05)
				until getResearchPoints() > 50000 and getMoney() > 3e15;
					BuyItem:InvokeServer("Painite Mine", 1)
					BuyItem:InvokeServer("Shielded Conveyor", 1)
					BuyItem:InvokeServer("Walled Conveyor", 1)
					BuyItem:InvokeServer("Ore Collider", 1)
					BuyItem:InvokeServer("Schrodinger Evaluator", 1)
					Withdrawl()
					wait(0.2)
					PlaceItem("Portable Ore Advancer", CFrame.new(76.5, 3.50000381, -75, 0, 0, 1, 0, 1, -0, -1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceItem("Portable Ore Advancer", CFrame.new(76.5, 3.50000381, -57, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceItem("Portable Ore Advancer", CFrame.new(67.5, 3.50000381, -75, 0, 0, 1, 0, 1, -0, -1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceItem("Shielded Conveyor", CFrame.new(78, 2.00000381, -66, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceItem("Basic Conveyor", CFrame.new(69, 2.00000381, -36, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceItem("Freon-Blast Upgrader", CFrame.new(63, 5.00000381, -36, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceItem("Painite Mine", CFrame.new(73.5, 8.00000381, -43.5, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceItem("Painite Mine", CFrame.new(76.5, 8.00000381, -31.5, -1, 0, 0, 0, 1, 0, 0, 0, -1) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceItem("Portable Ore Advancer", CFrame.new(67.5, 3.50000381, -57, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceItem("Portable Ore Advancer", CFrame.new(58.5, 3.50000381, -57, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceItem("Portable Ore Advancer", CFrame.new(49.5, 3.50000381, -57, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceItem("Portable Ore Advancer", CFrame.new(40.5, 3.50000381, -57, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceItem("Portable Ore Advancer", CFrame.new(31.5, 3.50000381, -57, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceItem("Portable Ore Advancer", CFrame.new(22.5, 3.50000381, -57, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceItem("Portable Ore Advancer", CFrame.new(13.5, 3.50000381, -57, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceItem("Portable Ore Advancer", CFrame.new(4.5, 3.50000381, -57, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceItem("Portable Ore Advancer", CFrame.new(-4.5, 3.50000381, -57, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceItem("Plasma Iron Polisher", CFrame.new(72, 3.50000381, -66, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceItem("Plasma Iron Polisher", CFrame.new(66, 3.50000381, -66, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceItem("Plasma Iron Polisher", CFrame.new(60, 3.50000381, -66, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceItem("Plasma Iron Polisher", CFrame.new(54, 3.50000381, -66, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceItem("Plasma Iron Polisher", CFrame.new(48, 3.50000381, -66, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceItem("Plasma Iron Polisher", CFrame.new(42, 3.50000381, -66, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceItem("Plasma Iron Polisher", CFrame.new(36, 3.50000381, -66, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceItem("Plasma Iron Polisher", CFrame.new(30, 3.50000381, -66, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceItem("Plasma Iron Polisher", CFrame.new(24, 3.50000381, -66, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceItem("Plasma Iron Polisher", CFrame.new(18, 3.50000381, -66, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceItem("Portable Ore Advancer", CFrame.new(4.5, 3.50000381, -75, 0, 0, 1, 0, 1, -0, -1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceItem("Portable Ore Advancer", CFrame.new(-4.5, 3.50000381, -75, 0, 0, 1, 0, 1, -0, -1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceItem("Advanced Ore Scanner", CFrame.new(-3, 5.00000381, -66, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceItem("Advanced Ore Scanner", CFrame.new(9, 5.00000381, -66, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceItem("Portable Ore Advancer", CFrame.new(13.5, 3.50000381, -75, 0, 0, 1, 0, 1, -0, -1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceItem("Portable Ore Advancer", CFrame.new(22.5, 3.50000381, -75, 0, 0, 1, 0, 1, -0, -1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceItem("Portable Ore Advancer", CFrame.new(31.5, 3.50000381, -75, 0, 0, 1, 0, 1, -0, -1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceItem("Portable Ore Advancer", CFrame.new(40.5, 3.50000381, -75, 0, 0, 1, 0, 1, -0, -1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceItem("Portable Ore Advancer", CFrame.new(49.5, 3.50000381, -75, 0, 0, 1, 0, 1, -0, -1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceItem("Portable Ore Advancer", CFrame.new(58.5, 3.50000381, -75, 0, 0, 1, 0, 1, -0, -1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceItem("Ore Collider", CFrame.new(31.5, 3.50000381, -36, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceItem("Walled Conveyor", CFrame.new(39, 2.00000381, -36, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceItem("Schrodinger Evaluator", CFrame.new(48, 3.50000381, -36, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceItem("Military-Grade Conveyor", CFrame.new(57, 2.00000381, -36, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					if table.find(validInInv_Name(), "Sword Master's Spirit") then
						PlaceItem("Sword Master's Spirit", CFrame.new(-18.0000305, 5.00000381, -66, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					else
						PlaceItem("Sacrificial Altar", CFrame.new(-19.5, 8.00000381, -66.0000305, -1, 0, 0, 0, 1, 0, 0, 0, -1) + Tycoon.Base.Position, {FacBase}) 
					end
					wait(0.1)
					Notif("Waiting for your cash to be more than "..MoneyLibModule.HandleMoney(4.5e17),{"Sweet"},15)
					TouchLoop(PlrTycoon["Freon-Blast Upgrader"], 1.25e11, "Military-Grade Conveyor")
					--TPOre(PlrTycoon["Schrodinger Evaluator"], "Walled Conveyor")
					TPOre(PlrTycoon["Ore Collider"], "Shielded Conveyor")
				repeat checkPlayer() if not NewSettings["FullSetup"] then return end 
					local droplimit = game.ReplicatedStorage.PlayerData[FacBase.Parent.Name].DropLimit.Value / 2
					if game.ReplicatedStorage.PlayerData[FacBase.Parent.Name].DropCount.Value >= droplimit then
						Pulse()
					end 
					if getResearchPoints() < 100000 then
						FarmCrates()
					end
					wait(0.05)
				until getResearchPoints() > 50000 and getMoney() > 4.5e17;
					Pulse()
					BuyItem:InvokeServer("Ion Field", 4)
					BuyItem:InvokeServer("The Dream-Maker", 1)
					BuyItem:InvokeServer("Orbitable Upgrader", 3)
					BuyItem:InvokeServer("Flaming Ore Scanner", 2)
					--game.ReplicatedStorage.Items["Ion Field"].Model.Upgrade.Size = Vector3.new(100, 100, 100)
					Withdrawl()
					wait(0.2)
					PlaceRemote:InvokeServer("Basic Conveyor", CFrame.new(-33, 2.00000381, -9, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceRemote:InvokeServer("Portable Ore Advancer", CFrame.new(61.5, 3.50000381, 0, -1.1920929e-07, 0, -1.00000012, 0, 1, 0, 1.00000012, 0, -1.1920929e-07) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceRemote:InvokeServer("Portable Ore Advancer", CFrame.new(43.5, 3.50000381, 0, -1.1920929e-07, 0, -1.00000012, 0, 1, 0, 1.00000012, 0, -1.1920929e-07) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceRemote:InvokeServer("Portable Ore Advancer", CFrame.new(25.5, 3.50000381, 0, -1.1920929e-07, 0, -1.00000012, 0, 1, 0, 1.00000012, 0, -1.1920929e-07) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceRemote:InvokeServer("Portable Ore Advancer", CFrame.new(16.5, 3.50000381, 0, -1.1920929e-07, 0, -1.00000012, 0, 1, 0, 1.00000012, 0, -1.1920929e-07) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceRemote:InvokeServer("Portable Ore Advancer", CFrame.new(7.5, 3.50000381, 0, -1.1920929e-07, 0, -1.00000012, 0, 1, 0, 1.00000012, 0, -1.1920929e-07) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceRemote:InvokeServer("Portable Ore Advancer", CFrame.new(52.5, 3.50000381, 0, -1.1920929e-07, 0, -1.00000012, 0, 1, 0, 1.00000012, 0, -1.1920929e-07) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceRemote:InvokeServer("Portable Ore Advancer", CFrame.new(-1.5, 3.50000381, 0, -1.1920929e-07, 0, -1.00000012, 0, 1, 0, 1.00000012, 0, -1.1920929e-07) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceRemote:InvokeServer("Portable Ore Advancer", CFrame.new(79.5, 3.50000381, 0, -1.1920929e-07, 0, -1.00000012, 0, 1, 0, 1.00000012, 0, -1.1920929e-07) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceRemote:InvokeServer("Plasma Iron Polisher", CFrame.new(75, 3.50000381, -9, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceRemote:InvokeServer("Portable Ore Advancer", CFrame.new(70.5, 3.50000381, 0, -1.1920929e-07, 0, -1.00000012, 0, 1, 0, 1.00000012, 0, -1.1920929e-07) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceRemote:InvokeServer("Portable Ore Advancer", CFrame.new(7.5, 3.50000381, -18, -1.1920929e-07, 0, 1.00000012, 0, 1, 0, -1.00000012, 0, -1.1920929e-07) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceRemote:InvokeServer("Plasma Iron Polisher", CFrame.new(27, 3.50000381, -9, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceRemote:InvokeServer("Portable Ore Advancer", CFrame.new(79.5, 3.50000381, -18, -1.1920929e-07, 0, 1.00000012, 0, 1, 0, -1.00000012, 0, -1.1920929e-07) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceRemote:InvokeServer("Portable Ore Advancer", CFrame.new(70.5, 3.50000381, -18, -1.1920929e-07, 0, 1.00000012, 0, 1, 0, -1.00000012, 0, -1.1920929e-07) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceRemote:InvokeServer("Portable Ore Advancer", CFrame.new(61.5, 3.50000381, -18, -1.1920929e-07, 0, 1.00000012, 0, 1, 0, -1.00000012, 0, -1.1920929e-07) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceRemote:InvokeServer("Portable Ore Advancer", CFrame.new(52.5, 3.50000381, -18, -1.1920929e-07, 0, 1.00000012, 0, 1, 0, -1.00000012, 0, -1.1920929e-07) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceRemote:InvokeServer("Portable Ore Advancer", CFrame.new(43.5, 3.50000381, -18, -1.1920929e-07, 0, 1.00000012, 0, 1, 0, -1.00000012, 0, -1.1920929e-07) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceRemote:InvokeServer("Portable Ore Advancer", CFrame.new(34.5, 3.50000381, 0, -1.1920929e-07, 0, -1.00000012, 0, 1, 0, 1.00000012, 0, -1.1920929e-07) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceRemote:InvokeServer("Portable Ore Advancer", CFrame.new(25.5, 3.50000381, -18, -1.1920929e-07, 0, 1.00000012, 0, 1, 0, -1.00000012, 0, -1.1920929e-07) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceRemote:InvokeServer("Portable Ore Advancer", CFrame.new(16.5, 3.50000381, -18, -1.1920929e-07, 0, 1.00000012, 0, 1, 0, -1.00000012, 0, -1.1920929e-07) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceRemote:InvokeServer("Plasma Iron Polisher", CFrame.new(69, 3.50000381, -9, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceRemote:InvokeServer("Plasma Iron Polisher", CFrame.new(63, 3.50000381, -9, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01)  
					PlaceRemote:InvokeServer("Plasma Iron Polisher", CFrame.new(45, 3.50000381, -9, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceRemote:InvokeServer("Plasma Iron Polisher", CFrame.new(51, 3.50000381, -9, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceRemote:InvokeServer("Portable Ore Advancer", CFrame.new(34.5, 3.50000381, -18, -1.1920929e-07, 0, 1.00000012, 0, 1, 0, -1.00000012, 0, -1.1920929e-07) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceRemote:InvokeServer("Plasma Iron Polisher", CFrame.new(39, 3.50000381, -9, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01)  
					PlaceRemote:InvokeServer("Portable Ore Advancer", CFrame.new(-1.5, 3.50000381, -18, -1.1920929e-07, 0, 1.00000012, 0, 1, 0, -1.00000012, 0, -1.1920929e-07) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceRemote:InvokeServer("Plasma Iron Polisher", CFrame.new(21, 3.50000381, -9, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceRemote:InvokeServer("Plasma Iron Polisher", CFrame.new(33, 3.50000381, -9, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceRemote:InvokeServer("Plasma Iron Polisher", CFrame.new(57, 3.50000381, -9, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceRemote:InvokeServer("Basic Conveyor", CFrame.new(-15, 2.00000381, -9, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceRemote:InvokeServer("Ion Field", CFrame.new(-12, 8.00000381, -21, -1.1920929e-07, 0, -1.00000012, 0, 1, 0, 1.00000012, 0, -1.1920929e-07) + Tycoon.Base.Position, {FacBase}) 
					for i1,v1 in next, PlrTycoon:GetChildren() do
						if v1.Name == "Ion Field" then
							v1.Model.Upgrade.Size = Vector3.new(40, 40, 40)
						end
					end
					wait(0.01) 
					PlaceRemote:InvokeServer("Ion Field", CFrame.new(-12, 8.00000381, 3, -1.1920929e-07, 0, 1.00000012, 0, 1, 0, -1.00000012, 0, -1.1920929e-07) + Tycoon.Base.Position, {FacBase})
					for i1,v1 in next, PlrTycoon:GetChildren() do
						if v1.Name == "Ion Field" then
							v1.Model.Upgrade.Size = Vector3.new(40, 40, 40)
						end
					end 
					wait(0.01) 
					PlaceRemote:InvokeServer("Ion Field", CFrame.new(-24, 8.00000381, 3, -1.1920929e-07, 0, 1.00000012, 0, 1, 0, -1.00000012, 0, -1.1920929e-07) + Tycoon.Base.Position, {FacBase}) 
					for i1,v1 in next, PlrTycoon:GetChildren() do
						if v1.Name == "Ion Field" then
							v1.Model.Upgrade.Size = Vector3.new(40, 40, 40)
						end
					end
					wait(0.01) 
					--game.ReplicatedStorage.Items["Ion Field"].Model.Upgrade.Size = Vector3.new(100, 100, 100)
					PlaceRemote:InvokeServer("Ion Field", CFrame.new(-24, 8.00000381, -21, -1.1920929e-07, 0, -1.00000012, 0, 1, 0, 1.00000012, 0, -1.1920929e-07) + Tycoon.Base.Position, {FacBase}) 
					for i1,v1 in next, PlrTycoon:GetChildren() do
						if v1.Name == "Ion Field" then
							v1.Model.Upgrade.Size = Vector3.new(40, 40, 40)
						end
					end
					wait(0.01) 
					PlaceRemote:InvokeServer("Orbitable Upgrader", CFrame.new(-43.5, 3.50000381, -3, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01)  
					PlaceRemote:InvokeServer("Basic Conveyor", CFrame.new(-21, 2.00000381, -9, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceRemote:InvokeServer("Basic Conveyor", CFrame.new(-27, 2.00000381, -9, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceRemote:InvokeServer("Basic Conveyor", CFrame.new(-39, 2.00000381, -9, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceRemote:InvokeServer("Shielded Conveyor", CFrame.new(81, 2.00000381, -9, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceRemote:InvokeServer("Flaming Ore Scanner", CFrame.new(-4.5, 5.00000381, -9, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01)  
					PlaceRemote:InvokeServer("Orbitable Upgrader", CFrame.new(-34.5, 3.50000381, -15, 0, 0, 1, 0, 1, -0, -1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01)  
					PlaceRemote:InvokeServer("Flaming Ore Scanner", CFrame.new(10.5, 5.00000381, -9, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceRemote:InvokeServer("Basic Conveyor", CFrame.new(-45, 2.00000381, -9, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceRemote:InvokeServer("Orbitable Upgrader", CFrame.new(-34.5, 3.50000381, -3, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceRemote:InvokeServer("Painite Mine", CFrame.new(49.5, 8.00000381, 7.5, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceRemote:InvokeServer("Painite Mine", CFrame.new(52.5, 8.00000381, 19.5, -1, 0, 0, 0, 1, 0, 0, 0, -1) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01)  
					PlaceRemote:InvokeServer("Basic Conveyor", CFrame.new(45, 2.00000381, 15, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01)  
					PlaceRemote:InvokeServer("Freon-Blast Upgrader", CFrame.new(39, 5.00000381, 15, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceRemote:InvokeServer("Military-Grade Conveyor", CFrame.new(27, 2.00000381, 15, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceRemote:InvokeServer("Schrodinger Evaluator", CFrame.new(18, 3.50000381, 15, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceRemote:InvokeServer("Ore Collider", CFrame.new(7.5, 3.50000381, 15, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					if table.find(validInInv_Name(), "Sword Master's Spirit") then
						PlaceRemote:InvokeServer("Sword Master's Spirit", CFrame.new(-57.0000305, 5.00000381, -9, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					else
						PlaceRemote:InvokeServer("The Dream-Maker", CFrame.new(-55.5, 5.00000381, -9.00003052, -1, 0, 0, 0, 1, 0, 0, 0, -1) + Tycoon.Base.Position, {FacBase}) 
					end
					wait(0.1)
					if getResearchPoints() < 100000 then
						Notif("Farming server crates until RP is more than "..MoneyLibModule.HandleMoney(100000).." and Waiting for your cash to be more than "..MoneyLibModule.HandleMoney(1.8e19),{"Sweet"},10)
					else
						Notif("Waiting for your cash to be more than "..MoneyLibModule.HandleMoney(1.8e19),{"Sweet"},15)
					end
					TouchLoop(PlrTycoon["Freon-Blast Upgrader"], 1.25e11, "Military-Grade Conveyor")
					--TPOre(PlrTycoon["Schrodinger Evaluator"], "Walled Conveyor")
					TPOre(PlrTycoon["Ore Collider"], "Shielded Conveyor")
					OGLife = game.Players.LocalPlayer.Rebirths.Value
				repeat checkPlayer() if not NewSettings["FullSetup"] then return end 
					local droplimit = tonumber(game.ReplicatedStorage.PlayerData[FacBase.Parent.Name].DropLimit.Value / 2)
					if game.ReplicatedStorage.PlayerData[FacBase.Parent.Name].DropCount.Value >= droplimit then
						Pulse()
					end 
					if getMoney() > RebornPrice(client.Rebirths.Value) then
						game.ReplicatedStorage.Rebirth:InvokeServer()
						wait(5)
						return
					end
					wait(0.05)
					if (CurrentLife > OGLife) then
						return
					end
					wait(0.05)
				until (CurrentLife > OGLife) or (getResearchPoints() > 100000 and getMoney() > 1.8e19);
					Pulse()
					BuyItem:InvokeServer("Tiny Conveyor", 2)
					BuyItem:InvokeServer("Nuclear Conveyor", 1)
					BuyItem:InvokeServer("Portable Macrowave", 1)
					BuyItem:InvokeServer("Serpentine Upgrader", 1)
					BuyItem:InvokeServer("Raised-ier Conveyor", 1)
					BuyItem:InvokeServer("Shrine of Penitence", 1)
					Withdrawl()
					wait(0.2)	
					PlaceRemote:InvokeServer("Painite Mine", CFrame.new(76.5, 8.00000381, -61.5, -1, 0, 0, 0, 1, 0, 0, 0, -1) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceRemote:InvokeServer("Painite Mine", CFrame.new(73.5, 8.00000381, -73.5, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceRemote:InvokeServer("Basic Conveyor", CFrame.new(69, 2.00000381, -66, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceRemote:InvokeServer("Freon-Blast Upgrader", CFrame.new(63, 5.00000381, -66, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceRemote:InvokeServer("Military-Grade Conveyor", CFrame.new(72, 2.00000381, -45, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceRemote:InvokeServer("Serpentine Upgrader", CFrame.new(58.5, 3.50000381, -42, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceRemote:InvokeServer("Tiny Conveyor", CFrame.new(67.5, 2.00000381, -46.5, 1, 0, 0, 0, 1, 0, 0, 0, 1) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceRemote:InvokeServer("Tiny Conveyor", CFrame.new(67.5, 2.00000381, -43.5, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceRemote:InvokeServer("Shielded Conveyor", CFrame.new(72, 2.00000381, -24, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceRemote:InvokeServer("Ore Collider", CFrame.new(52.5, 3.50000381, -24, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceRemote:InvokeServer("Schrodinger Evaluator", CFrame.new(63, 3.50000381, -24, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceRemote:InvokeServer("Portable Ore Advancer", CFrame.new(70.5, 3.50000381, 0, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceRemote:InvokeServer("Walled Conveyor", CFrame.new(72, 2.00000381, -6, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceRemote:InvokeServer("Portable Macrowave", CFrame.new(72, 5.00000381, 16.5, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceRemote:InvokeServer("Raised-ier Conveyor", CFrame.new(72, 3.50000381, 10.5, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceRemote:InvokeServer("Nuclear Conveyor", CFrame.new(72, 2.00000381, 36, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceRemote:InvokeServer("Flaming Ore Scanner", CFrame.new(46.5, 5.00000381, 36, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceRemote:InvokeServer("Flaming Ore Scanner", CFrame.new(61.5, 5.00000381, 36, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceRemote:InvokeServer("Orbitable Upgrader", CFrame.new(1.5, 3.50000381, 30, 0, 0, 1, 0, 1, -0, -1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceRemote:InvokeServer("Basic Conveyor", CFrame.new(36, 2.00000381, 36, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceRemote:InvokeServer("Basic Conveyor", CFrame.new(30, 2.00000381, 36, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceRemote:InvokeServer("Basic Conveyor", CFrame.new(24, 2.00000381, 36, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceRemote:InvokeServer("Basic Conveyor", CFrame.new(18, 2.00000381, 36, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceRemote:InvokeServer("Basic Conveyor", CFrame.new(12, 2.00000381, 36, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceRemote:InvokeServer("Ion Field", CFrame.new(33, 8.00000381, 45, -1.1920929e-07, 0, 1.00000012, 0, 1, 0, -1.00000012, 0, -1.1920929e-07) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceRemote:InvokeServer("Ion Field", CFrame.new(33, 8.00000381, 27, -1.1920929e-07, 0, -1.00000012, 0, 1, 0, 1.00000012, 0, -1.1920929e-07) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceRemote:InvokeServer("Ion Field", CFrame.new(21, 8.00000381, 45, -1.1920929e-07, 0, 1.00000012, 0, 1, 0, -1.00000012, 0, -1.1920929e-07) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceRemote:InvokeServer("Ion Field", CFrame.new(21, 8.00000381, 27, -1.1920929e-07, 0, -1.00000012, 0, 1, 0, 1.00000012, 0, -1.1920929e-07) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceRemote:InvokeServer("Orbitable Upgrader", CFrame.new(10.5, 3.50000381, 42, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceRemote:InvokeServer("Orbitable Upgrader", CFrame.new(10.5, 3.50000381, 30, 0, 0, 1, 0, 1, -0, -1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceRemote:InvokeServer("Basic Conveyor", CFrame.new(0, 2.00000381, 36, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					PlaceRemote:InvokeServer("Basic Conveyor", CFrame.new(6, 2.00000381, 36, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					wait(0.01) 
					if table.find(validInInv_Name(), "Sword Master's Spirit") then
						PlaceRemote:InvokeServer("Sword Master's Spirit", CFrame.new(-12.0000305, 5.00000381, 36, 0, 0, -1, 0, 1, 0, 1, 0, 0) + Tycoon.Base.Position, {FacBase}) 
					else
						PlaceRemote:InvokeServer("Shrine of Penitence", CFrame.new(-9, 5.00000381, 35.9999695, -1, 0, 0, 0, 1, 0, 0, 0, -1) + Tycoon.Base.Position, {FacBase}) 
					end
					for i1,v1 in next, PlrTycoon:GetChildren() do
						if v1.Name == "Ion Field" then
							v1.Model.Upgrade.Size = Vector3.new(40, 40, 40)
						end
					end --"Farming server crates until RP is more than "..MoneyLibModule.HandleMoney(100000)..
					TouchLoop(PlrTycoon["Freon-Blast Upgrader"], 1.25e11, "Military-Grade Conveyor")
					TouchLoop(PlrTycoon["Serpentine Upgrader"], 1e12, "Shielded Conveyor")
					TPOre(PlrTycoon["Ore Collider"], "Walled Conveyor")
					TouchLoopAmount(PlrTycoon["Portable Ore Advancer"], 30, "Raised-ier Conveyor")
					TouchLoopAmount(PlrTycoon["Portable Macrowave"], 6, "Nuclear Conveyor")
					Notif("Waiting for your cash to be more than "..MoneyLibModule.HandleMoney(1e20),{"Sweet"},10)
					OGLife = client.Rebirths.Value
				repeat checkPlayer() if not NewSettings["FullSetup"] then return end 
					CurrentLife = client.Rebirths.Value
					local droplimit = game.ReplicatedStorage.PlayerData[FacBase.Parent.Name].DropLimit.Value / 2
					if game.ReplicatedStorage.PlayerData[FacBase.Parent.Name].DropCount.Value >= droplimit then
						Pulse()
					end 
					if getResearchPoints() < 150000 then
						FarmCrates()
					end
					if getMoney() > RebornPrice(client.Rebirths.Value) then
						game.ReplicatedStorage.Rebirth:InvokeServer()
						wait(5)
						return
					end
					wait(0.05)
					if (CurrentLife > OGLife) then
						return
					end
				until getResearchPoints() > 100000 and getMoney() > 1e21; -- Make layout for sx rebirhts
				local droplimit = game.ReplicatedStorage.PlayerData[FacBase.Parent.Name].DropLimit.Value / 2
				if game.ReplicatedStorage.PlayerData[FacBase.Parent.Name].DropCount.Value >= droplimit then
					Pulse()
				end 

			elseif getMoney() <= 1e24 then -- 1 Septillion
				if not NewSettings["FullSetup"] then return end 
				Withdrawl()
				--Notif("Done For Now",{"Sweet"},nil)
			end
		end

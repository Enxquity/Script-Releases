local RenderPoint = workspace.Render

local params = RaycastParams.new()
params.FilterDescendantsInstances = {workspace.Rays}

local Canvas = {
	
}

function MakeCanvas()
	for x = -80, 80, 1 do
		--// Populate canvas
		Canvas[x] = {}
		for y = -80, 80, 1 do
			local NewUI = Instance.new("Frame", script.Parent.Canvas.Frame)
			NewUI.Size = UDim2.fromOffset(2, 2)
			NewUI.Position = UDim2.fromOffset(x*2 + 250, -y*2 + 250)
			NewUI.BackgroundColor3 = Color3.new(1,1,1)
			NewUI.BorderSizePixel = 0
			Canvas[x][y] = NewUI
		end
	end
end

function Render()
	if #script.Parent.Canvas.Frame:GetChildren() == 0 then
		MakeCanvas()
		print("Made Canvas")
	end
	
	local A = 0
	local RenderStart = tick()
	for i,v in pairs(workspace.Rays:GetChildren()) do
		v:Destroy()
	end
	
	for x = -80, 80, 1 do -- 80 is the resolution so 80x80 pixels * 2 due to it having to go both directions so in total 160x160
		for y = -80, 80, 1 do
			local dir = Vector3.new(x/200, y/200, 0)
			local R = workspace:Raycast(RenderPoint.Position, (RenderPoint.CFrame.LookVector + dir) * 100, params)
			
			if R and Canvas[x][y].BackgroundColor3 == R.Instance.Color then continue end
			Canvas[x][y].BackgroundColor3 = R and R.Instance.Color or Color3.new(1,1,1)
			
			A+=1
			if A%400 == 0 then
				task.wait()
			end
		end
	end
	print(("Render took: %f"):format(tick()-RenderStart))
end

Render()

game:GetService("UserInputService").InputBegan:Connect(function(Input, IsTyping)
	if IsTyping then return end
	if Input.KeyCode == Enum.KeyCode.G then
		RenderPoint.Position += Vector3.new(0, 0, -1)
		Render()
	elseif Input.KeyCode == Enum.KeyCode.B then
		RenderPoint.Position += Vector3.new(0, 0, 1)
		Render()
	end
end)

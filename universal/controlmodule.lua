-- Damn it, Solara and Xeno didn’t add require (rip)
local UserInputService = game:GetService('UserInputService');
local RunService = game:GetService('RunService');

local controlModule = {}
local moveDirection = Vector3.zero
local touchInput, startPos
local keyboardVec = Vector3.zero
local touchVec = Vector3.zero

local function updateKeyboardMovement()
    local forward, right = 0, 0

    if UserInputService:IsKeyDown(Enum.KeyCode.W) then forward += 1 end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then forward -= 1 end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then right += 1 end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then right -= 1 end

    local vec = Vector3.new(right, 0, forward)
    keyboardVec = (vec.Magnitude > 0) and vec.Unit or Vector3.zero
end

UserInputService.TouchStarted:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        touchInput = input
        startPos = input.Position
    end
end)

UserInputService.TouchMoved:Connect(function(input)
    if input == touchInput and startPos then
        local delta = input.Position - startPos
        local vec = Vector3.new(delta.X, 0, delta.Y)
        touchVec = (vec.Magnitude > 20) and vec.Unit or Vector3.zero
    end
end)

UserInputService.TouchEnded:Connect(function(input)
    if input == touchInput then
        touchInput = nil
        startPos = nil
        touchVec = Vector3.zero
    end
end)

RunService.Heartbeat:Connect(function()
    updateKeyboardMovement()
    if touchVec.Magnitude > 0 then
        moveDirection = touchVec
    else
        moveDirection = keyboardVec
    end
end)

function controlModule:GetMoveVector()
    return moveDirection
end

return controlModule

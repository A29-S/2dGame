Ballon = Class{}

local GRAVITY = 10

function Ballon:init()
    self.image = love.graphics.circle( "fill", VIRTUAL_WIDTH / 2 - 8, VIRTUAL_HEIGHT / 2 - 8, 100 )
    self.x = VIRTUAL_WIDTH / 2 - 8
    self.y = VIRTUAL_HEIGHT / 2 - 8

    self.width = self.image:getWidth() 
    self.height = self.image:getHeight()

    self.dy = 0
end

--[[
    AABB collision that expects a pipe, which will have an X and Y and reference
    global pipe width and height values.
]]
function Bird:collides(pipe)
    -- the 2's are left and top offsets
    -- the 4's are right and bottom offsets
    -- both offsets are used to shrink the bounding box to give the player
    -- a little bit of leeway with the collision

    if (self.x + 2) + (self.width - 4) >= pipe.x and self.x + 2 <= pipe.x + PIPE_WIDTH then
        if (self.y + 2) + (self.height - 4) >= pipe.y and self.y + 2 <= pipe.y + PIPE_HEIGHT then
            return true
        end
    end

    return false
end

function Ballon:update(dt)
    self.dy = self.dy + GRAVITY * dt

    if love.keyboard.wasPressed('space') or love.mouse.wasPressed(1) then
        self.dy = -5
        sounds['jump']:play()
    end

    self.y = self.y + self.dy
end

function Ballon:render()
    love.graphics.draw(self.image, self.x, self.y)
end

push = require 'push'
Class = require 'class'

require 'Ballon'
require 'Mountain'
require 'Bird'
require 'Tower'
require 'Bush'
--require 'Aim'

require 'StateMachine'
--require 'states/PlayState'
--require 'states/TitleScreenState'
--require 'states/BaseState'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

local background = love.graphics.newImage('asset/background.png')
local bush = love.graphics.newImage('asset/ground.png')

local backgroundScroll = 0
local bushScroll = 0

local backgroundScroll_SPEED = 25
local bushScroll_SPEED = 50

local backgroundScroll_LOOPING_POINT = 413

local ballon = Ballon()

local mountains = {}
local birds = {}

local spawn_Mountain_Timer = 0
local spawn_Bird_Timer = math.random(2, 7)

local scrolling = true

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    math.randomseed(os.time())

    love.window.setTitle('Nomex')


    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })


    love.keyboard.keysPressed = {}
    love.mouse.keysPressed = {}
    love.mouse.keysReleased = {}

end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
	love.keyboard.keysPressed[key] = true

	if key == 'escape' then
		love.event.quit()
	end
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.mousepressed(x, y, key)
    love.mouse.keysPressed[key] = true
end

function love.mousereleased(x, y, key)
    love.mouse.keysReleased[key] = true 
end

function love.mouse.wasPressed(key)
    return love.mouse.keysPressed[key]
end

function love.mouse.wasReleased(key)
    return love.mouse.keysReleased[key]
end

function love.update(dt)
	if scrolling then

	   backgroundScroll = (backgroundScroll + backgroundScroll_SPEED * dt) 
	        % backgroundScroll_LOOPING_POINT

	   bushScroll = (bushScroll + bushScroll_SPEED * dt) 
	        % VIRTUAL_WIDTH

	   spawn_Mountain_Timer = spawn_Mountain_Timer + dt
	   spawn_Bird_Timer = spawn_Bird_Timer + dt

	   if spawn_Mountain_Timer > 2 then
	   		table.insert(mountains, Mountain())
	   		spawn_Mountain_Timer = 0
	   end

	   if spawn_Bird_Timer > math.random(2, 7) then
	   		table.insert(birds, Bird())
	   		spawn_Bird_Timer = 0
	   end

	   ballon:update(dt)

	   for i, mountain in pairs(mountains) do
	   		mountain:update(dt)

	   		if ballon:collides(mountain)  or  
	   			--ground collision checker
	   			((ballon.y + 2) + (ballon.height - 4)  >= VIRTUAL_HEIGHT - 15) 
	   			--cloud collision checker
	   			or ((ballon.y + 2) + (ballon.height - 4)  <= 25)then
	   			scrolling = false
	   		end	

	   		if mountain.x < -mountain.width then
	   			table.remove(mountains, i)
	   		end
	   end

	   for i, bird in pairs(birds) do
	   		bird:update(dt)

	   		if bird.x < -bird.width then
	   			table.remove(birds, i)
	   		end
	   	end
		
		for i, bird in pairs(birds) do
		   	if bird.remove then
		   		table.remove(bird, i)
		   	end
		end

	   for i, mountain in pairs(mountains) do
	   		if mountain.remove then
	   			table.remove(mountain, i)
	   		end
	   end

	   

	   love.keyboard.keysPressed = {}

   end
end

function love.draw()
    push:start()

    love.graphics.draw(background, -backgroundScroll, 0)

    for i, bird in pairs(birds) do
    	bird:render()
    end

    for i, mountain in pairs(mountains) do
    	mountain:render()
    end
   
    love.graphics.draw(bush, -bushScroll, VIRTUAL_HEIGHT - 16)

    ballon:render()
    
    push:finish()
end
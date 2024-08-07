-- Constants for obstace, car and screen dimensions
SCREEN_WIDTH = 800
SCREEN_HEIGHT = 600
OBSTACLE_WIDTH = 50
OBSTACLE_HEIGHT = 50
CAR_WIDTH = 40
CAR_HEIGHT = 60

-- Variables
game_over = false
current_level = 1
obstacles = {}
score = 0
elapsed_time = 0

-- Constants for colors
WHITE = {1, 1, 1}
GREEN = {0, 1, 0}
RED = {1, 0, 0}

-- Define the Car class
Car = {}
Car.__index = Car

levels = {
    [1] = {
        obstacle_rate = 0.25,
        speed_increase = 0.25,
        max_hits = 3,
        duration = 60 -- 60 seconds for the first level
    },
    [2] = {
        obstacle_rate = 2,
        speed_increase = 0.1,
        max_hits = 3,
        duration = 60
    },
    [3] = {
        obstacle_rate = 5,
        speed_increase = 0.1,
        max_hits = 3,
        duration = 60
    },
    [4] = {
        obstacle_rate = 10,
        speed_increase = 0.25,
        max_hits = 3,
        duration = 60
    },
    [5] = {
        obstacle_rate = 20,
        speed_increase = 0.30,
        max_hits = 3,
        duration = 60
    },
}


function Car:create(x, y)
    local car = {}
    setmetatable(car, Car)
    car.x = x
    car.y = y
    car.dx = 10
    car.speed = 0.1
    car.hit_count = 0
    return car
end

function Car:draw()
    love.graphics.setColor(WHITE)
    love.graphics.rectangle("fill", self.x, self.y, CAR_WIDTH, CAR_HEIGHT)
end

function Car:move(direction)
    local new_position = self.x + self.dx * direction * self.speed
    self.x = math.max(0, math.min(SCREEN_WIDTH - CAR_WIDTH, new_position))
end

function Car:increase_speed()
    self.speed = self.speed + 0.01
end

function Car:decrease_speed()
    self.speed = math.max(0.1, self.speed - 0.05)
end

function Car:hit()
    self.hit_count = self.hit_count + 1
    self:decrease_speed()
end

-- Define the Obstacle class
Obstacle = {}
Obstacle.__index = Obstacle

function Obstacle:create(x, y)
    local obstacle = {}
    setmetatable(obstacle, Obstacle)
    obstacle.x = x
    obstacle.y = y
    obstacle.dy = 5
    return obstacle
end

function Obstacle:draw()
    love.graphics.setColor(GREEN)
    love.graphics.rectangle("fill", self.x, self.y, OBSTACLE_WIDTH, OBSTACLE_HEIGHT)
end

function Obstacle:move()
    self.y = self.y + self.dy
end

-- Variables for the game state
local car
local obstacles = {}
local time_count = 0
local obstacle_rate = 30

-- Additional variables for enhanced features
local score = 0
local elapsed_time = 0
local gameOverFont = love.graphics.newFont(40)
local scoreFont = love.graphics.newFont(20)

function love.load()
    love.window.setMode(SCREEN_WIDTH, SCREEN_HEIGHT)
    love.window.setTitle("Car Dodging Game")
    car = Car:create(SCREEN_WIDTH / 2, SCREEN_HEIGHT - CAR_HEIGHT - 10)
end

function love.update(dt)
    if game_over then
        return
    end

    if love.keyboard.isDown("left") then
        car:move(-1)
    elseif love.keyboard.isDown("right") then
        car:move(1)
    end

    -- Use level's obstacle rate
    if math.random(0, levels[current_level].obstacle_rate) == 0 then
        table.insert(obstacles, Obstacle:create(math.random(0, SCREEN_WIDTH - OBSTACLE_WIDTH), -OBSTACLE_HEIGHT))
    end

    for i, obstacle in ipairs(obstacles) do
        obstacle:move()
        obstacle.dy = obstacle.dy + levels[current_level].speed_increase

        if car.x < obstacle.x + OBSTACLE_WIDTH and
           car.x + CAR_WIDTH > obstacle.x and
           car.y < obstacle.y + OBSTACLE_HEIGHT and
           car.y + CAR_HEIGHT > obstacle.y then
            car:hit()
            table.remove(obstacles, i)
        elseif obstacle.y > SCREEN_HEIGHT then
            car:increase_speed()
            table.remove(obstacles, i)
        end
    end

    if car.hit_count >= levels[current_level].max_hits then
        game_over = true
    end

    elapsed_time = elapsed_time + dt
    if elapsed_time >= 1 then
        score = score + 1
        elapsed_time = elapsed_time - 1
    end

    -- All other updates related to the game and its mechanics...
end


function love.draw()
    car:draw()
    for _, obstacle in ipairs(obstacles) do
        obstacle:draw()
    end
    -- Displaying the score
    love.graphics.setFont(scoreFont)
    love.graphics.setColor(WHITE)
    love.graphics.print("Score: " .. score, 10, 10)
    love.graphics.print("Hits: " .. car.hit_count .. "/3", SCREEN_WIDTH - 110, 10)

    if car.hit_count >= 3 then
        love.graphics.setFont(gameOverFont)
        love.graphics.setColor(RED)
        love.graphics.printf("Game Over", 0, SCREEN_HEIGHT/2 - 60, SCREEN_WIDTH, "center")
        love.graphics.printf("Final Score: " .. score, 0, SCREEN_HEIGHT/2, SCREEN_WIDTH, "center")
    end
end

-- ... [rest of the constants and class definitions]

local game_over = false  -- Add this line to keep track of game state

function love.update(dt)
    if game_over then
        return
    end

    if love.keyboard.isDown("left") then
        car:move(-1)
    elseif love.keyboard.isDown("right") then
        car:move(1)
    end

    if math.random(0, obstacle_rate) == 0 then
        table.insert(obstacles, Obstacle:create(math.random(0, SCREEN_WIDTH - OBSTACLE_WIDTH), -OBSTACLE_HEIGHT))
    end

    for i, obstacle in ipairs(obstacles) do
        obstacle:move()

        if car.x < obstacle.x + OBSTACLE_WIDTH and
           car.x + CAR_WIDTH > obstacle.x and
           car.y < obstacle.y + OBSTACLE_HEIGHT and
           car.y + CAR_HEIGHT > obstacle.y then
            car:hit()
            table.remove(obstacles, i)
        elseif obstacle.y > SCREEN_HEIGHT then
            car:increase_speed()
            table.remove(obstacles, i)
        end

        obstacle.dy = obstacle.dy + dt / 5  -- Increasing obstacle speed over time
    end

    if car.hit_count >= 3 then
        game_over = true  -- Set game state to over instead of quitting
    end

    elapsed_time = elapsed_time + dt
    if elapsed_time >= 1 then
        score = score + 1
        elapsed_time = elapsed_time - 1
    end

    time_count = time_count + dt
    if time_count > 10 then
        obstacle_rate = math.max(5, obstacle_rate - 5)
        time_count = 0
    end
end

function love.draw()
    car:draw()
    for _, obstacle in ipairs(obstacles) do
        obstacle:draw()
    end

    -- Displaying the score
    love.graphics.setFont(scoreFont)
    love.graphics.setColor(WHITE)
    love.graphics.print("Score: " .. score, 10, 10)
    love.graphics.print("Hits: " .. car.hit_count .. "/3", SCREEN_WIDTH - 110, 10)

    if game_over then  -- Checking if the game state is over
        love.graphics.setFont(gameOverFont)
        love.graphics.setColor(RED)
        love.graphics.printf("Game Over", 0, SCREEN_HEIGHT/2 - 60, SCREEN_WIDTH, "center")
        love.graphics.printf("Final Score: " .. score, 0, SCREEN_HEIGHT/2, SCREEN_WIDTH, "center")
    end
end

-- Drawing the fade effect during transitions
if transitioning or game_over then
    love.graphics.setColor(0, 0, 0, fade_value) -- Using a black color for the fade
    love.graphics.rectangle("fill", 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
end

-- Drawing the transition message or "Congratulations" for the final level
if transitioning and fade_in then
    love.graphics.setFont(gameOverFont)
    love.graphics.setColor(1, 1, 1, 1 - fade_value) -- The message will fade out as the screen fades in
    love.graphics.printf("Level " .. current_level, 0, SCREEN_HEIGHT/2 - 60, SCREEN_WIDTH, "center")
elseif game_over and current_level == #levels then
    love.graphics.setFont(gameOverFont)
    love.graphics.setColor(1, 1, 1, fade_value)
    love.graphics.printf("Congratulations", 0, SCREEN_HEIGHT/2 - 60, SCREEN_WIDTH, "center")
end

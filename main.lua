-- main.lua
local playerLeftColor = {1, 0, 0}  -- Rojo
local playerRightColor = {0, 0, 1} -- Azul
local paddleLeft = { x = 50, y = 250, width = 10, height = 60, speed = 400,color=playerLeftColor,score=0 }
local paddleRight = { x = 740, y = 250, width = 10, height = 60, speed = 400,color=playerRightColor, score=0 }
local gameState = "menu" -- Estado inicial del juego
local isPaused = false -- Variable para controlar la pausa
local ball = { x = 400, y = 300, width = 20, height = 20, speedX = 0, speedY = 0 }
local ballSpeed=300
local ballSpeedIncrease=50
local scoreLeft = 0
local scoreRight = 0
local winningScore=5


function love.load()
    love.window.setTitle("Pong Game")
    love.window.setMode(800, 600)

    -- Configura la fuente para el texto
    font = love.graphics.newFont(24)
    love.graphics.setFont(font)
end

function love.update(dt)
    
    if gameState == "game" and not isPaused then
        -- Actualiza el juego solo cuando esté en modo de juego y no esté en pausa
        ball.x = ball.x + ball.speedX * dt
        ball.y = ball.y + ball.speedY * dt

        if ball.y < 0 or ball.y + ball.height > 600 then
            ball.speedY = -ball.speedY -- Invierte la dirección vertical
        end

        if ball.x < 0 then
            -- Punto para el jugador de la derecha
            paddleRight.score = paddleRight.score+1
            ResetBall()
        elseif ball.x + ball.width > 800 then
            -- Punto para el jugador de la izquierda
            paddleLeft.score = paddleLeft.score + 1
            ResetBall()
        end
        
        if ball.x < paddleLeft.x + paddleLeft.width and
        ball.y + ball.height > paddleLeft.y and
        ball.y < paddleLeft.y + paddleLeft.height then
         ball.speedX = -ball.speedX -- Invertir dirección horizontal
         ball.speedX = ball.speedX + (ball.speedX > 0 and ballSpeedIncrease or -ballSpeedIncrease) -- Aumentar velocidad
     end

     -- Colisión de la pelota con la paleta derecha
     if ball.x + ball.width > paddleRight.x and
        ball.y + ball.height > paddleRight.y and
        ball.y < paddleRight.y + paddleRight.height then
         ball.speedX = -ball.speedX -- Invertir dirección horizontal
         ball.speedX = ball.speedX + (ball.speedX > 0 and ballSpeedIncrease or -ballSpeedIncrease) -- Aumentar velocidad
     end
        
    if love.keyboard.isDown("w") and paddleLeft.y > 0 then
        paddleLeft.y = paddleLeft.y - paddleLeft.speed * dt
       
    end
    if love.keyboard.isDown("s") and paddleLeft.y<540 then
        paddleLeft.y = paddleLeft.y + paddleLeft.speed * dt
      
    end
    if love.keyboard.isDown("up") and paddleRight.y>0 then
        paddleRight.y = paddleRight.y - paddleRight.speed * dt
    end
    if love.keyboard.isDown("down") and paddleRight.y<540 then
        paddleRight.y = paddleRight.y + paddleRight.speed * dt
    
    end
  end
end

function love.draw()
    if gameState == "menu" then
        -- Dibuja la pantalla de menú
        love.graphics.print("Press Enter to start", 300, 250)
    elseif gameState == "game" then
        -- Dibuja el juego
        -- Dibuja el campo de juego
        love.graphics.rectangle("line", 0, 0, 800, 600) -- Bordes del campo
        
        love.graphics.line(400, 0, 400, 600) -- Línea central
        love.graphics.rectangle("fill", ball.x, ball.y, ball.width,ball.height)

        love.graphics.setColor(paddleLeft.color)
        love.graphics.rectangle("fill", paddleLeft.x, paddleLeft.y, paddleLeft.width, paddleLeft.height)
        love.graphics.setColor(paddleRight.color)
        love.graphics.rectangle("fill", paddleRight.x, paddleRight.y, paddleRight.width, paddleRight.height)
        love.graphics.setColor(paddleLeft.color)
        love.graphics.print("Player 1: " .. paddleLeft.score, 50, 50)
        love.graphics.setColor(paddleRight.color)
        love.graphics.print("Player 2: " .. paddleRight.score, 650, 50)
        love.graphics.setColor(1, 1, 1)
    elseif gameState == "gameover" then
    -- Determinar al ganador y mostrar un mensaje
    local winner
    if paddleLeft.score == winningScore then
        winner = "Player 1"
    else
        winner = "Player 2"
    end

    love.graphics.printf(winner .. " wins!\nPress Enter to restart", 0, 250, 800, "center")
end

    if isPaused then
        -- Dibuja el texto de pausa
        love.graphics.printf("PAUSED\nPress Esc or P to resume", 0, 250, 800, "center")
    end
end

function love.keypressed(key)
    if key == "return" then
        if gameState == "menu" then
            gameState = "game"
        end
    elseif key == "escape" or key == "p" then
        isPaused = not isPaused
    elseif key == "space" then
        -- Presionar la barra espaciadora (space) crea una pelota en el centro del campo
        if gameState == "game" and not isPaused then
            ball.x = 400
            ball.y = 300
            local angle = math.random() * math.pi * 2 -- Ángulo aleatorio en radianes
            local speed = 200 -- Velocidad de la pelota
            ball.speedX = math.cos(angle) * speed
            ball.speedY = math.sin(angle) * speed
        end
    end
end

function ResetBall()
    ball.x = 400
    ball.y = 300
    ball.speedX = 0
    ball.speedY = 0
end
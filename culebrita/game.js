const canvas = document.getElementById("gameCanvas");
const ctx = canvas.getContext("2d");

const scoreElement = document.getElementById("score");
const messageElement = document.getElementById("message");

const gridSize = 20;

const tileCount = canvas.width / gridSize;

let snake;
let food;

let direction;

let nextDirection;

let score;

let gameRunning;

let gameLoop;


function restartGame() {

    snake = [
        { x: 10, y: 10 },
        { x: 9, y: 10 },
        { x: 8, y: 10 }
    ];

    direction = {
        x: 1,
        y: 0
    };

    nextDirection = {
        x: 1,
        y: 0
    };

    score = 0;

    gameRunning = true;

    scoreElement.textContent = score;

    messageElement.textContent =
        "Usa las flechas del teclado para jugar";

    generateFood();

    clearInterval(gameLoop);

    gameLoop = setInterval(updateGame, 100);
}


function generateFood() {

    food = {
        x: Math.floor(Math.random() * tileCount),
        y: Math.floor(Math.random() * tileCount)
    };

    for (let segment of snake) {

        if (
            segment.x === food.x &&
            segment.y === food.y
        ) {

            generateFood();

            return;
        }
    }
}


function updateGame() {

    if (!gameRunning) {
        return;
    }

    direction = nextDirection;

    const head = {
        x: snake[0].x + direction.x,
        y: snake[0].y + direction.y
    };


    if (
        head.x < 0 ||
        head.x >= tileCount ||
        head.y < 0 ||
        head.y >= tileCount
    ) {

        endGame();

        return;
    }


    for (let segment of snake) {

        if (
            segment.x === head.x &&
            segment.y === head.y
        ) {

            endGame();

            return;
        }
    }


    snake.unshift(head);


    if (
        head.x === food.x &&
        head.y === food.y
    ) {

        score++;

        scoreElement.textContent = score;

        generateFood();

    } else {

        snake.pop();
    }


    drawGame();
}


function drawGame() {

    ctx.fillStyle = "#000";

    ctx.fillRect(
        0,
        0,
        canvas.width,
        canvas.height
    );


    ctx.fillStyle = "#ef4444";

    ctx.fillRect(
        food.x * gridSize,
        food.y * gridSize,
        gridSize - 2,
        gridSize - 2
    );


    snake.forEach((segment, index) => {

        if (index === 0) {

            ctx.fillStyle = "#4ade80";

        } else {

            ctx.fillStyle = "#22c55e";
        }


        ctx.fillRect(
            segment.x * gridSize,
            segment.y * gridSize,
            gridSize - 2,
            gridSize - 2
        );

    });
}


function endGame() {

    gameRunning = false;

    clearInterval(gameLoop);

    messageElement.textContent =
        "¡Game Over! Puntuación: " + score;
}


document.addEventListener(
    "keydown",
    function(event) {

        switch (event.key) {

            case "ArrowUp":

                if (direction.y !== 1) {

                    nextDirection = {
                        x: 0,
                        y: -1
                    };
                }

                break;


            case "ArrowDown":

                if (direction.y !== -1) {

                    nextDirection = {
                        x: 0,
                        y: 1
                    };
                }

                break;


            case "ArrowLeft":

                if (direction.x !== 1) {

                    nextDirection = {
                        x: -1,
                        y: 0
                    };
                }

                break;


            case "ArrowRight":

                if (direction.x !== -1) {

                    nextDirection = {
                        x: 1,
                        y: 0
                    };
                }

                break;
        }

    }
);


restartGame();

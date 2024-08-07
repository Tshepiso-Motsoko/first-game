# (LÖVE) The impossible-to-beat 'car' Game

**Video Demo:** [https://youtu.be/bUKKXSTNoy0](https://youtu.be/bUKKXSTNoy0)

## Description:
The (LÖVE) The-impossible-to-beat 'car' game is a dynamic and immersive driving game that offers players a truly unique and challenging experience. Developed using the LÖVE framework, this game showcases the powers of the Lua programming language in game development.

## Implementation Details:

### Car Class:
- `initialize(self, x, y)`: Initializes the car's position, speed, and hit count.
- `draw(self)`: Draws the car on the LÖVE window.
- `move(self, direction)`: Controls the horizontal movement of the car based on user input.
- `increase_speed(self)`: Increases the car's speed, escalating the game's difficulty over time.
- `decrease_speed(self)`: Decreases the car's speed, especially useful when a collision occurs.
- `hit(self)`: Handles the scenario when the car collides with an obstacle.

### Obstacle Class:
- `initialize(self, x, y)`: Initializes the obstacle's position.
- `draw(self)`: Draws the obstacle on the LÖVE window.
- `move(self)`: Controls the movement of the obstacle, making it fall from the top to the bottom of the window.

The main function of the game is hosted in the `main.lua` file. This file could import the classes from `classes.lua` (but initially I thought the game work be too short to implement another file but now that I have nearly 300 lines of code it's some to consider which I definitely will as I add more features after submitting this prototype) and incorporates the game loop, which manages events, executes game logic, and updates the window.

To further enhance the game's functionality, the `main.lua` file integrates additional functions such as `create_obstacle()`, `detect_collision()`, and `reset_game()`, each playing a crucial role in the game dynamics.

## Testing:
The testing phase for LÖVE games is usually conducted manually since it's challenging to use automated testing tools with the LÖVE framework. Players and developers tested various scenarios to ensure game mechanics work seamlessly and provide feedback to further refine the gameplay.

## Requirements:
The game requires the LÖVE framework for execution. Make sure you have it installed for your respective platform from [https://love2d.org/](https://love2d.org/).

The final product is a shining example of the potential of Lua and LÖVE in creating simple, yet enthralling games (with the potential of adding more features in a much easier manner than pygame). While being a simple project on the surface, it integrates all the essential elements of a classic car obstacle game. Its design choices reflect the power of object-oriented programming in Lua and how game elements can be efficiently managed to create a functional and enjoyable user experience.

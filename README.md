# The Legend of Frog

A game made in 8086 Assembly. Inspired by The Legend of Zelda (1986).

## The game

Upon opening the game, there will be 4 options. Start playing, read story, see credits, and exit.<br>
<br>
When you start playing, the screen will be divided into 2 parts. The top one is the game, and the bottom is the UI. The number in the right of the UI is the player's health. The six numbers in the middle are the player's materials (gold, diamond, ruby) and stats (sword, armor, ring). On the right of the UI there will be a minimap and the cost of each stat.<br>
<br>
You can move the player with WASD. When the player reaches the boundries of the screen, it will move and reveal the next part of the world. In the world, there can be found apples, gold, diamond, and ruby. When standing next to them and pressing space, the row will disappear and the materials will be added to the UI. If apples are eaten, your health will be restored according to your ring stat.<br>
<br>
There are also enemies in the map in the shape of spiders. When a player collides with an enemy, the player will be damaged and its health would go down according to the armor stat (more armor = less damage). The player can attack the spiders by pressing K. When pressing, a sword will be shown. If an enemy collides with the sword, it will be damaged according to your sword stat (more sword = more damage).<br>
<br>
The player can upgrade their stats by pressing 1, 2, or 3. When doing so, the correct materials will be removed from the UI according to the recipes on the left of the UI, and the target stat will be upgraded.<br>
<br>
The player wins by killing all spiders. If the player's health goes down to 0, the player loses.

## How to run

The game can only run on DOSBox. It is recommended to run <code>cycles = max</code> before running the game, to ensure that the game runs at full speed.<br>
To compile (with TASM) and run, execute <code>run.bat</code>. To compile and debug (with Turbo Debugger), execute <code>debug.bat</code>. To just run the game, execute <code>base.exe</code>.

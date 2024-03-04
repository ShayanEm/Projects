/**
  ******************************************************************************
  * @file    obstacle.c
  * @brief   This file provides functions to handle obstacles in the game.
  ******************************************************************************
  * @author   Shayan Eram
  ******************************************************************************
  */
#include "avatar.h"
#include "MCUFRIEND_kbv.h"
#include "stdio.h"
#include "stdlib.h"
#include "main.h"

/**
  * @brief External variables declaration.
  */
extern double objectDistance;
extern int objectDisappeared;
extern int sendObstacle;
extern uint8_t Rx_value[3];
extern int previousDistance;
extern int receivedObstaclePosition;
int obstacleSpeed = 15;
extern int nextObstacleYpos;
extern int full_timer;
int id = 0;
extern int mySpeed;

/**
  * @brief Initializes the game.
  * @param avatar: Pointer to the Avatar structure
  * @param obstacle: Pointer to the Obstacle structure
  * @retval None
  */
void initGame(struct Avatar *avatar, struct Obstacle *obstacle) {
	avatar->posy = AVATAR_POSY_START;
	avatar->previous_posy = AVATAR_POSY_START;

	avatar->width = AVATAR_POSX;
	avatar->posx = AVATAR_WIDTH;
	avatar->length = AVATAR_LENGTH;
	avatar->color = RED;
	
	obstacle->width = 30;
	obstacle->counter = 24;
	
	LCD_Begin();
	HAL_Delay(20);
	LCD_SetRotation(1);
	LCD_FillScreen(COLOR_BACKGROUND);
	
	drawAvatar(avatar);
}

/**
  * @brief Draws the avatar (car) on the screen.
  * @param avatar: Pointer to the Avatar structure
  */
void drawAvatar(struct Avatar *avatar) {
    int posx = avatar->posx;
    int posy = avatar->posy;
    int width = avatar->width;
    int length = avatar->length;
    int color = avatar->color;

    // Body
    LCD_FillRect(posx, posy + length / 3, width, length / 3, color);
    // Roof
    LCD_FillRect(posx + width / 5, posy, width * 3 / 5, length / 3, color);
    // Windows
    LCD_FillRect(posx + width / 5, posy + length / 15, width / 5, length / 5, WHITE);  // Left window
    LCD_FillRect(posx + width * 3 / 5, posy + length / 15, width / 5, length / 5, WHITE);  // Right window
    // Wheels
    LCD_FillCircle(posx + width / 4, posy + length * 2 / 3, width / 6, BLACK);  // Left wheel
    LCD_FillCircle(posx + width * 3 / 4, posy + length * 2 / 3, width / 6, BLACK);  // Right wheel
    // Bumpers
    LCD_FillRect(posx - 2, posy + length / 3, 2, length / 3, BLACK);  // Left bumper
    LCD_FillRect(posx + width, posy + length / 3, 2, length / 3, BLACK);  // Right bumper
}

/**
  * @brief Moves the avatar.
  * @param avatar: Pointer to the Avatar structure
  * @retval None
  */
void moveAvatar(struct Avatar *avatar) {
	int move = 1; // variable move n'est plus vraiment necessaire
		
	if(move == 0) {
		avatar->previous_posy = avatar->posy;
	}
	if(move == 1) {
		avatar->previous_posy = avatar->posy;
		avatar->posy = 230 - 5 * objectDistance;
		if(avatar->posy > 210)
			avatar->posy = 210;
		if(avatar->posy < 0)
			avatar->posy = 0;
	}
	if(move == 2) {
		avatar->previous_posy = avatar->posy;
		avatar->posy -= 30;
		if(avatar->posy < 0)
			avatar->posy = 0;
	}
	
	avatar->step++;
	drawAvatar(avatar);
	if (move != 0) {
	}
}

/**
  * @brief Moves and draws the obstacle on the screen.
  * @param obstacle: Pointer to the Obstacle structure
  */
void moveObstacle(struct Obstacle *obstacle) {
    // Update obstacle position
    obstacle->posx -= obstacleSpeed;

    // Draw obstacle
    if (obstacle->posx + obstacle->width > 0) {
        // Draw main body
        LCD_FillRect(obstacle->posx, obstacle->posy, obstacle->width, obstacle->length, obstacle->color);
        
        // Draw details or variation
        // Add headlights
        int headlightSize = 5; // headlight size
        LCD_FillRect(obstacle->posx + obstacle->width / 4 - headlightSize / 2, obstacle->posy + obstacle->length / 4, headlightSize, headlightSize, WHITE); // Left headlight
        LCD_FillRect(obstacle->posx + obstacle->width * 3 / 4 - headlightSize / 2, obstacle->posy + obstacle->length / 4, headlightSize, headlightSize, WHITE); // Right headlight
        
        // Add patterns or textures
        int patternSize = 3; // pattern size
        for (int x = obstacle->posx; x < obstacle->posx + obstacle->width; x += patternSize * 2) {
            for (int y = obstacle->posy; y < obstacle->posy + obstacle->length; y += patternSize * 2) {
                LCD_DrawPixel(x, y, BLACK); // Draw pattern
            }
        }
    } else {
        // Reset obstacle position and choose a new appearance
        obstacle->posx = 320;  // Adjust position based on screen width
        obstacle->counter = 0; // Reset counter for appearance variation
        
        // Randomly choose the color and size of the next obstacle
        obstacle->color = rand() % 0xFFFFFF; // Random color
        obstacle->width = (rand() % 50) + 30; // Random width (minimum 30 pixels)
        obstacle->length = (rand() % 50) + 30; // Random length (minimum 30 pixels)
    }
}
	
	if(obstacle->posx <= 0 - obstacle->width || obstacle->counter == 0) {
		obstacle->posy = receivedObstaclePosition;
	}
	
	if(obstacle->posx < 330 && sendObstacle == 0 && receivedObstaclePosition != 0)
		Rx_value[2] = 1;
	
	if(Rx_value[2] == 1) {
		if(obstacle->posx < 320)
			LCD_FillRect(310, 0, 10, 240, BLACK);
		
		obstacle->posx -= obstacleSpeed;
		
		if(obstacle->posx <= 0 - obstacle->width)
			Rx_value[2] = 0;
		
		LCD_FillRect(obstacle->posx + obstacleSpeed, obstacle->posy, obstacle->width + 1, obstacle->length + 1, BLACK);
		LCD_FillRect(obstacle->posx + obstacle->width / 5, obstacle->posy, obstacle->width * 3 / 5, obstacle->length / 3, obstacle->color); // body
		LCD_FillRect(obstacle->posx, obstacle->posy + obstacle->length / 3, obstacle->width, obstacle->length * 2 / 3, obstacle->color);  // top
		LCD_FillCircle(obstacle->posx + obstacle->width * 4 / 5, obstacle->posy + obstacle->length * 5 / 6, obstacle->width / 10, WHITE);	// Front tire
		LCD_FillCircle(obstacle->posx + obstacle->width / 5, obstacle->posy + obstacle->length * 5 / 6, obstacle->width / 10, WHITE);	// Back tire
		
		obstacle->counter++;
	}

/**
  * @brief Checks for collision between the avatar and obstacle.
  * @param avatar: Pointer to the Avatar structure
  * @param obstacle: Pointer to the Obstacle structure
  * @retval 1 if collision detected, 0 otherwise
  */
int lookColision(struct Avatar *avatar, struct Obstacle *obstacle) {
    // Define collision boundaries for avatar and obstacle
    int avatar_left = avatar->posx;
    int avatar_right = avatar->posx + avatar->width;
    int avatar_top = avatar->posy;
    int avatar_bottom = avatar->posy + avatar->length;
    
    int obstacle_left = obstacle->posx;
    int obstacle_right = obstacle->posx + obstacle->width;
    int obstacle_top = obstacle->posy;
    int obstacle_bottom = obstacle->posy + obstacle->length;
    
    // Check if boundaries intersect
    if (avatar_right >= obstacle_left && avatar_left <= obstacle_right &&
        avatar_bottom >= obstacle_top && avatar_top <= obstacle_bottom) {
        // Collision detected
        obstacle->counter = 0;
        LCD_FillScreen(BLACK);
        char buffer[20] = {0};
        int score = full_timer;
        sprintf(buffer, "ACCIDENT!!!");
        LCD_SetCursor(45, 105);
        LCD_SetTextSize(4);
        LCD_SetTextColor(RED, BLACK);
        LCD_Printf(buffer);
        LCD_SetCursor(45, 150);
        LCD_SetTextSize(2);
        LCD_SetTextColor(WHITE, BLACK);
        LCD_Printf("SCORE:");
        LCD_Printf("%i", score);
        LCD_SetCursor(45, 180);
        LCD_SetTextSize(2);
        LCD_SetTextColor(WHITE, BLACK);
        LCD_Printf("MAX SPEED:");
        LCD_Printf("%i", mySpeed);
        full_timer = 0;
        mySpeed = 0;
        return 1;
    }
    return 0;
}

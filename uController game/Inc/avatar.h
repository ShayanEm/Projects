#ifndef AVATAR_H
#define AVATAR_H
/**
  * @brief Y-coordinate of the starting position for the avatar.
  */
#define AVATAR_POSY_START 90

/**
  * @brief X-coordinate of the avatar.
  */
#define AVATAR_POSX 30

/**
  * @brief Width of the avatar.
  */
#define AVATAR_WIDTH 30

/**
  * @brief Length of the avatar.
  */
#define AVATAR_LENGTH 30

/**
  * @brief Background color (BLACK).
  */
#define COLOR_BACKGROUND 0x0000

/**
  * @brief Background color (WHITE).
  */
#define COLOR_BACKGROUND2 0xFFFF

/**
  * @brief Structure representing the Avatar.
  */
struct Avatar {
    int posy; /**< Y-coordinate of the avatar's position */
    int previous_posy; /**< Previous Y-coordinate of the avatar's position */
    int posx; /**< X-coordinate of the avatar's position */
    int length; /**< Length of the avatar */
    int width; /**< Width of the avatar */
    int color; /**< Color of the avatar */
    int step; /**< Step size for avatar movement */
};

/**
  * @brief Structure representing an obstacle.
  */
struct Obstacle {
    int posy; /**< Y-coordinate of the obstacle's position */
    int posx; /**< X-coordinate of the obstacle's position */
    int length; /**< Length of the obstacle */
    int width; /**< Width of the obstacle */
    int color; /**< Color of the obstacle */
    int id; /**< Identifier for the obstacle */
    int counter; /**< Counter for the obstacle */
};

/**
  * @brief Initializes the game with the given avatar and obstacle.
  * @param avatar Pointer to the Avatar structure
  * @param obstacle Pointer to the Obstacle structure
  */
void initGame(struct Avatar *avatar, struct Obstacle *obstacle);

/**
  * @brief Draws the avatar on the screen.
  * @param avatar Pointer to the Avatar structure
  */
void drawAvatar(struct Avatar *avatar);

/**
  * @brief Moves the avatar.
  * @param avatar Pointer to the Avatar structure
  */
void moveAvatar(struct Avatar *avatar);

/**
  * @brief Moves the obstacle.
  * @param obstacle Pointer to the Obstacle structure
  */
void moveObstacle(struct Obstacle *obstacle);

/**
  * @brief Checks for collision between the avatar and obstacle.
  * @param avatar Pointer to the Avatar structure
  * @param obstacle Pointer to the Obstacle structure
  * @return 1 if there is a collision, 0 otherwise
  */
int lookCollision(struct Avatar *avatar, struct Obstacle *obstacle);

#endif // AVATAR_H

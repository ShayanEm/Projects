/**
  ******************************************************************************
  * @file    main.c
  * @brief   Main program body
  * @author	 Shayan Eram
  ******************************************************************************
  */
#include "main.h"

uint8_t Tx_value[TABLE_LENGTH];
uint8_t Rx_value[3];
uint8_t temp_value[1];
volatile int current_state = 0;
int counter = 0;
struct Avatar avatar;
struct Obstacle obstacle;
int gameover = 0;
volatile int scroll = 0;
int timer = 0;
int full_timer = 0;
int speed = 200;
uint32_t risingEdgeTime = 0;
uint32_t fallingEdgeTime = 0;
uint32_t pulseWidth = 0;
double objectDistance = 0;
double testDistance = 101;
volatile int capturedRisingEdge = 0;
int numMeasures = 0;
int previousDistance;
int sendObstacle = 0;
int objectDetected = 0;
int objectDisappeared = 0;
int nextObstacleYpos = 0;
int receivedObstaclePosition = 0;
int draw = 0;
int i = 0;
int test = 0;
int numReceivedMeasures = 0;
int mySpeed = 100;
int speedTimer;

/**
  * @brief  Function to wait for a brief period
  * @param  None
  * @retval None
  */
void wait()
{
    __HAL_TIM_SET_COUNTER(&htim8, 0);
    while (__HAL_TIM_GET_COUNTER(&htim8) < 3);
}

/**
  * @brief  Callback function for handling input capture events
  * @param  htim: TIM handle pointer
  * @retval None
  */
void HAL_TIM_IC_CaptureCallback(TIM_HandleTypeDef *htim)
{
    // Check if the interrupt is from TIM3 and channel 3
    if (htim->Instance == TIM3 && htim->Channel == HAL_TIM_ACTIVE_CHANNEL_3)
    {
        previousDistance = objectDistance;

        // Handling rising edge
        if (capturedRisingEdge == 0)
        {
            risingEdgeTime = HAL_TIM_ReadCapturedValue(htim, TIM_CHANNEL_3);
            capturedRisingEdge = 1;

            // Detecting object and updating measures
            if (objectDetected == 1 && testDistance <= 100)
                numMeasures++;
            if (objectDetected == 0 && testDistance <= 100)
                objectDetected = 1;
            else if (objectDetected == 1 && testDistance >= 100)
            {
                // Processing when object disappears
                numMeasures++;
                if (numMeasures == 2)
                {
                    nextObstacleYpos = 230 - 5 * previousDistance;
                    objectDisappeared = 1;
                    Tx_value[0] = 255;
                    Tx_value[1] = nextObstacleYpos;
                    Tx_value[2] = obstacle.id;
                    Tx_value[3] = 254;
                    numMeasures = 0;
                    draw = 1;
                }
            }
            else if (objectDisappeared == 1 && testDistance <= 100)
            {
                // Resetting state when object reappears
                Tx_value[0] = 0;
                sendObstacle = 0;
                objectDetected = 0;
                objectDisappeared = 0;
                numMeasures = 0;
            }
            if (i == 0)
                i = 1;
        }
        // Handling falling edge
        else if (capturedRisingEdge == 1)
        {
            fallingEdgeTime = HAL_TIM_ReadCapturedValue(htim, TIM_CHANNEL_3);
            __HAL_TIM_SET_COUNTER(htim, 0);
            pulseWidth = (fallingEdgeTime - risingEdgeTime);
            testDistance = (pulseWidth)*340 / 2;
            testDistance /= 400;
            capturedRisingEdge = 0;

            // Checking distance and updating object distance
            if (testDistance > 100)
                return;
            else
                objectDistance = testDistance;
        }
    }
}

/**
  * @brief  Callback function for handling system tick timer
  * @param  None
  * @retval None
  */
void HAL_SYSTICK_Callback(void)
{
    // Updating timers
    speedTimer++;
    full_timer++;
    timer++;

    // Updating speed every 5000 ticks
    if (speedTimer == 5000)
    {
        speedTimer = 0;
        mySpeed += 20;
    }

    // Handling scrolling
    if (timer >= speed)
    {
        scroll = 1;
        timer = 0;
    }
}

/**
  * @brief  Main function
  * @param  None
  * @retval None
  */
int main(void)
{
    while (1)
    {
        // Waiting for scrolling signal
        while (!scroll);
        scroll = 0;

        // Incrementing obstacle ID
        obstacle.id++;
        if (obstacle.id > 7)
            obstacle.id = 0;

        // Moving avatar and obstacle
        receivedObstaclePosition = Rx_value[0];
        moveAvatar(&avatar);
        moveObstacle(&obstacle);

        // Checking collision
        gameover = lookColision(&avatar, &obstacle);
        if (gameover)
        {
            // Handling game over state
            HAL_Delay(5000);
            initGame(&avatar, &obstacle);
            drawAvatar(&avatar);
        }

        // Displaying score and speed
        LCD_SetCursor(10, 10);
        LCD_SetTextSize(2);
        LCD_SetTextColor(WHITE, BLACK);
        LCD_Printf("SCORE:");
        LCD_Printf("%i", full_timer);
        LCD_SetCursor(10, 35);
        LCD_SetTextSize(2);
        LCD_SetTextColor(WHITE, BLACK);
        LCD_Printf("SPEED:");
        LCD_Printf("%i", mySpeed);
    }
}

/**
  * @brief  Callback function for UART receive
  * @param  huart: UART handle pointer
  * @retval None
  */
void HAL_UART_RxCpltCallback(UART_HandleTypeDef *huart)
{
    switch (current_state)
    {
    case 0:
        // Checking for start byte
        if (temp_value[0] == 255)
        {
            current_state = 1;
            counter = 0;
        }
        else
        {
            current_state = 0;
            Rx_value[2] = 0;
        }
        break;
    case 1:
        // Receiving data bytes
        Rx_value[counter] = temp_value[0];
        if (counter == 1)
            current_state = 2;
        counter++;
        break;
    case 2:
        // Checking for end byte
        if (temp_value[0] == 254)
        {
            current_state = 0;
            Rx_value[2] = 1;
        }
        else
        {
            // Resetting if end byte not received
            current_state = 0;
            Rx_value[0] = 0;
            Rx_value[1] = 0;
            Rx_value[2] = 0;
        }
        break;
    }
    // Restarting UART reception
    HAL_UART_Receive_IT(&huart5, temp_value, 1);
}

/**
  * @brief  Overriding putchar function for UART output
  * @param  ch: character to be transmitted
  * @param  f: pointer to FILE structure
  * @retval Transmitted character
  */
PUTCHAR_PROTOTYPE
{
    HAL_UART_Transmit(&huart2, (uint8_t *)&ch, 1, 0xFFFF);
    return ch;
}

/**
  * @brief  Error handler function
  * @param  None
  * @retval None
  */
void Error_Handler(void)
{
    // Halting program execution in case of error
    __disable_irq();
    while (1)
    {
    }
}

#include "usart.h"

/**
  * @brief Initializes UART5 peripheral.
  * @param None
  * @retval None
  */
void MX_UART5_Init(void)
{
  /* UART5 initialization code */
  huart5.Instance = UART5;
  huart5.Init.BaudRate = 2400;
  huart5.Init.WordLength = UART_WORDLENGTH_8B;
  huart5.Init.StopBits = UART_STOPBITS_1;
  huart5.Init.Parity = UART_PARITY_NONE;
  huart5.Init.Mode = UART_MODE_TX_RX;
  huart5.Init.HwFlowCtl = UART_HWCONTROL_NONE;
  huart5.Init.OverSampling = UART_OVERSAMPLING_16;
  if (HAL_UART_Init(&huart5) != HAL_OK) {
    Error_Handler();
  }
}

/**
  * @brief Initializes USART2 peripheral.
  * @param None
  * @retval None
  */
void MX_USART2_UART_Init(void)
{
  /* USART2 initialization code */
  huart2.Instance = USART2;
  huart2.Init.BaudRate = 115200;
  huart2.Init.WordLength = UART_WORDLENGTH_8B;
  huart2.Init.StopBits = UART_STOPBITS_1;
  huart2.Init.Parity = UART_PARITY_NONE;
  huart2.Init.Mode = UART_MODE_TX_RX;
  huart2.Init.HwFlowCtl = UART_HWCONTROL_NONE;
  huart2.Init.OverSampling = UART_OVERSAMPLING_16;
  if (HAL_UART_Init(&huart2) != HAL_OK)
  {
    Error_Handler();
  }
}

/**
  * @brief Initializes UART MSP (MCU Specific Package).
  * @param uartHandle: Pointer to UART handle structure
  * @retval None
  */
void HAL_UART_MspInit(UART_HandleTypeDef* uartHandle)
{
  /* UART MSP initialization code */
}

/**
  * @brief Deinitializes UART MSP (MCU Specific Package).
  * @param uartHandle: Pointer to UART handle structure
  * @retval None
  */
void HAL_UART_MspDeInit(UART_HandleTypeDef* uartHandle)
{
  /* UART MSP deinitialization code */
}

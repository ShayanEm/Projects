#include "dma.h"

/* DMA handle declaration */
DMA_HandleTypeDef hdma_adc1; /**< Handle for ADC DMA */
DMA_HandleTypeDef hdma_dac2; /**< Handle for DAC DMA */

/**
  * @brief Initializes the DMA controller
  * @param None
  * @retval None
  */
void MX_DMA_Init(void)
{
  /* Enable DMA controller clocks */
  __HAL_RCC_DMA1_CLK_ENABLE();
  __HAL_RCC_DMA2_CLK_ENABLE();

  /* Configure DMA interrupts */
  HAL_NVIC_SetPriority(DMA1_Stream6_IRQn, 0, 0); /**< Set priority for DMA1 Stream 6 interrupt */
  HAL_NVIC_EnableIRQ(DMA1_Stream6_IRQn); /**< Enable DMA1 Stream 6 interrupt */
  HAL_NVIC_SetPriority(DMA1_Stream7_IRQn, 0, 0); /**< Set priority for DMA1 Stream 7 interrupt */
  HAL_NVIC_EnableIRQ(DMA1_Stream7_IRQn); /**< Enable DMA1 Stream 7 interrupt */
  HAL_NVIC_SetPriority(DMA2_Stream0_IRQn, 0, 0); /**< Set priority for DMA2 Stream 0 interrupt */
  HAL_NVIC_EnableIRQ(DMA2_Stream0_IRQn); /**< Enable DMA2 Stream 0 interrupt */
}

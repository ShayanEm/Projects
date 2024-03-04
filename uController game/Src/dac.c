#include "dac.h"

/* DAC handle declaration */
DAC_HandleTypeDef hdac;

/* DAC DMA handle declaration */
DMA_HandleTypeDef hdma_dac2;

/**
  * @brief DAC initialization function
  * @param None
  * @retval None
  */
void MX_DAC_Init(void)
{
  DAC_ChannelConfTypeDef sConfig = {0};

  /* Initialize DAC instance */
  hdac.Instance = DAC;
  if (HAL_DAC_Init(&hdac) != HAL_OK)
  {
    Error_Handler();
  }

  /* Configure DAC channel */
  sConfig.DAC_Trigger = DAC_TRIGGER_T8_TRGO;
  sConfig.DAC_OutputBuffer = DAC_OUTPUTBUFFER_ENABLE;
  if (HAL_DAC_ConfigChannel(&hdac, &sConfig, DAC_CHANNEL_2) != HAL_OK)
  {
    Error_Handler();
  }
}

/**
  * @brief DAC MSP initialization function
  * @param dacHandle: DAC handle pointer
  * @retval None
  */
void HAL_DAC_MspInit(DAC_HandleTypeDef* dacHandle)
{
  GPIO_InitTypeDef GPIO_InitStruct = {0};
  
  if(dacHandle->Instance==DAC)
  {
    /* Enable DAC clock */
    __HAL_RCC_DAC_CLK_ENABLE();
    __HAL_RCC_GPIOA_CLK_ENABLE();

    /* Configure DAC GPIO */
    GPIO_InitStruct.Pin = GPIO_PIN_5;
    GPIO_InitStruct.Mode = GPIO_MODE_ANALOG;
    GPIO_InitStruct.Pull = GPIO_NOPULL;
    HAL_GPIO_Init(GPIOA, &GPIO_InitStruct);

    /* Configure DMA for DAC */
    hdma_dac2.Instance = DMA1_Stream6;
    hdma_dac2.Init.Channel = DMA_CHANNEL_7;
    hdma_dac2.Init.Direction = DMA_MEMORY_TO_PERIPH;
    hdma_dac2.Init.PeriphInc = DMA_PINC_DISABLE;
    hdma_dac2.Init.MemInc = DMA_MINC_ENABLE;
    hdma_dac2.Init.PeriphDataAlignment = DMA_PDATAALIGN_HALFWORD;
    hdma_dac2.Init.MemDataAlignment = DMA_MDATAALIGN_HALFWORD;
    hdma_dac2.Init.Mode = DMA_NORMAL;
    hdma_dac2.Init.Priority = DMA_PRIORITY_HIGH;
    hdma_dac2.Init.FIFOMode = DMA_FIFOMODE_DISABLE;
    if (HAL_DMA_Init(&hdma_dac2) != HAL_OK)
    {
      Error_Handler();
    }

    /* Link DMA handle to DAC handle */
    __HAL_LINKDMA(dacHandle,DMA_Handle2,hdma_dac2);
  }
}

/**
  * @brief DAC MSP de-initialization function
  * @param dacHandle: DAC handle pointer
  * @retval None
  */
void HAL_DAC_MspDeInit(DAC_HandleTypeDef* dacHandle)
{
  if(dacHandle->Instance==DAC)
  {
    /* Disable DAC clock */
    __HAL_RCC_DAC_CLK_DISABLE();

    /* De-initialize DAC GPIO */
    HAL_GPIO_DeInit(GPIOA, GPIO_PIN_5);

    /* De-initialize DMA for DAC */
    HAL_DMA_DeInit(dacHandle->DMA_Handle2);
  }
}

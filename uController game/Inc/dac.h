#ifndef __DAC_H__
#define __DAC_H__

#ifdef __cplusplus
extern "C" {
#endif

#include "main.h"

/**
  * @brief DAC handle declaration
  */
extern DAC_HandleTypeDef hdac;

/**
  * @brief Initializes the DAC peripheral.
  * @param None
  * @retval None
  */
void MX_DAC_Init(void);

#ifdef __cplusplus
}
#endif

#endif /* __DAC_H__ */

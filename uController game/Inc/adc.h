#ifndef __ADC_H__
#define __ADC_H__

#ifdef __cplusplus
extern "C" {
#endif

#include "main.h"

/**
  * @brief ADC handle declaration
  */
extern ADC_HandleTypeDef hadc1;

/**
  * @brief Function prototypes
  */
void MX_ADC1_Init(void);

#ifdef __cplusplus
}
#endif

#endif /* __ADC_H__ */

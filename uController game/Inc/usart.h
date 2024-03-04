#ifndef __USART_H__
#define __USART_H__

#ifdef __cplusplus
extern "C" {
#endif

#include "main.h"

/**
  * @brief UART handle declaration for UART5.
  */
extern UART_HandleTypeDef huart5;

/**
  * @brief UART handle declaration for USART2.
  */
extern UART_HandleTypeDef huart2;

void MX_UART5_Init(void);
void MX_USART2_UART_Init(void);

#ifdef __cplusplus
}
#endif

#endif /* __USART_H__ */

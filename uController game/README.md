# Project Overview:
Avatar Racing Game is a racing game developed for a microcontroller platform, specifically the STM32 series. The game utilizes various peripherals such as GPIO, DMA, USART, TIM, ADC, and DAC to create a basic gaming experience. Players control an avatar, represented by a graphical character, and navigate it through obstacles on the screen. The game features score tracking and increasing difficulty as the player progresses.

# Hardware Requirements
STM32 microcontroller board (e.g., STM32F4 Discovery)
Ultrasonic distance sensor (HC-SR04 or similar)
TFT LCD display
Miscellaneous components (resistors, capacitors, wires, etc.)

# Software Requirements
STM32CubeMX for project initialization and peripheral configuration.
STM32CubeIDE or any compatible IDE for firmware development.
MCUFRIEND library for TFT LCD display interface.
ARM CMSIS DSP library for signal processing.

# Features:
Avatar Control: Players can control the avatar using input commands, navigating it across the screen to avoid obstacles.
Obstacle Generation: Obstacles appear randomly on the screen, creating challenges for the player to overcome.
Score Tracking: The game tracks the player's score based on the time survived, providing a sense of progression and achievement.
Increasing Difficulty: As the game progresses, obstacles appear more frequently and move faster, increasing the challenge for the player.
Peripherals Used:
GPIO: Used for general-purpose input/output operations, such as controlling LEDs and receiving input from buttons.
DMA: Direct Memory Access is utilized for efficient data transfer between peripherals and memory.
USART: Universal Synchronous Asynchronous Receiver Transmitter for serial communication with other devices.
TIM: Timer modules are used for generating precise timing intervals and capturing external events.
ADC: Analog-to-Digital Converter for converting analog signals (such as sensor inputs) into digital values.
DAC: Digital-to-Analog Converter for generating analog output signals.

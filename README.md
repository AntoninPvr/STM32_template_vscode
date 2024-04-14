# Template for STM32CubeMX and PlatformIO

It allows to generate a PlatformIO project from STM32CubeMX configuration.
It is based on the [stm32pio](https://github.com/ussserrr/stm32pio) tool.
Change board in platformio.ini to your board.

## Working principle

It uses STM32CubeMX to generate a HAL library. Then it uses stm32pio to generate a PlatformIO project from the HAL library. It place generated file in `lib/cubemx/src` and `lib/cubemx/inc` directories. Original `main.c` is renamed `driver.c` in `lib/cubemx/src` directory.

Just include `driver.h` in `src/main.c` and you are ready to go.

## Setup

1. Change: `cubemx_cmd = "Path to STM32CubeMX.exe"` to the accoprding path to STM32CubeMX.exe

2. Change: `java_cmd = "Path to STM32CubeMX/jre/bin/java.exe"` to the accoprding path to java.exe

3. Change board in `platformio.ini` to your board.

4. You need stm32pio: 
    ```
    pip install stm32pio
    ```
    For more details about stm32pio follow: https://github.com/ussserrr/stm32pio

## Instructions

To update config open `stm_config.ioc` using STM32CubeMX.

In PlatformIO CLI run:
```
./update_config.sh
```

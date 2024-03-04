cmake_minimum_required(VERSION 3.27)
project(CSM_3980_HW6 LANGUAGES C CUDA)

set(CMAKE_C_STANDARD 99)

include_directories(.)

add_executable(CSM_3980_HW6
        Main.cu
        Main.cuh)

cmake_minimum_required(VERSION 3.16)
project(KavachCPP VERSION 1.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

find_package(Qt6 REQUIRED COMPONENTS Core Gui Qml Sql Network)

set(SOURCES 
    src/main.cpp 
    src/AuthDatabase.cpp 
    include/AuthDatabase.h 
    src/ScannerEngine.cpp 
    include/ScannerEngine.h
)

add_executable(KavachApp ${SOURCES})
target_link_libraries(KavachApp PRIVATE Qt6::Core Qt6::Gui Qt6::Qml Qt6::Sql Qt6::Network)

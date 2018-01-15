cmake_minimum_required(VERSION 2.8.12)

project(CoinView LANGUAGES CXX)

set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

find_package(Qt5 COMPONENTS Core Quick widgets REQUIRED)

add_executable(${PROJECT_NAME} MACOSX_BUNDLE "main.cpp" "qml.qrc" "Resources/Info.plist.in" "systemtrayicon.cpp" "systemtrayicon.h")

target_link_libraries(${PROJECT_NAME} Qt5::Core Qt5::Quick Qt5::Widgets)

if(APPLE)
	set_target_properties(${PROJECT_NAME} PROPERTIES MACOSX_BUNDLE_INFO_PLIST ${CMAKE_CURRENT_SOURCE_DIR}/Resources/Info.plist.in)
endif ()

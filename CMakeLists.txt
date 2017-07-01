# Simple TODO
project (com.github.licorna.simpletodo)

cmake_minimum_required (VERSION 2.6)

list (APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)
list (APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake/src)

set (DATADIR "${CMAKE_INSTALL_PREFIX}/share")

set (PKGDATADIR "${DATADIR}/com.github.licorna.simpletodo")

set (EXEC_NAME "com.github.licorna.simpletodo")
set (RELEASE_NAME "Simple TODO")
set (VERSION "0.2")
set (VERSION_INFO "Complex stuff")

find_package (PkgConfig)

set (SIMPLE_DEPS
  gtk+-3.0
  granite>=0.3.0)

pkg_check_modules(DEPS REQUIRED ${SIMPLE_DEPS})

add_definitions(${DEPS_CFLAGS})
link_libraries(${DEPS_LIBRARIES})
link_directories(${DEPS_LIBRARY_DIRS})

find_package(Vala REQUIRED)
include(ValaVersion)
ensure_vala_version("0.16" MINIMUM)

# Translation files
set (GETTEXT_PACKAGE "${CMAKE_PROJECT_NAME}")
add_definitions (-DGETTEXT_PACKAGE=\"${GETTEXT_PACKAGE}\")
add_subdirectory (po)

include(ValaPrecompile)
vala_precompile(VALA_C ${EXEC_NAME}
  src/Application.vala
  src/MainWindow.vala

  PACKAGES
  granite>=0.3.0)

add_executable(${EXEC_NAME} ${VALA_C})

install(TARGETS ${EXEC_NAME} RUNTIME DESTINATION bin)

install(FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/com.github.licorna.simpletodo.desktop DESTINATION ${DATADIR}/applications/)
install(FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/com.github.licorna.simpletodo.appdata.xml DESTINATION ${DATADIR}/metainfo/)

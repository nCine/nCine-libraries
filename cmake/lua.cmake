set(TARGET_LUA lua)
set(URL_LUA https://www.lua.org/ftp/lua-5.3.5.tar.gz)
set(URL_MD5_LUA 4f4b4f323fd3514a68e0ab3da8ce3455)
set(LIBNAME_LUA lua)
set(PROJECT_SRC_LUA ${EP_BASE}/Source/project_${TARGET_LUA})
set(PROJECT_BUILD_LUA ${EP_BASE}/Build/project_${TARGET_LUA})

if(MSVC)
	ExternalProject_Add(project_${TARGET_LUA}
		URL ${URL_LUA}
		URL_MD5 ${URL_MD5_LUA}
		PATCH_COMMAND ${CMAKE_COMMAND} -E copy_if_different ${CMAKE_SOURCE_DIR}/patches/CMakeLists_lua.txt ${PROJECT_SRC_LUA}/CMakeLists.txt
		CMAKE_ARGS -DCMAKE_BUILD_TYPE=${CONFIGURATION}
		BUILD_IN_SOURCE 0
		INSTALL_COMMAND ${CMAKE_COMMAND} -E copy_if_different ${PROJECT_BUILD_LUA}/${CONFIGURATION}/lua53.dll ${BINDIR}/
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${PROJECT_BUILD_LUA}/${CONFIGURATION}/lua53.lib ${LIBDIR}/
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${PROJECT_BUILD_LUA}/${CONFIGURATION}/lua.lib ${LIBDIR}/
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${PROJECT_BUILD_LUA}/${CONFIGURATION}/lua.exe ${BINDIR}/
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${PROJECT_BUILD_LUA}/${CONFIGURATION}/luac.exe ${BINDIR}/
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${PROJECT_SRC_LUA}/src/lua.h ${INCDIR}/
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${PROJECT_SRC_LUA}/src/luaconf.h ${INCDIR}/
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${PROJECT_SRC_LUA}/src/lualib.h ${INCDIR}/
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${PROJECT_SRC_LUA}/src/lauxlib.h ${INCDIR}/
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${PROJECT_SRC_LUA}/src/lua.hpp ${INCDIR}/
	)
elseif(APPLE)
	set(FRAMEWORK_DIR_LUA ${DESTINATION_PATH}/${TARGET_LUA}.framework)
	set(DYLIBNAME_LUA liblua5.3.dylib)

	ExternalProject_Add(project_${TARGET_LUA}
		URL ${URL_LUA}
		URL_MD5 ${URL_MD5_LUA}
		PATCH_COMMAND ${CMAKE_COMMAND} -E copy_if_different ${CMAKE_SOURCE_DIR}/patches/CMakeLists_lua.txt ${PROJECT_SRC_LUA}/CMakeLists.txt
		CMAKE_ARGS -DCMAKE_BUILD_TYPE=${CONFIGURATION}
		BUILD_IN_SOURCE 0
		INSTALL_COMMAND ${CMAKE_COMMAND} -E make_directory ${FRAMEWORK_DIR_LUA}/Versions/A
			COMMAND ${CMAKE_COMMAND} -E create_symlink A ${FRAMEWORK_DIR_LUA}/Versions/Current
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${PROJECT_BUILD_LUA}/${DYLIBNAME_LUA} ${FRAMEWORK_DIR_LUA}/Versions/A/
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${PROJECT_BUILD_LUA}/liblua.a ${FRAMEWORK_DIR_LUA}/Versions/A/
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${PROJECT_BUILD_LUA}/lua ${FRAMEWORK_DIR_LUA}/Versions/A/
			COMMAND install_name_tool -change "${PROJECT_BUILD_LUA}/${DYLIBNAME_LUA}" "${DYLIBNAME_LUA}" ${FRAMEWORK_DIR_LUA}/Versions/A/lua
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${PROJECT_BUILD_LUA}/luac ${FRAMEWORK_DIR_LUA}/Versions/A/
			COMMAND install_name_tool -change "${PROJECT_BUILD_LUA}/${DYLIBNAME_LUA}" "${DYLIBNAME_LUA}" ${FRAMEWORK_DIR_LUA}/Versions/A/luac
			COMMAND ${CMAKE_COMMAND} -E create_symlink Versions/Current/${DYLIBNAME_LUA} ${FRAMEWORK_DIR_LUA}/${TARGET_LUA}
			COMMAND install_name_tool -id "@rpath/${TARGET_LUA}.framework/${TARGET_LUA}" ${FRAMEWORK_DIR_LUA}/${TARGET_LUA}
			COMMAND ${CMAKE_COMMAND} -E make_directory ${FRAMEWORK_DIR_LUA}/Versions/A/Headers/
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${PROJECT_SRC_LUA}/src/lua.h ${FRAMEWORK_DIR_LUA}/Versions/A/Headers/
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${PROJECT_SRC_LUA}/src/luaconf.h ${FRAMEWORK_DIR_LUA}/Versions/A/Headers/
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${PROJECT_SRC_LUA}/src/lualib.h ${FRAMEWORK_DIR_LUA}/Versions/A/Headers/
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${PROJECT_SRC_LUA}/src/lauxlib.h ${FRAMEWORK_DIR_LUA}/Versions/A/Headers/
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${PROJECT_SRC_LUA}/src/lua.hpp ${FRAMEWORK_DIR_LUA}/Versions/A/Headers/
			COMMAND ${CMAKE_COMMAND} -E create_symlink Versions/Current/Headers ${FRAMEWORK_DIR_LUA}/Headers
	)
elseif(EMSCRIPTEN)
	ExternalProject_Add(project_${TARGET_LUA}
		URL ${URL_LUA}
		URL_MD5 ${URL_MD5_LUA}
		PATCH_COMMAND ${CMAKE_COMMAND} -E copy_if_different ${CMAKE_SOURCE_DIR}/patches/CMakeLists_lua.txt ${PROJECT_SRC_LUA}/CMakeLists.txt
		CMAKE_COMMAND emcmake ${CMAKE_COMMAND} -G ${CMAKE_GENERATOR}
		CMAKE_ARGS -DCMAKE_BUILD_TYPE=${CONFIGURATION}
		BUILD_IN_SOURCE 0
		INSTALL_COMMAND COMMAND ${CMAKE_COMMAND} -E copy_if_different ${PROJECT_BUILD_LUA}/liblua.a ${DESTINATION_PATH}/lib/liblua.a
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${PROJECT_BUILD_LUA}/lua.js ${DESTINATION_PATH}/bin/lua.js
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${PROJECT_BUILD_LUA}/lua.wasm ${DESTINATION_PATH}/bin/lua.wasm
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${PROJECT_BUILD_LUA}/luac.js ${DESTINATION_PATH}/bin/luac.js
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${PROJECT_BUILD_LUA}/luac.wasm ${DESTINATION_PATH}/bin/luac.wasm
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${PROJECT_SRC_LUA}/src/lua.h ${DESTINATION_PATH}/include/lua.h
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${PROJECT_SRC_LUA}/src/luaconf.h ${DESTINATION_PATH}/include/luaconf.h
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${PROJECT_SRC_LUA}/src/lualib.h ${DESTINATION_PATH}/include/lualib.h
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${PROJECT_SRC_LUA}/src/lauxlib.h ${DESTINATION_PATH}/include/lauxlib.h
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${PROJECT_SRC_LUA}/src/lua.hpp ${DESTINATION_PATH}/include/lua.hpp
	)
else()
	ExternalProject_Add(project_${TARGET_LUA}
		URL ${URL_LUA}
		URL_MD5 ${URL_MD5_LUA}
		PATCH_COMMAND ${CMAKE_COMMAND} -E copy_if_different ${CMAKE_SOURCE_DIR}/patches/CMakeLists_lua.txt ${PROJECT_SRC_LUA}/CMakeLists.txt
		CMAKE_ARGS -DCMAKE_BUILD_TYPE=${CONFIGURATION}
		BUILD_IN_SOURCE 0
		INSTALL_COMMAND ${CMAKE_COMMAND} -E copy_if_different ${PROJECT_BUILD_LUA}/liblua5.3.so ${DESTINATION_PATH}/lib/liblua5.3.so
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${PROJECT_BUILD_LUA}/liblua.a ${DESTINATION_PATH}/lib/liblua.a
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${PROJECT_BUILD_LUA}/lua ${DESTINATION_PATH}/bin/lua
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${PROJECT_BUILD_LUA}/luac ${DESTINATION_PATH}/bin/luac
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${PROJECT_SRC_LUA}/src/lua.h ${DESTINATION_PATH}/include/lua.h
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${PROJECT_SRC_LUA}/src/luaconf.h ${DESTINATION_PATH}/include/luaconf.h
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${PROJECT_SRC_LUA}/src/lualib.h ${DESTINATION_PATH}/include/lualib.h
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${PROJECT_SRC_LUA}/src/lauxlib.h ${DESTINATION_PATH}/include/lauxlib.h
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${PROJECT_SRC_LUA}/src/lua.hpp ${DESTINATION_PATH}/include/lua.hpp
	)
endif()

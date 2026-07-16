set(TARGET_SDL3 sdl3)
set(URL_SDL3 https://github.com/libsdl-org/SDL/archive/refs/tags/release-3.4.12.tar.gz)
set(URL_MD5_SDL3 30e75c2ca6fe03dfcac8fc6d0b4b6f13)
set(LIBNAME_SDL3 SDL3)
set(COMMON_CMAKE_ARGS_SDL3 -DSDL_AUDIO=OFF -DSDL_CAMERA=OFF -DSDL_DUMMYVIDEO=OFF -DSDL_EXAMPLES=OFF -DSDL_OFFSCREEN=OFF -DSDL_POWER=OFF -DSDL_RENDER=OFF -DSDL_SENSOR=OFF -DSDL_TESTS=OFF)

if(MSVC)
	if(CMAKE_BUILD_TYPE STREQUAL "Debug")
		set(LIBNAME_SDL3 SDL3d)
	endif()

	if(MSVC_IDE)
		set(LIBFILE_SDL3_DLL ${CMAKE_BUILD_TYPE}/${LIBNAME_SDL3}.dll)
		set(LIBFILE_SDL3_IMPLIB ${CMAKE_BUILD_TYPE}/${LIBNAME_SDL3}.lib)
	else()
		set(LIBFILE_SDL3_DLL ${LIBNAME_SDL3}.dll)
		set(LIBFILE_SDL3_IMPLIB ${LIBNAME_SDL3}.lib)
	endif()

	ExternalProject_Add(project_${TARGET_SDL3}
		URL ${URL_SDL3}
		URL_MD5 ${URL_MD5_SDL3}
		CMAKE_ARGS -DSDL_STATIC=OFF ${COMMON_CMAKE_ARGS_SDL3} -DSDL_DIRECTX=OFF
		BUILD_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE} --parallel
		BUILD_IN_SOURCE 0
		INSTALL_COMMAND ${CMAKE_COMMAND} -E copy_if_different ${LIBFILE_SDL3_DLL} ${BINDIR}/
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${LIBFILE_SDL3_IMPLIB} ${LIBDIR}/
			COMMAND ${CMAKE_COMMAND} -E copy_directory ${EP_BASE}/Source/project_${TARGET_SDL3}/include/SDL3 ${INCDIR}/SDL3
			COMMAND ${CMAKE_COMMAND} -E copy_if_different include-config-$<LOWER_CASE:$<CONFIG>>/build_config/SDL_build_config.h ${INCDIR}/SDL3/
			COMMAND ${CMAKE_COMMAND} -E copy_if_different include-revision/SDL3/SDL_revision.h ${INCDIR}/SDL3/
	)
elseif(APPLE)
	set(FRAMEWORK_DIR_SDL3 ${DESTINATION_PATH}/${TARGET_SDL3}.framework)
	set(DYLIBNAME_SDL3 libSDL3.0.dylib)

	ExternalProject_Add(project_${TARGET_SDL3}
		URL ${URL_SDL3}
		URL_MD5 ${URL_MD5_SDL3}
		CMAKE_ARGS -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} ${COMMON_CMAKE_ARGS_SDL3}
		BUILD_COMMAND ${CMAKE_COMMAND} --build . --parallel
		BUILD_IN_SOURCE 0
		INSTALL_COMMAND ${CMAKE_COMMAND} -E make_directory ${FRAMEWORK_DIR_SDL3}/Versions/A
			COMMAND ${CMAKE_COMMAND} -E create_symlink A ${FRAMEWORK_DIR_SDL3}/Versions/Current
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${DYLIBNAME_SDL3} ${FRAMEWORK_DIR_SDL3}/Versions/A/
			COMMAND ${CMAKE_COMMAND} -E create_symlink Versions/Current/${DYLIBNAME_SDL3} ${FRAMEWORK_DIR_SDL3}/${TARGET_SDL3}
			COMMAND install_name_tool -id "@rpath/${TARGET_SDL3}.framework/${TARGET_SDL3}" ${FRAMEWORK_DIR_SDL3}/${TARGET_SDL3}
			COMMAND ${CMAKE_COMMAND} -E make_directory ${FRAMEWORK_DIR_SDL3}/Versions/A/Headers/
			COMMAND ${CMAKE_COMMAND} -E copy_directory ${EP_BASE}/Source/project_${TARGET_SDL3}/include/SDL3 ${FRAMEWORK_DIR_SDL3}/Versions/A/Headers/
			COMMAND ${CMAKE_COMMAND} -E copy_if_different include-config-$<LOWER_CASE:$<CONFIG>>/build_config/SDL_build_config.h ${FRAMEWORK_DIR_SDL3}/Versions/A/Headers/
			COMMAND ${CMAKE_COMMAND} -E copy_if_different include-revision/SDL3/SDL_revision.h ${FRAMEWORK_DIR_SDL3}/Versions/A/Headers/
			COMMAND ${CMAKE_COMMAND} -E create_symlink Versions/Current/Headers ${FRAMEWORK_DIR_SDL3}/Headers
			COMMAND ${CMAKE_COMMAND} -E make_directory ${FRAMEWORK_DIR_SDL3}/Versions/A/Resources
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${EP_BASE}/Source/project_${TARGET_SDL3}/Xcode/SDL/Info-Framework.plist ${FRAMEWORK_DIR_SDL3}/Versions/A/Resources/Info.plist
			COMMAND ${CMAKE_COMMAND} -E create_symlink Versions/Current/Resources ${FRAMEWORK_DIR_SDL3}/Resources
	)
elseif(NOT EMSCRIPTEN)
	if(MINGW)
		list(APPEND COMMON_CMAKE_ARGS_SDL3 -DSDL_DIRECTX=OFF -DSDL_OPENGLES=OFF)
	else()
		list(APPEND COMMON_CMAKE_ARGS_SDL3 -DSDL_X11_XSCRNSAVER=OFF -DSDL_X11_XTEST=OFF)
	endif()

	ExternalProject_Add(project_${TARGET_SDL3}
		URL ${URL_SDL3}
		URL_MD5 ${URL_MD5_SDL3}
		CMAKE_ARGS -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} ${COMMON_CMAKE_ARGS_SDL3} -DCMAKE_INSTALL_PREFIX=${DESTINATION_PATH}
		BUILD_COMMAND ${CMAKE_COMMAND} --build . --parallel
		BUILD_IN_SOURCE 0
		INSTALL_COMMAND make install
	)
endif()

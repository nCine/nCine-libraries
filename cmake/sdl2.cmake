set(TARGET_SDL2 sdl2)
set(URL_SDL2 https://www.libsdl.org/release/SDL2-2.0.10.tar.gz)
set(URL_MD5_SDL2 5a2114f2a6f348bdab5bf52b994811db)
set(LIBNAME_SDL2 SDL2)
set(LIBNAME_SDL2MAIN SDL2main)

if(MSVC)
	if(MSVC_IDE)
		set(LIBFILE_SDL2_DLL ${CONFIGURATION}/${LIBNAME_SDL2}.dll)
		set(LIBFILE_SDL2_IMPLIB ${CONFIGURATION}/${LIBNAME_SDL2}.lib)
		set(LIBFILE_SDL2MAIN ${CONFIGURATION}/${LIBNAME_SDL2MAIN}.lib)
	else()
		set(LIBFILE_SDL2_DLL ${LIBNAME_SDL2}.dll)
		set(LIBFILE_SDL2_IMPLIB ${LIBNAME_SDL2}.lib)
		set(LIBFILE_SDL2MAIN ${LIBNAME_SDL2MAIN}.lib)
	endif()

	ExternalProject_Add(project_${TARGET_SDL2}
		URL ${URL_SDL2}
		URL_MD5 ${URL_MD5_SDL2}
		CMAKE_ARGS -DCMAKE_BUILD_TYPE=${CONFIGURATION} -DSDL_STATIC=OFF
		BUILD_IN_SOURCE 0
		INSTALL_COMMAND ${CMAKE_COMMAND} -E copy_if_different ${LIBFILE_SDL2_DLL} ${BINDIR}/
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${LIBFILE_SDL2_IMPLIB} ${LIBDIR}/
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${LIBFILE_SDL2MAIN} ${LIBDIR}/
			COMMAND ${CMAKE_COMMAND} -E copy_directory ${EP_BASE}/Source/project_${TARGET_SDL2}/include ${INCDIR}/SDL2
			COMMAND ${CMAKE_COMMAND} -E copy_if_different include/SDL_config.h ${INCDIR}/SDL2/
			COMMAND ${CMAKE_COMMAND} -E remove ${INCDIR}/SDL2/SDL_config.h.cmake
			COMMAND ${CMAKE_COMMAND} -E remove ${INCDIR}/SDL2/SDL_config.h.in
	)
elseif(APPLE)
	set(FRAMEWORK_DIR_SDL2 ${DESTINATION_PATH}/${TARGET_SDL2}.framework)
	set(DYLIBNAME_SDL2 libSDL2-2.0.dylib)

	ExternalProject_Add(project_${TARGET_SDL2}
		URL ${URL_SDL2}
		URL_MD5 ${URL_MD5_SDL2}
		CMAKE_ARGS -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
		BUILD_IN_SOURCE 0
		INSTALL_COMMAND ${CMAKE_COMMAND} -E make_directory ${FRAMEWORK_DIR_SDL2}/Versions/A
			COMMAND ${CMAKE_COMMAND} -E create_symlink A ${FRAMEWORK_DIR_SDL2}/Versions/Current
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${DYLIBNAME_SDL2} ${FRAMEWORK_DIR_SDL2}/Versions/A/
			COMMAND ${CMAKE_COMMAND} -E copy_if_different libSDL2main.a ${FRAMEWORK_DIR_SDL2}/Versions/A/
			COMMAND ${CMAKE_COMMAND} -E copy_if_different libSDL2.a ${FRAMEWORK_DIR_SDL2}/Versions/A/
			COMMAND ${CMAKE_COMMAND} -E create_symlink Versions/Current/${DYLIBNAME_SDL2} ${FRAMEWORK_DIR_SDL2}/${TARGET_SDL2}
			COMMAND install_name_tool -id "@rpath/${TARGET_SDL2}.framework/${TARGET_SDL2}" ${FRAMEWORK_DIR_SDL2}/${TARGET_SDL2}
			COMMAND ${CMAKE_COMMAND} -E make_directory ${FRAMEWORK_DIR_SDL2}/Versions/A/Headers/
			COMMAND ${CMAKE_COMMAND} -E copy_directory ${EP_BASE}/Source/project_${TARGET_SDL2}/include ${FRAMEWORK_DIR_SDL2}/Versions/A/Headers
			COMMAND ${CMAKE_COMMAND} -E copy_if_different include/SDL_config.h ${FRAMEWORK_DIR_SDL2}/Versions/A/Headers
			COMMAND ${CMAKE_COMMAND} -E remove ${FRAMEWORK_DIR_SDL2}/Versions/A/Headers/SDL_config.h.cmake
			COMMAND ${CMAKE_COMMAND} -E remove ${FRAMEWORK_DIR_SDL2}/Versions/A/Headers/SDL_config.h.in
			COMMAND ${CMAKE_COMMAND} -E create_symlink Versions/Current/Headers ${FRAMEWORK_DIR_SDL2}/Headers
			COMMAND ${CMAKE_COMMAND} -E make_directory ${FRAMEWORK_DIR_SDL2}/Versions/A/Resources
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${EP_BASE}/Source/project_${TARGET_SDL2}/Xcode/SDL/Info-Framework.plist ${FRAMEWORK_DIR_SDL2}/Versions/A/Resources/Info.plist
			COMMAND ${CMAKE_COMMAND} -E create_symlink Versions/Current/Resources ${FRAMEWORK_DIR_SDL2}/Resources
	)
elseif(NOT EMSCRIPTEN)
	ExternalProject_Add(project_${TARGET_SDL2}
		URL ${URL_SDL2}
		URL_MD5 ${URL_MD5_SDL2}
		CMAKE_ARGS -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} -DCMAKE_INSTALL_PREFIX=${DESTINATION_PATH}
		BUILD_IN_SOURCE 0
		INSTALL_COMMAND make install
	)
endif()

set(TARGET_SDL sdl)
set(URL_SDL http://www.libsdl.org/release/SDL-1.2.15.tar.gz)
set(URL_MD5_SDL 9d96df8417572a2afb781a7c4c811a85)
set(LIBNAME_SDL SDL)
set(LIBNAME_SDLMAIN SDLmain)

if(MSVC)
	set(LIBFILE_SDL ${EP_BASE}/Source/project_${TARGET_SDL}/VisualC/SDL/${CONFIGURATION}/${LIBNAME_SDL}.dll)
	set(LIBFILE_SDL_LIBDYN ${EP_BASE}/Source/project_${TARGET_SDL}/VisualC/SDL/${PLATFORM}/${CONFIGURATION}/${LIBNAME_SDL}.lib) # for dynamic linking
	set(LIBFILE_SDLMAIN ${EP_BASE}/Source/project_${TARGET_SDL}/VisualC/SDLmain/${PLATFORM}/${CONFIGURATION}/${LIBNAME_SDLMAIN}.lib)

	ExternalProject_Add(project_${TARGET_SDL}
		URL ${URL_SDL}
		URL_MD5 ${URL_MD5_SDL}
		CONFIGURE_COMMAND devenv VisualC/SDL.sln /Upgrade
		BUILD_COMMAND msbuild VisualC/SDL/SDL.vcxproj /t:Build /p:Configuration=${CONFIGURATION} /p:Platform=${PLATFORM}
			COMMAND msbuild VisualC/SDLmain/SDLmain.vcxproj /t:Build /p:Configuration=${CONFIGURATION} /p:Platform=${PLATFORM}
		BUILD_IN_SOURCE 1
		INSTALL_COMMAND ${CMAKE_COMMAND} -E copy_if_different ${LIBFILE_SDL} ${BINDIR}/
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${LIBFILE_SDL_LIBDYN} ${LIBDIR}/
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${LIBFILE_SDLMAIN} ${LIBDIR}/
			COMMAND ${CMAKE_COMMAND} -E copy_directory include ${INCDIR}/SDL
			COMMAND ${CMAKE_COMMAND} -E remove ${INCDIR}/SDL/doxyfile
			COMMAND ${CMAKE_COMMAND} -E remove ${INCDIR}/SDL/SDL_config.h.default
			COMMAND ${CMAKE_COMMAND} -E remove ${INCDIR}/SDL/SDL_config.h.in
	)
elseif(APPLE)
	return() # SDL 1.2.15 doesn't compile on OS X 10.9 and later

	set(FRAMEWORK_DIR_SDL ${DESTINATION_PATH}/${TARGET_SDL}.framework)
	set(DYLIBNAME_SDL libsdl.1.2.15.dylib)

	ExternalProject_Add(project_${TARGET_SDL}
		URL ${URL_SDL}
		URL_MD5 ${URL_MD5_SDL}
		CONFIGURE_COMMAND ./configure --without-x --prefix=
		BUILD_COMMAND ${PARALLEL_MAKE}
		BUILD_IN_SOURCE 1
		INSTALL_COMMAND ${CMAKE_COMMAND} -E make_directory ${FRAMEWORK_DIR_SDL}/Versions/A
			COMMAND ${CMAKE_COMMAND} -E create_symlink A ${FRAMEWORK_DIR_SDL}/Versions/Current
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${DYLIBNAME_SDL} ${FRAMEWORK_DIR_SDL}/Versions/A/
			COMMAND ${CMAKE_COMMAND} -E create_symlink Versions/Current/${DYLIBNAME_SDL} ${FRAMEWORK_DIR_SDL}/${TARGET_SDL}
			COMMAND ${CMAKE_COMMAND} -E make_directory ${FRAMEWORK_DIR_SDL}/Versions/A/Headers/
			COMMAND ${CMAKE_COMMAND} -E copy_directory include ${FRAMEWORK_DIR_SDL}/Versions/A/Headers
			COMMAND ${CMAKE_COMMAND} -E remove ${FRAMEWORK_DIR_SDL}/Versions/A/Headers/doxyfile
			COMMAND ${CMAKE_COMMAND} -E remove ${FRAMEWORK_DIR_SDL}/Versions/A/Headers/SDL_config.h.default
			COMMAND ${CMAKE_COMMAND} -E remove ${FRAMEWORK_DIR_SDL}/Versions/A/Headers/SDL_config.h.in
			COMMAND ${CMAKE_COMMAND} -E create_symlink Versions/Current/Headers ${FRAMEWORK_DIR_SDL}/Headers
			COMMAND ${CMAKE_COMMAND} -E make_directory ${FRAMEWORK_DIR_VORBIS}/Versions/A/Resource
			COMMAND ${CMAKE_COMMAND} -E copy_if_different Xcode/SDL/Info-Framework.plist ${FRAMEWORK_DIR_VORBIS}/Versions/A/Resources/Info.plist
			COMMAND ${CMAKE_COMMAND} -E create_symlink Versions/Current/Resources ${FRAMEWORK_DIR_VORBIS}/Resources
	)
else()
	ExternalProject_Add(project_${TARGET_SDL}
		URL ${URL_SDL}
		URL_MD5 ${URL_MD5_SDL}
		CONFIGURE_COMMAND ./configure --prefix=
		BUILD_COMMAND ${PARALLEL_MAKE}
		BUILD_IN_SOURCE 1
		INSTALL_COMMAND make DESTDIR=${DESTINATION_PATH} install
	)
endif()

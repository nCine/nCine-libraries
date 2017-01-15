if(NOT DEFINED TARGET_SDL)
	message(FATAL_ERROR "TARGET_SDL is not defined")
endif()

set(TARGET_SDLIMAGE sdl_image)
set(URL_SDLIMAGE http://www.libsdl.org/projects/SDL_image/release/SDL_image-1.2.12.tar.gz)
set(URL_MD5_SDLIMAGE a0f9098ebe5400f0bdc9b62e60797ecb)
set(LIBNAME_SDLIMAGE SDL_image)

if(MSVC)
	set(INCLUDEDIR_SDL ${EP_BASE}/Source/project_${TARGET_SDL}/include)
	set(LIBFILE_SDLIMAGE_NOEXT ${EP_BASE}/Source/project_${TARGET_SDLIMAGE}/VisualC/${PLATFORM}/${CONFIGURATION}/${LIBNAME_SDLIMAGE})

	get_filename_component(LIBDIR_SDL ${LIBFILE_SDL_LIBDYN} DIRECTORY)
	ExternalProject_Add(project_${TARGET_SDLIMAGE}
		DEPENDS project_${TARGET_SDL} project_${TARGET_PNG}
		URL ${URL_SDLIMAGE}
		URL_MD5 ${URL_MD5_SDLIMAGE}
		CONFIGURE_COMMAND devenv VisualC/SDL_image.sln /Upgrade
		BUILD_COMMAND set CL=/I${INCLUDEDIR_SDL} COMMAND set LINK=/LIBPATH:${LIBDIR_SDL}
			COMMAND msbuild VisualC/SDL_image.vcxproj /t:Build /p:Configuration=${CONFIGURATION} /p:Platform=${PLATFORM}
		BUILD_IN_SOURCE 1
		INSTALL_COMMAND ${CMAKE_COMMAND} -E copy_if_different ${LIBFILE_SDLIMAGE_NOEXT}.dll ${BINDIR}/
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${LIBFILE_SDLIMAGE_NOEXT}.lib ${LIBDIR}/
			COMMAND ${CMAKE_COMMAND} -E copy_if_different SDL_image.h ${INCDIR}/SDL
	)
elseif(NOT APPLE) # SDL 1.2.15 doesn't compile on Os X 10.9 and later	
	ExternalProject_Add(project_${TARGET_SDLIMAGE}
		DEPENDS project_${TARGET_SDL} project_${TARGET_PNG}
		URL ${URL_SDLIMAGE}
		URL_MD5 ${URL_MD5_SDLIMAGE}
		CONFIGURE_COMMAND ./configure --prefix=
		BUILD_COMMAND ${PARALLEL_MAKE}
		BUILD_IN_SOURCE 1
		INSTALL_COMMAND make DESTDIR=${DESTINATION_PATH} install
	)
endif()

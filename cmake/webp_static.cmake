set(TARGET_WEBP_STATIC webp_static)

if(MSVC)
	set(LIBNAME_WEBP_LIB libwebp) # for static linking

	set(CONFIG_WEBP release-static)
	if(CMAKE_BUILD_TYPE STREQUAL "Debug")
		set(CONFIG_WEBP debug-static)
	endif()
	set(OBJDIR_WEBP ${EP_BASE}/Source/project_${TARGET_WEBP}/${CONFIG_WEBP}/${PLATFORM})

	ExternalProject_Add(project_${TARGET_WEBP_STATIC}
		DEPENDS project_${TARGET_WEBP}
		DOWNLOAD_COMMAND ""
		SOURCE_DIR ${EP_BASE}/Source/project_${TARGET_WEBP}
		CONFIGURE_COMMAND ""
		BUILD_COMMAND nmake /f Makefile.vc ARCH=${ARCH_WEBP} CFG=${CONFIG_WEBP} OBJDIR=.
		BUILD_IN_SOURCE 1
		INSTALL_COMMAND ${CMAKE_COMMAND} -E copy_if_different ${OBJDIR_WEBP}/lib/${LIBNAME_WEBP}.lib ${LIBDIR}/
	)
# Supporting only frameworks on OS X
elseif(NOT APPLE AND NOT EMSCRIPTEN)
	ExternalProject_Add(project_${TARGET_WEBP_STATIC}
		DEPENDS project_${TARGET_WEBP}
		DOWNLOAD_COMMAND ""
		SOURCE_DIR ${EP_BASE}/Source/project_${TARGET_WEBP}
		CONFIGURE_COMMAND ./configure --enable-shared=no --enable-static=yes --prefix=${DESTINATION_PATH} --exec-prefix=${DESTINATION_PATH}
		BUILD_COMMAND make
		BUILD_IN_SOURCE 1
		INSTALL_COMMAND make install
	)
endif()

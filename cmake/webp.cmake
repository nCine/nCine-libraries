set(TARGET_WEBP webp)
set(URL_WEBP http://downloads.webmproject.org/releases/webp/libwebp-0.6.0.tar.gz)
set(URL_MD5_WEBP 19a6e926ab1721268df03161b84bb4a0)
set(LIBNAME_WEBP libwebp)
set(LIBNAME_WEBPDECODER libwebpdecoder)
set(LIBNAME_WEBP_LIBDYN libwebp_dll) # for dynamic linking
set(LIBNAME_WEBPDECODER_LIBDYN libwebpdecoder_dll) # for dynamic linking

if(MSVC)
	set(CONFIG_WEBP release-dynamic)
	if(CMAKE_BUILD_TYPE STREQUAL "Debug")
		set(CONFIG_WEBP debug-dynamic)
		set(LIBNAME_WEBP libwebp_debug)
		set(LIBNAME_WEBPDECODER libwebpdecoder_debug)
		set(LIBNAME_WEBP_LIBDYN libwebp_debug_dll)
		set(LIBNAME_WEBPDECODER_LIBDYN libwebpdecoder_debug_dll)
	endif()
	set(OBJDIR_WEBP ${EP_BASE}/Source/project_${TARGET_WEBP}/${CONFIG_WEBP}/${PLATFORM})

	ExternalProject_Add(project_${TARGET_WEBP}
		URL ${URL_WEBP}
		URL_MD5 ${URL_MD5_WEBP}
		CONFIGURE_COMMAND ""
		BUILD_COMMAND nmake /f Makefile.vc CFG=${CONFIG_WEBP} OBJDIR=.
		BUILD_IN_SOURCE 1
		INSTALL_COMMAND ${CMAKE_COMMAND} -E copy_if_different ${OBJDIR_WEBP}/bin/${LIBNAME_WEBP}.dll ${BINDIR}/
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${OBJDIR_WEBP}/bin/${LIBNAME_WEBPDECODER}.dll ${BINDIR}/
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${OBJDIR_WEBP}/lib/${LIBNAME_WEBP_LIBDYN}.lib ${LIBDIR}/
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${OBJDIR_WEBP}/lib/${LIBNAME_WEBPDECODER_LIBDYN}.lib ${LIBDIR}/
			COMMAND ${CMAKE_COMMAND} -E copy_directory src/webp ${INCDIR}/webp
			COMMAND ${CMAKE_COMMAND} -E remove ${INCDIR}/webp/config.h.in
	)
elseif(APPLE)
	set(FRAMEWORK_DIR_WEBP ${DESTINATION_PATH}/${TARGET_WEBP}.framework)
	set(DYLIBNAME_WEBP libwebp.7.dylib)

	ExternalProject_Add(project_${TARGET_WEBP}
		URL ${URL_WEBP}
		URL_MD5 ${URL_MD5_WEBP}
		CONFIGURE_COMMAND ./configure --enable-shared=yes --enable-static=no --prefix=
		BUILD_COMMAND ${PARALLEL_MAKE}
		BUILD_IN_SOURCE 1
		INSTALL_COMMAND ${CMAKE_COMMAND} -E make_directory ${FRAMEWORK_DIR_WEBP}/Versions/A
			COMMAND ${CMAKE_COMMAND} -E create_symlink A ${FRAMEWORK_DIR_WEBP}/Versions/Current
			COMMAND ${CMAKE_COMMAND} -E copy_if_different src/.libs/${DYLIBNAME_WEBP} ${FRAMEWORK_DIR_WEBP}/Versions/A/
			COMMAND ${CMAKE_COMMAND} -E create_symlink Versions/Current/${DYLIBNAME_WEBP} ${FRAMEWORK_DIR_WEBP}/${TARGET_WEBP}
			COMMAND install_name_tool -id "@rpath/${TARGET_WEBP}.framework/${TARGET_WEBP}" ${FRAMEWORK_DIR_WEBP}/${TARGET_WEBP}
			COMMAND ${CMAKE_COMMAND} -E copy_directory src/webp ${FRAMEWORK_DIR_WEBP}/Versions/A/Headers/
			COMMAND ${CMAKE_COMMAND} -E remove ${FRAMEWORK_DIR_WEBP}/Versions/A/Headers/config.h.in
			COMMAND ${CMAKE_COMMAND} -E create_symlink Versions/Current/Headers ${FRAMEWORK_DIR_WEBP}/Headers
	)
else()
	ExternalProject_Add(project_${TARGET_WEBP}
		URL ${URL_WEBP}
		URL_MD5 ${URL_MD5_WEBP}
		CONFIGURE_COMMAND ./configure --enable-shared=yes --enable-static=no --prefix=
		BUILD_COMMAND ${PARALLEL_MAKE}
		BUILD_IN_SOURCE 1
		INSTALL_COMMAND make DESTDIR=${DESTINATION_PATH} install
	)
endif()

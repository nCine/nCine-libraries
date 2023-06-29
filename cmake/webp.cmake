set(TARGET_WEBP webp)
set(URL_WEBP http://downloads.webmproject.org/releases/webp/libwebp-1.3.1.tar.gz)
set(URL_MD5_WEBP 0ff59e5598753f47519e3e61c12f8cfd)
set(LIBNAME_WEBP libwebp)
set(LIBNAME_SHARPYUV libsharpyuv)
set(LIBNAME_WEBPDECODER libwebpdecoder)
set(LIBNAME_WEBP_IMPLIB libwebp_dll) # for dynamic linking
set(LIBNAME_SHARPYUV_IMPLIB libsharpyuv_dll) # for dynamic linking
set(LIBNAME_WEBPDECODER_IMPLIB libwebpdecoder_dll) # for dynamic linking
set(PROJECT_SRC_WEBP ${EP_BASE}/Source/project_${TARGET_WEBP})

if(MSVC)
	if(CMAKE_CL_64)
		set(ARCH_WEBP "x64")
	else()
		set(ARCH_WEBP "x86")
	endif()

	set(CONFIG_WEBP release-dynamic)
	if(CMAKE_BUILD_TYPE STREQUAL "Debug")
		set(CONFIG_WEBP debug-dynamic)
		set(LIBNAME_WEBP libwebp_debug)
		set(LIBNAME_SHARPYUV libsharpyuv_debug)
		set(LIBNAME_WEBPDECODER libwebpdecoder_debug)
		set(LIBNAME_WEBP_IMPLIB libwebp_debug_dll)
		set(LIBNAME_SHARPYUV_IMPLIB libsharpyuv_debug_dll)
		set(LIBNAME_WEBPDECODER_IMPLIB libwebpdecoder_debug_dll)
	endif()
	set(OBJDIR_WEBP ${EP_BASE}/Source/project_${TARGET_WEBP}/${CONFIG_WEBP}/${CMAKE_VS_PLATFORM_NAME})

	ExternalProject_Add(project_${TARGET_WEBP}
		URL ${URL_WEBP}
		URL_MD5 ${URL_MD5_WEBP}
		CONFIGURE_COMMAND ""
		BUILD_COMMAND nmake /f Makefile.vc ARCH=${ARCH_WEBP} CFG=${CONFIG_WEBP} OBJDIR=.
		BUILD_IN_SOURCE 1
		INSTALL_COMMAND ${CMAKE_COMMAND} -E copy_if_different ${OBJDIR_WEBP}/bin/${LIBNAME_WEBP}.dll ${BINDIR}/
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${OBJDIR_WEBP}/bin/${LIBNAME_SHARPYUV}.dll ${BINDIR}/
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${OBJDIR_WEBP}/bin/${LIBNAME_WEBPDECODER}.dll ${BINDIR}/
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${OBJDIR_WEBP}/lib/${LIBNAME_WEBP_IMPLIB}.lib ${LIBDIR}/
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${OBJDIR_WEBP}/lib/${LIBNAME_SHARPYUV_IMPLIB}.lib ${LIBDIR}/
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${OBJDIR_WEBP}/lib/${LIBNAME_WEBPDECODER_IMPLIB}.lib ${LIBDIR}/
			COMMAND ${CMAKE_COMMAND} -E copy_directory ${PROJECT_SRC_WEBP}/src/webp ${INCDIR}/webp
			COMMAND ${CMAKE_COMMAND} -E remove ${INCDIR}/webp/config.h.in
	)
elseif(APPLE)
	set(FRAMEWORK_DIR_WEBP ${DESTINATION_PATH}/${TARGET_WEBP}.framework)
	set(DYLIBNAME_WEBP libwebp.7.dylib)
	set(DYLIBNAME_SHARPYUV libsharpyuv.0.dylib)

	ExternalProject_Add(project_${TARGET_WEBP}
		URL ${URL_WEBP}
		URL_MD5 ${URL_MD5_WEBP}
		CONFIGURE_COMMAND ./configure --enable-shared=yes --enable-static=no --prefix=
		BUILD_COMMAND make -j${CPUS}
		BUILD_IN_SOURCE 1
		INSTALL_COMMAND ${CMAKE_COMMAND} -E make_directory ${FRAMEWORK_DIR_WEBP}/Versions/A
			COMMAND ${CMAKE_COMMAND} -E create_symlink A ${FRAMEWORK_DIR_WEBP}/Versions/Current
			COMMAND ${CMAKE_COMMAND} -E copy_if_different src/.libs/${DYLIBNAME_WEBP} ${FRAMEWORK_DIR_WEBP}/Versions/A/
			COMMAND ${CMAKE_COMMAND} -E create_symlink Versions/Current/${DYLIBNAME_WEBP} ${FRAMEWORK_DIR_WEBP}/${TARGET_WEBP}
			COMMAND ${CMAKE_COMMAND} -E copy_if_different sharpyuv/.libs/${DYLIBNAME_SHARPYUV} ${FRAMEWORK_DIR_WEBP}/Versions/A/
			COMMAND ${CMAKE_COMMAND} -E create_symlink Versions/Current/${DYLIBNAME_SHARPYUV} ${FRAMEWORK_DIR_WEBP}/sharpyuv
			COMMAND install_name_tool -id "@rpath/${TARGET_WEBP}.framework/${TARGET_WEBP}" ${FRAMEWORK_DIR_WEBP}/${TARGET_WEBP}
			COMMAND install_name_tool ${FRAMEWORK_DIR_WEBP}/Versions/A/${DYLIBNAME_WEBP} -change "/lib/${DYLIBNAME_SHARPYUV}" "@loader_path/${DYLIBNAME_SHARPYUV}"
			COMMAND install_name_tool -id "@rpath/${TARGET_WEBP}.framework/sharpyuv" ${FRAMEWORK_DIR_WEBP}/sharpyuv
			COMMAND ${CMAKE_COMMAND} -E copy_directory ${PROJECT_SRC_WEBP}/src/webp ${FRAMEWORK_DIR_WEBP}/Versions/A/Headers/
			COMMAND ${CMAKE_COMMAND} -E remove ${FRAMEWORK_DIR_WEBP}/Versions/A/Headers/config.h.in
			COMMAND ${CMAKE_COMMAND} -E create_symlink Versions/Current/Headers ${FRAMEWORK_DIR_WEBP}/Headers
	)
elseif(EMSCRIPTEN)
	set(PROJECT_BUILD_WEBP ${EP_BASE}/Build/project_${TARGET_WEBP})

	ExternalProject_Add(project_${TARGET_WEBP}
		URL ${URL_WEBP}
		URL_MD5 ${URL_MD5_WEBP}
		CMAKE_COMMAND emcmake ${CMAKE_COMMAND} -G ${CMAKE_GENERATOR}
		CMAKE_ARGS -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} -DWEBP_BUILD_WEBP_JS=ON -DCMAKE_DISABLE_FIND_PACKAGE_Threads=ON
		BUILD_COMMAND ${CMAKE_COMMAND} --build . --parallel
		BUILD_IN_SOURCE 0
		INSTALL_COMMAND ${CMAKE_COMMAND} -E copy_if_different ${PROJECT_BUILD_WEBP}/${LIBNAME_WEBP}.a ${DESTINATION_PATH}/lib/${LIBNAME_WEBP}.a
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${PROJECT_BUILD_WEBP}/${LIBNAME_SHARPYUV}.a ${DESTINATION_PATH}/lib/${LIBNAME_SHARPYUV}.a
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${PROJECT_BUILD_WEBP}/${LIBNAME_WEBPDECODER}.a ${DESTINATION_PATH}/lib/${LIBNAME_WEBPDECODER}.a
			COMMAND ${CMAKE_COMMAND} -E copy_directory ${PROJECT_SRC_WEBP}/src/webp ${DESTINATION_PATH}/include/webp
			COMMAND ${CMAKE_COMMAND} -E remove ${DESTINATION_PATH}/include/webp/config.h.in
	)
else()
	ExternalProject_Add(project_${TARGET_WEBP}
		URL ${URL_WEBP}
		URL_MD5 ${URL_MD5_WEBP}
		CONFIGURE_COMMAND ./configure --enable-shared=yes --enable-static=no --prefix=${DESTINATION_PATH} --exec-prefix=${DESTINATION_PATH}
		BUILD_COMMAND make -j${CPUS}
		BUILD_IN_SOURCE 1
		INSTALL_COMMAND make install
	)
endif()

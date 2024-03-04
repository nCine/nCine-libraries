set(TARGET_WEBP webp)
set(URL_WEBP http://downloads.webmproject.org/releases/webp/libwebp-1.3.2.tar.gz)
set(URL_MD5_WEBP 34869086761c0e2da6361035f7b64771)
set(LIBNAME_WEBP libwebp)
set(LIBNAME_SHARPYUV libsharpyuv)
set(LIBNAME_WEBPDECODER libwebpdecoder)
set(PROJECT_SRC_WEBP ${EP_BASE}/Source/project_${TARGET_WEBP})
set(COMMON_CMAKE_ARGS_WEBP -DWEBP_BUILD_ANIM_UTILS=OFF -DWEBP_BUILD_CWEBP=OFF -DWEBP_BUILD_DWEBP=OFF -DWEBP_BUILD_GIF2WEBP=OFF -DWEBP_BUILD_IMG2WEBP=OFF -DWEBP_BUILD_VWEBP=OFF -DWEBP_BUILD_WEBPINFO=OFF -DWEBP_BUILD_LIBWEBPMUX=OFF -DWEBP_BUILD_WEBPMUX=OFF -DWEBP_BUILD_EXTRAS=OFF)

if(MSVC)
	ExternalProject_Add(project_${TARGET_WEBP}
		URL ${URL_WEBP}
		URL_MD5 ${URL_MD5_WEBP}
		CMAKE_ARGS ${COMMON_CMAKE_ARGS_WEBP} -DBUILD_SHARED_LIBS=ON
		BUILD_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE} --parallel
		BUILD_IN_SOURCE 0
		INSTALL_COMMAND ${CMAKE_COMMAND} -E copy_if_different ${CMAKE_BUILD_TYPE}/${LIBNAME_WEBP}.dll ${BINDIR}/
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${CMAKE_BUILD_TYPE}/${LIBNAME_SHARPYUV}.dll ${BINDIR}/
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${CMAKE_BUILD_TYPE}/${LIBNAME_WEBPDECODER}.dll ${BINDIR}/
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${CMAKE_BUILD_TYPE}/${LIBNAME_WEBP}.lib ${LIBDIR}/
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${CMAKE_BUILD_TYPE}/${LIBNAME_SHARPYUV}.lib ${LIBDIR}/
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${CMAKE_BUILD_TYPE}/${LIBNAME_WEBPDECODER}.lib ${LIBDIR}/
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
		CMAKE_ARGS -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} ${COMMON_CMAKE_ARGS_WEBP} -DBUILD_SHARED_LIBS=ON
		BUILD_COMMAND ${CMAKE_COMMAND} --build . --parallel
		BUILD_IN_SOURCE 0
		INSTALL_COMMAND ${CMAKE_COMMAND} -E make_directory ${FRAMEWORK_DIR_WEBP}/Versions/A
			COMMAND ${CMAKE_COMMAND} -E create_symlink A ${FRAMEWORK_DIR_WEBP}/Versions/Current
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${DYLIBNAME_WEBP} ${FRAMEWORK_DIR_WEBP}/Versions/A/
			COMMAND ${CMAKE_COMMAND} -E create_symlink Versions/Current/${DYLIBNAME_WEBP} ${FRAMEWORK_DIR_WEBP}/${TARGET_WEBP}
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${DYLIBNAME_SHARPYUV} ${FRAMEWORK_DIR_WEBP}/Versions/A/
			COMMAND ${CMAKE_COMMAND} -E create_symlink Versions/Current/${DYLIBNAME_SHARPYUV} ${FRAMEWORK_DIR_WEBP}/sharpyuv
			COMMAND install_name_tool -id "@rpath/${TARGET_WEBP}.framework/${TARGET_WEBP}" ${FRAMEWORK_DIR_WEBP}/${TARGET_WEBP}
			COMMAND install_name_tool -change "@rpath/${DYLIBNAME_SHARPYUV}" "@rpath/${TARGET_WEBP}.framework/sharpyuv" ${FRAMEWORK_DIR_WEBP}/Versions/A/${DYLIBNAME_WEBP}
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
		CMAKE_ARGS -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} ${COMMON_CMAKE_ARGS_WEBP} -DBUILD_SHARED_LIBS=ON -DCMAKE_INSTALL_PREFIX=${DESTINATION_PATH}
		BUILD_COMMAND ${CMAKE_COMMAND} --build . --parallel
		BUILD_IN_SOURCE 0
		INSTALL_COMMAND make install
	)
endif()

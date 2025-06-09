set(TARGET_CURL curl)
set(URL_CURL https://curl.se/download/curl-8.14.1.tar.gz)
set(URL_MD5_CURL 745dfc1da8c44eb9ce6ede16fd102c32)
set(COMMON_CMAKE_ARGS_CURL -DHTTP_ONLY=ON -DCURL_USE_LIBPSL=OFF -DBUILD_CURL_EXE=OFF -DBUILD_LIBCURL_DOCS=OFF)

if(MSVC)
	if(MSVC_IDE)
		set(LIB_SOURCEDIR ${EP_BASE}/Build/project_${TARGET_CURL}/lib/${CMAKE_BUILD_TYPE})
	else()
		set(LIB_SOURCEDIR ${EP_BASE}/Build/project_${TARGET_CURL}/lib)
	endif()

	ExternalProject_Add(project_${TARGET_CURL}
		URL ${URL_CURL}
		URL_MD5 ${URL_MD5_CURL}
		CMAKE_ARGS ${COMMON_CMAKE_ARGS_CURL}
		BUILD_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE} --parallel
		BUILD_IN_SOURCE 0
		INSTALL_COMMAND ${CMAKE_COMMAND} -E copy_if_different ${LIB_SOURCEDIR}/libcurl.dll ${BINDIR}/
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${LIB_SOURCEDIR}/libcurl_imp.lib ${LIBDIR}/
			COMMAND ${CMAKE_COMMAND} -E copy_directory ${EP_BASE}/Source/project_${TARGET_CURL}/include/curl ${INCDIR}/curl
			COMMAND ${CMAKE_COMMAND} -E remove ${INCDIR}/curl/Makefile.am
			COMMAND ${CMAKE_COMMAND} -E remove ${INCDIR}/curl/Makefile.in
	)
elseif(APPLE)
	set(FRAMEWORK_DIR_CURL ${DESTINATION_PATH}/${TARGET_CURL}.framework)
	if(CMAKE_BUILD_TYPE STREQUAL "Debug")
		set(DYLIBNAME_CURL libcurl-d.4.8.0.dylib)
	else()
		set(DYLIBNAME_CURL libcurl.4.8.0.dylib)
	endif()

	ExternalProject_Add(project_${TARGET_CURL}
		URL ${URL_CURL}
		URL_MD5 ${URL_MD5_CURL}
		CMAKE_ARGS -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} -DCURL_USE_SECTRANSP=ON ${COMMON_CMAKE_ARGS_CURL}
		BUILD_COMMAND ${CMAKE_COMMAND} --build . --parallel
		BUILD_IN_SOURCE 0
		INSTALL_COMMAND ${CMAKE_COMMAND} -E make_directory ${FRAMEWORK_DIR_CURL}/Versions/A
			COMMAND ${CMAKE_COMMAND} -E create_symlink A ${FRAMEWORK_DIR_CURL}/Versions/Current
			COMMAND ${CMAKE_COMMAND} -E copy_if_different lib/${DYLIBNAME_CURL} ${FRAMEWORK_DIR_CURL}/Versions/A/
			COMMAND ${CMAKE_COMMAND} -E create_symlink Versions/Current/${DYLIBNAME_CURL} ${FRAMEWORK_DIR_CURL}/${TARGET_CURL}
			COMMAND install_name_tool -id "@rpath/${TARGET_CURL}.framework/${TARGET_CURL}" ${FRAMEWORK_DIR_CURL}/${TARGET_CURL}
			COMMAND ${CMAKE_COMMAND} -E copy_directory ${EP_BASE}/Source/project_${TARGET_CURL}/include/curl ${FRAMEWORK_DIR_CURL}/Versions/A/Headers/curl
			COMMAND ${CMAKE_COMMAND} -E remove ${FRAMEWORK_DIR_CURL}/Versions/A/Headers/curl/Makefile.am
			COMMAND ${CMAKE_COMMAND} -E remove ${FRAMEWORK_DIR_CURL}/Versions/A/Headers/curl/Makefile.in
			COMMAND ${CMAKE_COMMAND} -E create_symlink Versions/Current/Headers ${FRAMEWORK_DIR_CURL}/Headers
	)
elseif(NOT EMSCRIPTEN)
	ExternalProject_Add(project_${TARGET_CURL}
		URL ${URL_CURL}
		URL_MD5 ${URL_MD5_CURL}
		CMAKE_ARGS -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} ${COMMON_CMAKE_ARGS_CURL} -DCMAKE_INSTALL_PREFIX=${DESTINATION_PATH}
		BUILD_COMMAND ${CMAKE_COMMAND} --build . --parallel
		BUILD_IN_SOURCE 0
		INSTALL_COMMAND make install
	)
endif()

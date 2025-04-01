set(TARGET_GLEW glew)
set(URL_GLEW http://sourceforge.net/projects/glew/files/glew/2.2.0/glew-2.2.0.tgz/download)
set(URL_MD5_GLEW 3579164bccaef09e36c0af7f4fd5c7c7)
set(COMMON_CMAKE_ARGS_GLEW -DBUILD_UTILS=OFF -DCMAKE_POLICY_VERSION_MINIMUM=3.5)

if(MSVC)
	if(CMAKE_BUILD_TYPE STREQUAL "Debug")
		set(LIBNAME_GLEW glew32d)
	else()
		set(LIBNAME_GLEW glew32)
	endif()

	set(BINDIR_GLEW ${EP_BASE}/Source/project_${TARGET_GLEW}/bin/${CMAKE_BUILD_TYPE})
	set(LIBDIR_GLEW ${EP_BASE}/Source/project_${TARGET_GLEW}/lib/${CMAKE_BUILD_TYPE})

	ExternalProject_Add(project_${TARGET_GLEW}
		URL ${URL_GLEW}
		URL_MD5 ${URL_MD5_GLEW}
		CONFIGURE_COMMAND ${CMAKE_COMMAND} -E touch CMakeLists.txt COMMAND ${CMAKE_COMMAND} build/cmake -A ${CMAKE_VS_PLATFORM_NAME} ${COMMON_CMAKE_ARGS_GLEW}
		BUILD_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE} --parallel
		BUILD_IN_SOURCE 1
		INSTALL_COMMAND ${CMAKE_COMMAND} -E copy_if_different ${BINDIR_GLEW}/${LIBNAME_GLEW}.dll ${BINDIR}/
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${LIBDIR_GLEW}/${LIBNAME_GLEW}.lib ${LIBDIR}/
			COMMAND ${CMAKE_COMMAND} -E copy_directory include/GL ${INCDIR}/GL
	)
elseif(APPLE)
	set(FRAMEWORK_DIR_GLEW ${DESTINATION_PATH}/${TARGET_GLEW}.framework)
	if(CMAKE_BUILD_TYPE STREQUAL "Debug")
		set(LIBNAME_GLEW libGLEWd)
	else()
		set(LIBNAME_GLEW libGLEW)
	endif()

	ExternalProject_Add(project_${TARGET_GLEW}
		URL ${URL_GLEW}
		URL_MD5 ${URL_MD5_GLEW}
		CONFIGURE_COMMAND ${CMAKE_COMMAND} -E touch CMakeLists.txt
			COMMAND ${CMAKE_COMMAND} build/cmake -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} ${COMMON_CMAKE_ARGS_GLEW} -DCMAKE_INSTALL_PREFIX=${DESTINATION_PATH}
		BUILD_COMMAND ${CMAKE_COMMAND} --build . --parallel
		BUILD_IN_SOURCE 1
		INSTALL_COMMAND ${CMAKE_COMMAND} -E make_directory ${FRAMEWORK_DIR_GLEW}/Versions/A
			COMMAND ${CMAKE_COMMAND} -E create_symlink A ${FRAMEWORK_DIR_GLEW}/Versions/Current
			COMMAND ${CMAKE_COMMAND} -E copy_if_different lib/${LIBNAME_GLEW}.dylib ${FRAMEWORK_DIR_GLEW}/Versions/A/
			COMMAND ${CMAKE_COMMAND} -E copy_if_different lib/${LIBNAME_GLEW}.a ${FRAMEWORK_DIR_GLEW}/Versions/A/
			COMMAND ${CMAKE_COMMAND} -E create_symlink Versions/Current/${LIBNAME_GLEW}.dylib ${FRAMEWORK_DIR_GLEW}/${TARGET_GLEW}
			COMMAND install_name_tool -id "@rpath/${TARGET_GLEW}.framework/${TARGET_GLEW}" ${FRAMEWORK_DIR_GLEW}/${TARGET_GLEW}
			COMMAND ${CMAKE_COMMAND} -E make_directory ${FRAMEWORK_DIR_GLEW}/Versions/A/Headers/
			COMMAND ${CMAKE_COMMAND} -E copy_directory include/GL ${FRAMEWORK_DIR_GLEW}/Versions/A/Headers/GL
			COMMAND ${CMAKE_COMMAND} -E create_symlink Versions/Current/Headers ${FRAMEWORK_DIR_GLEW}/Headers
	)
elseif(NOT EMSCRIPTEN)
	ExternalProject_Add(project_${TARGET_GLEW}
		URL ${URL_GLEW}
		URL_MD5 ${URL_MD5_GLEW}
		CONFIGURE_COMMAND ${CMAKE_COMMAND} -E touch CMakeLists.txt
			COMMAND ${CMAKE_COMMAND} build/cmake -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} ${COMMON_CMAKE_ARGS_GLEW} -DCMAKE_INSTALL_PREFIX=${DESTINATION_PATH} -G ${CMAKE_GENERATOR}
		BUILD_COMMAND ${CMAKE_COMMAND} --build . --parallel
		BUILD_IN_SOURCE 1
		INSTALL_COMMAND make install
	)
endif()

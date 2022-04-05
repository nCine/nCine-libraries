set(TARGET_GLFW glfw)
set(URL_GLFW https://github.com/glfw/glfw/releases/download/3.3.7/glfw-3.3.7.zip)
set(URL_MD5_GLFW 6985b0ecfba89ff4a3c7bc7e22f85a9d)
set(LIBNAME_GLFW glfw3)
set(COMMON_CMAKE_ARGS_GLFW -DBUILD_SHARED_LIBS=ON -DGLFW_BUILD_EXAMPLES=OFF -DGLFW_BUILD_TESTS=OFF -DGLFW_BUILD_DOCS=OFF)

if(MSVC)
	set(LIBNAME_GLFW_IMPLIB glfw3dll) # for dynamic linking
	if(MSVC_IDE)
		set(LIB_SOURCEDIR ${EP_BASE}/Build/project_${TARGET_GLFW}/src/${CMAKE_BUILD_TYPE})
	else()
		set(LIB_SOURCEDIR ${EP_BASE}/Build/project_${TARGET_GLFW}/src)
	endif()
	set(LIBFILE_GLFW ${LIB_SOURCEDIR}/${LIBNAME_GLFW}.dll)
	set(LIBFILE_GLFW_IMPLIB ${LIB_SOURCEDIR}/${LIBNAME_GLFW_IMPLIB}.lib)
	set(LIBFILE_GLFW_LIB ${LIB_SOURCEDIR}/${LIBNAME_GLFW}.lib)

	ExternalProject_Add(project_${TARGET_GLFW}
		URL ${URL_GLFW}
		URL_MD5 ${URL_MD5_GLFW}
		CMAKE_ARGS ${COMMON_CMAKE_ARGS_GLFW} -DGLFW_INSTALL=OFF
		BUILD_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE} --parallel
		BUILD_IN_SOURCE 0
		INSTALL_COMMAND ${CMAKE_COMMAND} -E copy_if_different ${LIBFILE_GLFW} ${BINDIR}/
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${LIBFILE_GLFW_IMPLIB} ${LIBDIR}/
			COMMAND ${CMAKE_COMMAND} -E copy_directory ${EP_BASE}/Source/project_${TARGET_GLFW}/include/GLFW ${INCDIR}/GLFW
	)
elseif(APPLE)
	if(GLFW_VIRTUALIZED_OSX)
		set(GLFW_PATCH_COMMAND patch -p1 < ${CMAKE_SOURCE_DIR}/patches/glfw-virtualized_osx.patch)
		message(STATUS "Virtualized OS X patch is going to be applied")
	endif()

	set(FRAMEWORK_DIR_GLFW ${DESTINATION_PATH}/${TARGET_GLFW}.framework)
	set(DYLIBNAME_GLFW libglfw.3.dylib)

	ExternalProject_Add(project_${TARGET_GLFW}
		URL ${URL_GLFW}
		URL_MD5 ${URL_MD5_GLFW}
		PATCH_COMMAND ${GLFW_PATCH_COMMAND}
		CMAKE_ARGS -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} ${COMMON_CMAKE_ARGS_GLFW} -DGLFW_INSTALL=OFF
		BUILD_COMMAND ${CMAKE_COMMAND} --build . --parallel
		BUILD_IN_SOURCE 0
		INSTALL_COMMAND ${CMAKE_COMMAND} -E make_directory ${FRAMEWORK_DIR_GLFW}/Versions/A
			COMMAND ${CMAKE_COMMAND} -E create_symlink A ${FRAMEWORK_DIR_GLFW}/Versions/Current
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${EP_BASE}/Build/project_${TARGET_GLFW}/src/${DYLIBNAME_GLFW} ${FRAMEWORK_DIR_GLFW}/Versions/A/
			COMMAND ${CMAKE_COMMAND} -E create_symlink Versions/Current/${DYLIBNAME_GLFW} ${FRAMEWORK_DIR_GLFW}/${TARGET_GLFW}
			COMMAND install_name_tool -id "@rpath/${TARGET_GLFW}.framework/${TARGET_GLFW}" ${FRAMEWORK_DIR_GLFW}/${TARGET_GLFW}
			COMMAND ${CMAKE_COMMAND} -E copy_directory ${EP_BASE}/Source/project_${TARGET_GLFW}/include/GLFW ${FRAMEWORK_DIR_GLFW}/Versions/A/Headers
			COMMAND ${CMAKE_COMMAND} -E create_symlink Versions/Current/Headers ${FRAMEWORK_DIR_GLFW}/Headers
	)
elseif(NOT EMSCRIPTEN)
	ExternalProject_Add(project_${TARGET_GLFW}
		URL ${URL_GLFW}
		URL_MD5 ${URL_MD5_GLFW}
		CMAKE_ARGS -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} ${COMMON_CMAKE_ARGS_GLFW} -DCMAKE_INSTALL_PREFIX=${DESTINATION_PATH}
		BUILD_COMMAND ${CMAKE_COMMAND} --build . --parallel
		BUILD_IN_SOURCE 0
		INSTALL_COMMAND make install
	)
endif()

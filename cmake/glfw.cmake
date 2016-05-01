set(TARGET_GLFW glfw)
set(URL_GLFW https://github.com/glfw/glfw/releases/download/3.1.2/glfw-3.1.2.zip)
set(URL_MD5_GLFW 8023327bfe979b3fe735e449e2f54842)
set(LIBNAME_GLFW glfw3)
set(COMMON_CMAKE_ARGS_GLFW -DBUILD_SHARED_LIBS=ON -DGLFW_BUILD_EXAMPLES=OFF -DGLFW_BUILD_TESTS=OFF -DGLFW_BUILD_DOCS=OFF)

if(MSVC)
	set(LIBNAME_GLFW_LIBDYN glfw3dll) # for dynamic linking
	if(MSVC_IDE)
		set(LIB_SOURCEDIR ${EP_BASE}/Build/project_${TARGET_GLFW}/src/${CONFIGURATION})
	else()
		set(LIB_SOURCEDIR ${EP_BASE}/Build/project_${TARGET_GLFW}/src)
	endif()
	set(LIBFILE_GLFW ${LIB_SOURCEDIR}/${LIBNAME_GLFW}.dll)
	set(LIBFILE_GLFW_LIBDYN ${LIB_SOURCEDIR}/${LIBNAME_GLFW_LIBDYN}.lib)
	set(LIBFILE_GLFW_LIB ${LIB_SOURCEDIR}/${LIBNAME_GLFW}.lib)

	ExternalProject_Add(project_${TARGET_GLFW}
		URL ${URL_GLFW}
		URL_MD5 ${URL_MD5_GLFW}
		CMAKE_ARGS -DCMAKE_BUILD_TYPE=${CONFIGURATION} ${COMMON_CMAKE_ARGS_GLFW} -DGLFW_INSTALL=OFF
		BUILD_IN_SOURCE 0
		INSTALL_COMMAND ${CMAKE_COMMAND} -E copy_if_different ${LIBFILE_GLFW} ${BINDIR}
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${LIBFILE_GLFW_LIBDYN} ${LIBDIR}
			COMMAND ${CMAKE_COMMAND} -E copy_directory ${EP_BASE}/Source/project_${TARGET_GLFW}/include/GLFW ${INCDIR}/GLFW
	)
elseif(APPLE)
	# GLFW > 3.0.x cannot open a window when OS X runs in a virtual machine
	set(URL_GLFW https://github.com/glfw/glfw/archive/3.0.4.zip)
	set(URL_MD5_GLFW 608d5cb50325f41d154fe1cc42061606)
	set(FRAMEWORK_DIR_GLFW ${DESTINATION_PATH}/${TARGET_GLFW}.framework)
	set(DYLIBNAME_GLFW libglfw.3.dylib)

	ExternalProject_Add(project_${TARGET_GLFW}
		URL ${URL_GLFW}
		URL_MD5 ${URL_MD5_GLFW}
		CMAKE_ARGS ${COMMON_CMAKE_ARGS_GLFW} -DGLFW_INSTALL=OFF
		BUILD_IN_SOURCE 0
		INSTALL_COMMAND ${CMAKE_COMMAND} -E make_directory ${FRAMEWORK_DIR_GLFW}/Versions/A
			COMMAND ${CMAKE_COMMAND} -E create_symlink A ${FRAMEWORK_DIR_GLFW}/Versions/Current
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${EP_BASE}/Build/project_${TARGET_GLFW}/src/${DYLIBNAME_GLFW} ${FRAMEWORK_DIR_GLFW}/Versions/A/
			COMMAND ${CMAKE_COMMAND} -E create_symlink Versions/Current/${DYLIBNAME_GLFW} ${FRAMEWORK_DIR_GLFW}/${TARGET_GLFW}
			COMMAND install_name_tool -id "@rpath/${TARGET_GLFW}.framework/${TARGET_GLFW}" ${FRAMEWORK_DIR_GLFW}/${TARGET_GLFW}
			COMMAND ${CMAKE_COMMAND} -E copy_directory ${EP_BASE}/Source/project_${TARGET_GLFW}/include/GLFW ${FRAMEWORK_DIR_GLFW}/Versions/A/Headers
			COMMAND ${CMAKE_COMMAND} -E create_symlink Versions/Current/Headers ${FRAMEWORK_DIR_GLFW}/Headers
	)
else()
	ExternalProject_Add(project_${TARGET_GLFW}
		URL ${URL_GLFW}
		URL_MD5 ${URL_MD5_GLFW}
		CMAKE_ARGS ${COMMON_CMAKE_ARGS_GLFW} -DCMAKE_INSTALL_PREFIX=${DESTINATION_PATH}
		BUILD_IN_SOURCE 0
		INSTALL_COMMAND make install
	)
endif()

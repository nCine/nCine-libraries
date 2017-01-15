set(TARGET_GLFW_STATIC glfw_static)
set(COMMON_CMAKE_ARGS_GLFW_STATIC -DBUILD_SHARED_LIBS=OFF -DGLFW_BUILD_EXAMPLES=OFF -DGLFW_BUILD_TESTS=OFF -DGLFW_BUILD_DOCS=OFF)

if(MSVC)
	set(LIBNAME_GLFW_LIB glfw) # for static linking
	if(MSVC_IDE)
		set(LIB_SOURCEDIR ${EP_BASE}/Build/project_${TARGET_GLFW_STATIC}/src/${CONFIGURATION})
	else()
		set(LIB_SOURCEDIR ${EP_BASE}/Build/project_${TARGET_GLFW_STATIC}/src)
	endif()
	set(LIBFILE_GLFW_LIB ${LIB_SOURCEDIR}/${LIBNAME_GLFW}.lib)

	ExternalProject_Add(project_${TARGET_GLFW_STATIC}
		DEPENDS project_${TARGET_GLFW}
		DOWNLOAD_COMMAND ""
		SOURCE_DIR ${EP_BASE}/Source/project_${TARGET_GLFW}
		CMAKE_ARGS -DCMAKE_BUILD_TYPE=${CONFIGURATION} ${COMMON_CMAKE_ARGS_GLFW_STATIC} -DGLFW_INSTALL=OFF
		BUILD_IN_SOURCE 0
		INSTALL_COMMAND ${CMAKE_COMMAND} -E copy_if_different ${LIBFILE_GLFW_LIB} ${LIBDIR}/
	)
# Supporting only frameworks on OS X
elseif(NOT APPLE)
	ExternalProject_Add(project_${TARGET_GLFW_STATIC}
		DEPENDS project_${TARGET_GLFW}
		DOWNLOAD_COMMAND ""
		SOURCE_DIR ${EP_BASE}/Source/project_${TARGET_GLFW}
		CMAKE_ARGS ${COMMON_CMAKE_ARGS_GLFW_STATIC} -DCMAKE_INSTALL_PREFIX=${DESTINATION_PATH}
		BUILD_IN_SOURCE 0
		INSTALL_COMMAND make install
	)
endif()

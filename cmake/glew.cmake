set(TARGET_GLEW glew)
set(URL_GLEW http://sourceforge.net/projects/glew/files/glew/1.13.0/glew-1.13.0.tgz/download)
set(URL_MD5_GLEW 7cbada3166d2aadfc4169c4283701066)
set(LIBNAME_GLEW glew32)
set(LIBNAME_MX_GLEW glew32mx)

if(MSVC)
	if(MSVC_IDE)
		set(LIBNAME_GLEW $<$<NOT:$<CONFIG:Debug>>:glew32>$<$<CONFIG:Debug>:glew32d>)
		set(LIBNAME_MX_GLEW $<$<NOT:$<CONFIG:Debug>>:glew32mx>$<$<CONFIG:Debug>:glew32mxd>)
	else()
		if(CMAKE_BUILD_TYPE STREQUAL "Debug")
			set(LIBNAME_GLEW glew32d)
			set(LIBNAME_MX_GLEW glew32mxd)
		endif()
	endif()

	set(CONFIGURATION_MX_GLEW "${CONFIGURATION} MX")
	set(BINDIR_GLEW ${EP_BASE}/Source/project_${TARGET_GLEW}/bin/${CONFIGURATION}/${PLATFORM})
	set(LIBDIR_GLEW ${EP_BASE}/Source/project_${TARGET_GLEW}/lib/${CONFIGURATION}/${PLATFORM})
 	set(BINDIR_MX_GLEW "${EP_BASE}/Source/project_${TARGET_GLEW}/bin/${CONFIGURATION} MX/${PLATFORM}")
	set(LIBDIR_MX_GLEW "${EP_BASE}/Source/project_${TARGET_GLEW}/lib/${CONFIGURATION} MX/${PLATFORM}")

	ExternalProject_Add(project_${TARGET_GLEW}
		URL ${URL_GLEW}
		URL_MD5 ${URL_MD5_GLEW}
		CONFIGURE_COMMAND devenv build/vc12/glew.sln /Upgrade # TODO: Build with CMake
		BUILD_COMMAND msbuild build/vc12/glew_shared.vcxproj /t:Build /p:Platform=${PLATFORM} /p:Configuration=${CONFIGURATION} /p:Platform=${PLATFORM} /p:PlatformToolset=${CMAKE_VS_PLATFORM_TOOLSET}
			COMMAND msbuild build/vc12/glew_shared.vcxproj /t:Build /p:Platform=${PLATFORM} /p:Configuration=${CONFIGURATION_MX_GLEW} /p:Platform=${PLATFORM} /p:PlatformToolset=${CMAKE_VS_PLATFORM_TOOLSET}
		BUILD_IN_SOURCE 1
		INSTALL_COMMAND ${CMAKE_COMMAND} -E copy_if_different ${BINDIR_GLEW}/${LIBNAME_GLEW}.dll ${BINDIR}
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${LIBDIR_GLEW}/${LIBNAME_GLEW}.lib ${LIBDIR}
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${BINDIR_MX_GLEW}/${LIBNAME_MX_GLEW}.dll ${BINDIR}
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${LIBDIR_MX_GLEW}/${LIBNAME_MX_GLEW}.lib ${LIBDIR}
			COMMAND ${CMAKE_COMMAND} -E copy_if_different include/GL/glew.h ${INCDIR}/GL/glew.h
			COMMAND ${CMAKE_COMMAND} -E copy_if_different include/GL/glxew.h ${INCDIR}/GL/glxew.h
			COMMAND ${CMAKE_COMMAND} -E copy_if_different include/GL/wglew.h ${INCDIR}/GL/wglew.h
	)
# Unneeded on OS X
elseif(NOT APPLE)
	ExternalProject_Add(project_${TARGET_GLEW}
		URL ${URL_GLEW}
		URL_MD5 ${URL_MD5_GLEW}
		CONFIGURE_COMMAND ${CMAKE_COMMAND} -E touch CMakeLists.txt
			COMMAND ${CMAKE_COMMAND} build/cmake -DBUILD_UTILS=OFF -DCMAKE_INSTALL_PREFIX=${DESTINATION_PATH}
		BUILD_COMMAND ${PARALLEL_MAKE}
		BUILD_IN_SOURCE 1
		INSTALL_COMMAND make install
	)
endif()

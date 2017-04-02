set(TARGET_GLEW glew)
set(URL_GLEW http://sourceforge.net/projects/glew/files/glew/2.0.0/glew-2.0.0.tgz/download)
set(URL_MD5_GLEW 2a2cd7c98f13854d2fcddae0d2b20411)

if(MSVC)
	if(MSVC_IDE)
		set(LIBNAME_GLEW $<$<NOT:$<CONFIG:Debug>>:glew32>$<$<CONFIG:Debug>:glew32d>)
	else()
		if(CMAKE_BUILD_TYPE STREQUAL "Debug")
			set(LIBNAME_GLEW glew32d)
		else()
			set(LIBNAME_GLEW glew32)
		endif()
	endif()

	set(BINDIR_GLEW ${EP_BASE}/Source/project_${TARGET_GLEW}/bin/${CONFIGURATION}/${PLATFORM})
	set(LIBDIR_GLEW ${EP_BASE}/Source/project_${TARGET_GLEW}/lib/${CONFIGURATION}/${PLATFORM})

	ExternalProject_Add(project_${TARGET_GLEW}
		URL ${URL_GLEW}
		URL_MD5 ${URL_MD5_GLEW}
		CONFIGURE_COMMAND devenv build/vc12/glew.sln /Upgrade # TODO: Build with CMake
		BUILD_COMMAND msbuild build/vc12/glew_shared.vcxproj /t:Build /p:Platform=${PLATFORM} /p:Configuration=${CONFIGURATION} /p:Platform=${PLATFORM} /p:PlatformToolset=${CMAKE_VS_PLATFORM_TOOLSET} /p:WindowsTargetPlatformVersion=${CMAKE_VS_WINDOWS_TARGET_PLATFORM_VERSION}
		BUILD_IN_SOURCE 1
		INSTALL_COMMAND ${CMAKE_COMMAND} -E copy_if_different ${BINDIR_GLEW}/${LIBNAME_GLEW}.dll ${BINDIR}/
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${LIBDIR_GLEW}/${LIBNAME_GLEW}.lib ${LIBDIR}/
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

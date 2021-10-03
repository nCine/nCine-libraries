set(TARGET_OGG ogg)
set(URL_OGG http://downloads.xiph.org/releases/ogg/libogg-1.3.3.tar.gz)
set(URL_MD5_OGG 1eda7efc22a97d08af98265107d65f95)
set(LIBNAME_OGG libogg)

if(MSVC)
	set(LIBFILE_OGG_NOEXT ${EP_BASE}/Source/project_${TARGET_OGG}/win32/VS2015/${CMAKE_VS_PLATFORM_NAME}/${CMAKE_BUILD_TYPE}/${LIBNAME_OGG})

	ExternalProject_Add(project_${TARGET_OGG}
		URL ${URL_OGG}
		URL_MD5 ${URL_MD5_OGG}
		CONFIGURE_COMMAND devenv win32/VS2015/libogg_dynamic.vcxproj /Upgrade
		BUILD_COMMAND msbuild win32/VS2015/libogg_dynamic.vcxproj -m /t:Build /p:Configuration=${CMAKE_BUILD_TYPE} /p:Platform=${CMAKE_VS_PLATFORM_NAME} /p:PlatformToolset=${CMAKE_VS_PLATFORM_TOOLSET} /p:WindowsTargetPlatformVersion=${CMAKE_VS_WINDOWS_TARGET_PLATFORM_VERSION}
		BUILD_IN_SOURCE 1
		INSTALL_COMMAND ${CMAKE_COMMAND} -E copy_if_different ${LIBFILE_OGG_NOEXT}.dll ${BINDIR}/
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${LIBFILE_OGG_NOEXT}.lib ${LIBDIR}/
			COMMAND ${CMAKE_COMMAND} -E copy_if_different include/ogg/ogg.h ${INCDIR}/ogg/ogg.h
			COMMAND ${CMAKE_COMMAND} -E copy_if_different include/ogg/os_types.h ${INCDIR}/ogg/os_types.h
	)

	set(TARGET_OGG_STATIC ogg_static)
	ExternalProject_Add(project_${TARGET_OGG_STATIC}
		DEPENDS project_${TARGET_OGG}
		DOWNLOAD_COMMAND ""
		SOURCE_DIR ${EP_BASE}/Source/project_${TARGET_OGG}
		CONFIGURE_COMMAND devenv win32/VS2015/libogg_static.vcxproj /Upgrade
		BUILD_COMMAND msbuild win32/VS2015/libogg_static.vcxproj -m /t:Build /p:Configuration=${CMAKE_BUILD_TYPE} /p:Platform=${CMAKE_VS_PLATFORM_NAME} /p:PlatformToolset=${CMAKE_VS_PLATFORM_TOOLSET} /p:WindowsTargetPlatformVersion=${CMAKE_VS_WINDOWS_TARGET_PLATFORM_VERSION}
		BUILD_IN_SOURCE 1
		INSTALL_COMMAND "" #${CMAKE_COMMAND} -E copy_if_different ${LIBFILE_OGG_NOEXT}_static.lib ${LIBDIR}/
	)
elseif(APPLE)
	set(FRAMEWORK_DIR_OGG ${DESTINATION_PATH}/${TARGET_OGG}.framework)
	set(DYLIBNAME_OGG libogg.0.dylib)

	ExternalProject_Add(project_${TARGET_OGG}
		URL ${URL_OGG}
		URL_MD5 ${URL_MD5_OGG}
		CONFIGURE_COMMAND ./configure --prefix=
		BUILD_COMMAND make -j${CPUS}
		BUILD_IN_SOURCE 1
		INSTALL_COMMAND ${CMAKE_COMMAND} -E make_directory ${FRAMEWORK_DIR_OGG}/Versions/A
			COMMAND ${CMAKE_COMMAND} -E create_symlink A ${FRAMEWORK_DIR_OGG}/Versions/Current
			COMMAND ${CMAKE_COMMAND} -E copy_if_different src/.libs/${DYLIBNAME_OGG} ${FRAMEWORK_DIR_OGG}/Versions/A/
			COMMAND ${CMAKE_COMMAND} -E create_symlink Versions/Current/${DYLIBNAME_OGG} ${FRAMEWORK_DIR_OGG}/${TARGET_OGG}
			COMMAND install_name_tool -id "@rpath/${TARGET_OGG}.framework/${TARGET_OGG}" ${FRAMEWORK_DIR_OGG}/${TARGET_OGG}
			COMMAND ${CMAKE_COMMAND} -E make_directory ${FRAMEWORK_DIR_OGG}/Versions/A/Headers/
			COMMAND ${CMAKE_COMMAND} -E copy_if_different include/ogg/ogg.h ${FRAMEWORK_DIR_OGG}/Versions/A/Headers/
			COMMAND ${CMAKE_COMMAND} -E copy_if_different include/ogg/os_types.h ${FRAMEWORK_DIR_OGG}/Versions/A/Headers/
			COMMAND ${CMAKE_COMMAND} -E create_symlink Versions/Current/Headers ${FRAMEWORK_DIR_OGG}/Headers
			COMMAND ${CMAKE_COMMAND} -E make_directory ${FRAMEWORK_DIR_OGG}/Versions/A/Resources
			COMMAND ${CMAKE_COMMAND} -E copy_if_different macosx/English.lproj ${FRAMEWORK_DIR_OGG}/Versions/A/Resources/
			COMMAND ${CMAKE_COMMAND} -E copy_if_different macosx/Info.plist ${FRAMEWORK_DIR_OGG}/Versions/A/Resources/
			COMMAND ${CMAKE_COMMAND} -E create_symlink Versions/Current/Resources ${FRAMEWORK_DIR_OGG}/Resources
	)
elseif(NOT EMSCRIPTEN)
	ExternalProject_Add(project_${TARGET_OGG}
		URL ${URL_OGG}
		URL_MD5 ${URL_MD5_OGG}
		CONFIGURE_COMMAND ./configure --prefix=${DESTINATION_PATH} --exec-prefix=${DESTINATION_PATH}
		BUILD_COMMAND make -j${CPUS}
		BUILD_IN_SOURCE 1
		INSTALL_COMMAND make install
	)
endif()

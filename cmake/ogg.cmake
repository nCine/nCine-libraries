set(TARGET_OGG ogg)
set(URL_OGG http://downloads.xiph.org/releases/ogg/libogg-1.3.2.tar.gz)
set(URL_MD5_OGG b72e1a1dbadff3248e4ed62a4177e937)
set(LIBNAME_OGG libogg)

if(MSVC)
	set(LIBFILE_OGG_NOEXT ${EP_BASE}/Source/project_${TARGET_OGG}/win32/VS2010/${PLATFORM}/${CONFIGURATION}/${LIBNAME_OGG})

	ExternalProject_Add(project_${TARGET_OGG}
		URL ${URL_OGG}
		URL_MD5 ${URL_MD5_OGG}
		CONFIGURE_COMMAND devenv win32/VS2010/libogg_dynamic.vcxproj /Upgrade
		BUILD_COMMAND msbuild win32/VS2010/libogg_dynamic.vcxproj /t:Build /p:Configuration=${CONFIGURATION} /p:Platform=${PLATFORM} /p:PlatformToolset=${CMAKE_VS_PLATFORM_TOOLSET}
		BUILD_IN_SOURCE 1
		INSTALL_COMMAND ${CMAKE_COMMAND} -E copy_if_different ${LIBFILE_OGG_NOEXT}.dll ${BINDIR}
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${LIBFILE_OGG_NOEXT}.lib ${LIBDIR}
			COMMAND ${CMAKE_COMMAND} -E copy_if_different include/ogg/ogg.h ${INCDIR}/ogg/ogg.h
			COMMAND ${CMAKE_COMMAND} -E copy_if_different include/ogg/os_types.h ${INCDIR}/ogg/os_types.h
	)
elseif(APPLE)
	set(FRAMEWORK_DIR_OGG ${DESTINATION_PATH}/${TARGET_OGG}.framework)
	set(DYLIBNAME_OGG libogg.0.dylib)

	ExternalProject_Add(project_${TARGET_OGG}
		URL ${URL_OGG}
		URL_MD5 ${URL_MD5_OGG}
		CONFIGURE_COMMAND ./configure --prefix=
		BUILD_COMMAND ${PARALLEL_MAKE}
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
else()
	ExternalProject_Add(project_${TARGET_OGG}
		URL ${URL_OGG}
		URL_MD5 ${URL_MD5_OGG}
		CONFIGURE_COMMAND ./configure --prefix=
		BUILD_COMMAND ${PARALLEL_MAKE}
		BUILD_IN_SOURCE 1
		INSTALL_COMMAND make DESTDIR=${DESTINATION_PATH} install
	)
endif()

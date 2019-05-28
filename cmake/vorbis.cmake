if(NOT DEFINED TARGET_OGG)
	message(FATAL_ERROR "TARGET_OGG is not defined")
endif()

set(TARGET_VORBIS vorbis)
set(URL_VORBIS http://downloads.xiph.org/releases/vorbis/libvorbis-1.3.6.tar.gz)
set(URL_MD5_VORBIS d3190649b26572d44cd1e4f553943b31)

set(LIBNAME_VORBIS libvorbis)
set(TARGET_VORBISFILE vorbisfile)
set(LIBNAME_VORBISFILE libvorbisfile)

if(MSVC)
	set(LIBFILE_VORBIS_NOEXT ${EP_BASE}/Source/project_${TARGET_VORBIS}/win32/VS2010/libvorbis/${PLATFORM}/${CONFIGURATION}/${LIBNAME_VORBIS})

	get_filename_component(LIBDIR_OGG ${LIBFILE_OGG_NOEXT}.dll DIRECTORY)
	set(INCLUDEDIR_OGG ${EP_BASE}/Source/project_${TARGET_OGG}/include)
	ExternalProject_Add(project_${TARGET_VORBIS}
		DEPENDS project_${TARGET_OGG}
		URL ${URL_VORBIS}
		URL_MD5 ${URL_MD5_VORBIS}
		CONFIGURE_COMMAND devenv win32/VS2010/libvorbis/libvorbis_dynamic.vcxproj /Upgrade
		BUILD_COMMAND set CL=/I${INCLUDEDIR_OGG} COMMAND set LINK=/LIBPATH:${LIBDIR_OGG}
			COMMAND msbuild win32/VS2010/libvorbis/libvorbis_dynamic.vcxproj /t:Build /p:Configuration=${CONFIGURATION} /p:Platform=${PLATFORM} /p:PlatformToolset=${CMAKE_VS_PLATFORM_TOOLSET} /p:WindowsTargetPlatformVersion=${CMAKE_VS_WINDOWS_TARGET_PLATFORM_VERSION}
		BUILD_IN_SOURCE 1
		INSTALL_COMMAND ${CMAKE_COMMAND} -E copy_if_different ${LIBFILE_VORBIS_NOEXT}.dll ${BINDIR}/
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${LIBFILE_VORBIS_NOEXT}.lib ${LIBDIR}/
			COMMAND ${CMAKE_COMMAND} -E copy_if_different include/vorbis/codec.h ${INCDIR}/vorbis/codec.h
			COMMAND ${CMAKE_COMMAND} -E copy_if_different include/vorbis/vorbisenc.h ${INCDIR}/vorbis/vorbisenc.h
	)
	set(TARGET_VORBIS_STATIC vorbis_static)
	ExternalProject_Add(project_${TARGET_VORBIS_STATIC}
		DEPENDS project_${TARGET_VORBIS}
		DOWNLOAD_COMMAND ""
		SOURCE_DIR ${EP_BASE}/Source/project_${TARGET_VORBIS}
		CONFIGURE_COMMAND devenv win32/VS2010/libvorbis/libvorbis_static.vcxproj /Upgrade
		BUILD_COMMAND set CL=/I${INCLUDEDIR_OGG} COMMAND set LINK=/LIBPATH:${LIBDIR_OGG}
			COMMAND msbuild win32/VS2010/libvorbis/libvorbis_static.vcxproj /t:Build /p:Configuration=${CONFIGURATION} /p:Platform=${PLATFORM} /p:PlatformToolset=${CMAKE_VS_PLATFORM_TOOLSET} /p:WindowsTargetPlatformVersion=${CMAKE_VS_WINDOWS_TARGET_PLATFORM_VERSION}
		BUILD_IN_SOURCE 1
		INSTALL_COMMAND "" #${CMAKE_COMMAND} -E copy_if_different ${LIBFILE_VORBIS_NOEXT}_static.lib ${LIBDIR}/
	)

	set(LIBFILE_VORBISFILE_NOEXT ${EP_BASE}/Source/project_${TARGET_VORBIS}/win32/VS2010/libvorbisfile/${PLATFORM}/${CONFIGURATION}/${LIBNAME_VORBISFILE})

	get_filename_component(LIBDIR_VORBIS ${LIBFILE_VORBIS_NOEXT}.dll DIRECTORY)
	ExternalProject_Add(project_${TARGET_VORBISFILE}
		DEPENDS project_${TARGET_VORBIS}
		DOWNLOAD_COMMAND "" # Vorbis project is going to download the archive, but a dummy command is needed
		SOURCE_DIR ${EP_BASE}/Source/project_${TARGET_VORBIS}
		CONFIGURE_COMMAND devenv win32/VS2010/libvorbisfile/libvorbisfile_dynamic.vcxproj /Upgrade
		BUILD_COMMAND set CL=/I${INCLUDEDIR_OGG} COMMAND set LINK=/LIBPATH:${LIBDIR_OGG} /LIBPATH:${LIBDIR_VORBIS}
			COMMAND msbuild win32/VS2010/libvorbisfile/libvorbisfile_dynamic.vcxproj /t:Build /p:Configuration=${CONFIGURATION} /p:Platform=${PLATFORM} /p:PlatformToolset=${CMAKE_VS_PLATFORM_TOOLSET} /p:WindowsTargetPlatformVersion=${CMAKE_VS_WINDOWS_TARGET_PLATFORM_VERSION}
		BUILD_IN_SOURCE 1
		INSTALL_COMMAND ${CMAKE_COMMAND} -E copy_if_different ${LIBFILE_VORBISFILE_NOEXT}.dll ${BINDIR}/
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${LIBFILE_VORBISFILE_NOEXT}.lib ${LIBDIR}/
			COMMAND ${CMAKE_COMMAND} -E copy_if_different include/vorbis/vorbisfile.h ${INCDIR}/vorbis/vorbisfile.h
	)
	set(TARGET_VORBISFILE_STATIC vorbisfile_static)
	ExternalProject_Add(project_${TARGET_VORBISFILE_STATIC}
		DEPENDS project_${TARGET_VORBISFILE}
		DOWNLOAD_COMMAND ""
		SOURCE_DIR ${EP_BASE}/Source/project_${TARGET_VORBIS}
		CONFIGURE_COMMAND devenv win32/VS2010/libvorbisfile/libvorbisfile_static.vcxproj /Upgrade
		BUILD_COMMAND set CL=/I${INCLUDEDIR_OGG} COMMAND set LINK=/LIBPATH:${LIBDIR_OGG}
			COMMAND msbuild win32/VS2010/libvorbisfile/libvorbisfile_static.vcxproj /t:Build /p:Configuration=${CONFIGURATION} /p:Platform=${PLATFORM} /p:PlatformToolset=${CMAKE_VS_PLATFORM_TOOLSET} /p:WindowsTargetPlatformVersion=${CMAKE_VS_WINDOWS_TARGET_PLATFORM_VERSION}
		BUILD_IN_SOURCE 1
		INSTALL_COMMAND "" #${CMAKE_COMMAND} -E copy_if_different ${LIBFILE_VORBISFILE_NOEXT}_static.lib ${LIBDIR}/
	)
elseif(APPLE)
	set(FRAMEWORK_DIR_VORBIS ${DESTINATION_PATH}/${TARGET_VORBIS}.framework)
	set(DYLIBNAME_VORBIS libvorbis.0.dylib)
	set(FRAMEWORK_DIR_VORBISFILE ${DESTINATION_PATH}/${TARGET_VORBISFILE}.framework)
	set(DYLIBNAME_VORBISFILE libvorbisfile.3.dylib)

	ExternalProject_Add(project_${TARGET_VORBIS}
		DEPENDS project_${TARGET_OGG}
		URL ${URL_VORBIS}
		URL_MD5 ${URL_MD5_VORBIS}
		CONFIGURE_COMMAND ./configure --with-ogg-libraries=${EP_BASE}/Source/project_${TARGET_OGG}/src/.libs/ --with-ogg-includes=${EP_BASE}/Source/project_${TARGET_OGG}/include/ --enable-oggtest=no --prefix=
		BUILD_COMMAND ${PARALLEL_MAKE}
		BUILD_IN_SOURCE 1
		INSTALL_COMMAND ${CMAKE_COMMAND} -E make_directory ${FRAMEWORK_DIR_VORBIS}/Versions/A
			COMMAND ${CMAKE_COMMAND} -E create_symlink A ${FRAMEWORK_DIR_VORBIS}/Versions/Current
			COMMAND ${CMAKE_COMMAND} -E copy_if_different lib/.libs/${DYLIBNAME_VORBIS} ${FRAMEWORK_DIR_VORBIS}/Versions/A/
			COMMAND ${CMAKE_COMMAND} -E create_symlink Versions/Current/${DYLIBNAME_VORBIS} ${FRAMEWORK_DIR_VORBIS}/${TARGET_VORBIS}
			COMMAND install_name_tool -id "@rpath/${TARGET_VORBIS}.framework/${TARGET_VORBIS}" ${FRAMEWORK_DIR_VORBIS}/${TARGET_VORBIS}
			COMMAND install_name_tool -change "/lib/${DYLIBNAME_OGG}" "@rpath/${TARGET_OGG}.framework/${TARGET_OGG}" ${FRAMEWORK_DIR_VORBIS}/${TARGET_VORBIS}
			COMMAND ${CMAKE_COMMAND} -E make_directory ${FRAMEWORK_DIR_VORBIS}/Versions/A/Headers/
			COMMAND ${CMAKE_COMMAND} -E copy_if_different include/vorbis/codec.h ${FRAMEWORK_DIR_VORBIS}/Versions/A/Headers/
			COMMAND ${CMAKE_COMMAND} -E copy_if_different include/vorbis/vorbisenc.h ${FRAMEWORK_DIR_VORBIS}/Versions/A/Headers/
			COMMAND ${CMAKE_COMMAND} -E copy_if_different include/vorbis/vorbisfile.h ${FRAMEWORK_DIR_VORBIS}/Versions/A/Headers/ # needed here too
			COMMAND ${CMAKE_COMMAND} -E create_symlink Versions/Current/Headers ${FRAMEWORK_DIR_VORBIS}/Headers
			COMMAND ${CMAKE_COMMAND} -E make_directory ${FRAMEWORK_DIR_VORBIS}/Versions/A/Resources
			COMMAND ${CMAKE_COMMAND} -E copy_if_different macosx/English.lproj ${FRAMEWORK_DIR_VORBIS}/Versions/A/Resources/
			COMMAND ${CMAKE_COMMAND} -E copy_if_different macosx/Info.plist ${FRAMEWORK_DIR_VORBIS}/Versions/A/Resources/
			COMMAND ${CMAKE_COMMAND} -E create_symlink Versions/Current/Resources ${FRAMEWORK_DIR_VORBIS}/Resources
	)

	ExternalProject_Add(project_${TARGET_VORBISFILE}
		DEPENDS project_${TARGET_VORBIS}
		DOWNLOAD_COMMAND "" # Vorbis project is going to download the archive, but a dummy command is needed
		SOURCE_DIR ${EP_BASE}/Source/project_${TARGET_VORBIS}
		CONFIGURE_COMMAND ""
		BUILD_COMMAND ""
		BUILD_IN_SOURCE 1
		INSTALL_COMMAND ${CMAKE_COMMAND} -E make_directory ${FRAMEWORK_DIR_VORBISFILE}/Versions/A
			COMMAND ${CMAKE_COMMAND} -E create_symlink A ${FRAMEWORK_DIR_VORBISFILE}/Versions/Current
			COMMAND ${CMAKE_COMMAND} -E copy_if_different lib/.libs/${DYLIBNAME_VORBISFILE} ${FRAMEWORK_DIR_VORBISFILE}/Versions/A/
			COMMAND ${CMAKE_COMMAND} -E create_symlink Versions/Current/${DYLIBNAME_VORBISFILE} ${FRAMEWORK_DIR_VORBISFILE}/${TARGET_VORBISFILE}
			COMMAND install_name_tool -id "@rpath/${TARGET_VORBISFILE}.framework/${TARGET_VORBISFILE}" ${FRAMEWORK_DIR_VORBISFILE}/${TARGET_VORBISFILE}
			COMMAND install_name_tool -change "/lib/${DYLIBNAME_VORBIS}" "@rpath/${TARGET_VORBIS}.framework/${TARGET_VORBIS}" ${FRAMEWORK_DIR_VORBISFILE}/${TARGET_VORBISFILE}
			COMMAND install_name_tool -change "/lib/${DYLIBNAME_OGG}" "@rpath/${TARGET_OGG}.framework/${TARGET_OGG}" ${FRAMEWORK_DIR_VORBISFILE}/${TARGET_VORBISFILE}
			COMMAND ${CMAKE_COMMAND} -E make_directory ${FRAMEWORK_DIR_VORBISFILE}/Versions/A/Headers/
			COMMAND ${CMAKE_COMMAND} -E copy_if_different include/vorbis/vorbisfile.h ${FRAMEWORK_DIR_VORBISFILE}/Versions/A/Headers/
			COMMAND ${CMAKE_COMMAND} -E create_symlink Versions/Current/Headers ${FRAMEWORK_DIR_VORBISFILE}/Headers
	)
else()
	ExternalProject_Add(project_${TARGET_VORBIS}
		DEPENDS project_${TARGET_OGG}
		URL ${URL_VORBIS}
		URL_MD5 ${URL_MD5_VORBIS}
		CONFIGURE_COMMAND ./configure --with-ogg-libraries=${DESTINATION_PATH}/lib --with-ogg-includes=${DESTINATION_PATH}/include/ --prefix=# && make clean # clean to avoid libtool error
		BUILD_COMMAND ${PARALLEL_MAKE}
		BUILD_IN_SOURCE 1
		INSTALL_COMMAND make DESTDIR=${DESTINATION_PATH} install
	)
endif()

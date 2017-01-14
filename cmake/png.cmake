if(NOT DEFINED TARGET_ZLIB)
	message(FATAL_ERROR "TARGET_ZLIB is not defined")
endif()

set(TARGET_PNG png)
set(URL_PNG http://downloads.sourceforge.net/project/libpng/libpng16/1.6.28/libpng-1.6.28.tar.gz)
set(URL_MD5_PNG 897ccec1ebfb0922e83c2bfaa1be8748)
set(LIBNAME_PNG libpng16)
set(COMMON_CMAKE_ARGS_PNG -DPNG_TESTS=OFF)

if(MSVC)
	set(LIBNAME_PNG_LIB libpng16_static) # for static linking
	if(MSVC_IDE)
		set(LIBNAME_PNG $<$<NOT:$<CONFIG:Debug>>:libpng16>$<$<CONFIG:Debug>:libpng16d>)
		set(LIBNAME_PNG_LIB $<$<NOT:$<CONFIG:Debug>>:libpng16_static>$<$<CONFIG:Debug>:libpng16_staticd>)
	else()
		if(CMAKE_BUILD_TYPE STREQUAL "Debug")
			set(LIBNAME_PNG libpng16d)
			set(LIBNAME_PNG_LIB libpng16_staticd)
		endif()
	endif()

	if(MSVC_IDE)
		set(LIBFILE_PNG_NOEXT ${EP_BASE}/Build/project_${TARGET_PNG}/${CONFIGURATION}/${LIBNAME_PNG})
		set(LIBFILE_PNG_LIB ${EP_BASE}/Build/project_${TARGET_PNG}/${CONFIGURATION}/${LIBNAME_PNG_LIB}.lib)
	else()
		set(LIBFILE_PNG_NOEXT ${EP_BASE}/Build/project_${TARGET_PNG}/${LIBNAME_PNG})
		set(LIBFILE_PNG_LIB ${EP_BASE}/Build/project_${TARGET_PNG}/${LIBNAME_PNG_LIB}.lib)
	endif()

	get_filename_component(LIBDIR_ZLIB ${LIBFILE_ZLIB_DLL} DIRECTORY)
	set(INCLUDEDIR_ZLIB ${EP_BASE}/Source/project_${TARGET_ZLIB})
	ExternalProject_Add(project_${TARGET_PNG}
		DEPENDS project_${TARGET_ZLIB}
		URL ${URL_PNG}
		URL_MD5 ${URL_MD5_PNG}
		CMAKE_ARGS -DCMAKE_BUILD_TYPE=${CONFIGURATION} -DZLIB_LIBRARY=${LIBFILE_ZLIB_LIBDYN} -DZLIB_INCLUDE_DIR=${LIBDIR_ZLIB} ${COMMON_CMAKE_ARGS_PNG} -DSKIP_INSTALL_ALL=1
		BUILD_IN_SOURCE 0
		INSTALL_COMMAND ${CMAKE_COMMAND} -E copy_if_different ${LIBFILE_PNG_NOEXT}.dll ${BINDIR}
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${LIBFILE_PNG_NOEXT}.lib ${LIBDIR}
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${LIBFILE_PNG_LIB} ${LIBDIR}
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${EP_BASE}/Source/project_${TARGET_PNG}/png.h ${INCDIR}/png.h
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${EP_BASE}/Source/project_${TARGET_PNG}/pngconf.h ${INCDIR}/pngconf.h
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${EP_BASE}/Source/project_${TARGET_PNG}/scripts/pnglibconf.h.prebuilt ${INCDIR}/pnglibconf.h 
	)
elseif(APPLE)
	set(FRAMEWORK_DIR_PNG ${DESTINATION_PATH}/${TARGET_PNG}.framework)
	set(DYLIBNAME_PNG libpng16.16.28.0.dylib)

	ExternalProject_Add(project_${TARGET_PNG}
		DEPENDS project_${TARGET_ZLIB}
		URL ${URL_PNG}
		URL_MD5 ${URL_MD5_PNG}
		CMAKE_ARGS -DZLIB_ROOT=${EP_BASE}/Source/project_${TARGET_ZLIB}/include/ ${COMMON_CMAKE_ARGS_PNG}
		BUILD_COMMAND ${PARALLEL_MAKE}
		BUILD_IN_SOURCE 0
		INSTALL_COMMAND ${CMAKE_COMMAND} -E make_directory ${FRAMEWORK_DIR_PNG}/Versions/A
			COMMAND ${CMAKE_COMMAND} -E create_symlink A ${FRAMEWORK_DIR_PNG}/Versions/Current
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${DYLIBNAME_PNG} ${FRAMEWORK_DIR_PNG}/Versions/A/
			COMMAND ${CMAKE_COMMAND} -E create_symlink Versions/Current/${DYLIBNAME_PNG} ${FRAMEWORK_DIR_PNG}/${TARGET_PNG}
			COMMAND install_name_tool -id "@rpath/${TARGET_PNG}.framework/${TARGET_PNG}" ${FRAMEWORK_DIR_PNG}/${TARGET_PNG}
			COMMAND ${CMAKE_COMMAND} -E make_directory ${FRAMEWORK_DIR_PNG}/Versions/A/Headers/
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${EP_BASE}/Source/project_${TARGET_PNG}/png.h ${FRAMEWORK_DIR_PNG}/Versions/A/Headers/
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${EP_BASE}/Source/project_${TARGET_PNG}/pngconf.h ${FRAMEWORK_DIR_PNG}/Versions/A/Headers/
			COMMAND ${CMAKE_COMMAND} -E copy_if_different pnglibconf.h ${FRAMEWORK_DIR_PNG}/Versions/A/Headers/
			COMMAND ${CMAKE_COMMAND} -E create_symlink Versions/Current/Headers ${FRAMEWORK_DIR_PNG}/Headers
	)
else()
	set(ZLIB_INCLUDE_DIR ${DESTINATION_PATH}/include)
	set(ZLIB_LIBRARY ${DESTINATION_PATH}/lib/${LIBNAME_ZLIB}.so)

	ExternalProject_Add(project_${TARGET_PNG}
		DEPENDS project_${TARGET_ZLIB}
		URL ${URL_PNG}
		URL_MD5 ${URL_MD5_PNG}
		CMAKE_ARGS -DZLIB_ROOT=${DESTDIR} ${COMMON_CMAKE_ARGS_PNG} -DCMAKE_INSTALL_PREFIX=${DESTINATION_PATH}
		BUILD_COMMAND ${PARALLEL_MAKE}
		BUILD_IN_SOURCE 0
		INSTALL_COMMAND make install
	)
endif()

if(NOT DEFINED TARGET_ZLIB)
	message(FATAL_ERROR "TARGET_ZLIB is not defined")
endif()

set(TARGET_PNG png)
set(URL_PNG http://downloads.sourceforge.net/project/libpng/libpng16/1.6.47/libpng-1.6.47.tar.gz)
set(URL_MD5_PNG 6b46d508eb5da4d9c98722c69d7e8b67)
set(LIBNAME_PNG libpng16)
set(COMMON_CMAKE_ARGS_PNG -DZLIB_ROOT=${BUILDDIR_ZLIB} -DPNG_TESTS=OFF)
set(BUILDDIR_ZLIB ${EP_BASE}/Build/project_${TARGET_ZLIB})

if(MSVC)
	set(LIBNAME_PNG_LIB libpng16_static) # for static linking
	if(CMAKE_BUILD_TYPE STREQUAL "Debug")
		set(LIBNAME_PNG libpng16d)
		set(LIBNAME_PNG_LIB libpng16_staticd)
	endif()

	if(MSVC_IDE)
		set(LIBFILE_PNG_NOEXT ${CMAKE_BUILD_TYPE}/${LIBNAME_PNG})
		set(LIBFILE_PNG_LIB ${CMAKE_BUILD_TYPE}/${LIBNAME_PNG_LIB}.lib)
	else()
		set(LIBFILE_PNG_NOEXT ${LIBNAME_PNG})
		set(LIBFILE_PNG_LIB ${LIBNAME_PNG_LIB}.lib)
	endif()

	ExternalProject_Add(project_${TARGET_PNG}
		DEPENDS project_${TARGET_ZLIB}
		URL ${URL_PNG}
		URL_MD5 ${URL_MD5_PNG}
		CMAKE_ARGS -DZLIB_LIBRARY=${BUILDDIR_ZLIB}/${LIBFILE_ZLIB_IMPLIB} -DZLIB_INCLUDE_DIR=${BUILDDIR_ZLIB} ${COMMON_CMAKE_ARGS_PNG} -DSKIP_INSTALL_ALL=1
		BUILD_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE} --parallel
		BUILD_IN_SOURCE 0
		INSTALL_COMMAND ${CMAKE_COMMAND} -E copy_if_different ${LIBFILE_PNG_NOEXT}.dll ${BINDIR}/
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${LIBFILE_PNG_NOEXT}.lib ${LIBDIR}/
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${LIBFILE_PNG_LIB} ${LIBDIR}/
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${EP_BASE}/Source/project_${TARGET_PNG}/png.h ${INCDIR}/
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${EP_BASE}/Source/project_${TARGET_PNG}/pngconf.h ${INCDIR}/
			COMMAND ${CMAKE_COMMAND} -E copy_if_different pnglibconf.h ${INCDIR}/
	)
elseif(APPLE)
	set(FRAMEWORK_DIR_PNG ${DESTINATION_PATH}/${TARGET_PNG}.framework)
	if(CMAKE_BUILD_TYPE STREQUAL "Debug")
		set(DYLIBNAME_PNG libpng16d.16.47.0.dylib)
	else()
		set(DYLIBNAME_PNG libpng16.16.47.0.dylib)
	endif()

	ExternalProject_Add(project_${TARGET_PNG}
		DEPENDS project_${TARGET_ZLIB}
		URL ${URL_PNG}
		URL_MD5 ${URL_MD5_PNG}
		CMAKE_ARGS -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} -DZLIB_LIBRARIES=${BUILDDIR_ZLIB}/${DYLIBNAME_ZLIB} -DZLIB_INCLUDE_DIRS=${BUILDDIR_ZLIB} ${COMMON_CMAKE_ARGS_PNG}
		BUILD_COMMAND ${CMAKE_COMMAND} --build . --parallel
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
elseif(NOT EMSCRIPTEN)
	ExternalProject_Add(project_${TARGET_PNG}
		DEPENDS project_${TARGET_ZLIB}
		URL ${URL_PNG}
		URL_MD5 ${URL_MD5_PNG}
		CMAKE_ARGS -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} -DZLIB_LIBRARIES=${BUILDDIR_ZLIB}/${LIBNAME_ZLIB} -DZLIB_INCLUDE_DIRS=${BUILDDIR_ZLIB} ${COMMON_CMAKE_ARGS_PNG} -DCMAKE_INSTALL_PREFIX=${DESTINATION_PATH}
		BUILD_COMMAND ${CMAKE_COMMAND} --build . --parallel
		BUILD_IN_SOURCE 0
		INSTALL_COMMAND make install
	)
endif()

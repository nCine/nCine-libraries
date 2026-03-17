set(TARGET_ZLIB zlib)
set(URL_ZLIB https://www.zlib.net/zlib-1.3.2.tar.gz)
set(URL_MD5_ZLIB a1e6c958597af3c67d162995a342138a)
set(LIBNAME_ZLIB zlib)
set(COMMON_CMAKE_ARGS_ZLIB -DZLIB_BUILD_TESTING=OFF)

if(MSVC)
	set(LIBNAME_ZLIB z)
	set(LIBNAME_ZLIB_LIB zs) # for static linking
	if(CMAKE_BUILD_TYPE STREQUAL "Debug")
		set(LIBNAME_ZLIB zd)
		set(LIBNAME_ZLIB_LIB zsd) # for static linking
	endif()

	if(MSVC_IDE)
		set(LIBFILE_ZLIB_DLL ${CMAKE_BUILD_TYPE}/${LIBNAME_ZLIB}.dll)
		set(LIBFILE_ZLIB_IMPLIB ${CMAKE_BUILD_TYPE}/${LIBNAME_ZLIB}.lib)
		set(LIBFILE_ZLIB_LIB ${CMAKE_BUILD_TYPE}/${LIBNAME_ZLIB_LIB}.lib)
	else()
		set(LIBFILE_ZLIB_DLL ${LIBNAME_ZLIB_DLL}.dll)
		set(LIBFILE_ZLIB_IMPLIB ${LIBNAME_ZLIB_DLL}.lib)
		set(LIBFILE_ZLIB_LIB ${LIBNAME_ZLIB_LIB}.lib)
	endif()

	ExternalProject_Add(project_${TARGET_ZLIB}
		URL ${URL_ZLIB}
		URL_MD5 ${URL_MD5_ZLIB}
		CMAKE_ARGS ${COMMON_CMAKE_ARGS_ZLIB}
		BUILD_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE} --parallel
		BUILD_IN_SOURCE 0
		INSTALL_COMMAND ${CMAKE_COMMAND} -E copy_if_different ${LIBFILE_ZLIB_DLL} ${BINDIR}/${LIBNAME_ZLIB}.dll
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${LIBFILE_ZLIB_IMPLIB} ${LIBDIR}/${LIBNAME_ZLIB}.lib
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${LIBFILE_ZLIB_LIB} ${LIBDIR}/${LIBNAME_ZLIB_LIB}.lib
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${EP_BASE}/Source/project_${TARGET_ZLIB}/zlib.h ${INCDIR}/
			COMMAND ${CMAKE_COMMAND} -E copy_if_different zconf.h ${INCDIR}/

			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${EP_BASE}/Source/project_${TARGET_ZLIB}/zlib.h ${EP_BASE}/Build/project_${TARGET_ZLIB}/ # to build libpng
	)
elseif(APPLE)
	set(FRAMEWORK_DIR_ZLIB ${DESTINATION_PATH}/${TARGET_ZLIB}.framework)
	set(DYLIBNAME_ZLIB libz.1.3.2.dylib)

	ExternalProject_Add(project_${TARGET_ZLIB}
		URL ${URL_ZLIB}
		URL_MD5 ${URL_MD5_ZLIB}
		CMAKE_ARGS -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} -DCMAKE_MACOSX_RPATH=ON ${COMMON_CMAKE_ARGS_ZLIB}
		BUILD_COMMAND ${CMAKE_COMMAND} --build . --parallel
		BUILD_IN_SOURCE 0
		INSTALL_COMMAND ${CMAKE_COMMAND} -E make_directory ${FRAMEWORK_DIR_ZLIB}/Versions/A
			COMMAND ${CMAKE_COMMAND} -E create_symlink A ${FRAMEWORK_DIR_ZLIB}/Versions/Current
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${DYLIBNAME_ZLIB} ${FRAMEWORK_DIR_ZLIB}/Versions/A/
			COMMAND ${CMAKE_COMMAND} -E create_symlink Versions/Current/${DYLIBNAME_ZLIB} ${FRAMEWORK_DIR_ZLIB}/${TARGET_ZLIB}
			COMMAND install_name_tool -id "@rpath/${TARGET_ZLIB}.framework/${TARGET_ZLIB}" ${FRAMEWORK_DIR_ZLIB}/${TARGET_ZLIB}
			COMMAND ${CMAKE_COMMAND} -E make_directory ${FRAMEWORK_DIR_ZLIB}/Versions/A/Headers/
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${EP_BASE}/Source/project_${TARGET_ZLIB}/zlib.h ${FRAMEWORK_DIR_ZLIB}/Versions/A/Headers/
			COMMAND ${CMAKE_COMMAND} -E copy_if_different zconf.h ${FRAMEWORK_DIR_ZLIB}/Versions/A/Headers/
			COMMAND ${CMAKE_COMMAND} -E create_symlink Versions/Current/Headers ${FRAMEWORK_DIR_ZLIB}/Headers

			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${EP_BASE}/Source/project_${TARGET_ZLIB}/zlib.h zlib.h # to build libpng
	)
elseif(NOT EMSCRIPTEN)
	ExternalProject_Add(project_${TARGET_ZLIB}
		URL ${URL_ZLIB}
		URL_MD5 ${URL_MD5_ZLIB}
		CMAKE_ARGS -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} -DCMAKE_INSTALL_PREFIX=${DESTINATION_PATH} ${COMMON_CMAKE_ARGS_ZLIB}
		BUILD_COMMAND ${CMAKE_COMMAND} --build . --parallel
		BUILD_IN_SOURCE 0
		INSTALL_COMMAND make install
	)
endif()

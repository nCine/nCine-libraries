set(TARGET_ZLIB zlib)
set(URL_ZLIB http://downloads.sourceforge.net/project/libpng/zlib/1.2.10/zlib-1.2.10.tar.gz)
set(URL_MD5_ZLIB d9794246f853d15ce0fcbf79b9a3cf13)

if(MSVC)
	set(LIBNAME_ZLIB_DLL zlib1)
	set(LIBNAME_ZLIB_LIBDYN zdll) # for dynamic linking
	set(LIBNAME_ZLIB_LIB zlib) # for static linking
	set(LIBFILE_ZLIB_DLL ${EP_BASE}/Source/project_${TARGET_ZLIB}/${LIBNAME_ZLIB_DLL}.dll)
	set(LIBFILE_ZLIB_LIBDYN ${EP_BASE}/Source/project_${TARGET_ZLIB}/${LIBNAME_ZLIB_LIBDYN}.lib)
	set(LIBFILE_ZLIB_LIB ${EP_BASE}/Source/project_${TARGET_ZLIB}/${LIBNAME_ZLIB_LIB}.lib)

	ExternalProject_Add(project_${TARGET_ZLIB}
		URL ${URL_ZLIB}
		URL_MD5 ${URL_MD5_ZLIB}
		BUILD_COMMAND nmake -f win32/Makefile.msc
		BUILD_IN_SOURCE 1
		INSTALL_COMMAND ${CMAKE_COMMAND} -E copy_if_different ${LIBFILE_ZLIB_DLL} ${BINDIR}
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${LIBFILE_ZLIB_LIBDYN} ${LIBDIR}
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${LIBFILE_ZLIB_LIB} ${LIBDIR}
			COMMAND ${CMAKE_COMMAND} -E copy_if_different zlib.h ${INCDIR}
	)
elseif(APPLE)
	set(FRAMEWORK_DIR_ZLIB ${DESTINATION_PATH}/${TARGET_ZLIB}.framework)
	set(DYLIBNAME_ZLIB libz.1.2.10.dylib)

	ExternalProject_Add(project_${TARGET_ZLIB}
		URL ${URL_ZLIB}
		URL_MD5 ${URL_MD5_ZLIB}
		CONFIGURE_COMMAND ./configure --prefix=
		BUILD_COMMAND ${PARALLEL_MAKE}
		BUILD_IN_SOURCE 1
		INSTALL_COMMAND ${CMAKE_COMMAND} -E make_directory ${FRAMEWORK_DIR_ZLIB}/Versions/A
			COMMAND ${CMAKE_COMMAND} -E create_symlink A ${FRAMEWORK_DIR_ZLIB}/Versions/Current
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${DYLIBNAME_ZLIB} ${FRAMEWORK_DIR_ZLIB}/Versions/A/
			COMMAND ${CMAKE_COMMAND} -E create_symlink Versions/Current/${DYLIBNAME_ZLIB} ${FRAMEWORK_DIR_ZLIB}/${TARGET_ZLIB}
			COMMAND install_name_tool -id "@rpath/${TARGET_ZLIB}.framework/${TARGET_ZLIB}" ${FRAMEWORK_DIR_ZLIB}/${TARGET_ZLIB}
			COMMAND ${CMAKE_COMMAND} -E make_directory ${FRAMEWORK_DIR_ZLIB}/Versions/A/Headers/
			COMMAND ${CMAKE_COMMAND} -E copy_if_different zlib.h ${FRAMEWORK_DIR_ZLIB}/Versions/A/Headers/
			COMMAND ${CMAKE_COMMAND} -E create_symlink Versions/Current/Headers ${FRAMEWORK_DIR_ZLIB}/Headers
	)
else()
	set(LIBNAME_ZLIB libz)

	ExternalProject_Add(project_${TARGET_ZLIB}
		URL ${URL_ZLIB}
		URL_MD5 ${URL_MD5_ZLIB}
		CONFIGURE_COMMAND ./configure --prefix=${DESTINATION_PATH}
		BUILD_COMMAND ${PARALLEL_MAKE}
		BUILD_IN_SOURCE 1
		INSTALL_COMMAND make install
	)
endif()

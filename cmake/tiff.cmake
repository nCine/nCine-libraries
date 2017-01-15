set(TARGET_TIFF tiff)
set(URL_TIFF ftp://ftp.remotesensing.org/pub/libtiff/tiff-4.0.4.zip)
set(URL_MD5_TIFF 8f538a34156188f9a8dcddb679c65d1e)
set(LIBNAME_TIFF libtiff)

if(MSVC)
	set(LIBNAME_TIFF_LIBDYN libtiff_i) # for dynamic linking
	set(LIBFILE_TIFF_NOEXT ${EP_BASE}/Source/project_${TARGET_TIFF}/libtiff/${LIBNAME_TIFF})
	set(LIBFILE_TIFF_LIBDYN ${EP_BASE}/Source/project_${TARGET_TIFF}/libtiff/${LIBNAME_TIFF_LIBDYN}.lib)

	ExternalProject_Add(project_${TARGET_TIFF}
		URL ${URL_TIFF}
		URL_MD5 ${URL_MD5_TIFF}
		CONFIGURE_COMMAND ""
		BUILD_COMMAND nmake -f Makefile.vc
		BUILD_IN_SOURCE 1
		INSTALL_COMMAND ${CMAKE_COMMAND} -E copy_if_different ${LIBFILE_TIFF_NOEXT}.dll ${BINDIR}/
	)
elseif(NOT APPLE)
	ExternalProject_Add(project_${TARGET_TIFF}
		URL ${URL_TIFF}
		URL_MD5 ${URL_MD5_TIFF}
		CONFIGURE_COMMAND ./configure --prefix=
		BUILD_COMMAND ${PARALLEL_MAKE}
		BUILD_IN_SOURCE 1
		INSTALL_COMMAND make DESTDIR=${DESTINATION_PATH} install
	)
endif()

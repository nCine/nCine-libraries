set(TARGET_OGG ogg)
set(URL_OGG http://downloads.xiph.org/releases/ogg/libogg-1.3.5.tar.gz)
set(URL_MD5_OGG 3267127fe8d7ba77d3e00cb9d7ad578d)
set(COMMON_CMAKE_ARGS_OGG -DBUILD_SHARED_LIBS=ON -DINSTALL_DOCS=OFF -DCMAKE_POLICY_VERSION_MINIMUM=3.5)
set(INCLUDE_DIR_OGG ${EP_BASE}/Source/project_${TARGET_OGG}/include)

if(MSVC)
	set(LIBNAME_OGG ogg)
	set(LIBFILE_OGG_NOEXT ${CMAKE_BUILD_TYPE}/${LIBNAME_OGG})

	ExternalProject_Add(project_${TARGET_OGG}
		URL ${URL_OGG}
		URL_MD5 ${URL_MD5_OGG}
		CMAKE_ARGS ${COMMON_CMAKE_ARGS_OGG}
		BUILD_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE} --parallel
		BUILD_IN_SOURCE 0
		INSTALL_COMMAND ${CMAKE_COMMAND} -E copy_if_different ${LIBFILE_OGG_NOEXT}.dll ${BINDIR}/
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${LIBFILE_OGG_NOEXT}.lib ${LIBDIR}/
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${INCLUDE_DIR_OGG}/ogg/ogg.h ${INCDIR}/ogg/ogg.h
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${INCLUDE_DIR_OGG}/ogg/os_types.h ${INCDIR}/ogg/os_types.h
			COMMAND ${CMAKE_COMMAND} -E copy_if_different include/ogg/config_types.h ${INCDIR}/ogg/config_types.h
	)
elseif(APPLE)
	set(FRAMEWORK_DIR_OGG ${DESTINATION_PATH}/${TARGET_OGG}.framework)
	set(DYLIBNAME_OGG libogg.0.dylib)
	set(DYLIBNAME_VERSIONED_OGG libogg.0.8.5.dylib)

	ExternalProject_Add(project_${TARGET_OGG}
		URL ${URL_OGG}
		URL_MD5 ${URL_MD5_OGG}
		CMAKE_ARGS -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} ${COMMON_CMAKE_ARGS_OGG}
		BUILD_COMMAND ${CMAKE_COMMAND} --build . --parallel
		BUILD_IN_SOURCE 0
		INSTALL_COMMAND ${CMAKE_COMMAND} -E make_directory ${FRAMEWORK_DIR_OGG}/Versions/A
			COMMAND ${CMAKE_COMMAND} -E create_symlink A ${FRAMEWORK_DIR_OGG}/Versions/Current
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${DYLIBNAME_VERSIONED_OGG} ${FRAMEWORK_DIR_OGG}/Versions/A/
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${DYLIBNAME_OGG} ${FRAMEWORK_DIR_OGG}/Versions/A/
			COMMAND ${CMAKE_COMMAND} -E create_symlink Versions/Current/${DYLIBNAME_OGG} ${FRAMEWORK_DIR_OGG}/${TARGET_OGG}
			COMMAND install_name_tool -id "@rpath/${TARGET_OGG}.framework/${TARGET_OGG}" ${FRAMEWORK_DIR_OGG}/${TARGET_OGG}
			COMMAND ${CMAKE_COMMAND} -E make_directory ${FRAMEWORK_DIR_OGG}/Versions/A/Headers/
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${INCLUDE_DIR_OGG}/ogg/ogg.h ${FRAMEWORK_DIR_OGG}/Versions/A/Headers/
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${INCLUDE_DIR_OGG}/ogg/os_types.h ${FRAMEWORK_DIR_OGG}/Versions/A/Headers/
			COMMAND ${CMAKE_COMMAND} -E copy_if_different include/ogg/config_types.h ${FRAMEWORK_DIR_OGG}/Versions/A/Headers/
			COMMAND ${CMAKE_COMMAND} -E create_symlink Versions/Current/Headers ${FRAMEWORK_DIR_OGG}/Headers
	)
elseif(NOT EMSCRIPTEN)
	ExternalProject_Add(project_${TARGET_OGG}
		URL ${URL_OGG}
		URL_MD5 ${URL_MD5_OGG}
		CMAKE_ARGS -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} ${COMMON_CMAKE_ARGS_OGG} -DCMAKE_INSTALL_PREFIX=${DESTINATION_PATH}
		BUILD_COMMAND ${CMAKE_COMMAND} --build . --parallel
		BUILD_IN_SOURCE 0
		INSTALL_COMMAND make install
	)
endif()

set(TARGET_BOX2D box2d)
set(URL_BOX2D https://github.com/erincatto/box2d/archive/v3.0.0.tar.gz)
set(URL_MD5_BOX2D ad0d1f85461cbbb98d6f7c71fe831a46)
set(COMMON_CMAKE_ARGS_BOX2D -DBOX2D_SAMPLES=OFF -DBOX2D_UNIT_TESTS=OFF -DBOX2D_DOCS=OFF)
set(PROJECT_SRC_BOX2D ${EP_BASE}/Source/project_${TARGET_BOX2D})
set(PROJECT_BUILD_BOX2D ${EP_BASE}/Build/project_${TARGET_BOX2D})

if(MSVC)
	set(LIBNAME_BOX2D box2d)

	ExternalProject_Add(project_${TARGET_BOX2D}
		URL ${URL_BOX2D}
		URL_MD5 ${URL_MD5_BOX2D}
		CMAKE_ARGS ${COMMON_CMAKE_ARGS_BOX2D} -DBUILD_SHARED_LIBS=ON
		BUILD_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE} --parallel
		BUILD_IN_SOURCE 0
		INSTALL_COMMAND ${CMAKE_COMMAND} -E copy_if_different ${EP_BASE}/Build/project_${TARGET_BOX2D}/bin/${CMAKE_BUILD_TYPE}/${LIBNAME_BOX2D}.dll ${BINDIR}/
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${EP_BASE}/Build/project_${TARGET_BOX2D}/src/${CMAKE_BUILD_TYPE}/${LIBNAME_BOX2D}.lib ${LIBDIR}/
			COMMAND ${CMAKE_COMMAND} -E copy_directory ${EP_BASE}/Source/project_${TARGET_BOX2D}/include/box2d ${INCDIR}/box2d
	)
elseif(APPLE)
	set(FRAMEWORK_DIR_BOX2D ${DESTINATION_PATH}/${TARGET_BOX2D}.framework)
	set(DYLIBNAME_BOX2D libbox2d.3.0.0.dylib)

	ExternalProject_Add(project_${TARGET_BOX2D}
		URL ${URL_BOX2D}
		URL_MD5 ${URL_MD5_BOX2D}
		CMAKE_ARGS -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} ${COMMON_CMAKE_ARGS_BOX2D} -DBUILD_SHARED_LIBS=ON
		BUILD_COMMAND ${CMAKE_COMMAND} --build . --parallel
		BUILD_IN_SOURCE 0
		INSTALL_COMMAND ${CMAKE_COMMAND} -E make_directory ${FRAMEWORK_DIR_BOX2D}/Versions/A
			COMMAND ${CMAKE_COMMAND} -E create_symlink A ${FRAMEWORK_DIR_BOX2D}/Versions/Current
			COMMAND ${CMAKE_COMMAND} -E copy_if_different src/${DYLIBNAME_BOX2D} ${FRAMEWORK_DIR_BOX2D}/Versions/A/
			COMMAND ${CMAKE_COMMAND} -E create_symlink Versions/Current/${DYLIBNAME_BOX2D} ${FRAMEWORK_DIR_BOX2D}/${TARGET_BOX2D}
			COMMAND install_name_tool -id "@rpath/${TARGET_BOX2D}.framework/${TARGET_BOX2D}" ${FRAMEWORK_DIR_BOX2D}/${TARGET_BOX2D}
			COMMAND ${CMAKE_COMMAND} -E make_directory ${FRAMEWORK_DIR_BOX2D}/Versions/A/Headers/
			COMMAND ${CMAKE_COMMAND} -E copy_directory ${EP_BASE}/Source/project_${TARGET_BOX2D}/include/box2d ${FRAMEWORK_DIR_BOX2D}/Versions/A/Headers/box2d
			COMMAND ${CMAKE_COMMAND} -E create_symlink Versions/Current/Headers ${FRAMEWORK_DIR_BOX2D}/Headers
	)
elseif(EMSCRIPTEN)
	ExternalProject_Add(project_${TARGET_BOX2D}
		URL ${URL_BOX2D}
		URL_MD5 ${URL_MD5_BOX2D}
		CMAKE_COMMAND emcmake ${CMAKE_COMMAND} -G ${CMAKE_GENERATOR}
		CMAKE_ARGS -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} ${COMMON_CMAKE_ARGS_BOX2D} -DBUILD_SHARED_LIBS=OFF
		BUILD_COMMAND ${CMAKE_COMMAND} --build . --parallel
		BUILD_IN_SOURCE 0
		INSTALL_COMMAND COMMAND ${CMAKE_COMMAND} -E copy_if_different ${PROJECT_BUILD_BOX2D}/src/libbox2d.a ${DESTINATION_PATH}/lib/libbox2d.a
			COMMAND ${CMAKE_COMMAND} -E copy_directory ${PROJECT_SRC_BOX2D}/include/box2d ${DESTINATION_PATH}/include/box2d
	)
else()
	ExternalProject_Add(project_${TARGET_BOX2D}
		URL ${URL_BOX2D}
		URL_MD5 ${URL_MD5_BOX2D}
		CMAKE_ARGS -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} ${COMMON_CMAKE_ARGS_BOX2D} -DBUILD_SHARED_LIBS=ON -DCMAKE_INSTALL_PREFIX=${DESTINATION_PATH}
		BUILD_COMMAND ${CMAKE_COMMAND} --build . --parallel
		BUILD_IN_SOURCE 0
		INSTALL_COMMAND make install
			COMMAND ${CMAKE_COMMAND} -E copy_directory ${PROJECT_SRC_BOX2D}/include/box2d ${DESTINATION_PATH}/include/box2d
	)
endif()

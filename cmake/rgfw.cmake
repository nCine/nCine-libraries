set(TARGET_RGFW rgfw)
set(URL_RGFW https://github.com/ColleagueRiley/RGFW/archive/refs/tags/1.8.1.zip)
set(URL_MD5_RGFW f9578656409afc2e3a7cb3450c7daf56)
set(PROJECT_SRC_RGFW ${EP_BASE}/Source/project_${TARGET_RGFW})
set(PROJECT_BUILD_RGFW ${EP_BASE}/Build/project_${TARGET_RGFW})

if(MSVC)
	ExternalProject_Add(project_${TARGET_RGFW}
		URL ${URL_RGFW}
		URL_MD5 ${URL_MD5_RGFW}
		PATCH_COMMAND ${CMAKE_COMMAND} -E copy_if_different ${CMAKE_SOURCE_DIR}/patches/CMakeLists_rgfw.txt ${PROJECT_SRC_RGFW}/CMakeLists.txt
		BUILD_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE} --parallel
		BUILD_IN_SOURCE 0
		INSTALL_COMMAND ${CMAKE_COMMAND} -E copy_if_different ${PROJECT_BUILD_RGFW}/${CMAKE_BUILD_TYPE}/RGFW.dll ${BINDIR}/RGFW.dll
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${PROJECT_BUILD_RGFW}/${CMAKE_BUILD_TYPE}/RGFW.dll.lib ${LIBDIR}/RGFW.dll.lib
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${PROJECT_BUILD_RGFW}/${CMAKE_BUILD_TYPE}/RGFW.lib ${LIBDIR}/RGFW.lib
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${PROJECT_SRC_RGFW}/RGFW.h ${INCDIR}/RGFW.h
	)
elseif(APPLE)
	set(FRAMEWORK_DIR_RGFW ${DESTINATION_PATH}/${TARGET_RGFW}.framework)

	ExternalProject_Add(project_${TARGET_RGFW}
		URL ${URL_RGFW}
		URL_MD5 ${URL_MD5_RGFW}
		PATCH_COMMAND ${CMAKE_COMMAND} -E copy_if_different ${CMAKE_SOURCE_DIR}/patches/CMakeLists_rgfw.txt ${PROJECT_SRC_RGFW}/CMakeLists.txt
		CMAKE_ARGS -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
		BUILD_COMMAND ${CMAKE_COMMAND} --build . --parallel
		BUILD_IN_SOURCE 0
		INSTALL_COMMAND ${CMAKE_COMMAND} -E make_directory ${FRAMEWORK_DIR_RGFW}/Versions/A
			COMMAND ${CMAKE_COMMAND} -E create_symlink A ${FRAMEWORK_DIR_RGFW}/Versions/Current
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${PROJECT_BUILD_RGFW}/libRGFW.dylib ${FRAMEWORK_DIR_RGFW}/Versions/A/
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${PROJECT_BUILD_RGFW}/libRGFW.a ${FRAMEWORK_DIR_RGFW}/Versions/A/
			COMMAND ${CMAKE_COMMAND} -E create_symlink Versions/Current/libRGFW.dylib ${FRAMEWORK_DIR_RGFW}/${TARGET_RGFW}
			COMMAND install_name_tool -id "@rpath/${TARGET_RGFW}.framework/${TARGET_RGFW}" ${FRAMEWORK_DIR_RGFW}/${TARGET_RGFW}
			COMMAND ${CMAKE_COMMAND} -E make_directory ${FRAMEWORK_DIR_RGFW}/Versions/A/Headers
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${PROJECT_SRC_RGFW}/RGFW.h ${FRAMEWORK_DIR_RGFW}/Versions/A/Headers/
			COMMAND ${CMAKE_COMMAND} -E create_symlink Versions/Current/Headers ${FRAMEWORK_DIR_RGFW}/Headers
	)
elseif(EMSCRIPTEN)
	ExternalProject_Add(project_${TARGET_RGFW}
		URL ${URL_RGFW}
		URL_MD5 ${URL_MD5_RGFW}
		PATCH_COMMAND ${CMAKE_COMMAND} -E copy_if_different ${CMAKE_SOURCE_DIR}/patches/CMakeLists_rgfw.txt ${PROJECT_SRC_RGFW}/CMakeLists.txt
		CMAKE_COMMAND emcmake ${CMAKE_COMMAND} -G ${CMAKE_GENERATOR}
		CMAKE_ARGS -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
		BUILD_COMMAND ${CMAKE_COMMAND} --build . --parallel
		BUILD_IN_SOURCE 0
		INSTALL_COMMAND COMMAND ${CMAKE_COMMAND} -E copy_if_different ${PROJECT_BUILD_RGFW}/libRGFW.a ${DESTINATION_PATH}/lib/libRGFW.a
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${PROJECT_SRC_RGFW}/RGFW.h ${DESTINATION_PATH}/include/RGFW.h
	)
elseif(MINGW)
	ExternalProject_Add(project_${TARGET_RGFW}
		URL ${URL_RGFW}
		URL_MD5 ${URL_MD5_RGFW}
		PATCH_COMMAND ${CMAKE_COMMAND} -E copy_if_different ${CMAKE_SOURCE_DIR}/patches/CMakeLists_rgfw.txt ${PROJECT_SRC_RGFW}/CMakeLists.txt
		CMAKE_ARGS -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
		BUILD_COMMAND ${CMAKE_COMMAND} --build . --parallel
		BUILD_IN_SOURCE 0
		INSTALL_COMMAND ${CMAKE_COMMAND} -E copy_if_different ${PROJECT_BUILD_RGFW}/libRGFW.dll ${DESTINATION_PATH}/bin/libRGFW.dll
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${PROJECT_BUILD_RGFW}/libRGFW.dll.a ${DESTINATION_PATH}/lib/libRGFW.dll.a
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${PROJECT_BUILD_RGFW}/libRGFW.a ${DESTINATION_PATH}/lib/libRGFW.a
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${PROJECT_SRC_RGFW}/RGFW.h ${DESTINATION_PATH}/include/RGFW.h
	)
else()
	ExternalProject_Add(project_${TARGET_RGFW}
		URL ${URL_RGFW}
		URL_MD5 ${URL_MD5_RGFW}
		PATCH_COMMAND ${CMAKE_COMMAND} -E copy_if_different ${CMAKE_SOURCE_DIR}/patches/CMakeLists_rgfw.txt ${PROJECT_SRC_RGFW}/CMakeLists.txt
		CMAKE_ARGS -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
		BUILD_COMMAND ${CMAKE_COMMAND} --build . --parallel
		BUILD_IN_SOURCE 0
		INSTALL_COMMAND ${CMAKE_COMMAND} -E copy_if_different ${PROJECT_BUILD_RGFW}/libRGFW.so ${DESTINATION_PATH}/lib/libRGFW.so
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${PROJECT_BUILD_RGFW}/libRGFW.a ${DESTINATION_PATH}/lib/libRGFW.a
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${PROJECT_SRC_RGFW}/RGFW.h ${DESTINATION_PATH}/include/RGFW.h
	)
endif()

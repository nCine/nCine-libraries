if(NOT DEFINED TARGET_OGG)
	message(FATAL_ERROR "TARGET_OGG is not defined")
endif()

set(TARGET_VORBIS vorbis)
set(URL_VORBIS http://downloads.xiph.org/releases/vorbis/libvorbis-1.3.7.tar.gz)
set(URL_MD5_VORBIS 9b8034da6edc1a17d18b9bc4542015c7)
set(COMMON_CMAKE_ARGS_VORBIS -DBUILD_SHARED_LIBS=ON -DCMAKE_POLICY_VERSION_MINIMUM=3.5)
set(INCLUDE_DIR_VORBIS ${EP_BASE}/Source/project_${TARGET_VORBIS}/include)
set(TARGET_VORBISFILE vorbisfile)

if(MSVC)
	set(LIBNAME_VORBIS vorbis)
	set(LIBNAME_VORBISFILE vorbisfile)
	set(LIBFILE_VORBIS_NOEXT lib/${CMAKE_BUILD_TYPE}/${LIBNAME_VORBIS})
	set(LIBFILE_VORBISFILE_NOEXT lib/${CMAKE_BUILD_TYPE}/${LIBNAME_VORBISFILE})

	get_filename_component(LIBDIR_OGG ${LIBFILE_OGG_NOEXT}.dll DIRECTORY)
	ExternalProject_Add(project_${TARGET_VORBIS}
		DEPENDS project_${TARGET_OGG}
		URL ${URL_VORBIS}
		URL_MD5 ${URL_MD5_VORBIS}
		# Clearing `CMAKE_FIND_ROOT_PATH` to build with MSVC under MSYS/MinGW
		CMAKE_ARGS -DOGG_LIBRARY=${EP_BASE}/Build/project_${TARGET_OGG}/${LIBFILE_OGG_NOEXT}.lib -DOGG_INCLUDE_DIR=${EP_BASE}/Source/project_${TARGET_OGG}/include -DCMAKE_FIND_ROOT_PATH="" ${COMMON_CMAKE_ARGS_VORBIS}
		BUILD_COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE} --parallel
		BUILD_IN_SOURCE 0
		INSTALL_COMMAND ${CMAKE_COMMAND} -E copy_if_different ${LIBFILE_VORBIS_NOEXT}.dll ${BINDIR}/
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${LIBFILE_VORBIS_NOEXT}.lib ${LIBDIR}/
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${INCLUDE_DIR_VORBIS}/vorbis/codec.h ${INCDIR}/vorbis/codec.h
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${INCLUDE_DIR_VORBIS}/vorbis/vorbisenc.h ${INCDIR}/vorbis/vorbisenc.h

			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${LIBFILE_VORBISFILE_NOEXT}.dll ${BINDIR}/
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${LIBFILE_VORBISFILE_NOEXT}.lib ${LIBDIR}/
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${INCLUDE_DIR_VORBIS}/vorbis/vorbisfile.h ${INCDIR}/vorbis/vorbisfile.h
	)
elseif(APPLE)
	set(FRAMEWORK_DIR_VORBIS ${DESTINATION_PATH}/${TARGET_VORBIS}.framework)
	set(DYLIBNAME_VORBIS libvorbis.dylib)
	set(DYLIBNAME_VERSIONED_VORBIS libvorbis.0.4.9.dylib)
	set(FRAMEWORK_DIR_VORBISFILE ${DESTINATION_PATH}/${TARGET_VORBISFILE}.framework)
	set(DYLIBNAME_VORBISFILE libvorbisfile.dylib)
	set(DYLIBNAME_VERSIONED_VORBISFILE libvorbisfile.3.3.8.dylib)

	ExternalProject_Add(project_${TARGET_VORBIS}
		DEPENDS project_${TARGET_OGG}
		URL ${URL_VORBIS}
		URL_MD5 ${URL_MD5_VORBIS}
		CMAKE_ARGS -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} -DOGG_LIBRARY=${EP_BASE}/Build/project_${TARGET_OGG}/${DYLIBNAME_OGG} -DOGG_INCLUDE_DIR=${EP_BASE}/Source/project_${TARGET_OGG}/include ${COMMON_CMAKE_ARGS_VORBIS}
		BUILD_COMMAND ${CMAKE_COMMAND} --build .  --parallel
		BUILD_IN_SOURCE 0
		INSTALL_COMMAND ${CMAKE_COMMAND} -E make_directory ${FRAMEWORK_DIR_VORBIS}/Versions/A
			COMMAND ${CMAKE_COMMAND} -E create_symlink A ${FRAMEWORK_DIR_VORBIS}/Versions/Current
			COMMAND ${CMAKE_COMMAND} -E copy_if_different lib/${DYLIBNAME_VORBIS} ${FRAMEWORK_DIR_VORBIS}/Versions/A/
			COMMAND ${CMAKE_COMMAND} -E create_symlink Versions/Current/${DYLIBNAME_VERSIONED_VORBIS} ${FRAMEWORK_DIR_VORBIS}/${TARGET_VORBIS}
			COMMAND ${CMAKE_COMMAND} -E create_symlink Versions/Current/${DYLIBNAME_VORBIS} ${FRAMEWORK_DIR_VORBIS}/${TARGET_VORBIS}
			COMMAND install_name_tool -id "@rpath/${TARGET_VORBIS}.framework/${TARGET_VORBIS}" ${FRAMEWORK_DIR_VORBIS}/${TARGET_VORBIS}
			COMMAND sh -c "install_name_tool -change $(otool -L ${FRAMEWORK_DIR_VORBIS}/${TARGET_VORBIS} | grep ${DYLIBNAME_OGG} | cut -f2 | cut -d \" \" -f1) \"@rpath/${TARGET_OGG}.framework/${TARGET_OGG}\" ${FRAMEWORK_DIR_VORBIS}/${TARGET_VORBIS}"
			COMMAND ${CMAKE_COMMAND} -E make_directory ${FRAMEWORK_DIR_VORBIS}/Versions/A/Headers/
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${INCLUDE_DIR_VORBIS}/vorbis/codec.h ${FRAMEWORK_DIR_VORBIS}/Versions/A/Headers/
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${INCLUDE_DIR_VORBIS}/vorbis/vorbisenc.h ${FRAMEWORK_DIR_VORBIS}/Versions/A/Headers/
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${INCLUDE_DIR_VORBIS}/vorbis/vorbisfile.h ${FRAMEWORK_DIR_VORBIS}/Versions/A/Headers/ # needed here too
			COMMAND ${CMAKE_COMMAND} -E create_symlink Versions/Current/Headers ${FRAMEWORK_DIR_VORBIS}/Headers

			COMMAND ${CMAKE_COMMAND} -E make_directory ${FRAMEWORK_DIR_VORBISFILE}/Versions/A
			COMMAND ${CMAKE_COMMAND} -E create_symlink A ${FRAMEWORK_DIR_VORBISFILE}/Versions/Current
			COMMAND ${CMAKE_COMMAND} -E copy_if_different lib/${DYLIBNAME_VERSIONED_VORBISFILE} ${FRAMEWORK_DIR_VORBISFILE}/Versions/A/
			COMMAND ${CMAKE_COMMAND} -E copy_if_different lib/${DYLIBNAME_VORBISFILE} ${FRAMEWORK_DIR_VORBISFILE}/Versions/A/
			COMMAND ${CMAKE_COMMAND} -E create_symlink Versions/Current/${DYLIBNAME_VORBISFILE} ${FRAMEWORK_DIR_VORBISFILE}/${TARGET_VORBISFILE}
			COMMAND install_name_tool -id "@rpath/${TARGET_VORBISFILE}.framework/${TARGET_VORBISFILE}" ${FRAMEWORK_DIR_VORBISFILE}/${TARGET_VORBISFILE}
			COMMAND sh -c "install_name_tool -change $(otool -L ${FRAMEWORK_DIR_VORBISFILE}/${TARGET_VORBISFILE} | grep ${DYLIBNAME_VERSIONED_VORBIS} | cut -f2 | cut -d ' ' -f1) \"@rpath/${TARGET_VORBIS}.framework/${TARGET_VORBIS}\" ${FRAMEWORK_DIR_VORBISFILE}/${TARGET_VORBISFILE}"
			COMMAND sh -c "install_name_tool -change $(otool -L ${FRAMEWORK_DIR_VORBISFILE}/${TARGET_VORBISFILE} | grep ${DYLIBNAME_OGG} | cut -f2 | cut -d ' ' -f1) \"@rpath/${TARGET_OGG}.framework/${TARGET_OGG}\" ${FRAMEWORK_DIR_VORBISFILE}/${TARGET_VORBISFILE}"
			COMMAND ${CMAKE_COMMAND} -E make_directory ${FRAMEWORK_DIR_VORBISFILE}/Versions/A/Headers/
			COMMAND ${CMAKE_COMMAND} -E copy_if_different ${INCLUDE_DIR_VORBIS}/vorbis/vorbisfile.h ${FRAMEWORK_DIR_VORBISFILE}/Versions/A/Headers/
			COMMAND ${CMAKE_COMMAND} -E create_symlink Versions/Current/Headers ${FRAMEWORK_DIR_VORBISFILE}/Headers
	)
elseif(NOT EMSCRIPTEN)
	if(MINGW)
		set(MINGW_PATCH_COMMAND patch -p1 < ${CMAKE_SOURCE_DIR}/patches/vorbis_mingw.patch)
	endif()

	ExternalProject_Add(project_${TARGET_VORBIS}
		DEPENDS project_${TARGET_OGG}
		URL ${URL_VORBIS}
		URL_MD5 ${URL_MD5_VORBIS}
		PATCH_COMMAND ${MINGW_PATCH_COMMAND}
		CMAKE_ARGS -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} -DOGG_ROOT=${DESTINATION_PATH} ${COMMON_CMAKE_ARGS_VORBIS} -DCMAKE_INSTALL_PREFIX=${DESTINATION_PATH}
		BUILD_COMMAND ${CMAKE_COMMAND} --build . --parallel
		BUILD_IN_SOURCE 0
		INSTALL_COMMAND make install
	)
endif()

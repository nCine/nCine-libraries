file(STRINGS ${CMAKELISTS_TXT_FILE} CMAKELISTS_TXT_STRINGS NEWLINE_CONSUME)
file(WRITE ${CMAKELISTS_TXT_FILE} "")
foreach(CMAKELISTS_TXT_STRING ${CMAKELISTS_TXT_STRINGS})
	string(REPLACE
		"  target_link_libraries (glew LINK_PRIVATE -nodefaultlib -noentry)"
		"  target_link_libraries (glew LINK_PRIVATE -nodefaultlib -noentry libvcruntime.lib msvcrt.lib)"
		CMAKELISTS_TXT_STRING "${CMAKELISTS_TXT_STRING}")
	file(APPEND ${CMAKELISTS_TXT_FILE} "${CMAKELISTS_TXT_STRING}\n")
endforeach()

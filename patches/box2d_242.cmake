file(STRINGS ${CMAKELISTS_TXT_FILE} CMAKELISTS_TXT_STRINGS NEWLINE_CONSUME)
file(WRITE ${CMAKELISTS_TXT_FILE} "")
foreach(CMAKELISTS_TXT_STRING ${CMAKELISTS_TXT_STRINGS})
	string(REPLACE
		"project(box2d VERSION 2.4.1)"
		"project(box2d VERSION 2.4.2)"
		CMAKELISTS_TXT_STRING "${CMAKELISTS_TXT_STRING}")
	file(APPEND ${CMAKELISTS_TXT_FILE} "${CMAKELISTS_TXT_STRING}\n")
endforeach()

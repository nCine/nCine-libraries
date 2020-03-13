file(STRINGS ${CMAKELISTS_TXT_FILE} CMAKELISTS_TXT_STRINGS NEWLINE_CONSUME)
file(WRITE ${CMAKELISTS_TXT_FILE} "")
foreach(CMAKELISTS_TXT_STRING ${CMAKELISTS_TXT_STRINGS})
	string(REPLACE
		" list(APPEND EXTRA_LIBS user32 gdi32 winmm imm32 ole32 oleaut32 version uuid advapi32 setupapi shell32)"
		" list(APPEND EXTRA_LIBS vcruntime user32 gdi32 winmm imm32 ole32 oleaut32 version uuid advapi32 setupapi shell32)"
		CMAKELISTS_TXT_STRING "${CMAKELISTS_TXT_STRING}")
	file(APPEND ${CMAKELISTS_TXT_FILE} "${CMAKELISTS_TXT_STRING}\n")
endforeach()

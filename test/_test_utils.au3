#include-once
#include <File.au3>

Func get_test_data_path($file_or_dirname_path)
	$file_or_dirname_path = StringReplace($file_or_dirname_path, "/", "\")

	If FileExists($file_or_dirname_path) Then
		Return _PathFull($file_or_dirname_path)
	EndIf

	Local $parents = _Mediapipe_ObjCreate("VectorOfString")

	If FileExists(EnvGet("TEST_SRCDIR")) Then
		$parents.Add(EnvGet("TEST_SRCDIR"))
	EndIf

	Local Static $_TEST_SRCDIR = _Mediapipe_FindFile("autoit-mediapipe-com\build_x64\mediapipe-src\mediapipe\tasks\testdata")
	If FileExists($_TEST_SRCDIR) Then
		$parents.Add($_TEST_SRCDIR)
	EndIf

	Local Static $_TEST_DATA_DIR = _Mediapipe_FindResourceDir() & "\mediapipe\tasks\testdata"
	If FileExists($_TEST_DATA_DIR) Then
		$parents.Add($_TEST_DATA_DIR)
	EndIf

	Local $iLen = StringLen($file_or_dirname_path)
	Local $sPath, $aFileList

	For $sParent In $parents
		$aFileList = _FileListToArray($sParent)

		For $j = 1 To $aFileList[0]
			$sPath = _PathFull($sParent & "\" & $aFileList[$j])

			If FileExists($sPath & "\" & $file_or_dirname_path) Then
				Return $sPath & "\" & $file_or_dirname_path
			EndIf

			If StringRight($sPath, $iLen + 1) == "\" & $file_or_dirname_path Then
				Return $sPath
			EndIf
		Next
	Next

	Return SetError(1, 0, $file_or_dirname_path)
EndFunc   ;==>get_test_data_path

Func read_file_into_buffer($file_path)
	Local $f = FileOpen($file_path, $FO_BINARY)
	Local $data = FileRead($f)
	Local $nread = @extended
	FileClose($f)

	Local $sStruct = "byte data[" & $nread & "]"
	Local $bytes = DllStructCreate($sStruct)
	$bytes.data = $data

	Return _Mediapipe_ObjCreate("autoit.Buffer").create(DllStructGetPtr($bytes), $nread)
EndFunc   ;==>read_file_into_buffer

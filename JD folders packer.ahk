; Упаковка (перемещение) папок AC.ID в заголовочные вида AC.N0 и обратно
isRu := A_Language=00419

; Четыре режима
If isRu
	modes := {0: "Упаковать всё"
	, 1: "Упаковать пустые"
	, 2: "Распаковать всё"
	, 3: "Распаковать непустые"}
else
	modes := {0: "Pack all"
	, 1: "Pack empty"
	, 2: "Unpack all"
	, 3: "Unpack non empty"}

mode := 0

If A_Args.Length() > 0
	mode := A_Args[1]

If A_Args.Length() > 1
{
	title := modes[mode]
	MsgBox, 33, %title%, %A_WorkingDir%
	IfMsgBox, Cancel, ExitApp
}

Loop Files, %A_WorkingDir%\*, D
	If A_LoopFileName ~= "^\d\d\.\d0"
		Switch mode
		{
			Case 0, 1:
			n := SubStr(A_LoopFileName, 4, 1)
			f := A_LoopFileName
			Loop Files, %A_WorkingDir%\*, D
			{
				s1 := "^\d\d\." . n . "\d"
				s2 := "^\d\d\." . n . "[^0]"
				d := f . "/" . A_LoopFileName
				If A_LoopFileName ~= s1 and A_LoopFileName ~= s2
					If (mode = 0) or (mode = 1 and GetSize(A_LoopFileName) = 0)
						FileMoveDir, %A_LoopFileName%, %d%, R
			}

			Case 2, 3:
			Loop Files, %A_LoopFileName%\*, D
			{
				d := A_WorkingDir . "/" . A_LoopFileName
				If (mode = 2) or (mode = 3 and GetSize(A_LoopFileFullPath) > 0)
					FileMoveDir, %A_LoopFileFullPath%, %d%, R
			}
		}


GetSize(path)
{
	return FileExist(path) ? ComObjCreate("Scripting.FileSystemObject").GetFolder(path).Size : false
}

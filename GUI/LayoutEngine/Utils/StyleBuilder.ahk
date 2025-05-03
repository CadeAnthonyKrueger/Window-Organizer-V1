#Requires AutoHotkey v2.0

#Include ./StyleMapper.ahk

class StyleBuilder {

    static styleMapper := StyleMapper()

    static Build(name, styleSheet) {
        styleMap := StyleBuilder.IniToObject(name, styleSheet)
        for key, value in styleMap {
            StyleBuilder.styleMapper.Add(key, value)
        }
        return StyleBuilder.styleMapper.GetStyleObject()
    }

    static IniToObject(name, styleSheet) {
        result := Map()
        inSection := false
        Loop Read, styleSheet {
            line := Trim(A_LoopReadLine)
            if line = "" || SubStr(line, 1, 1) = ";"
                continue
            if RegExMatch(line, "^\[(.+)\]$", &match) {
                inSection := (match[1] = name)
                continue
            }
            if inSection && RegExMatch(line, "^(.*?)=(.*)$", &kv) {
                key := Trim(kv[1])
                value := Trim(kv[2])
                result[key] := value
            } else if inSection && RegExMatch(line, "^\[.+\]$") {
                break
            }
        }
        return result
    }
}

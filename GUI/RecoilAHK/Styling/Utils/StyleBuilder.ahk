#Requires AutoHotkey v2.0

#Include ./StyleMapper.ahk

class StyleBuilder {

    static styleMapper := StyleMapper()

    static Build(name, styleSheet, inlineStyle) {
        styleMap := StyleBuilder.IniToObject(name, styleSheet)
        ; StyleBuilder.PrintMap(styleMap)
        ; StyleBuilder.PrintMap({ backgroundColor: "0xffffff", display: "none"})
        for key, value in styleMap {
            StyleBuilder.styleMapper.Add(key, value)
        }
        if inlineStyle != "" {
            for key in ObjOwnProps(inlineStyle) {
                StyleBuilder.styleMapper.Add(key, inlineStyle.%key%)
            }
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

    static PrintMap(map) {
        output := ""
        if Type(map) != "Map" {
            map := ObjOwnProps(map)
        }
        for key, value in map {
            output .= key " => " value "`n"
        }
        MsgBox output
    }
}

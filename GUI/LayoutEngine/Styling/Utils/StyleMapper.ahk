#Requires AutoHotkey v2.0

#Include ../Core/StyleAspect.ahk
#Include ../Core/Style.ahk

class StyleMapper {

    static styleAspects := Map(
        "Dimension", Map("styles", ["x", "y", "w", "h"], "classRef", Dimension),
        "Alignment", Map("styles", ["display", "flexDirection", "justify", "align"], "classRef", Alignment),
        "Appearance", Map("styles", ["backgroundColor", "color"], "classRef", Appearance)
    )

    static GetClassName(key) {
        for className, aspects in StyleMapper.styleAspects {
            keyInAspects := false
            for style in aspects["styles"] {
                if style = key {
                    keyInAspects := true
                    break
                }
            }
            if keyInAspects {
                return className
            }
        }
        return ""
    }

    __New() {
        this.styleMap := Map(
            "Dimension", Map(),
            "Alignment", Map(),
            "Appearance", Map()
        )
    }

    Add(key, value) {
        className := StyleMapper.GetClassName(key)
        if (className != "") {
            this.styleMap[className][key] := value
        }
    }

    GetStyleObject() {
        dimension := StyleMapper.styleAspects["Dimension"]["classRef"].FromMap(this.styleMap["Dimension"])
        alignment := StyleMapper.styleAspects["Alignment"]["classRef"].FromMap(this.styleMap["Alignment"])
        appearance := StyleMapper.styleAspects["Appearance"]["classRef"].FromMap(this.styleMap["Appearance"])
        return Style(dimension, alignment, appearance)
    }
}

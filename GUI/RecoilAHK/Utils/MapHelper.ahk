#Requires AutoHotkey v2.0 

class MapHelper {
    static SplitMap(mapToSplit, keys1, keys2) {
        newMap1 := Map()
        newMap2 := Map()

        for key in keys1 {
            newMap1[key] := mapToSplit.%key%
        }

        for key in keys2 {
            newMap2[key] := mapToSplit.%key%
        }

        return [newMap1, newMap2]
    }

    static PrintMap(mapOrObj) {
        str := ""
        for key in ObjOwnProps(mapOrObj) {
            try str .= Format("{} => {}`n", key, mapOrObj.%key%)
            catch
                str .= key " => [Error displaying value]`n"
        }
        MsgBox str
    }
}
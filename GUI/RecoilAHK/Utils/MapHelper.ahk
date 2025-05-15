#Requires AutoHotkey v2.0 

class MapHelper {
    static SplitMap(map, keys1, keys2) {
        newMap1 := Map()
        newMap2 := Map()

        maxLength := Max(keys1.Length, keys2.Length)
        for index in maxLength {
            if keys1.Length >= index
                newMap1[keys1[index]] := map[keys1[index]]
            if keys2.Length >= index
                newMap2[keys2[index]] := map[keys2[index]]
        }

        return [newMap1, newMap2]
    }
}
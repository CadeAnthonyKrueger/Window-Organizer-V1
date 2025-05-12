#Requires AutoHotkey v2.0 

class ArrayHelper {
    static BinaryInsert(arr, el, func, cond) {
        if arr.Length = 0 {
            arr.Push(el)
            return
        }
        low := 1
        high := arr.length
        check := func(el)

        while low <= high {
            mid := (low + high) // 2
            midCheck := func(arr[mid])

            if cond(check, midCheck) {
                high := mid - 1
            } else {
                low := mid + 1
            }
        }
        arr.InsertAt(low, el)
        return low
    }

    static SliceArray(arr, start, length := "") {
        result := []
        ; Adjust for 1-based indexing
        endIndex := (length != "") ? (start + length - 1) : arr.Length
        Loop (endIndex - start + 1) {
            i := start + A_Index - 1
            result.Push(arr[i])
        }
        return result
    }    
}
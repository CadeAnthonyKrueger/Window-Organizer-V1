#Requires AutoHotkey v2.0

class Path {
    static Resolve(callerFile, relativePath) {
        relativePath := StrReplace(relativePath, "/", "\")
        SplitPath callerFile,, &dir
        return dir . "\" . relativePath
    }
}




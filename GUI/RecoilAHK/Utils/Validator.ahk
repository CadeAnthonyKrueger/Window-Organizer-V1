#Requires AutoHotkey v2.0 

#Include ./MapHelper.ahk

class Validator {
    static ValidateParams(params, validParams, requiredParams := []) {
        for key in ObjOwnProps(params) {
            MsgBox(key)
        }
        return validParams
    }
}

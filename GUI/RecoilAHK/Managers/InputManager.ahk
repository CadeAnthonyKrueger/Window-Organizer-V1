#Requires AutoHotkey v2.0
#SingleInstance Force

class InputManager {
    static instance := ""
    static allowConstruction := false

    __New() {
        if !InputManager.allowConstruction
            throw "InputManager is a singleton and cannot be instantiated directly. Use GetInstance()."
    }

    static GetInstance() {
        if InputManager.instance = "" {
            InputManager.allowConstruction := true
            InputManager.instance := InputManager()
            InputManager.allowConstruction := false
        }
        return InputManager.instance
    }

    static Initialize() {
        InputManager.GetInstance().Initialize()
    }

    Initialize() {
        
    }
}

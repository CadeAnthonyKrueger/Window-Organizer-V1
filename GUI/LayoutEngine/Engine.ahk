#Requires AutoHotkey v2.0 
#SingleInstance Force

class Engine {
    static instance := ""

    __New() {
        throw "Engine is a singleton and cannot be instantiated directly. Use GetInstance()."
    }

    static GetInstance() {
        if Engine.instance = "" {
            Engine.instance := Engine()
        }
        return Engine.instance
    }

    static Initialize() {
        
    }
}
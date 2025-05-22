#Requires AutoHotkey v2.0 

#Include ../Utils/Queue.ahk

class AbstractFactory {
    __New() {
        this.recycledElements := Queue()
    }

    GetElement(params := {}) {
        newElement := this.recycledElements.Dequeue()
        if newElement == "" {
            newElement := this.CreateNew()
        }
        newElement.Initialize(params)
        return newElement
    }

    RecycleElement(recycledElement) {
        this.recycledElements.Enqueue(recycledElement)
        recycledElement.Deinitialize()
    }

    CreateNew() {
        throw Error("Subclasses must implement CreateNew().")
    }
}
#Requires AutoHotkey v2.0 

class Queue {
    __New() {
        this.items := []
    }

    Enqueue(item) {
        this.items.Push(item)
    }

    Dequeue() {
        return this.items.Length > 0 ? this.items.RemoveAt(1) : ""
    }

    Peek() {
        return this.items.Length > 0 ? this.items[1] : ""
    }

    IsEmpty() {
        return this.items.Length = 0
    }

    Clear() {
        this.items := []
    }
}

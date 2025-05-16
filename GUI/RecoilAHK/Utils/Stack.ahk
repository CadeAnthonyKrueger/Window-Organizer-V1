#Requires AutoHotkey v2.0

class Stack {
    __New(initialElement := "") {
        this.items := !initialElement ? [] : [initialElement]
        this.length := this.items.Length
    }

    Push(item) {
        this.items.Push(item)
        this.length := this.items.Length
    }

    Pop() {
        return this.items.Length > 0 ? this.items.Pop() : ""
        this.length := this.items.Length
    }

    Peek() {
        return this.items.Length > 0 ? this.items[this.items.Length] : ""
    }

    IsEmpty() {
        return this.items.Length = 0
    }

    Clear() {
        this.items := []
        this.length := this.items.Length
    }

    static CreateChildStack(startingElement, callback := () => "") {
        stack := Stack()
        queue := Stack(startingElement)

        ; Fill stack with full subtree
        while queue.Length > 0 {
            current := queue.Pop()
            stack.Push(current)
            callback(current)
            for child in callback(current) {
                queue.Push(child)
            }
        }
        return stack
    }
}

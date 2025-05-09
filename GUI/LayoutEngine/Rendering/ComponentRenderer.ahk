#Requires AutoHotkey v2.0
#Include ./Utils/DepthList.ahk

class ComponentRenderer {
    static queue := DepthList()

    static Add(container, depth := 0) {
        ComponentRenderer.queue.Push(container, depth)
    }

    static RenderAll() {
        ComponentRenderer.queue.ForEach((container) => container.Render())
        ComponentRenderer.queue.Clear()
    }
}

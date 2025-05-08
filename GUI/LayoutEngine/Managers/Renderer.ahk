#Requires AutoHotkey v2.0
#Include ./Utils/DepthList.ahk

class Renderer {
    static queue := DepthList()

    static Add(container, depth := 0) {
        Renderer.queue.Push(container, depth)
    }

    static RenderAll() {
        Renderer.queue.ForEach((container) => container.Render())
        Renderer.queue.Clear()
    }
}

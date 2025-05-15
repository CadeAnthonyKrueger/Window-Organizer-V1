#Requires AutoHotkey v2.0

class ComponentRenderer {
    static RenderAll(tree) {
        tree.ForEach((component) => component.Render())
    }

    static RenderFrom(tree, startingComponent) {
        tree.ForEach((component) => component.Render(), startingComponent)
    }
}

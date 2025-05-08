#Requires AutoHotkey v2.0 

class StyleAspect {
    SetProperty(key, value) {
        this.%key% := value
    }

    static FromMap(props) {
        defaults := this.Defaults()
        for k, v in props
            if defaults.Has(k)
                defaults[k] := v

        return this.CallConstructor(defaults)
    }

    ; Subclasses must override this to provide default values
    static Defaults() {
        throw Error("Subclasses must implement Defaults().")
    }

    ; Subclasses must override this to define how to construct the instance
    static CallConstructor(defaults) {
        throw Error("Subclasses must implement CallConstructor().")
    }

    ToString() {
        return ""
    }
}

#Requires AutoHotkey v2.0 

class Validator {
    static ValidateParams(params, validParams, requiredParams := []) {
        ; Check for unknown parameters
        for key in params {
            if !validParams.Has(key)
                throw Error(Format("Unknown parameter: '{}'", key))
        }

        ; Apply known parameters
        for key, value in params {
            validParams[key] := value
        }

        ; Check required parameters
        for key in requiredParams {
            if validParams[key] = ""
                throw Error(Format("Missing required parameter: '{}'", key))
        }

        return validParams
    }
}

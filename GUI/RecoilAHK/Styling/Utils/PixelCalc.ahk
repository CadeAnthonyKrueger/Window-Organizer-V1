#Requires AutoHotkey v2.0

class PixelCalc {
    static ToPixels(value, parentDim) {

        static ops := Map("+" ,1, "-" ,1, "*" ,2, "/" ,2)

        if Type(value) = "String" {
            value := Trim(value)

            ; Handle calc("...")
            if RegExMatch(value, '^calc\(\s*"(.+)"\s*\)$', &match) {
                expr := match[1]

                ; Tokenize
                tokens := []
                pattern := '\s*(\d+%|\d+px|\d+|[()+\-*/])\s*'
                while RegExMatch(expr, pattern, &m, A_Index = 1 ? 1 : m.Pos + m.Len)
                    tokens.Push(m[1])

                ; Shunting Yard (to RPN)
                output := []
                stack := []
                for token in tokens {
                    if RegExMatch(token, '^\d+%$|^\d+px$|^\d+$') {
                        output.Push(token)
                    } else if ops.Has(token) {
                        while (stack.Length && ops.Has(stack[-1]) && ops[token] <= ops[stack[-1]])
                            output.Push(stack.Pop())
                        stack.Push(token)
                    } else if token = "(" {
                        stack.Push(token)
                    } else if token = ")" {
                        while (stack.Length && stack[-1] != "(")
                            output.Push(stack.Pop())
                        if (stack.Length && stack[-1] = "(")
                            stack.Pop()
                    }
                }
                while (stack.Length)
                    output.Push(stack.Pop())

                ; Evaluate RPN
                eval := []
                for token in output {
                    if ops.Has(token) {
                        b := PixelCalc.ToPixels(eval.Pop(), parentDim)
                        a := PixelCalc.ToPixels(eval.Pop(), parentDim)
                        switch token {
                            case "+": eval.Push(a + b)
                            case "-": eval.Push(a - b)
                            case "*": eval.Push(a * b)
                            case "/": eval.Push(b != 0 ? a / b : 0)
                        }
                    } else {
                        eval.Push(token)
                    }
                }
                return PixelCalc.ToPixels(eval[1], parentDim)
            }

            ; Handle percentage
            if InStr(value, "%") && RegExMatch(value, "(\d+)", &match)
                return Round(Number(match[1]) / 100 * parentDim)

            ; Handle px
            if RegExMatch(value, "i)^\s*(\d+)\s*px\s*$", &match)
                return Number(match[1])

            ; Raw number
            if RegExMatch(value, "^\d+$", &match)
                return Number(match[0])
        }

        return Type(value) = "Integer" ? value : 0
    }
}

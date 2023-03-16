; credit to https://github.com/flipeador/Library-AutoHotkey/blob/master/math/Eval.ahk

; ===================================================================================================
; GUI
; ===================================================================================================
Gui Add, Text, x5 y5 w300 h21, Bewerking:
Gui Add, Edit, x5 y30 w300 vUserType
Gui Add, Button, x5 y125 w300 gCalculate Default, Bereken
Gui, Add, Text, x15 y55 w220 h50 , Druk op Enter om het resultaat te zien`, druk op Delete om het invoerveld leeg te maken, om af te sluiten druk op Escape.

Gui Show,,Rekenmachine
return


; ===================================================================================================
; LABELS
; ===================================================================================================
Calculate:
Gui Submit, NoHide
GuiControl ,, UserType, % Eval(UserType)
Send {End}


return

GuiClose:
Exitapp

Esc:: Exitapp

Del:: GuiControl ,, UserType,


; ===================================================================================================
; FUNCTIONS
; ===================================================================================================
Eval(Expr, Format := FALSE)
{
    static obj := ""    ; voor prestatieproblemen
    if ( !obj )
        obj := ComObjCreate("HTMLfile")

    Expr := StrReplace( RegExReplace(Expr, "\s") , ",", ".")
  , Expr := RegExReplace(StrReplace(Expr, "**", "^"), "(\w+(\.*\d+)?)\^(\w+(\.*\d+)?)", "pow($1,$3)")    ; 2**3 -> 2^3 -> pow(2,3)
  , Expr := RegExReplace(Expr, "=+", "==")    ; = -> ==  |  === -> ==  |  ==== -> ==  |  ..
  , Expr := RegExReplace(Expr, "\b(E|LN2|LN10|LOG2E|LOG10E|PI|SQRT1_2|SQRT2)\b", "Math.$1")
  , Expr := RegExReplace(Expr, "\b(abs|acos|asin|atan|atan2|ceil|cos|exp|floor|log|max|min|pow|random|round|sin|sqrt|tan)\b\(", "Math.$1(")

  , obj.write("<body><script>document.body.innerText=eval('" . Expr . "');</script>")
  , Expr := obj.body.innerText

    return InStr(Expr, "d") ? "" : InStr(Expr, "false") ? FALSE    ; d = body | undefined
                                 : InStr(Expr, "true")  ? TRUE
                                 : ( Format && InStr(Expr, "e") ? Format("{:f}",Expr) : Expr )
} 

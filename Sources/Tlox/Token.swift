struct Token: Equatable {
    init(_ type: TokenType, _ loc: Location) {
        self.type = type
        self.loc = loc
    }

    let type: TokenType
    let loc: Location
}

struct Location: Equatable, CustomDebugStringConvertible {
    let line: Int
    let col: Int
    
    init(_ line: Int, _ col: Int) {
        self.line = line
        self.col = col
    }
    
    var debugDescription: String {
        "\(line):\(col)"
    }
}

enum TokenType: Equatable {
    case num(Float)
    case str(String)
    case id(String)

    // keywords
    case kwClass
    case kwFun
    case kwVar
    case kwFor
    case kwIf
    case kwElse
    case kwPrint
    case kwReturn
    case kwWhile
    case kwSuper
    case kwTrue
    case kwFalse
    case kwNil
    case kwThis
    
    // symbol
    case plus
    case minus
    case mul
    case div
    case assign
    case gt
    case ge
    case lt
    case le
    case neq
    case eq
    case neg // !
    case dot
    
    // other
    case comma
    case semiColon
    case openParent
    case closeParent
    case openBracket
    case closeBracket
    
    case eof
}
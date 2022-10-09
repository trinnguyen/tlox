class Lexer {
    private let scalars: [UnicodeScalar]
    private var current: UnicodeScalar?
    private var index: Int = 0
    private var line: Int = 1
    private var col: Int = 1
    
    init(_ str: String) {
        self.scalars = Array(str.unicodeScalars)
        self.current = index < scalars.count ? scalars[index] : nil
    }
    
    func scan() -> [Token] {
        var tokens: [Token] = []
        while true {
            let token = nextToken()
            tokens.append(token)
            if case .eof = token.type {
                break
            }
        }
        return tokens
    }
    
    func nextToken() -> Token {
        // ignore whitespace
        guard let current else { return .init(.eof, loc()) }
        if current.isWhitespace {
            while let tmp = advance(), tmp.isWhitespace {}
        }
        
        let loc = loc()
        let type = nextTokenType()
        return .init(type, loc)
    }
    
    private func nextTokenType() -> TokenType {
        guard let cur = self.current else { return .eof }
        
        switch cur {
            
        // scan string with quote
        case "\"":
            var scalars: String.UnicodeScalarView = .init()
            while let tmp = advance(), tmp != "\"" {
                scalars.append(tmp)
            }
            let str = String(scalars)
            _ = advance()
            return .str(str)
            
        // scan id
        case let c where c.isAlpha:
            var scalars: String.UnicodeScalarView = .init()
            scalars.append(cur)
            while let tmp = advance(), tmp.isAlpha || tmp.isDigit {
                scalars.append(tmp)
            }
            return .id(String(scalars))
            
        // scan number
        case let c where c.isDigit:
            var scalars = String.UnicodeScalarView()
            scalars.append(c)
            var hasDot = false
            while let tmp = advance(), tmp.isDigit || (!hasDot && tmp == ".") {
                if tmp == "." {
                    hasDot = true
                }
                scalars.append(tmp)
            }
            return .num(Float(String(scalars))!)
            
        case "+":
            _ = advance()
            return .plus
            
        case "-":
            _ = advance()
            return .minus
            
        case "*":
            _ = advance()
            return .mul
            
        case "/":
            _ = advance()
            return .div
            
        case ">":
            if let nxt = advance(), nxt == "=" {
                _ = advance()
                return .ge
            }
            return .gt
            
        case "<":
            if let nxt = advance(), nxt == "=" {
                _ = advance()
                return .le
            }
            return .lt
            
        case "!":
            if let nxt = advance(), nxt == "=" {
                _ = advance()
                return .neq
            }
            return .neg

        case "=":
            if let nxt = advance(), nxt == "=" {
                _ = advance()
                return .eq
            }
            return .assign
            
        case ".":
            _ = advance()
            return .dot

        case ":":
            _ = advance()
            return .comma

        case ";":
            _ = advance()
            return .semiColon
            
        case "(":
            _ = advance()
            return .openParent
            
        case ")":
            _ = advance()
            return .closeParent
            
        case "{":
            _ = advance()
            return .openBracket
            
        case "}":
            _ = advance()
            return .closeBracket
            
        default:
            ()
        }
        
        fatalError("Unexpected token: \(cur)")
    }
}

// Helper method
extension Lexer {
    private func advance() -> UnicodeScalar? {
        index = index + 1
        current = index < scalars.count ? scalars[index] : nil
        if let current {
            if current == "\n" {
                line = line + 1
                col = 1
            } else {
                col = col + 1
            }
        }
        
        return current
    }
    
    private func loc() -> Location {
        Location(line, col)
    }
}

extension UnicodeScalar {
    var isWhitespace: Bool {
        switch self {
        case " ", "\t", "\n", "\r":
            return true
        default:
            return false
        }
    }
    
    var isAlpha: Bool {
        switch self {
        case "_", "A"..."Z", "a"..."z":
            return true
        default:
            return false
        }
    }
    
    var isDigit: Bool {
        switch self {
        case "0"..."9":
            return true
        default:
            return false
        }
    }
}

@main
public struct Tlox {
    public static func main() {
        let src = """
        print b1
        1 + 2.46
        print "abc hi!"
        """
        let lexer = Lexer(src)
        
        // TODO: start testing
        
        // TODO: end testing
        
        let tokens = lexer.scan()
        print(tokens.map { "\($0)" }.joined())
        print(Ast(decls: []))
    }
}

@main
public struct Tlox {
    public static func main() {
        let src = """
        print 45;
        print true;
        print false;
        print "ab u";
        print ("hey!");
        """
        run(src)

        // test 2:
        run("true or false;")
    }

    private static func run(_ src: String) {
        print("------------------\n\(src)\n------------------")
        // lexing
        let lexer = Lexer(src)
        let tokens = lexer.scan()
        print(tokens)

        // parsing
        let parser = Parser(tokens)
        let ast = parser.parse()
        print(ast)
        
        // tree walker
        print("------------ TREE WALKER:-----")
        let walker = TreeExecutor()
        walker.walk(ast)
    }
}

class Parser {
    private let tokens: [Token]
    private var current: Token? {
        index < tokens.count ? tokens[index] : nil
    }

    private var currentTok: Token {
        guard let current else { fatalError("unexpected eof") }
        return current
    }

    private func peek() -> Token? {
        let i = index + 1
        return i < tokens.count ? tokens[i] : nil
    }

    private var index: Int = 0

    init(_ tokens: [Token]) {
        self.tokens = tokens
    }

    func parse() -> Ast {
        return Ast(decls: parseDecls())
    }

    private func parseDecls() -> [Decl] {
        var decls: [Decl] = []
        while let decl = parseDecl() {
            decls.append(decl)
        }
        return decls
    }

    private func parseDecl() -> Decl? {
        guard let current else { return nil }
        switch current.type {
            case .kwClass:
                return parseClassDecl()
            case .kwFun:
                return parseFunDecl()
            case .kwVar:
                return parseVarDecl()
            case .eof:
                return nil
            default:
                return parseStmt()
        }
    }

    private func parseClassDecl() -> ClassDecl {
        consume(.kwClass)
        fatalError("fatalError parseClassDecl")
    }

    private func parseFunDecl() -> FunDecl {
        consume(.kwFun)
        fatalError("fatalError parseFunDecl")
    }

    private func parseVarDecl() -> VarDecl {
        consume(.kwVar)
        fatalError("fatalError parseVarDecl")
    }

    private func parseStmt() -> Stmt {
        guard let current else { fatalError("Expected Stmt but eof") }
        switch current.type {
            case .kwFor:
                return parseForStmt()
            case .kwIf:
                return parseIfStmt()
            case .kwPrint:
                return parsePrintStmt()
            case .kwReturn:
                return parseReturnStmt()
            case .kwWhile:
                return parseWhileStmt()
            case .openBracket:
                return parseBlock()
            default:
                return parseExprStmt()
        }
    }

    private func parseExprStmt() -> ExprStmt {
        let expr = parseExpr()
        consume(.semiColon)
        return ExprStmt(expr: expr)
    }

    private func parseForStmt() -> ForStmt {
        fatalError("parseForStmt")
    }

    private func parseIfStmt() -> IfStmt {
        fatalError("parseIfStmt")
    }

    private func parsePrintStmt() -> PrintStmt {
        consume(.kwPrint)
        let expr = parseExpr()
        consume(.semiColon)
        return PrintStmt(expr: expr)
    }

    private func parseReturnStmt() -> ReturnStmt {
        fatalError("parseReturnStmt")
    }

    private func parseWhileStmt() -> WhileStmt {
        fatalError("parseWhileStmt")
    }

    private func parseBlock() -> Block {
        consume(.openBracket)
        let decls = parseDecls()
        consume(.closeBracket)
        return Block(decls: decls)
    }

    private func parseExpr() -> Expr {
        parseAssignment()
    }

    private func parseAssignment() -> Expr {
        // assignment
        switch (currentTok.type, peek()?.type) {
            case (.id(let id), .some(.assign)):
                advance()
                consume(.assign)
                let expr = parseAssignment()
                return AssignmentExpr(id: id, expr: expr)
            default:
                return parseOpExpr()
        }
    }

    private func parseOpExpr() -> Expr {
        parseOrExpr()
    }

    private func parseBinaryExpr(ops: [TokenType: BinaryExpr.Op], _ provider: () -> Expr) -> Expr {
        let lhs = provider()
        guard let op = ops[currentTok.type] else { return lhs }
        advance()
        let rhs = provider()
        return BinaryExpr(lhs: lhs, op: op, rhs: rhs)
    }

    private func parseOrExpr() -> Expr {
        parseBinaryExpr(ops: [.kwOr : .or], parseAndExpr)
    }

    private func parseAndExpr() -> Expr {
        parseBinaryExpr(ops: [.kwAnd : .and], parseEqExpr)
    }

    private func parseEqExpr() -> Expr {
        parseBinaryExpr(ops: [.neq : .neq, .eq : .eq], parseComparisonExpr)
    }

    private func parseComparisonExpr() -> Expr {
        parseBinaryExpr(
            ops: [
                .gt : .gt,
                .ge : .ge,
                .lt : .lt,
                .le : .le
            ],
            parseTermExpr
        )
    }

    private func parseTermExpr() -> Expr {
        parseBinaryExpr(ops: [.sub : .sub, .add : .add], parseFactorExpr)
    }

    private func parseFactorExpr() -> Expr {
        parseBinaryExpr(ops: [.div : .div, .mul : .mul], parseUnaryExpr)   
    }

    private func parseUnaryExpr() -> Expr {
        switch currentTok.type {
            case .neg, .sub:
                let op: UnaryExpr.Op = currentTok.type == .neg ? .neg : .sub
                advance()
                let expr = parseUnaryExpr()
                return UnaryExpr(op: op, expr: expr)
            default:
                return parseCall()
        }
    }

    private func parseCall() -> Expr {
        let expr = parseGroupOrPrimary()

        // check if call
        switch currentTok.type {
            case .openParent:
                advance()

                // TODO: parse arguments
                var args: [Expr] = []
                consume(.closeParent)
                return Call.fun(expr: expr, args: args)
            case .dot:
                advance()
                guard case .id(let id) = currentTok.type else { fatalError("expected Id but \(currentTok)") }
                advance()
                return Call.prop(expr: expr, id: id)
            default:
                return expr
        }
    }

    private func parseGroupOrPrimary() -> Expr {
        guard let current else { fatalError("expected Group or Primary but eof") }
        switch current.type {
            case .openParent:
                advance()
                let expr = parseExpr()
                consume(.closeParent)
                return expr
            default:
                return parsePrimary()
        }
    }

    private func parsePrimary() -> Primary {
        guard let current else { fatalError("expected Primary but eof") }
        switch current.type {
            case .kwTrue:
                advance()
                return .true
            case .kwFalse:
                advance()
                return .false
            case .kwNil:
                advance()
                return .nil
            case .kwThis:
                advance()
                return .this
            case .num(let num):
                advance()
                return .num(num)
            case .str(let str):
                advance()
                return .str(str)
            case .id(let id):
                advance()
                return .id(id)
            case .kwSuper:
                advance()
                consume(.dot)
                guard let tmp = self.current, case .id(let id) = tmp.type else {
                    fatalError("Expected id but eof")
                }
                advance()
                return .superId(id)
            default:
                fatalError("Unexpected: \(current)")
        }
    }
}

extension Parser {
    private func advance() {
        if index < tokens.count {
            index = index + 1
        }
    }

    private func consume(_ type: TokenType) {
        guard let current else {
            fatalError("Expected \(type) but eof")
        }

        guard current.type == type else {
            fatalError("Expected \(type) but \(current.type) at \(current.loc)")
        }
        index = index + 1
    }
}

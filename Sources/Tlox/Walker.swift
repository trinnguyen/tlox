protocol Walker {
    associatedtype T
    
    // stmt
    func visitPrintStmt(_ stmt: PrintStmt)

    // expr
    func visitBinary(expr: BinaryExpr) -> T
    
    // expr primary
    func visitTrue() -> T
    func visitFalse() -> T
    func visitNil() -> T
    func visitThis() -> T
    func visitNum(_ num: Float) -> T
    func visitStr(_ str: String) -> T
    func visitId(_ id: String) -> T
    func visitSuperId(_ id: String) -> T
}

extension Walker {
    func walk(_ ast: Ast) {
        for decl in ast.decls {
            visitDecl(decl: decl)
        }
    }

    private func visitDecl(decl: Decl) {
        switch decl {
            case is ClassDecl:
                fatalError("not supported ClassDecl")
            case is FunDecl:
                fatalError("not supported FunDecl")
            case is VarDecl:
                fatalError("not supported VarDecl")
            case let stmt as Stmt:
                visitStmt(stmt: stmt)
            default:
                fatalError("not supported")
        }
    }

    private func visitStmt(stmt: Stmt) {
        switch stmt {
        case let exprStmt as ExprStmt:
            let _ = visitExpr(exprStmt.expr)
        case let printStmt as PrintStmt:
            visitPrintStmt(printStmt)
        default:
            fatalError("Not supported")
        }
    }
    
    func visitExpr(_ expr: Expr) -> T {
        switch expr {
        case let primary as Primary:
            return visitPrimary(primary: primary)
        case let bin as BinaryExpr:
            return visitBinary(expr: bin)
        default:
            fatalError("Not supported")
        }
    }
    
    private func visitPrimary(primary: Primary) -> T {
        switch primary {
        case .true:
            return visitTrue()
        case .false:
            return visitFalse()
        case .nil:
            return visitNil()
        case .this:
            return visitThis()
        case .num(num: let num):
            return visitNum(num)
        case .str(str: let str):
            return visitStr(str)
        case .id(id: let id):
            return visitId(id)
        case .superId(id: let id):
            return visitSuperId(id)
        }
    }
}

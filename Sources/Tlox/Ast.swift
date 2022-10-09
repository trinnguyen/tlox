typealias Id = String

struct Ast {
    let decls: [Decl]
}

enum Decl {
    case `class`(id: Id, superId: Id?, functions: [Function])
    case `func`(function: Function)
    case `var`(VarDecl)
    case stmt(stmt: Stmt)
}

struct VarDecl {
    let id: Id
    let expr: Expr?
}

// Stmt
protocol Stmt {
}

struct ExprStmt: Stmt {
    let expr: Expr
}

struct ForStmt: Stmt {
    let decl: ForDecl
    let expr1: Expr?
    let expr2: Expr?
    let bodyStmt: Stmt

    enum ForDecl {
        case varDecl(VarDecl)
        case exprStmt(Expr)
        case none
    }
}

struct IfStmt: Stmt {
    let expr: Expr
    let thenStmt: Stmt
    let elseStmt: Stmt?
}

struct PrintStmt: Stmt {
    let expr: Expr
}

struct ReturnStmt: Stmt {
    let expr: Expr?
}

struct WhileStmt: Stmt {
    let expr: Expr
    let bodyStmt: Stmt
}

struct BlockStmt: Stmt {
    let decls: [Decl]
}

// Expr
protocol Expr {}

struct AssignExpr: Expr {
    let call: Call?
    let id: Id
    let assignment: Expr
}

struct BinaryExpr {

    enum Op: String {
        case or
        case and
        case neq = "!="
        case eq = "=="
        case gt = ">"
        case gte = ">="
        case lt = "<"
        case lte = "<="
        case sub = "-"
        case add = "+"
        case div = "/"
        case mul = "*"
    }

    let lhsExpr: Expr
    let rhsExpr: Expr
    let op: Op
}

struct UnaryExpr {
    enum Op: String {
        case neg = "!"
        case min = "-"
    }
    let expr: Expr
}

struct Call: Expr {
    let primary: Primary
    let arguments: [Id]?
    let dotId: [Id]?
}

enum Primary: Expr {
    case `true`
    case `false`
    case `nil`
    case this
    case num(num: Int)
    case str(str: String)
    case id(id: Id)
    case expr(expr: Expr)
    case superId(id: Id)
}

struct Function {
    let id: Id
    let parameters: [Id]
    let block: BlockStmt
}

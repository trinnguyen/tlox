typealias Id = String

struct Ast {
    let decls: [Decl]
}

protocol Decl {
}

struct ClassDecl: Decl {
    let id: Id
    let superId: Id?
    let functions: [Function]
}

struct FunDecl: Decl {
    let function: Function
}

struct VarDecl: Decl {
    let id: Id
    let expr: Expr?
}

// Stmt
protocol Stmt: Decl {
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

struct Block: Stmt {
    let decls: [Decl]
}

// Expr
protocol Expr {}

struct BinaryExpr: Expr {

    enum Op: String, Equatable {
        case or
        case and
        case neq = "!="
        case eq = "=="
        case gt = ">"
        case ge = ">="
        case lt = "<"
        case le = "<="
        case sub = "-"
        case add = "+"
        case div = "/"
        case mul = "*"
    }

    let lhs: Expr
    let op: Op
    let rhs: Expr
}

struct UnaryExpr: Expr {
    enum Op: String {
        case neg = "!"
        case sub = "-"
    }
    let op: Op
    let expr: Expr
}

enum Call: Expr {
    case fun(expr: Expr, args: [Expr])
    case prop(expr: Expr, id: Id)
}

struct AssignmentExpr: Expr {
    let id: Id
    let expr: Expr

    // TODO: call?
}

enum Primary: Expr, Equatable {
    case `true`
    case `false`
    case `nil`
    case this
    case num(Float)
    case str(String)
    case id(Id)
    case superId(Id)
}

struct Function {
    let id: Id
    let parameters: [Id]
    let block: Block
}

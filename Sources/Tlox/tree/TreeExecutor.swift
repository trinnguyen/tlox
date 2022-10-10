class TreeExecutor: Walker {

	var printHandler: (String) -> () = { print($0) }
    
    func visitPrintStmt(_ stmt: PrintStmt) {
        let result = visitExpr(stmt.expr)
        var str: String = ""
        switch result {
        case .str(let s):
            str = s
        case .num(let num):
        	if let intVal = Int(exactly: num) {
        		str = "\(intVal)"
        	} else {
        		str = "\(num)"
        	}
        case .bool(let bool):
            str = "\(bool)"
        case .nill:
            str = "nil"
        }
        printHandler(str)
    }

    func visitBinary(expr: BinaryExpr) -> Result {
    	let lhs = visitExpr(expr.lhs)
    	let evalRhs: () -> Result = { self.visitExpr(expr.rhs) }
    	let evalNumbers: () -> (Float, Float) = {
			guard let lhsVal = lhs.numVal, let rhsVal = evalRhs().numVal else {
				fatalError("operation requires 2 numbers")
			}
			return (lhsVal, rhsVal)
    	}
    	switch expr.op {
			case .or:
				if lhs.isTruthy { return lhs }
				return evalRhs()
			case .and:
				if lhs.isTruthy { return evalRhs() }
				return lhs
			case .neq:
				return .bool(lhs != evalRhs())
			case .eq:
				return .bool(lhs == evalRhs())
			case .gt:
				let (l, r) = evalNumbers()
				return .bool(l > r)
			case .ge:
				let (l, r) = evalNumbers()
				return .bool(l >= r)
			case .lt:
				let (l, r) = evalNumbers()
				return .bool(l < r)
			case .le:
				let (l, r) = evalNumbers()
				return .bool(l <= r)
			case .sub:
				let (l, r) = evalNumbers()
				return .num(l - r)
			case .add:
				let (l, r) = evalNumbers()
				return .num(l + r)
			case .div:
				let (l, r) = evalNumbers()
				guard r != 0 else { fatalError("division by zero") }
				return .num(l / r)
			case .mul:
				let (l, r) = evalNumbers()
				return .num(l * r)
    	}
    }
    
    func visitTrue() -> Result {
        .bool(true)
    }
    
    func visitFalse() -> Result {
        .bool(false)
    }
    
    func visitNil() -> Result {
        .nill
    }
    
    func visitThis() -> Result {
        fatalError("error this")
    }
    
    func visitNum(_ num: Float) -> Result {
        .num(num)
    }
    
    func visitStr(_ str: String) -> Result {
        .str(str)
    }
    
    func visitId(_ id: String) -> Result {
        fatalError("error id")
    }
    
    func visitSuperId(_ id: String) -> Result {
        fatalError("error super id: \(id)")
    }
    
 
    enum Result: Equatable {
        case nill
        case bool(Bool)
        case num(Float)
        case str(String)

        var isNil: Bool {
        	return self == .nill
        }

        var numVal: Float? {
        	if case .num(let v) = self {
        		return v
        	}
        	return nil
        }

        var isTruthy: Bool {
        	switch self {
        		case .nill:
        			return false
    			case .bool(let v):
    				return v
				default:
					return true
        	}
        }
    }
}

import XCTest
@testable import Tlox

final class TloxTests: XCTestCase {
    func testAst() throws {
        let ast = Ast(decls: [])
        XCTAssertEqual(ast.decls.count, 0)
    }
}

//
//  LexerTests.swift
//  
//
//  Created by Tri Nguyen on 09/10/2022.
//

import XCTest
@testable import Tlox

final class LexerTests: XCTestCase {
    
    func testEof() {
        XCTAssertEqual([Token(.eof, .init(1, 1))], Lexer("").scan())
    }
    
    func testId() {
        XCTAssertEqual([Token(.id("print"), .init(1, 1))], Lexer("print").scan().dropLast())
    }
    
    func testStr() {
        XCTAssertEqual([Token(.str("print"), .init(1, 1))], Lexer("\"print\"").scan().dropLast())
    }
    
    func testNum() {
        XCTAssertEqual([Token(.num(1), .init(1, 1))], Lexer("1").scan().dropLast())
    }
    
    func testNumFloat() {
        XCTAssertEqual([Token(.num(3.14), .init(1, 1))], Lexer("3.14").scan().dropLast())
    }

    func testNumFloatFailed() {
        // This is expected in lexer, error will be handled by parser
        let src = """
        3.14.8.a
        """
        XCTAssertEqual([
            TokenType.num(3.14),
            TokenType.dot,
            TokenType.num(8),
            TokenType.id("a"),
            TokenType.eof,
        ], Lexer(src).scan().map { $0.type })
    }
    
    func testPlus() {
        XCTAssertEqual([Token(.plus, .init(1, 1))], Lexer("+").scan().dropLast())
    }
    
    func testMinus() {
        XCTAssertEqual([Token(.minus, .init(1, 1))], Lexer("-").scan().dropLast())
    }
    
    func testMul() {
        XCTAssertEqual([Token(.mul, .init(1, 1))], Lexer("*").scan().dropLast())
    }
    
    func testDiv() {
        XCTAssertEqual([Token(.div, .init(1, 1))], Lexer("/").scan().dropLast())
    }
    
    func testFull() {
        let src = """
        print "Hello world!"
                _bb1 = 1 + 2 / 3 * 4
        a = 5.67 * _bb1
        print a
        """
        XCTAssertEqual([
            TokenType.id("print"),
            TokenType.str("Hello world!"),
            TokenType.id("_bb1"),
            TokenType.assign,
            TokenType.num(1),
            TokenType.plus,
            TokenType.num(2),
            TokenType.div,
            TokenType.num(3),
            TokenType.mul,
            TokenType.num(4),
            TokenType.id("a"),
            TokenType.assign,
            TokenType.num(5.67),
            TokenType.mul,
            TokenType.id("_bb1"),
            TokenType.id("print"),
            TokenType.id("a"),
            TokenType.eof,
        ], Lexer(src).scan().map { $0.type })
    }

    func testSymbols() {
        let src = """
        } { ) ( ; : . ! == != <= < >= > = / * - +
        """
        XCTAssertEqual([
            TokenType.closeBracket,
            TokenType.openBracket,
            TokenType.closeParent,
            TokenType.openParent,
            TokenType.semiColon,
            TokenType.comma,
            TokenType.dot,
            TokenType.neg,
            TokenType.eq,
            TokenType.neq,
            TokenType.le,
            TokenType.lt,
            TokenType.ge,
            TokenType.gt,
            TokenType.assign,
            TokenType.div,
            TokenType.mul,
            TokenType.minus,
            TokenType.plus,
            TokenType.eof
        ], Lexer(src).scan().map { $0.type })
    }
}

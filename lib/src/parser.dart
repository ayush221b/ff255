import 'package:ff255/src/lexer.dart';
import 'package:ff255/src/nodes.dart';

class Parser {
  final List<Token> _tokens;
  int _current = 0;
  LoopNode? currentLoop;

  Parser(this._tokens);

  List<Stmt> parse() {
    List<Stmt> statements = [];

    // Start Marker Check
    if (!_tryMatch(TokenType.number) ||
        _tokens[_current - 1].value != "11111111") {
      throw Exception("FF 255 programs must start with '11111111'");
    }
    while (!_isAtEnd()) {
      statements.add(parseStatement());
    }

    return statements;
  }

  Stmt parseStatement() {
    if (_tryMatch(TokenType.aiWillReplace)) {
      final name = _expectIdentifier();
      _expect(TokenType.equal);
      final value = parseExpression();
      _expect(TokenType.semicolon);
      return AssignmentNode(name, value);
    } else if (_tryMatch(TokenType.debug)) {
      Expr expression = parseExpression();
      _expect(TokenType.semicolon);
      return DebugNode(expression);
    } else if (_tryMatch(TokenType.weeklySprint)) {
      Expr condition = parseExpression();

      List<Stmt> body = parseBlock();

      currentLoop = LoopNode(condition, body);

      return currentLoop!;
    } else if (_tryMatch(TokenType.maybe)) {
      List<ConditionalBlock> blocks = [];

      // First 'maybe' Block
      Expr condition = parseExpression();
      List<Stmt> maybeBlock = parseBlock();
      blocks.add(ConditionalBlock(condition, maybeBlock));

      // Subsequent 'else if' blocks
      while (_tryMatch(TokenType.whatIf)) {
        condition = parseExpression();
        List<Stmt> whatIfBlock = parseBlock();
        blocks.add(ConditionalBlock(condition, whatIfBlock));
      }

      // Optional 'nevermind' (else) Block
      if (_tryMatch(TokenType.nevermind)) {
        List<Stmt> elseBlock = parseBlock();
        blocks.add(
          ConditionalBlock(null, elseBlock),
        ); // No condition for 'else'
      }

      return ConditionalNode(blocks);
    }

    return _parseExpressionStatement(); // Handle expression statements
  }

  List<Stmt> parseBlock() {
    List<Stmt> statements = [];
    _expect(TokenType.leftBrace);

    while (!_tryMatch(TokenType.rightBrace) && !_isAtEnd()) {
      statements.add(parseStatement());
    }

    return statements;
  }

  Stmt _parseExpressionStatement() {
    Expr expr = parseExpression();
    _expect(TokenType.semicolon);
    return ExpressionStmt(expr);
  }

  Expr parseExpression() {
    return parseLogicalOrExpr();
  }

  Expr parseLogicalOrExpr() {
    Expr left = parseLogicalAndExpr();

    while (_current < _tokens.length &&
        _tokens[_current].type == TokenType.logicalOr) {
      TokenType operator = _tokens[_current].type;
      _current++; // Advance past the operator
      Expr right = parseLogicalAndExpr();
      left = BinaryOpNode(left, operator, right);
    }

    return left;
  }

  Expr parseLogicalAndExpr() {
    Expr left = parseEqualityExpr();

    while (_current < _tokens.length &&
        _tokens[_current].type == TokenType.logicalAnd) {
      TokenType operator = _tokens[_current].type;
      _current++;
      Expr right = parseEqualityExpr();
      left = BinaryOpNode(left, operator, right);
    }

    return left;
  }

  Expr parseEqualityExpr() {
    Expr left = parseRelationalExpr();

    while (_current < _tokens.length &&
        _tokens[_current].type == TokenType.equals) {
      TokenType operator = _tokens[_current].type;
      _current++;
      Expr right = parseRelationalExpr();
      left = BinaryOpNode(left, operator, right);
    }

    return left;
  }

  Expr parseRelationalExpr() {
    Expr left = parseAdditiveExpr();

    while (_current < _tokens.length &&
        [
          TokenType.greaterThan,
          TokenType.lessThan,
          TokenType.greaterThanOrEqual,
          TokenType.lessThanOrEqual
        ].contains(_tokens[_current].type)) {
      TokenType operator = _tokens[_current].type;
      _current++;
      Expr right = parseAdditiveExpr();
      left = BinaryOpNode(left, operator, right);
    }

    return left;
  }

  Expr parseAdditiveExpr() {
    Expr left = parseMultiplicativeExpr();

    while (_current < _tokens.length &&
        [
          TokenType.plus,
          TokenType.minus,
        ].contains(_tokens[_current].type)) {
      TokenType operator = _tokens[_current].type;
      _current++;
      Expr right = parseMultiplicativeExpr();
      left = BinaryOpNode(left, operator, right);
    }

    return left;
  }

  Expr parseUnaryExpr() {
    if (_tryMatch(TokenType.minus) || _tryMatch(TokenType.thisIsNotRealCode)) {
      TokenType operator = _tokens[_current - 1].type;
      Expr operand = parseUnaryExpr(); // Allow nested unary operations
      return UnaryOpNode(operator, operand);
    }

    // If not a unary operator, parse a primary expression
    return parsePrimaryExpr();
  }

  Expr parseMultiplicativeExpr() {
    Expr left = parseUnaryExpr(); // Update for potential unary minus

    while (_current < _tokens.length &&
        [
          TokenType.multiply,
          TokenType.divide,
          TokenType.modulo,
        ].contains(_tokens[_current].type)) {
      TokenType operator = _tokens[_current].type;
      _current++;
      Expr right = parseUnaryExpr(); // Update for potential unary minus
      left = BinaryOpNode(left, operator, right);
    }

    return left;
  }

  Expr parsePrimaryExpr() {
    if (_tokens[_current].type == TokenType.number) {
      double value = double.tryParse(_tokens[_current].value) ?? 0.0;
      _current++; // Advance token index
      return NumberNode(value);
    } else if (_tokens[_current].type == TokenType.identifier) {
      String name = _tokens[_current].value;
      _current++; // Advance token index
      return VariableNode(name);
    } else if (_tokens[_current].type == TokenType.feature) {
      _current++;
      return BooleanNode(true);
    } else if (_tokens[_current].type == TokenType.bug) {
      _current++;
      return BooleanNode(false);
    } else if (_tryMatch(TokenType.thisIsNotRealCode)) {
      Expr operand = parsePrimaryExpr();
      return UnaryOpNode(TokenType.thisIsNotRealCode, operand);
    } else if (_tryMatch(TokenType.leftParen)) {
      Expr expr = parseExpression();
      _expect(TokenType.rightParen);
      return expr;
    } else if (_tokens[_current].type == TokenType.string) {
      String stringValue = _tokens[_current].value;
      _current++; // Advance past the string token
      return StringNode(stringValue);
    }

    throw Exception('Unexpected token: ${_tokens[_current].type} $_current');
  }

  bool _tryMatch(TokenType type) {
    if (_isAtEnd()) return false;
    if (_tokens[_current].type == type) {
      _current++;
      return true;
    }
    return false;
  }

  void _expect(TokenType type) {
    if (_tryMatch(type)) return;
    throw Exception(
        'Expected ${type.name} but got ${_tokens[_current].type.name}');
  }

  String _expectIdentifier() {
    if (_tryMatch(TokenType.identifier)) {
      return _tokens[_current - 1].value;
    }
    throw Exception('Expected identifier');
  }

  bool _isAtEnd() => _current >= _tokens.length;
}

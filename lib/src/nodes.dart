import 'package:ff255/src/lexer.dart';

// Abstract base classes for expressions and statements

abstract class Expr {
  dynamic accept<T>(Visitor<T> visitor);
}

abstract class Stmt {
  dynamic accept<T>(Visitor<T> visitor);
}

abstract class Visitor<T> {
  T visitAssignmentExpr(AssignmentNode stmt);
  T visitConditionalStmtExpr(ConditionalNode stmt);
  T visitLoopStmtExpr(LoopNode stmt);
  T visitBreakStmtExpr(BreakNode stmt);
  T visitContinueStmtExpr(ContinueNode stmt);
  T visitDebugStmtExpr(DebugNode stmt);
  T visitExpressionStmtExpr(ExpressionStmt stmt);
  T visitUnaryExpr(UnaryOpNode expr);
  T visitBinaryExpr(BinaryOpNode expr);
  T visitNumberExpr(NumberNode expr);
  T visitStringExpr(StringNode expr);
  T visitBooleanExpr(BooleanNode expr);
  T visitVariableExpr(VariableNode expr);
}

// Number and Boolean literals
class NumberNode extends Expr {
  final double value;
  NumberNode(this.value);

  @override
  dynamic accept<T>(Visitor<T> visitor) {
    return visitor.visitNumberExpr(this);
  }
}

class StringNode extends Expr {
  final String value;
  StringNode(this.value);

  @override
  dynamic accept<T>(Visitor<T> visitor) {
    return visitor.visitStringExpr(this);
  }
}

class BooleanNode extends Expr {
  final bool value;
  BooleanNode(this.value);

  @override
  dynamic accept<T>(Visitor<T> visitor) {
    return visitor.visitBooleanExpr(this);
  }
}

// Variables
class VariableNode extends Expr {
  final String name;
  VariableNode(this.name);

  @override
  dynamic accept<T>(Visitor<T> visitor) {
    return visitor.visitVariableExpr(this);
  }
}

// Logical Operators
class UnaryOpNode extends Expr {
  final TokenType operator;
  final Expr operand;
  UnaryOpNode(this.operator, this.operand);

  @override
  dynamic accept<T>(Visitor<T> visitor) {
    return visitor.visitUnaryExpr(this);
  }
}

class BinaryOpNode extends Expr {
  final Expr left;
  final TokenType operator;
  final Expr right;
  BinaryOpNode(this.left, this.operator, this.right);

  @override
  dynamic accept<T>(Visitor<T> visitor) {
    return visitor.visitBinaryExpr(this);
  }
}

// Variable Assignment
class AssignmentNode extends Stmt {
  final String name;
  final Expr value;
  AssignmentNode(this.name, this.value);

  @override
  dynamic accept<T>(Visitor<T> visitor) {
    return visitor.visitAssignmentExpr(this);
  }
}

class ConditionalBlock {
  final Expr? condition;
  final List<Stmt> thenBranch;

  ConditionalBlock(this.condition, this.thenBranch);
}

// Conditional Blocks ('maybe'/'whatif'/'nevermind')
class ConditionalNode extends Stmt {
  final List<ConditionalBlock> conditionalBlocks;

  ConditionalNode(
    this.conditionalBlocks,
  );

  @override
  dynamic accept<T>(Visitor<T> visitor) {
    return visitor.visitConditionalStmtExpr(this);
  }
}

// Loop ('weekly sprint') with break & continue
class LoopNode extends Stmt {
  final Expr condition;
  final List<Stmt> body;

  LoopNode(this.condition, this.body);

  @override
  dynamic accept<T>(Visitor<T> visitor) {
    return visitor.visitLoopStmtExpr(this);
  }
}

class BreakNode extends Stmt {
  static final type = BreakNode();

  @override
  dynamic accept<T>(Visitor<T> visitor) {
    return visitor.visitBreakStmtExpr(this);
  }
}

class ContinueNode extends Stmt {
  static final type = ContinueNode();

  @override
  dynamic accept<T>(Visitor<T> visitor) {
    return visitor.visitContinueStmtExpr(this);
  }
}

// Debug Statement
class DebugNode extends Stmt {
  final Expr value;
  DebugNode(this.value);

  @override
  dynamic accept<T>(Visitor<T> visitor) {
    return visitor.visitDebugStmtExpr(this);
  }
}

class ExpressionStmt extends Stmt {
  final Expr expression;
  ExpressionStmt(this.expression);

  @override
  dynamic accept<T>(Visitor<T> visitor) {
    return visitor.visitExpressionStmtExpr(this);
  }
}

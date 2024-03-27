enum TokenType {
  aiWillReplace,
  number,
  string,
  identifier,
  weeklySprint,
  maybe,
  whatIf,
  nevermind,
  debug,
  feature,
  bug,
  thisIsNotRealCode,
  logicalOr,
  logicalAnd,
  greaterThan,
  lessThan,
  greaterThanOrEqual,
  lessThanOrEqual,
  equals,
  plus,
  minus,
  multiply,
  divide,
  modulo,
  equal,
  leftBrace,
  rightBrace,
  leftParen,
  rightParen,
  semicolon
}

class Token {
  final TokenType type;
  final String value;

  Token(this.type, this.value);
}

class Lexer {
  final String input;
  int _position = 0;
  int _start = 0;

  List<Token> tokens = [];

  Lexer(this.input);

  List<Token> tokenize() {
    _skipWhitespace();

    while (_position < input.length) {
      _start = _position;

      if (_matchKeyword()) {
        // Keyword matching - already implemented
      } else if (_matchNumber()) {
        tokens.add(Token(TokenType.number, _extractString()));
      } else if (_matchString()) {
        tokens.add(Token(TokenType.string, _extractString()));
      } else if (_matchIdentifier()) {
        tokens.add(Token(TokenType.identifier, _extractString()));
      } else {
        throw Exception("Unexpected character: ${input[_position]}");
      }

      _skipWhitespace();
    }

    return tokens;
  }

  bool _matchKeyword() {
    final keywords = const {
      "ai will replace": TokenType.aiWillReplace,
      "weekly sprint": TokenType.weeklySprint,
      "maybe": TokenType.maybe,
      "what if": TokenType.whatIf,
      "nevermind": TokenType.nevermind,
      "debug": TokenType.debug,
      "feature": TokenType.feature,
      "bug": TokenType.bug,
      "this is not real code": TokenType.thisIsNotRealCode,
      "||": TokenType.logicalOr,
      "&&": TokenType.logicalAnd,
      ">=": TokenType.greaterThanOrEqual,
      "<=": TokenType.lessThanOrEqual,
      "==": TokenType.equals,
      ">": TokenType.greaterThan,
      "<": TokenType.lessThan,
      "+": TokenType.plus,
      "-": TokenType.minus,
      "*": TokenType.multiply,
      "/": TokenType.divide,
      "%": TokenType.modulo,
      "=": TokenType.equal,
      "{": TokenType.leftBrace,
      "}": TokenType.rightBrace,
      "(": TokenType.leftParen,
      ")": TokenType.rightParen,
      ";": TokenType.semicolon,
      // ... Add more keywords
    };

    for (final entry in keywords.entries) {
      if (_tryMatch(entry.key)) {
        tokens.add(Token(entry.value, entry.key));
        return true;
      }
    }
    return false;
  }

  bool _tryMatch(String pattern) {
    if (input.startsWith(pattern, _position)) {
      _position += pattern.length;
      return true;
    }
    return false;
  }

  bool _matchNumber() {
    int start = _position; // Store starting position

    while (_position < input.length && _isDigit(input.codeUnitAt(_position))) {
      _position++;
    }

    // Optional decimal part
    if ((_position) < input.length && (input[_position] == '.')) {
      _position++;
      while (
          _position < input.length && _isDigit(input.codeUnitAt(_position))) {
        _position++;
      }
    }

    if (_position > start) {
      // Did we match any digits?
      return true;
    }

    return false;
  }

  // Helper function to check for a digit character
  bool _isDigit(int charCode) => charCode >= 48 && charCode <= 57;

  bool _matchString() {
    if (input.codeUnitAt(_position) == 34 ||
        input.codeUnitAt(_position) == 39) {
      final quoteChar = input.codeUnitAt(_position);
      _position++;

      while (_position < input.length &&
          input.codeUnitAt(_position) != quoteChar &&
          input.codeUnitAt(_position) != 10) {
        // Check for newline (\n)
        _position++;
      }

      // Check for unterminated string
      if (_position >= input.length) {
        throw Exception("Unterminated string");
      }

      _position++; // Move past the closing quote
      return true;
    }
    return false;
  }

  bool _matchIdentifier() {
    final regexp = RegExp(r'[a-zA-Z_][a-zA-Z0-9_]*');
    final match = regexp.firstMatch(input.substring(_position));
    if (match != null) {
      _position += match.group(0)!.length;
      return true;
    }
    return false;
  }

  void _skipWhitespace() {
    while (_position < input.length && input[_position].codeUnitAt(0) <= 32) {
      _position++;
    }
  }

  String _extractString() {
    var stringValue = input.substring(_start, _position);
    if (stringValue.startsWith('"') && stringValue.endsWith('"')) {
      stringValue = stringValue.substring(1, stringValue.length - 1);
    }
    return stringValue;
  }
}

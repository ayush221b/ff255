import 'dart:io';
import 'package:args/args.dart';

import 'package:ff255/src/interpreter.dart';
import 'package:ff255/src/lexer.dart';
import 'package:ff255/src/parser.dart';

String bannerText = r"""        
 _______  _______     ___    _____   _____  
|   ____||   ____|   |__ \  | ____| | ____| 
|  |__   |  |__         ) | | |__   | |__   
|   __|  |   __|       / /  |___ \  |___ \  
|  |     |  |         / /_   ___) |  ___) | 
|__|     |__|        |____| |____/  |____/  

A For Fun programming language written with love in Dart by @ayush221b
""";

void main(List<String> arguments) async {
  // Display the cool FF 255 banner
  print(bannerText);

  final parser = ArgParser();
  parser.addOption(
    'file',
    abbr: 'f',
    help: 'Path to the FF255 file that you wish to execute.',
  );

  // Add help flag
  parser.addFlag(
    'help',
    negatable: false,
    abbr: 'h',
    help: 'Displays usage instructions',
  );

  ArgResults argResults;
  try {
    argResults = parser.parse(arguments);
  } on FormatException catch (e) {
    print(e.message);
    print(parser.usage);
    exit(1);
  }

  final filePath = argResults['file'];
  if (filePath == null) {
    print('Please provide a file path.');
    print(parser.usage);
    exit(1);
  }

  // Check file extension
  if (!filePath.endsWith('.ff255')) {
    print('Error: Please provide a file with the .ff255 extension.');
    exit(1);
  }

  try {
    final fileContents = await File(filePath).readAsString();

    final lexer = Lexer(fileContents);
    final tokens = lexer.tokenize();

    final parser = Parser(tokens);
    final statements = parser.parse();

    final interpreter = Interpreter();
    interpreter.interpret(statements);
  } on FileSystemException catch (e) {
    print('Error reading file: $e');
  }
}

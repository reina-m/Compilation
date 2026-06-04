
# MicroGo Compiler

## Overview

MicroGo is a compiler project for a small subset of the Go language.  
The project implements the main stages of a compiler:

1. Lexical analysis
2. Syntax analysis
3. Static type checking
4. MIPS 32-bit code generation

The compiler takes a MicroGo program as input and produces MIPS assembly code.

## Project Structure

The main implemented files are:

- `mgolexer.mll` — lexer for MicroGo tokens
- `mgoparser.mly` — Menhir parser for the MicroGo grammar
- `typechecker.ml` — static type checker
- `compile.ml` — MIPS code generator
- `mips.ml` — MIPS instruction representation and printing utilities

## Features

### Lexical Analysis

The lexer supports:

- MicroGo keywords
- identifiers
- integers
- strings
- operators and delimiters
- line comments and block comments
- automatic semicolon insertion

It also reports lexical errors such as:

- unterminated strings
- integers that are too large
- unknown characters
- unterminated comments

### Syntax Analysis

The parser supports:

- package declarations
- optional `fmt` import
- structure declarations
- function declarations
- variable declarations
- assignments
- `if / else`
- `for` loops
- function calls
- `fmt.Print`
- operator precedence

### Type Checking

The type checker verifies:

- well-formed types
- declared variables and functions
- structure fields
- function calls
- multiple return values
- multiple assignments
- valid `return` statements
- correct `main` function signature
- correct usage of `fmt.Print`

It also includes bonus checks for:

- unused local variables
- consistency between `import "fmt"` and `fmt.Print`

### MIPS Code Generation

The compiler generates MIPS 32-bit assembly code.

It supports:

- integers, booleans, strings and structures
- stack-based local variables
- function calls
- activation records
- heap allocation for structures
- multiple return values using heap-allocated tuples
- printing integers, strings and booleans

## Tests

The compiler was tested on valid and invalid MicroGo programs.

Valid tests include:

- arithmetic expressions
- variable declarations
- loops and conditionals
- structures
- multiple returns
- automatic semicolon insertion

Error tests include:

- lexical errors
- syntax errors
- type errors
- incorrect `main` function
- invalid multiple assignments
- invalid `fmt` usage

## Conclusion

This project implements a complete compilation chain for MicroGo, from source code analysis to MIPS code generation. It demonstrates the connection between grammar, AST construction, static typing, runtime representation, stack management and low-level code generation.

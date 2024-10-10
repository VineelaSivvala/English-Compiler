# English-Compiler
This repository is about creating a compiler for English like Language

# Lex and Yacc Parser Project

## Overview

This project involves creating a lexer and parser using Lex and Yacc to process input strings based on specified lexical and syntactic rules. The primary goal is to tokenize input, validate its structure according to defined specifications, and optionally display the Abstract Syntax Tree (AST) and LL(1) parsing table.

## Lexical Specifications

- **Word**: A string of at least 3 characters and up to 26 characters, excluding any digits and whitespace.
- **Startword**: A Word that begins with an uppercase letter.
- **Stop**: A full stop (.)
- **Comma**: A comma (,)
- **Hyphen**: A hyphen (-)
- **Quotations (Optional)**: Start with “ and end with “, containing zero or more words.
- **Whitespace**: Any spaces or tabs between words (ignored during tokenization).

## Syntactic Specifications

1. The input string must start with a Startword and end with a Stop.
2. Commas and hyphens should be placed between words, and two commas cannot be placed next to each other.
3. If both Commas and Hyphens are present, the parser should handle Commas first.
4. If two Commas or Hyphens are present, the left one should be parsed first.

## Approach

1. **Lexer Implementation**:
   - The lexer is responsible for tokenizing the input string into valid tokens based on the lexical specifications.
   - It checks for words, startwords, stops, commas, and hyphens while ignoring whitespace.
   - If a word exceeds 26 characters, it splits the word into two valid tokens and handles each accordingly.
   
2. **Parser Implementation**:
   - The parser utilizes the generated tokens to validate the structure of the input according to the syntactic specifications.
   - It ensures that the input string follows the specified grammar, providing appropriate error messages for invalid structures.
   - Optional features include displaying the accepted string formed by valid tokens and printing the AST structure.

## Challenges

- Ensuring the lexer accurately identifies and splits long words while managing the tokenization of valid input strings.
- Constructing the parser to effectively handle the precedence of commas and hyphens while adhering to the defined syntactic rules.
- Managing error handling gracefully to provide informative feedback for invalid input.

# Packrat Parser for Blitzmax

VERSION: 0.0.0-alpha.1.2

__UNSTABLE ALPHA RELEASE__
__MAY CONTAIN SERIOUS BUGS AND INCOMPLETE FEATURES__

* [Project Milestones](MILESTONES.md)

A Packrat parser shares many similarities with a recursive descent parser but uses PEG (Parsing Expression Grammar) instead of LL Grammars.

This implementation has several tools and features that can be used in your applications.

* [Installation](https://github.com/blitzmaxmods/packrat.mod/wiki/Installation)
* [PEG Syntax](docs/PEG%20;Definition)

* Pattern matching
* Parsing PEG Grammar
* Generating a Parser
* [Parsing CSV data](https://github.com/blitzmaxmods/packrat.mod/wiki/Parsing-CSV-data)
* Parsing JSON data

# Examples
| MODULE | STATUS | DETAILS |
|----|----|----|
| 01.Macros.bmx | :white_check_mark: | Shows available Macros and how they relate to PEG |
| 02.Operators.bmx | :white_check_mark: | Shows how to use the Macros as operators to perform matching |
| 03.Simple-Match.bmx | :white_check_mark: | Shows how to perform simple matching |
| 04.Parsing-Grammar.bmx | :white_check_mark: | Shows how to use grammar to perform matching |

# Change Logs

| DATE | VERSION | AUTHOR | DETAILS |
|----|----|----|-----|
|12-AUG-2023| 0.0.0-pre-alpha.0.0 | Scaremonger | Outline |
|02-SEP-2023| 0.0.0-pre-alpha.0.1 | Scaremonger | Defined PEG syntax as PEG |
|18-OCT-2023| 0.0.0-pre-alpha.0.2 | Scaremonger | Initial Parser |
|21-OCT-2023| 0.0.0-pre-alpha.0.3 | Scaremonger | Initial BlitzMax PEG Parser |
|09-NOV-2023| 0.0.0-pre-alpha.0.4 | Scaremonger | Initial Transpiler |
|17-NOV-2023| 0.0.0-pre-alpha.0.5 | Scaremonger | Initial Parser generator |
|06-DEC-2023| 0.0.0-pre-alpha.0.6 | Scaremonger | Operators and first Examples added |
|06-DEC-2023| 0.0.0-pre-alpha.0.6 | Scaremonger | Operators and first Examples added |
|06-DEC-2023| 0.0.0-pre-alpha.0.6 | Scaremonger | Operators and first Examples added |
|05-OCT-2025| 0.0.0-alpha.1.0 | Scaremonger | Refactoring begins |
|14-NOV-2025| 0.0.0-alpha.1.1 | Scaremonger | Packrat Parser with Memoisation cache and Examples |
|14-NOV-2025| 0.0.0-alpha.1.2 | Scaremonger | Refactored PEG (DEV) Parser and PEG Generator |

# Next Steps

| VERSION          | DETAILS                   | CURRENT STATE |
| 0.0.0-alpha.1.3  | Error Recovery            | Implemented, requires testing and debugging |
| 0.0.0-alpha.1.4  | PEG Parser for CSV        | PRE-ALPHA, Waiting on refactoring |
| 0.0.0-alpha.1.5  | PEG Parser for JSON       | PRE-ALPHA, Waiting on refactoring |
| 0.0.0-alpha.1.6  | PEG Parser for INI        | PRE-ALPHA, Waiting on refactoring |
| 0.0.0-alpha.1.7  | PEG Parser for BlitzMax   | PRE-ALPHA, Waiting on refactoring |
| 0.0.0-alpha.1.8  | Transpiler                | PRE-ALPHA, Waiting on refactoring |
| 0.0.0-alpha.1.9  | PEG Parser for BlitzBasic | PRE-ALPHA, Waiting on refactoring |
| 0.0.0-alpha.1.10 | PEG Parser for Blitz3D    | PRE-ALPHA, Waiting on refactoring |



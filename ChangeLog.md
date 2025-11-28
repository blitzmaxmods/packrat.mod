# Change Logs
This project is currently in Alpha

# ALPHA - 05 OCT 2025 to DATE
__UNSTABLE ALPHA RELEASE__
__MAY CONTAIN SERIOUS ERRORS AND INCOMPLETE FEATURES__
__UNSUITABLE FOR PRODUCTION__

## Current Build:
__0.0.0-alpha.1.3, Scaremonger__
* 15-NOV-2025, Added metatags to TParsenode (name is now a tag)
* 16-NOV-2025, Several bug fixes and improvements
* 17-NOV-2025, Replaced TPattern.escape() and descape() with encode() and decode()
* 17-NOV-2025, PEG Parser Rule changes:
    * Added rules ARROW, BACKSLASH, HEXBYTE, HEXWORD and ENCODEDOCTET
    * Fixed rules VCHAR and CHAR
    * Fixed double quote encoding bug in CHARSET
* 18-NOV-2025
    * Added helper macro READUNTIL() to packrat.patterns: "READUNTIL <- (!e .)* e"
    * Added Operator macro ERROR() to packrat.patterns:   "{error="Message"}"
    * Added Pattern TError() packrat.parser / operators
* 22-NOV-2025
    * Moved Project milestones to WIKI
    * Added Example 05.PEG-Grammar.bmx
    * Added simple table viewer to example library
    * Added query() to TMemoisation and TParseTree to extract table data (improved debugging)
* 23 NOV 2025
    * Renamed packrat.patterns to packrat.macros (because patterns are something different)
    * Added TGrammar.merge() to allow grammar merging.
    * Created packrat.ABNF to simplyfy core rules
    * Added getGrammarABNF() to packrat.ABNF
    * Created packrat.REGEX to simplyfy core rules
    * Added getGrammarREGEX() to packrat.REGEX
* 24 NOV 2025
	* Bugfixes
	* Added CHARSET:TPattern( charset:Int[] ) macro
	* Added SYMBOL:TPattern( charset:Int[] ) macro
* 25 Nov 2024
	* Bugfixes
	* Removed TRange Operator and merged into TCharset
	* Replaced RANGE() Macro with RANGE() helpers

__0.0.0-alpha.1.2, Scaremonger__
* 14-NOV-2025, Refactored PEG (DEV) Parser and PEG Generator

__0.0.0-alpha.1.1, Scaremonger__
* 14-NOV-2025, Packrat Parser with Memoisation cache and Examples

__0.0.0-alpha.1.0, Scaremonger__
* 05-OCT-2025, Refactoring begins

# PRE-ALPHA - 12 AUG 2023 to 06 DEC 2023
__UNSTABLE PRE-ALPHA RELEASE__
__MAY CONTAIN SERIOUS ERRORS AND INCOMPLETE FEATURES__
__UNSUITABLE FOR PRODUCTION__

__0.0.0-pre-alpha.0.6, Scaremonger__
* 06-DEC-2023, Operators and first Examples added

__0.0.0-pre-alpha.0.5, Scaremonger__
* 17-NOV-2023, Initial Parser generator

__0.0.0-pre-alpha.0.4, Scaremonger__
* 09-NOV-2023, Initial Transpiler

__0.0.0-pre-alpha.0.3, Scaremonger__
* 21-OCT-2023, Initial BlitzMax PEG Parser

__0.0.0-pre-alpha.0.2, Scaremonger__
* 18-OCT-2023, Initial Parser

__0.0.0-pre-alpha.0.1, Scaremonger__
* 02-SEP-2023, Defined PEG syntax as PEG

__0.0.0-pre-alpha.0.0, Scaremonger__
* 12-AUG-2023, Outline


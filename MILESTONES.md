# Project Milestones
| TASK | STATUS | RELEASE | NOTES |
|----|----|----|
| Sort out examples          | :white_check_mark: | BETA      | Done |
| Packrat Parser             | :construction:     | ALPHA     | Not feature complete (Error Recovery) |
| Packrat PEG Parser         | :white_check_mark: | ALPHA     | Not feature complete |
| Parser generator           | :white_check_mark: | BETA      | Done |
| BlitzMax PEG Parser        | :black_circle:     | PRE-ALPHA | Not feature complete |
| Parsing CSV documentation  | :beetle:           | PRE-ALPHA | Not feature complete |
| Parsing JSON documentation | :x:                | n/a       | Pending |

# Modules
| MODULE | STATUS | RELEASE | NOTES |
|----|----|----|
| packrat.patterns  | :white_check_mark: | BETA  | Done |
| packrat.parser    | :construction:     | ALPHA | Not feature complete (Error recovery) |
| packrat.generator | :beetle:           | BETA  | Done |
| packrat.peg       | :construction:     | APLHA | Not feature complete |

# Utilities
| FILENAME | STATUS | RELEASE | NOTES |
|----|----|----|
| packrat.peg/utils/Generate-PEG-Parser.bmx | :beetle: | BETA | Done |

# Known Bugs
* PEG Labels are not being parsed correctly (^label)
* PEG Capture is not being parsed ($expression)
* PEG Case sensitive and Case insensitive strings are not working consistently.
* Named() operator is missing - Currently only rule name is used
* Parser error handling is not working correctly; this is an issue with LABEL
* Review "kind" in TParseNode.new() - Do we still need it?
* Review "depth" in TPattern.getMatch() and Matcher() - Do we still need them?

# Things to do & Known bugs
* Source file headers
* TPattern.find() - Remove traceback argument
* TParsenode.bykind() does not work because kind is nearly always zero!!
* Remove "name" argument from all Parser functions, wrap in Named() if you want a name.
* TParseNode.new() does not save the first argument (pattern)
  - Should it> - if so, where, if not; remove it as an argument!
* PaseError handling has broken it! ERROR() goes into an infinate loop.
* Regular expression compatability is currently commented out
    - This needs to be moved to an optional library along with ABNF notation
* compile.bat/sh should extract current foldername for compile
* Take a look at rule PEG in the dev parser:
    grammar["PEG"] = ZEROORMORE( __("LINE") )
    - This gets wrapped in an additonal CHOICE within the Production parser:
        ' PEG <- ( ( EOI / LINE )* )        WHERE DO THE EXTRA () COME FROM?
        grammar["PEG"] = ..
	        CHOICE([..                      THIS IS FROM THE generate() FUNCTION
		        ZEROORMORE( ..
			        CHOICE( [..
				        __( "EOI" ), ..
				        __( "LINE" ) ..
			        ])..
		        ) ..
	        ])
    - A Trace for the rule also includes a TChoice:
        TChoice[TZeroOrMore[TChoice[TNotPredicate{EOI},TSequence{LINE}]}]]}
* Move unit testing to MAX.UNIT from custom module


# Project Milestones

| TASK | STATUS | NOTES |
|----|----|----|
| Move to parser.mod | :construction: | Repo created |
| Sort out examples | :construction: | Incomplete |
| Parsing CSV documentation | :beetle: | Incomplete |
| Parsing JSON documentation | :x: | Incomplete |
| Packrat Parser | :black_circle: | Done, but not in repo |
| Packrat PEG Parser | :black_circle: | Done, but not in repo |
| Parser generator | :black_circle: | Done, but not in repo |

# Modules
| MODULE | STATUS | NOTES |
|----|----|----|
| packrat.generator | :x: | Needs to be moved to new repo |
| packrat.patterns | :white_check_mark: | Complete |
| packrat.parser | :beetle: | Move to new repo introduced bugs / parsetree tools still included|
| packrat.parsetree | :beetle: | Move to new repo introduced bugs |
| packrat.peg | :beetle: | Move to new repo introduced bugs |
| packrat.visitor | :white_check_mark: | Complete |

# Utilities
| FILENAME | STATUS | NOTES |
|----|----|----|
| peg.mod/Generate-PEG-Parser.bmx | :beetle: | Move to new repo introduced bugs |

# Examples
| MODULE | STATUS | NOTES |
|----|----|----|
| 1.Matching.bmx | :beetle: | Move to new repo introduced bugs |

# Things to do
* Source file headers
* TPattern.find() - Remove traceback argument
* TParsenode.bykind() does not work because kind is nearly always zero!!
* Remove "name" argument from all Parser functions, wrap in Named() if you want a name.
* TParseNode.new() does not save the first argument (pattern)
  - Should it> - if so, where, if not; remove it as an argument!
* PaseError handling has broken it! ERROR() goes into an infinate loop.
* Regular expression compatability is currently commented out - WHY?
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
* In parser.mod/src/operators, "self.name=name" is commented out but functions still accept name argument!
* Move unittesting to MAX.UNIT


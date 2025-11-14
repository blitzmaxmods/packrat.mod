'	PEG PARSER
'	(c) Copyright Si Dunford [Scaremonger], 2023-date, All rights reserved.
'	VERSION 1.0
'
'	A Manually created PEG parser that is used by the Parser generator

' Get the Development Packrat Parser
' THE MANUAL PARSER IS CONSIDERED A DEVELOPMENT VERSION ONLY

' Generate PEG grammar
' NOTE: This is a manually created parser
Type TPackratParser_PEG_DEV Extends TPackratParser

	Method New()
		grammar = New TGrammar( "PEG", "PEG" )	' Create new Grammar
		
		' define core rules
		Local DQUOTE:TPattern = SYMBOL( $22 )
		Local SQUOTE:TPattern = SYMBOL( "'" )

		grammar["HTAB"]     = SYMBOL( $09 )                  ' %d09 = Horizontal Tab  \t
		grammar["LF"]       = SYMBOL( $0A )                  ' %d10 = Line Feed       \n
		grammar["CR"]       = SYMBOL( $0D )                  ' %d13 = Carriage Return \r
		grammar["SP"]       = SYMBOL( $20 )                  ' %d32 = Space
		grammar["DQUOTE"]   = SYMBOL( $22 )                  ' %d34 = Double Quote    "
		grammar["DOLLAR"]   = SYMBOL( $24 )                  ' %d36 = Dollar sign     $
		grammar["SQUOTE"]   = SYMBOL( $27 )                  ' %d39 = Single Quote    '
		grammar["CARET"]    = SYMBOL( $5E )                  ' %d94 = Caret           ^ 

		'DebugStop
		grammar["ALPHA"]    = RANGE( "A-Za-z" )              ' Case insensitive A-Z
		grammar["CHAR"]     = RANGE( Chr($34)+"-"+Chr($7F) ) ' 7 BIt ASCII except CTRL
		grammar["CRLF"]     = CHARSET( Chr($0D)+Chr($0A) )   ' Newline \r\n
		grammar["DIGIT"]    = RANGE( "0-9" )                 ' Digit 0 to 9
		grammar["HEXDIGIT"] = RANGE( "0-9A-Fa-f" )           ' Hexadecimal digits
		'Self["OCTET"]    = RANGE( Chr($00)+Chr($FF) )       ' Any 8 bit character
		'Self["VCHAR"]    = RANGE( Chr($21)+Chr($7E) )       ' visible (printing) characters
		grammar["WSP"]      = CHOICE([ SYMBOL($20), SYMBOL($09) ])  ' Whitespace
		'
		' REGULAR EXPRESSION COMPATABILITY
		' Not implemented - Move this to a library so it can be used by others
'		grammar["\d"]       = RANGE( "0-9" )                   		' Digit 0 to 9
'		grammar["\s"]       = CHOICE([ SYMBOL($20), SYMBOL($09) ])  ' Whitespace
'		grammar["\w"]       = RANGE( "A-Za-z0-9_" )
'		grammar["\D"]       = SEQUENCE([ LITERAL("!"), RANGE( "0-9" ) ])
'		grammar["\S"]       = SEQUENCE([ LITERAL("!"), CHOICE([ SYMBOL($20), SYMBOL($09) ]) ])
'		grammar["\W"]       = SEQUENCE([ LITERAL("!"), RANGE( "A-Za-z0-9_" ) ])

'		grammar["\q"]       = SYMBOL( $22 )							' QUOTE
		
		' WHITESPACE SHORTCUT
		Local _:TPattern = ZEROORMORE( __("WSP") )
		
		' EXTENDED CORE DEFINTIONS
		grammar["NUMBER"]  = ONEORMORE( __("DIGIT") )               	' Number
		grammar["QSTRING"] = SEQUENCE([ DQUOTE, ZEROORMORE( SEQUENCE([ NOTPRED(DQUOTE), RANGE( Chr($20)+Chr($21)+Chr($23)+"-"+Chr($7E) ) ]) ), DQUOTE ])
		grammar["STRING"] = SEQUENCE([ SQUOTE, ZEROORMORE( SEQUENCE([ NOTPRED(SQUOTE), RANGE( Chr($20)+"-"+Chr($26)+Chr($28)+"-"+Chr($7E) ) ]) ), SQUOTE ])
		' EOI <- !.
		grammar["EOI"]     = ..
			SEQUENCE([ ..
				_,..
				NOTPRED( ANY() )..				' End of Input / End of File
			])
		' EOL <- ( _ CR? LF ) 
		grammar["EOL"] = ..
			SEQUENCE([ ..
				_, ..
				OPTIONAL( __("CR") ), ..
				__("LF"), ..
				__("EOI") ..
			])

		'Self["UNTILEOL"] = SEQUENCE( [ ZEROORMORE( SEQUENCE([ NOTPRED( __("EOL") ), ANY() ]) ), __("EOL") ])

		' Flag all core rules to prevent them being shown in output
		'For Local rule:String = EachIn grammar.keys()
		'	Local pattern:TPattern = TPattern( grammar[rule] )
		'	'pattern.hidden = True
		'	pattern.hideCoreRule()
		'Next
	
		' Pre-define PEG rule names
		'DebugStop
		grammar.declare([..
			"ACTION", "ALPHANUMUNDER", "ANDPREDICATE",..
			"CHOICE", "COMMENT", ..
			"EXPRESSION",..
			"GROUP",..
			"LINE",..
			"NAME",..
			"NONTERMINAL", "NOTPREDICATE",..
			"ONEORMORE", "OPTIONAL",..
			"PEG", "PEXPR",..
			"RULE", ..
			"SEQUENCE", ..
			"TERMINAL", "TOEOL", ..
			"ZEROORMORE", "ZEROONEOPT" ])
			
		' Some shortcuts that we can use elsewhere
		'Local SP:TPattern  = __("SP")			' Whitespace
		'Local SP0:TPattern = zeroOrMore(WSP)	' Zero or more whitespace
		'Local SP1:TPattern = oneOrMore(WSP)		' One or more whitespace
		'DebugStop
		Local EOL:TPattern = __("EOL")
		Local EOI:TPattern = __("EOI")
		'Local _:TPattern = zeroOrMore(WSP)		' Optional whitespace
		'Local _:TPattern = ZEROORMORE( __("SP") )
		
		'Local READ_TO_EOL:TPattern = sequence([ zeroOrMore( sequence([ negate(EOL), any() ]) ), EOL ])	' Reads to end of line
		
		grammar["ACTION"]        =..
			SEQUENCE([..
				_, ..
				LITERAL("{"),..
				_,..
				ONEORMORE(__("ALPHANUMUNDER")),..
				_,..
				LITERAL("}") ..
			])
		' ALPHA                  <- [A-Za-z]
		'grammar["ALPHA"]         = CHARSET([ "AZ", "az" ])
		' ALPHANUMUNDER          <- [A-Za-z0-9_]
		grammar["ALPHANUMUNDER"] = RANGE( "A-Za-z0-9_" )
		' ANDPREDICATE           <- "&" EXPRESSION
		grammar["ANDPREDICATE"]  = SEQUENCE( [ SYMBOL("&"), __("EXPRESSION") ])
		' CHOICE                 <- EXPRESSION ( "/" EXPRESSION )+
		grammar["CHOICE"] = ..
			SEQUENCE([ ..
				_, ..
				__("EXPRESSION"), ..
				ONEORMORE( ..
					SEQUENCE([ ..
						_,..
						SYMBOL("/"), ..
						_,..
						__("EXPRESSION") ..
						]) ..
					) ..
				])
		' CHAR					 <- "%" ( ( "d" DIGIT+ ) / ("x" HEXDIGIT+ ) / ("b" ["0","1"]+) )
		grammar["CHAR"]          = ..
			SEQUENCE([ ..
				SYMBOL("%"), ..
				CHOICE([ ..
					SEQUENCE([ LITERAL("d"),ONEORMORE(__("DIGIT")) ]),..
					SEQUENCE([ LITERAL("h"),ONEORMORE(__("HEXDIGIT")) ]),..
					SEQUENCE([ LITERAL("b"),ONEORMORE(CHARSET("01")) ]) ..
					]).. 
				])
		' COMMENT           	 <- SP* "//" (!EOL, .)* EOL
		grammar["COMMENT"]       = SEQUENCE([ _, SYMBOL("#"), __("TOEOL") ])
		' DQUOTE                 <- &034;
		'grammar["DQUOTE"]        = CHARSET( Chr(34) )
		' EOL                    <- SP* "/r"? "/n"
		'grammar["EOL"]           = SEQUENCE( "EOL", [ _, optional( LITERAL("~r") ), LITERAL( "~n" ) ] )
		' EXPRESSION             <- NONTERMINAL / QUOTEDSTRING
		grammar["EXPRESSION"]    = ..
			CHOICE([ ..
				__("NONTERMINAL"), ..
				__("QSTRING") ..
			])
		' GROUP                  <- "(" EXPRESSION ")"  
		grammar["GROUP"]         = SEQUENCE([ LITERAL("("), __("EXPRESSION"), LITERAL(")") ])
		' LINE                   <- LINECOMMENT | BLOCKCOMMENT | RULE | EOL
		grammar["LINE"] = ..
			CHOICE([ ..
				SEQUENCE([ _,__("EOL")]), ..	' Blank line
				__("RULE"), ..											
				__("COMMENT") ..
				])
'				ERROR( READUNTIL(EOL) ) ..
		' NONTERMINAL            <- UPPERCASE+
		' NAME=<expression>
		grammar["NAME"] = ..
			SEQUENCE( [ ..
				ONEORMORE( __("ALPHANUMUNDER") ), ..
				_, ..
				LITERAL("="),..
				_, ..
				__("PEXPR")] )
		grammar["NONTERMINAL"]   = ONEORMORE( __("ALPHA") )    
		' NOTPREDICATE           <- "!" EXPRESSION
		grammar["NOTPREDICATE"]  = SEQUENCE([ LITERAL("!"), __("EXPRESSION") ])
		' ONEORMORE              <- EXPRESSION "+"
		grammar["ONEORMORE"]     = SEQUENCE([ __("EXPRESSION"), LITERAL("+") ])
		' OPTIONAL               <- EXPRESSION "?"
		grammar["OPTIONAL"]      = SEQUENCE([ __("EXPRESSION"), LITERAL("?") ])
		' PEG                    <- LINE+


		grammar["PEG"] = ZEROORMORE( __("LINE") )
'		grammar["PEG"] = ..
'			SEQUENCE([ ..
'				ZEROORMORE( __("LINE") ), ..
'				_,..
'				EOI..
'			])
		' PEXPRESSION            <- CHOICE / SEQUENCE / ZEROONEOOPT / ANDNOT / GROUP / {@EOL}
		grammar["PEXPR"] = ..
			SEQUENCE([ ..
				_,..
				CHOICE([ ..
					__("CHOICE"), ..
					__("SEQUENCE"), ..
					__("ZEROONEOPT"), ..
					__("NOTPREDICATE"), ..
					__("EXPRESSION"), ..
					__("GROUP") ..
				])..
			])
					'ERROR( READUNTIL(__("EOL")) ) ..

			' QUOTEDSTRING           <- DQUOTE (!DQUOTE, .)* DQUOTE
		'grammar["QUOTEDSTRING"]  = SEQUENCE( "QUOTEDSTRING", [ __("DQUOTE"), zeroOrMore( sequence([ NEG(__("DQUOTE")), any() ])), __("DQUOTE") ])
		' RULE                   <- NONTERMINAL SP+ "<-" SP+ PEXPR EOL
		'grammar["RULE"]          = sequence([ choice([ __("NONTERMINAL"), error( "Rule name expected!" )]), SP_, literal("<-"), SP_, __("PEXPR"), EOL ])

		' RULE                   <- <NONTERMINAL> _ <"<-"> _ PEXPR EOL
		grammar["RULE"]  = SEQUENCE([ ..
			_, ..							' Leading whitespace
			__("NONTERMINAL"), ..
			_, ..
			LITERAL( "<-" ), ..
			_, ..
			__("PEXPR"), ..
			EOL ..
			])

		' SEARCH                 <- "@" EXPRESSION
		grammar["SEARCH"]        = SEQUENCE([ SYMBOL("@"), __("EXPRESSION") ])
		' SEQUENCE               <- EXPRESSION EXPRESSION+
		grammar["SEQUENCE"] = ..
			SEQUENCE([ ..
				__("EXPRESSION"), ..
				ONEORMORE( __("EXPRESSION") ) ..
				])
		' TERMINAL               <- ALPHA ALPHANUMUNDER*
		grammar["TERMINAL"]      = SEQUENCE([ __("ALPHA"), ZEROORMORE( __("ALPHANUMUNDER") ) ])
		' TOEOL                  <- 
		grammar["TOEOL"]         = SEQUENCE([ NOTPRED( __("EOL") ), ANY(), __("EOL") ])
		' UPPERCASE              <- [A-Z]
		'grammar["UPPERCASE"]     = RANGE( "AZ" )
		' ZEROORMORE             <- EXPRESSION "*"
		grammar["ZEROORMORE"]    = SEQUENCE([ __("EXPRESSION"), CHARSET("*") ])
		' ZEROONEOOPT            <- ZEROORMORE / ONEORMORE / OPTIONAL
		grammar["ZEROONEOPT"]    = SEQUENCE([ __("EXPRESSION"), __("ONEORMORE"), __("OPTIONAL") ])

		' LABELS
		'grammar["expected"]      <- 


		' Validate the rules
		validate()

	End Method

	' Shortcut to NonTerminal
	Method __:TPattern( name:String )
		Assert grammar.contains( name ), "Undefined Pattern '"+name+"' in definition"
		'Return New TNonTerminal( name, grammar )
		Return New TNonTerminal( name )
	End Method
		
	'Method RULE_PEG:TASTNode( ast:TASTNode )
	'	Return ast
	'End Method
	
	'Method _LINECOMMENT:Object( state:Object )
	'	' SEQUENCE
	'	If Not _LITERAL( state, "//" ); Return Null
	'	Local comment:String = state.readuntil( [EOL,EOI] )
	'	' CREATE NODE
	'	Return New TASTNode( TOKEN_LINE_COMMENT, comment, state )
	'End Method
	
	'	RULE DEFINITION
	
	'Method __START:Object( ast:String )
	'	DebugStop
	'End Method
	
	'Method __PEG:Object( ast:String )
	'End Method
	
End Type

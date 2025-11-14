PEG PARSER
----------

REFERENCES:
========================================
    https://people.seas.harvard.edu/~chong/pubs/gpeg_sle21.pdf

SYNTAX
========================================
RULE "<-" SEQUENCE / CHOICE / ANDPRED / NOTPRED / ANY / ONEORMORE /
		ZEROORMORE / OPTIONAL / GROUP / LITERAL / SYMBOL / RANGE / RULE

	a <- c / d
	a       Rule name
	<-      Definition symbol
	c /d	Pattern      

PATTERNS
========================================
| PEG   | MACRO	      | DESCRIPTION |
|-------|-------------|------------|
| e1 e2 | SEQUENCE    | Matches each pattern in turn, sucecs if all match, fail on first fail |
| e1/e2 | CHOICE      | Matches first is a set of alterative options |
| &e    | ANDPRED     | Positive lookup (Successd if p matches but consumes no input) |
| !e    | NOTPRED     | NOT operator (Succeeds if p does not match) |
| .     | ANY         | Any matching character |
| e+    | ONEORMORE   | Matches One or more of preceeding match |
| e*    | ZEROORMORE  | Matches Zero or More (Kleene Operator) |
| e?    | OPTIONAL    | Matches Zero or More (Kleene Operator) |
| (e)   | GROUP       | Groups patterns together |
|       |             |                          |
| ".."  | LITERAL     | Case sensitive, LITERAL( text ) |
| ".."i | LITERAL     | Case insensitive, LITERAL( text, True ) |
| ^l    | LABEL       | Attch a label to a pattern, LABEL( label, pattern ) |
|       |             |                          |
| %nn   | SYMBOL      | Character encoding |
| [ ]   | RANGE       | Character ranges for example [0-9], [a-zA-Z] |
| [ ]   | CHARSET     | A set of Characters for example ["0","1","2","3","4","5","6","7","8","9"] |
| Text  | NONTERMINAL | Reference to another pre-defined rule |

When defining single symbols such as ">" you can define them in many different ways:

	Local GTR:TPattern = LITERAL( ">" )
	Local GTR:TPattern = CHARSET( ">" )
	Local GTR:TPattern = SYMBOL( ">" )		' Recommeded
	Local GTR:TPattern = SYMBOL( 62 )
	
	In PEG, you would probably have them defined as a LITERAL or a symbol
	
	GTR <- ">"	# Recommeded
	GTR <- %62
	

NOTED PATTERNS:
========================================
!.      EOI (End of Input) Succeeds if it is not possible to accept another character

        Usually defined as:
            EOI <- !.

        Be careful when using this as it can lead to an infinate loop (See Common Issue Below)

@E      Equivalent to (!E .)* E

&p		Equivalent to !!p

MEMOIZATION
========================================
The notation {{p}} is used to mark a pattern for memoization

MACROS
========================================

SEQUENCE([...])		rule <- e1 e2 e3...
	Success if all options match, null if any one fail

	PEG:        example -> "Once" SP "Upon" SP "a" SP "Time
	
	MACRO:		SEQUENCE([ 
					LITERAL("once",False), SPACE, LITERAL("upon",False), SPACE, LITERAL("a",False), SPACE, LITERAL("time",False)
					])

	Options:

		match( example, "Once upon a time" ) = MATCH
		match( example, "Once upon a dream" ) = FAIL

		ERROR: Literal "dream" expected at 1,13

CHOICE([..])
	Success on first match, fail if no matches

NOT PREDICATE
	Success only if pattern matches
	Does not consume any input

		example -> ( "foo" !"bar" )

		match( example, "foobar" )      = FAIL
		match( example, "foo fighter" ) = MATCH 

		On failure it generates "example found at 1"

		example "foobar" -> ( "foo" !"bar" )
		On failure it generates "foobar found at 1"

		#example -> ( "foo" !"bar" )
		On failure it generates no message

* OPERATOR (Zero or more)
Always successful.

    example -> "-"*

    match( example, "2345" ) = MATCH    ""
    match( example, "-234" ) = MATCH    "-"
    match( example, "----" ) = MATCH    "----"


? OPERATOR (Optional / Zero or One)
Always successful.

    example -> "-"? NUMBER

    match( example, "-345" ) = MATCH
    match( example, "2345" ) = MATCH


+ OPERATOR (One or more)
Successful if at least one match, only fails with no matches

    example -> [0-9]+

    match( example, "1234" ) = MATCH
    match( example, "-234" ) = FAILURE

COMMON ISSUES
========================================
	E*
	Zero Or More can match an empty result that could lead to an [infinate loop].

	!E
	Not Predicate returns an empty result that could lead to an [infinate loop].

	&E
	And Predicate returns an empty result that could lead to an [infinate loop].

	SYMBOL <- [+-/*]
	The use of a "-" in a character set is reserved. If you need the "-" symbol; it must be the first or last character otherwise it is used as a range operator.

	SYMBOL <- [+-/*]    == "+" | "," | "-" | "." | "/" | "*"
	SYMBOL <- [-+/*]    == "-" | "+" | "/" | "*"
	SYMBOL <- [+/*-]    == "+" | "/" | "*" | "-"

	In the first example; the range "+" to "/" is selected, followed by a "*"

Left Recursion
========================================

    The following syntax is allowed; but leads to an infinate loop as it is impossible to evaluate:

    SYNTAX <- SYNTAX / "a"

    In this case; the non-terminal "SYNTAX" is used to lookup the rule, which results in another lookup to "SYNTAX" etc.
  
    You can usually get around this by re-writing the expression, for example:

    SYNTAX <- "a"*

Infinate Loops
========================================
	If an expression that returns an empty result (E*, !E, &E) is placed in a pattern that repeats (E*, E+) the cursor does not
	increment and the parser will hang.

		EXAMPLE <- EOI*
		EXAMPLE <- (&.)*

	In a simple loop; this is usally easy to debug, but the loop may exist several steps down in nested syntax which can be very difficult
	to identify.

OPTIONAL SYMBOLS
========================================
Sometimes you may want to select between one or more symbols:

    SYMBOL <- "a" / "b" / "*" / "+"

This will work; but will be slower than using a character set:

    SYMBOL <- [ab*+]


'	unit-test.bmx
'	(c) Copyright Si Dunford [Scaremonger], 2023-date, All rights reserved.
'	VERSION 1.0
'
'	UNIT TEST PACKRAT TOOLS
'

'Import packrat.parser
'Import "../parser.bmx"

'Import packrat.tools
Import "../tools.bmx"

Import unit.testing
'Import "../../unit.testing/testing.bmx"

'	Set up some local variables
Local pattern:TPattern
Local digit:TPattern = RANGE("0-9")
Local hexdigit:TPattern = CHARSET( "0-9A-Fa-f" )
Local grammar:TGrammar = New TGrammar( "TEST", "TEST", True )
grammar["DIGIT"] = digit

'	PREPARE THE TEST TABLE

Local UnitTest:TUnitTest = New TUnitTest( [3,5,32,30] )	
unittest.heading( "PATTERNS" )
unittest.write( ["ID","STATE","NAME","RESULT"] )
unittest.break()

'	TEST PATTERNS

pattern = ANDPRED( digit )
UnitTest.check( "ANDPRED(RANGE(~q0-9~q))", pattern.AsString(), "TAndPredicate[TRange[0123456789]]" )

pattern = Any()
UnitTest.check( "ANY()", pattern.AsString(), "TAny" )

pattern = CAPTURE(Any())
UnitTest.check( "CAPTURE(Any())", pattern.AsString(), "TCapture{''}[TAny]" )

pattern = CAPTURE("test",Any())
UnitTest.check( "CAPTURE(~qtest~q,Any())", pattern.AsString(), "TCapture{'test'}[TAny]" )

pattern = hexdigit
UnitTest.check( "CHARSET(hexdigit)", pattern.AsString(), "TCharSet[0-9A-Fa-f]" ) 

pattern = CHARSET( ["+","-","/","*"] )
UnitTest.check( "CHARSET( [~q+~q,~q-~q,~q/~q,~q*~q] )", pattern.AsString(), "TCharSet[+-/*]" )

pattern = CHOICE( [hexdigit,digit] )
UnitTest.check( "CHOICE([hexdigit,digit])", pattern.AsString(), "TChoice[TCharSet[0-9A-Fa-f],TRange[0123456789]]}" )

pattern = ERROR( hexdigit )
UnitTest.check( "ERROR( hexdigit )", pattern.AsString(), "TError[TCharSet[0-9A-Fa-f]]" )

pattern = EXPECT( hexdigit)
UnitTest.check( "EXPECT( hexdigit )", pattern.AsString(), "TExpect[TCharSet[0-9A-Fa-f]]" )

pattern = GROUP( hexdigit )
UnitTest.check( "GROUP( hexdigit )", pattern.AsString(), "TGroup[TCharSet[0-9A-Fa-f]]" )

pattern = KEYWORD( "Function" )
UnitTest.check( "KEYWORD(~qFunction~q)", pattern.AsString(), "TLiteral{Case-insensitive}[Function]" )

pattern = LITERAL( "Example" )
UnitTest.check( "LITERAL(~qExample~q)", pattern.AsString(), "TLiteral{Case-sensitive}[Example]" )

pattern = LITERAL( "Example", False )
UnitTest.check( "LITERAL(~qExample~q,False)", pattern.AsString(), "TLiteral{Case-insensitive}[Example]" )

' Test grammar lookup (NON-TERMINAL)
pattern = NONTERMINAL( grammar, "DIGIT" )
UnitTest.check( "NONTERMINAL(grammar,~qdigit~q)", pattern.AsString(), "TRange{DIGIT}" )

pattern = NOTPRED( digit )
UnitTest.check( "NOTPRED( digit )", pattern.AsString(), "TNotPredicate[TRange[0123456789]]" )

pattern = ONEORMORE( digit )
UnitTest.check( "ONEORMORE( digit )", pattern.AsString(), "TOneOrMore[TRange[0123456789]]" )

pattern = OPTIONAL( digit )
UnitTest.check( "OPTIONAL( digit )", pattern.AsString(), "TOptional[TRange[0123456789]]" )

pattern = RANGE("0-9")
UnitTest.check( "RANGE(~q0-9~q)", pattern.AsString(), "TRange[0123456789]" )

pattern = RANGE( "0-9A-Fa-f" )
UnitTest.check( "RANGE(~q0-9A-Fa-f~q)", pattern.AsString(), "TRange[0123456789ABCDEFabcdef]" )

'pattern = READUNTIL( digit )
'UnitTest.check( "READUNTIL(~qdigit~q)", pattern.AsString(), "TSequence([ ZEROORMORE( SEQUENCE([ NOTPRED(pattern), ANY() ]) ), pattern ] " )

'pattern = RECOVERLINE()
'UnitTest.check( "RECOVERLINE()", pattern.AsString(), "TSequence([ ZEROORMORE( SEQUENCE([ NOTPRED(pattern), ANY() ]) ), pattern ] )" )

pattern = SEQUENCE( [SYMBOL("$"),hexdigit] )
UnitTest.check( "SEQUENCE([SYMBOL(~q$~q),hexdigit])", pattern.AsString(), "TSequence[TSymbol[$],TCharSet[0-9A-Fa-f]]" )

pattern = SYMBOL( "~t" )
UnitTest.check( "SYMBOL(~q~t~q)", pattern.AsString(), "TSymbol[\t]" )

pattern = SYMBOL( $09 )
UnitTest.check( "SYMBOL($09)", pattern.AsString(), "TSymbol[\t]" )

pattern = ZEROORMORE( digit )
UnitTest.check( "ZEROORMORE(digit)", pattern.AsString(), "TZeroOrMore[TRange[0123456789]]" )




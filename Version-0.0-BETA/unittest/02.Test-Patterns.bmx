' Unit test for Patterns

Import "lib/UnitTest.bmx"

Import packrat.patterns
'Import "../patterns.mod/patterns.bmx"

Type TTestPatterns Extends TTestCase

	Const Text:String = "hello world"

	Method Test_Pattern_Literal_case_Match()		{test}
		Local pattern:TPattern = LITERAL( "hello" )
		Local matches:TPackMatch = pattern.find( Text )
		AssertNotNull( matches )
	End Method

	Method Test_Pattern_Literal_case_Mismatch()		{test}
		Local pattern:TPattern = LITERAL( "HELLO" )
		Local matches:TPackMatch = pattern.find( Text )
		AssertNull( matches )
	End Method

	Method Test_Pattern_Literal_nocase_Match()		{test}
		Local pattern:TPattern = LITERAL( "HELLO", True )
		Local matches:TPackMatch = pattern.find( Text )
		AssertNotNull( matches )
	End Method

	Method Test_Pattern_Literal_nocase_Match_result()		{test}
		Local pattern:TPattern = LITERAL( "HELLO", True )
		Local matches:TPackMatch = pattern.find( Text )
		If Not matches
			AssertNotNull( matches )
		Else
			assertEqual( matches.subexp(0), "hello" )
		EndIf
	End Method

	Method Test_Pattern_Sequence_Match()	{test}
		Local pattern:TPattern = SEQUENCE([ LITERAL( "hello" ), SYMBOL(" "), LITERAL( "world" ) ])
		Local matches:TPackMatch = pattern.find( Text )
		AssertNotNull( matches )
	End Method

	Method test_negative_number()	{test}
		skip( "just because" )
		assertEqual( Abs(-10), 10 )
	EndMethod

	Method test_zero()	{test}
		assertEqual( Abs(0), 0 )
	EndMethod

End Type

' Run the test
Local test:TTestPatterns = New TTestPatterns()
test.run(2)
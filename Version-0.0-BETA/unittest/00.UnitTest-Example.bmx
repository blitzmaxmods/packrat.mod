' Testing the UnitTest Library

' This tests the blitzmax ABS() function

Import "lib/UnitTest.bmx"
'DebugStop

Type TestAbsFunction Extends TTestCase

	Method test_positive_number()	{test}
		title( "Test for positive" )
		assertEqual( Abs(10), 10 )
	EndMethod
	
	Method test_negative_number()	{test}
		assertEqual( Abs(-10), 10 )
	EndMethod

	Method test_zero()	{skip}
		assertEqual( Abs(0), 0 )
	EndMethod

	Method test_Skipped()	{skip="skipping"}
		assertEqual( Abs(-10), 10 )
	EndMethod

	Method test_Skipping() {test}
		skip( "just because" )
		assertEqual( Abs(-10), 10 )
	EndMethod

End Type

' Run the test
Local test:TestAbsFunction = New TestAbsFunction()
test.run(2)
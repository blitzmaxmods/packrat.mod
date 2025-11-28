'	01. Unit test for Memotable
'	(c) Copyright Si Dunford [Scaremonger], 2023-date, All rights reserved.
'	VERSION 1.0
'

Import "lib/UnitTest.bmx"

'Import packrat.parser
Import "../parser.mod/parser.bmx"
DebugStop

Type TTestMemo Extends TTestCase

	Const RULEID:Int  = 10
	Const START:Int   = 1024
	Const MISSING:Int = 2000
	
	Field memotable:TMemoisation
	Field parsenode:TParseNode

	Method New()
		memotable = New TMemoisation()
		parsenode = New TParseNode()
	End Method

	' Setting a value for the first time should work
	Method Test_Memo_set_first_time()	{test}
	DebugStop
		Local set:Int = memotable.set( RULEID, START, parsenode )
		assertTrue( set )
	End Method

	' Setting a value for the second time should fail
	Method Test_Memo_set_second_time()	{test}
		Local set:Int = memotable.set( RULEID, START, parsenode )
		assertFalse( set )
	End Method

	Method Test_Memo_get_isNotNull()	{test}

		Local memo:TMemoEntry = memotable.get( RULEID, START )
		assertNotNull( memo )
			
	EndMethod
	
	Method Test_Memo_get_node()	{test}
		
		Local memo:TMemoEntry = memotable.get( RULEID, START )
		assertEqual( memo.result, parsenode )
			
	EndMethod

	Method Test_Memo_get_missingrule()	{test}
		
		Local memo:TMemoEntry = memotable.get( MISSING, START )
		assertNull( memo )
			
	EndMethod

	Method Test_Memo_get_missingposition()	{test}
		
		Local memo:TMemoEntry = memotable.get( RULEID, MISSING )
		assertNull( memo )
			
	EndMethod

	Method Test_Memo_get_zerozero()	{test}
		
		Local memo:TMemoEntry = memotable.get( 0, 0 )
		assertNull( memo )
			
	EndMethod

	Method Test_Memo_set_zerozero()	{test}
		
		memotable.set( 0, 0, parsenode )
		Local memo:TMemoEntry = memotable.get( 0, 0 )
		assertNotNull( memo )
			
	EndMethod

End Type

' Run the test
Local test:TTestMemo = New TTestMemo()
test.run(2)

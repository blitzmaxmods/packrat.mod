' Unit testing library
' (c) Copyright Si Dunford, Oct 2025
' Version 1.0

' Inspired by Java "JUnit" and Python "TestCase"

' CHANGELOG
' VER
' 1.01  12OCT25  Changed test metadata to {test} to ease later migration to MAX.UNIT

Rem FUTURE EXPANSION (If anyone is interested)
* Add additional overridden assert*() methods for other datatypes like short, byte SColor8 etc.
* Test array size and matching members
* Test Tlist and TMap members match
* Test for key in an array or TMap
* Test if an exception is raised (might be able to simply catch it)
* Add ANSI escape codes to print a dot or cross every time a test is run
	- Followed by results when complete
* Assert*() functions should raise a failure which is picked up by
	- the calling run() loop as a try/catch and not the convaluted way it does it now.

* Add subTest:int()
	- Subtest will not raise these errors (or will handle them itself)
	
EndRem

Type TTestCase

	Private

	Field skiptest:Int = False
	Field name:String     ' Title of the test
	Field testname:String  ' Name of the method
	Field typename:String	' Name of the type being tested.
	Field verbosity:Int = 1

	Field testresults:String[]
	Field teststart:Int
	Field testcount:Int

	' Check whether we should skip this test
	Method skipped:Int()
		If Not skiptest; Return False
		skiptest = False
		'testname = ""
		Return True
	EndMethod
	
	' Produce a report
	Method report( success:Int, reason:String="" )
	'DebugStop
		If verbosity = 0; Return
		Local result:String
		'
		If verbosity = 2; result = typename+"::"
		'
		If name
			result :+ name
		Else
			result :+ testname
		EndIf
		'
		If success = -1
			result :+ " --> SKIP"
		Else If success
			result :+ " --> OK"
		Else ' failure
			result :+ " --> FAIL"
		EndIf
		If reason; result :+ " ("+reason+")"
		testresults :+ [result]
	End Method
		
	Public
	' 
	Method Run( verbosity:Int = 1 )
		'DebugStop
		Self.verbosity = Max(Min(verbosity,2),0)
		testresults = []
		testcount = 0
		teststart = MilliSecs()
		
		' Run the tests using reflection
		Local this:TTestCase = Self
		Local typeid:TTypeId = TTypeId.forObject( Self )
		typename = typeid.name()
		
		Local methods:TList = typeid.enumMethods()
		For Local m:TMethod = EachIn methods
			testname = m.name()

			'If m.isPrivate(); Continue
			'If m.name() = "New"; Continue

			If m.HasMetaData( "skip" )
				Local skipstr:String = m.Metadata("skip")
				If Not skipstr Or skipstr="1"; skipstr = "Flagged by metadata"
				report( -1, skipstr )
			EndIf

			If m.HasMetaData( "test" ) Or m.HasMetaData( "TEST" )
				If m.HasMetaData( "TEST" ); testresults :+ [typename+"::"+testname+" - {TEST} is depreciated"]
				testcount :+ 1
				m.invoke(Self)
				name = ""		' Reset the title if set by test 
			EndIf
		Next 
		
		Local testend:Int = MilliSecs()
		
		' print results
		If Len(testresults) >0
			Print " "[..40].Replace(" ","-")
			For Local result:String = EachIn testresults
				Print result
			Next
		EndIf
		
		' Print summary
		Print " "[..40].Replace(" ","-")
		Print "Ran "+testcount+" tests in "+ Float(testend-teststart)/1000 + "s"
		
	End Method
	
	' EQUALITY
	
	Method AssertEqual( condition:Float, expected:Float )
		If skipped(); Return
		report( condition = expected )
	End Method

	Method AssertEqual( condition:Int, expected:Int )
		If skipped(); Return
		report( condition = expected )
	End Method

	Method AssertEqual( condition:String, expected:String )
		If skipped(); Return
		report( condition = expected )
	End Method

	Method AssertEqual( condition:Object, expected:Object )
		If skipped(); Return
		report( condition = expected )
	End Method
	
	' INEQUALITY
	
	Method AssertNotEqual( condition:Int, expected:Int )
		If skipped(); Return
		report( condition <> expected )
	End Method

	' BOOLEAN

	Method AssertTrue( condition:Int )
		If skipped(); Return
		report( condition = True )
	End Method

	Method AssertFalse( condition:Int )
		If skipped(); Return
		report( condition = False )
	End Method

	' OBJECTS
	
	Method AssertNull( obj:Object )
		If skipped(); Return
		report( obj = Null )
	End Method
	
	Method AssertNotNull( obj:Object )
		If skipped(); Return
		report( obj <> Null )
	End Method

	Method AssertType( obj:Object, expected:String, matchCase:Int=False )
		If skipped(); Return
		Local typeid:TTypeId = TTypeId.forObject( obj )
		If matchcase
			report( typeid.name() = expected )
		Else
			report( Lower(typeid.name()) = Lower(expected) )
		EndIf
	End Method

	Method AssertNotType( obj:Object, expected:String, matchCase:Int=False )
		If skipped(); Return
		Local typeid:TTypeId = TTypeId.forObject( obj )
		If matchcase
			report( typeid.name() <> expected )
		Else
			report( Lower(typeid.name()) <> Lower(expected) )
		EndIf
	End Method
	
	' This method always fails a test
	Method fail( reason:String )
		report( False, reason )
	End Method

	' Override the test title. Default is the method name.
	Method title( name:String )
		Self.name = name
	EndMethod

	Method skip( reason:String )
		report( -1, reason )
		skiptest = True
	EndMethod

	Method skipif( condition:Int, reason:String )
		If Not condition; Return
		report( -1, reason )
		skiptest = True
	EndMethod

	Method skipunless( condition:Int, reason:String )
		If condition; Return
		report( -1, reason )
		skiptest = True
	EndMethod
	
EndType

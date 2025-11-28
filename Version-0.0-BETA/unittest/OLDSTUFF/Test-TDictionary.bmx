SuperStrict

Import "../src/TDictionary.bmx"

DebugStop

Type TTest
	Field name:String
	
	Method New( name:String )
		Self.name = name
	End Method
	
End Type

Local dict:TDictionary = New TDictionary()

Print "-----"

dict["ONE"] = New TTest( "ONE" )
dict["TWO"] = New TTest( "TWO" )
dict["THREE"] = New TTest( "THREE" )

Print TTest(dict["ONE"]).name
Print TTest(dict["TWO"]).name
Print TTest(dict["THREE"]).name

Print "-----"

dict["TWO"] = New TTest( "FOUR" )

Print TTest(dict["ONE"]).name
Print TTest(dict["TWO"]).name
Print TTest(dict["THREE"]).name

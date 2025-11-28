
Function Raiseif( condition:Int, action:Object )
	If condition; Throw action
End Function

' Exception for a bad or missing starting rule in your grammar
Type TPackratBadStart Extends TBlitzException

	Field name:String
	
	Method New( name:String )
		Self.name = name
	End Method

	Method ToString:String() Override
		Return "Start rule '"+name+"' is not defined"
	End Method
	
EndType



include "general.stuff"

import general.stuff

' Example Comment

const SCAREMONGER:int = 22

global NAME:string = "SCAREMONGER"


function ABC( test:string )
end Function

function DEF( test:string, number:int )
end Function
REM
function XYZ:string()
	return "hello"
end Function

' Function variable
function GHI( test( something:string, number:int ), testing:int( something:string) )
end Function

function JKL( test(), testing:int() )
end Function

function MNO( test( abc( jkl() ) ) )
end Function
ENDREM

struct SScaremonger
	field x:int
end struct

interface IScaremonger
	blah
end interface

enum EScaremonger
end enum

REM Example
end Rem

Type Thing
	method hello()
	end method
end type

Type TMessage extends Something
	Private
	Field _id:String	' Test "
	
	Method new( methd:String, payload:JSON )	', params:JSON=Null )
		' Arguments

    end method

    method init()
		Self.methd = methd
		Self.J = payload

        local m:int = $0001
		
		' Extractions
		params = payload.find( "params" )
		
		' Extract ID (if there is one) 
		If payload.contains( "id" )
			request = True
			_id = payload.find( "id" ).toString()
		End If

	End Method
			
	' Getter!
	Method getid:String()
		Return _id
	End Method

	' Helper function for message distribution
	Method send()
		lsp.distribute( Self )
	End Method
End Type

While true
wend

repeat

    local name:int

until True

repeat
    if true then exit 
forever

for local n:int = 1 to 10 ; next
for local n:int = 1 until 10 ; next
for local item:object = eachin list
next

function ABC()
end Function

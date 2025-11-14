SuperStrict
'	03.Simple-Matching.bmx
'	(c) Copyright Si Dunford, Dec 2024, All rights reserved
'
'	Version 1.0
'
'	The purpose of this example is to show you how to perform a simple string match

'Import packrat.patterns
Import "../patterns.mod/patterns.bmx"

' Create a pattern

Local hello:TPattern = LITERAL( "hello", CASE_INSENSITIVE )
Local space:TPattern = CHARSET( " " )
Local world:TPattern = LITERAL( "world", CASE_INSENSITIVE )

Local pattern:TPattern = SEQUENCE([ hello, space, world ])
Print "PATTERN <-"+pattern.toPEG()

Local match:TMatchResult 

' Now perform a find on a string
match = pattern.match( "Hello World" )
If match.found()
	Print "Match found"
Else
	Print "No match"
EndIf

match = pattern.match( "Hello there" )
If match.found()
	Print "Match found"
Else
	Print "No match"
EndIf

match = pattern.match( "Hello world of warcraft" )
If match.found()
	Print "Match found"
Else
	Print "No match"
EndIf

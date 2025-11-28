SuperStrict

'	MATCHING.BMX
'	(c) Copyright Si Dunford [Scaremonger], Dec 2024, All rights reserved
'	VERSION: 1.0
'
'	This example shows how to perform pattern matching with Packrat.Parser

'Import Packrat.Parser
Import "../parser.mod/parser.bmx"
Import "../peg.mod/peg.bmx"

Local REPEAT_COUNT:Int = 10000

' Our aim is the extract dates (MM/DD/YYYY) from the following sentence:

Local sentence:String = "The dates are: 12/30/1969, 6/4/1974 and 8/15/1980"

' To match dates in a string, ignoring all seperators and other characters we need to
' create a PEG definition that looks something like this:

Local CR:String = "~n"
Local date_peg:String = ""
date_peg :+ "sentence <- skip (date [skip])+" +CR
date_peg :+ "skip     <- !number" +CR
date_peg :+ "date     <- month '/' day '/' year" +CR
date_peg :+ "month    <- number" +CR
date_peg :+ "day      <- number" +CR
date_peg :+ "year     <- number" +CR
date_peg :+ "number   <- [0-9]+" +CR

' You'll recognise the defintion of a date using month, day and year which is very similar
' to regex. The sentence is defined as a skip rule followed by one or more dates, with each date
' followed by optional skipped text.

' Now we need to create a parser from our PEG definition

'DebugStop
Print date_peg.Replace("~n","¯")

Local Parser:TPackratParser = TPEG.GetParser( TPEG.DEVELOPMENT )
If Not parser; End
DebugStop
Local tree:TParseTree = Parser.Parse( date_peg )
'Local tree:TParseTree = ParsePEG( date_peg )
End
DebugStop

' Create a Pattern from the PEG definition
'Local pattern:TPattern = PEGParser( TPackrat.Parse( 

'	Parse the CSV definition using the PEG parser
DebugStop
Local PEG:TPackratParser     = TPEG.GetParser()
Local csv_tree:TParseTree
Try
	DebugStop
	csv_tree = PEG.parse( date_peg )
Catch e:TParserException
	Print "## EXCEPTION: "+e.message()
	Print "## TRACEBACK: "+e.traceback()
'	End
EndTry

' MATCH USING PATTERN

Local matches:TPackMatch
matches = pattern.find( Text )
For Local i:Int = 0 Until matches.subCount()
	Print "Match "+i+". "+matches.SubExp( i )
Next

matches = pattern.byName( "date" )
For Local i:Int = 0 Until matches.subCount()
	Print "Match "+i+". "+matches.SubExp( i )
Next

' OLD STUFF

csv_tree.reveal()
Local pparser:TPackratParser = TPEG.Create( date_peg )

DebugStop

' The tests here uses a pre-compiled expression
Local timer:Int = MilliSecs()

Print "+---------------------------------------"
Print "| PEG PARSER"
Print "+---------------------------------------"
timer = MilliSecs()
'For Local test:Int = 1 To REPEAT_COUNT

	' Match our datestring
	'Local result:TParseNode = pattern.match( sentence,, pos )

'Next
Print "PEG PARSER TOOK: "+(MilliSecs()-timer) + " ms"

Print "+---------------------------------------"
Print "| REGEX"
Print "+---------------------------------------"

Local regex:TRegEx = TRegEx.Create("(\d+)[-/](\d+)[-/](\d+)")


timer = MilliSecs()
For Local test:Int = 1 To REPEAT_COUNT
	Try

		Local results:String[]
		Local match:TRegExMatch = regex.Find(sentence)
		
		While match
			'Print "~nDate -"+ match.SubExp(0)
			results :+ [match.subexp(0)]
			match = regex.Find()
		Wend

	Catch e:TRegExException

		Print "Error : " + e.ToString()
		
	End Try
Next
Print "REGEX TOOK: "+(MilliSecs()-timer) + " ms"

Print "DONE"
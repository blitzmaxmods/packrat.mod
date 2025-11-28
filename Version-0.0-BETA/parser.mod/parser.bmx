' PACKRAT PARSER MODULE FOR BLITZMAXNG
' (c) Copyright Si Dunford [Scaremonger], 2023-date, All rights reserved.
' VERSION 1.0

' 04 OCT 2025  V1.01  Scaremonger  Updated to new repo
'
'Module packrat.parser

' REMEMBER - MATCH START POSITION ARE ZERO-BASED

Import brl.event
Import brl.intmap
Import brl.retro
Import Text.regex	' Used by parser generator to perform keyword replacements

Import packrat.visitor
'Import packrat.parsetree

'Include "src/Compound.bmx"
Include "src/Constants.bmx"
Include "src/Exceptions.bmx"
Include "src/Extensions.bmx"
'Include "src/Extras.bmx"
'Include "src/Functions.bmx"
Include "src/Operators.bmx"
'nclude "src/Visitors.bmx"
Include "src/TDictionary.bmx"
Include "src/TGrammar.bmx"
Include "src/TParseNode.bmx"
Include "src/TParseTree.bmx"
Include "src/TParseError.bmx"
Include "src/TPackratParser.bmx"
'Include "src/TPackrat_PEG_Parser.bmx"
Include "src/TPattern.bmx"
'Include "src/TParserGenerator.bmx"
Include "src/TMemoisation.bmx"
Include "src/TTextDocument.bmx"
Include "src/TActivity.bmx"
Include "src/TPackMatch.bmx"

'
'Include "tools/ExtractGrammar.bmx"

'Global DEBUGGER:Int = False

Rem
THIS FUNCTION SHOWED PARSING AS IT PROGRESSED AND WAS ONLY USEFUL TO THE POINT OF
CHECKING THAT EACH OPERATOR RESPONDED CORRECTLY ON SUCCESS/FAILURE

Function debug( depth:Int, doc:String, start:Int, this:TPattern, optional:Object=Null, count:Int=0, total:Int=0 )
?debug
	If Not TPackratParser.DEBUGGER; Return
	Local str:String, ptype:String	', name:String
	'name = this.named
	ptype = this.typeof()
	'If name = ""; name = "(anon)"
	Local text:String = doc[ start..(start+4) ]+".. "
	text = text.Replace("~t","\t")
	text = text.Replace("~n","\n")
	text = text.Replace("~r","\r")
	str = Right("0000"+start,4)+" "+text+" "[..depth*2] + ptype
	If count>0 And total>0; str :+ "("+count+"/"+total+")" 
	'
	Local pattern:TPattern = TPattern( optional )
	Local message:String = String( optional )
	If pattern<>Null
		'If pattern.name=""
		'	str :+ ", (anon)"
		'Else
		'	str :+ ", "+pattern.name
		'End If
		str :+ " <- " + pattern.PEG()
	ElseIf message <> ""
		str :+ ", "+ message
	End If
	Print( str )
?
End Function
EndRem

Interface IViewable
	Method getChildren:IViewable[]()
	Method getText:String[]()
	Method getCaption:String()
End Interface

Rem
' Simple string cleanser to remove unDebugables.
Function Cleanse:String( text:String )
	'text = text.Replace( " ", "\s" )
	text = text.Replace( "~t", "\t" )
	text = text.Replace( "~n", "\n" )
	text = text.Replace( "~r", "\r" )
	Local result:String
'DebugStop
	For Local ch:Byte = EachIn text
		If ch>31 And ch<127
			result:+Chr(ch)
		Else
			result :+ "."
		EndIf
	Next
	Return result
End Function
EndRem

'Function escape_V1:String( text:String )
'	Local str:String 
'	For Local n:Int = 0 Until Len(text)
'		Local ch:Int = text[n..n+1]
'		Select True
'		Case ch=32;	str :+ "\s"
'		Case ch=34; str :+ "\q"
'		Case ch=33 Or ch>34 And ch<128
'			str :+ Chr(ch)
'		Case ch=09;	str :+ "\t"
'		Case ch=10;	str :+ "\n"
'		Case ch=13;	str :+ "\r"
'		Default
'			' This is an invalid character, so just drop it for now...
'		End Select
'	Next	
'	Return str
'End Function

Function escape:String( Text:String )
	Local escaped:String	
	Local n:Int
	While n<Text.Length
		Local ch:Int = Asc(Text[n..n+1])
		If ch=9 
			escaped :+ "\t"
		ElseIf ch=10
			escaped :+ "\n"
		ElseIf ch=13
			escaped :+ "\r"
		ElseIf ch<33 Or ch=92 Or ( ch>125 And ch<256 )
			escaped :+ "\x"+Hex(ch)[6..]
		ElseIf ch>256	'UNICODE
'TODO: Add full support for unicode
			DebugStop
			' THIS IS NOT TESTED - Should produce \uNNNN
			escaped :+ "\u"+Hex(ch)[4..]
			DebugStop		
		ElseIf ch=34
			escaped :+ "\q"
		Else
			escaped :+ Chr(ch)
		End If
		n:+1
	Wend
	Return escaped	
End Function

Function descape:String( Text:String )
'TODO: Optimise and support unprintables

	DebugLog "DESCAPE() IS UNTESTED"
	DebugStop

	Local descaped:String
	Local n:Int
	While n<Text.Length
		Select Text[n]
		Case "\"	' ESCAPED
DebugStop
			n:+1
			Select Text[n..n+1]
			Case "\";	descaped :+ "\"
			Case "n";	descaped :+ "~n"
			Case "r";	descaped :+ "~r"
			Case "t";	descaped :+ "~t"
			Case "q";	descaped :+ "~q"
			Case Chr(34);	descaped :+ "~q"
			Case "x"
				descaped :+ Chr( Int( "$"+Text[n..n+2] ) )
				n:+2
			Case "u"
				descaped :+ Chr( Int( "$"+Text[n..n+4] ) )
				n:+4
			Default
				' Invalid encoded character, so ignore
			End Select
			n:+1
		Default
DebugStop
			descaped :+ Text[n..n+1]
			n:+1
		End Select
	Wend
	Return descaped
End Function

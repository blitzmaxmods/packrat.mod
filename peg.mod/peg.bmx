'	PARSER.PEG
'	(c) Copyright Si Dunford, NOV 2025, All Rights Reserved. 
'   VERSION: 1.0
'
'	A Parser that uses the Packrat Parser to Parse PEG.
'
'	*******
'	WARNING: You must run the Generator first to create TPackratParser_PEG.bmx
'	*******
'

SuperStrict

'Module packrat.peg
Import "../parser.mod/parser.bmx"

'Import packrat.macros
Import "../macros.mod/macros.bmx"

Include "dev/TPackratParser_PEG_DEV.bmx"	' MANUALLY GENERATED
Include "bin/TPackratParser_PEG.bmx"		' PACKRAT GENERATED

Include "../Examples/library/showtable.bmx"

'Include "src/TParseTree2PEG.bmx"			' Tool to convert ParseTree into PEG

' Parser Registration - Allows PEG parsers to be registered when module imported
' and an instance created simply by referencing it with getParser( "name" )
'Private Global parser_registration:TStringMap = New TStringMap()

' Create a Parser for a given PEG definition
Function CreateParserFromPEG:TPackratParser( PEG_definition:String, development:Int=False, verbose:Int=False )

	' Use PEG Parser to parse PEG into a ParseTree
	DebugStop
	Local pegparser:TPackratParser = GetParser( development )
	If verbose; pegparser.setverbose( True )
	Print pegparser.grammar.toPeg()
	
	DebugStop ' THIS IS RETURNING NULL
	Local parsetree:TParseTree = pegparser.parse( PEG_definition )
DebugStop
	'pegparser.showMemotable()

' Query Parsetree
Local memo:TMemoisation = pegparser.getMemotable()
If memo
	Print( "~nMEMOTABLE")
	showtable( memo.query() )
EndIf
DebugStop
Print( "~nPARSETREE")
showtable( parsetree.query() )
DebugStop
'Local query:String[][] = parsetree.query()
'For Local row:String[] = EachIn query
'	
'	DebugStop
'Next

	' Create new parser extracting grammar from Parsetree



	' Extract grammar from a parsetree and create new parser
DebugStop	
'NEED To FIND THIS Function
'Type TTreeToGrammar Or extractGrammar() - these are defined previously, just need To find And refactor them
	
	Local grammar:TGrammar = parsetree.extractGrammar()
	Return New TPackratParser( grammar )

End Function

' Helper functions to obtain a copy of Core Grammar rules from otehr modules
Function GetGrammar:TGrammar( name:String )
	Throw( "getGrammar( name:string ) is Not implemented yet" )
'	Local factory:TGrammar()
	' factory = TGrammar()(grammar_registration.valueforKey( name )
	' If factory; return factory()
	Return Null
EndFunction

' Helper functions to obtain a copy of the PEG Parser
Function GetParser:TPackratParser( development:Int=False )
	If Not development; Return New TPackratParser_PEG()
	DebugLog( "WARNING; You are using the development PEG Parser" )
	Return New TPackratParser_PEG_DEV()
End Function

Function GetParser:TPackratParser( name:String )
	Throw( "getParser( name:string ) is Not implemented yet" )
'	Local factory:TPackratParser()
	' factory = TPackratParser()(parser_registration.valueforKey( name )
	' If factory; return factory()
	Return Null
EndFunction

' Core rules for PEG Parser
Function getPEGCoreRules:TGrammar()
	Throw( "getPEGCoreRules() is Not implemented yet" )
	Local grammar:TGrammar = New TGrammar
	grammar["WSP"] = CHARSET([$09,$20])
	grammar["EOL"] = CHOICE([ SYMBOL([$0D,$0A]), SYMBOL($0A) ])
	
	Return grammar
End Function

' Parser registration allows you to call getParser( name )
Function RegisterParser:Int( name:String, factory:TPackratParser() )
	Throw( "RegisterParser() is Not implemented yet" )
	
	' Add to stringmap 
' TODO: Cannot add a Function pointer, maybe we need reflection here
	'parser_registration.insert( Lower(name), Object(factory) )
End Function

' Grammar registration allows you to call getGrammar( name )
Function RegisterGrammar:Int( name:String, factory:TGrammar() )
	Throw( "RegisterGrammar() is Not implemented yet" )
	' Add to stringmap 
' TODO: Cannot add a Function pointer, maybe we need reflection here
	'grammar_registration.insert( Lower(name), Object(factory) )
End Function

' Register PEG core rules
'RegisterGrammar( "PEG", getPEGCoreRules )


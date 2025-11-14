
'Module packrat.parser
'TODO: If TMatchResult.error is not used; remove it.

'Import packrat.parser
'Import "../parser.mod/parser.bmx"

' Structure to hold a pattern return result
'	If node is null
'		no match has been found, we should use the value in label
'		to identify what to do
'		If label set:
'			we use the label as a rule and use it for error recovery
'		if label is unset
'			we backtrack as normal
'	if node is NOT NULL
'		A match has been found, WE MUST IGNORE THE LABEL
'
'                NODE      LABEL     ERRORPOS
'	SUCCESS      NOT-NULL  (ignored) n/a       Match found
'   FAIL NORMAL  NULL      NULL      Farthest  Backtrack
'   FAIL ERROR   NULL      REQUIRED  ErrorPos  Error Recovery
'  




'Include "src/Errorcodes.bmx"
Include "src/Exceptions.bmx"
Include "src/Operators.bmx"

Include "src/TDictionary.bmx"
Include "src/TGrammar.bmx"
Include "src/TMemoisation.bmx"
Include "src/TParseNode.bmx"
Include "src/TPattern.bmx"
Include "src/TTextDocument.bmx"

' Packrat Parser
Include "src/TMatchResult.bmx"
Include "src/TPackratParser.bmx"
Include "src/TParseContext.bmx"
Include "src/TParseTree.bmx"
Include "src/TSearchEnumerator.bmx"

' PARSER OPTION BITS
'Const PARSEOPT_VERBOSE:Int        = $0001	'0000 0000 0000 0001	Verbose Processing
Const PARSEOPT_NO_MEMOISATION:Int = $0002	'0000 0000 0000 0010	Disable Memoisation


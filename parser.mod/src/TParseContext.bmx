
' A Structure used during parsing to hold the current parse state
Type TParseContext
	Field doc:TTextDocument
	Field grammar:TGrammar
	Field memotable:TMemoisation	' Parse Cache
	Field verbose:Int = False

	' Tree debugging
	Field trace:String[] = New String[10]
	Field depth:Int = 0

	' Normal grammar matcher
	Method New( doc:TTextDocument, grammar:TGrammar, usecache:Int=True, verbose:Int=False )
		Self.doc     = doc
		Self.grammar = grammar
		Self.verbose = verbose
		If useCache; memotable = New TMemoisation( verbose )
	End Method

	' Simple pattern matcher
	Method New( doc:TTextDocument, pattern:TPattern, usecache:Int=True, verbose:Int=False )
		Self.doc         = doc
		Self.grammar     = New TGrammar( "SIMPLE" )
		Self.verbose = verbose
		grammar["START"] = pattern
		If useCache; memotable = New TMemoisation( verbose )
	End Method

	' Enable verbose debugging
	Method setVerbose( state:Int = True )
		verbose = state
		If memotable; memotable.setVerbose( state )
	End Method
	
	' Pop a leaf from the trace
	Method pop( message:String="" )
		Print "< "+ " / ".join( trace[..depth] )+ " :: ~q"+message+"~q"
		depth :- 1
		If depth <0; Throw( "CONTEXT STACK FAILURE" )
	EndMethod

	' Pop a leaf from the trace
	Method pop( start:Int, finish:Int )
		Print "< "+ " / ".join( trace[..depth] )+ " :: OK=~q"+doc.extract( start, finish)+"~q"
		depth :- 1
		If depth <0; Throw( "CONTEXT STACK FAILURE" )
	EndMethod

	' Push a leaf to the trace
	Method push( leaf:String )
		'DebugStop
		If depth>=Len(trace); trace=trace[..(Len(trace)+10)]
		trace[depth] = leaf
		depth :+1
		Print "> "+ " / ".join( trace[..depth] )
	End Method
	
	' Push a leaf to the trace
	'method branch( message:String )
	'Return " / ".join( trace )+ " :: "+message
	'End Method
	
EndType
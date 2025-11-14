
' A Structure used during parsing to hold the current parse state
Type TParseContext
	Field doc:TTextDocument
	Field grammar:TGrammar
	Field memotable:TMemoisation	' Parse Cache
	Field verbose:Int = False

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
	
EndType
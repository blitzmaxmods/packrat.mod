
' Read characters until we hit an expression
' This is useful for:
'	- Reading to end of line: READUNTIL( EOL, ANY )
'	- Reading string until the next quote: READUNTIL( DQUOTE, VCHAR )
' (!e .)* e
Public Function READUNTIL:TPattern( finish:TPattern, pattern:TPattern )
	Return ..
		SEQUENCE([..
			ZEROORMORE(..
				GROUP(..
					SEQUENCE([ ..
						NOTPRED( finish ),..
						pattern..
					]) ..
				)..
			),..
			finish ..
		])
End Function

' Return a range of characters
Public Function RANGE:String( start:Int, finish:Int )
	If start<0 Or finish>255 Or start>finish; Return ""
	Return TCharset.ASCII8[start..finish]
End Function

Public Function RANGE:String( startstr:String, finishstr:String )
	Local start:Int = Asc(startstr)
	Local finish:Int = Asc(finishstr)
	If start<0 Or finish>255 Or start>finish; Return ""
	Return TCharset.ASCII8[start..finish]
End Function

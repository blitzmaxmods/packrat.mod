SuperStrict

' We use a dummy TParseNode here so that we dont need to include the whole parser
Type TParseNode
	Field x:Int
End Type

Include "../src/TMemoisation.bmx"

Local memo:TMemoisation = New TMemoisation( 4 )
Local node:TParseNode

' TEST GROWTH OF TABLE
memo.grow( 8, 4 )		' Grow X
memo.grow( 8, 8 )		' Grow Y
memo.grow( 12, 12 )		' Grow X&Y

DebugStop 
' Will not work after here due to EVAL disable in TMemoisation

' TEST APPLY RULE FOR FIRST TIME
node = memo.Apply( 3,1 )

' TEST APPLY RULE FOR SECOND TIME
node = memo.Apply( 3,1 )

' TEST APPLY RULE WITH INFINATE LOOP
node = memo.Apply( 4,3 )


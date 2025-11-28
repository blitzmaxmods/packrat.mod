SuperStrict

'   BMX.VISITOR
'   (c) Copyright Si Dunford, MMM 2022, All Rights Reserved. 
'   VERSION: 1.0
'
'	Blitzmax implementation of the visitor pattern
'
'   CHANGES:
'   09 NOV 2023  V0.1  Initial Creation
'   08 DEC 2024  V0.2  Renamed PNode to VNode
'	07 DEC 2024  V1.0  Module Creation And Publication To Github
'
Rem
bbdoc: bmx.visitor
about: 
End Rem
Module packrat.visitor
Import brl.reflection

' EXPORTS
Include "src/VNode.bmx"
Include "src/TVisitor.bmx"

Interface IVisitable
	Method accept:Int( visitor:IVisitor )
End Interface

Interface IVisitor
	Method visit:Int( visitable:IVisitable )
End Interface

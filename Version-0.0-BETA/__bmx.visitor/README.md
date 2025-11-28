# bmx.visitor
# PRE-BETA - NOT WORKING - NOT READY FOR DOWNLOAD

A Blitzmax implementation of the Visitor Pattern


On the object that should be vistable, add the interface and method as follows:

Type TMyType Implements IVisitable

	' IVisitable
	Public Method accept:Int( visitor:IVisitor )
		Return visitor.visit( Self )
	End Method

End Type



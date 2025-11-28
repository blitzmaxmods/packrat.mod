
' Displays a multi dimensional string array as a table
' You can insert a horizontal line by adding a tab "~t" into the first cell of any row

Function showTable( table:String[][] )

	' Calculate column widths
	
	Local cols:Int[] = [0]
	For Local y:Int = 0 Until Len( table )
		If table[y][0]="~t"; Continue
		For Local x:Int = 0 Until Len( table[y] )
			If Len(cols) < x+1; cols :+ [0]
			cols[x] = Max( cols[x], Len( table[y][x] ) )
		Next
	Next

	' Draw table to stdout

	'DebugStop
	For Local y:Int = 0 Until Len(table)
		Local line:String ="|"
		If table[y][0]="~t"; line = "+"
		For Local x:Int = 0 Until Len( cols )
			If table[y][0]="~t"
				line :+ (" "[..(cols[x]+2)]).Replace(" ","-")+"+"
			Else
				If Len(table[y])>x
					line :+ " "+table[y][x][..cols[x]]+" |"
				Else
					line:+ " "[..(cols[x]+2)]+"|"
				EndIf
			EndIf
		Next
		Print line
	Next
	
End Function

SuperStrict
'Framework brl.retro

Import "md5digest.mod/md5digest.bmx"
Import "digest.mod/digest.bmx"

Local data:String = "Hello World"

Local digest:TMessageDigest = GetMessageDigest("MD5")

If digest Then
	Print digest.Digest(data)
End If
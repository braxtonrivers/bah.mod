SuperStrict

Framework BaH.Persistence
Import BRL.StandardIO
Import BRL.Random

Type abc
	Const bits:String = "<>`~~~q~r~n!@£$%^&*()|}{:?abcdefghijklmnopqrstuvwxyz¡€#¢∞§¶•ªº–≠"

	Field text:String
	Method Create:abc()
		For Local i:Int = 0 Until 128
			Local index:Int = Rand(0, bits.length-1)
			text:+ bits[index..index+1]
		Next
		
		Return Self
	End Method
End Type

SeedRnd(MilliSecs())


Local obj:abc = New abc.Create()
Print obj.text

TPersist.format = True
Local s:String = TPersist.Serialize(obj)
Print s + "~n~n~n"

obj = abc(TPersist.DeSerialize(s))
Print TPersist.Serialize(obj)
Print obj.text

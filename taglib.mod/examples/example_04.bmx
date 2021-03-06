'
' Show tags, properties and embedded images for an mp4/m4a (aac).
'
SuperStrict

Framework BaH.TagLib
Import BRL.StandardIO
Import BRL.FileSystem
Import brl.glmax2d
Import brl.bankstream
Import bah.freeimage

' path to an mp3...
Local path:String = "/Volumes/media/Music/Город 312/Обернись/05 Сквозняк.m4a"

Graphics 800, 600, 0

Global images:TList = New TList

ShowTagInfo(path)

' something to display?
If Not images.IsEmpty() Then

	While Not KeyHit(key_escape)
		Cls
		
		Local x:Int = 0, y:Int = 0, yoff:Int = 0
		
		For Local image:TImage = EachIn images
			DrawImage image, x, y
			
			x:+ image.width + 5
			yoff = Max(yoff, image.height)
			
			If x > GraphicsWidth() Then
				y:+ yoff + 5
				yoff = 0
			End If
		Next
		
		
		Flip
	Wend

End If

End


Function ShowTagInfo(filename:String)

	Local file:TTLMP4File = New TTLMP4File.Create(filename)
	
	If file.isValid() Then

		Print "******************** ~q" + filename + "~q ********************"

		Local tag:TTLMP4Tag = file.tag()
		
		If tag Then
		
			For Local item:TTLMP4Item = EachIn tag.itemList()
				
				' text details...
				Local strings:String[] = item.toStrings()
				If strings.length > 0 Then
					Local s:String = "item : "
					For Local st:String = EachIn strings
						s:+ st + " "
					Next
					Print s
				End If
				
				' images...
				For Local art:TTLMP4CoverArt = EachIn item.toCoverArtList()
				
					' retrieve the picture data
					Local data:TTLByteVector = art.data()

					If data Then
						' make a bankified version of the data
						Local bank:TBank = data.bank()
						If bank Then
							' load into a pixmap
							' images are stored in their original format. e.g. JPEG, PNG, etc.
							Local pixmap:TPixmap = LoadPixmap(CreateBankStream(bank))
							If pixmap Then
								Print "cover art : w = " + pixmap.width + " : h = " + pixmap.height
								' create an image
								images.AddLast(LoadImage(pixmap))
							End If
						End If
					
					End If
				Next
			Next

			Print "~nTag"
		
			Print "title   - ~q" + tag.title()   + "~q"
			Print "artist  - ~q" + tag.artist()  + "~q"
			Print "album   - ~q" + tag.album()   + "~q"
			Print "year    - ~q" + tag.year()    + "~q"
			Print "comment - ~q" + tag.comment() + "~q"
			Print "track   - ~q" + tag.track()   + "~q"
			Print "genre   - ~q" + tag.genre()   + "~q"

		Else
			Print "file does not have a valid id3v2 tag"
		End If

		Print "~n"
		
		' free the file
		file.Free()
	End If

End Function




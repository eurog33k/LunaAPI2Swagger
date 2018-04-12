#tag Module
Protected Module request
	#tag Method, Flags = &h0
		Sub request(myAPIsocket AS APISocket, requestUrl As JSONItem_MTC)
		  // Set up the socket
		  // "mySocket" should be a property stored elsewhere so it will not go out of scope
		  
		  //Set the headers
		  myAPIsocket.ClearRequestHeaders
		  
		  if requestUrl.Child("headers").IsObject Then
		    Dim strHeaderNames() As String=requestUrl.Child("headers").Names
		    For each strHeaderName As String In strHeaderNames
		      Dim strHeaderValue As String= requestUrl.Child("headers").Value(strHeaderName).StringValue
		      myAPIsocket.RequestHeader(StringToText(strHeaderName)) = StringToText(strHeaderValue)
		    Next
		  else
		    For i As Integer=0 to requestUrl.Child("headers").Count-1
		      Dim strHeaderField As String= requestUrl.Child("headers").Value(i).StringValue
		      Dim strHeaderName As String=Trim(NthField(strHeaderField,":",1))
		      Dim strHeaderValue As String=Trim(NthField(strHeaderField,":",2))
		      myAPIsocket.RequestHeader(StringToText(strHeaderName)) = StringToText(strHeaderValue)
		    Next
		  end if
		  
		  //Set the data
		  if requestUrl.HasName("body") and requestUrl.Child("body").Count>0 Then
		    
		    Dim txtDataLine As Text
		    Dim txtData() As Text
		    Dim txtDataAssembled As Text
		    Dim strBoundary As String = "--" + Right(EncodeHex(MD5(Str(Microseconds))), 24) + "--bndry"
		    Static CRLF As String = EndOfLine.Windows
		    
		    Dim iCount As Integer=requestUrl.Child("body").Count-1
		    Dim bBoundaryUsed As Boolean=False
		    
		    For i As Integer=0 to iCount
		      Dim tmp As JSONItem_MTC=requestUrl.Child("body").Value(i)
		      Dim strBodyName As String=tmp.Name(0)
		      Dim strBodyValue As String=tmp.Value(strBodyName)
		      if strBodyName<>"" Then
		        bBoundaryUsed=True
		        txtDataLine=StringToText("--" + strBoundary + CRLF)
		      end if
		      if strBodyName="file" Then
		        Dim tmpFile As Xojo.IO.FolderItem //get file based on strBodyValue
		        Dim tis As Xojo.IO.TextInputStream
		        tmpFile=Xojo.IO.SpecialFolder.Documents.Child("swaggertestfiles").Child(StringToText(strBodyValue))
		        tis = Xojo.IO.TextInputStream.Open(tmpFile,Xojo.Core.TextEncoding.UTF8)
		        dim strFileContent as Text = tis.ReadAll
		        Dim strFileName As String=tmpFile.DisplayName
		        txtDataLine=txtDataLine + StringToText("Content-Disposition: form-data; name=""" + strBodyName + """; filename=""" + strFileName + """" + CRLF)
		        txtDataLine=txtDataLine + StringToText("Content-Type: multipart/form-data" + CRLF + CRLF)
		        txtDataLine=txtDataLine + strFileContent + StringToText(CRLF)
		      else
		        if strBodyName<>"" Then
		          txtDataLine=txtDataLine + StringToText("Content-Disposition: form-data; name=""" + strBodyName + """" + CRLF + CRLF)
		          txtDataLine=txtDataLine + StringToText("Content-Type: Content-Type: application/json" + CRLF + CRLF)
		          txtDataLine=txtDataLine + StringToText(tmp.ToString + CRLF)
		        else
		          'txtDataLine=txtDataLine + StringToText("Content-Type: Content-Type: application/json" + CRLF + CRLF)
		          txtDataLine=txtDataLine + StringToText(strBodyValue + CRLF)
		        end if
		      end if
		      txtData.Append txtDataLine
		    Next
		    txtDataAssembled=Text.Join(txtData,"&")
		    if bBoundaryUsed=true Then
		      txtDataAssembled=txtDataAssembled + StringToText("--" + strBoundary + "--" + CRLF)
		    else
		      txtDataAssembled=txtDataAssembled + StringToText(CRLF)
		    end if
		    
		    Dim mbData As xojo.Core.MemoryBlock=Xojo.Core.TextEncoding.UTF8.ConvertTextToData(txtDataAssembled)
		    'if bBoundaryUsed=True Then
		    myAPIsocket.SetRequestContent(mbData,"multipart/form-data")
		    'else
		    'myAPIsocket.SetRequestContent(mbData,"application/json")
		    'end if
		  end if
		  
		  // Set the URL
		  dim url as Text = StringToText(requestUrl.Child("requestUrl").Value("url").StringValue)
		  
		  //Set the method
		  Dim txtMethod As Text=StringToText(requestUrl.Child("requestUrl").Value("method").StringValue)
		  myAPIsocket.method=txtMethod
		  
		  // Send Asynchronous Request
		  dStartTime=Microseconds
		  myAPIsocket.Send(txtMethod,url)
		  
		  
		End Sub
	#tag EndMethod


	#tag ViewBehavior
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
	#tag EndViewBehavior
End Module
#tag EndModule

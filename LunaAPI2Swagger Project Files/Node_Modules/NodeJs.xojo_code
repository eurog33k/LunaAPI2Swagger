#tag Module
Protected Module NodeJs
	#tag Method, Flags = &h0
		Function Slice(extends MyString As String, iStart As Integer) As String
		  Dim strReturn As String
		  Dim myArr() As String=Split(MyString,",")
		  Dim iEnd As Integer
		  iEnd=myArr.Ubound+1
		  strReturn=MyString.Slice(iStart,iEnd)
		  Return strReturn
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Slice(extends MyString As String, iStart As Integer, iEnd As Integer) As String
		  Dim myArr() As String=Split(MyString,",")
		  Dim iStartInternal As Integer
		  Dim iEndInternal As Integer
		  Dim i As Integer
		  If iStart>=0 and iEnd>=0 and iEnd<=iStart Then
		    Return ""
		  End If
		  If iStart>=0 Then
		    iStartInternal=iStart
		  Else
		    iStartInternal=myArr.Ubound + 1 + iStart
		  End If
		  if iEnd>=0 Then
		    iEndInternal=iEnd
		  Else
		    iEndInternal=myArr.Ubound + 1 + iEnd
		    if iEndInternal<0 then
		      iEndInternal=0
		    end if
		  end if
		  For i=myArr.Ubound DownTo iEndInternal
		    myArr.Remove(i)
		  Next 
		  if myArr.Ubound<>-1 then
		    For i=iStartInternal-1 downto 0
		      if i<=myArr.Ubound Then
		        myArr.Remove(i)
		      end if
		    Next
		  else
		    Return ""
		  end if
		  Dim strReturn As String
		  strReturn=join(myArr,",")
		  Return strReturn
		  
		End Function
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

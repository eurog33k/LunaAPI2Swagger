#tag Class
Protected Class APICall
	#tag Method, Flags = &h0
		Sub StartCall()
		  DoAPIRequest
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		jAPIBodyParameters As JSONItem_MTC
	#tag EndProperty

	#tag Property, Flags = &h0
		jAPIHeaderParameters As JSONItem_MTC
	#tag EndProperty

	#tag Property, Flags = &h0
		jAPIPathParameters As JSONItem_MTC
	#tag EndProperty

	#tag Property, Flags = &h0
		jAPIQueryParameters As JSONItem_MTC
	#tag EndProperty

	#tag Property, Flags = &h0
		mySocket As APISocket
	#tag EndProperty

	#tag Property, Flags = &h0
		strAPIPath As String
	#tag EndProperty

	#tag Property, Flags = &h0
		strAPIVersion As String
	#tag EndProperty

	#tag Property, Flags = &h0
		strBasePath As String
	#tag EndProperty

	#tag Property, Flags = &h0
		strHost As String
	#tag EndProperty

	#tag Property, Flags = &h0
		strHTTPConnectionMethod As String
	#tag EndProperty

	#tag Property, Flags = &h0
		strHTTPMethod As String
	#tag EndProperty

	#tag Property, Flags = &h0
		strTestMethodAndName As String
	#tag EndProperty


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
			Name="strAPIPath"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="strAPIVersion"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="strBasePath"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="strHost"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="strHTTPConnectionMethod"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="strHTTPMethod"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="strTestMethodAndName"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
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
End Class
#tag EndClass

#tag Class
Protected Class APICalls
	#tag Method, Flags = &h0
		Sub PragmaWarnings()
		  
		  #Pragma Warning "Don't forget to adjust the test parameters for v1_Contacts_GET"
		  #Pragma Warning "Don't forget to adjust the test parameters for v1_Contacts_DELETE"
		  #Pragma Warning "Don't forget to adjust the test parameters for v1_Contacts_POST"
		  #Pragma Warning "Don't forget to adjust the test parameters for v1_Contacts_PUT"
		  #Pragma Warning "Don't forget to adjust the test parameters for v1_Reset_GET"
		  #Pragma Warning "You might need to adjust the test parameters for v1_Contacts_GET due to changes to the call"
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		strHost As String
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			[
			{
			"test1": {
			"APIPath": "/Contacts/{emailaddress}",
			"PathParameters": {
			"emailaddress": "timdietrich@me.com"
			}
			}
			}
			]
			
			
		#tag EndNote
		v1_Contacts_DELETE As String = "[ { ""test1"": { ""APIPath"": ""/Contacts/{emailaddress}"", ""PathParameters"": { ""emailaddress"": ""timdietrich@me.com"" } } } ]"
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			[
			{
			"test1": {
			"APIPath": "/Contacts"
			}
			},
			{
			"test2": {
			"APIPath": "/Contacts/{emailaddress}",
			"PathParameters": {
			"emailaddress": "ShirleySBruce@einrot.com"
			}
			}
			},
			{
			"test3": {
			"APIPath": "/Contacts/{emailaddress}",
			"PathParameters": {
			"emailaddress": "ShirleySBruce@einrot.com"
			},
			"QueryParameters": {
			"columns": "GivenName,Surname"
			}
			}
			}
			]
			
			
		#tag EndNote
		v1_Contacts_GET As String = "[ { ""test1"": { ""APIPath"": ""/Contacts"" } }, { ""test2"": { ""APIPath"": ""/Contacts/{emailaddress}"", ""PathParameters"": { ""emailaddress"": ""ShirleySBruce@einrot.com"" } } }, { ""test3"": { ""APIPath"": ""/Contacts/{emailaddress}"", ""PathParameters"": { ""emailaddress"": ""ShirleySBruce@einrot.com"" }, ""QueryParameters"": { ""columns"": ""GivenName,Surname"" } } } ]"
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			[
			{
			"test1": {
			"APIPath": "/Contacts",
			"BodyParameters": {
			"Title":"Mr.","GivenName":"Timothy","Surname":"Dietrich","StreetAddress":"500 Xojo Way","City":"Sedona","State":"AZ","ZipCode":"86336","EmailAddress":"timdietrich@me.com","TelephoneNumber":"800-555-4TIM","Occupation":"Apple TV App Developer","Company":"Dietrich Enterprises, LLC","Domain":"timdietrich.me"
			}
			}
			}
			]
			
			
		#tag EndNote
		v1_Contacts_POST As String = "[ { ""test1"": { ""APIPath"": ""/Contacts"", ""BodyParameters"": { ""Title"":""Mr."",""GivenName"":""Timothy"",""Surname"":""Dietrich"",""StreetAddress"":""500 Xojo Way"",""City"":""Sedona"",""State"":""AZ"",""ZipCode"":""86336"",""EmailAddress"":""timdietrich@me.com"",""TelephoneNumber"":""800-555-4TIM"",""Occupation"":""Apple TV App Developer"",""Company"":""Dietrich Enterprises, LLC"",""Domain"":""timdietrich.me"" } } } ]"
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			[
			{
			"test1": {
			"APIPath": "/Contacts/{emailaddress}",
			"PathParameters": {
			"emailaddress": "timdietrich@me.com"
			},
			"BodyParameters": {
			"Title":"Mr.","GivenName":"Timothy","Surname":"Dietrich","StreetAddress":"500 Xojo Way","City":"Sedona","State":"AZ","ZipCode":"86336","EmailAddress":"timdietrich@me.com","TelephoneNumber":"800-555-4TIM","Occupation":"Apple TV App Developer","Company":"Dietrich Enterprises, LLC","Domain":"timdietrich.me"
			}
			}
			}
			]
			
		#tag EndNote
		v1_Contacts_PUT As String = "[ { ""test1"": { ""APIPath"": ""/Contacts/{emailaddress}"", ""PathParameters"": { ""emailaddress"": ""timdietrich@me.com"" }, ""BodyParameters"": { ""Title"":""Mr."",""GivenName"":""Timothy"",""Surname"":""Dietrich"",""StreetAddress"":""500 Xojo Way"",""City"":""Sedona"",""State"":""AZ"",""ZipCode"":""86336"",""EmailAddress"":""timdietrich@me.com"",""TelephoneNumber"":""800-555-4TIM"",""Occupation"":""Apple TV App Developer"",""Company"":""Dietrich Enterprises, LLC"",""Domain"":""timdietrich.me"" } } } ]"
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			{
			"Authorization": {
			"required": true,
			"type": "string",
			"description": "AuthorizationKey needed to Access the API"
			}
			
		#tag EndNote
		v1_Credentials As String = "{ ""Authorization"": { ""required"": true, ""type"": ""string"", ""description"": ""AuthorizationKey needed to Access the API"" } }"
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			[
			{
			"test1": {
			"APIPath": "/Reset",
			"HeaderParameters": {
			"ResetAuthorization": "Bearer MySuperSecretResetPassword"
			}
			}
			}
			]
			
			
		#tag EndNote
		v1_Reset_GET As String = "[ { ""test1"": { ""APIPath"": ""/Reset"", ""HeaderParameters"": { ""ResetAuthorization"": ""Bearer MySuperSecretResetPassword"" } } } ]"
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			[
			"v1_Reset_GET (test1)",
			"v1_Contacts_GET (test1)",
			"v1_Contacts_GET (test2)",
			"v1_Contacts_GET (test3)",
			"v1_Contacts_POST (test1)",
			"v1_Contacts_PUT (test1)",
			"v1_Contacts_DELETE (test1)"
			]
		#tag EndNote
		v1_Sequence As String = "[ ""v1_Reset_GET (test1)"", ""v1_Contacts_GET (test1)"", ""v1_Contacts_GET (test2)"", ""v1_Contacts_GET (test3)"", ""v1_Contacts_POST (test1)"", ""v1_Contacts_PUT (test1)"", ""v1_Contacts_DELETE (test1)"" ]"
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
			Name="strHost"
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
		#tag ViewProperty
			Name="v1_Contacts_DELETE"
			Group="Behavior"
			InitialValue="[{""""test1"""":{""""APIPath"""":""""/Contacts/{emailaddress}"""",""""PathParameters"""":{""""emailaddress"""":0}}}]"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="v1_Contacts_GET"
			Group="Behavior"
			InitialValue="[{""""test1"""":{""""APIPath"""":""""/Contacts""""}},{""""test2"""":{""""APIPath"""":""""/Contacts/{emailaddress}"""",""""PathParameters"""":{""""emailaddress"""":""""""""}}}]"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="v1_Contacts_POST"
			Group="Behavior"
			InitialValue="[ { """"test1"""": { """"APIPath"""": """"/Contacts"""", """"BodyParameters"""": { """"Title"""":""""Mr."""",""""GivenName"""":""""Timothy"""",""""Surname"""":""""Dietrich"""",""""StreetAddress"""":""""500 Xojo Way"""",""""City"""":""""Sedona"""",""""State"""":""""AZ"""",""""ZipCode"""":""""86336"""",""""EmailAddress"""":""""timdietrich@me.com"""",""""TelephoneNumber"""":""""800-555-4TIM"""",""""Occupation"""":""""Apple TV App Developer"""",""""Company"""":""""Dietrich Enterprises, LLC"""",""""Domain"""":""""timdietrich.me"""" } } } ]"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="v1_Contacts_PUT"
			Group="Behavior"
			InitialValue="[ { """"test1"""": { """"APIPath"""": """"/Contacts/{emailaddress}"""", """"PathParameters"""": { """"emailaddress"""": """"timdietrich@me.com"""" }, """"BodyParameters"""": { """"Title"""":""""Mr."""",""""GivenName"""":""""Timothy"""",""""Surname"""":""""Dietrich"""",""""StreetAddress"""":""""500 Xojo Way"""",""""City"""":""""Sedona"""",""""State"""":""""AZ"""",""""ZipCode"""":""""86336"""",""""EmailAddress"""":""""timdietrich@me.com"""",""""TelephoneNumber"""":""""800-555-4TIM"""",""""Occupation"""":""""Apple TV App Developer"""",""""Company"""":""""Dietrich Enterprises, LLC"""",""""Domain"""":""""timdietrich.me"""" } } } ]"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="v1_Credentials"
			Group="Behavior"
			InitialValue="{ """"Clientnr"""": { """"required"""": true, """"type"""": """"integer"""", """"description"""": """"Clientnr of the Use IT Group client"""" }, """"AccessToken"""": { """"required"""": true, """"type"""": """"string"""", """"description"""": """"AccessToken received from the Use IT Group activation system"""" } }"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="v1_Reset_GET"
			Group="Behavior"
			InitialValue="[{""""test1"""":{""""APIPath"""":""""/Reset""""}}]"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="v1_Sequence"
			Group="Behavior"
			InitialValue="[ """"v1_Reset_GET (test1)"""", """"v1_Contacts_GET (test1)"""", """"v1_Contacts_GET (test2)"""", """"v1_Contacts_POST (test1)"""", """"v1_Contacts_PUT (test1)"""", """"v1_Contacts_DELETE (test1)"""" ]"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass

#tag Class
Protected Class APICallDocs
	#tag Property, Flags = &h0
		#tag Note
			{
			"PathSpecific": {
			"/Contacts/{emailaddress}": {
			"apiinfoq": [
			{
			"name": "description",
			"value": "Delete a Contact"
			},
			{
			"name": "summary",
			"value": "Delete Contacts"
			},
			{
			"name": "externalDocsUrl",
			"value": "https://www.lunaapi.ga/Luna/LunaAPICalls.v1_Contacts_DELETE.html"
			},
			{
			"name": "operationId",
			"value": "DeleteContacts"
			},
			{
			"name": "tags",
			"value": "DELETE,Contacts"
			}
			],
			"PathParameters": {
			"emailaddress": {
			"description": "The emailaddress of the Contact you want to delete.",
			"type": "string",
			"required": true
			}
			}
			}
			},
			"HeaderParameters": {
			"Authorization": {
			"type": "string",
			"required": true,
			"description": "Authorization received to access the API"
			}
			}
			}
			
		#tag EndNote
		v1_Contacts_DELETE As String = "{""PathSpecific"":{""\/Contacts\/{emailaddress}"":{""apiinfoq"":[{""name"":""description"",""value"":""Delete a Contact""},{""name"":""summary"",""value"":""Delete Contacts""},{""name"":""externalDocsUrl"",""value"":""https:\/\/www.lunaapi.ga\/Luna\/LunaAPICalls.v1_Contacts_DELETE.html""},{""name"":""operationId"",""value"":""DeleteContacts""},{""name"":""tags"",""value"":""DELETE,Contacts""}],""PathParameters"":{""emailaddress"":{""description"":""The emailaddress of the Contact you want to delete."",""type"":""string"",""required"":true}}}},""HeaderParameters"":{""Authorization"":{""type"":""string"",""required"":true,""description"":""Authorization received to access the API""}}}"
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			{
			"PathSpecific": {
			"/Contacts": {
			"apiinfoq": [
			{
			"name": "description",
			"value": "Get a list of Contacts"
			},
			{
			"name": "summary",
			"value": "List Contacts"
			},
			{
			"name": "externalDocsUrl",
			"value": "https://www.lunaapi.ga/Luna/LunaAPICalls.v1_Contacts_GET.html"
			},
			{
			"name": "operationId",
			"value": "GetContacts"
			},
			{
			"name": "tags",
			"value": "LIST,GET,Contacts"
			}
			]
			},
			"/Contacts/{emailaddress}": {
			"apiinfoq": [
			{
			"name": "description",
			"value": "Get one specific Contact based on emailaddress"
			},
			{
			"name": "summary",
			"value": "Get Contact"
			},
			{
			"name": "externalDocsUrl",
			"value": "https://www.lunaapi.ga/Luna/LunaAPICalls.v1_Contacts_GET.html"
			},
			{
			"name": "operationId",
			"value": "GetContact"
			},
			{
			"name": "tags",
			"value": "GET,Contacts"
			}
			],
			"PathParameters": {
			"emailaddress": {
			"description": "The emailaddress of the Contact you want to get.",
			"type": "string",
			"required": true
			}
			}
			}
			},
			"HeaderParameters": {
			"Authorization": {
			"type": "string",
			"required": true,
			"description": "Authorization received to access the API"
			}
			},
			"QueryParameters": {
			"columns": {
			"type": "string",
			"required": false,
			"description": "the columns you want to get returned, seperated by comma’s"
			}
			}
			}
			
		#tag EndNote
		v1_Contacts_GET As String = "{""PathSpecific"":{""\/Contacts"":{""apiinfoq"":[{""name"":""description"",""value"":""Get a list of Contacts""},{""name"":""summary"",""value"":""List Contacts""},{""name"":""externalDocsUrl"",""value"":""https:\/\/www.lunaapi.ga\/Luna\/LunaAPICalls.v1_Contacts_GET.html""},{""name"":""operationId"",""value"":""GetContacts""},{""name"":""tags"",""value"":""LIST,GET,Contacts""}]},""\/Contacts\/{emailaddress}"":{""apiinfoq"":[{""name"":""description"",""value"":""Get one specific Contact based on emailaddress""},{""name"":""summary"",""value"":""Get Contact""},{""name"":""externalDocsUrl"",""value"":""https:\/\/www.lunaapi.ga\/Luna\/LunaAPICalls.v1_Contacts_GET.html""},{""name"":""operationId"",""value"":""GetContact""},{""name"":""tags"",""value"":""GET,Contacts""}],""PathParameters"":{""emailaddress"":{""description"":""The emailaddress of the Contact you want to get."",""type"":""string"",""required"":true}}}},""HeaderParameters"":{""Authorization"":{""type"":""string"",""required"":true,""description"":""Authorization received to access the API""}},""QueryParameters"":{""columns"":{""type"":""string"",""required"":false,""description"":""the columns you want to get returned, seperated by comma’s""}}}"
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			{
			"PathSpecific": {
			"/Contacts": {
			"apiinfoq": [
			{
			"name": "description",
			"value": "Insert a Contact"
			},
			{
			"name": "summary",
			"value": "Insert Contacts"
			},
			{
			"name": "externalDocsUrl",
			"value": "https://www.lunaapi.ga/Luna/LunaAPICalls.v1_Contacts_POST.html"
			},
			{
			"name": "operationId",
			"value": "PostContacts"
			},
			{
			"name": "tags",
			"value": "POST,Contacts"
			}
			],
			"BodyParameters": {
			"": {
			"type": "string",
			"required": true,
			"description": "JSON Object with key value pairs, where the key is the fieldname of the corresponding value"
			}
			}
			}
			},
			"HeaderParameters": {
			"Authorization": {
			"type": "string",
			"required": true,
			"description": "Authorization received to access the API"
			},
			"Content-Type": {
			"type": "string",
			"required": false,
			"description": "Content-Type for the POST instruction (application/json; charset=utf-80"
			}
			},
			"BodyParameters": {
			
			}
			}
			
		#tag EndNote
		v1_Contacts_POST As String = "{""PathSpecific"":{""\/Contacts"":{""apiinfoq"":[{""name"":""description"",""value"":""Insert a Contact""},{""name"":""summary"",""value"":""Insert Contacts""},{""name"":""externalDocsUrl"",""value"":""https:\/\/www.lunaapi.ga\/Luna\/LunaAPICalls.v1_Contacts_POST.html""},{""name"":""operationId"",""value"":""PostContacts""},{""name"":""tags"",""value"":""POST,Contacts""}],""BodyParameters"":{"""":{""type"":""string"",""required"":true,""description"":""JSON Object with key value pairs, where the key is the fieldname of the corresponding value""}}}},""HeaderParameters"":{""Authorization"":{""type"":""string"",""required"":true,""description"":""Authorization received to access the API""},""Content-Type"":{""type"":""string"",""required"":false,""description"":""Content-Type for the POST instruction (application\/json; charset=utf-80""}},""BodyParameters"":{}}"
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			{
			"PathSpecific": {
			"/Contacts/{emailaddress}": {
			"apiinfoq": [
			{
			"name": "description",
			"value": "Update a specific Contact based on emailaddress"
			},
			{
			"name": "summary",
			"value": "Update Contacts"
			},
			{
			"name": "externalDocsUrl",
			"value": "https://www.lunaapi.ga/Luna/LunaAPICalls.v1_Contacts_PUT.html"
			},
			{
			"name": "operationId",
			"value": "PutContacts"
			},
			{
			"name": "tags",
			"value": "PUT,Contacts"
			}
			],
			"PathParameters": {
			"emailaddress": {
			"description": "The emailaddress of the Contact you want to update.",
			"type": "string",
			"required": true
			}
			},
			"BodyParameters": {
			"": {
			"type": "string",
			"required": true,
			"description": "JSON Object with key value pairs, where the key is the fieldname of the corresponding value"
			}
			}
			}
			},
			"HeaderParameters": {
			"Authorization": {
			"type": "string",
			"required": true,
			"description": "Authorization received to access the API"
			},
			"Content-Type": {
			"type": "string",
			"required": false,
			"description": "Content-Type for the POST, PUT or PATCH instruction (application/json; charset=utf-8)"
			}
			},
			"BodyParameters": {
			
			}
			}
			
		#tag EndNote
		v1_Contacts_PUT As String = "{""PathSpecific"":{""\/Contacts\/{emailaddress}"":{""apiinfoq"":[{""name"":""description"",""value"":""Update a specific Contact based on emailaddress""},{""name"":""summary"",""value"":""Update Contacts""},{""name"":""externalDocsUrl"",""value"":""https:\/\/www.lunaapi.ga\/Luna\/LunaAPICalls.v1_Contacts_PUT.html""},{""name"":""operationId"",""value"":""PutContacts""},{""name"":""tags"",""value"":""PUT,Contacts""}],""PathParameters"":{""emailaddress"":{""description"":""The emailaddress of the Contact you want to update."",""type"":""string"",""required"":true}},""BodyParameters"":{"""":{""type"":""string"",""required"":true,""description"":""JSON Object with key value pairs, where the key is the fieldname of the corresponding value""}}}},""HeaderParameters"":{""Authorization"":{""type"":""string"",""required"":true,""description"":""Authorization received to access the API""},""Content-Type"":{""type"":""string"",""required"":false,""description"":""Content-Type for the POST, PUT or PATCH instruction (application\/json; charset=utf-8)""}},""BodyParameters"":{}}"
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			{
			"PathSpecific": {
			"/Reset": {
			"apiinfoq": [
			{
			"name": "description",
			"value": "Reset the database for unit tests"
			},
			{
			"name": "summary",
			"value": "Reset database"
			},
			{
			"name": "externalDocsUrl",
			"value": "https://www.lunaapi.ga/Luna/LunaAPICalls.v1_Reset_GET.html"
			},
			{
			"name": "operationId",
			"value": "GetReset"
			},
			{
			"name": "tags",
			"value": "Reset"
			}
			]
			}
			},
			"HeaderParameters": {
			"Authorization": {
			"type": "string",
			"required": true,
			"description": "Authorization received to access the API"
			},
			"ResetAuthorization": {
			"type": "string",
			"required": true,
			"description": "ResetAuthorization needed to reset the database"
			}
			}
			}
			
		#tag EndNote
		v1_Reset_GET As String = "{""PathSpecific"":{""\/Reset"":{""apiinfoq"":[{""name"":""description"",""value"":""Reset the database for unit tests""},{""name"":""summary"",""value"":""Reset database""},{""name"":""externalDocsUrl"",""value"":""https:\/\/www.lunaapi.ga\/Luna\/LunaAPICalls.v1_Reset_GET.html""},{""name"":""operationId"",""value"":""GetReset""},{""name"":""tags"",""value"":""Reset""}]}},""HeaderParameters"":{""Authorization"":{""type"":""string"",""required"":true,""description"":""Authorization received to access the API""},""ResetAuthorization"":{""type"":""string"",""required"":true,""description"":""ResetAuthorization needed to reset the database""}}}"
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
			Name="v1_Contacts_GET"
			Group="Behavior"
			InitialValue="{""""PathSpecific"""":{""""\\/Contacts"""":{""""apiinfoq"""":[{""""name"""":""""description"""",""""value"""":""""Get a list of Contacts""""},{""""name"""":""""summary"""",""""value"""":""""List Contacts""""},{""""name"""":""""externalDocsUrl"""",""""value"""":""""https:\\/\\/support.bouwsoft.be\\/manual\\/api\\/Content\\/UseItGroup\\/API\\/ApiAlg.htm""""},{""""name"""":""""operationId"""",""""value"""":""""GetContacts""""},{""""name"""":""""tags"""",""""value"""":""""LIST,GET,Contacts""""}]},""""\\/Contacts\\/{emailaddress}"""":{""""apiinfoq"""":[{""""name"""":""""description"""",""""value"""":""""Get one specific Contact based on emailaddress""""},{""""name"""":""""summary"""",""""value"""":""""Get Contact""""},{""""name"""":""""externalDocsUrl"""",""""value"""":""""https:\\/\\/support.bouwsoft.be\\/manual\\/api\\/Content\\/UseItGroup\\/API\\/ApiAlg.htm""""},{""""name"""":""""operationId"""",""""value"""":""""GetContact""""},{""""name"""":""""tags"""",""""value"""":""""GET,Contacts""""}],""""PathParameters"""":{""""emailaddress"""":{""""description"""":""""The emailaddress of the Contact you want to get."""",""""type"""":""""string"""",""""required"""":true}}}},""""HeaderParameters"""":{""""Authorization"""":{""""type"""":""""string"""",""""required"""":true,""""description"""":""""Authorization received to access the API""""}}}"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="v1_Contacts_DELETE"
			Group="Behavior"
			InitialValue="{""""PathSpecific"""":{""""\\/Contacts\\/{emailaddress}"""":{""""apiinfoq"""":[{""""name"""":""""description"""",""""value"""":""""Delete a Contact""""},{""""name"""":""""summary"""",""""value"""":""""Delete Contacts""""},{""""name"""":""""externalDocsUrl"""",""""value"""":""""https:\\/\\/support.bouwsoft.be\\/manual\\/api\\/Content\\/UseItGroup\\/API\\/ApiAlg.htm""""},{""""name"""":""""operationId"""",""""value"""":""""DeleteContacts""""},{""""name"""":""""tags"""",""""value"""":""""DELETE,Contacts""""}],""""PathParameters"""":{""""emailaddress"""":{""""description"""":""""The emailaddress of the Contact you want to delete."""",""""type"""":""""integer"""",""""required"""":true}}}},""""HeaderParameters"""":{""""Authorization"""":{""""type"""":""""string"""",""""required"""":true,""""description"""":""""Authorization received to access the API""""}}}"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="v1_Contacts_POST"
			Group="Behavior"
			InitialValue="{""""PathSpecific"""":{""""\\/Contacts"""":{""""apiinfoq"""":[{""""name"""":""""description"""",""""value"""":""""Insert a Contact""""},{""""name"""":""""summary"""",""""value"""":""""Insert Contacts""""},{""""name"""":""""externalDocsUrl"""",""""value"""":""""https:\\/\\/support.bouwsoft.be\\/manual\\/api\\/Content\\/UseItGroup\\/API\\/ApiAlg.htm""""},{""""name"""":""""operationId"""",""""value"""":""""PostContacts""""},{""""name"""":""""tags"""",""""value"""":""""POST,Contacts""""}],""""BodyParameters"""":{"""""""":{""""type"""":""""string"""",""""required"""":true,""""description"""":""""JSON Object with key values pair, where the key is the fieldname of the corresponding value""""}}}},""""HeaderParameters"""":{""""Authorization"""":{""""type"""":""""string"""",""""required"""":true,""""description"""":""""Authorization received to access the API""""},""""Content-Type"""":{""""type"""":""""string"""",""""required"""":true,""""description"""":""""Content-Type for the POST instruction (application\\/json; charset=utf-80""""}},""""BodyParameters"""":{}}"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="v1_Contacts_PUT"
			Group="Behavior"
			InitialValue="{""""PathSpecific"""":{""""\\/Contacts\\/{emailaddress}"""":{""""apiinfoq"""":[{""""name"""":""""description"""",""""value"""":""""Update a specific Contact based on emailaddress""""},{""""name"""":""""summary"""",""""value"""":""""Update Contacts""""},{""""name"""":""""externalDocsUrl"""",""""value"""":""""https:\\/\\/support.bouwsoft.be\\/manual\\/api\\/Content\\/UseItGroup\\/API\\/ApiAlg.htm""""},{""""name"""":""""operationId"""",""""value"""":""""PutContacts""""},{""""name"""":""""tags"""",""""value"""":""""PUT,Contacts""""}],""""PathParameters"""":{""""emailaddress"""":{""""description"""":""""The emailaddress of the Contact you want to update."""",""""type"""":""""string"""",""""required"""":true}},""""BodyParameters"""":{"""""""":{""""type"""":""""string"""",""""required"""":true,""""description"""":""""JSON Object with key value pairs, where the key is the fieldname of the corresponding value""""}}}},""""HeaderParameters"""":{""""Authorization"""":{""""type"""":""""string"""",""""required"""":true,""""description"""":""""Authorization received to access the API""""},""""Content-Type"""":{""""type"""":""""string"""",""""required"""":false,""""description"""":""""Content-Type for the POST, PUT or PATCH instruction (application\\/json; charset=utf-8)""""}},""""BodyParameters"""":{}}"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="v1_Reset_GET"
			Group="Behavior"
			InitialValue="{""""PathSpecific"""":{""""\\/Reset"""":{""""apiinfoq"""":[{""""name"""":""""description"""",""""value"""":""""Reset the database for unit tests""""},{""""name"""":""""summary"""",""""value"""":""""Reset database""""},{""""name"""":""""externalDocsUrl"""",""""value"""":""""https:\\/\\/support.bouwsoft.be\\/manual\\/api\\/Content\\/UseItGroup\\/API\\/ApiAlg.htm""""},{""""name"""":""""operationId"""",""""value"""":""""GetReset""""},{""""name"""":""""tags"""",""""value"""":""""Reset""""}]}},""""HeaderParameters"""":{""""Authorization"""":{""""type"""":""""string"""",""""required"""":true,""""description"""":""""Authorization received to access the API""""},""""ResetAuthorization"""":{""""type"""":""""string"""",""""required"""":true,""""description"""":""""ResetAuthorization needed to reset the database""""}}}"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass

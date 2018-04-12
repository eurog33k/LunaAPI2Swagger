#tag Module
Protected Module errorCodes
	#tag Method, Flags = &h0
		Function errorMessage(code As String) As string
		  Dim strReturn As String
		  Dim jErrorCodes As New JSONItem_MTC(command_errorCodes)
		  Dim jErrorCode As JSONItem_MTC
		  if jErrorCodes.HasName(code) Then
		    jErrorCode=jErrorCodes.Value(code)
		    strReturn=jErrorCode.ToString
		  end if
		  Return strReturn
		  
		End Function
	#tag EndMethod


	#tag Note, Name = command.js
		module.exports = {
		errorMessage: errorMessage
		};
		
		var errorCodes = {
		'01': {
		title: 'Input missing',
		message: 'API Endpoint is missing to make a call',
		details: 'Make sure you specify endpoint using -e option. For Example ' +
		'swaggergen -e http://example.com/helloWorld'
		},
		'02': {
		title: 'Invalid hostname',
		message: 'API Endpoint is invalid to make a call',
		details: 'Make sure you specify http endpoint using -e option. For Example ' +
		'swaggergen -e http://example.com/helloWorld'
		},
		'03': {
		title: 'Invalid hostname',
		message: 'API Endpoint is invalid only http, https, ws, wss supported',
		details: 'Make sure you specify http endpoint using -e option. For Example ' +
		'swaggergen -e http://example.com/helloWorld'
		},
		'04': {
		title: 'Invalid Method Name',
		message: 'Method name is invalid only HEAD, GET, POST, PUT, DELETE supported',
		details: 'Make sure you specify http method using -X option. For Example ' +
		'swaggergen -e http://example.com/helloWorld -X POST'
		},
		'05': {
		title: 'Swagger Output file missing',
		message: 'Swagger Output file missing.',
		details: 'Make sure you specify output file using -o option. For Example ' +
		'swaggergen -e http://example.com/helloWorld -X POST -o /Users/Anils/Desktop/swagger.json'
		},
		'06': {
		title: "Host Name, doesn't match",
		message: "Please check your API or Create a new swagger file..",
		details: "Existing swagger file you have mentioned doesn't match new API hostname."
		},
		'07': {
		title: "Base Path Name, doesn't match",
		message: "Please check your API or Create a new swagger file..",
		details: "Existing swagger file you have mentioned doesn't match new API base path."
		}
		};
		
		function errorMessage(code) {
		return errorCodes[code];
		}
	#tag EndNote


	#tag Property, Flags = &h0
		#tag Note
			{
			"01": {
			"title": "Input missing",
			"message": "API Endpoint is missing to make a call",
			"details": "Make sure you specify endpoint using -e option. For Example swaggergen -e http://example.com/helloWorld"
			},
			"02": {
			"title": "Invalid hostname",
			"message": "API Endpoint is invalid to make a call",
			"details": "Make sure you specify http endpoint using -e option. For Example swaggergen -e http://example.com/helloWorld"
			},
			"03": {
			"title": "Invalid hostname",
			"message": "API Endpoint is invalid only http, https, ws, wss supported",
			"details": "Make sure you specify http endpoint using -e option. For Example swaggergen -e http://example.com/helloWorld"
			},
			"04": {
			"title": "Invalid Method Name",
			"message": "Method name is invalid only HEAD, GET, POST, PUT, DELETE supported",
			"details": "Make sure you specify http method using -X option. For Example swaggergen -e http://example.com/helloWorld -X POST"
			},
			"05": {
			"title": "Swagger Output file missing",
			"message": "Swagger Output file missing.",
			"details": "Make sure you specify output file using -o option. For Example swaggergen -e http://example.com/helloWorld -X POST -o /Users/Anils/Desktop/swagger.json"
			},
			"06": {
			"title": "Host Name, doesn't match",
			"message": "Please check your API or Create a new swagger file..",
			"details": "Existing swagger file you have mentioned doesn't match new API hostname."
			},
			"07": {
			"title": "Base Path Name, doesn't match",
			"message": "Please check your API or Create a new swagger file..",
			"details": "Existing swagger file you have mentioned doesn't match new API base path."
			}
			}
		#tag EndNote
		command_errorCodes As String = "{ ""01"": { ""title"": ""Input missing"", ""message"": ""API Endpoint is missing to make a call"", ""details"": ""Make sure you specify endpoint using -e option. For Example swaggergen -e http://example.com/helloWorld"" }, ""02"": { ""title"": ""Invalid hostname"", ""message"": ""API Endpoint is invalid to make a call"", ""details"": ""Make sure you specify http endpoint using -e option. For Example swaggergen -e http://example.com/helloWorld"" }, ""03"": { ""title"": ""Invalid hostname"", ""message"": ""API Endpoint is invalid only http, https, ws, wss supported"", ""details"": ""Make sure you specify http endpoint using -e option. For Example swaggergen -e http://example.com/helloWorld"" }, ""04"": { ""title"": ""Invalid Method Name"", ""message"": ""Method name is invalid only HEAD, GET, POST, PUT, DELETE supported"", ""details"": ""Make sure you specify http method using -X option. For Example swaggergen -e http://example.com/helloWorld -X POST"" }, ""05"": { ""title"": ""Swagger Output file missing"", ""message"": ""Swagger Output file missing."", ""details"": ""Make sure you specify output file using -o option. For Example swaggergen -e http://example.com/helloWorld -X POST -o /Users/Anils/Desktop/swagger.json"" }, ""06"": { ""title"": ""Host Name, doesn't match"", ""message"": ""Please check your API or Create a new swagger file.."", ""details"": ""Existing swagger file you have mentioned doesn't match new API hostname."" }, ""07"": { ""title"": ""Base Path Name, doesn't match"", ""message"": ""Please check your API or Create a new swagger file.."", ""details"": ""Existing swagger file you have mentioned doesn't match new API base path."" } }"
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="command_errorCodes"
			Group="Behavior"
			InitialValue="{   '01': {     title: 'Input missing',     message: 'API Endpoint is missing to make a call',     details: 'Make sure you specify endpoint using -e option. For Example ' +     'swaggergen -e http://example.com/helloWorld'   },   '02': {     title: 'Invalid hostname',     message: 'API Endpoint is invalid to make a call',     details: 'Make sure you specify http endpoint using -e option. For Example ' +     'swaggergen -e http://example.com/helloWorld'   },   '03': {     title: 'Invalid hostname',     message: 'API Endpoint is invalid only http, https, ws, wss supported',     details: 'Make sure you specify http endpoint using -e option. For Example ' +     'swaggergen -e http://example.com/helloWorld'   },   '04': {     title: 'Invalid Method Name',     message: 'Method name is invalid only HEAD, GET, POST, PUT, DELETE supported',     details: 'Make sure you specify http method using -X option. For Example ' +     'swaggergen -e http://example.com/helloWorld -X POST'   },   '05': {     title: 'Swagger Output file missing',     message: 'Swagger Output file missing.',     details: 'Make sure you specify output file using -o option. For Example ' +     'swaggergen -e http://example.com/helloWorld -X POST -o /Users/Anils/Desktop/swagger.json'   },   '06': {     title: """"Host Name, doesn't match"""",     message: """"Please check your API or Create a new swagger file.."""",     details: """"Existing swagger file you have mentioned doesn't match new API hostname.""""   },   '07': {     title: """"Base Path Name, doesn't match"""",     message: """"Please check your API or Create a new swagger file.."""",     details: """"Existing swagger file you have mentioned doesn't match new API base path.""""   } }"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
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

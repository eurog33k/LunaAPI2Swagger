#tag Class
Protected Class LunaAPICalls
	#tag Method, Flags = &h0
		Function v1_Contacts_DELETE() As String
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function v1_Contacts_GET() As String
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function v1_Contacts_POST() As String
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function v1_Contacts_PUT() As String
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function v1_Reset_GET() As String
		  
		End Function
	#tag EndMethod


	#tag Note, Name = ]
		## Luna API - Version 1  
		
		[Which server to call][]  
		[Calling the API][]  
		[API Calls][]  
		# Which server to call #  
		
		When making a call to the Luna API, we always call the server the API provider gave us  
		
		For instance:  
		http://www.lunaapi.ga/api/v1/Contacts  
		
		# **Calling the API** #  
		
		# API Calls #
		
		[XJD:SECTION:DETAILS]
		
		The Use IT Group API gets called with the following (possible) Parameters
		
		# HeaderParameters #
		
		| Parameter name | Type    | Description                                                                                                          |  
		|----------------|---------|----------------------------------------------------------------------------------------------------------------------|  
		| Authorization   | String  | Authorization key needed for Luna API access                                                                                 |  
		
		
		# PathParameters #  
		/ApiMethodName/**{emailaddress}**  
		If you want to get the data for one specific item, you call the API with the emailaddress of the item you want to receive  
		For instance:  
		https://www.lunaapi.ga/api/v1/Contacts/ShirleySBruce@einrot.com  
		
		# QueryParameters #  
		If you want to modify the list of data you want to receive, you can use the following parameters
		
		| Parameter name | Type    | Description                                                                                                          |  
		|----------------|---------|----------------------------------------------------------------------------------------------------------------------|  
		| [columns][]    | String  | The names of the fields you want in the result set ( seperated by , )                                                |  
		
		
		HTTP Response Codes
		===================
		| Code                           | Description                                                                                                    |  
		|--------------------------------|----------------------------------------------------------------------------------------------------------------|  
		| [200 OK][]                     | Successful response for GET and PUT (Update/Replace) requests.                                                 |  
		| [201 Created][]                | Successful response for POST (Create) requests.                                                                |  
		| [204 No Content][]             | Successful response for DELETE requests.                                                                       |  
		| [301 MOVED PERMANETLY][]       | Failure response to a request that has been moved.                                                             |  
		| [400 Bad Request][]            | Failure response to a request with a malformed body.                                                           |  
		| [401 Unauthorized][]           | Failure response for missing or invalid authentication credentials.                                            |  
		| [403 Forbidden][]              | Failure response to an unauthorized request. The client does not have permission to perform the action.        |    
		| [403.4 Forbidden][]            | Failure response because SSL is required.                                                                      |    
		| [404 Not Found][]              | Failure response because the requested resource is invalid.                                                    |    
		| [500 Internal Server Error][]  | No Response received from this call                                                                            |  
		
		***
		
		# **Examples of queryparameters** #  
		# columns #  
		The names of the fields you want in the result set (seperated by ,)  
		For instance Contacts    
		With queryparameter  
		* columns = GivenName,Surname    
		
		Result:  
		[  
		&nbsp;&nbsp;{  
		&nbsp;&nbsp;&nbsp;&nbsp;"GivenName": "George",  
		&nbsp;&nbsp;&nbsp;&nbsp;"Surname": "Lopez"  
		&nbsp;&nbsp;},  
		&nbsp;&nbsp;{  
		&nbsp;&nbsp;&nbsp;&nbsp;"GivenName": "Faustino",  
		&nbsp;&nbsp;&nbsp;&nbsp;"Surname": "Aliff"  
		&nbsp;&nbsp;},  
		...  
		
		
		***
		
		#**Response Codes**#
		
		[200 OK][]  
		[201 CREATED][]  
		[204 NO CONTENT][]  
		[301 MOVED PERMANETLY][]  
		[400 BAD REQUEST][]  
		[401 UNAUTHORIZED][]  
		[403 FORBIDDEN][]  
		[403.4 FORBIDDEN][]  
		[404 NOT FOUND][]  
		[500 Internal Server Error][]
		
		# 200 OK #  
		Successful response for GET and POST requests.  
		
		The reponse is the data you just asked for in JSON format   
		
		# 201 CREATED #  
		Successful response for PUT requests.  
		
		The reponse is the data you just inserted in JSON format   
		
		# 204 NO CONTENT #
		Successful response for DELETE requests.
		
		The reponse is empty since the data has just been deleted.  
		Therefore the only answer to a delete request is the status code.  
		
		# 301 MOVED PERMANETLY #  
		**If the resource has been moved, the response status is 301**  
		
		This can happen if the call has been made to http, but http has been permanently redirected to https
		
		# 400 BAD REQUEST #
		**If there is something wrong with the request, the response status and code is 400**  
		
		**Examples of bad requests:**  
		
		## columns ##
		***
		### General ###  
		columns: name  
		{"Code":"400","Message":"Bad Request","Description":"Column not found: name"}  
		
		***
		
		# 401 UNAUTHORIZED #  
		Failure response for missing or invalid authorization.  
		
		**If you forget to send the Authorization, the response status and code is 401**  
		(401 Unauthorized)  
		  
		# 403 FORBIDDEN #  
		Failure response to an unauthorized request. The client does not have permission to perform the action.  
		  
		# 403.4 FORBIDDEN #  
		Failure response because SSL is required.  
		  
		# 404 NOT FOUND #  
		Failure response because the requested resource is invalid.  
		
		**If there is no record that has the requested emailaddress the HTTP response status and code is 404**  
		(404 Not found)  
		
		example:  https://www.lunaapi.ga/api/v1/Contacts/dirk@wherever.com  
		
		{"Code":"404","Message":"SQL SELECT Failure","Description":"No records were found that meet the filter criteria."}
		
		Another possible reason is that you are using http instead of https
		
		**When using http, you get 404 with the following reply (in http)**  
		
		    <!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML 2.0//EN">
		    <html><head>
		    <title>404 Not Found</title>
		    </head><body>
		    <h1>Not Found</h1>
		    <p>The requested URL /api/v1/Machines was not found on this server.</p>
		    <hr>
		    <address>Apache/2.4.18 (Ubuntu) Server at www.lunaapi.ga Port 80</address>
		    </body></html>  
		
		  
		# 500 Internal Server Error #  
		No Response received from this call  
		
		Luna API was not able to answer this call  
		For instance:  
		https://lunaapi.ga/api/v1/Contacts/ShirleySBruce@einrot.com
		with the queryparameter columns that has the value GivenName,Surnames
		
		If you try this, you get the 500 Internal Server Error below   
		{"Code":"500","Message":"SQL SELECT Failure","Description":"Database error code: 1"}  
		
		
	#tag EndNote

	#tag Note, Name = ]M:v1_Contacts_DELETE
		**This API call is used to delete a(n) Contact**  
		
		| HTTP method   | API version  |
		|---------------|--------------|
		| DELETE        | v1           |
		
		*Don't forget to put the Authorization field in the header*  
		
		API Path: /Contacts/{emailaddress}    
		
		You make this API call with the key field "emailaddress" as the path parameter (the emailaddress of the Contact you want to delete)  
		
		Possible answers: 
		=================
		If everything succeeds the HTTP response status is 204  
		(204 No Content)  
		
		If you forgot the key field or they key field is not found, the response status and code is 404  
		(404 Not Found)  
		The response in this case is SQL SELECT Failure  
		
		If you forget to send the Authorization, the response status is 401  
		(401 Unauthorized)  
		
		For an explanation of all possible errors, please consult our section on possible answers to API calls [here](LunaAPICalls.html#responsecodes)  
		
		**Examples:**  
		  
		https://lunaapi.ga/api/v1/Contacts/timdietrich@me.com  
		 
		  
		Success gives statuscode 204 
		
		
	#tag EndNote

	#tag Note, Name = ]M:v1_Contacts_GET
		
		**This API call is used to get fields of a(n) Contact(s)**  
		
		| HTTP method   | API version  |
		|---------------|--------------|
		| GET           | v1           |
		
		*Don't forget to put the Authorization field in the header*  
		
		**API Path: [/Contacts/][]**  
		or  
		**API Path: [/Contacts/{emailaddress}][]**  
		
		You can make this API call:  
		* without the key field "emailaddress" to get a list of Contacts  
		* with the key field "emailaddress" as the path parameter (the specific emailaddress of the Contact you want to get)  
		
		# Fields #  
		**The following fields are available:**  
		
		| Field Name      | Type         |
		|-----------------|--------------|
		| Title           | String       |
		| GivenName       | String       |
		| Surname         | String       |
		| StreetAddress   | String       |
		| City            | String       |
		| State           | String       |
		| ZipCode         | String       |
		| EmailAddress    | String       |
		| TelephoneNumber | String       |
		| Occupation      | String       |
		| Company         | String       |
		| Domain          | String       |
		
		
		
		# /Contacts/ #  
		
		**API Path: /Contacts/**  
		
		If everything succeeds the HTTP response status is 200  
		(200 OK)  
		
		If there is something wrong with the request, the response status and code is 400  
		(400 Bad Request)  
		
		If you forget to send the Authorization, the response status is 401  
		(401 Unauthorized)  
		
		If what you sent can't be processed, the response status is 500  
		(500 Internal Server Error)  
		
		For an explanation of all possible errors, please consult our section on possible answers to API calls [here](LunAPICalls.html#responsecodes)  
		
		**Examples:**  
		  
		**https://lunaapi.ga/api/v1/Contacts**  
		 
		  
		Success gives statuscode 200 
		And the following result 
		  
		[  
		&nbsp;&nbsp;{  
		&nbsp;&nbsp;&nbsp;&nbsp;\"Title\": \"Mr.\",  
		&nbsp;&nbsp;&nbsp;&nbsp;\"GivenName\": \"George\",  
		&nbsp;&nbsp;&nbsp;&nbsp;\"Surname\": \"Lopez\",  
		&nbsp;&nbsp;&nbsp;&nbsp;\"StreetAddress\": \"657 Brannon Avenue\",  
		&nbsp;&nbsp;&nbsp;&nbsp;\"City\": \"Jacksonville\",  
		&nbsp;&nbsp;&nbsp;&nbsp;\"State\": \"FL\",  
		&nbsp;&nbsp;&nbsp;&nbsp;\"ZipCode\": \"32205\",  
		&nbsp;&nbsp;&nbsp;&nbsp;\"EmailAddress\": \"GeorgeELopez@fleckens.hu\",  
		&nbsp;&nbsp;&nbsp;&nbsp;\"TelephoneNumber\": \"904-781-8829\",  
		&nbsp;&nbsp;&nbsp;&nbsp;\"Occupation\": \"Substance abuse and behavioral disorder counselor\",  
		&nbsp;&nbsp;&nbsp;&nbsp;\"Company\": \"Egghead Software\",  
		&nbsp;&nbsp;&nbsp;&nbsp;\"Domain\": \"amphidea.com\"  
		&nbsp;&nbsp;},  
		&nbsp;&nbsp;{  
		&nbsp;&nbsp;&nbsp;&nbsp;\"Title\": \"Mr.\",  
		&nbsp;&nbsp;&nbsp;&nbsp;\"GivenName\": \"Faustino\",  
		&nbsp;&nbsp;&nbsp;&nbsp;\"Surname\": \"Aliff\",  
		&nbsp;&nbsp;&nbsp;&nbsp;\"StreetAddress\": \"1960 Charla Lane\",  
		&nbsp;&nbsp;&nbsp;&nbsp;\"City\": \"Bristol\",  
		&nbsp;&nbsp;&nbsp;&nbsp;\"State\": \"TX\",  
		&nbsp;&nbsp;&nbsp;&nbsp;\"ZipCode\": \"75125\",  
		&nbsp;&nbsp;&nbsp;&nbsp;\"EmailAddress\": \"FaustinoJAliff@teleworm.us\",  
		&nbsp;&nbsp;&nbsp;&nbsp;\"TelephoneNumber\": \"972-666-5250\",  
		&nbsp;&nbsp;&nbsp;&nbsp;\"Occupation\": \"Music arranger\",  
		&nbsp;&nbsp;&nbsp;&nbsp;\"Company\": \"Universo Realtors\",  
		&nbsp;&nbsp;&nbsp;&nbsp;\"Domain\": \"arctoidea.com\"  
		&nbsp;&nbsp;}  
		,  
		...  
		]  
		   
		  
		
		# /Contacts/{emailaddress} #  
		
		**API Path: /Contacts/{emailaddress}**  
		
		If everything succeeds the HTTP response status is 200  
		(200 OK)  
		
		If there is something wrong with the request, the response status and code is 400  
		(400 Bad Request)  
		
		If there is no record that has the requested id the HTTP response status and code is 404  
		(404 Not found)  
		
		If you forget to send the Authorization, the response status is 401  
		(401 Unauthorized)  
		
		If what you sent can't be processed, the response status is 500  
		(500 Internal Server Error)  
		
		For an explanation of all possible errors, please consult our section on possible answers to API calls [here](LunaAPICalls.html#responsecodes)  
		
		**Examples:**  
		  
		**https://lunaapi.ga/api/v1/Contacts/ShirleySBruce@einrot.com**  
		 
		  
		Success gives statuscode 200 
		And the following result 
		  
		[  
		&nbsp;&nbsp;{  
		&nbsp;&nbsp;&nbsp;&nbsp;\"Title\": \"Ms.\",  
		&nbsp;&nbsp;&nbsp;&nbsp;\"GivenName\": \"Shirley\",  
		&nbsp;&nbsp;&nbsp;&nbsp;\"Surname\": \"Bruce\",  
		&nbsp;&nbsp;&nbsp;&nbsp;\"StreetAddress\": \"3588 Frum Street\",  
		&nbsp;&nbsp;&nbsp;&nbsp;\"City\": \"Nashville\",  
		&nbsp;&nbsp;&nbsp;&nbsp;\"State\": \"TN\",  
		&nbsp;&nbsp;&nbsp;&nbsp;\"ZipCode\": \"37203\",  
		&nbsp;&nbsp;&nbsp;&nbsp;\"EmailAddress\": \"ShirleySBruce@einrot.com\",  
		&nbsp;&nbsp;&nbsp;&nbsp;\"TelephoneNumber\": \"615-344-0115\",  
		&nbsp;&nbsp;&nbsp;&nbsp;\"Occupation\": \"Occupational therapist aide\",  
		&nbsp;&nbsp;&nbsp;&nbsp;\"Company\": \"LaBelle's\",  
		&nbsp;&nbsp;&nbsp;&nbsp;\"Domain\": \"amimidea.com\"  
		&nbsp;&nbsp;}  
		]   
		
		  
		**https://lunaapi.ga/api/v1/Contacts/ShirleySBruce@einrot.com/ShirleySBruce@einrot.com**  
		 
		with the following parameters :  
		  
		Query Parameters :  
		ParameterName: columns , ParameterValue: GivenName,Surname
		
		  
		  
		Success gives statuscode 200 
		And the following result 
		  
		[  
		&nbsp;&nbsp;{  
		&nbsp;&nbsp;&nbsp;&nbsp;\"GivenName\": \"Shirley\",  
		&nbsp;&nbsp;&nbsp;&nbsp;\"Surname\": \"Bruce\"  
		&nbsp;&nbsp;}  
		]   
		  
		
		
	#tag EndNote

	#tag Note, Name = ]M:v1_Contacts_POST
		**This API call is used to add a(n) Contact**  
		
		# General Description #
		
		| HTTP method   | API version  |
		|---------------|--------------|
		| POST          | v1           |
		
		*Don't forget to put the Authorization field in the header*  
		
		**API Path: [/Contacts][]**  
		
		# Fields #
		**The following fields are available:**  
		
		| Field Name      | Type         |
		|-----------------|--------------|
		| Title           | String       |
		| GivenName       | String       |
		| Surname         | String       |
		| StreetAddress   | String       |
		| City            | String       |
		| State           | String       |
		| ZipCode         | String       |
		| EmailAddress    | String       |
		| TelephoneNumber | String       |
		| Occupation      | String       |
		| Company         | String       |
		| Domain          | String       |
		
		
		
		# **/Contacts** #  
		
		**API Path: /Contacts/**
		
		If everything succeeds the HTTP response status is 201  
		(201 CREATED)  
		
		If you forget to send the Authorization, the response status and code is 401  
		(401 Unauthorized)  
		
		For an explanation of all possible errors, please consult our section on possible answers to API calls [here](LunaAPICalls.html#responsecodes)  
		
		**Examples:**  
		  
		https://lunaapi.ga/api/v1/Contacts  
		 
		with the following parameters :  
		  
		Body Parameters :  
		{  
		&nbsp;&nbsp;\"Title\": \"Mr.\",  
		&nbsp;&nbsp;\"GivenName\": \"Timothy\",  
		&nbsp;&nbsp;\"Surname\": \"Dietrich\",  
		&nbsp;&nbsp;\"StreetAddress\": \"500 Xojo Way\",  
		&nbsp;&nbsp;\"City\": \"Sedona\",  
		&nbsp;&nbsp;\"State\": \"AZ\",  
		&nbsp;&nbsp;\"ZipCode\": \"86336\",  
		&nbsp;&nbsp;\"EmailAddress\": \"timdietrich@me.com\",  
		&nbsp;&nbsp;\"TelephoneNumber\": \"800-555-4TIM\",  
		&nbsp;&nbsp;\"Occupation\": \"Apple TV App Developer\",  
		&nbsp;&nbsp;\"Company\": \"Dietrich Enterprises, LLC\",  
		&nbsp;&nbsp;\"Domain\": \"timdietrich.me\"  
		}  
		
		  
		  
		Success gives statuscode 201 
		And the following result 
		  
		[  
		&nbsp;&nbsp;{  
		&nbsp;&nbsp;&nbsp;&nbsp;\"Title\": \"Mr.\",  
		&nbsp;&nbsp;&nbsp;&nbsp;\"GivenName\": \"Timothy\",  
		&nbsp;&nbsp;&nbsp;&nbsp;\"Surname\": \"Dietrich\",  
		&nbsp;&nbsp;&nbsp;&nbsp;\"StreetAddress\": \"500 Xojo Way\",  
		&nbsp;&nbsp;&nbsp;&nbsp;\"City\": \"Sedona\",  
		&nbsp;&nbsp;&nbsp;&nbsp;\"State\": \"AZ\",  
		&nbsp;&nbsp;&nbsp;&nbsp;\"ZipCode\": \"86336\",  
		&nbsp;&nbsp;&nbsp;&nbsp;\"EmailAddress\": \"timdietrich@me.com\",  
		&nbsp;&nbsp;&nbsp;&nbsp;\"TelephoneNumber\": \"800-555-4TIM\",  
		&nbsp;&nbsp;&nbsp;&nbsp;\"Occupation\": \"Apple TV App Developer\",  
		&nbsp;&nbsp;&nbsp;&nbsp;\"Company\": \"Dietrich Enterprises, LLC\",  
		&nbsp;&nbsp;&nbsp;&nbsp;\"Domain\": \"timdietrich.me\"  
		&nbsp;&nbsp;}  
		]   
		 
		
		
	#tag EndNote

	#tag Note, Name = ]M:v1_Contacts_PUT
		**This API call is used to update fields of a(n) Contact**  
		
		# General Description #
		
		| HTTP method   | API version  |
		|---------------|--------------|
		| PUT           | v1           |
		
		*Don't forget to put the Authorization field in the header*  
		
		**API Path: [/Contacts/{emailaddress}][]**  
		
		You make this API call with the key field "emailaddress" as the path parameter (the emailaddress of the addresscontact you want to update)  
		
		# Fields #
		**The following fields are available:**  
		
		| Field Name      | Type         |
		|-----------------|--------------|
		| Title           | String       |
		| GivenName       | String       |
		| Surname         | String       |
		| StreetAddress   | String       |
		| City            | String       |
		| State           | String       |
		| ZipCode         | String       |
		| EmailAddress    | String       |
		| TelephoneNumber | String       |
		| Occupation      | String       |
		| Company         | String       |
		| Domain          | String       |
		 
		
		# /Contacts/{emailaddress} #
		
		**API Path: /Contacts/{emailaddress}**  
		  
		If everything succeeds the HTTP response status is 200  
		(200 OK)  
		
		If you forget to send the Authentication, the response status and code is 401  
		(401 Unauthorized)  
		
		If there is no record for the requested pathparameter the HTTP response status en code 404  
		(404 Not found)  
		
		For an explanation of all possible errors, please consult our section on possible answers to API calls [here](LunaAPICalls.html#responsecodes)  
		
		**Examples:**  
		  
		https://lunaapi.ga/api/v1/Contacts/timdietrich@me.com  
		 
		with the following parameters :  
		  
		Body Parameters :  
		{  
		&nbsp;&nbsp;\"Title\": \"Mr.\",  
		&nbsp;&nbsp;\"GivenName\": \"Timothy\",  
		&nbsp;&nbsp;\"Surname\": \"Dietrich\",  
		&nbsp;&nbsp;\"StreetAddress\": \"500 Xojo Way\",  
		&nbsp;&nbsp;\"City\": \"Sedona\",  
		&nbsp;&nbsp;\"State\": \"AZ\",  
		&nbsp;&nbsp;\"ZipCode\": \"86336\",  
		&nbsp;&nbsp;\"EmailAddress\": \"timdietrich@me.com\",  
		&nbsp;&nbsp;\"TelephoneNumber\": \"800-555-4TIM\",  
		&nbsp;&nbsp;\"Occupation\": \"Apple TV App Developer\",  
		&nbsp;&nbsp;\"Company\": \"Dietrich Enterprises, LLC\",  
		&nbsp;&nbsp;\"Domain\": \"timdietrich.me\"  
		}  
		
		  
		  
		Success gives statuscode 200 
		And the following result 
		  
		[  
		&nbsp;&nbsp;{  
		&nbsp;&nbsp;&nbsp;&nbsp;\"Title\": \"Mr.\",  
		&nbsp;&nbsp;&nbsp;&nbsp;\"GivenName\": \"Timothy\",  
		&nbsp;&nbsp;&nbsp;&nbsp;\"Surname\": \"Dietrich\",  
		&nbsp;&nbsp;&nbsp;&nbsp;\"StreetAddress\": \"500 Xojo Way\",  
		&nbsp;&nbsp;&nbsp;&nbsp;\"City\": \"Sedona\",  
		&nbsp;&nbsp;&nbsp;&nbsp;\"State\": \"AZ\",  
		&nbsp;&nbsp;&nbsp;&nbsp;\"ZipCode\": \"86336\",  
		&nbsp;&nbsp;&nbsp;&nbsp;\"EmailAddress\": \"timdietrich@me.com\",  
		&nbsp;&nbsp;&nbsp;&nbsp;\"TelephoneNumber\": \"800-555-4TIM\",  
		&nbsp;&nbsp;&nbsp;&nbsp;\"Occupation\": \"Apple TV App Developer\",  
		&nbsp;&nbsp;&nbsp;&nbsp;\"Company\": \"Dietrich Enterprises, LLC\",  
		&nbsp;&nbsp;&nbsp;&nbsp;\"Domain\": \"timdietrich.me\"  
		&nbsp;&nbsp;}  
		]   
		  
		
		
		
	#tag EndNote

	#tag Note, Name = ]M:v1_Reset_GET
		
		**This API call is used to get fields of a(n) Reset(s)**  
		
		| HTTP method   | API version  |
		|---------------|--------------|
		| GET           | v1           |
		
		*Don't forget to put the Authorization field in the header*  
		
		**API Path: [/Reset/][]**  
		
		You make this API call:  
		* to get the result of Reset  
		
		# Fields #  
		**The following fields are available:**  
		
		| Field Name| Type         |
		|----------|--------------|
		| Count(*) | String       |
		
		
		
		# /Reset/ #  
		
		**API Path: /Reset/**  
		
		If everything succeeds the HTTP response status is 200  
		(200 OK)  
		
		If there is something wrong with the request, the response status and code is 400  
		(400 Bad Request)  
		
		If you forget to send the Authorization, the response status is 401  
		(401 Unauthorized)  
		
		If what you sent can't be processed, the response status is 500  
		(500 Internal Server Error)  
		
		For an explanation of all possible errors, please consult our section on possible answers to API calls [here](LunAPICalls.html#responsecodes)  
		
		**Examples:**  
		  
		https://lunaapi.ga/api/v1/Reset  
		 
		  
		Success gives statuscode 200 
		And the following result 
		  
		[  
		&nbsp;&nbsp;{  
		&nbsp;&nbsp;&nbsp;&nbsp;\"Count(*)\": \"500\"  
		&nbsp;&nbsp;}  
		]   
		  
		
		
	#tag EndNote


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
End Class
#tag EndClass

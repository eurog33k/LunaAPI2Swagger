#tag Module
Protected Module questions
	#tag Method, Flags = &h0
		Function aboutq_Function_basePathsQ(options() As String) As JSONItem_MTC
		  Dim jOptions As New JSONItem_MTC
		  Dim answers As JSONItem_MTC
		  For i As Integer=0 to options.Ubound
		    jOptions.Append options(i)
		  Next
		  
		  Dim jBasepathq As New JSONItem_MTC(aboutq_basepathq)
		  
		  jBasepathq.Value("choices")=jOptions
		  
		  answers=Questions(jBasepathq.ToString)
		  
		  Return answers
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function aboutq_Function_InfoQ() As JSONItem_MTC
		  Dim info As New JSONItem_MTC("{}")
		  Dim answers As JSONItem_MTC
		  
		  answers=Questions(aboutq_infoq)
		  
		  info.Value("description") = answers.Value("description")
		  info.Value("title") = answers.Value("title")
		  info.Value("version") = answers.Value("version")
		  info.Value("termsOfService") = answers.Value("termsOfService")
		  
		  Dim contact As New JSONItem_MTC("{}")
		  
		  contact.Value("name") = answers.Value("contactName")
		  contact.Value("url") = answers.Value("contactUrl")
		  contact.Value("email") = answers.Value("contactEmail")
		  
		  info.Value("contact") = contact
		  
		  //proprietary license, so we don't publish this
		  'Dim license As New JSONItem_MTC("{}")
		  
		  'license.Value("name") = answers.Value("licenseName")
		  'license.Value("url") = answers.Value("licenseUrl")
		  
		  'info.value("license") = license
		  
		  Return info
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function aboutq_Function_protocolsQ(data As String) As JSONItem_MTC
		  Dim myQuestions As String
		  Dim answers As JSONItem_MTC
		  
		  if data="http" then
		    myQuestions=aboutq_httpsq
		  else
		    myQuestions=aboutq_httpq
		  end if
		  
		  answers=questions(myquestions)
		  
		  Return answers
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function apiq_Function_apiInfoQ() As JSONItem_MTC
		  Dim tmpAnswers As JSONItem_MTC
		  Dim answers As New JSONItem_MTC
		  
		  tmpAnswers=Questions(apiq_apiInfoQuestions)
		  
		  Dim names() As String=tmpAnswers.Names
		  for each name as String in names
		    if name<>"tags" and name<>"externalDocsUrl" Then
		      answers.Value(name)=tmpAnswers.Value(name)
		    end if
		  next
		  
		  Dim strTags() As String = Split( tmpanswers.Value("tags") , "," )
		  Dim jTags As New JSONItem_MTC
		  For each strTag As String in strTags
		    jTags.Append strTag
		  Next
		  
		  answers.Value("tags") = jTags
		  
		  answers.Value("externalDocs") = New JSONItem_MTC("{}")
		  
		  answers.Child("externalDocs").Value("description") = "Find out more"
		  answers.Child("externalDocs").Value("url") = tmpAnswers.Value("externalDocsUrl")
		  
		  Return answers
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function apiq_Function_apiInfoQ(jApiInfo As JSONItem_MTC) As JSONItem_MTC
		  Dim tmpAnswers As New JSONItem_MTC
		  Dim answers As New JSONItem_MTC
		  
		  for i As Integer=0 to jApiInfo.Count-1
		    Dim jChild As JSONItem_MTC=jApiInfo.Child(i)
		    tmpAnswers.Value(jChild.Value("name").StringValue)=jChild.Value("value").StringValue
		  next
		  
		  Dim names() As String=tmpAnswers.Names
		  for each name as String in names
		    if name<>"tags" and name<>"externalDocsUrl" Then
		      answers.Value(name)=tmpAnswers.Value(name)
		    end if
		  next
		  
		  Dim strTags() As String = Split( tmpAnswers.Value("tags") , "," )
		  Dim jTags As New JSONItem_MTC
		  For each strTag As String in strTags
		    jTags.Append strTag
		  Next
		  
		  answers.Value("tags") = jTags
		  
		  answers.Value("externalDocs") = New JSONItem_MTC("{}")
		  
		  answers.Child("externalDocs").Value("description") = "Find out more"
		  answers.Child("externalDocs").Value("url") = tmpAnswers.Value("externalDocsUrl")
		  
		  Return answers
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function apiq_Function_bodyJsonQ(schema As String) As JSONItem_MTC
		  //body parameters that describe the body of POST, PUT and PATCH requests (see Describing Request Body)
		  //http://swagger.io/docs/specification/describing-request-body/
		  Dim answers As JSONItem_MTC
		  Dim jschema As JSONItem_MTC
		  answers=Questions(apiq_bodyJsonQuestion)
		  
		  Dim param As New JSONItem_MTC("{}")
		  
		  param.Value("in") = "body"
		  param.Value("name") = answers.Value("name")
		  param.Value("description") = answers.Value("description")
		  param.Value("required") = True
		  if schema="" Then
		    schema="{""type"": ""string""}"
		  end if
		  jschema=new JSONItem_MTC(schema)
		  param.Value("schema") = jschema
		  
		  Return param
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function apiq_Function_BodyParameterQ(paramName As String, jQueryParameters As JSONItem_MTC) As JSONItem_MTC
		  //body parameters, such as formData
		  //if there really are parameters (as in named body items) 
		  //then we treat them the same way as queryparameters
		  Dim param As New JSONItem_MTC("{}")
		  
		  param.Value("in") = "formData"
		  param.Value("name") = paramName
		  param.Value("description") = jQueryParameters.child(paramName).value("description")
		  if jQueryParameters.child(paramName).HasName("type")=False or jQueryParameters.child(paramName).Value("type")="" Then
		    param.Value("type") = "string"
		  else
		    param.Value("type") = jQueryParameters.child(paramName).Value("type")
		  end if
		  param.Value("required") = jQueryParameters.child(paramName).Value("required")
		  
		  //currently no enum, since we usually don't want to limit possible values
		  'if answers.HasName("possibleValues") Then
		  'param.Value("enum") = answers.Value("possibleValues")
		  'end if
		  
		  Return param
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function apiq_Function_BodyParameterQ(paramName As String, paramValue As String) As JSONItem_MTC
		  //body parameters, such as formData
		  //if there really are parameters (as in named body items) 
		  //then we treat them the same way as queryparameters
		  Dim answers As JSONItem_MTC
		  Dim jqueryParamQuestions As New JSONItem_MTC(apiq_queryParameterQuestions)
		  jqueryParamQuestions.Child(3).Value("default")=paramValue
		  answers=Questions(jqueryParamQuestions.ToString)
		  
		  Dim param As New JSONItem_MTC("{}")
		  
		  param.Value("in") = "formData"
		  param.Value("name") = paramName
		  param.Value("description") = answers.value("description")
		  if answers.Value("type")="" Then
		    param.Value("type") = "string"
		  else
		    param.Value("type") = answers.Value("type")
		  end if
		  param.Value("required") = answers.Value("required")
		  
		  if answers.HasName("possibleValues") Then
		    param.Value("enum") = answers.Value("possibleValues")
		  end if
		  
		  Return param
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function apiq_Function_formParameterQ(paramName As String, paramValue As String) As JSONItem_MTC
		  //form parameters – a variety of body parameters used to describe the payload of requests 
		  //with Content-Type of application/x-www-form-urlencoded and multipart/form-data 
		  //(the latter is typically used for file uploads)
		  //http://swagger.io/docs/specification/describing-parameters/#form-parameters
		  Dim answers As JSONItem_MTC
		  Dim jqueryParamQuestions As New JSONItem_MTC(apiq_queryParameterQuestions)
		  jqueryParamQuestions.Child(3).Value("default")=paramValue
		  answers=Questions(jqueryParamQuestions.ToString)
		  
		  Dim param As New JSONItem_MTC("{}")
		  
		  param.Value("in") = "formData"
		  param.Value("name") = paramName
		  param.Value("description") = answers.Value("description")
		  param.Value("type") = answers.Value("type")
		  param.Value("required") = answers.Value("required")
		  if answers.HasName("possibleValues") Then
		    param.Value("enum") = answers.Value("possibleValues")
		  end if
		  
		  Return param
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function apiq_Function_headerParameterQ(headerName As String) As JSONItem_MTC
		  //header parameters, such as X-MyHeader: Value
		  //http://swagger.io/docs/specification/describing-parameters/#header-parameters
		  Dim answers As JSONItem_MTC
		  'Dim jEmptyArray As New JSONItem_MTC("[]")
		  Dim jheaderParamQuestions As New JSONItem_MTC(apiq_headerParameterQuestions)
		  jheaderParamQuestions.Child(0).Value("default")=headerName
		  
		  'Dim jheaderSampleValues As JSONItem_MTC=jEmptyArray
		  
		  answers=Questions(jheaderParamQuestions.ToString)
		  
		  Dim param As New JSONItem_MTC("{}")
		  
		  param.Value("in") = "header"
		  param.Value("name") = headerName
		  param.Value("description") = answers.Value("description")
		  param.Value("required") = True
		  if answers.Value("type")="" Then
		    param.Value("type") = "string"
		  else
		    param.Value("type") = answers.Value("type")
		  end if
		  //cuurently no enum, since we usually don't want to limit possible values
		  'param.Value("enum") = jheaderSampleValues
		  
		  Return param
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function apiq_Function_headerParameterQ(headerName As String, jHeaderDoc As JSONItem_MTC) As JSONItem_MTC
		  //header parameters, such as X-MyHeader: Value
		  //http://swagger.io/docs/specification/describing-parameters/#header-parameters
		  
		  'Dim jEmptyArray As New JSONItem_MTC("[]")
		  'Dim jheaderSampleValues As JSONItem_MTC=jEmptyArray
		  Dim param As New JSONItem_MTC("{}")
		  
		  param.Value("in") = "header"
		  param.Value("name") = headerName
		  param.Value("description") = jHeaderDoc.Value("description")
		  param.Value("required") = jHeaderDoc.Value("required")
		  param.Value("type") = jHeaderDoc.Value("type")
		  
		  //currently no enum, since we usually don't want to limit possible values
		  'param.Value("enum") = jheaderSampleValues
		  
		  Return param
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function apiq_Function_pathParameterQ(paramName As String) As JSONItem_MTC
		  //path parameters, such as /users/{id}
		  //http://swagger.io/docs/specification/describing-parameters/#path-parameters
		  
		  Dim answers As JSONItem_MTC
		  Dim jUrlParamQuestions As New JSONItem_MTC(apiq_pathParameterQuestions)
		  if paramName="Authorize" Then
		    jUrlParamQuestions.Child(2).Value("default")="string"
		  end if
		  
		  if len(paramName)>2  and left(paramName,1)="{" and right(paramName,1)="}" then
		    paramName=Mid(paramName,2,len(paramName)-2)
		  end if
		  
		  answers=Questions(jUrlParamQuestions.ToString)
		  
		  Dim param As New JSONItem_MTC("{}")
		  
		  param.Value("in") = "path"
		  param.Value("name") = paramName
		  param.Value("description") = answers.Value("description")
		  param.Value("required") = True
		  if answers.Value("type")="" Then
		    param.Value("type") = "string"
		  else
		    param.Value("type") = answers.Value("type")
		  end if
		  Return param
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function apiq_Function_pathParameterQ(paramName As String, jPathParameterDoc As JSONItem_MTC) As JSONItem_MTC
		  //path parameters, such as /users/{id}
		  //http://swagger.io/docs/specification/describing-parameters/#path-parameters
		  
		  Dim param As New JSONItem_MTC("{}")
		  
		  if len(paramName)>2  and left(paramName,1)="{" and right(paramName,1)="}" then
		    paramName=Mid(paramName,2,len(paramName)-2)
		  end if
		  
		  param.Value("in") = "path"
		  param.Value("name") = paramName
		  param.Value("description") = jPathParameterDoc.value("description")
		  param.Value("required") = jPathParameterDoc.Value("required")
		  if jPathParameterDoc.HasName("type")=False or jPathParameterDoc.Value("type")="" Then
		    param.Value("type") = "string"
		  else
		    param.Value("type") = jPathParameterDoc.Value("type")
		  end if
		  Return param
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function apiq_Function_queryParameterQ(paramName As String, jQueryParameters As JSONItem_MTC) As JSONItem_MTC
		  //query parameters, such as /users?role=admin
		  //http://swagger.io/docs/specification/describing-parameters/#query-parameters
		  'Dim answers As JSONItem_MTC
		  'Dim jqueryParamQuestions As New JSONItem_MTC(apiq_queryParameterQuestions)
		  'jqueryParamQuestions.Child(3).Value("default")=paramValue
		  'answers=Questions(jqueryParamQuestions.ToString)
		  
		  Dim param As New JSONItem_MTC("{}")
		  
		  param.Value("in") = "query"
		  param.Value("name") = paramName
		  param.Value("description") = jQueryParameters.child(paramName).value("description")
		  if jQueryParameters.child(paramName).HasName("type")=False or jQueryParameters.child(paramName).Value("type")="" Then
		    param.Value("type") = "string"
		  else
		    param.Value("type") = jQueryParameters.child(paramName).Value("type")
		  end if
		  param.Value("required") = jQueryParameters.child(paramName).Value("required")
		  
		  //currently no enum, since we usually don't want to limit possible values
		  'if answers.HasName("possibleValues") Then
		  'param.Value("enum") = answers.Value("possibleValues")
		  'end if
		  
		  Return param
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function apiq_Function_queryParameterQ(paramName As String, paramValue As String) As JSONItem_MTC
		  //query parameters, such as /users?role=admin
		  //http://swagger.io/docs/specification/describing-parameters/#query-parameters
		  Dim answers As JSONItem_MTC
		  Dim jqueryParamQuestions As New JSONItem_MTC(apiq_queryParameterQuestions)
		  jqueryParamQuestions.Child(3).Value("default")=paramValue
		  answers=Questions(jqueryParamQuestions.ToString)
		  
		  Dim param As New JSONItem_MTC("{}")
		  
		  param.Value("in") = "query"
		  param.Value("name") = paramName
		  param.Value("description") = answers.value("description")
		  if answers.Value("type")="" Then
		    param.Value("type") = "string"
		  else
		    param.Value("type") = answers.Value("type")
		  end if
		  param.Value("required") = answers.Value("required")
		  
		  if answers.HasName("possibleValues") Then
		    param.Value("enum") = answers.Value("possibleValues")
		  end if
		  
		  Return param
		End Function
	#tag EndMethod


	#tag Note, Name = aboutq.js
		
		var inquirer = require("inquirer");
		
		var infoq = [
		{ name: 'title',     message: 'Title of Swagger Spec ?', default: 'API Program Title.'},
		{ name: 'description',     message: 'Description of Swagger Spec ?', default: 'API Program description'},
		{ name: 'termsOfService', message: 'Terms of Service URL ?', default: 'http://example.com/about/terms'},
		{ name: 'version', message: 'Version of your API Program ?', default: '0.0.1'},
		{ name: 'contactName',     message: 'Contact Name?', default: 'API Docs'},
		{ name: 'contactUrl',     message: 'Contact URL ?', default: 'http://example.com/contact'},
		{ name: 'contactEmail', message: 'Contact Email ?', default: 'apidocs@example.com'},
		{ name: 'licenseName',     message: 'License Name ?', default: 'Apache 2.0'},
		{ name: 'licenseUrl',     message: 'License URL ?', default: 'http://example.com'}
		];
		
		var httpsq = [
		{name: 'https', message: 'Does your API support https ?', type: 'confirm'}
		];
		
		var httpq = [
		{name: 'http', message: 'Does your API support http ?', type: 'confirm'}
		];
		
		var basepathq = [
		{
		type: "list",
		name: "basePath",
		message: "Pick Base Path from your API ?"
		}
		];
		
		module.exports.infoQ = function(data, callback) {
		inquirer.prompt(infoq, function( answers ) {
		var info = {};
		info.description = answers.description;
		info.title = answers.title;
		info.version = answers.version;
		info.termsOfService = answers.termsOfService;
		info.contact = {};
		info.contact.name = answers.contactName;
		info.contact.url = answers.contactUrl;
		info.contact.email = answers.contactEmail;
		info.license = {};
		info.license.name = answers.licenseName;
		info.license.url = answers.licenseUrl;
		callback(info);
		});
		}
		
		
		
		module.exports.protocolsQ = function(data, callback) {
		if (data == 'http') {
		var questions = httpsq;
		} else {
		var questions = httpq;
		}
		inquirer.prompt(questions, function( answers ) {
		callback(answers);
		});
		}
		
		module.exports.basePathsQ = function(options, callback) {
		basepathq[0].choices = options;
		inquirer.prompt(basepathq, function( answers ) {
		callback(answers);
		});
		}
	#tag EndNote

	#tag Note, Name = apiq.js
		var inquirer = require("inquirer");
		
		var queryParamQuestions = [
		{ name: 'description',     message: 'Description of Query Param ?', default: 'Query Param description goes here..'},
		{ name: 'required', message: 'Is Above Query param required ?', type: 'confirm'},
		{ name: 'type', message: 'Type of query param ?', type: 'list', choices: [ "string", "number", "boolean" ]},
		{ name: 'possibleValues', message: 'Comma Separated possible values?'}
		];
		
		var urlParamQuestions = [
		{ name: 'name',     message: 'Name of URL Param ?', default: ''},
		{ name: 'description',     message: 'Description of URL Param ?', default: ''},
		{ name: 'type', message: 'Type of query param ?', type: 'list', choices: [ "string", "integer", "boolean" ]}
		];
		
		var bodyJsonQuestion = [
		{ name: 'name',     message: 'Name of URL Param ?', default: 'body'},
		{ name: 'description',     message: 'Description of URL Param ?', default: 'Request Payload Body'},
		];
		
		var headerParamQuestions = [
		{ name: 'name',     message: 'Name of URL Param ?'},
		{ name: 'description',     message: 'Description of URL Param ?', default: 'Header Param Description'},
		{ name: 'type', message: 'Type of query param ?', type: 'list', choices: [ "string", "integer", "boolean" ]}
		];
		
		var apiInfoQuestions = [
		{ name: 'description',     message: 'A verbose explanation of the operation behavior.  ?', default: 'API Method Description'},
		{ name: 'summary',     message: 'A short summary of what the operation does. ?', default: 'Short Summary of API Method'},
		{ name: 'externalDocsUrl',     message: 'Additional external documentation for this operation. ?', default: 'http://docs.example.com/management/apis/get/entities'},
		{ name: 'operationId',     message: 'Unique string used to identify the operation. ?', default: 'uniqueId'},
		{ name: 'tags',     message: 'A list of tags for API documentation control.  ?', default: 'api2swagger'},
		];
		
		module.exports.queryParamQ = function(paramName, paramValue, callback) {
		queryParamQuestions[3].default = paramValue;
		inquirer.prompt(queryParamQuestions, function( answers ) {
		var param = {};
		param.in = 'query';
		param.name = paramName;
		param.description = answers.description;
		param.type = answers.type;
		param.required = answers.required;
		param.enum = answers.possibleValues.split(',');
		callback(param);
		});
		}
		
		
		module.exports.formParamQ = function(paramName, paramValue, callback) {
		queryParamQuestions[3].default = paramValue;
		inquirer.prompt(queryParamQuestions, function( answers ) {
		var param = {};
		param.in = 'form';
		param.name = paramName;
		param.description = answers.description;
		param.type = answers.type;
		param.required = answers.required;
		param.enum = answers.possibleValues.split(',');
		callback(param);
		});
		}
		
		module.exports.urlParamQ = function(paramName, callback) {
		inquirer.prompt(urlParamQuestions, function( answers ) {
		var param = {};
		param.in = 'path';
		param.name = answers.name;
		param.description = answers.description;
		param.required = true;
		param.type = answers.type;
		callback(param);
		});
		}
		
		module.exports.headerParamQ = function(headerName, headerValue, callback) {
		headerParamQuestions[0].default = headerName;
		var headerSampleValues = new Array();
		headerSampleValues.push(headerValue);
		inquirer.prompt(headerParamQuestions, function( answers ) {
		var param = {};
		param.in = 'header';
		param.name = headerName;
		param.description = answers.description;
		param.required = true;
		param.type = answers.type;
		param.enum = headerSampleValues;
		callback(param);
		});
		}
		
		module.exports.bodyJsonQ = function(schema, callback) {
		inquirer.prompt(bodyJsonQuestion, function( answers ) {
		var param = {};
		param.in = 'body';
		param.name = answers.name;
		param.description = answers.description;
		param.required = true;
		param.schema = schema;
		callback(param);
		});
		}
		
		module.exports.apiInfoQ = function(data, callback) {
		inquirer.prompt(apiInfoQuestions, function( answers ) {
		var apiInfo = {};
		answers.tags = answers.tags.split(',');
		answers.externalDocs = {};
		answers.externalDocs.description = "Find out more";
		answers.externalDocs.url = answers.externalDocsUrl;
		callback(answers);
		});
		}
	#tag EndNote


	#tag Property, Flags = &h0
		#tag Note
			{     "type": "list",     "name": "basePath",     "message": "Pick Base Path from your API ?", "default": "/api/v1"   }
		#tag EndNote
		aboutq_basepathq As String = "{     ""type"": ""list"",     ""name"": ""basePath"",     ""message"": ""Pick Base Path from your API ?"", ""default"": ""/api/v1""   }"
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			[   {"name": "http", "message": "Does your API support http ?", "type": "confirm", "default": "n"} ]
		#tag EndNote
		aboutq_httpq As String = "[   {""name"": ""http"", ""message"": ""Does your API support http ?"", ""type"": ""confirm"", ""default"": ""n""} ]"
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			[   {"name": "https", "message": "Does your API support https ?", "type": "confirm", "default": "n"} ]
		#tag EndNote
		aboutq_httpsq As String = "[   {""name"": ""https"", ""message"": ""Does your API support https ?"", ""type"": ""confirm"", ""default"": ""n""} ]"
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			[{
			"name": "title",
			"message": "Title of Swagger Spec ?",
			"default": "LunaAPI"
			},
			{
			"name": "description",
			"message": "Description of Swagger Spec ?",
			"default": "Luna API"
			},
			{
			"name": "termsOfService",
			"message": "Terms of Service URL ?",
			"default": "https://github.com/timdietrich/luna"
			},
			{
			"name": "version",
			"message": "Version of your API Program ?",
			"default": "1"
			},
			{
			"name": "contactName",
			"message": "Contact Name?",
			"default": "Dirk"
			},
			{
			"name": "contactUrl",
			"message": "Contact URL ?",
			"default": "https://github.com/eurog33k/luna"
			},
			{
			"name": "contactEmail",
			"message": "Contact Email ?",
			"default": "api@mydomain.com"
			},
			{
			"name": "licenseName",
			"message": "License Name ?",
			"default": "The MIT License (MIT)"
			},
			{
			"name": "licenseUrl",
			"message": "License URL ?",
			"default": "https://github.com/timdietrich/luna/blob/master/LICENSE.md"
			}
			]
		#tag EndNote
		aboutq_infoq As String = "[{ ""name"": ""title"", ""message"": ""Title of Swagger Spec ?"", ""default"": ""LunaAPI"" }, { ""name"": ""description"", ""message"": ""Description of Swagger Spec ?"", ""default"": ""Luna API"" }, { ""name"": ""termsOfService"", ""message"": ""Terms of Service URL ?"", ""default"": ""https://github.com/timdietrich/luna"" }, { ""name"": ""version"", ""message"": ""Version of your API Program ?"", ""default"": ""1"" }, { ""name"": ""contactName"", ""message"": ""Contact Name?"", ""default"": ""Dirk"" }, { ""name"": ""contactUrl"", ""message"": ""Contact URL ?"", ""default"": ""https://github.com/eurog33k/luna"" }, { ""name"": ""contactEmail"", ""message"": ""Contact Email ?"", ""default"": ""api@mydomain.com"" }, { ""name"": ""licenseName"", ""message"": ""License Name ?"", ""default"": ""The MIT License (MIT)"" }, { ""name"": ""licenseUrl"", ""message"": ""License URL ?"", ""default"": ""https://github.com/timdietrich/luna/blob/master/LICENSE.md"" } ]"
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			[{
			"name": "description",
			"message": "A verbose explanation of the operation behavior.  ?",
			"default": "API Method Description"
			}, {
			"name": "summary",
			"message": "A short summary of what the operation does. ?",
			"default": "Short Summary of API Method"
			}, {
			"name": "externalDocsUrl",
			"message": "Additional external documentation for this operation. ?",
			"default": "http://docs.example.com/api/v1/ExternaldocUndefined"
			}, {
			"name": "operationId",
			"message": "Unique string used to identify the operation. ?",
			"default": "No UniqueId"
			}, {
			"name": "tags",
			"message": "A list of tags for API documentation control.  ?",
			"default": "Undefined Tag"
			}]
		#tag EndNote
		apiq_apiInfoQuestions As String = "[{ ""name"": ""description"", ""message"": ""A verbose explanation of the operation behavior.  ?"", ""default"": ""API Method Description"" }, { ""name"": ""summary"", ""message"": ""A short summary of what the operation does. ?"", ""default"": ""Short Summary of API Method"" }, { ""name"": ""externalDocsUrl"", ""message"": ""Additional external documentation for this operation. ?"", ""default"": ""http://docs.example.com/management/apis/get/entities"" }, { ""name"": ""operationId"", ""message"": ""Unique string used to identify the operation. ?"", ""default"": ""uniqueId"" }, { ""name"": ""tags"", ""message"": ""A list of tags for API documentation control.  ?"", ""default"": ""RefreshToken"" }]"
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			[{
			"name": "name",
			"message": "Name of body Param ?",
			"default": "body"
			},
			{
			"name": "description",
			"message": "Description of body Param ?",
			"default": "Request Payload Body"
			}
			]
		#tag EndNote
		apiq_bodyJsonQuestion As String = "[{ ""name"": ""name"", ""message"": ""Name of body Param ?"", ""default"": ""body"" }, { ""name"": ""description"", ""message"": ""Description of body Param ?"", ""default"": ""Request Payload Body"" } ]"
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			[{
			"name": "name",
			"message": "Name of Header Param ?"
			},
			{
			"name": "description",
			"message": "Description of Header Param ?",
			"default": "Header Param Description"
			},
			{
			"name": "required",
			"message": "Is Above Query param required ?",
			"type": "confirm"},
			{
			"name": "type",
			"message": "Type of query param ?",
			"type": "list",
			"choices": ["string", "integer", "boolean"]
			}
			]
		#tag EndNote
		apiq_headerParameterQuestions As String = "[{ ""name"": ""name"", ""message"": ""Name of Header Param ?"" }, { ""name"": ""description"", ""message"": ""Description of Header Param ?"", ""default"": ""Header Param Description"" }, { ""name"": ""type"", ""message"": ""Type of query param ?"", ""type"": ""list"", ""choices"": [""string"", ""integer"", ""boolean""] } ]"
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			[{
			"name": "name",
			"message": "Name of URL Param ?",
			"default": ""
			},
			{
			"name": "description",
			"message": "Description of URL Param ?",
			"default": ""
			},
			{
			"name": "type",
			"message": "Type of query param ?",
			"type": "list",
			"choices": ["string", "integer", "boolean"]
			}
			]
		#tag EndNote
		apiq_pathParameterQuestions As String = "[{ 		""name"": ""name"", 		""message"": ""Name of URL Param ?"", 		""default"": """" 	}, 	{ 		""name"": ""description"", 		""message"": ""Description of URL Param ?"", 		""default"": """" 	}, 	{ 		""name"": ""type"", 		""message"": ""Type of query param ?"", 		""type"": ""list"", 		""choices"": [""string"", ""integer"", ""boolean""] 	} ]"
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			[
			{ "name": "description", "message": "Description of Query Param ?", "default": "Query Param description goes here.."},
			{ "name": "required", "message": "Is Above Query param required ?", "type": "confirm"},
			{ "name": "type", "message": "Type of query param ?", "type": "list", "choices": [ "string", "number", "boolean" ]},
			{ "name": "possibleValues", "message": "Comma Separated possible values?"}
			]
		#tag EndNote
		apiq_queryParameterQuestions As String = "[ { ""name"": ""description"", ""message"": ""Description of Query Param ?"", ""default"": ""Query Param description goes here..""}, { ""name"": ""required"", ""message"": ""Is Above Query param required ?"", ""type"": ""confirm""}, { ""name"": ""type"", ""message"": ""Type of query param ?"", ""type"": ""list"", ""choices"": [ ""string"", ""number"", ""boolean"" ]}, { ""name"": ""possibleValues"", ""message"": ""Comma Separated possible values?""} ]"
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="aboutq_basepathq"
			Group="Behavior"
			InitialValue="[   {     type: """"list"""",     name: """"basePath"""",     message: """"Pick Base Path from your API ?""""   } ]"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="aboutq_httpq"
			Group="Behavior"
			InitialValue="[   {""""name"""": """"http"""", """"message"""": """"Does your API supports http ?"""", """"type"""": """"confirm""""} ]"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="aboutq_httpsq"
			Group="Behavior"
			InitialValue="[   {""""name"""": """"https"""", """"message"""": """"Does your API supports https ?"""", """"type"""": """"confirm""""} ]"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="aboutq_infoq"
			Group="Behavior"
			InitialValue="[{ 		""""name"""": """"title"""", 		""""message"""": """"Title of Swagger Spec ?"""", 		""""default"""": """"API Program Title."""" 	}, 	{ 		""""name"""": """"description"""", 		""""message"""": """"Description of Swagger Spec ?"""", 		""""default"""": """"API Program description"""" 	}, 	{ 		""""name"""": """"termsOfService"""", 		""""message"""": """"Terms of Service URL ?"""", 		""""default"""": """"http://example.com/about/terms"""" 	}, 	{ 		""""name"""": """"version"""", 		""""message"""": """"Version of your API Program ?"""", 		""""default"""": """"0.0.1"""" 	}, 	{ 		""""name"""": """"contactName"""", 		""""message"""": """"Contact Name?"""", 		""""default"""": """"API Docs"""" 	}, 	{ 		""""name"""": """"contactUrl"""", 		""""message"""": """"Contact URL ?"""", 		""""default"""": """"http://example.com/contact"""" 	}, 	{ 		""""name"""": """"contactEmail"""", 		""""message"""": """"Contact Email ?"""", 		""""default"""": """"apidocs@example.com"""" 	}, 	{ 		""""name"""": """"licenseName"""", 		""""message"""": """"License Name ?"""", 		""""default"""": """"Apache 2.0"""" 	}, 	{ 		""""name"""": """"licenseUrl"""", 		""""message"""": """"License URL ?"""", 		""""default"""": """"http://example.com"""" 	} ]"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="apiq_apiInfoQuestions"
			Group="Behavior"
			InitialValue="[   { name: 'description',     message: 'A verbose explanation of the operation behavior.  ?', default: 'API Method Description'},   { name: 'summary',     message: 'A short summary of what the operation does. ?', default: 'Short Summary of API Method'},   { name: 'externalDocsUrl',     message: 'Additional external documentation for this operation. ?', default: 'http://docs.example.com/management/apis/get/entities'},   { name: 'operationId',     message: 'Unique string used to identify the operation. ?', default: 'uniqueId'},   { name: 'tags',     message: 'A list of tags for API documentation control.  ?', default: 'api2swagger'}, ]"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="apiq_bodyJsonQuestion"
			Group="Behavior"
			InitialValue="[   { name: 'name',     message: 'Name of URL Param ?', default: 'body'},   { name: 'description',     message: 'Description of URL Param ?', default: 'Request Payload Body'}, ]"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="apiq_headerParameterQuestions"
			Group="Behavior"
			InitialValue="[   { name: 'name',     message: 'Name of URL Param ?'},   { name: 'description',     message: 'Description of URL Param ?', default: 'Header Param Description'},   { name: 'type', message: 'Date type of query param ?', type: 'list', choices: [ """"string"""", """"integer"""", """"boolean"""" ]} ]"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="apiq_pathParameterQuestions"
			Group="Behavior"
			InitialValue="[   { name: 'name',     message: 'Name of URL Param ?', default: ''},   { name: 'description',     message: 'Description of URL Param ?', default: ''},   { name: 'type', message: 'Date type of query param ?', type: 'list', choices: [ """"string"""", """"integer"""", """"boolean"""" ]} ]"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="apiq_queryParameterQuestions"
			Group="Behavior"
			InitialValue="[   { name: 'description',     message: 'Description of Query Param ?', default: 'Query Param description goes here..'},   { name: 'required', message: 'Is Above Query param required ?', type: 'confirm'},   { name: 'type', message: 'Date type of query param ?', type: 'list', choices: [ """"string"""", """"number"""", """"boolean"""" ]},   { name: 'possibleValues', message: 'Comma Separated possible values?'} ]"
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

#tag Module
Protected Module execute
	#tag Method, Flags = &h0
		Function CompareResults(strTestMethodAndName As String, URL As String, HTTPStatus As Integer, Body As String, PathMethod As String) As Boolean
		  if testdb=nil Then
		    Return True
		  end if
		  Dim strSQL As String= "SELECT * FROM testresults WHERE test='" + EscapeSQLData(strTestMethodAndName) + "';"
		  Dim strHeaderParameters As String
		  Dim strPathParameters As String
		  Dim strQueryParameters As String
		  Dim strBodyParameters As String
		  if myAPICall.jAPIHeaderParameters<>nil then
		    myAPICall.jAPIHeaderParameters.EscapeSlashes=False
		    strHeaderParameters=myAPICall.jAPIHeaderParameters.ToString
		  end if
		  if myAPICall.jAPIPathParameters<>nil then
		    myAPICall.jAPIPathParameters.EscapeSlashes=False
		    strPathParameters=myAPICall.jAPIPathParameters.ToString
		  end if
		  if myAPICall.jAPIQueryParameters<>nil then
		    myAPICall.jAPIQueryParameters.EscapeSlashes=False
		    strQueryParameters=myAPICall.jAPIQueryParameters.ToString
		  end if
		  if myAPICall.jAPIBodyParameters<>nil then
		    myAPICall.jAPIBodyParameters.EscapeSlashes=False
		    strBodyParameters=myAPICall.jAPIBodyParameters.ToString
		  end if
		  Dim rs As RecordSet
		  rs=testdb.SQLSelect(strSQL)
		  if rs<>nil and rs.eof=False Then
		    //found, get and compare
		    Dim strMethod As String=rs.Field("method").StringValue
		    Dim strURL As String=rs.Field("url").StringValue
		    Dim iHTTPStatus As Integer=rs.Field("responsehttpstatus").IntegerValue
		    Dim strBody As String=rs.Field("responsebody").StringValue
		    Dim id As Integer=rs.Field("id").IntegerValue
		    strSQL="UPDATE testresults SET currenthttpstatus=" + Cstr(HTTPStatus) + ", currentresponsebody='" + _
		    EscapeSQLData(Body) + "' WHERE test='" + EscapeSQLData(strTestMethodAndName) + "';"
		    testdb.SQLExecute(strSQL)
		    if testdb.error=true Then
		      System.DebugLog "Failed to store result"
		    end if
		    if strMethod<>PathMethod then
		      Return False
		    end if
		    If strURL<>URL Then
		      Return False
		    end if
		    If iHTTPStatus<>HTTPStatus Then
		      Return False
		    end if
		    If strBody<>Body Then
		      Return False
		    end if
		    Return True
		  else
		    //not found
		    //store results
		    strSQL="INSERT INTO testresults(test,method,url,responsehttpstatus,responsebody,currenthttpstatus,currentresponsebody, " + _
		    "headerparameters,pathparameters,queryparameters,bodyparameters) VALUES(" + _
		    "'" + EscapeSQLData(strTestMethodAndName) + "', " + _ 
		    "'" + EscapeSQLData(PathMethod) + "', '" + EscapeSQLData(URL) + "', " + Cstr(HTTPStatus) + _
		    ", '" + EscapeSQLData(Body) + "', " + Cstr(HTTPStatus) + ", '" + EscapeSQLData(Body) + _
		    "', '" + EscapeSQLData(strHeaderParameters) + "', '" + EscapeSQLData(strPathParameters) + _
		    "', '" + EscapeSQLData(strQueryParameters) + "', '" + EscapeSQLData(strBodyParameters) + "');"
		    testdb.SQLExecute(strSQL)
		    if testdb.error=true Then
		      System.DebugLog "Failed to store result"
		      Return False
		    end if
		    Return True
		  end if
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub ContinueProcessRequest(Optional err As String)
		  Dim results As String
		  if err="" Then
		    Try
		      getQueryParametersInfo(swaggerSpec, urlObj, myOptions)
		      getHeaderParametersInfo(swaggerSpec, urlObj, myOptions)
		      getBodyInfo(swaggerSpec, urlObj, myOptions)
		      getPathParametersInfo(swaggerSpec, urlObj, myOptions)
		      finish(swaggerSpec, myOptions,results)
		      'break
		    Catch e As RuntimeException
		      err=e.Message
		    End Try
		  end if
		  if err<>"" Then
		    break
		    System.DebugLog "Error: " + err
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DoAPIRequest()
		  //arguments of the original api2swagger program
		  //"args": [
		  //                "-e 'https://server/v1/apiPath'", 
		  //                "-X GET", 
		  //                "-o /Users/username/swagger.json", 
		  //                "-H headerkeyname: the value of the headerkey'"
		  //            ],
		  
		  dim options As New JSONItem_MTC
		  //options.endpoint = program.endpoint;
		  Dim strEndPoint As String
		  Dim strDynamicEndPoint As String
		  //are we using https or http?
		  if myAPICall.strHTTPConnectionMethod="https" Then
		    strEndPoint="https://"
		  else
		    strEndPoint="http://"
		  end if
		  //are the host, basepath and apipath filled in
		  if myAPICall.strHost<>"" and myAPICall.strBasePath<>"" and myAPICall.strAPIPath<>"" then
		    //do we have an extra indentifier that has been added to the APIPath? (for instance an Id)
		    if myAPICall.jAPIPathParameters<>nil Then
		      Dim strDynamicPath As String=GetDynamicValuesAPIPath(myAPICall.strAPIVersion, myAPICall.strHTTPMethod, myAPICall.strAPIPath)
		      if left(strDynamicPath,1)<>"/" Then
		        strDynamicEndPoint=strEndPoint + myAPICall.strHost.Lowercase + myAPICall.strBasePath + "/" + strDynamicPath
		      Else
		        strDynamicEndPoint=strEndPoint + myAPICall.strHost.Lowercase + myAPICall.strBasePath + strDynamicPath
		      end if
		    end if
		    if left(myAPICall.strAPIPath,1)<>"/" Then
		      strEndPoint=strEndPoint + myAPICall.strHost.Lowercase + myAPICall.strBasePath + "/" + myAPICall.strAPIPath
		    else
		      strEndPoint=strEndPoint + myAPICall.strHost.Lowercase + myAPICall.strBasePath + myAPICall.strAPIPath
		    end if
		    //do we have QueryParameters
		    if myAPICall.jAPIQueryParameters<>nil then
		      if myAPICall.jAPIQueryParameters.Count>0 Then
		        if strDynamicEndPoint<>"" Then
		          strDynamicEndPoint = strDynamicEndPoint + "?"
		        end if
		        strEndPoint = strEndPoint + "?"
		        for i As Integer=0 To myAPICall.jAPIQueryParameters.Count-1
		          if i>0 Then
		            if strDynamicEndPoint<>"" Then
		              strDynamicEndPoint = strDynamicEndPoint + "&"
		            end if
		            strEndPoint=strEndPoint + "&"
		          end if
		          Dim jQueryParameter As JSONItem_MTC
		          jQueryParameter=myAPICall.jAPIQueryParameters(i)
		          Dim strQueryParameterName As String
		          strQueryParameterName=jQueryParameter.Name(0)
		          Dim strQueryParameterValue As String
		          strQueryParameterValue=jQueryParameter.Value(strQueryParameterName).StringValue
		          if strDynamicEndPoint<>"" Then
		            strDynamicEndPoint=strDynamicEndPoint + EncodeURLComponent(strQueryParameterName) + "=" + EncodeURLComponent(strQueryParameterValue)
		          end if
		          strEndPoint=strEndPoint + EncodeURLComponent(strQueryParameterName) + "=" + EncodeURLComponent(strQueryParameterValue)
		        next
		      end if
		    end if
		    
		    options.Value("endpoint")=strEndPoint
		    if strDynamicEndPoint<>"" then
		      options.Value("dynamicendpoint")=strDynamicEndPoint
		    end if
		    //options.httpMethod = program.httpMethod;
		    options.Value("httpMethod")=myAPICall.strHTTPMethod
		    //options.output = program.output;
		    options.Value("output")=strOutputFileName
		    //options.data = program.data;
		    if myAPICall.jAPIBodyParameters<>nil Then
		      options.Value("data")=myAPICall.jAPIBodyParameters
		      iBodyCount=myAPICall.jAPIBodyParameters.Count-1
		      if iBodyCount>=0 Then
		        bCurrentRequestContainsBody=True
		      end if
		    end if
		    //options.headers = program.header;
		    if myAPICall.jAPIHeaderParameters<>nil then
		      options.Value("headers")=myAPICall.jAPIHeaderParameters
		    end if
		    //options.proxy = program.proxy;
		    //Xojo.Net.HTTPSocket uses the system proxy settings
		    Dim errmsg As String
		    
		    StartProcessRequest(options,errmsg)
		    if errmsg<>"" then 
		      System.DebugLog(errmsg)
		    end if
		    
		  else
		    //No Host or no BasePath or no APIPath
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub Finish(swaggerSpec As JSONItem_MTC, options As JSONItem_MTC, byRef Results As String)
		  if err <> "" then
		    System.DebugLog "error in the information-gathering phase - no output will be generated"
		    return
		  end if
		  Try 
		    Dim fi As FolderItem
		    fi=GetFolderItem(options.Value("output").StringValue,FolderItem.PathTypeNative)
		    if fi<>nil then
		      Dim t As TextOutputStream = TextOutputStream.Create(fi)
		      swaggerSpec.EscapeSlashes=False
		      t.Write(ConvertEncoding(JSONPrettyPrint(StringToText(swaggerSpec.ToString)), Encodings.UTF8))
		      t=nil
		    end if
		  Catch
		    System.DebugLog "Error writing Swagger JSON File to : " + options.Value("output").StringValue
		    return
		  End Try
		  swaggerSpec.EscapeSlashes=False
		  System.DebugLog "Swagger JSON File successfully generated in : " + options.Value("output").StringValue
		  results=swaggerSpec.ToString
		  //back up the chain of execution
		  xojo.core.timer.CallLater(1000,Addressof RunTestsInArray)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetAndSetCredentials(strAPIVersion As String) As Boolean
		  Dim bReturn As Boolean=False
		  
		  //initialise the API Calls. MyAPICalls contains the credentials, so needs to be have been initialised
		  if myAPICalls=Nil then Return bReturn
		  
		  //Set the Credentials
		  //named according to the name of the credential in APICalls v1_Credentials
		  SetCredentials(myAPICalls,strAPIVersion,"Authorization",AuthorizationKey)
		  
		  //Set the host to connect to and the refreshtoken
		  myAPICalls.strHost=APIHost
		  
		  bReturn=True
		  
		  Return bReturn
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub GetApiInfo(urlObj As URIHelpers.URI, options As JSONItem_MTC)
		  Dim urlObjPath As String=DecodeURLComponent(urlObj.path.ToString)
		  Dim strSwaggerBasePath As String=swaggerSpec.Value("basePath")
		  Dim apiPath As String = urlObjPath.replace(strSwaggerBasePath, "")
		  Dim bNeedToCreatePath As Boolean=False
		  Dim bNeedToCreateApiPath As Boolean=False
		  Dim bNeedToCreateMethod As Boolean=False
		  
		  if apiPath = "" Then
		    apiPath = "/"
		  end if
		  
		  if Left(apiPath,1) <> "/" Then
		    apiPath = "/" + apiPath
		  end if
		  
		  Dim pathMethod As String = options.Value("httpMethod").StringValue.Lowercase
		  
		  if swaggerSpec.HasName("paths")=False Then
		    bNeedToCreatePath=True
		    bNeedToCreateApiPath=True
		    bNeedToCreateMethod=True
		  else
		    if swaggerSpec.child("paths").HasName(apipath)=False Then
		      bNeedToCreateApiPath=True
		      bNeedToCreateMethod=True
		    else
		      if swaggerSpec.Child("paths").Child(apiPath).HasName(pathMethod)=False Then
		        bNeedToCreateMethod=True
		      end if
		    end if
		  end if
		  
		  //temporary disable
		  //we currently create a new swagger file every single time
		  //to make sure that nothing goes wrong
		  #Pragma Warning "Code disabled for now. Check later if this is still needed"
		  'if bNeedToCreatePath=False and bNeedToCreateApiPath=False and bNeedToCreateMethod=False Then
		  '//all this is a check
		  '//the apipath and method already exist
		  '//if it does, but the headers differ, then we make a new apipath that has # and a number at the back
		  '//our hosted swaggerui will show two methods and they will work
		  '//in swagger you normally cannot have the same method called with different headers
		  'Dim bNewAPIPath As Boolean=False
		  'Dim headerParameters() As String
		  '//put the existing swagger API call (same basepath, apipath and method) header parameters in headerParameters
		  'for i As Integer = 0 to swaggerSpec.Child("paths").Child(apiPath).Child(pathMethod).Child("parameters").Count-1
		  'Dim jParameter As  New JSONItem_MTC
		  'jParameter = swaggerSpec.Child("paths").Child(apiPath).Child(pathMethod).Child("parameters").Value(i)
		  'if jParameter.Value("in").StringValue="header" Then
		  'headerParameters.Append jParameter.Value("name").StringValue
		  'end if
		  'next
		  '//todo: double check the header difference check code
		  '//compare option headers with the existing headers
		  'if options.HasName("headers") Then
		  'Dim jHeaders As New JSONItem_MTC
		  'jHeaders=options.Value("headers")
		  'for i As Integer = 0 to jHeaders.Count-1
		  'Dim jHeader As JSONItem_MTC
		  'jHeader=jHeaders.Value(i)
		  'Dim strName As String=jHeader.Name(0)
		  'if headerParameters.IndexOf(strName)=-1 Then
		  'bNewAPIPath=true
		  'end if
		  'next
		  'end if
		  '
		  'Dim iNextPathNumber As Integer
		  'if bNewAPIPath=True Then
		  'Dim jPaths As New JSONItem_MTC
		  'jPaths=swaggerSpec.Value("paths")
		  'Dim strPathNames() As String=jPaths.Names
		  'for i As Integer=0 to strPathNames.Ubound
		  'if left(strPathNames(i),len(apiPath))=apiPath Then
		  'Dim strPathNameParts() As String
		  'strPathNameParts=Split(strPathNames(i),"#")
		  'if strPathNameParts.Ubound=0 Then
		  'iNextPathNumber=1
		  'else
		  'if CLong(strPathNameParts(1))>iNextPathNumber Then
		  'iNextPathNumber=CLong(strPathNameParts(1))
		  'end if
		  'end if
		  'end if
		  'next
		  'end if
		  'If iNextPathNumber>0 Then
		  'apiPath=apiPath + "#" + CStr(iNextPathNumber)
		  'bNeedToCreateApiPath=True
		  'end if
		  'end if
		  
		  Dim jDocs As JSONItem_MTC
		  jDocs=GetDocs
		  Dim jApiInfo As JSONItem_MTC
		  if jDocs<>nil and jDocs.HasName("PathSpecific") and jDocs.Child("PathSpecific").HasName(apiPath) and _
		    jDocs.Child("PathSpecific").Child(apiPath).HasName("apiinfoq") and _
		    jDocs.Child("PathSpecific").Child(apiPath).Child("apiinfoq").Count > 0  then
		    jApiInfo=jDocs.Child("PathSpecific").Child(apiPath).Child("apiinfoq")
		    //array of apiinfoq's, each having the name of the apipath it belongs to
		    for i As Integer=0 to jApiInfo.Count-1
		      Dim jChild As JSONItem_MTC
		      //get the child
		      jChild=jApiInfo.Value(i)
		      //check its name
		      if jChild.Name(0)=apiPath Then
		        jApiInfo=jChild.Value(jChild.Name(0))
		        exit for
		      end if
		      
		    next
		  end if
		  
		  Dim answers AS JSONItem_MTC
		  if jApiInfo<>nil then
		    answers = apiq_Function_apiInfoQ(jApiInfo)
		  else
		    answers = apiq_Function_apiInfoQ()
		  end if
		  
		  Dim jPathMethodValues As New JSONItem_MTC
		  if bNeedToCreateMethod=True Then
		    jPathMethodValues.Value("description")=answers.Value("description")
		    jPathMethodValues.Value("summary")=answers.Value("summary")
		    if bCurrentRequestContainsBody=True Then
		      if iBodyCount>1 then
		        Dim jConsumes As New JSONItem_MTC("[]")
		        jConsumes.Append("multipart/form-data")
		        jPathMethodValues.Value("consumes")=jConsumes
		      else
		        Dim jConsumes As New JSONItem_MTC("[]")
		        jConsumes.Append("application/json")
		        jPathMethodValues.Value("consumes")=jConsumes
		      end if
		    end if
		    jPathMethodValues.Value("externalDocs")=answers.Value("externalDocs")
		    jPathMethodValues.Value("operationId")=answers.Value("operationId")
		    jPathMethodValues.Value("tags")=answers.Value("tags")
		  end if
		  
		  Dim jPathMethod As New JSONItem_MTC
		  jPathMethod.Value(pathMethod)=jPathMethodValues
		  
		  Dim jApiPath As New JSONItem_MTC
		  jApiPath.Value(apiPath)=jPathMethod
		  
		  if bNeedToCreatePath Then
		    swaggerSpec.Value("paths")=jApiPath
		  else
		    if bNeedToCreateApiPath Then
		      swaggerSpec.Child("paths").Value(apiPath)=jPathMethod
		    else
		      if bNeedToCreateMethod Then
		        swaggerSpec.Child("paths").Child(apiPath).Value(pathMethod)=jPathMethodValues
		      end if
		    end if
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub GetApiRuntimeInfo(urlObj As URIHelpers.URI, options As JSONItem_MTC, update As Boolean)
		  #Pragma Unused urlObj
		  #Pragma Unused update
		  system.DebugLog "Making an API Call & fetching more details...Please stay tuned.."
		  Dim pathMethod As String = options.Value("httpMethod").StringValue.Lowercase
		  
		  Dim requestUrl As New JSONItem_MTC("")
		  Dim jTmp As New JSONItem_MTC
		  if options.HasName("dynamicendpoint") then
		    jTmp.Value("url") = options.Value("dynamicendpoint").StringValue
		  else
		    jTmp.Value("url") = options.Value("endpoint").StringValue
		  end if
		  jTmp.Value("method") = pathMethod
		  requestUrl.Value("requestUrl") = jTmp
		  
		  
		  'if options.HasName("proxy") then
		  'requestUrl.Value("proxy") = options.Value("proxy")
		  'end if
		  //Xojo.Net.HTTPSocket uses the system proxy settings
		  
		  if options.HasName("data") then
		    requestUrl.Value("body") = options.Value("data")
		  end if
		  if options.HasName("headers") Then
		    if options.Child("headers").Count > 0 Then
		      Dim jHeaders As New JSONItem_MTC
		      for i As Integer = 0 to options.Child("headers").Count - 1
		        Dim jheader As JSONItem_MTC
		        jheader = options.Child("headers").Value(i)
		        Dim strName As String=jheader.Name(0)
		        Dim strValue As String=jheader.Value(strName).StringValue
		        jHeaders.Value(strName) = Trim(strValue)
		      next
		      requestUrl.Value("headers")=jHeaders
		    end if
		  end if
		  
		  request(myAPISocket,requestUrl)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub GetApiRuntimeInfoProcessResult(URL As Text, HTTPStatus As Integer, Content As xojo.Core.MemoryBlock, PathMethod As String, strContentType As String, strAuthorization As String)
		  #Pragma Unused URL
		  system.DebugLog "Processing the API Call Result..."
		  
		  Dim jEmptyObject As New JSONItem_MTC("{}")
		  Dim jEmptyArray As New JSONItem_MTC("[]")
		  Dim bPathMethodAlreadyExisted As Boolean=False
		  
		  PathMethod=PathMethod.Lowercase
		  
		  Dim apiPath As String=myAPICall.strAPIPath
		  
		  if apiPath = "" Then
		    apiPath = "/"
		  end if
		  
		  if Left(apiPath,1) <> "/" Then
		    apiPath = "/" + apiPath
		  end if
		  
		  if myAPICall.jAPIPathParameters<>nil Then
		    //todo
		    'apiPath=apiPath + "/" + myAPICall.strAPIPathIdentifier
		  end if
		  
		  if swaggerSpec.HasName("paths") = False Then
		    swaggerSpec.Value("paths") = jEmptyObject
		  end if
		  
		  if swaggerSpec.child("paths").HasName(apipath) = False Then
		    swaggerSpec.Child("paths").Value(apiPath) = jEmptyObject
		  end if
		  
		  if swaggerSpec.Child("paths").Child(apiPath).HasName(pathMethod) = False Then
		    swaggerSpec.Child("paths").Child(apiPath).Value(PathMethod) = jEmptyObject
		  else
		    bPathMethodAlreadyExisted = True
		  end if
		  
		  if swaggerSpec.Child("paths").Child(apiPath).Child(pathMethod).HasName("produces") = False Then
		    //if produces did not exist, then create it and fill it in
		    Dim jProduces As New JSONItem_MTC
		    jProduces.Append strContentType
		    swaggerSpec.Child("paths").Child(apiPath).Child(PathMethod).Value("produces")=jProduces
		  else
		    //if produces does exist add the content type if necessary (content type does not exist yet)
		    Dim bFound As Boolean=False
		    For i As Integer = 0 to swaggerSpec.Child("paths").Child(apiPath).Child(PathMethod).Child("produces").Count-1
		      if swaggerSpec.Child("paths").Child(apiPath).Child(PathMethod).Child("produces").Value(i).StringValue=strContentType Then
		        bFound=True
		        Exit for
		      end if
		    Next
		    if bFound=False Then
		      swaggerSpec.Child("paths").Child(apiPath).Child(PathMethod).Child("produces").Append strContentType
		    end if
		  end if
		  
		  
		  if swaggerSpec.Child("paths").Child(apiPath).Child(pathMethod).HasName("responses") = False Then
		    //if responses did not exist, create it, so we can fill in what the path produces
		    swaggerSpec.Child("paths").Child(apiPath).Child(PathMethod).Value("responses")=jEmptyObject
		  end if
		  
		  // We convert the returned content (MemoryBlock) to a Text
		  Dim body As Text = Xojo.Core.TextEncoding.UTF8.ConvertDataToText(Content)
		  Dim strBody As String=body
		  
		  Dim bcompare As Boolean=CompareResults(myAPICall.strTestMethodAndName,url,HTTPStatus,strBody,PathMethod)
		  Dim bstored As Boolean=StoreResultStructure(myAPICall.strTestMethodAndName,url,HTTPStatus,body,PathMethod)
		  
		  Dim jResponses As New JSONItem_MTC(body)
		  
		  wndGenerator.taResponse.Text=JSONPrettyPrint(StringToText(jResponses.ToString))
		  
		  Dim dDuration As Double=(Microseconds-dStartTime)/1000
		  wndGenerator.lstTestsRun.Cell(wndGenerator.lstTestsRun.LastIndex,1)=CStr(HTTPStatus)
		  wndGenerator.lstTestsRun.Cell(wndGenerator.lstTestsRun.LastIndex,2)=Format(dDuration,"#####") + "ms"
		  wndGenerator.lstTestsRun.CellType(wndGenerator.lstTestsRun.LastIndex,3)=Listbox.TypeCheckbox
		  wndGenerator.lstTestsRun.CellCheck(wndGenerator.lstTestsRun.LastIndex,3)=bcompare
		  
		  Dim jDescription As New JSONItem_MTC
		  jDescription.Value("description") = HTTPStatusDescription(Cstr(HTTPStatus))
		  
		  swaggerSpec.Child("paths").Child(apiPath).Child(PathMethod).Child("responses").Value(Cstr(HTTPStatus))=jDescription
		  
		  if strContentType.Instr("application/json") <> 0 and body <> "" Then
		    
		    //var schemaObj = jsonSchemaGenerator(JSON.parse(body));
		    Dim schemaObj AS JSONItem_MTC=jsonToSchema(jResponses) //schemaobject
		    schemaObj.Remove("$schema")
		    // bug with json scheme generator - work around
		    // For more details, https://github.com/krg7880/json-schema-generator/issues/13
		    scan(schemaObj)
		    swaggerSpec.Child("paths").Child(apiPath).Child(pathMethod).Child("responses").Child(Cstr(HTTPStatus)).Value("schema")=schemaObj
		    
		  end if
		  
		  if swaggerSpec.Child("paths").Child(apiPath).Child(pathMethod).HasName("security")=False Then
		    //we only set this once. not more than one security system per api call
		    swaggerSpec.Child("paths").Child(apiPath).Child(pathMethod).Value("security")=jEmptyArray
		    
		    if strAuthorization<>"" And Left(strAuthorization,5)="Basic" Then
		      Dim jBasicSecurity As New JSONItem_MTC("{""basicAuth"": []}")
		      Dim jSecurityDefinitions As New JSONItem_MTC("{""basicAuth"": {""type"": ""basic"",""description"": ""HTTP Basic Authentication. Works over `HTTP` and `HTTPS`""}}")
		      swaggerSpec.Value("securityDefinitions") = jSecurityDefinitions 
		      swaggerSpec.Child("paths").Child(apiPath).Child(pathMethod).Child("security").Append jBasicSecurity
		    end if
		  end if
		  
		  ContinueProcessRequest
		  
		  Exception e As RuntimeException
		    err=e.Message
		    ContinueProcessRequest
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub GetBasePathsInfo(possibleBasePaths() As String)
		  Dim answers AS JSONItem_MTC=aboutq_Function_basePathsQ(possibleBasePaths)
		  swaggerSpec.Value("basePath") = answers.Value("basePath")
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub GetBodyInfo(swaggerSpec As JSONItem_MTC, urlObj As URIHelpers.URI, options As JSONItem_MTC)
		  #Pragma Unused urlObj
		  // body parameters, such as file=tptype.txt
		  Dim jEmptyArray As New JSONItem_MTC("[]")
		  Dim apiPath As String=myAPICall.strAPIPath
		  Dim pathMethod As String = options.Value("httpMethod").StringValue.Lowercase
		  'if urlObj.Arguments.Count<>0 then
		  if apiPath = "" Then
		    apiPath = "/"
		  end if
		  
		  if Left(apiPath,1) <> "/" Then
		    apiPath = "/" + apiPath
		  end if
		  if swaggerSpec.Child("paths").Child(apiPath).Child(pathMethod).HasName("parameters")=False Then
		    swaggerSpec.Child("paths").Child(apiPath).Child(pathMethod).Value("parameters") = jEmptyArray
		  end if
		  //get the apidocs for this api version and call
		  Dim jDocs As JSONItem_MTC
		  Dim jbodyParametersDocs As JSONItem_MTC
		  jDocs=GetDocs
		  //look for general bodyparameters in the docs
		  if jDocs<>nil and jDocs.HasName("BodyParameters") Then
		    jbodyParametersDocs=jDocs.Child("BodyParameters")
		  end if
		  If jbodyParametersDocs<>nil and jbodyParametersDocs.Count>0 Then
		    Dim strbodyParameters() As String=jbodyParametersDocs.Names
		    if strbodyParameters.Ubound=0 Then
		      //one body parameter so in "body"
		      System.DebugLog "Api2swagger needs details related to param : " + strbodyParameters(0)
		      Dim answers As JSONItem_MTC=apiq_Function_BodyJSONQ(" {""type"": ""string""}")
		      swaggerSpec.Child("paths").Child(apiPath).Child(pathMethod).Child("parameters").Append answers
		    Else
		      //more than one body parameter so in "formData"
		      for i As Integer=0 to strbodyParameters.Ubound
		        System.DebugLog "Api2swagger needs details related to param : " + strbodyParameters(i)
		        Dim answers As JSONItem_MTC=apiq_Function_BodyParameterQ(strbodyParameters(i),jbodyParametersDocs)
		        swaggerSpec.Child("paths").Child(apiPath).Child(pathMethod).Child("parameters").Append answers
		      next
		    End If
		  end if
		  
		  //look for apipath specific parameters in the docs
		  if jDocs<>nil and jDocs.HasName("PathSpecific") Then
		    jDocs=jDocs.Child("PathSpecific")
		  else
		    jDocs=nil
		  end if
		  
		  if jDocs<>nil and jDocs.HasName(apipath) Then
		    jDocs=jDocs.Child(apiPath)
		    if jDocs<>nil and jDocs.HasName("BodyParameters") Then
		      jbodyParametersDocs=jDocs.Child("BodyParameters")
		    else
		      jbodyParametersDocs=nil
		    end if
		    #Pragma Warning "Still need to catch situation where combination op body parameters in general and pathspecific at the same time"
		    If jbodyParametersDocs<>nil and jbodyParametersDocs.Count>0 Then
		      Dim strbodyParameters() As String=jbodyParametersDocs.Names
		      if strbodyParameters.Ubound=0 Then
		        //one body parameter so in "body"
		        System.DebugLog "Api2swagger needs details related to param : " + strbodyParameters(0)
		        Dim answers As JSONItem_MTC=apiq_Function_BodyJSONQ(" {""type"": ""string""}")
		        swaggerSpec.Child("paths").Child(apiPath).Child(pathMethod).Child("parameters").Append answers
		      Else
		        //more than one body parameter so in "formData"
		        for i As Integer=0 to strbodyParameters.Ubound
		          System.DebugLog "Api2swagger needs details related to param : " + strbodyParameters(i)
		          Dim answers As JSONItem_MTC=apiq_Function_BodyParameterQ(strbodyParameters(i),jbodyParametersDocs)
		          swaggerSpec.Child("paths").Child(apiPath).Child(pathMethod).Child("parameters").Append answers
		        next
		      end if
		    end if
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetCredential(ByRef tmpAPICalls As APICalls, strAPIVersion As String, strName As String) As Variant
		  Dim vReturn As Variant
		  Dim myAPICallProperties() As Introspection.PropertyInfo = Introspection.GetType(tmpAPICalls).getProperties
		  Dim strAPICredentials As String="v" + strAPIVersion + "_Credentials"
		  For j As Integer=0 To myAPICallProperties.Ubound
		    If myAPICallProperties(j).Name=strAPICredentials Then
		      Dim strCredentials As String=myAPICallProperties(j).Value(tmpAPICalls).StringValue
		      Dim jCredentials As New JSONItem_MTC(strCredentials)
		      For k As Integer=0 To jCredentials.Count-1
		        Dim strCredName As String=jCredentials.Name(k)
		        If strCredName=strName Then
		          Dim jProperties As JSONItem_MTC=jCredentials.Value(strCredName)
		          vReturn=jProperties.Value("value")
		          Exit For
		        End If
		      Next
		      Exit For
		    End If
		  Next
		  Return vReturn
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function GetDocs() As JSONItem_MTC
		  //get all the properties of myAPIDocs
		  Dim myProperties() As Introspection.PropertyInfo = Introspection.GetType(myAPIDocs).getProperties
		  Dim strAPIVersion As String=myAPICall.strAPIVersion
		  Dim strHTTPMethod As String=myAPICall.strHTTPMethod
		  Dim strAPIPath As String=myAPICall.strAPIPath
		  Dim strAPIPathParts() As String=Split(strAPIPath,"/")
		  strAPIPath=strAPIPathParts(1) 
		  Dim strMethodName As String="v" + strAPIVersion + "_" + strAPIPath + "_" + strHTTPMethod
		  Dim jDocs As JSONItem_MTC
		  For i As Integer=0 To myProperties.Ubound
		    //if the name of the property is the same as the name of the api path being called
		    if myProperties(i).Name=strMethodName Then
		      //then get the value of the property
		      Dim strValue As String=myProperties(i).Value(myAPIDocs).StringValue
		      //turn it into a JSONItem_MTC
		      jDocs = New JSONItem_MTC(strValue)
		      exit for
		    end if
		  Next
		  Return jDocs
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetDynamicValuesAPIPath(strAPIVersion As String, strHTTPMethod As String, strAPIPath As String) As String
		  //get all the properties of myAPICalls
		  Dim myProperties() As Introspection.PropertyInfo = Introspection.GetType(myAPIcalls).getProperties
		  Dim strAPIPathParts() As String=strAPIPath.Split("/")
		  Dim strMethodName As String="v" + strAPIVersion + "_" + strAPIPathParts(1) + "_" + strHTTPMethod
		  Dim strDynamicAPIPath As String
		  For i As Integer=0 To myProperties.Ubound
		    //if the name of the property is the same as the name of the api path being called
		    if myProperties(i).Name=strMethodName Then
		      //then get the value of the property
		      Dim strValue As String=myProperties(i).Value(myAPICalls).StringValue
		      //turn it into a JSONItem_MTC
		      Dim jTests As JSONItem_MTC = New JSONItem_MTC(strValue)
		      For j As Integer=0 to jTests.Count-1
		        //go over the tests
		        Dim jTest As JSONItem_MTC=jTests.Child(j)
		        Dim jTestParameters As JSONItem_MTC=jTest.Value(jTest.Name(0))
		        if jTestParameters.Value("APIPath").StringValue=strAPIPath Then
		          //correct test found
		          //todo: more than 1 test for the same path
		          Dim strParameterName As String
		          if jTestParameters.HasName("PathParameters")=False then
		            strDynamicAPIPath=strAPIPath //no PathParameters Found in test, return original path
		          else
		            Dim jPathParameters As JSONItem_MTC=jTestParameters.Child("PathParameters")
		            if jPathParameters.Count=0 Then
		              strDynamicAPIPath=strAPIPath //no PathParameters Found in test, return original path
		            else
		              for k As Integer=0 to strAPIPathParts.Ubound
		                if len(strAPIPathParts(k))>2 and left(strAPIPathParts(k),1)="{" and right(strAPIPathParts(k),1)="}" Then
		                  //for a dynamic parameter in the path
		                  strParameterName=mid(strAPIPathParts(k),2,len(strAPIPathParts(k))-2)
		                  for l As Integer=0 to jPathParameters.Count
		                    if jPathParameters.name(l)=strParameterName then
		                      //found
		                      strAPIPathParts(k)=jPathParameters.Value(strParameterName)
		                      exit for
		                    end if
		                  next
		                end if
		                //look for the next dynamic parameter
		              next
		              strDynamicAPIPath=Join(strAPIPathParts, "/")
		            end if
		          end if
		          exit for
		        end if
		      Next
		      exit for
		    end if
		  Next
		  Return strDynamicAPIPath
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub GetHeaderParametersInfo(swaggerSpec As JSONItem_MTC, urlObj As URIHelpers.URI, options As JSONItem_MTC)
		  #Pragma Unused urlObj
		  //header parameters, such as X-MyHeader: Value
		  Dim jEmptyArray As New JSONItem_MTC("[]")
		  Dim apiPath As String=myAPICall.strAPIPath
		  
		  if apiPath = "" Then
		    apiPath = "/"
		  end if
		  
		  if Left(apiPath,1) <> "/" Then
		    apiPath = "/" + apiPath
		  end if
		  
		  Dim pathMethod As String = options.Value("httpMethod").StringValue.Lowercase
		  if swaggerSpec.Child("paths").Child(apiPath).Child(pathMethod).HasName("parameters")=False Then
		    swaggerSpec.Child("paths").Child(apiPath).Child(pathMethod).Value("parameters") = jEmptyArray
		  end if
		  
		  //get the apidocs for this api version and call
		  Dim jDocs As JSONItem_MTC
		  Dim jHeaderDocs As JSONItem_MTC
		  jDocs=GetDocs
		  //look for general queryparameters in the docs
		  if jDocs<>nil and jDocs.HasName("HeaderParameters") Then
		    jHeaderDocs=jDocs.Child("HeaderParameters")
		  end if
		  
		  If jHeaderDocs<>nil and jHeaderDocs.Count>0 then
		    //get all the headernames
		    Dim strHeaderNames() As String=jHeaderDocs.Names
		    For i As Integer=0 to strHeaderNames.Ubound
		      Dim jHeaderDoc As JSONItem_MTC=jHeaderDocs.Child(strHeaderNames(i))
		      Dim answers AS JSONItem_MTC
		      answers = apiq_Function_headerParameterQ(strHeaderNames(i),jHeaderDoc)
		      //check if we already have the parameter in the swaggerSpec
		      Dim jParameters As New JSONItem_MTC
		      jParameters=swaggerSpec.Child("paths").Child(apiPath).Child(pathMethod).Value("parameters")
		      Dim bFound As Boolean=False
		      Dim jParameter As New JSONItem_MTC
		      for j As Integer = 0 to jParameters.Count-1
		        jParameter=jParameters.Value(j)
		        if jParameter.Value("in").StringValue="header" then
		          if jParameter.Value("name").StringValue=strHeaderNames(i) then
		            bFound=True
		            Exit For
		          end if
		        end if
		      next
		      if bFound=False Then
		        swaggerSpec.Child("paths").Child(apiPath).Child(pathMethod).Child("parameters").Append answers
		      else
		        jParameter=answers
		      end if
		    Next
		  end if
		  
		  //look for apipath specific parameters in the docs
		  if jDocs<>nil and jDocs.HasName("PathSpecific") Then
		    jDocs=jDocs.Child("PathSpecific")
		  else
		    jDocs=nil
		  end if
		  
		  if jDocs<>nil and jDocs.HasName(apiPath) Then
		    jDocs=jDocs.Child(apiPath)
		    
		    if jDocs<>nil and jDocs.HasName("HeaderParameters") Then
		      jHeaderDocs=jDocs.Child("HeaderParameters")
		    else
		      jHeaderDocs=nil
		    end if
		    
		    If jHeaderDocs<>nil and jHeaderDocs.Count>0 then
		      //get all the headernames
		      Dim strHeaderNames() As String=jHeaderDocs.Names
		      For i As Integer=0 to strHeaderNames.Ubound
		        Dim jHeaderDoc As JSONItem_MTC=jHeaderDocs.Child(strHeaderNames(i))
		        Dim answers AS JSONItem_MTC
		        answers = apiq_Function_headerParameterQ(strHeaderNames(i),jHeaderDoc)
		        //check if we already have the parameter in the swaggerSpec
		        Dim jParameters As New JSONItem_MTC
		        jParameters=swaggerSpec.Child("paths").Child(apiPath).Child(pathMethod).Value("parameters")
		        Dim bFound As Boolean=False
		        Dim jParameter As New JSONItem_MTC
		        for j As Integer = 0 to jParameters.Count-1
		          jParameter=jParameters.Value(j)
		          if jParameter.Value("in").StringValue="header" then
		            if jParameter.Value("name").StringValue=strHeaderNames(i) then
		              bFound=True
		              Exit For
		            end if
		          end if
		        next
		        if bFound=False Then
		          swaggerSpec.Child("paths").Child(apiPath).Child(pathMethod).Child("parameters").Append answers
		        else
		          jParameter=answers
		        end if
		      Next
		    end if
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetMethodsAndTests(strAPIVersion As String, strHTTPMethod As String) As JSONItem_MTC
		  //get all the properties of myAPICalls
		  Dim strValue As String
		  Dim myProperties() As Introspection.PropertyInfo = Introspection.GetType(myAPIcalls).getProperties
		  Dim strAPIVer As String="v" + strAPIVersion + "_"
		  Dim iLenAPIVer As Integer= strAPIVer.Len
		  Dim strMethod As String = "_" + strHTTPMethod
		  Dim iLenHTTPMethod As Integer= strMethod.Len
		  Dim jReturnTests As New JSONItem_MTC("[]")
		  for each p as Introspection.PropertyInfo in myProperties
		    //if the name of the property is the same as the name of the api path being called
		    //or we want to run all tests
		    if Left(p.Name,iLenAPIVer)=strAPIVer and right(p.name,iLenHTTPMethod)=strMethod Then
		      //then get the value of the property
		      strValue=p.Value(myAPICalls).StringValue
		      //turn it into a JSONItem_MTC
		      Dim jTests As JSONItem_MTC = New JSONItem_MTC(strValue)
		      For j As Integer=0 to jTests.Count-1
		        //go over the tests
		        Dim jTest As JSONItem_MTC=jTests.Child(j)
		        Dim jTestParameters As JSONItem_MTC=jTest.Value(jTest.Name(0))
		        Dim jReturnTest As New JSONItem_MTC("{}")
		        jReturnTest.Value("methodandtestname")=p.Name  + " (" + jTest.Name(0) + ")"
		        jReturnTest.Value("apipathandtestname")=jTestParameters.Value("APIPath").StringValue + " (" + jTest.Name(0) + ")"
		        jReturnTests.Append jReturnTest
		      Next
		    end if
		  Next
		  Return jReturnTests
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub GetPathParametersInfo(swaggerSpec As JSONItem_MTC, urlObj As URIHelpers.URI, options As JSONItem_MTC)
		  Dim jEmptyArray As New JSONItem_MTC("")
		  Dim pathMethod As String = options.Value("httpMethod").StringValue.Lowercase
		  Dim apiPath As String=myAPICall.strAPIPath
		  
		  if apiPath = "" Then
		    apiPath = "/"
		  end if
		  
		  if Left(apiPath,1) <> "/" Then
		    apiPath = "/" + apiPath
		  end if
		  
		  if swaggerSpec.Child("paths").Child(apiPath).Child(pathMethod).HasName("parameters")=False Then
		    swaggerSpec.Child("paths").Child(apiPath).Child(pathMethod).Value("parameters") = jEmptyArray
		  end if
		  // path parameters, such as /users/{id}
		  //if myAPICall.jAPIPathParameters is not empty then we have dynamic parameters
		  //contrary to headerparameters and queryparameters we only document the ones we called, since they are part of the apipath
		  //and therefore will create another path in the swaggerspec 
		  //as a result we also only have pathparameters at the apipath level
		  //so for instance /Addresses/{addressid}/Orders/{orderid} would have addressid at the /Addresses/{addressid} path
		  //and {addressid} and {orderid} at the /Addresses/{addressid}/Orders/{orderid} path
		  
		  if myAPICall.jAPIPathParameters<>nil and myAPICall.jAPIPathParameters.Count>0 Then
		    Dim tmppathComponents() As String = urlObj.path.ToString.split("/")
		    Dim jPathComponents As New JSONItem_MTC
		    For i As Integer=0 to tmppathComponents.Ubound
		      jPathComponents.Append DecodeURLComponent(tmppathComponents(i))
		    Next
		    'Dim chooseParams As String="[{ ""name"": ""urlParams"", ""message"": ""Choose Dynamic Params in URL ?"", ""type"": ""checkbox"", ""choices"": " + jpathComponents.ToString + "}]"
		    'Dim moreanswers As JSONItem_MTC=Questions(chooseParams,True)
		    //fill moreanswers from the actual call
		    Dim moreanswers As New JSONItem_MTC
		    moreanswers.Value("urlParams")=myAPICall.jAPIPathParameters
		    // Run param info call
		    'async.eachSeries(answers.urlParams, function iterator(urlParam, qcallback) {
		    Dim jURLParams As New JSONItem_MTC
		    jURLParams=moreanswers.Value("urlParams")
		    Dim strParamNames() As String=jURLParams.Names
		    strParamNames.Sort
		    For i As Integer = 0 to strParamNames.Ubound
		      Dim strPathParam As String=strParamNames(i)
		      System.DebugLog "Api2swagger needs details related to param : " + strPathParam
		      // construct new path too..
		      Dim jDocs As JSONItem_MTC
		      Dim jPathParametersDocs As JSONItem_MTC
		      jDocs=GetDocs
		      if jDocs.HasName("PathSpecific") and jDocs.Child("PathSpecific").HasName(apiPath) and _
		        jDocs.Child("PathSpecific").Child(apiPath).HasName("PathParameters") then
		        jPathParametersDocs=jDocs.Child("PathSpecific").Child(apiPath).Child("PathParameters")
		      end if
		      if jPathParametersDocs<>nil and jPathParametersDocs.HasName(strPathParam) Then
		        jPathParametersDocs=jPathParametersDocs.Child(strPathParam)
		      else
		        jPathParametersDocs=nil
		      end if
		      Dim urlanswers As JSONItem_MTC
		      if jPathParametersDocs<>nil and jPathParametersDocs.Count>0 then
		        urlanswers = apiq_Function_pathParameterQ(strPathParam,jPathParametersDocs)
		      else
		        urlanswers = apiq_Function_pathParameterQ(strPathParam)
		      end if
		      swaggerSpec.Child("paths").Child(apiPath).Child(pathMethod).Child("parameters").Append urlanswers
		    Next
		  End if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub GetProtocolInfo(urlObj As URIHelpers.URI)
		  Dim answers As JSONItem_MTC = aboutq_Function_protocolsQ(urlObj.Scheme)
		  if answers.HasName("http") Then
		    swaggerSpec.Child("schemes").append "http"
		  elseif answers.HasName("https") Then
		    swaggerSpec.Child("schemes").append "https"
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub GetQueryParametersInfo(swaggerSpec As JSONItem_MTC, urlObj As URIHelpers.URI, options As JSONItem_MTC)
		  #Pragma Unused urlObj
		  // query parameters, such as /users?role=admin
		  Dim jEmptyArray As New JSONItem_MTC("[]")
		  Dim apiPath As String=myAPICall.strAPIPath
		  Dim pathMethod As String = options.Value("httpMethod").StringValue.Lowercase
		  if apiPath = "" Then
		    apiPath = "/"
		  end if
		  
		  if Left(apiPath,1) <> "/" Then
		    apiPath = "/" + apiPath
		  end if
		  swaggerSpec.Child("paths").Child(apiPath).Child(pathMethod).Value("parameters") = jEmptyArray
		  //get the apidocs for this api version and call
		  Dim jDocs As JSONItem_MTC
		  Dim jQueryParametersDocs As JSONItem_MTC
		  jDocs=GetDocs
		  //look for general queryparameters in the docs
		  if jDocs<>nil and jDocs.HasName("QueryParameters") Then
		    jQueryParametersDocs=jDocs.Child("QueryParameters")
		  end if
		  If jQueryParametersDocs<>nil and jQueryParametersDocs.Count>0 Then
		    //disabled. We will document all the parameters from the docs instead
		    'For i As Integer = 0 to urlObj.Arguments.Count-1
		    'System.DebugLog "Api2swagger needs details related to param : " + urlObj.Arguments.Name(i)
		    'Dim answers As JSONItem_MTC=apiq_Function_queryParameterQ(urlObj.Arguments.Name(i),jQueryParametersDocs)
		    'swaggerSpec.Child("paths").Child(apiPath).Child(pathMethod).Child("parameters").Append answers
		    'Next
		    Dim strQueryParameters() As String=jQueryParametersDocs.Names
		    for i As Integer=0 to strQueryParameters.Ubound
		      System.DebugLog "Api2swagger needs details related to param : " + strQueryParameters(i)
		      Dim answers As JSONItem_MTC=apiq_Function_queryParameterQ(strQueryParameters(i),jQueryParametersDocs)
		      swaggerSpec.Child("paths").Child(apiPath).Child(pathMethod).Child("parameters").Append answers
		    next
		  end if
		  
		  //look for apipath specific parameters in the docs
		  if jDocs<>nil and jDocs.HasName("PathSpecific") Then
		    jDocs=jDocs.Child("PathSpecific")
		  else
		    jDocs=nil
		  end if
		  
		  if jDocs<>nil and jDocs.HasName(apipath) Then
		    jDocs=jDocs.Child(apiPath)
		    if jDocs<>nil and jDocs.HasName("QueryParameters") Then
		      jQueryParametersDocs=jDocs.Child("QueryParameters")
		    else
		      jQueryParametersDocs=nil
		    end if
		    If jQueryParametersDocs<>nil and jQueryParametersDocs.Count>0 Then
		      //disabled. We will document all the parameters from the docs instead
		      'For i As Integer = 0 to urlObj.Arguments.Count-1
		      'System.DebugLog "Api2swagger needs details related to param : " + urlObj.Arguments.Name(i)
		      'Dim answers As JSONItem_MTC=apiq_Function_queryParameterQ(urlObj.Arguments.Name(i),jQueryParametersDocs)
		      'swaggerSpec.Child("paths").Child(apiPath).Child(pathMethod).Child("parameters").Append answers
		      'Next
		      Dim strQueryParameters() As String=jQueryParametersDocs.Names
		      for i As Integer=0 to strQueryParameters.Ubound
		        System.DebugLog "Api2swagger needs details related to param : " + strQueryParameters(i)
		        Dim answers As JSONItem_MTC=apiq_Function_queryParameterQ(strQueryParameters(i),jQueryParametersDocs)
		        swaggerSpec.Child("paths").Child(apiPath).Child(pathMethod).Child("parameters").Append answers
		      next
		    end if
		  end if
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetSequence(strAPIVersion As String) As JSONItem_MTC
		  //get all the properties of myAPICalls
		  Dim strValue As String
		  Dim myProperties() As Introspection.PropertyInfo = Introspection.GetType(myAPIcalls).getProperties
		  Dim strAPISequence As String="v" + strAPIVersion + "_Sequence"
		  Dim jTestSequence As New JSONItem_MTC("[]")
		  for each p as Introspection.PropertyInfo in myProperties
		    //if the name of the property is the same as the name of the api path being called
		    //or we want to run all tests
		    if p.Name=strAPISequence Then
		      //then get the value of the property
		      strValue=p.Value(myAPICalls).StringValue
		      //turn it into a JSONItem_MTC
		      jTestSequence = New JSONItem_MTC(strValue)
		    end if
		  Next
		  Return jTestSequence
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetStructureFromCallResult(HTTPStatus As Integer, buffer As Text) As String
		  Dim jResponse As New JSONItem(buffer)
		  Dim strReturn As String=""
		  Dim iSuccessHTTPCode() As Integer=Array(200,201,204) 
		  
		  if iSuccessHTTPCode.IndexOf(HTTPStatus)=-1 then
		    Return ""
		  end if
		  Dim jRecords As JSONItem
		  
		  if jResponse.IsArray=False Then
		    #Pragma Warning "Use It Group specific code. Remove if not needed."
		    if jResponse.HasName("Records") Then
		      jRecords=jResponse.Child("Records")
		    end if
		  else
		    jRecords=jResponse
		  end if
		  
		  if jRecords=nil then
		    Return ""
		  end if
		  
		  if jRecords.IsArray and jRecords.Count>0 Then
		    //get the first record
		    Dim jRecord As JSONItem=jRecords.Value(0)
		    if jRecord.IsArray=False Then
		      Dim RecordFieldNames() As String=jRecord.Names
		      If RecordFieldNames.Ubound<>-1 Then
		        Dim iMaxLenFieldName As Integer=len("Field Name")
		        For i As Integer=0 to RecordFieldNames.Ubound
		          if Len(RecordFieldNames(i))>iMaxLenFieldName Then
		            iMaxLenFieldName=Len(RecordFieldNames(i))
		          end if
		        Next
		        For i As Integer=0 to RecordFieldNames.Ubound
		          strReturn=strReturn + RecordFieldNames(i) + ","
		          Dim v As Variant
		          v=jRecord.Value(RecordFieldNames(i))
		          Dim vType As Integer=VarType(v)
		          strReturn = strReturn + Cstr(vType) + EndOfLine
		        Next
		      end if
		    end if
		  end if
		  
		  Return strReturn
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function getsupportedprotocols() As String()
		  return Array("https")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub GetSwaggerInfo()
		  Dim answers AS JSONItem_MTC=aboutq_Function_InfoQ
		  swaggerSpec.Value("info")=answers
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetTests(strAPIVersion As String, strHTTPMethod As String) As String()
		  //get all the properties of myAPICalls
		  Dim strValue As String
		  Dim myProperties() As Introspection.PropertyInfo = Introspection.GetType(myAPIcalls).getProperties
		  Dim strAPIVer As String="v" + strAPIVersion + "_"
		  Dim iLenAPIVer As Integer= strAPIVer.Len
		  Dim strMethod As String = "_" + strHTTPMethod
		  Dim iLenHTTPMethod As Integer= strMethod.Len
		  Dim strTests() As String
		  for each p as Introspection.PropertyInfo in myProperties
		    //if the name of the property is the same as the name of the api path being called
		    //or we want to run all tests
		    if Left(p.Name,iLenAPIVer)=strAPIVer and right(p.name,iLenHTTPMethod)=strMethod Then
		      //then get the value of the property
		      strValue=p.Value(myAPICalls).StringValue
		      //turn it into a JSONItem_MTC
		      Dim jTests As JSONItem_MTC = New JSONItem_MTC(strValue)
		      For j As Integer=0 to jTests.Count-1
		        //go over the tests
		        Dim jTest As JSONItem_MTC=jTests.Child(j)
		        Dim jTestParameters As JSONItem_MTC=jTest.Value(jTest.Name(0))
		        strTests.Append jTestParameters.Value("APIPath").StringValue + " (" + jTest.Name(0) + ")"
		      Next
		    end if
		  Next
		  Return strTests
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub InitialiseAPICalls()
		  //initialise the API docs
		  myAPIDocs=new APICallDocs
		  
		  //initialise the test values for the calls
		  JSONValuesForRun=new JSONItem_MTC
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Questions(myQuestions As Variant, bAsk As Boolean=False) As JSONItem_MTC
		  'name: 'description',     message: 'A verbose explanation of the operation behavior.  ?', default: 'API Method Description'
		  Dim jQuestions As New JSONItem_MTC(myQuestions)
		  Dim jAnswers As New JSONItem_MTC
		  if jQuestions.Count=0 Then
		    Return nil
		  end if
		  if jQuestions.IsArray Then
		    For i As Integer=0 To jQuestions.Count-1
		      Dim strType As String = ""
		      if JSONItem_MTC(jQuestions.Value(i)).HasName("type") Then
		        strType=JSONItem_MTC(jQuestions.Value(i)).Value("type").StringValue
		      end if
		      Dim strName As String = JSONItem_MTC(jQuestions.Value(i)).Value("name").StringValue
		      Dim strMessage As String = JSONItem_MTC(jQuestions.Value(i)).Value("message").StringValue
		      Dim strDefault As String = ""
		      if JSONItem_MTC(jQuestions.Value(i)).HasName("default") Then
		        strDefault = JSONItem_MTC(jQuestions.Value(i)).Value("default").StringValue
		      end if
		      if strType="" Then
		        if bAsk Then
		          Dim strAnswer As String=wndQuestion.ShowModal(strName, strMessage, strDefault, strType)
		          jAnswers.Value(strName) = strAnswer
		        else
		          jAnswers.Value(strName) = strDefault
		        end if
		      elseif strType="confirm" then
		        if bAsk Then
		          Dim d As New MessageDialog
		          Dim b As MessageDialogButton
		          d.Icon=MessageDialog.GraphicQuestion
		          d.ActionButton.Caption="Y"
		          d.AlternateActionButton.Caption="n"
		          d.AlternateActionButton.Visible=True
		          d.Message=strMessage
		          d.Title=strName
		          b=d.ShowModal
		          Select Case b
		          Case d.ActionButton
		            jAnswers.Value(strName) = "Y"
		          Case d.AlternateActionButton
		            //do not add the name (http or https)
		          end select
		        else
		          if strDefault="Y" Then
		            jAnswers.Value(strName) = strDefault
		          end if
		        end if
		        
		      elseif strType="list" then
		        if bAsk Then
		          if JSONItem_MTC(jQuestions.Value(i)).HasName("choices") Then
		            Dim jOptions As JSONItem_MTC=JSONItem_MTC(jQuestions.Value(i)).Child("choices")
		            Dim strOptions() As String
		            For j As Integer=0 to jOptions.Count-1
		              strOptions.Append jOptions.Value(j).StringValue
		            Next
		            Dim strAnswer As String=wndQuestion.ShowModal(strName, strMessage, strDefault, strType, strOptions)
		            jAnswers.Value(strName) = strAnswer
		          else
		            jAnswers.Value(strName) = strDefault
		          end if
		        else
		          jAnswers.Value(strName) = strDefault
		        end if
		        
		      elseif strType="checkbox" then
		        if bAsk Then
		          if JSONItem_MTC(jQuestions.Value(i)).HasName("choices") Then
		            Dim jOptions As JSONItem_MTC=JSONItem_MTC(jQuestions.Value(i)).Child("choices")
		            Dim strOptions() As String
		            For j As Integer=0 to jOptions.Count-1
		              strOptions.Append jOptions.Value(j).StringValue
		            Next
		            Dim strAnswer As String=wndQuestion.ShowModal(strName, strMessage, strDefault, strType, strOptions)
		            jAnswers.Value(strName) = strAnswer
		          else
		            jAnswers.Value(strName) = strDefault
		          end if
		        else
		          jAnswers.Value(strName) = strDefault
		        end if
		        
		      else
		        if strDefault="Y" Then
		          jAnswers.Value(strName) = strDefault
		        else
		          //do not add the name (http or https)
		        end if
		      end if
		      
		    Next
		  else
		    Dim strType As String = ""
		    if jQuestions.HasName("type") Then
		      strType=jQuestions.Value("type").StringValue
		    end if
		    Dim strName As String = jQuestions.Value("name").StringValue
		    Dim strMessage As String = jQuestions.Value("message").StringValue
		    Dim strDefault As String = ""
		    if jQuestions.HasName("default") Then
		      strDefault = jQuestions.Value("default").StringValue
		    end if
		    if strType="list" then
		      if bAsk Then
		        if jQuestions.HasName("choices") Then
		          Dim jOptions As JSONItem_MTC=jQuestions.Child("choices")
		          Dim strOptions() As String
		          For i As Integer=0 to jOptions.Count-1
		            strOptions.Append jOptions.Value(i).StringValue
		          Next
		          Dim strAnswer As String=wndQuestion.ShowModal(strName, strMessage, strDefault, strType, strOptions)
		          jAnswers.Value(strName) = strAnswer
		        else
		          jAnswers.Value(strName) = strDefault
		        end if
		      else
		        jAnswers.Value(strName) = strDefault
		      end if
		    end if
		  end if
		  Return jAnswers
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RunSelectedMethods()
		  //collect all the api call paths (strAPIPaths) and their http methods (strAPIPathHTTPMethods) to run in the test
		  Dim strAPIPathAndTestNamesTmp() As String
		  Dim strAPITestHTTPMethodsTmp() As String
		  Dim strAPIMethodsAndTestNamesTmp() As String
		  Dim strAPIPathAndTestNamesInTests() As String
		  Dim strAPITestHTTPMethodsInTests() As String
		  Dim strAPIMethodsAndTestNamesInTests() As String
		  if strAllowedHTTPMethods.Ubound<>-1 Then
		    Dim strCurrentHTTPMethod As String
		    Dim jMethodsAndTests As JSONItem_MTC
		    Do
		      strCurrentHTTPMethod=strAllowedHTTPMethods.Pop
		      jMethodsAndTests=GetMethodsAndTests(strAPIVersion,strCurrentHTTPMethod)
		      Dim iCount As Integer=jMethodsAndTests.Count
		      if iCount > 0 Then
		        for i As Integer=0 to iCount-1
		          Dim jMethodAndTest As JSONItem_MTC=jMethodsAndTests.Value(i)
		          strAPIMethodsAndTestNamesTmp.Append jMethodAndTest.Value("methodandtestname").StringValue
		          strAPIPathAndTestNamesTmp.Append jMethodAndTest.Value("apipathandtestname").StringValue
		          strAPITestHTTPMethodsTmp.Append strCurrentHTTPMethod
		        next
		      end if
		    Loop Until strAllowedHTTPMethods.Ubound=-1
		    //determine sequence of tests (from v1_Sequence)
		    'Dim jSequence As New JSONItem_MTC("[""v1_Reset_GET (test1)"",""v1_Contacts_GET (test1)"",""v1_Contacts_GET (test2)"",""v1_Contacts_POST (test1)"",""v1_Contacts_PUT (test1)"",""v1_Contacts_DELETE (test1)""]")
		    Dim jSequence As JSONItem_MTC=GetSequence(strAPIVersion)
		    If jSequence.IsArray Then
		      Dim iTestCount As Integer=jSequence.Count
		      For i As Integer=0 to iTestCount-1
		        Dim strTestName As String = jSequence.Value(i).StringValue
		        Dim iTestPlaceInTmpArray As Integer=strAPIMethodsAndTestNamesTmp.IndexOf(strTestName)
		        if iTestPlaceInTmpArray<>-1 Then
		          //test found, add it to the intests arrays
		          strAPIPathAndTestNamesInTests.Append strAPIPathAndTestNamesTmp(iTestPlaceInTmpArray)
		          strAPITestHTTPMethodsInTests.Append strAPITestHTTPMethodsTmp(iTestPlaceInTmpArray)
		          strAPIMethodsAndTestNamesInTests.Append strAPIMethodsAndTestNamesTmp(iTestPlaceInTmpArray)
		        end if
		      Next i
		    end if
		    //reverse order due to the use of pop on the array during processing
		    For i As Integer=strAPIPathAndTestNamesInTests.Ubound Downto 0
		      strAPIMethodsAndTestNames.Append strAPIMethodsAndTestNamesInTests(i)
		      strAPIPathAndTestNames.Append strAPIPathAndTestNamesInTests(i)
		      strAPITestHTTPMethods.Append strAPITestHTTPMethodsInTests(i)
		    Next
		     
		    if strAPIPathAndTestNames.Ubound<>-1 Then
		      xojo.core.timer.CallLater(1000,Addressof RunTestsInArray)
		    else
		      wndGenerator.tfStatus.Text="Done"
		    end if
		  else
		    'Break
		    wndGenerator.tfStatus.Text="Done"
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RunSelectedTest(strAPIMethodAndTestName As String, strAPIPathAndTestName As String, strHTTPMethod As String)
		  //get all the properties of myAPIDocs
		  Dim myProperties() As Introspection.PropertyInfo = Introspection.GetType(myAPIDocs).getProperties
		  //Take the first part of the apipath
		  //do this so that we can put all the documentation for a path in one place (for instance v1_GET_Adddresses)
		  //keep the full path so we can look up the correct path's documentation in the doc for the path
		  Dim strAPIPathFull As String=strAPIPathAndTestName
		  bResultColumnsLimited=False
		  //remove the test name from the path. It starts with ' ('
		  Dim iTestNameStart As Integer=InStr(strAPIPathFull,"(")
		  Dim strTestName As String
		  if len(strAPIPathFull)<iTestNameStart+1 Then
		    strTestName=""
		  else
		    strTestName=Mid(strAPIPathFull,iTestNameStart+1)
		    Dim iTestNameEnd As Integer
		    iTestNameEnd=InStr(strTestName,")")
		    if iTestNameEnd<>0 Then
		      strTestName=Left(strTestName,iTestNameEnd-1)
		    end if
		  end if
		  
		  if iTestNameStart<>0 and iTestNameStart>1 Then
		    strAPIPathFull=Left(strAPIPathFull,iTestNameStart-2)
		  end if
		  
		  Dim strAPIPathForCall As String=strAPIPathFull
		  
		  if Left(strAPIPathFull,1) <> "/" Then
		    strAPIPathFull = "/" + strAPIPathFull
		  end if
		  Dim strAPIPathParts() As String=split(strAPIPathFull,"/")
		  Dim strAPIPath As String=strAPIPathParts(1)
		  Dim strMethodName As String="v" + strAPIVersion + "_" + strAPIPath + "_" + strHTTPMethod
		  
		  
		  wndGenerator.lstTestsRun.AddRow strMethodName + "(" + strAPIMethodAndTestName + ")"
		  
		  Dim jHeaders As New JSONItem_MTC
		  Dim jAPIQueryParameters As New JSONItem_MTC
		  Dim jAPIPathParameters As New JSONItem_MTC
		  Dim jAPIBodyParameters As New JSONItem_MTC
		  
		  For i As Integer=0 To myProperties.Ubound
		    //if the name of the property is the same as the name of the api path being called
		    if myProperties(i).Name=strMethodName Then
		      //collect the credentials from APICalls
		      dim myAPICallsProperties() As Introspection.PropertyInfo = Introspection.GetType(myAPICalls).getProperties
		      Dim bCredentialsFound As Boolean=False
		      dim strAPICredentials As String="v" + strAPIVersion + "_Credentials"
		      Dim jCredentials As JSONItem_MTC
		      Dim jTestValues As JSONItem_MTC
		      for j As Integer=0 to myAPICallsProperties.Ubound
		        if myAPICallsProperties(j).Name=strAPICredentials then
		          //we found the Credentials for this version of the API
		          bCredentialsFound=True
		          //make a JSONItem_MTC
		          Dim strCredentials As String=myAPICallsProperties(j).Value(myAPICalls).StringValue
		          jCredentials = New JSONItem_MTC(strCredentials)
		          APIParametersToJSONItemArray(jCredentials,jHeaders)
		          Exit For
		        end if
		      next
		      if bCredentialsFound=False Then
		        //without Credentials we cannot use the api
		        Break
		        exit Sub
		      end if
		      //then get the value of the property
		      Dim strValue As String=myProperties(i).Value(myAPIDocs).StringValue
		      //turn it into a JSONItem_MTC
		      Dim jValues As New JSONItem_MTC(strValue)
		      //Get the test values for the current call
		      Dim bTestValuesFound As Boolean=False
		      Dim jTestsValues As JSONItem_MTC
		      for j As Integer=0 to myAPICallsProperties.Ubound
		        if myAPICallsProperties(j).Name=strMethodName then
		          //make a JSONItem_MTC
		          Dim strTestsValues As String=myAPICallsProperties(j).Value(myAPICalls).StringValue
		          jTestsValues = New JSONItem_MTC(strTestsValues)
		          //this is an array of tests
		          //check if the test with strTestName exists
		          //then get the specific test values for this test
		          For k As Integer=0 to jTestsValues.Count-1
		            jTestValues=jTestsValues.Value(k)
		            if jTestValues.Name(0)=strTestName Then
		              jTestValues=jTestValues.Value(strTestName)
		              bTestValuesFound=True
		              Exit For
		            end if
		          Next
		          if bTestValuesFound=True then
		            exit For
		          end if
		        end if
		      next
		      //Get the HeaderParameterValues from the testvalues, if any
		      Dim jHeaderParameterValues As JSONItem_MTC
		      if jTestValues<>nil and jTestValues.HasName("HeaderParameters") then
		        jHeaderParameterValues=jTestValues.Child("HeaderParameters")
		      end if
		      //if the property contains headers
		      if jValues.HasName("HeaderParameters") then
		        //get the headerparameters from the top level
		        Dim jHeaderParameters As JSONItem_MTC=jValues.Child("HeaderParameters")
		        //Credentials are found at the top level
		        //if the headernames are found in the Credentials then don't add it here (already added)
		        Dim strHeaderNames() As String=jHeaderParameters.Names
		        For k As Integer=0 to strHeaderNames.Ubound
		          if jCredentials.HasName(strHeaderNames(k)) Then
		            jHeaderParameters.Remove(strHeaderNames(k))
		          end if
		        Next
		        if jHeaderParameters.Count>0 Then
		          APIParametersToJSONItemArray(jHeaderParameters,jHeaders,jHeaderParameterValues)
		        end if
		      end if
		      if jValues.HasName("PathSpecific") and jValues.Child("PathSpecific").HasName(strAPIPathFull) and _
		        jValues.Child("PathSpecific").Child(strAPIPathFull).HasName("HeaderParameters") and _
		        jValues.Child("PathSpecific").Child(strAPIPathFull).Child("HeaderParameters").Count > 0 then
		        //get the path specific headerparameters
		        Dim jHeaderParameters As JSONItem_MTC=jValues.Child("PathSpecific").Child(strAPIPathFull).Child("HeaderParameters")
		        APIParametersToJSONItemArray(jHeaderParameters,jHeaders,jHeaderParameterValues)
		      end if
		      //Get the QueryParameterValues from the testvalues, if any
		      Dim jQueryParameterValues As JSONItem_MTC
		      if jTestValues<>nil and jTestValues.HasName("QueryParameters") then
		        jQueryParameterValues=jTestValues.Child("QueryParameters")
		      end if
		      if jValues.HasName("QueryParameters") then
		        //get the QueryParameters from the top level
		        Dim jQueryParameters As JSONItem_MTC=jValues.Child("QueryParameters")
		        #Pragma Warning "If... End If is Luna specific code. Disable for other api's" 
		        if jQueryParameters.HasName("columns") Then
		          bResultColumnsLimited=True
		        end if
		        APIParametersToJSONItemArray(jQueryParameters,jAPIQueryParameters,jQueryParameterValues)
		      end if
		      if jValues.HasName("PathSpecific") and jValues.Child("PathSpecific").HasName(strAPIPathFull) and _
		        jValues.Child("PathSpecific").Child(strAPIPathFull).HasName("QueryParameters") and _
		        jValues.Child("PathSpecific").Child(strAPIPathFull).Child("QueryParameters").Count > 0  then
		        //get the path specific query parameters
		        Dim jQueryParameters As JSONItem_MTC=jValues.Child("PathSpecific").Child(strAPIPathFull).Child("QueryParameters")
		        #Pragma Warning "If... End If is Luna specific code. Disable for other api's"
		        if jQueryParameters.HasName("columns") Then
		          bResultColumnsLimited=True
		        end if
		        APIParametersToJSONItemArray(jQueryParameters,jAPIQueryParameters,jQueryParameterValues)
		      end if
		      //Get the BodyParameterValues from the testvalues, if any
		      Dim jBodyParameterValues As JSONItem_MTC
		      if jTestValues<>nil and jTestValues.HasName("BodyParameters") then
		        jBodyParameterValues=jTestValues.Child("BodyParameters")
		      end if
		      if jValues.HasName("BodyParameters") then
		        //get the BodyParameters from the top level
		        Dim jBodyParameters As JSONItem_MTC=jValues.Child("BodyParameters")
		        APIParametersToJSONItemArray(jBodyParameters,jAPIBodyParameters,jBodyParameterValues)
		      end if
		      if jValues.HasName("PathSpecific") and jValues.Child("PathSpecific").HasName(strAPIPathFull) and _
		        jValues.Child("PathSpecific").Child(strAPIPathFull).HasName("BodyParameters") and _
		        jValues.Child("PathSpecific").Child(strAPIPathFull).Child("BodyParameters").Count > 0  then
		        //get the path specific query parameters
		        Dim jBodyParameters As JSONItem_MTC=jValues.Child("PathSpecific").Child(strAPIPathFull).Child("BodyParameters")
		        APIParametersToJSONItemArray(jBodyParameters,jAPIBodyParameters,jBodyParameterValues)
		      end if
		      
		      //Get the PathParameterValues from the testvalues, if any
		      Dim jPathParameterValues As JSONItem_MTC
		      if jTestValues<>nil and jTestValues.HasName("PathParameters") then
		        jPathParameterValues=jTestValues.Child("PathParameters")
		      end if
		      //pathparameters are always path specific
		      if jValues.HasName("PathSpecific") and jValues.Child("PathSpecific").HasName(strAPIPathFull) and _
		        jValues.Child("PathSpecific").Child(strAPIPathFull).HasName("PathParameters") and _
		        jValues.Child("PathSpecific").Child(strAPIPathFull).Child("PathParameters").Count > 0 then
		        //get the PathParams
		        Dim jPathParameters As JSONItem_MTC=jValues.Child("PathSpecific").Child(strAPIPathFull).Child("PathParameters")
		        APIParametersToJSONItemObject(jPathParameters,jAPIPathParameters,jPathParameterValues)
		      end if
		      exit for
		    end if
		  Next
		  
		  myAPICall = New APICall
		  myAPICall.strAPIVersion=strAPIVersion
		  myAPICall.strTestMethodAndName=strAPIMethodAndTestName
		  myAPICall.strHTTPConnectionMethod=strHTTPConnectionMethod
		  myAPICall.strHTTPMethod=strHTTPMethod
		  myAPICall.strHost=strHost
		  myAPICall.strBasePath=strExecuteBasePath
		  myAPICall.strAPIPath=strAPIPathForCall
		  if jAPIPathParameters.Count=0 Then jAPIPathParameters=nil
		  myAPICall.jAPIPathParameters=jAPIPathParameters
		  if jHeaders.Count=0 Then jHeaders=nil
		  myAPICall.jAPIHeaderParameters=jHeaders
		  if jAPIQueryParameters.Count=0 Then jAPIQueryParameters=nil
		  myAPICall.jAPIQueryParameters=jAPIQueryParameters
		  myAPICall.jAPIBodyParameters=jAPIBodyParameters
		  myAPICall.StartCall
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RunTests(strPassedMethods As String="")
		  //collect the methods to run in the test
		  //the order of processing is
		  //RunTests
		  //RunSelectedMethods
		  //RunTestsInArray
		  //RunSelectedTest
		  //Finish goes back to get the next test in RunTestsInArray
		  ReDim strAPIMethodsAndTestNames(-1)
		  ReDim strAPIPathAndTestNames(-1)
		  ReDim strAPITestHTTPMethods(-1)
		  Dim strAllowedMethods() As String=Split("GET,POST,PUT,DELETE",",")
		  Dim strPassedMethodArray() As String
		  if strPassedMethods="" Then
		    strPassedMethods="GET,POST,PUT,DELETE"
		  end if
		  strPassedMethodArray=Split(strPassedMethods,",")
		  for i As integer = 0 to strPassedMethodArray.Ubound
		    if strAllowedMethods.IndexOf(strPassedMethodArray(i))<>-1 Then
		      strAllowedHTTPMethods.Append strPassedMethodArray(i)
		    end if
		  next
		  testdb=OpenDB
		  if testdb=nil Then
		    System.DebugLog "Won't be able to compare results"
		  end if
		  xojo.core.timer.CallLater(1000,AddressOf RunSelectedMethods)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RunTestsInArray()
		  if strAPIPathAndTestNames.Ubound<>-1 then
		    Dim strAPIMethodAndTestName As String
		    Dim strAPIPathAndTestName As String
		    Dim strHTTPMethod As String
		    //get the next test
		    strAPIMethodAndTestName=strAPIMethodsAndTestNames.Pop
		    strAPIPathAndTestName=strAPIPathAndTestNames.Pop
		    strHTTPMethod=strAPITestHTTPMethods.Pop
		    RunSelectedTest(strAPIMethodAndTestName, strAPIPathAndTestName, strHTTPMethod)
		    
		  else
		    //back up the chain
		    xojo.Core.Timer.CallLater(1000,Addressof RunSelectedMethods)
		    
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub Scan(obj AS JSONItem_MTC)
		  Dim k As String
		  if obj.IsObject Then
		    Dim names() As String = obj.Names
		    For i As Integer=0 to names.Ubound
		      k=names(i)
		      if k="required" Then
		        if obj.Child(k).IsArray Then
		          if obj.Child(k).Count=0 Then
		            obj.Remove(k)
		          end if
		        end if
		      else
		        if obj.HasName(k) then
		          Dim bChildIsaJSONItem As Boolean=obj.isJSONItem(k)
		          if bChildIsaJSONItem=True Then
		            Scan(obj.Child(k))
		          end if
		        end if
		      end if
		    Next
		  else
		    //not an Object so obj[k] here is a value
		  end if
		  
		  Exception err As JSONException
		    System.DebugLog err.Message + " Error Code:" + Cstr(err.ErrorNumber)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetCredentials(ByRef tmpAPICalls As APICalls, strAPIVersion As String, strName As String, vValue As Variant)
		  dim myAPICallProperties() As Introspection.PropertyInfo = Introspection.GetType(tmpAPICalls).getProperties
		  dim strAPICredentials As String="v" + strAPIVersion + "_Credentials"
		  for j As Integer=0 to myAPICallProperties.Ubound
		    if myAPICallProperties(j).Name=strAPICredentials then
		      Dim strCredentials As String=myAPICallProperties(j).Value(tmpAPICalls).StringValue
		      Dim jCredentials As New JSONItem_MTC(strCredentials)
		      for k As Integer=0 to jCredentials.Count-1
		        Dim strCredName As String=jCredentials.Name(k)
		        if strCredName=strName Then
		          Dim jProperties As JSONItem_MTC=jCredentials.Value(strCredName)
		          jProperties.Value("value")=vValue
		          jCredentials.Value(strName)=jProperties
		          myAPICallProperties(j).Value(tmpAPICalls)=jCredentials.ToString
		          Exit For
		        end if
		      next
		      Exit For
		    end if
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetPmToValue(pm As PopupMenu, strValue As String)
		  for i As Integer=0 to pm.ListCount-1
		    if pm.List(i)=strValue Then
		      pm.ListIndex=i
		      exit for
		    end if
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetStaticExecuteParameters(mystrAPIVersion As String, mystrHTTPConnectionMethod As String,  mystrHost As String, mystrBasePath As String, mystrOutputFileName As String)
		  strAPIVersion=mystrAPIVersion
		  strHTTPConnectionMethod=mystrHTTPConnectionMethod
		  strHost=mystrHost
		  strExecuteBasePath=mystrBasePath
		  strOutputFileName=mystrOutputFileName
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub StartProcessRequest(options As JSONItem_MTC, byRef ErrorMessage As String)
		  err=""
		  Dim jErrorMsgs As New JSONItem_MTC(command_errorCodes)
		  myAPISocket=new APISocket
		  swaggerSpec = New JSONItem_MTC()
		  swaggerSpec.EscapeSlashes=False
		  basePathMatch = False
		  myOptions=options
		  
		  swaggerSpec.Value("swagger") = "2.0"
		  if options.HasName("endpoint")=False Then
		    // Error Code : 01 for missing endPoint
		    ErrorMessage=jErrorMsgs.Value("01")
		    Exit Sub
		  end if
		  // Extract Information needed for Swagger Spec
		  urlObj = options.Value("endpoint").StringValue
		  if urlObj.host.ToString = "" Then
		    // Error Code : 02 for invalid endPoint
		    ErrorMessage=jErrorMsgs.Value("02")
		    Exit Sub
		  End if
		  if options.HasName("output")=False then
		    // Error Code : 05 for output file missing
		    ErrorMessage=jErrorMsgs.Value("05")
		    Exit Sub
		  end if
		  Dim supportedProtocols() As String = getsupportedprotocols
		  //If you support http and https, also change the default answer
		  //in aboutq_httpsq and aboutq_httpq, so that the support for https
		  //is visible in the swaggerSpec
		  'Dim supportedProtocols() As String = Array("http","https","ws","wss")
		  if supportedProtocols.indexOf ( urlObj.Scheme ) = -1 Then
		    // Error Code : 03 for invalid protocol
		    ErrorMessage=jErrorMsgs.Value("03")
		    Exit Sub
		  end if
		  #Pragma Warning "No support for PATCH for now"
		  Dim supportedMethods() As String = Array("GET", "POST", "PUT", "DELETE", "HEAD")
		  if options.HasName("httpMethod")=False then
		    options.Value("httpMethod") = "GET"
		  end if
		  if supportedMethods.indexOf(options.Value("httpMethod")) = -1 Then
		    // Error Code : 04 for invalid Method Name
		    ErrorMessage=jErrorMsgs.Value("04")
		    Exit Sub
		  end if
		  // Check if swagger source given in output - Update Operation
		  dim strSwaggerSpecRead As String
		  Dim swaggerSpecRead As JSONItem_MTC
		  Try 
		    // Query the entry
		    Dim stats As FolderItem
		    stats=GetFolderItem(options.Value("output").StringValue,FolderItem.PathTypeNative)
		    if stats<>nil then
		      if stats.Exists then
		        dim tiSwaggerSpecRead As TextInputStream
		        tiSwaggerSpecRead=TextInputStream.Open(stats)
		        tiSwaggerSpecRead.Encoding = Encodings.UTF8
		        strSwaggerSpecRead=tiSwaggerSpecRead.ReadAll
		      end if
		    end if
		    if strSwaggerSpecRead<>"" then
		      swaggerSpecRead = New JSONItem_MTC(strSwaggerSpecRead)
		      if swaggerSpecRead.HasName("host") and swaggerSpecRead.Value("host").StringValue.Lowercase <> urlObj.host.ToString.Lowercase Then
		        Dim jErrorMessage As JSONItem_MTC=jErrorMsgs.Child("06")
		        ErrorMessage=jErrorMessage.ToString
		        Exit Sub
		      end if
		      hostMatch = true
		      createNew = false
		    else
		      hostMatch=False
		      createNew=True
		    end if
		  catch e As RuntimeException
		    // Nothing for now..
		  End Try
		  
		  // Check for basepath match
		  if createNew=False and swaggerSpecRead<>nil Then
		    if Instr(urlObj.path.ToString, swaggerSpecRead.Value("basePath").StringValue ) =0 Then
		      ErrorMessage=jErrorMsgs.Value("07")
		    else
		      basePathMatch = true
		    end if
		  end if
		  
		  if basePathMatch=False and options.Value("output").StringValue="" Then
		    //we have something that we don't want to log
		    //for instance getting e new accesstoken
		    //output is defined as empty
		    //so we need to create a new swaggerspec that we won't save in the end
		    hostMatch=False
		    createNew=True
		  end if
		  
		  
		  swaggerSpec.Value("host") = urlObj.host.ToString.Lowercase
		  Dim jSchemes As New JSONItem_MTC
		  jSchemes.Append(urlObj.Scheme)
		  swaggerSpec.Value("schemes") = jSchemes
		  '// Extract Possible Base Paths
		  Dim pathComponents() As String = Split(urlObj.Path.ToString,"/")
		  Dim possibleBasePaths() As String
		  Dim tempBasePath As String= ""
		  for each PathComponent As String in pathComponents
		    if pathComponent <> "" Then
		      tempBasePath = tempBasePath + "/" + pathComponent
		      possibleBasePaths.Append(tempBasePath)
		    else 
		      possibleBasePaths.Append("/")
		    End if
		  next
		  
		  if hostMatch=False and createNew=True Then
		    getSwaggerInfo //general description of the API + contact info + licence info
		    getProtocolInfo(urlObj) //what schemes are supported, https, http or both
		    getBasePathsInfo(possibleBasePaths) //the basepath of the api (for instance /api/v1)
		    getApiInfo(urlObj, options) //api path, http method (GET,POST,PUT,PATCH,DELETE), parameters, description, 
		    //the next call will send a request to the api
		    //the result of the mySocket call will get processed by getApiRuntimeInfoProcessResult
		    //after that ContinueProcessRequest will be called where everything will be finished 
		    //and written to the file 
		    getApiRuntimeInfo(urlObj, options, false)
		    
		  else
		    // Basepath & hostname matched, updated the swagger spec
		    swaggerSpec = swaggerSpecRead
		    getApiInfo(urlObj, options)
		    //the next call will send a request to the api
		    //the result of the mySocket call will get processed by getApiRuntimeInfoProcessResult
		    //after that ContinueProcessRequest will be called where everything will be finished 
		    //and written to the file 
		    getApiRuntimeInfo(urlObj, options, true)
		    
		  end if
		  
		  Exception e As RuntimeException
		    err=e.message
		    ContinueProcessRequest
		    
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function StoreResultStructure(strTestMethodAndName As String, URL As String, HTTPStatus As Integer, Body As Text, PathMethod As String) As Boolean
		  Dim bReturn As Boolean=False
		  if testdb=nil Then
		    Return False
		  end if
		  Dim strSQL As String= "SELECT structure FROM testresults WHERE test='" + EscapeSQLData(strTestMethodAndName) + "';"
		  Dim rs As RecordSet
		  Dim strStructure As String=GetStructureFromCallResult(HTTPStatus,Body)
		  if strStructure<>"" Then
		    rs=testdb.SQLSelect(strSQL)
		    if rs<>nil and rs.eof=False Then
		      //found, update structure
		      //should always exist, because this comes after the CompareResults function which creates the record if needed
		      strSQL="UPDATE testresults SET structure='" +  strStructure + "' WHERE test='" + EscapeSQLData(strTestMethodAndName) + "';"
		      testdb.SQLExecute(strSQL)
		      if testdb.error=true Then
		        System.DebugLog "Failed to store result"
		      else
		        bReturn=True
		      end if
		    end if
		  else
		    //no structure received or error
		  end if
		  Return bReturn
		  
		End Function
	#tag EndMethod


	#tag Note, Name = api.js
		var url = require('url');
		var errorCodes = require('../errorCodes/command');
		var questions = require('../questions/aboutq');
		var apiq = require('../questions/apiq');
		var async = require('async');
		var request = require('request');
		var HTTPStatus = require('http-status');
		var jsonSchemaGenerator = require('json-schema-generator');
		var fs = require('fs');
		var inquirer = require("inquirer");
		
		module.exports = {
		processRequest: processRequest
		};
		
		var swaggerSpec = {};
		swaggerSpec.swagger = "2.0";
		var hostMatch = false;
		var basePathMatch = false;
		var createNew = true;
		
		
		function processRequest(options, cb) {
		if(options.endpoint == null) {
		// Error Code : 01 for missing endPoint
		var errorMessage = errorCodes.errorMessage("01");
		return cb(true, errorMessage);
		}
		// Extract Information needed for Swagger Spec
		var urlObj = url.parse(options.endpoint);
		if (urlObj.host == null) {
		// Error Code : 02 for invalid endPoint
		return cb(true, errorCodes.errorMessage("02"));
		}
		if (options.output == null) {
		// Error Code : 02 for invalid endPoint
		return cb(true, errorCodes.errorMessage("05"));
		}
		var supportedProtocols = ['http', 'https', 'ws', 'wss'];
		if (supportedProtocols.indexOf(urlObj.protocol.slice(0, -1)) == -1) {
		// Error Code : 03 for invalid protocol
		return cb(true, errorCodes.errorMessage("03"));
		}
		var supportedMethods = ['GET', 'POST', 'PUT', 'DELETE', 'HEAD'];
		if (options.httpMethod == null) {
		options.httpMethod = 'GET';
		}
		if (supportedMethods.indexOf(options.httpMethod) == -1) {
		// Error Code : 03 for invalid protocol
		return cb(true, errorCodes.errorMessage("04"));
		}
		// Check if swagger source given in output - Update Operation
		try {
		// Query the entry
		stats = fs.lstatSync(options.output);
		var swaggerSpecRead = JSON.parse(fs.readFileSync(options.output, 'utf8'));
		if (swaggerSpecRead.host != urlObj.host) {
		return cb(true, errorCodes.errorMessage("06"));
		}
		hostMatch = true;
		createNew = false;
		}
		catch (e) {
		// Nothing for now..
		}
		
		// Check for basepath match
		if (!createNew) {
		if (urlObj.pathname.indexOf(swaggerSpecRead.basePath) == -1) {
		return cb(true, errorCodes.errorMessage("07"));
		} else {
		basePathMatch = true;
		}
		}
		
		swaggerSpec.host = urlObj.host;
		swaggerSpec.schemes = new Array();
		swaggerSpec.schemes.push(urlObj.protocol.slice(0, -1));
		// Extract Possible Base Paths
		var pathComponents = urlObj.pathname.split("/");
		var possibleBasePaths = new Array();
		var tempBasePath = "";
		for (var key in pathComponents) {
		if (pathComponents[key] != '') {
		tempBasePath = tempBasePath + "/" + pathComponents[key];
		possibleBasePaths.push(tempBasePath);
		}
		else {
		possibleBasePaths.push("/");
		}
		}
		if (!hostMatch && createNew) {
		async.series({
		swaggerInfo: function (callback) {
		getSwaggerInfo(swaggerSpec, callback);
		},
		protocols: function (callback) {
		getProtocolInfo(swaggerSpec, urlObj, callback);
		},
		basePaths: function (callback) {
		getBasePathsInfo(swaggerSpec, possibleBasePaths, callback);
		},
		apiInfo: function (callback) {
		getApiInfo(swaggerSpec, urlObj, options, callback);
		},
		runtimeInfo: function (callback) {
		getApiRuntimeInfo(swaggerSpec, urlObj, options, false, callback);
		},
		queryParamInfo: function (callback) {
		getQueryParamInfo(swaggerSpec, urlObj, options, callback);
		},
		headerInfo: function (callback) {
		getHeaderInfo(swaggerSpec, urlObj, options, callback);
		},
		bodyInfo: function (callback) {
		getBodyInfo(swaggerSpec, urlObj, options, callback);
		},
		// Make sure you execute this last
		paramsInfo: function (callback) {
		getParamsInfo(swaggerSpec, urlObj, options, callback);
		}
		},
		function (err, results) {
		console.log(JSON.stringify(swaggerSpec, null, 2));
		fs.writeFile(options.output, JSON.stringify(swaggerSpec, null, 2), function (err) {
		if (err) {
		cb(err, {});
		}
		console.log("Swagger JSON File successfully generated in : " + options.output);
		cb(null, {});
		});
		}
		);
		}
		else {
		// Basepath & hostname matched, updated the swagger spec
		swaggerSpec = swaggerSpecRead;
		async.series({
		apiInfo: function (callback) {
		getApiInfo(swaggerSpec, urlObj, options, callback);
		},
		runtimeInfo: function (callback) {
		getApiRuntimeInfo(swaggerSpec, urlObj, options, true, callback);
		},
		queryParamInfo: function (callback) {
		getQueryParamInfo(swaggerSpec, urlObj, options, callback);
		},
		headerInfo: function (callback) {
		getHeaderInfo(swaggerSpec, urlObj, options, callback);
		},
		bodyInfo: function (callback) {
		getBodyInfo(swaggerSpec, urlObj, options, callback);
		},
		// Make sure you execute this last
		paramsInfo: function (callback) {
		getParamsInfo(swaggerSpec, urlObj, options, callback);
		}
		},
		function (err, results) {
		console.log(JSON.stringify(swaggerSpec, null, 2));
		fs.writeFile(options.output, JSON.stringify(swaggerSpec, null, 2), function (err) {
		if (err) {
		cb(err, {});
		}
		console.log("Swagger JSON File successfully generated in : " + options.output);
		cb(null, {});
		});
		}
		);
		}
		}
		
		function scan(obj)
		{
		var k;
		if (obj instanceof Object) {
		for (k in obj){
		if (k=="required") {
		if (obj[k] instanceof Array) {
		if (obj[k].length == 0) {
		delete obj[k];
		}
		}
		}
		if (obj.hasOwnProperty(k)){
		//recursive call to scan property
		scan( obj[k] );
		}
		}
		} else {
		//not an Object so obj[k] here is a value
		};
		};
		
		var getSwaggerInfo = function(swaggerSpec, callback){
		questions.infoQ(null, function(answers) {
		swaggerSpec.info = answers;
		callback(null, true);
		});
		};
		
		var getApiInfo = function(swaggerSpec, urlObj, options, callback){
		var apiPath = urlObj.pathname.replace(swaggerSpec.basePath, "");
		if (apiPath == "") {
		apiPath = "/";
		}
		if (apiPath.charAt(0) != "/") {
		apiPath = "/" + apiPath;
		}
		if (swaggerSpec.paths == null) {
		swaggerSpec.paths = {};
		}
		if (swaggerSpec.paths[apiPath] == null) {
		swaggerSpec.paths[apiPath] = {};
		}
		var pathMethod = options.httpMethod.toLowerCase();
		if (swaggerSpec.paths[apiPath][pathMethod] == null) {
		swaggerSpec.paths[apiPath][pathMethod] = {};
		}
		apiq.apiInfoQ(null, function(answers) {
		//Update API Path Information
		swaggerSpec.paths[apiPath][pathMethod]["description"] = answers.description;
		swaggerSpec.paths[apiPath][pathMethod]["summary"] = answers.summary;
		swaggerSpec.paths[apiPath][pathMethod]["externalDocs"] = answers.externalDocs;
		swaggerSpec.paths[apiPath][pathMethod]["operationId"] = answers.operationId;
		swaggerSpec.paths[apiPath][pathMethod]["tags"] = answers.tags;
		callback(null, true);
		});
		};
		
		var getProtocolInfo = function(swaggerSpec, urlObj, callback) {
		questions.protocolsQ(urlObj.protocol.slice(0, -1), function(answers) {
		if (answers.http) {
		swaggerSpec.schemes.push('http');
		}
		else if(answers.https){
		swaggerSpec.schemes.push('https');
		}
		callback(null, true);
		});
		}
		
		var getBasePathsInfo = function(swaggerSpec, possibleBasePaths, callback) {
		questions.basePathsQ(possibleBasePaths, function(answers) {
		swaggerSpec.basePath = answers.basePath;
		callback(null, true);
		});
		}
		
		var getApiRuntimeInfo = function(swaggerSpec, urlObj, options, update, callback) {
		console.log("Making an API Call & fetching more details...Please stay tuned..");
		var apiPath = urlObj.pathname.replace(swaggerSpec.basePath, "");
		var pathMethod = options.httpMethod.toLowerCase();
		if (apiPath == "") {
		apiPath = "/";
		}
		if (apiPath.charAt(0) != "/") {
		apiPath = "/" + apiPath;
		}
		var requestUrl = {
		url : options.endpoint,
		method: pathMethod
		};
		if (options.data != null) {
		requestUrl['body'] = options.data;
		}
		if (options.headers != null && options.headers.length > 0) {
		requestUrl['headers'] = {};
		for (var i = 0; i < options.headers.length; i++) {
		var header = options.headers[i];
		var keyValue = header.split(":");
		requestUrl['headers'][keyValue[0]] = keyValue[1];
		}
		}
		request(requestUrl, function (error, response, body) {
		if (swaggerSpec.paths == null) {
		swaggerSpec.paths = {};
		}
		if (swaggerSpec.paths[apiPath] == null) {
		swaggerSpec.paths[apiPath] = {};
		}
		if (swaggerSpec.paths[apiPath][pathMethod] == null) {
		swaggerSpec.paths[apiPath][pathMethod] = {};
		}
		swaggerSpec.paths[apiPath][pathMethod]["produces"] = new Array();
		swaggerSpec.paths[apiPath][pathMethod]["produces"].push(response.headers['content-type']);
		swaggerSpec.paths[apiPath][pathMethod]["responses"] = {};
		swaggerSpec.paths[apiPath][pathMethod]["responses"][response.statusCode] = {};
		swaggerSpec.paths[apiPath][pathMethod]["responses"][response.statusCode].description = HTTPStatus[response.statusCode];
		if (response.headers['content-type'].indexOf('application/json') > -1 && body != '') {
		var schemaObj = jsonSchemaGenerator(JSON.parse(body));
		delete schemaObj.$schema;
		// bug with json scheme generator - work around
		// For more details, https://github.com/krg7880/json-schema-generator/issues/13
		scan(schemaObj);
		swaggerSpec.paths[apiPath][pathMethod]["responses"][response.statusCode].schema = schemaObj;
		}
		swaggerSpec.paths[apiPath][pathMethod].security = new Array();
		if (response.request.headers.authorization && response.request.headers.authorization.startsWith('Basic')) {
		var basicSecurity =   {
		"basicAuth": []
		};
		swaggerSpec.securityDefinitions =  {
		"basicAuth": {
		"type": "basic",
		"description": "HTTP Basic Authentication. Works over `HTTP` and `HTTPS`"
		}
		};
		swaggerSpec.paths[apiPath][pathMethod].security.push(basicSecurity);
		}
		callback(null, true);
		});
		}
		
		
		var getQueryParamInfo =  function(swaggerSpec, urlObj, options, callback) {
		// TODO : redundant code, need better way
		var apiPath = urlObj.pathname.replace(swaggerSpec.basePath, "");
		if (apiPath == "") {
		apiPath = "/";
		}
		if (apiPath.charAt(0) != "/") {
		apiPath = "/" + apiPath;
		}
		var pathMethod = options.httpMethod.toLowerCase();
		if (urlObj.query != null && urlObj.query.split("&").length > 0) {
		var queryParams = urlObj.query.split("&");
		swaggerSpec.paths[apiPath][pathMethod]["parameters"] = new Array();
		async.eachSeries(queryParams, function iterator(queryparam, qcallback) {
		var keyValue = queryparam.split("=");
		console.log("Api2swagger needs details related to param : " + keyValue[0]);
		apiq.queryParamQ(keyValue[0], keyValue[1], function(answers) {
		swaggerSpec.paths[apiPath][pathMethod]["parameters"].push(answers);
		qcallback(null, true);
		});
		}, function done(error, data) {
		callback(null, true);
		});
		}
		else {
		callback(null, true);
		}
		}
		
		
		var getHeaderInfo =  function(swaggerSpec, urlObj, options, callback) {
		// TODO : redundant code, need better way
		var apiPath = urlObj.pathname.replace(swaggerSpec.basePath, "");
		var pathMethod = options.httpMethod.toLowerCase();
		if (apiPath == "") {
		apiPath = "/";
		}
		if (apiPath.charAt(0) != "/") {
		apiPath = "/" + apiPath;
		}
		if (swaggerSpec.paths[apiPath][pathMethod]["parameters"] == null) {
		swaggerSpec.paths[apiPath][pathMethod]["parameters"] = new Array();
		}
		if (options.headers != null && options.headers.length > 0) {
		async.eachSeries(options.headers, function iterator(header, qcallback) {
		var keyValue = header.split(":");
		console.log("Api2swagger needs details related to Header : " + keyValue[0]);
		apiq.headerParamQ(keyValue[0], keyValue[1], function(answers) {
		swaggerSpec.paths[apiPath][pathMethod]["parameters"].push(answers);
		qcallback(null, true);
		});
		}, function done(error, data) {
		callback(null, true);
		});
		}
		else {
		callback(null, true);
		}
		}
		
		var getBodyInfo =  function(swaggerSpec, urlObj, options, callback) {
		// TODO : redundant code, need better way
		var apiPath = urlObj.pathname.replace(swaggerSpec.basePath, "");
		var pathMethod = options.httpMethod.toLowerCase();
		if (apiPath == "") {
		apiPath = "/";
		}
		if (apiPath.charAt(0) != "/") {
		apiPath = "/" + apiPath;
		}
		if (swaggerSpec.paths[apiPath][pathMethod]["parameters"] == null) {
		swaggerSpec.paths[apiPath][pathMethod]["parameters"] = new Array();
		}
		if (options.data != null) {
		console.log("Please provide more details regarding request payload..");
		// json data - Check, Form Data - Check
		if (options.headers.length > 0) {
		var headerKeyValues = {};
		for (var i = 0; i < options.headers.length; i++) {
		var split = options.headers[i].split(':');
		headerKeyValues[split[0].trim()] = split[1].trim();
		}
		if (headerKeyValues['Content-Type'].indexOf('application/json') > -1 || headerKeyValues['content-type'].indexOf('application/json') > -1)  {
		// Found JSON
		var schemaObj = jsonSchemaGenerator(JSON.parse(options.data));
		delete schemaObj.$schema;
		// bug with json scheme generator - work around
		// For more details, https://github.com/krg7880/json-schema-generator/issues/13
		scan(schemaObj);
		// get details
		apiq.bodyJsonQ(schemaObj, function(answers) {
		swaggerSpec.paths[apiPath][pathMethod]["parameters"].push(answers);
		callback(null, true);
		});
		}
		else if (headerKeyValues['Content-Type'] == 'application/x-www-form-urlencoded') {
		if (options.data.split("&").length > 0) {
		var formParams = options.data.split("&");
		async.eachSeries(formParams, function iterator(formParam, qcallback) {
		var keyValue = formParam.split("=");
		console.log("Api2swagger needs details related to form param : " + keyValue[0]);
		apiq.formParamQ(keyValue[0], keyValue[1], function(answers) {
		swaggerSpec.paths[apiPath][pathMethod]["parameters"].push(answers);
		qcallback(null, true);
		});
		}, function done(error, data) {
		callback(null, true);
		});
		}
		else {
		callback(null, true);
		}
		}
		else {
		callback(null, true);
		}
		}
		else {
		apiq.bodyJsonQ(options.data, function(answers) {
		swaggerSpec.paths[apiPath][pathMethod]["parameters"].push(answers);
		callback(null, true);
		});
		}
		}
		else {
		callback(null, true);
		}
		}
		
		var getParamsInfo =  function(swaggerSpec, urlObj, options, callback) {
		// TODO : redundant code, need better way
		var apiPath = urlObj.pathname.replace(swaggerSpec.basePath, "");
		var pathMethod = options.httpMethod.toLowerCase();
		if (apiPath == "") {
		apiPath = "/";
		}
		if (apiPath.charAt(0) != "/") {
		apiPath = "/" + apiPath;
		}
		if (swaggerSpec.paths[apiPath][pathMethod]["parameters"] == null) {
		swaggerSpec.paths[apiPath][pathMethod]["parameters"] = new Array();
		}
		// Ask whether path has any dynamic params
		var isParams = [
		{ name: 'dynamicParams', message: 'API Path has any dynamic parameters ?', type: 'confirm'}
		];
		inquirer.prompt(isParams, function(answers) {
		if (answers.dynamicParams) {
		var pathComponents = urlObj.pathname.split("/");
		var chooseParams = [
		{ name: 'urlParams', message: 'Choose Dynamic Params in URL ?', type: 'checkbox', choices: pathComponents}
		];
		var newApiPath = apiPath;
		inquirer.prompt(chooseParams, function(answers) {
		// Run param info call
		async.eachSeries(answers.urlParams, function iterator(urlParam, qcallback) {
		console.log("Api2swagger needs details related to param : " + urlParam);
		// construct new path too..
		apiq.urlParamQ(urlParam, function(answers) {
		newApiPath = newApiPath.replace(urlParam, "{" + answers.name + "}");
		swaggerSpec.paths[apiPath][pathMethod]["parameters"].push(answers);
		qcallback(null, true);
		});
		}, function done(error, data) {
		// replace apiPath with new one
		if (swaggerSpec.paths[newApiPath] == null) {
		swaggerSpec.paths[newApiPath] = swaggerSpec.paths[apiPath];
		delete swaggerSpec.paths[apiPath];
		}
		else {
		swaggerSpec.paths[newApiPath][pathMethod] = swaggerSpec.paths[apiPath][pathMethod];
		delete swaggerSpec.paths[apiPath];
		}
		callback(null, true);
		});
		});
		}
		else {
		callback(null, true);
		}
		});
		}
		
	#tag EndNote

	#tag Note, Name = readme.md
		https://github.com/anil614sagar/api2swagger
		
		# Web Version
		
		We now have an UI version online, Check http://specgen.apistudio.io/
		
		# api2swagger
		
		Generate Swagger 2.0 (Open API) spec from Curl like API Call.
		
		# Installation
		
		You can install `api2swagger` either through npm or by cloning and linking the code from GitHub.  This document covers the installation details for installing from npm.
		
		## Installation from npm
		
		The `api2swagger` module and its dependencies are designed for Node.js 
		and is available through npm using the following command:
		
		### From a Terminal Window:
		```bash
		$ sudo npm install -g api2swagger
		```
		
		# Options
		| Entry | Explanation |
		| -----------------| ----------------------------------------------------------- |
		| -e, --endpoint   | Rest API Endpoint                                           |
		| -o, --output     | Swagger destination location filename                       |
		| -X, --httpMethod | HTTP Method Name - Allowed HEAD, GET, POST, PUT, DELETE     |
		| -d, --data       | POST / PUT Data                                             |
		| -H, --header     | Request Headers to be included.                             |
		| -P, --proxy      | proxy detail - http://username:password@proxyhost:proxyport |
		
		Notes on options
		
		| Option | Notes                                                                                              |
		| ------ | -------------------------------------------------------------------------------------------------- |
		| data   | Use single-quotes around a JSON string, and on Windows escape the double-quotes within the string  |
		|        | by prepending a / i.e. '{ \"grant_type\" : \"XXYYZZ\" }'                                           |
		| header | Quotes should be used, and multiple headers can be specified by giving multiple -H entries         |
		
		#### Examples
		
		```bash
		$ api2swagger -e "https://accounts.apigee.com/status" -X GET -o /Users/Anil/Desktop/sampleSwagger.json
		```
		
		#### Articles
		
		Getting Started with API2Swagger - Api2Swagger : Open API (Swagger) 2.0 Spec Generator - Command line tool
		https://community.apigee.com/articles/15397/api2swagger-open-api-swagger-20-spec-generator-fro.html
		
	#tag EndNote


	#tag Property, Flags = &h1
		Protected basePathMatch As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0
		bCurrentRequestContainsBody As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0
		bResultColumnsLimited As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected createNew As Boolean = True
	#tag EndProperty

	#tag Property, Flags = &h0
		dStartTime As Double
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected err As String
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected hostMatch As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0
		iBodyCount As Integer = -1
	#tag EndProperty

	#tag Property, Flags = &h0
		JSONValuesForRun As JSONItem_MTC
	#tag EndProperty

	#tag Property, Flags = &h0
		myAPICall As APICall
	#tag EndProperty

	#tag Property, Flags = &h0
		myAPICalls As APICalls
	#tag EndProperty

	#tag Property, Flags = &h0
		myAPIDocs As APICallDocs
	#tag EndProperty

	#tag Property, Flags = &h0
		myAPISocket As APISocket
	#tag EndProperty

	#tag Property, Flags = &h0
		myOptions As JSONItem_MTC
	#tag EndProperty

	#tag Property, Flags = &h0
		myTimer As Xojo.Core.Timer
	#tag EndProperty

	#tag Property, Flags = &h0
		strAllowedHTTPMethods() As String
	#tag EndProperty

	#tag Property, Flags = &h0
		strAPIMethodsAndTestNames() As String
	#tag EndProperty

	#tag Property, Flags = &h0
		strAPIPathAndTestNames() As String
	#tag EndProperty

	#tag Property, Flags = &h0
		strAPITestHTTPMethods() As String
	#tag EndProperty

	#tag Property, Flags = &h0
		strAPIVersion As String
	#tag EndProperty

	#tag Property, Flags = &h0
		strCurrentTestName As String
	#tag EndProperty

	#tag Property, Flags = &h0
		strExecuteBasePath As String
	#tag EndProperty

	#tag Property, Flags = &h0
		strHost As String
	#tag EndProperty

	#tag Property, Flags = &h0
		strHTTPConnectionMethod As String
	#tag EndProperty

	#tag Property, Flags = &h0
		strHTTPMethodOld As String
	#tag EndProperty

	#tag Property, Flags = &h0
		strOutputFileName As String
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected swaggerSpec As JSONItem_MTC
	#tag EndProperty

	#tag Property, Flags = &h0
		testdb As SQLiteDatabase = nil
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected urlObj As URIHelpers.URI
	#tag EndProperty


	#tag Constant, Name = APIHost, Type = String, Dynamic = False, Default = \"lunaapi.ga", Scope = Public
	#tag EndConstant

	#tag Constant, Name = AuthorizationKey, Type = String, Dynamic = False, Default = \"Bearer taWFk8Z4gR8oGoYtG+7Kycm97UswXW8i87T]HnjcNCGQJgi8JD", Scope = Public
	#tag EndConstant

	#tag Constant, Name = strAPIBasePath, Type = String, Dynamic = False, Default = \"/api/", Scope = Public
	#tag EndConstant


	#tag ViewBehavior
		#tag ViewProperty
			Name="bCurrentRequestContainsBody"
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="bResultColumnsLimited"
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="dStartTime"
			Group="Behavior"
			Type="Double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="iBodyCount"
			Group="Behavior"
			InitialValue="-1"
			Type="Integer"
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
			Name="strAPIVersion"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="strCurrentTestName"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="strExecuteBasePath"
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
			Name="strHTTPMethodOld"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="strOutputFileName"
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
End Module
#tag EndModule

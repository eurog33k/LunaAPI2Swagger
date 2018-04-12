#tag Class
Protected Class LunaAPI2Swagger
Inherits Application
	#tag Event
		Sub Open()
		  app.AutoQuit=True
		End Sub
	#tag EndEvent


	#tag Note, Name = api2swagger_MIT_License
		The MIT License
		
		SPDX short identifier: MIT
		
		Copyright 2016 Anil Sagar
		
		Permission is hereby granted, free of charge, to any person obtaining a copy of this software 
		and associated documentation files (the "Software"), to deal in the Software without restriction, 
		including without limitation the rights to use, copy, modify, merge, publish, distribute, 
		sublicense, and/or sell copies of the Software, and to permit persons to whom the Software 
		is furnished to do so, subject to the following conditions:
		
		The above copyright notice and this permission notice shall be included in all copies 
		or substantial portions of the Software.
		
		THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
		INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE 
		AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, 
		DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, 
		OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
		
	#tag EndNote

	#tag Note, Name = api2swagger_package.json
		https://github.com/anil614sagar/api2swagger/blob/master/package.json
		{
		  "name": "api2swagger",
		  "version": "0.1.3",
		  "description": "Generate Swagger 2.0 (Open API) spec from Curl like API Call.",
		  "main": "index.js",
		  "scripts": {
		    "test": "echo \"Error: no test specified\" && exit 1"
		  },
		  "bin": {
		    "api2swagger": "bin/api2swagger"
		  },
		  "repository": {
		    "type": "git",
		    "url": "git+https://github.com/anil614sagar/api2swagger.git"
		  },
		  "keywords": [
		    "Swagger",
		    "Generator",
		    "API",
		    "Runtime"
		  ],
		  "author": "Anil Sagar <anil614sagar@gmail.com> (https://in.linkedin.com/in/anilsagar/)",
		  "license": "MIT",
		  "bugs": {
		    "url": "https://github.com/anil614sagar/api2swagger/issues"
		  },
		  "homepage": "https://github.com/anil614sagar/api2swagger#readme",
		  "dependencies": {
		    "async": "^1.5.0",
		    "commander": "^2.9.0",
		    "http-status": "^0.2.0",
		    "inquirer": "^0.11.0",
		    "json-schema-generator": "^2.0.3",
		    "request": "^2.67.0"
		  }
		}
	#tag EndNote

	#tag Note, Name = json-schema-generator_License
		The MIT License (MIT)
		
		Copyright (c) 2014 krg7880
		
		Permission is hereby granted, free of charge, to any person obtaining a copy
		of this software and associated documentation files (the "Software"), to deal
		in the Software without restriction, including without limitation the rights
		to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
		copies of the Software, and to permit persons to whom the Software is
		furnished to do so, subject to the following conditions:
		
		The above copyright notice and this permission notice shall be included in all
		copies or substantial portions of the Software.
		
		THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
		IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
		FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
		AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
		LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
		OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
		SOFTWARE.
		
	#tag EndNote

	#tag Note, Name = JSONITEM_MTC_License
		License
		
		This class was created by Kem Tekinay, MacTechnologies Consulting (ktekinay@mactechnologies dot com). 
		It is copyright ©2016 by Kem Tekinay, all rights reserved.
		
		This project is distributed AS-IS and no warranty of fitness for any particular purpose is expressed or implied. 
		The author disavows any responsibility for bad design, poor execution, or any other faults.
		
		You may freely use or modify this project or any part within. 
		You may distribute a modified version as long as this notice or any other legal notice is left undisturbed 
		and all modifications are clearly documented and accredited. 
		The author does not actively support this class, although comments and recommendations are welcome.
	#tag EndNote

	#tag Note, Name = LunaAPI2Swagger
		Generate Swagger 2.0 (Open API) spec from your Xojo Program
		------------------------------------------------------------
		
		
		
		Based on api2swagger (https://github.com/anil614sagar/api2swagger)
		------------------------------------------------------------------
		
		The original API2Swagger source code this was based on can be found in relevant notes for the following modules/classes
		
		Xojo Folder     | Xojo Section       |  api2swagger folder | api2swagger source code note
		-----------------------------------------------------------------------
		api2swagger/lib | module errorCodes  | lib/errorCodes      | command.js
		api2swagger/lib | module execute     | lib/execute         | api.js
		api2swagger/lib | module questions   | lib/questions       | aboutq.js
		api2swagger/lib | module questions   | lib/questions       | apiq.js
		api2swagger/lib | module util        | lib/util            | cli.js
		api2swagger/bin | module bin         | bin                 | api2swagger
		
		
		
		JSONItem_MTC (https://github.com/ktekinay/JSONItem_MTC)
		-------------------------------------------------------------
		This is a drop-in replacements for the native JSONItem. It emulates all its features but should perform certain functions faster.
		
		RB-URI (https://github.com/charonn0/RB-URI)
		-------------------------------------------
		This project implements a set of REALstudio object classes which together allow for easy manipulation of URIs. 
		Strictly speaking, only the URL subset of the URI specification is supported. Other subsets like URNs are not supported.
		Used here for parsing of the URLs
		
		Uses the following Node modules:
		-------------------------------
		
		node-http-status (https://github.com/adaltas/node-http-status) 
		--------------------------------------------------------------------
		(Required by api2swagger, see api2swagger/lib/execute/api.js note)
		We're only using their Status Codes which are located in Node_Modules/node-http-status/nodehttpstatus.jHTTPStatus
		A HTTP Status Code is translated to a description (or reverse) with the nodehttpstatus.HTTPStatusDescription function
		
		json-schema-generator (https://github.com/krg7880/json-schema-generator)
		------------------------------------------------------------------------------
		(Required by api2swagger, see api2swagger/lib/execute/api.js note)
		The jsonToSchema function is located in Node_Modules/json-schema-generator/jsonschemagenerator
		The original json-schema-generator source code this was based on can be found in relevant notes for the following modules/classes
		
		Xojo Folder               | Xojo Section                 |  json-schema-generator folder | api2swagger source code note
		-----------------------------------------------------------------------------------------------------------------------
		json-schema-generator/lib | class AST                    | lib                           | ast.js
		json-schema-generator/lib | class jscompiler             | lib                           | compiler.js
		json-schema-generator/lib | module utils                 | lib                           | utils.js
		json-schema-generator     | module jsonschemagenerator   | lib                           | index.js
		
	#tag EndNote

	#tag Note, Name = node-http-status-license
		https://github.com/adaltas/node-http-status
		
		adaltas/node-http-status is licensed under the
		BSD 3-clause "New" or "Revised" License
		
		A permissive license similar to the BSD 2-Clause License, but with a 3rd clause
		that prohibits others from using the name of the project or its contributors to 
		promote derived products without written consent.
		
		Permissions
		
		Commercial use
		Modification
		Distribution
		Private use
		
		Conditions
		License and copyright notice
		
		Limitations
		
		Liability
		Warranty
		
		Software License Agreement (BSD License)
		========================================
		Copyright (c) 2008-2010, SARL Adaltas.
		
		All rights reserved.
		
		Redistribution and use of this software in source and binary forms, with or
		without modification, are permitted provided that the following conditions are
		met:
		
		-   Redistributions of source code must retain the above copyright notice, this
		list of conditions and the following disclaimer.
		
		-   Redistributions in binary form must reproduce the above copyright notice,
		this list of conditions and the following disclaimer in the documentation and/or
		other materials provided with the distribution.
		
		-   Neither the name of SARL Adaltas nor the names of its contributors may be
		used to endorse or promote products derived from this software without specific
		prior written permission of the SARL Adaltas.
		
		THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
		ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
		WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
		DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
		ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
		(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
		LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
		ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
		(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
		SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
		
	#tag EndNote

	#tag Note, Name = RB-URI License
		
		
		The MIT License (MIT)
		
		Copyright (c) 2016 Andrew Lambert
		
		Permission is hereby granted, free of charge, to any person obtaining a copy of
		this software and associated documentation files (the "Software"), to deal in
		the Software without restriction, including without limitation the rights to
		use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
		the Software, and to permit persons to whom the Software is furnished to do so,
		subject to the following conditions:
		
		The above copyright notice and this permission notice shall be included in all
		copies or substantial portions of the Software.
		
		THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
		IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
		FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
		COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
		IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
		CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
		
		
	#tag EndNote


	#tag Constant, Name = kEditClear, Type = String, Dynamic = False, Default = \"&Delete", Scope = Public
		#Tag Instance, Platform = Windows, Language = Default, Definition  = \"&Delete"
		#Tag Instance, Platform = Linux, Language = Default, Definition  = \"&Delete"
	#tag EndConstant

	#tag Constant, Name = kFileQuit, Type = String, Dynamic = False, Default = \"&Quit", Scope = Public
		#Tag Instance, Platform = Windows, Language = Default, Definition  = \"E&xit"
	#tag EndConstant

	#tag Constant, Name = kFileQuitShortcut, Type = String, Dynamic = False, Default = \"", Scope = Public
		#Tag Instance, Platform = Mac OS, Language = Default, Definition  = \"Cmd+Q"
		#Tag Instance, Platform = Linux, Language = Default, Definition  = \"Ctrl+Q"
	#tag EndConstant


	#tag ViewBehavior
	#tag EndViewBehavior
End Class
#tag EndClass

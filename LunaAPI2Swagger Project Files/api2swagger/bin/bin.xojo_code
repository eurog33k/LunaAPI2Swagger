#tag Module
Protected Module bin
	#tag Note, Name = api2swagger
		#!/usr/bin/env node
		'use strict';
		
		var program = require('commander');
		var version = require('../lib/util/cli').version();
		var executeApi = require('../lib/execute/api.js');
		
		program
		  .version(version);
		
		program
		  .usage('<options>')
		  .option('-e, --endpoint <endpoint>', 'Rest API Endpoint')
		  .option('-o, --output <file>', 'Swagger destination location filename')
		  .option('-X, --httpMethod <httpMethod>', 'HTTP Method Name - Allowed HEAD, GET, POST, PUT, DELETE')
		  .option('-d, --data <data>', 'POST / PUT Data')
		  .option('-H, --header <header>', 'Request Headers', collect, [])
		  .option('-P, --proxy <proxy>','proxy detail - http://username:password@proxyhost:proxyport')
		  .description('Generates Swagger 2.0 Spec from an API Call');
		
		program.on('--help', function(){
		  console.log('  Examples:');
		  console.log('');
		  console.log('    $ swaggergen --help');
		  console.log('    $ swaggergen -e http://example.com/returnSomething');
		  console.log('');
		});
		
		program.parse(process.argv);
		
		var options = {};
		options.endpoint = program.endpoint;
		options.httpMethod = program.httpMethod;
		options.output = program.output;
		options.data = program.data;
		options.headers = program.header;
		options.proxy = program.proxy;
		
		
		
		
		executeApi.processRequest(options, function(err, reply) {
		  if(err) {
		    console.log(reply);
		  }
		  else {
		    //nothing for now..
		  }
		});
		
		
		function collect(val, headers) {
		  headers.push(val);
		  return headers;
		}
	#tag EndNote


	#tag ViewBehavior
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
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

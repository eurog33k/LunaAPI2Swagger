#tag Module
Protected Module jsonschemagenerator
	#tag Method, Flags = &h0
		Function jsonToSchema(jJSON As JSONItem_MTC) As JSONItem_MTC
		  Dim MyJsCompiler As New jsCompiler
		  Dim myAST As New AST
		  myAST.Build(jJSON)
		  MyJsCompiler.compile(myAST.Tree)
		  Return MyJsCompiler.schema
		  
		  
		End Function
	#tag EndMethod


	#tag Note, Name = index.js
		https://github.com/krg7880/json-schema-generator/blob/master/lib/index.js
		
		'use strict';
		
		var Compiler = require('./compiler');
		var AST = require('./ast.js');
		var utils = require('./utils');
		
		var jsonToSchema = function(json) {
		  var compiler = new Compiler();
		  var ast = new AST();
		  ast.build(json);
		  compiler.compile(ast.tree);
		  return compiler.schema;
		};
		
		module.exports = jsonToSchema;
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
End Module
#tag EndModule

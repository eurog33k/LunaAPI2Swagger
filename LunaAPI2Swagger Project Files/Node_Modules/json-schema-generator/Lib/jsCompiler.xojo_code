#tag Class
Protected Class jsCompiler
	#tag Method, Flags = &h0
		Sub compile(tree As JSONItem_MTC)
		  Dim jEmptyProperties As New JSONItem_MTC("{}")
		  Dim jEmptyRequired As New JSONItem_MTC("[]")
		  if tree.value("type").StringValue="object" Then
		    schema.Value("$schema")="http://json-schema.org/draft-04/schema#"
		    schema.Value("description")= ""
		    schema.value("type") = "object"
		    schema.Value("properties")=jEmptyProperties
		    schema.Value("required")=jEmptyRequired
		    generate(tree,schema.Child("properties"),schema)
		  else
		    schema.value("type") = "array"
		    schema.Value("$schema") = "http://json-schema.org/draft-04/schema#"
		    schema.Value("description") = ""
		    schema.Value("minItems") = 1
		    schema.Value("uniqueItems") = true
		    Dim jItems As New JSONItem_MTC
		    jItems.Value("type") = "object"
		    jItems.Value("required") = jEmptyRequired
		    jItems.Value("properties") = jEmptyProperties
		    schema.Value("items") = jItems
		    generate(tree,schema.Child("items").Child("properties"),schema.Child("items"))
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor()
		  schema = New JSONItem_MTC("{}")
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub generate(tree As JSONItem_MTC, schema As JSONItem_MTC, parent As JSONItem_MTC)
		  Dim names() As String=tree.Child("children").Names
		  for j As Integer=0 to names.Ubound
		    
		    Dim i As String=names(j)
		    Dim bChildIsaJSONItem As Boolean=tree.Child("children").isJSONItem(i)
		    Dim child As JSONItem_MTC
		    
		    if bChildIsaJSONItem Then
		      child=tree.Child("children").Child(i)
		    end if
		    
		    if bChildIsaJSONItem and child.Value("type") = "object" Then
		      
		      If parent.HasName("required") and parent.IsJSONItem("required") and parent.Child("required").IsArray Then
		        parent.Child("required").Append i
		      end if
		      
		      schema.Value(i)=new JSONItem_MTC("{""type"": ""object"",""properties"": {},""required"": []}")
		      generate(child, schema.Child(i).Child("properties"), schema.Child(i)) 
		      
		    elseif bChildIsaJSONItem and child.Value("type") = "array" Then
		      
		      If parent.HasName("required") and parent.IsJSONItem("required") and parent.Child("required").IsArray Then
		        parent.Child("required").Append i
		      end if
		      Dim strSchemaValuei As String=    "{""type"": ""array"",""uniqueItems"": " + child.Value("uniqueItems").StringValue.Lowercase + _
		      ",""minItems"": " + child.Value("minItems").StringValue + ",""items"": {""required"":[],""properties"": {}}}"
		      schema.Value(i)=new JSONItem_MTC(strSchemaValuei)
		      generate(child, schema.Child(i).Child("items").Child("properties"), schema.child(i))
		      
		    else
		      
		      schema.Value(i)=new JSONItem_MTC("{}")
		      if Child.HasName("type") then
		        schema.Child(i).Value("type") = child.Value("type")
		      end if
		      
		      if child.HasName("minLength") and child.Value("minLength").IntegerValue>0 then
		        schema.Child(i).Value("minLength") = child.Value("minLength")
		      end if
		      
		      if child.HasName("required") then
		        if parent.HasName("items") and parent.child("items").HasName("required") and parent.child("items").Child("required").IsArray Then
		          parent.Child("items").Child("required").Append i
		        else
		          parent.child("required").Append i
		        end if
		      end if
		    end if
		  next
		  
		End Sub
	#tag EndMethod


	#tag Note, Name = compiler.js
		
		'use strict';
		
		var utils = require('./utils');
		
		/**
		Schema generator using a AST
		tree.
		
		@class Compiler
		*/
		var Compiler = function() {
		  if (!this instanceof Compiler) {
		    return new Compiler();
		  }
		
		  this.schema = {};
		};
		
		/**
		Generates a JSON schema based on the provided AST tree.
		
		@method generate
		@param {Object} tree AST
		@param {Object} schema The schema object
		@param {Object} parent Schema node parent object
		@return void
		*/
		Compiler.prototype.generate = function(tree, schema, parent) {
		  for (var i in tree.children) {
		    var child = tree.children[i];
		    if (child.type === 'object') {
		      if (utils.isArray(parent.required)) {
		        parent.required.push(i);
		      }
		      schema[i] = {
		        type: 'object'
		        ,properties: {}
		        ,required: []
		      };
		      this.generate(child, schema[i].properties, schema[i]);
		    } else if (child.type === 'array') {
		      if (utils.isArray(parent.required)) {
		        parent.required.push(i);
		      }
		      schema[i] = {
		        type: 'array'
		        ,uniqueItems: child.uniqueItems
		        ,minItems: child.minItems
		        ,items: {
		          required:[]
		          ,properties: {}
		        }
		      }
		      this.generate(child, schema[i].items.properties, schema[i]);
		    } else {
		      schema[i] = {};
		      if (child.type) {
		        schema[i].type = child.type;
		      }
		
		      if (child.minLength) { 
		        schema[i].minLength = child.minLength;
		      }
		
		      if (child.required) {
		        if (parent.items && utils.isArray(parent.items.required)) {
		          parent.items.required.push(i);
		        } else {
		          parent.required.push(i);
		        }
		      }
		    }
		  }
		};
		
		/**
		Initates compiling the given AST into a
		JSON schema.
		
		@method compile
		@param {Object} tree AST object
		@return void
		*/
		Compiler.prototype.compile = function(tree) {
		  if (tree.type === 'object') {
		   this.schema = {
		    '$schema': 'http://json-schema.org/draft-04/schema#'
		    ,description: ''
		    ,type: 'object'
		    ,properties: {}
		    ,required: []
		   };
		   this.generate(tree, this.schema.properties, this.schema);
		  } else {
		    this.schema = {
		      type: 'array'
		      ,'$schema': 'http://json-schema.org/draft-04/schema#'
		      ,'description': ''
		      ,minItems: 1
		      ,uniqueItems: true
		      ,items: {
		        type: 'object'
		        ,required: []
		        ,properties: {}
		      }
		    };
		
		    this.generate(tree, this.schema.items.properties, this.schema.items);
		  }
		};
		
		module.exports = Compiler;
	#tag EndNote


	#tag Property, Flags = &h0
		schema As JSONItem_MTC
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
	#tag EndViewBehavior
End Class
#tag EndClass

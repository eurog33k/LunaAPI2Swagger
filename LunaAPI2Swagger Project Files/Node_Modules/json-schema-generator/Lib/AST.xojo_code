#tag Class
Protected Class AST
	#tag Method, Flags = &h0
		Sub Build(myJSONItem_MTC As JSONItem_MTC)
		  if myJSONItem_MTC.IsArray Then
		    BuildArrayTree(Tree,myJSONItem_MTC)
		  Else
		    BuildObjectTree(Tree,myJSONItem_MTC)
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub BuildArrayTree(tree AS JSONItem_MTC, node As JSONItem_MTC)
		  tree.Value("type") = "array"
		  Dim jEmptyObject As New JSONItem_MTC("{}")
		  tree.Value("children")=jEmptyObject
		  Dim bChildIsaJSONItem As Boolean=node.isJSONItem(0)
		  If bChildIsaJSONItem=True Then
		    Dim first As JSONItem_MTC=node.Value(0)
		    If first.IsObject Then
		      Dim similar As JSONItem_MTC=isAllSimilarObjects(node)
		      If similar<>Nil Then
		        tree.Value("uniqueItems")=True
		        tree.Value("minItems")=1
		        BuildObjectTree(tree,similar.Child("selected"))
		        Exit Sub
		      End If
		      Exit Sub
		    End If
		    
		    For i As Integer=0 To node.Count-1
		      If node.Child(i).IsObject Then
		        tree.Child("children").Value(node.Name(i))=New JSONItem("{}")
		        tree.Child("children").Child(node.Name(i)).Value("type") = "object"
		        Dim keys() As String = node.Child(i).Names
		        If keys.Ubound > -1 Then
		          tree.Child("children").Child(node.Name(i)).Value("required") = True
		        End If
		        BuildObjectTree(tree.Child("children").Child(node.Name(i)), node.child(node.name(i)))
		      Elseif node.Child(i).IsArray Then
		        tree.Child("children").Value(node.Name(i))=New JSONItem("{}")
		        tree.Child("children").Child(node.Name(i)).Value("type") = "array"
		        tree.Child("children").Child(node.Name(i)).Value("uniqueItems") = True
		        If node.Child(i).Count>0 Then
		          tree.Child("children").Child(node.Name(i)).Value("required") = True
		        End If
		        BuildArrayTree(tree.Child("children").Child(node.Name(i)), node.child(node.name(i)))
		      Else
		        If tree.Value("type") = "object" Then
		          tree.Child("children").Value(node.Name(i))=New JSONItem("{}")
		          BuildPrimitive(tree.Child("children").Child(node.Name(i)), node.child(node.name(i)))
		        End If
		      End If
		    Next
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub BuildObjectTree(tree AS JSONItem_MTC, node As JSONItem_MTC)
		  if tree.HasName("type")=False Then
		    tree.Value("type") = "object"
		  end if
		  if tree.HasName("children")=False Then
		    tree.Value("children")=New JSONItem_MTC("{}")
		  end if
		  Dim Names() As String=node.Names
		  
		  For i As Integer=0 To Names.Ubound
		    
		    Dim bChildIsaJSONItem As Boolean=node.isJSONItem(names(i))
		    
		    if bChildIsaJSONItem and node.Child(names(i)).IsObject Then
		      tree.Child("children").Value(Names(i))=New JSONItem_MTC("{}")
		      BuildObjectTree(tree.Child("children").Child(names(i)), node.Child(names(i)))
		    ElseIf bChildIsaJSONItem and node.Child(names(i)).IsArray Then
		      tree.Child("children").Value(Names(i))=New JSONItem_MTC("{}")
		      BuildArrayTree(tree.Child("children").Child(Names(i)), node.Child(names(i)))
		    Else
		      tree.Child("children").Value(Names(i))=New JSONItem_MTC("{}")
		      BuildPrimitive(tree.Child("children").Child(Names(i)), node.Value(names(i)))
		    end if
		  Next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub BuildPrimitive(tree AS JSONItem_MTC, node As Variant)
		  Dim nodetype As String
		  nodetype=GetType(node)
		  tree.Value("type")=nodetype
		  if nodetype="string" Then
		    if node.StringValue.Len > 0 Then
		      tree.Value("minLength") = 1
		    else
		      tree.Value("minLength") = 0
		    end if
		  end if
		  //if (node !== null && typeof node !== 'undefined') {
		  //noce always defined in xojo, you can't have an undefined calling
		  if nodetype<>"null" Then
		    tree.Value("required")=True
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor()
		  Tree=New JSONItem_MTC("{}")
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function generateHash(myvalue As Variant) As String
		  Dim bVarIsJSONItem_MTC As Boolean=True
		  Dim jValue As JSONItem_MTC
		  Try
		    jValue=myvalue //geeft IllegalCastException wegens geen JSONItem
		  Catch err As RuntimeException
		    bVarIsJSONItem_MTC=False
		  End Try
		  
		  if bVarIsJSONItem_MTC=True Then
		    If jValue.IsObject Then
		      Dim keys() As String = jValue.Names
		      Dim jKeys As New JSONItem_MTC
		      For i As Integer = 0 to keys.Ubound
		        jKeys.Append keys(i)
		      Next
		      Dim strKeys As String=jKeys.ToString
		      Dim strHash As String=Crypto.Hash(strKeys,Crypto.Algorithm.MD5)
		      Return EncodeHex(strHash, False)
		    elseif jValue.IsArray Then
		      Dim strHash As String=Crypto.Hash(jValue.ToString, Crypto.Algorithm.MD5)
		      Return EncodeHex(strHash, False)
		    end if
		  Else
		    Dim strHash As String=Crypto.Hash(myvalue.StringValue, Crypto.Algorithm.MD5)
		    Return EncodeHex(strHash, False)
		  end if
		  Return ""
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function isAllSimilarObjects(myJSONItem_MTC As JSONItem_MTC) As JSONItem_MTC
		  Dim hashes As New JSONItem_MTC //array in the original?
		  Dim max As Integer
		  Dim selected As JSONItem_MTC
		  for i As Integer=0 to myJSONItem_MTC.Count-1
		    Dim hash As String
		    hash=generateHash(myJSONItem_MTC.Value(i))
		    hashes.Value(hash)=True
		    Dim jChild As JSONItem_MTC=myJSONItem_MTC.Child(i)
		    Dim keys() As String = jChild.Names
		    if keys.Ubound+1 > max Then
		      max=keys.Ubound+1
		      selected=myJSONItem_MTC.Value(i)
		    end if
		  next
		  Dim jReturn As New JSONItem_MTC
		  jReturn.Value("same")=(hashes.Count=1)
		  jReturn.Value("selected")=selected
		  Return jReturn
		End Function
	#tag EndMethod


	#tag Note, Name = ast.js
		
		'use strict';
		
		/**
		Generates an Abstract Syntax Tree
		used for generating the schema.
		
		@see: https://en.wikipedia.org/wiki/Abstract_syntax_tree
		*/
		var utils = require('./utils');
		var crypto = require('crypto');
		
		/**
		Abstract Syntax Tree Class
		
		@class AST
		@return {Object}
		*/
		var AST = function() {
		  if (!this instanceof AST) {
		    return new AST();
		  }
		
		  this.tree = {};
		};
		
		/**
		Computes the hex hash of the given value
		
		@method generateHash
		@param {Mixed} value Value to hash
		@return {String} HEX value.
		*/
		AST.prototype.generateHash = function(value) {
		 if (utils.isObject(value)) {
		    var keys = Object.keys(value);
		    return crypto.createHash("md5").update(JSON.stringify(keys)).digest("hex");
		  } else if (utils.isArray(value)) {
		    return crypto.createHash("md5").update(JSON.stringify(value)).digest("hex");
		  } else {
		    return crypto.createHash("md5").update(value).digest("hex");
		  }
		};
		
		/**
		Checks if the elements in the given node are all
		equal. 
		
		@method isAllSimilarObject
		@param {Object} node JSON node to inspect
		@return {Object}
		*/
		AST.prototype.isAllSimilarObjects = function(node) {
		  var hashes = [];
		  var max = 0;
		  var selected = null;
		  for (var i in node) {
		    var hash = this.generateHash(node[i]);
		    hashes[hash] = true;
		    var keys = Object.keys(node[i]);
		    if (!max || keys.length > max) {
		      max = keys.length;
		      selected = node[i];
		    }
		  }
		
		  return {same: (hashes.length === 1), selected: selected};
		}
		
		/**
		Inspect primitatives and apply the correct type
		and mark as required if the element contains a value.
		
		@method buildPrimitive
		@param {Object} tree Schema which represents the node
		@param {Node} node The JSON node being inspected
		@return void
		*/
		AST.prototype.buildPrimitive = function(tree, node) {
		  tree.type = utils.getType(node);
		  if (tree.type === 'string') {
		    tree.minLength = (node.length > 0) ? 1 : 0;
		  } 
		
		  if (node !== null && typeof node !== 'undefined') {
		    tree.required = true;
		  }
		}
		
		/**
		Inspect object properties and apply the correct
		type and mark as required if the element has set 
		properties.
		
		@method buildObject
		@param {Object} tree Schema which represents the node
		@param {Node} node The JSON node being inspected
		*/
		AST.prototype.buildObjectTree = function(tree, node) {
		  tree.type = tree.type || 'object';
		  tree.children = tree.children || {};
		  for (var i in node) {
		    if (utils.isObject(node[i])) {
		      tree.children[i] = {};
		      this.buildObjectTree(tree.children[i], node[i]);
		      continue;
		    } else if (utils.isArray(node[i])) {
		      tree.children[i] = {};
		      this.buildArrayTree(tree.children[i], node[i]);
		    } else {
		      tree.children[i] = {};
		      this.buildPrimitive(tree.children[i], node[i]);
		    } 
		  }
		};
		
		/**
		Inspect array elements apply the correct
		type and mark as required if the element has 
		set properties.
		
		@method buildObject
		@param {Object} tree Schema which represents the node
		@param {Node} node The JSON node being inspected
		*/
		AST.prototype.buildArrayTree = function(tree, node) {
		  tree.type = 'array';
		  tree.children = {};
		  var first = node[0];
		  if (utils.isObject(first)) {
		    var similar = this.isAllSimilarObjects(node);
		    if (this.isAllSimilarObjects(node)) {
		      tree.uniqueItems = true;
		      tree.minItems = 1;
		
		      return this.buildObjectTree(tree, similar.selected);
		    }
		  };
		
		  for (var i=0; i<node.length; i++) {
		    if (utils.isObject(node[i])) {
		      tree.children[i] = {};
		      tree.children[i].type = 'object';
		      var keys = Object.keys(node[i]);
		      if (keys.length > 0) {
		        tree.children[i].required = true;
		      }
		      this.buildObjectTree(tree.children[i], node[i]);
		    } else if (utils.isArray(node[i])) {
		      tree.children[i] = {};
		      tree.children[i].type = 'array';
		      tree.children[i].uniqueItems = true;
		      if (node[i].length > 0) {
		        tree.children[i].required = true;
		      }
		      this.buildArrayTree(tree.children[i], node[i]);
		    } else {
		      if (tree.type === 'object') {
		        tree.children[i] = {};
		        this.buildPrimitive(tree.children[i], node[i]);
		      }
		    }
		  }
		};
		
		/**
		Initiates generating the AST from the 
		given JSON document.
		
		@param {Object} json JSON object
		@return void
		*/
		AST.prototype.build = function(json) {
		  if (json instanceof Array) {
		    this.buildArrayTree(this.tree, json);
		  } else {
		    this.buildObjectTree(this.tree, json);
		  }
		};
		
		module.exports = AST;
		
	#tag EndNote


	#tag Property, Flags = &h0
		Tree As JSONItem_MTC
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

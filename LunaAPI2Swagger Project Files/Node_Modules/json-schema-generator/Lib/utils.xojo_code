#tag Module
Protected Module utils
	#tag Method, Flags = &h0
		Function GetType(myVar As Variant) As String
		  Dim bMyVarIsJSONItem As Boolean=False
		  if myVar Isa JSONItem_MTC Then
		    bMyVarIsJSONItem=True
		  end if
		  if bMyVarIsJSONItem and JSONItem_MTC(myVar).IsObject Then
		    Return "object"
		  ElseIf bMyVarIsJSONItem and JSONItem_MTC(myVar).IsArray Then
		    Return "array"
		  ElseIf myVar=nil Then
		    Return "null"
		  Elseif VarType(myVar)=11 then //isboolean
		    Return "boolean"
		  Elseif VarType(myVar)=8 or VarType(myVar)=37 then //String, Text
		    Return "string"
		  ElseIf IsNumeric(myVar) Then //isnumber
		    Return "number"
		  end if
		  Return ""
		End Function
	#tag EndMethod


	#tag Note, Name = utils.js
		
		'use strict';
		
		exports.isObject = function(value) {
		  return (null !== value && typeof value === typeof {} && !exports.isArray(value));
		};
		
		exports.isNumber = function(value) {
		  return !exports.isArray( value ) && (value - parseFloat( value ) + 1) >= 0;
		};
		
		exports.isArray = function(value) {
		  return (value instanceof Array);
		};
		
		exports.isString = function(value) {
		  return (typeof value === typeof '');
		};
		
		exports.isNull = function(value) {
		  return (null === value);
		};
		
		exports.isBoolean = function(value) {
		  return (value === true || value === false);
		};
		
		exports.toObject = function(arr) {
		  var rv = {};
		  for (var i = 0; i < arr.length; ++i)
		    rv[i] = arr[i];
		  return rv;
		};
		
		exports.oneIsNull = function(v1, v2) {
		  return ((v1 === null && v2 !== null) || (v1 !== null && v2 === null));
		};
		
		exports.isUndefined = function(val) {
		  return (null === val || typeof val === 'undefined');
		};
		
		exports.isFunction = function(fn) {
		  return (typeof fn === 'function');
		};
		
		exports.isEqual = function(v1, v2) {
		  if (typeof v1 !== typeof v2 || exports.oneIsNull(v1, v2)) {
		    return false;
		  }
		
		  if (typeof v1 === typeof "" || typeof v1 === typeof 0) {
		    return v1 === v2;
		  }
		
		  var _isEqual = true;
		
		  if (typeof v1 === typeof {}) {
		    var compare = function(value1, value2) {
		      for (var i in value1) {
		        if (!value2.hasOwnProperty(i)) {
		          _isEqual = false;
		          break;
		        }
		
		        if (exports.isObject(value1[i])) {
		          compare(value1[i], value2[i]);
		        } else if (typeof value1[i] === typeof "") {
		          if (value1[i] !== value2[i]) {
		            _isEqual = false;
		            break;
		          }
		        }
		      }
		    }
		
		    compare(v1, v2);
		  }
		
		  return _isEqual;
		};
		
		exports.getType = function(data) {
		  if (exports.isObject(data)) {
		    return 'object';
		  } else if (exports.isArray(data)) {
		    return 'array';
		  } else if (exports.isNull(data)) {
		    return null;
		  } else if (exports.isBoolean(data)) {
		    return 'boolean';
		  } else if (exports.isString(data)) {
		    return 'string';
		  } else if (exports.isNumber(data)) {
		    return 'number';
		  }
		};
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

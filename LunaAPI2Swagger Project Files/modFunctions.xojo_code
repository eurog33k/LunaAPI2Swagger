#tag Module
Protected Module modFunctions
	#tag Method, Flags = &h0
		Sub APIParametersToJSONItemArray(MyAPIParameters As JSONItem_MTC, targetJSONItem As JSONItem_MTC, Optional MyAPIParameterValues As JSONItem_MTC)
		  Dim tmpJSONItem As JSONItem_MTC
		  //go through all the JSONItems in the array
		  for iRow As Integer=0 to MyAPIParameters.Count-1
		    //get the current JSONItem out of the Object
		    Dim strName As String=MyAPIParameters.Name(iRow)
		    Dim jProperties As JSONItem_MTC=MyAPIParameters.Value(strName)
		    Dim bAPIParametersHasFieldValue As Boolean=jProperties.HasName("value")
		    //find the value
		    If bAPIParametersHasFieldValue=True Then
		      //there is a value
		      //if so, add it to the JSONItem_MTC
		      tmpJSONItem=new JSONItem_MTC
		      tmpJSONItem.Value(strName)=jProperties.Value("value").StringValue
		      targetJSONItem.Append tmpJSONItem
		    Elseif bAPIParametersHasFieldValue=False and MyAPIParameterValues<>nil Then
		      //if the apiparameters don't contain a value but there is a MyAPIParameterValues jsonitem
		      //check if the MyAPIParameterValues contains a value for the current field
		      if MyAPIParameterValues.HasName(strName) Then
		        //if so, add it to the JSONItem_MTC
		        tmpJSONItem=new JSONItem_MTC
		        tmpJSONItem.Value(strName)=MyAPIParameterValues.Value(strName).StringValue
		        targetJSONItem.Append tmpJSONItem
		      elseif strName="" Then
		        tmpJSONItem=new JSONItem_MTC
		        tmpJSONItem.Value("")=MyAPIParameterValues.ToString
		        targetJSONItem.Append tmpJSONItem
		      end if
		    end if
		  next
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub APIParametersToJSONItemObject(MyAPIParameters As JSONItem_MTC, targetJSONItem As JSONItem_MTC, Optional MyAPIParameterValues As JSONItem_MTC)
		  //go through all the JSONItems in the array
		  for iRow As Integer=0 to MyAPIParameters.Count-1
		    //get the current JSONItem out of the Object
		    Dim strName As String=MyAPIParameters.Name(iRow)
		    Dim jProperties As JSONItem_MTC=MyAPIParameters.Value(strName)
		    Dim bAPIParametersHasFieldValue As Boolean=jProperties.HasName("value")
		    //find the value
		    If bAPIParametersHasFieldValue=True Then
		      //there is a value
		      //if so, add it to the JSONItem_MTC
		      targetJSONItem.Value(strName)=jProperties.Value("value").StringValue
		    Elseif bAPIParametersHasFieldValue=False and MyAPIParameterValues<>nil Then
		      //if the apiparameters don't contain a value but there is a MyAPIParameterValues jsonitem
		      //check if the MyAPIParameterValues contains a value for the current field
		      if MyAPIParameterValues.HasName(strName) Then
		        //if so, add it to the JSONItem_MTC
		        targetJSONItem.Value(strName)=MyAPIParameterValues.Value(strName).StringValue
		      end if
		    end if
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub APIParametersToListBox(MyAPIParameters As JSONItem_MTC, targetListbox As Listbox, Optional MyAPIParameterValues As JSONItem_MTC)
		  Dim iColumnNumber As Integer=3 //start at 2, since 0, 1 and 2 are occupied by name, required and used
		  Dim bListBoxInitialised As Boolean=False
		  Dim DicColumns As New Dictionary
		  'targetListbox.DeleteAllRows
		  //go through all the JSONItems in the array
		  for iRow As Integer=0 to MyAPIParameters.Count-1
		    //get the current JSONItem out of the Object
		    Dim strName As String=MyAPIParameters.Name(iRow)
		    Dim jProperties As JSONItem_MTC=MyAPIParameters.Value(strName)
		    //create a row
		    targetListbox.AddRow strName
		    Dim bAPIParametersHasFieldValue As Boolean
		    Dim bNewRowValueHandled As Boolean=False
		    If jProperties.HasName("required")=False Then
		      Break
		      //this is a required field :) We have to know whether it is required or not
		      exit Sub
		    End If
		    Dim bRequired As Boolean=jProperties.Value("required").BooleanValue
		    //run through the columns
		    For i As Integer=0 to jProperties.Count-1
		      //get the current column name
		      Dim strColumnName As String=jProperties.Name(i)
		      if iRow=0 Then
		        //if we are on the first JSONItem, initialise the listbox
		        if bListBoxInitialised=False Then
		          targetListbox.HasHeading=True
		          //check if the api parameters contains a field called value
		          bAPIParametersHasFieldValue=jProperties.HasName("value")
		          //set the listbox to the required amount of colums
		          if bAPIParametersHasFieldValue=True Then
		            targetListbox.ColumnCount=jProperties.Count+2 //extra columns for name and used
		          else
		            targetListbox.ColumnCount=jProperties.Count+3 //extra columns for name, used and value
		          end if
		          //Set the static column headers that must be there and
		          //keep track of the column name and corresponding column number in a Dictionary
		          //column 0=Name, String
		          targetListbox.Heading(0)="name"
		          DicColumns.Value("name")=0
		          //column 1=required, Boolean
		          targetListbox.Heading(1)="required"
		          targetListbox.ColumnType(1)=Listbox.TypeCheckbox
		          DicColumns.Value("required")=1
		          //column 2=used, Boolean
		          targetListbox.Heading(2)="used"
		          targetListbox.ColumnType(2)=Listbox.TypeCheckbox
		          DicColumns.Value("used")=2
		          //if the api does not contain a value field, add it here as the last column
		          if bAPIParametersHasFieldValue=False Then
		            targetListbox.Heading(targetListbox.ColumnCount-1)="value"
		            targetListbox.ColumnType(targetListbox.ColumnCount-1)=Listbox.TypeEditableTextField
		            DicColumns.Value("value")=targetListbox.ColumnCount-1
		          end if
		          //listbox has the static columns and the right amount of columns
		          //initialise is complete
		          bListBoxInitialised=True
		        end if
		        //if the column name is not "required" and we are still on row 0
		        //put the column name in the heading
		        //add the column name and column number to the Dictionary
		        if strColumnName<>"required" Then
		          //column 0: name
		          //column 1: required
		          //column 2: used
		          targetListbox.Heading(iColumnNumber)=strColumnName
		          if strColumnName="value" then
		            targetListbox.ColumnType(iColumnNumber)=Listbox.TypeEditableTextField
		          end if
		          DicColumns.Value(strColumnName)=iColumnNumber
		          iColumnNumber=iColumnNumber+1
		        end if
		      end if
		      //fill in the column values
		      if strColumnName="required" then
		        targetListbox.CellCheck(targetListbox.LastIndex,DicColumns.Value("required"))=bRequired //required
		        targetListbox.CellCheck(targetListbox.LastIndex,DicColumns.Value("used"))=bRequired //used
		      else
		        //if we haven't checked for a value for this row yet
		        if bNewRowValueHandled=False Then
		          //if the apiparameters don't contain a value but there is a MyAPIParameterValues jsonitem
		          if bAPIParametersHasFieldValue=False and MyAPIParameterValues<>nil Then
		            //check if the MyAPIParameterValues contains a value for the current field
		            if MyAPIParameterValues.HasName(strName) Then
		              //if so, fill it in in the value column
		              targetListbox.Cell(targetListbox.LastIndex,DicColumns.Value("value").IntegerValue)=MyAPIParameterValues.Value(strName).StringValue
		              if bRequired=False Then
		                //if we have a value, but it wasn't required
		                //then check the used column
		                targetListbox.CellCheck(targetListbox.LastIndex,DicColumns.Value("used"))=True //used
		              end if
		            end if
		          end if
		          bNewRowValueHandled=True
		        end if
		        if strColumnName="value" and bRequired=False Then
		          //if we have a value, but it wasn't required
		          //then check the used column
		          targetListbox.CellCheck(targetListbox.LastIndex,DicColumns.Value("used"))=True //used
		        end if
		        targetListbox.Cell(targetListbox.LastIndex,DicColumns.Value(strColumnName).IntegerValue)=jProperties.Value(strColumnName).StringValue
		      end if
		    next
		  next
		  if targetListbox.ListCount>0 and DicColumns<>nil Then
		    targetListbox.CellTag(0,0)=DicColumns
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function EscapeSQLData(data as string) As String
		  // Prepare a string for use in a SQL statement.  A string which is being
		  // placed into a SQL statement cannot have a single quote in it since that will
		  // make the database engine believe the string is finished.
		  // For example the word "can't" will not work in SQL because it will see the word
		  // as just "can".
		  // In order to get around this you must escape all single quotes by adding a second
		  // one.  So "can't" will become "can''t" and then SQL command will work.
		  
		  // Replace all single quotes with two single quote characters
		  data = replaceAll( data, "'", "''" )
		  
		  // Return the new data which is ready to be used in SQL
		  return ConvertEncoding(data, Encodings.UTF8)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsJSONItem(Extends MyJSI As JSONItem_MTC, iIndex As Integer) As Boolean
		  Dim bReturn As Boolean=True
		  Try
		    Dim jChild As JSONItem_MTC=MyJSI.Value(iIndex) //returns an IllegalCastException due to the fact that this is no JSONItem
		  Catch err As RuntimeException
		    bReturn=False
		  End Try
		  Return bReturn
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsJSONItem(Extends MyJSI As JSONItem_MTC, StrName As String) As Boolean
		  #Pragma BreakOnExceptions Off
		  Dim bReturn As Boolean=True
		  Try
		    Dim jChild As JSONItem_MTC=MyJSI.Child(StrName) //returns an IllegalCastException due to the fact that this is no JSONItem
		  Catch err As RuntimeException
		    bReturn=False
		  End Try
		  Return bReturn
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function JSONPrettyPrint(JSON As Text) As Text
		  Const Indent = &h09
		  Const EndOfLine = &h0A
		  
		  Dim Bytes() As UInt8
		  Dim Indents As UInteger
		  
		  Dim AddAsIs, InQuote As Boolean
		  
		  Dim Mem As Xojo.Core.MemoryBlock = Xojo.Core.TextEncoding.UTF8.ConvertTextToData(JSON)
		  Dim Bound As UInteger = Mem.Size - 1
		  Dim Pointer As Ptr = Mem.Data
		  For Offset As UInteger = 0 To Bound
		    Dim Char As UInt8 = Pointer.UInt8(Offset)
		    
		    If AddAsIs Then
		      Bytes.Append(Char)
		      AddAsIs = False
		    ElseIf Char = &h22 Then
		      Bytes.Append(Char)
		      InQuote = Not InQuote
		    ElseIf InQuote Then
		      Bytes.Append(Char)
		      If Char = &h5C Then
		        AddAsIs = True
		      End If
		    ElseIf Char = &h7B Or Char = &h5B Then
		      Indents = Indents + 1
		      Bytes.Append(Char)
		      Bytes.Append(EndOfLine)
		      For I As UInteger = 1 To Indents
		        Bytes.Append(Indent)
		      Next
		    ElseIf Char = &h7D Or Char = &h5D Then
		      Indents = Indents - 1
		      Bytes.Append(EndOfLine)
		      For I As UInteger = 1 To Indents
		        Bytes.Append(Indent)
		      Next
		      Bytes.Append(Char)
		    ElseIf Char = &h2C Then
		      Bytes.Append(Char)
		      Bytes.Append(EndOfLine)
		      For I As UInteger = 1 To Indents
		        Bytes.Append(Indent)
		      Next
		    ElseIf Char = &h3A Then
		      Bytes.Append(Char)
		      Bytes.Append(&h20)
		    ElseIf Char = &h0A Or Char = &h0D Or Char = &h20 Or Char = &h09 Then
		      // Skip it
		    Else
		      Bytes.Append(Char)
		    End If
		  Next
		  
		  Return Xojo.Core.TextEncoding.UTF8.ConvertDataToText(New Xojo.Core.MemoryBlock(Bytes))
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function OpenDB() As SQLiteDatabase
		  Dim db As New SQLiteDatabase
		  Dim f As FolderItem
		  f=SpecialFolder.ApplicationData.Child("apidocsluna.db")
		  if f<>nil and f.Exists Then
		    db.DatabaseFile = f
		    if db.Connect=False Then
		      db=nil
		    end if
		  else
		    db=nil
		  End If
		  Return db
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, CompatibilityFlags = (not TargetHasGUI and not TargetWeb and not TargetIOS) or  (TargetWeb) or  (TargetHasGUI)
		Function StringToText(s As String) As Text
		  // Before a String can be converted to Text, it must have a valid encoding
		  // to avoid an exception. If the encoding is not valid, we will hex-encode the string instead.
		  
		  If s.Encoding Is Nil Or Not s.Encoding.IsValidData(s) Then
		    s = EncodeHex(s, True)
		    s = s.DefineEncoding(Encodings.UTF8) // Just to make sure
		  End If
		  
		  Return s.ToText
		  
		End Function
	#tag EndMethod


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

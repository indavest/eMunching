<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Text" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Text.RegularExpressions" %>
<%@ Import Namespace="System.Configuration" %>
<%@ Page Language="vb" EnableSessionState="True" EnableViewState="False" Strict="True" %>
<HTML>
    <HEAD>
		<SCRIPT language="vb" runat="server">
			Private _strImagePath As String             '-- path to GIF icon image files (absolute)
			Private _strHideFilePattern As String       '-- hide any files matching pattern
			Private _strHideFolderPattern As String     '-- hide any folders matching pattern
			Private _strAllowedPathPattern As String    '-- force user to stay on paths matching pattern
			Private _blnFlushContent As Boolean         '-- flush rows to the browser as they are written

			Private Const _strIconSize As String = "height=16 width=16"
			Private Const _strRenameTag As String = "_2_"
			Private Const _strCheckboxTag As String = "checked_"
			Private Const _strActionTag As String = "action"
			Private Const _strWebPathTag As String = "path"
			Private Const _strColSortTag As String = "sort"
			Private Const _strTargetFolderTag As String = "targetfolder"

			Private _FileOperationException As Exception

			Public ReadOnly Property RenameTag() As String
				Get
					Return _strRenameTag
				End Get
			End Property

			Public ReadOnly Property ActionTag() As String
				Get
					Return _strActionTag
				End Get
			End Property

			Public ReadOnly Property CheckboxTag() As String
				Get
					Return _strCheckboxTag
				End Get
			End Property

			Public ReadOnly Property TargetFolderTag() As String
				Get
					Return _strTargetFolderTag
				End Get
			End Property

			Public ReadOnly Property CurrentWebPath() As String
				Get
					Return WebPath()
				End Get
			End Property

			Public ReadOnly Property ScriptName() As String
				Get
					Return Request.ServerVariables("script_name")
				End Get
			End Property

			Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
				'-- get .config settings
				_strHideFolderPattern = GetConfigString("HideFolderPattern")
				_strHideFilePattern = GetConfigString("HideFilePattern")
				_strAllowedPathPattern = GetConfigString("AllowedPathPattern")
				_strImagePath = GetConfigString("ImagePath", "images/")
				_blnFlushContent = (GetConfigString("FlushContent") <> "")
			End Sub

			Private Function GetConfigString(ByVal strKey As String, Optional ByVal strDefaultValue As String = "") As String
				'strKey = "images/" & strKey
				If ConfigurationSettings.AppSettings(strKey) Is Nothing Then
					Return strDefaultValue
				Else
					Return Convert.ToString(ConfigurationSettings.AppSettings(strKey))
				End If
			End Function

			Public Sub HandleAction()
				If Request.Form(_strActionTag) Is Nothing Then Return

				Dim strAction As String = Request.Form(_strActionTag).ToLower
				If strAction = "" Then Return

				Select Case strAction
					Case "newfolder"
						MakeFolder(GetTargetPath)
					Case "upload"
						SaveUploadedFile()
					Case Else
						ProcessCheckedFiles(strAction)
				End Select
				If Not _FileOperationException Is Nothing Then
					WriteError(_FileOperationException)
				End If
			End Sub

			Private Sub ProcessCheckedFiles(ByVal strAction As String)
				Dim intLoc As Integer
				Dim strName As String
				Dim intTagLength As Integer = _strCheckboxTag.Length
				Dim FileList As New ArrayList

				For Each strItem As String In Request.Form
					intLoc = strItem.IndexOf(_strCheckboxTag)
					If intLoc > -1 Then
						_FileOperationException = Nothing
						strName = strItem.Substring(intLoc + intTagLength)
						FileList.Add(strName)
						Select Case strAction
							Case "delete"
								DeleteFileOrFolder(strName)
							Case "move"
								MakeFolder(GetTargetPath)
								MoveFileOrFolder(strName)
							Case "copy"
								MakeFolder(GetTargetPath)
								CopyFileOrFolder(strName)
							Case "rename"
								RenameFileOrFolder(strName)
						End Select
					End If
				Next

				'-- certain operations must work on all the selected files/folders at once.
				If strAction = "zip" Then
					ZipFileOrFolder(FileList)
				End If
			End Sub

			Private Sub SaveUploadedFile()
				If Request.Files.Count > 0 Then
					Dim pf As HttpPostedFile = Request.Files.Item(0)
					If pf.ContentLength > 0 Then
						Dim strFilename As String = pf.FileName
						Dim strTargetFile As String = GetLocalPath(Path.GetFileName(strFilename))
						'-- make sure we clear out any existing file before uploading
						If File.Exists(strTargetFile) Then
							DeleteFileOrFolder(strFilename)
						End If
						Try
							pf.SaveAs(strTargetFile)
						Catch ex As Exception
							_FileOperationException = ex
						End Try
					End If
				End If
			End Sub

			Public Sub WriteTable()
				Dim intRowsRendered As Integer
				With Response
					'-- header table
					.Write("<TABLE class=""Header"" width=""100%"" border=0>")
					.Write("<TR>")
					.Write("<TD width=310>")
					.Write("<IMG src=""" & _strImagePath & "file/folder.gif"" " & _strIconSize & " align=absmiddle>&nbsp;")
					.Write("<INPUT class=""input"" type=""text"" name=""path"" value=""" & WebPath() & """ size=35>")
					.Write("<INPUT class=""input"" type=""submit"" value=""Go"">")
					.Write("<TD width=150>")
					.Write(UpUrl)
					.Write("<IMG src=""" & _strImagePath & "icon/folderup.gif"" " & _strIconSize & " align=absmiddle>&nbsp;Move up a folder</A>")
					.Write("<TD align=right width=""*""><a href=""#bottom"" title=""end key"">Scroll to Bottom</a>")
					.Write("</TABLE>")
					.Write(Environment.NewLine)
					Flush()

					'-- body table
					.Write("<TABLE cellspacing=0 border=0 width=""100%"" STYLE=""table-layout:fixed;border-right:1px solid black;border-left:1px solid black;"">")
					.Write("<TR>")
					.Write("<TH width=20 align=right><INPUT name=""all_files_checkbox"" onclick=""javascript:checkall(this);"" type=checkbox>")
					.Write("<TH width=20 align=center>")
					.Write("<TH align=left>" & PageUrl("", "Name") & "File Name</a>")
					.Write("<TH width=80 align=right>" & PageUrl("", "Size") & "Size</a>")
					.Write("<TH width=30 align=left>")
					.Write("<TH width=150 align=right>" & PageUrl("", "Created") & "Created</a>")
					.Write("<TH width=150 align=right>" & PageUrl("", "Modified") & "Modified</a>")
					.Write("<TH width=45 align=right>" & PageUrl("", "Attr") & "Attr</a>")
					.Write(Environment.NewLine)
					Flush()

					'-- render body table rows for folders and files
					intRowsRendered = WriteRows()

					.Write("</TABLE>")
					Flush()

					'-- footer table
					If intRowsRendered < 0 Then Return

					.Write("<a name=""bottom""></a>")
					.Write("<TABLE class=""Footer"" width=""100%"">")
					.Write("<TR>")
					.Write("<TD width=""300"" valign=""top"">")
					.Write("<IMG src=""" & _strImagePath & "file/folder.gif"" " & _strIconSize & " align=absmiddle>")
					.Write("&nbsp;<input class=""input"" type=""text"" name=""" & _strTargetFolderTag & """ size=35>")
					.Write("<TD width=""*"" valign=""top"" rowspan=2> ")

					.Write("<TABLE>")
					.Write("<TR>")
					.Write("<TD width=140>")
					.Write("<A href=""javascript:newfolder();"">")
					.Write("<IMG src=""" & _strImagePath & "icon/newfolder.gif"" width=19 height=16 align=absmiddle>")
					.Write("&nbsp;New folder</A>")
					.Write("<TD width=140>")
					.Write("<A href=""javascript:confirmfiles('copy');"">")
					.Write("<IMG src=""" & _strImagePath & "icon/copy.gif"" " & _strIconSize & " align=absmiddle>&nbsp;Copy to folder</A>")
					.Write("<TD width=140>")
					.Write("<A href=""javascript:confirmfiles('move');"">")
					.Write("<IMG src=""" & _strImagePath & "icon/move.gif"" " & _strIconSize & " align=absmiddle>&nbsp;Move to folder</A>")
					.Write("<TD width=""*"">")
					.Write("<TR>")
					.Write("<TD width=140>")
					.Write("<A href=""javascript:upload();"">")
					.Write("<IMG src=""" & _strImagePath & "icon/upload.gif"" width=18 height=16 align=absmiddle>&nbsp;Upload a file</A>")
					.Write("<TD width=140>")
					.Write("<A href=""javascript:confirmfiles('delete');"">")
					.Write("<IMG src=""" & _strImagePath & "icon/delete.gif"" width=18 height=16 align=absmiddle>&nbsp;Delete</A>")
					.Write("<TD width=140>")
					.Write("<A href=""javascript:confirmfiles('rename');"">")
					.Write("<IMG src=""" & _strImagePath & "icon/rename.gif"" " & _strIconSize & " align=absmiddle>&nbsp;Rename</A>")
					.Write("<TD width=""*"">")
					.Write("<A href=""javascript:confirmfiles('zip');"">")
					.Write("<IMG src=""" & _strImagePath & "icon/zip.gif"" " & _strIconSize & " align=absmiddle>")
					.Write("&nbsp;Zip</A>")
					.Write("</TABLE>")

					.Write("<TR>")
					.Write("<TD width=""*"" valign=""top"">")
					.Write("<IMG src=""" & _strImagePath & "file/generic.gif"" " & _strIconSize & " align=absmiddle>")
					.Write("&nbsp;<INPUT class=""input"" type=""file"" name=""fileupload"" />&nbsp;&nbsp;<a href=""#"" class=""tt""><IMG SRC=""/images/help 16x16.png"" WIDTH=""16"" HEIGHT=""16"" BORDER=""0""><span class=""tooltip""><span class=""top""></span><span class=""middle"">Please use these sizes and directories when uploading images:<br><br><b>Menu Item Images</b><br>Dir: MenuItems<br><br><b>App Images</b><br>Dir: AppIcons<br><br><b>Deal Images</b><br>Dir: DealImages<br><br><b>Sizes:</b><br>Thumbnail: 16x16<br>Menu Image: 120x83<br>Item Image: 320x183</span><span class=""bottom""></span></span></a>")
					.Write("<TD width=""*"">")
					.Write("</TABLE>")
				End With
				Flush()
			End Sub

			Private Function WriteRows() As Integer
				Const strPathError As String = "The path '{0}' {1} <a href='javascript:history.go(-1);'>Go back</a>"

				'-- make sure we're allowed to look at this web path
				If _strAllowedPathPattern <> "" AndAlso _
					Not Regex.IsMatch(WebPath, _strAllowedPathPattern) Then
					WriteErrorRow(String.Format(strPathError, WebPath, "is not allowed because it does not match the pattern '" & Server.HtmlEncode(_strAllowedPathPattern) & "'."))
					Return -1
				End If

				'-- make sure this directory exists on the server
				Dim strLocalPath As String = GetLocalPath()
				If Not Directory.Exists(strLocalPath) Then
					WriteErrorRow(String.Format(strPathError, WebPath, "does not exist."))
					Return -1
				End If

				'-- make sure we can get the files and directories for this directory
				Dim da As DirectoryInfo()
				Dim fa As FileInfo()
				Try
					Dim di As New DirectoryInfo(strLocalPath)
					da = di.GetDirectories
					fa = di.GetFiles
				Catch ex As Exception
					WriteErrorRow(ex)
					Return -1
				End Try

				'-- add all file/directory info to intermediate DataTable
				Dim dt As DataTable = GetFileInfoTable()
				dt.BeginLoadData()
				For Each d As DirectoryInfo In da
					AddRowToFileInfoTable(d, dt)
				Next
				For Each f As FileInfo In fa
					AddRowToFileInfoTable(f, dt)
				Next
				dt.EndLoadData()
				dt.AcceptChanges()

				If dt.Rows.Count = 0 Then
					WriteErrorRow("(no files)")
					Return 0
				End If

				'-- sort and render intermediate DataView from our DataTable
				Dim dv As DataView
				If SortColumn() = "" Then
					dv = dt.DefaultView
				Else
					dv = New DataView(dt)
					If SortColumn.StartsWith("-") Then
						dv.Sort = "IsFolder, " & SortColumn().Substring(1) & " desc"
					Else
						dv.Sort = "IsFolder desc, " & SortColumn()
					End If
				End If

				Dim intRenderedRows As Integer = 0
				For Each drv As DataRowView In dv
					If WriteViewRow(drv) Then intRenderedRows += 1
				Next

				Return intRenderedRows
			End Function

			Private Function GetFileInfoTable() As DataTable
				Dim dt As New DataTable
				With dt.Columns
					.Add(New DataColumn("Name", GetType(System.String)))
					.Add(New DataColumn("IsFolder", GetType(System.Boolean)))
					.Add(New DataColumn("FileExtension", GetType(System.String)))
					.Add(New DataColumn("Attr", GetType(System.String)))
					.Add(New DataColumn("Size", GetType(System.Int64)))
					.Add(New DataColumn("Modified", GetType(System.DateTime)))
					.Add(New DataColumn("Created", GetType(System.DateTime)))
				End With
				Return dt
			End Function

			Private Sub AddRowToFileInfoTable(ByVal fi As FileSystemInfo, ByVal dt As DataTable)
				Dim dr As DataRow = dt.NewRow
				Dim Attr As String = AttribString(fi.Attributes)
				With dr
					.Item("Name") = fi.Name
					.Item("FileExtension") = Path.GetExtension(fi.Name)
					.Item("Attr") = Attr
					If Attr.IndexOf("d") > -1 Then
						.Item("IsFolder") = True
						.Item("Size") = 0
					Else
						.Item("IsFolder") = False
						.Item("Size") = New FileInfo(fi.FullName).Length
					End If
					.Item("Modified") = fi.LastWriteTime
					.Item("Created") = fi.CreationTime
				End With
				dt.Rows.Add(dr)
			End Sub

			Private Function SortColumn() As String
				If Request.QueryString(_strColSortTag) Is Nothing Then
					Return "Name"
				Else
					Return Request.QueryString(_strColSortTag)
				End If
			End Function

			Private Function WebPath() As String
				Dim strPath As String = Request.Item(_strWebPathTag)
				If strPath = Nothing OrElse strPath = "" Then
		            'strPath = GetConfigString("DefaultPath", "~/")
		            strPath = "/Restaurants/" + Session("RestName").ToString + "/ArtWork/"
		        End If
		        
		        Return strPath
			End Function

			Private Function UpUrl() As String
				Dim strUp As String = Regex.Replace(WebPath(), "/[^/]+$", "")
				If strUp = "" Or strUp = "/" Then
					strUp = GetConfigString("DefaultPath", "~/")
				End If
				Return PageUrl(strUp + "/")
			End Function

			Private Function PageUrl(Optional ByVal NewPath As String = "", _
				Optional ByVal NewSortColumn As String = "") As String

				Dim blnSortProvided As Boolean = (NewSortColumn <> "")

				'-- if not provided, use the current values in the querystring
				If NewPath = "" Then NewPath = WebPath()
				If NewSortColumn = "" Then NewSortColumn = SortColumn()

				Dim sb As New System.Text.StringBuilder
				With sb
					.Append("<A href=""")
					.Append(ScriptName)
					.Append("?")
					.Append(_strWebPathTag)
					.Append("=")
					.Append(NewPath)
					If NewSortColumn <> "" Then
						.Append("&")
						.Append(_strColSortTag)
						.Append("=")
						If blnSortProvided And (NewSortColumn.ToLower = SortColumn().ToLower) Then
							.Append("-")
						End If
						.Append(NewSortColumn)
					End If
					.Append(""">")
				End With

				Return sb.ToString
			End Function

			Private Function FormatKB(ByVal FileLength As Long) As String
				Return String.Format("{0:N0}", (FileLength / 1024))
			End Function

			Private Function AttribString(ByVal a As IO.FileAttributes) As String
				Dim sb As New StringBuilder
				If (a And FileAttributes.ReadOnly) > 0 Then sb.Append("r")
				If (a And FileAttributes.Hidden) > 0 Then sb.Append("h")
				If (a And FileAttributes.System) > 0 Then sb.Append("s")
				If (a And FileAttributes.Directory) > 0 Then sb.Append("d")
				If (a And FileAttributes.Archive) > 0 Then sb.Append("a")
				If (a And FileAttributes.Compressed) > 0 Then sb.Append("c")
				Return sb.ToString
			End Function

			Private Function WebPathCombine(ByVal path1 As String, ByVal path2 As String) As String
				Dim strTemp As String = Path.Combine(path1, path2).Replace("\", "/")
				If strTemp.IndexOf("~/") > -1 Then
					strTemp = strTemp.Replace("~/", Page.ResolveUrl("~/"))
				End If
				Return strTemp
			End Function

			Private Function FileIconLookup(ByVal drv As DataRowView) As String

				If IsDirectory(drv) Then
					Return WebPathCombine(_strImagePath, "file/folder.gif")
				End If

				Select Case Convert.ToString(drv.Item("FileExtension"))
					Case ".gif", ".peg", ".jpe", ".jpg", ".png"
						Return WebPathCombine(WebPath, Convert.ToString(drv.Item("Name")))
						'Return "file_image.gif"
					Case ".txt"
						Return WebPathCombine(_strImagePath, "file/text.gif")
					Case ".htm", ".xml", ".xsl", ".css", ".html", ".config"
						Return WebPathCombine(_strImagePath, "file/html.gif")
					Case ".mp3", ".wav", ".wma", ".au", ".mid", ".ram", ".rm", ".snd", ".asf"
						Return WebPathCombine(_strImagePath, "file/audio.gif")
					Case ".zip", "tar", ".gz", ".rar", ".cab", ".tgz"
						Return WebPathCombine(_strImagePath, "file/compressed.gif")
					Case ".asp", ".wsh", ".js", ".vbs", ".aspx", ".cs", ".vb"
						Return WebPathCombine(_strImagePath, "file/script.gif")
					Case Else
						Return WebPathCombine(_strImagePath, "file/generic.gif")
				End Select
			End Function

			Private Function WriteViewRow(ByVal drv As DataRowView) As Boolean
				Dim strFileLink As String
				Dim strFileName As String = Convert.ToString(drv.Item("Name"))
				Dim strFilePath As String = WebPathCombine(WebPath, strFileName)
				Dim blnFolder As Boolean = IsDirectory(drv)

				If blnFolder Then
					If _strHideFolderPattern <> "" AndAlso _
						Regex.IsMatch(strFileName, _strHideFolderPattern, RegexOptions.IgnoreCase) Then
						Return False
					End If
					strFileLink = PageUrl(strFilePath) & strFileName & "</A>"
				Else
					If _strHideFilePattern <> "" AndAlso _
						Regex.IsMatch(strFileName, _strHideFilePattern, RegexOptions.IgnoreCase) Then
						Return False
					End If
					strFileLink = "<A href=""" & strFilePath & """ target=""_blank"">" & strFileName & "</A>"
				End If

				With Response
					.Write("<TR>")
					.Write("<TD align=right><INPUT name=""")
					.Write(_strCheckboxTag)
					.Write(strFileName)
					.Write(""" type=checkbox>")
					.Write("<TD align=center><IMG src=""")
					.Write(FileIconLookup(drv))
					.Write(""" ")
					.Write(_strIconSize)
					.Write(">")
					.Write("<TD>")
					.Write(strFileLink)
					.Write("<TD align=right>")
					If blnFolder Then
						.Write("<TD align=left>")
					Else
						.Write(FormatKB(Convert.ToInt64(drv.Item("Size"))))
						.Write("<TD align=left>kb")
					End If
					.Write("<TD align=right>")
					.Write(Convert.ToString(drv.Item("Created")))
					.Write("<TD align=right>")
					.Write(Convert.ToString(drv.Item("Modified")))
					.Write("<TD align=right>")
					.Write(Convert.ToString(drv.Item("Attr")))
					.Write(Environment.NewLine)
				End With
				Flush()

				Return True
			End Function

			Private Sub Flush()
				If _blnFlushContent Then Response.Flush()
			End Sub

			Private Function GetLocalPath(Optional ByVal strFilename As String = "") As String
				Return Path.Combine(Server.MapPath(WebPath), strFilename)
			End Function

			Private Function MakeRelativePath(ByVal strFilename As String) As String
				Dim strRelativePath As String = strFilename.Replace(Server.MapPath(WebPath), "")
				If strRelativePath.StartsWith("\") Then
					Return strRelativePath.Substring(1)
				Else
					Return strRelativePath
				End If
			End Function

			Private Function GetTargetPath(Optional ByVal strFilename As String = "") As String
				Return Path.Combine(Path.Combine(GetLocalPath, Request.Form(_strTargetFolderTag)), strFilename)
			End Function

			Private Function IsDirectory(ByVal strFilepath As String) As Boolean
				Return Directory.Exists(strFilepath)
			End Function

			Private Function IsDirectory(ByVal drv As DataRowView) As Boolean
				Return Convert.ToString(drv.Item("attr")).IndexOf("d") > -1
			End Function

			Private Sub DeleteFileOrFolder(ByVal strName As String)
				Dim strLocalPath As String = GetLocalPath(strName)
				Try
					RemoveReadOnly(strLocalPath)
					If IsDirectory(strLocalPath) Then
						Directory.Delete(strLocalPath, True)
					Else
						File.Delete(strLocalPath)
					End If
				Catch ex As Exception
					_FileOperationException = ex
				End Try
			End Sub

			Private Sub MoveFileOrFolder(ByVal strName As String)
				Dim strLocalPath As String = GetLocalPath(strName)
				Dim strTargetPath As String = GetTargetPath(strName)
				Try
					If IsDirectory(strLocalPath) Then
						Directory.Move(strLocalPath, strTargetPath)
					Else
						File.Move(strLocalPath, strTargetPath)
					End If
				Catch ex As Exception
					_FileOperationException = ex
				End Try
			End Sub

			Private Sub CopyFileOrFolder(ByVal strName As String)
				Dim strLocalPath As String = GetLocalPath(strName)
				Dim strTargetPath As String = GetTargetPath(strName)

				Try
					If IsDirectory(strLocalPath) Then
						CopyFolder(strLocalPath, strTargetPath, True)
					Else
						File.Copy(strLocalPath, strTargetPath)
					End If
				Catch ex As Exception
					_FileOperationException = ex
				End Try
			End Sub

			Private Sub ZipFileOrFolder(ByVal FileList As ArrayList)
				Dim ZipTargetFile As String

				If FileList.Count = 1 Then
					ZipTargetFile = GetLocalPath(Path.ChangeExtension(Convert.ToString(FileList.Item(0)), ".zip"))
				Else
					ZipTargetFile = GetLocalPath("ZipFile.zip")
				End If

				Dim zfs As FileStream
				Dim zs As ICSharpCode.SharpZipLib.Zip.ZipOutputStream
				Try
					If File.Exists(ZipTargetFile) Then
						zfs = File.OpenWrite(ZipTargetFile)
					Else
						zfs = File.Create(ZipTargetFile)
					End If

					zs = New ICSharpCode.SharpZipLib.Zip.ZipOutputStream(zfs)

					ExpandFileList(FileList)

					For Each strName As String In FileList
						Dim ze As ICSharpCode.SharpZipLib.Zip.ZipEntry
						'-- the ZipEntry requires a preceding slash if the file is a folder
						If strName.IndexOf("\") > -1 And Not strName.StartsWith("\") Then
							ze = New ICSharpCode.SharpZipLib.Zip.ZipEntry("\" & strName)
						Else
							ze = New ICSharpCode.SharpZipLib.Zip.ZipEntry(strName)
						End If

						ze.DateTime = DateTime.Now
						zs.PutNextEntry(ze)

						Dim fs As FileStream
						Try
							fs = File.OpenRead(GetLocalPath(strName))
							Dim buffer(2048) As Byte
							Dim len As Integer = fs.Read(buffer, 0, buffer.Length)
							Do While len > 0
								zs.Write(buffer, 0, len)
								len = fs.Read(buffer, 0, buffer.Length)
							Loop
						Catch ex As Exception
							_FileOperationException = ex
						Finally
							If Not fs Is Nothing Then fs.Close()
							zs.CloseEntry()
						End Try
					Next
				Finally
					If Not zs Is Nothing Then zs.Close()
					If Not zfs Is Nothing Then zfs.Close()
				End Try
			End Sub

			Private Sub RenameFileOrFolder(ByVal strName As String)
				Dim strOldName As String
				Dim strNewName As String
				Dim intTagLoc As Integer = strName.IndexOf(_strRenameTag)
				If intTagLoc = -1 Then Return

				strOldName = strName.Substring(0, intTagLoc)
				strNewName = strName.Substring(intTagLoc + _strRenameTag.Length)
				If strOldName = strNewName Then Return

				Dim strOldPath As String = GetLocalPath(strOldName)
				Dim strNewPath As String = GetLocalPath(strNewName)

				Try
					If IsDirectory(strOldPath) Then
						Directory.Move(strOldPath, strNewPath)
					Else
						File.Move(strOldPath, strNewPath)
					End If
				Catch ex As Exception
					_FileOperationException = ex
				End Try
			End Sub

			Private Sub MakeFolder(ByVal strFilename As String)
				Dim strLocalPath As String = GetLocalPath(strFilename)
				Try
					If Not Directory.Exists(strLocalPath) Then
						Directory.CreateDirectory(strLocalPath)
					End If
				Catch ex As Exception
					_FileOperationException = ex
				End Try
			End Sub

			Private Sub CopyFolder(ByVal strSourceFolderPath As String, ByVal strDestinationFolderPath As String, _
				ByVal blnOverwrite As Boolean)

				'-- make sure target folder exists
				If Not Directory.Exists(strDestinationFolderPath) Then
					Directory.CreateDirectory(strDestinationFolderPath)
				End If

				'-- copy all of the files in this folder to the destination folder
				For Each strFilePath As String In Directory.GetFiles(strSourceFolderPath)
					Dim strFileName As String = Path.GetFileName(strFilePath)
					'-- if exception, will be caught in calling proc
					File.Copy(strFilePath, Path.Combine(strDestinationFolderPath, strFileName), blnOverwrite)
				Next

				'-- copy all of the subfolders in this folder
				For Each strFolderPath As String In Directory.GetDirectories(strSourceFolderPath)
					Dim strFolderName As String = Regex.Match(strFolderPath, "[^\\]+$").ToString
					CopyFolder(strFolderPath, Path.Combine(strDestinationFolderPath, strFolderName), blnOverwrite)
				Next
			End Sub

			Private Sub ExpandFileList(ByRef FileList As ArrayList)

				Dim strLocalPath As String
				Dim NewFileList As New ArrayList

				For i As Integer = FileList.Count - 1 To 0 Step -1
					strLocalPath = GetLocalPath(Convert.ToString(FileList.Item(i)))
					If IsDirectory(strLocalPath) Then
						FileList.Remove(FileList.Item(i))
						AddFilesFromFolder(strLocalPath, NewFileList)
					End If
				Next

				If NewFileList.Count > 0 Then
					FileList.AddRange(NewFileList)
				End If
			End Sub

			Private Sub AddFilesFromFolder(ByVal strFolderName As String, ByRef FileList As ArrayList)
				If Not Directory.Exists(strFolderName) Then Return

				Try
					For Each strName As String In Directory.GetFiles(strFolderName)
						FileList.Add(MakeRelativePath(strName))
					Next
				Catch ex As Exception
					'-- mostly to catch "access denied"
					_FileOperationException = ex
				End Try

				Try
					For Each strName As String In Directory.GetDirectories(strFolderName)
						AddFilesFromFolder(strName, FileList)
					Next
				Catch ex As Exception
					'-- mostly to catch "access denied"
					_FileOperationException = ex
				End Try
			End Sub

			Private Sub RemoveReadOnly(ByVal strPath As String)
				If IsDirectory(strPath) Then
					For Each strFile As String In Directory.GetFiles(strPath)
						RemoveReadOnly(strFile)
					Next
					For Each strFolder As String In Directory.GetDirectories(strPath)
						RemoveReadOnly(strFolder)
					Next
				Else
					Dim fi As New FileInfo(strPath)
					If (fi.Attributes And FileAttributes.ReadOnly) <> 0 Then
						fi.Attributes = fi.Attributes Xor FileAttributes.ReadOnly
					End If
				End If
			End Sub

			Private Function CurrentIdentity() As String
				Return System.Security.Principal.WindowsIdentity.GetCurrent.Name
			End Function

			Private Function GetFriendlyErrorMessage(ByVal ex As Exception) As String
				Dim strMessage As String = ex.Message
				If TypeOf ex Is System.UnauthorizedAccessException Then
					strMessage &= " The account '" & CurrentIdentity() & "' may not have permission to this file or folder."
				End If
				Return strMessage
			End Function

			Private Sub WriteError(ByVal ex As Exception)
				WriteError(GetFriendlyErrorMessage(ex))
			End Sub
			Private Sub WriteError(ByVal strText As String)
				Response.Write("<DIV class=""Error"">")
				Response.Write(strText)
				Response.Write("</DIV>")
			End Sub
			Private Sub WriteErrorRow(ByVal ex As Exception)
				WriteErrorRow(GetFriendlyErrorMessage(ex))
			End Sub
			Private Sub WriteErrorRow(ByVal strText As String)
				Response.Write("<TR><TD><TD><TD colspan=5><DIV class=""Error"">")
				Response.Write(strText)
				Response.Write("</DIV>")
			End Sub
				</SCRIPT>		
				<TITLE>Uploads in <%=CurrentWebPath%></TITLE>
				<SCRIPT language="JavaScript">	
				// create new folder
				function newfolder() {
					if (document.forms[0].elements['<%=TargetFolderTag%>'].value == '') {
						alert('No folder name was provided. Enter a new folder name in the textbox.');
						document.forms[0].elements['<%=TargetFolderTag%>'].focus();
						return;
					}
					document.forms[0].action.value = 'newfolder';
					document.forms[0].submit();
				}
				
				function upload() {
					if (document.forms[0].elements['fileupload'].value == '') {
						alert('No upload file was provided. Select a file to upload.');
						document.forms[0].elements['fileupload'].focus();
						return;
					}
					document.forms[0].action.value = 'upload';
					document.forms[0].submit();
				}
				
				// check or uncheck all file checkboxes
				function checkall(ctl) {
					for (var i = 0; i < document.forms[0].elements.length; i++) {
						if (document.forms[0].elements[i].name.indexOf('<%=CheckboxTag%>') > -1) { 
							document.forms[0].elements[i].checked = ctl.checked;
							}
						}
				}
				
				// confirm file list and target folder
				function confirmfiles(sAction) {
					var nMarked = 0;
					var sTemp = '';
					for (var i = 0; i < document.forms[0].elements.length; i++) {
						if (document.forms[0].elements[i].checked && 
						 document.forms[0].elements[i].name.indexOf('<%=CheckboxTag%>') > -1) { 
							if (sAction == 'rename') {
								var sFilename = '';
								var sNewFilename = '';
								sFilename = document.forms[0].elements[i].name;
								sFilename = sFilename.replace('<%=CheckboxTag%>','');
								sNewFilename = prompt('Enter new name for ' + sFilename, sFilename);
								if (sNewFilename != null) {
									document.forms[0].elements[i].name = document.forms[0].elements[i].name + '<%=RenameTag%>' + sNewFilename;
								}
							}
							nMarked = nMarked + 1;
						}
					}
					if (nMarked == 0) {
						alert('No items selected. To select items, use the checkboxes on the left.');
						return;
					}
					sTemp = 'Are you sure that you want to ' + sAction + ' the ' + nMarked + ' checked item(s)?'
					if (sAction == 'copy' || sAction == 'move') {
						sTemp = 'Are you sure you want to ' + sAction + ' the ' + nMarked + ' checked item(s) to the "' + document.forms[0].elements['<%=TargetFolderTag%>'].value + '" folder?'
						if (document.forms[0].elements['<%=TargetFolderTag%>'].value == '') {
							document.forms[0].elements['<%=TargetFolderTag%>'].focus();
							alert('No destination folder provided. Enter a folder name.');
							return;
						}
					}
					var confirmed = false;
					if (sAction == 'copy' || sAction == 'rename') {
						confirmed = true;
					} else {
						confirmed = confirm(sTemp);
					}

					if (confirmed) { 
						document.forms[0].action.value = sAction;
						document.forms[0].submit();
					}

				}
        </SCRIPT>
        <STYLE type="text/css">
            IMG { border: none; }
            BODY { background-color: #CCCCCC; font-family: "trebuchet ms", verdana, arial, sans-serif; FONT-SIZE: 80%; margin: 4px 4px 4px 4px; }
            TD { font-family: "trebuchet ms", verdana, arial, sans-serif; FONT-SIZE: 80%; }
            TH { font-family: "trebuchet ms", verdana, arial, sans-serif; FONT-SIZE: 80%; background-color: #eeeeee; }
			.input { text-align:left;font-weight:bold;	border: 1px solid black; }
            .Header { border-top: 1px solid black; border-right: 1px solid black; border-left: 1px solid black; background-color: lightyellow; }
			.Footer { border-bottom: 1px solid black; border-right: 1px solid black; border-left: 1px solid black; background-color: lightyellow; }
            .Error { color=red; font-weight: bold; }
        </STYLE>
		<link rel="stylesheet" type="text/css" href="/themes/bubbles.css" />
    </HEAD>
    <BODY>
		<div style="width:700px">
        <%HandleAction%>
        <FORM action="<%=ScriptName%>" method=post encType=multipart/form-data>
            <INPUT type=hidden name="<%=ActionTag%>">
            <%WriteTable%>
        </FORM>
		</div>
    </BODY>
</HTML>
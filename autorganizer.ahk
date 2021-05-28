 #NoEnv ;Recommended for performance and compatibility with future AutoHotkey releases.
 ; #Warn ;Enable warnings to assist with detecting common errors.
SendMode Input ;Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir% ;Ensures a consistent starting directory.

#SingleInstance force
#NoTrayIcon

global selectedFolder
global location
global option
;~ 1 select folder
FileSelectFolder, selectedFolder, , 3 , Select the folder to be sorted into subfolders
if selectedFolder =
   {
    MsgBox, You didn't select a folder.
    return
   }
else 
    MsgBox, You selected the folder "%selectedFolder%".
    
msg:= "Press YES if you want to make subfolders in" . selectedFolder . ",`n or Press NO if you want to chose another place"
MsgBox, 4,  Choose location , %msg%)
IfMsgBox Yes
    location:="here"
IfMsgBox No
    location:="elsewhere"

msg:= "Press YES if you want to enable the program to sort the files from the subfolders too. " . "`n or Press NO if you want to exclude the existing subfolders"
MsgBox, 4,  Choose option , %msg%)
IfMsgBox Yes
    option:="R"
IfMsgBox No
    option:= ;blank

MakeSubfoldersAndMoveFiles()
MsgBox, DONE!
MsgBox, , , DONE!, 3

ExitApp



MakeSubfoldersAndMoveFiles(){
    ; If (option = "R")
    If (location = "here")
    destination:= selectedFolder
    else
    {
        FileSelectFolder, destination, , 3 , Select the destination folder where will be sorted your files
        if destination =
        {
            MsgBox, You didn't select a folder.
            return
        }
    }

    Loop Files, %selectedFolder%\*, %option% ;Recurse into subfolders.
    {
        extention:=A_LoopFileExt
        subfolderPath:= SelectSubfolderFor(extention, destination)
        ; MsgBox % subfolderPath 
        If (A_LoopFileFullPath = "C:\Users\megur\Downloads\Downloads - Shortcut.lnk")
            Continue
        Else    
        FileMove, %A_LoopFileFullPath%, %subfolderPath%
    }
}
;~  switch (select) subfolder based on extension
SelectSubfolderFor(extention, destination){
 Switch extention
 {
 Case    "aif"    
       , "cda"    
       , "mid"    
       , "midi"  
       , "mp3"    
       , "mpa"    
       , "ogg"    
       , "wav"    
       , "wma"    
       , "wpl" :
     return ChooseSubfolder("Media\Audio", destination)

 Case    "ai"     
       , "bmp"    
       , "gif"    
       , "jpg"    
       , "jpeg"   
       , "png"    
       , "ps"     
       , "psd"    
       , "svg"    
       , "tif"    
       , "tiff"   
       , "cr2":
     return ChooseSubfolder("Media\Images", destination)
   ; video
 Case    "3g2"    
       , "3gp"    
       , "avi"    
       , "flv"    
       , "h264"   
       , "m4v"    
       , "mkv"    
       , "mov"    
       , "mp4"    
       , "mpg"    
       , "mpeg"   
       , "rm"     
       , "swf"    
       , "vob"    
       , "wmv":
     return ChooseSubfolder("Media\Video", destination)

 Case "pdf":
     return ChooseSubfolder("Documents\PDFs", destination)

 Case "doc", "docx":
     return ChooseSubfolder("Documents\Word", destination)

 Case    "key"    
       , "odp"    
       , "pps"    
       , "ppt"    
       , "pptx":
     return ChooseSubfolder("Documents\Presentations", destination)

 Case    "txt"     
       , "odt "   
       , "rtf"    
       , "tex"    
       , "wks "   
       , "wps"    
       , "wpd":
     return ChooseSubfolder("Documents\Others", destination)

 Case    "ods"    
       , "xlr"    
       , "xls"    
       , "xlsx":
     return ChooseSubfolder("Documents\Excel", destination)

 Case    "apk"    
       , "bat"    
       , "com"    
       , "exe"    
       , "gadget" 
       , "jar"    
       , "wsf" :
     return ChooseSubfolder("Executables", destination)

 Case "ahk":
     return "C:\hotkeys"

 Case    "7z"     
       , "arj"    
       , "deb"    
       , "pkg"    
       , "rar"    
       , "rpm"    
       , "targz" 
       , "z"      
       , "zip":
     return ChooseSubfolder("Archived files", destination)

 Case    "csv"    
       , "dat"    
       , "db"     
       , "dbf"    
       , "log"    
       , "mdb"    
       , "sav"    
       , "sql"    
       , "tar"    
       , "xml"    
       , "json" :
     return ChooseSubfolder("Programming\Database", destination)

 Case    "c"      
       , "cs"     
       , "class"  
       , "java"   
       , "py"     
       , "sh"     
       , "h"  :
     return ChooseSubfolder("Programming\c&c++", destination)

 Case "torrent":
     return ChooseSubfolder("Other\Torrents", destination)

 Case "ico" , "icns" :
     return ChooseSubfolder("Other\Icons", destination)

 Case    "asp"    
       , "aspx"   
       , "cer"    
       , "cfm"    
       , "cgi"    
       , "pl"     
       , "css"    
       , "htm"    
       , "js"     
       , "jsp"    
       , "part"   
       , "php"    
       , "rss"    
       , "xhtml"  
       , "html" :
     return ChooseSubfolder("Other\Internet", destination)

 Case    "bin"    
       , "dmg"    
       , "iso"    
       , "toast"  
       , "vcd" :
     return ChooseSubfolder("Other\Disc", destination)


 Case    "fnt"    
       , "fon"    
       , "otf"    
       , "ttf" :
     return ChooseSubfolder("Other\Fonts", destination)
 Case    "bak"    
       , "cab"    
       , "cfg"    
       , "cpl"    
       , "cur"    
       , "dll"    
       , "dmp"    
       , "drv"    
       , "ico"    
       , "ini"    
       , "lnk"    
       , "msi"    
       , "sys"    
       , "tmp" :
     return ChooseSubfolder("Programming\Database", destination)

 Default:
     return ChooseSubfolder("Other\uncategorized", destination)
 }
 
 
}

ChooseSubfolder(subfolderName, destination){
 path:=destination . "\" . subfolderName
;  MsgBox, SELECTED FOLDER IS: %path%
;  creates subfolders if is not created
 if !FileExist(path)
  FileCreateDir, %path%  
 return path
}


^!s::ExitApp
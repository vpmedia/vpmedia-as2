/*
 * Copyright the original author or authors.
 * 
 * Licensed under the MOZILLA PUBLIC LICENSE, Version 1.1 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *      http://www.mozilla.org/MPL/MPL-1.1.html
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import flash.net.FileReference;

import pl.milib.core.supers.MIBroadcastClass;

/**
 * @often_name fileRef
 * 
 * in html:
 * <?php
 * 	foreach ($_FILES as $fieldName => $file) {
 * 		echo move_uploaded_file($file['tmp_name'], "uploads/" .$folder . $file['name']);
 * 	}
 * ?>
 * 
 * @author Marek Brun 'minim'
 */
class pl.milib.tools.MIFileReference extends MIBroadcastClass {
	
	//MIFileReference_fileType_
	static public var fileType_Images:Object={id:'img', description: "Images", extension: "*.jpg;*.gif;*.png"};
	static public var fileType_FlashMovies:Object={id:'swf', description: "Flash Movies", extension: "*.swf"};
	static public var fileType_Documents:Object={id:'doc', description: "Documents", extension: "*.doc;*.pdf"};
	static public var fileType_Pdf:Object={id:'pdf', description: "Portable Document Format", extension: "*.pdf"};
	static public var fileType_Mp3:Object={id:'mp3', description: "MP3", extension: "*.mp3"};
	static public var fileType_Archive:Object={id:'zip', description: "Archive File", extension: "*.zip;*.rar;*.7z"};
	
	//Invoked when the user dismisses the file-browsing dialog box.
	public var event_Cancel:Object={name:'Cancel'};
	
	//Invoked when the upload or download operation has successfully completed.
	public var event_Complete:Object={name:'Complete'};
	
	//Invoked when an upload fails because of an HTTP error
	//DATA:	httpError:Number
	public var event_HTTPError:Object={name:'HTTPError'};
	
	//Invoked when an input/output error occurs.
	public var event_IOError:Object={name:'IOError'};
	
	//Invoked when an upload or download operation starts.
	public var event_Open:Object={name:'Open'};
	
	//Invoked periodically during the file upload or download operation.
	//DATA:	bl:Number //bytesLoaded
	//		bt:Number //bytesTotal
	public var event_Progress:Object={name:'Progress'};
	
	//Invoked when an upload or download fails because of a security error.
	//DATA: errorString:String
	public var event_SecurityError:Object={name:'SecurityError'};
	
	//Invoked when the user selects a file to upload or download from the file-browsing dialog box.
	public var event_Select:Object={name:'Select'};
	
	public var event_StartUploading:Object={name:'StartUploading'};
	
	//Invoked when upload or download operation has completed (successfully or not)
	//DATA:	Boolean //true - upload or download operation has successfully completed 
	public var event_Finish:Object={name:'Finish'}; 
	
	
	private var ref : FileReference;
	private var fileTypes : Array;
	private var uploadScriptURL : String;

	private var isUploading : Boolean;
	
	public function MIFileReference($ref:FileReference) {
		ref=$ref==null ? (new FileReference()) : $ref;
		ref.addListener(this);
	}//<>
	
	public function setupFileTypeNo(){ delete fileTypes; }//<<
	public function setupFileTypeOne(fileType_:Object){ fileTypes=[fileType_]; }//<<
	public function setupFileTypeGroup(fileType_s:Array){ fileTypes=fileType_s; }//<<
	/** @param extensions Array of String ex. ['as', 'fla', 'flv'] */
	public function setupFileTypeAddSelf(description:String, extensions:Array){
		for(var p=0;p<extensions.length;p++){
			extensions[p]='*.'+extensions[p];
		}
		setupFileTypeAdd({description:description, extension:extensions.join(';')});
	}//<<
	public function setupFileTypeAdd(fileType_:Object){
		if(!fileTypes){ fileTypes=[]; }
		fileTypes.push(fileType_);
	}//<<
	
	public function dbgInfoAboutFileTypes(){
		var allTypes=[];
		for(var p=0;p<fileTypes.length;p++){ allTypes.push(fileTypes[p].extension); }
		log('dbgInfoAboutFileTypes >'+allTypes.join('  '));
	}//<<
	
	public function dbgInfoCurrentSelectedFile(){
		log('dbgInfoCurrentSelectedFile >'+ref.name);
	}//<<
	
	/** Displays a file-browsing dialog box in which the user can select a local file to upload. */
	public function browse(): Boolean{
		return ref.browse(fileTypes);
	}//<<
	
	public function setupUploadScriptURL(uploadScriptURL:String){
		this.uploadScriptURL=uploadScriptURL;
	}//<<
	
	/** Starts the upload of a file selected by a user to a remote server. */
	public function upload(): Boolean{
		if(!uploadScriptURL){ logError_UnexpectedSituation(arguments, "!uploadScriptURL", "There is no upload script URL. See setupUploadScriptURL method."); return null; }
		isUploading=ref.upload(uploadScriptURL);
		if(isUploading){
			logHistory('upload to script:'+uploadScriptURL+' file>'+ref.name);
			bev(event_StartUploading);
		}
		return isUploading;
	}//<<
	
	public function getFileName(Void):String{ return ref.name; }//<<	public function getFileExtension(Void):String{ return ref.name.substr(ref.name.lastIndexOf('.')+1); }//<<
	
	static public function getFileTypeByID(id:String):Object {
		switch(id){
			case 'img': return fileType_Images; break;
			case 'swf': return fileType_FlashMovies; break;
			case 'doc': return fileType_Documents; break;
			case 'pdf': return fileType_Pdf; break;			case 'mp3': return fileType_Mp3; break;
		}
	}//<<
	
	public function gotSelected(Void):Boolean { return Boolean(ref.name.length>1); }//<<
	
	public function getIsUploadinhg(Void):Boolean { return isUploading; }//<<
	
//****************************************************************************
// EVENTS for MIFileReference
//****************************************************************************
	private function onCancel(file) { bev(event_Cancel); }//<<
	
	private function onComplete(file) {
		bev(event_Complete);
		isUploading=false;
		bev(event_Finish, true);
	}//<<
	
	private function onHTTPError(file, errorCode:Number) {
		logError_UnexpectedSituation(arguments, "HTTPError; file name>"+ref.name+" errorCode>"+errorCode);
		bev(event_HTTPError, {errorCode:errorCode});
		isUploading=false;
		bev(event_Finish, false);
	}//<<
	
	private function onIOError(file) {
		logError_UnexpectedSituation(arguments, "IOError; file name>"+ref.name);
		bev(event_IOError);
	}//<<
	
	private function onOpen(file) { bev(event_Open); }//<<
	
	private function onProgress(file, bytesLoaded:Number, bytesTotal:Number) {
		bev(event_Progress, {bl:bytesLoaded, bt:bytesTotal}); 
	}//<<
	
	private function onSecurityError(file, errorString:String) {
		logError_UnexpectedSituation(arguments, "SecurityError; file name>"+ref.name+' errorString>'+errorString);
		bev(event_SecurityError, {errorString:errorString});
		isUploading=false;
		bev(event_Finish, false); 
	}//<<
	
	private function onSelect(file) { bev(event_Select); }//<<

}
/**
 * com.sekati.net.File
 * @version 1.0.3
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */
 
import com.sekati.core.CoreObject;
import com.sekati.events.Event;
import com.sekati.events.Dispatcher;
import com.sekati.utils.Delegate;

import flash.net.FileReference;

/**
 * File handler class for uploading and downloading files and FileReference Events.<br>
 * TODO Needs thorough testing to confirm event handling works properly.
 */
class com.sekati.net.File extends CoreObject {

	private var _this:File;
	private var _ref:FileReference;
	private var _listener:Object;
	public var _imageType:Object = {description: "Image Files", extension: "*.jpg;*.gif;*.png"};
	public var _textType:Object = {description:"Text Files", extension:"*.txt; *.rtf"};
	public var _docTypes:Object = {description: "Documents", extension: "*.pdf; *.doc; *.xls"};
	public var _webTypes:Object = {description: "Web Files", extension: "*.html; *.htm; *.xhtml; *.php; *.asp; *.aspx; *.cfm; *.xml; *.xsl; *.xslt; *.css; *.js; *.jsp"};
	public var _flashTypes:Object = {description: "Flash Files", extension: "*.swf; *.fla; *.as; *.flp; *.flv"};
	public var _audioTypes:Object = {description: "Audio Files", extension:"*.mp3, *.aiff, *.wav"};
	public var _videoTypes:Object = {description: "Video Files", extension: "*.mpg; *.mpeg; *.mp4; *.mov; *.qt; *.avi; *.wmv; *.asf"};
	public var _anyType:Object = {description: "All Files", extension:"*.*"};
	public var _allTypes:Array = [ _imageType, _textType, _docTypes, _webTypes, _flashTypes, _audioTypes, _videoTypes, _anyType ];
	// events to dispatch
	public var onSelectEVENT:String = "FILE_onSelect";
	public var onCancelEVENT:String = "FILE_onCancel";
	public var onOpenEVENT:String = "FILE_onOpen";
	public var onProgressEVENT:String = "FILE_onProgress";
	public var onCompleteEVENT:String = "FILE_onComplete";
	public var onHTTPErrorEVENT:String = "FILE_onHTTPError";
	public var onIOErrorEVENT:String = "FILE_onIOError";
	public var onSecurityErrorEVENT:String = "FILE_onSecurityError";

	/**
	 * Constructor
	 */
	public function File() {
		super( );
		_this = this;
		_listener = new Object( );
		_ref = new FileReference( );
		_ref.addListener( _listener );
		_listener.onSelect = Delegate.create( _this, onSelect );
		_listener.onCancel = Delegate.create( _this, onCancel );
		_listener.onOpen = Delegate.create( _this, onOpen );
		_listener.onProgress = Delegate.create( _this, onProgress );
		_listener.onComplete = Delegate.create( _this, onComplete );
		_listener.onHTTPError = Delegate.create( _this, onHTTPError );
		_listener.onIOError = Delegate.create( _this, onIOError );
		_listener.onSecurityError = Delegate.create( _this, onSecurityError );
	}

	/**
	 * prompt user to save a remote file
	 * @param url (String) url of remote file
	 * @param defaultName (String) optional default filename for remote file to be saved as.
	 * @return Boolean - success status of download
	 */
	public function download(url:String, defaultFileName:String):Boolean {
		return _ref.download( url, defaultFileName );
	}

	/**
	 * Displays a file-browsing dialog box for the user to select a file to upload.
	 * @param type (Array) optional array of allowed filetypes. If none is passed the _allTypes class array will be used.
	 * @return Boolean - true if the dialogue box was successfully displayed.
	 */
	public function browse(type:Array):Boolean {
		if (!type) type = _allTypes;
		return _ref.browse( type );	
	}

	/**
	 * Start a file upload (100mb max is supported by the FlashPlayer).
	 * Note: On some browsers, URL strings are limited in length. 
	 * Lengths greater than 256 characters may fail on some browsers or servers.
	 * @param url (String) the server url to upload file to.
	 * @param uploadDataField (String) optional field name that precedes the file data in the upload POST. The default is "Filedata".
	 * @param testUpload (Boolean) optional 0byte upload test for windows Flashplayer only. The default is false.
	 * @return Boolean - false if upload fails for any reason.
	 */
	public function upload(url:String, uploadDataFieldName:String, testUpload:Boolean):Boolean {
		if (!uploadDataFieldName) uploadDataFieldName = "Filedata";
		if (testUpload == undefined) testUpload = false;
		return _ref.upload( url, uploadDataFieldName, testUpload );
	}

	// FileReference getters
	
	/**
	 * file creation date
	 * @return Date
	 */
	public function get creationDate():Date {
		return _ref.creationDate;	
	}

	/**
	 * macintosh creator type of the file
	 * @return String
	 */
	public function get creator():String {
		return _ref.creator;	
	}

	/**
	 * date the file was last modified on local disk
	 * @return Date
	 */
	public function get modificationDate():Date {
		return _ref.modificationDate;	
	}

	/**
	 * the file name on local disk
	 * @return String
	 */
	public function get name():String {
		return _ref.name;	
	}

	/**
	 * the file size on local disk in bytes
	 * @return Number
	 */
	public function get size():Number {
		return _ref.size;	
	}

	/**
	 * the file type
	 * @return String
	 */
	public function get type():String {
		return _ref.type;	
	}

	// FileReference Event handlers	
	private function onSelect(file:FileReference):Void {
		trace( "onSelect: " + file.name );
		Dispatcher( new Event( onSelectEVENT, _this, {file: file} ) );
		/*
	    if(!file.upload("http://www.yourdomain.com/yourUploadHandlerScript.cfm")) {
	        trace("Upload dialog failed to open.");
	    }
	    */
	}

	private function onCancel(file:FileReference):Void {
		trace( "onCancel" );
		Dispatcher( new Event( onCancelEVENT, _this, {file: file} ) );
	}

	private function onOpen(file:FileReference):Void {
		trace( "onOpen: " + file.name );
		Dispatcher( new Event( onOpenEVENT, _this, {name: file.name} ) );
	}

	private function onProgress(file:FileReference, bytesLoaded:Number, bytesTotal:Number):Void {
		trace( "onProgress with bytesLoaded: " + bytesLoaded + " bytesTotal: " + bytesTotal );
		Dispatcher( new Event( onProgressEVENT, _this, {bytesLoaded: bytesLoaded, bytesTotal: bytesTotal} ) );
	}

	private function onComplete(file:FileReference):Void {
		trace( "onComplete: " + file.name );
		Dispatcher( new Event( onCompleteEVENT, _this, {file:file} ) );
	}

	private function onHTTPError(file:FileReference):Void {
		trace( "onHTTPError: " + file.name );
		Dispatcher( new Event( onHTTPErrorEVENT, _this, {name: file.name} ) );
	}

	private function onIOError(file:FileReference):Void {
		trace( "onIOError: " + file.name );
		Dispatcher( new Event( onIOErrorEVENT, _this, {name: file.name} ) );
	}	

	private function onSecurityError(file:FileReference, errorString:String):Void {
		trace( "onSecurityError: " + file.name + " errorString: " + errorString );
		Dispatcher( new Event( onSecurityErrorEVENT, _this, {name: file.name, errorString: errorString} ) );
	}
}
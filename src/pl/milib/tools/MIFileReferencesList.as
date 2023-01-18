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
import flash.net.FileReferenceList;

import pl.milib.core.supers.MIRunningClass;
import pl.milib.core.value.MINumberValue;
import pl.milib.data.info.MIEventInfo;
import pl.milib.tools.MIFileReference;

/**
 * @author Marek Brun 'minim'
 */
class pl.milib.tools.MIFileReferencesList extends MIRunningClass {

	public var event_Select:Object={name:'Select'};
	
	public var _progress : MINumberValue;
	private var refs : FileReferenceList;
	private var currentUploadedFile : MIFileReference;
	private var folder : String;
	private var filesToUpload : Number;
	private var fileType : Object;
	private var password : String;	public var phpFile : String;
	
	public function MIFileReferencesList(MIFileReference_fileType_:Object) {
		refs=new FileReferenceList();
		refs.addListener(this);
		_progress=(new MINumberValue(0, 0));
		fileType=MIFileReference_fileType_;
		
	}//<>
	
	public function reset(Void):Void {
		if(isRunning){ finish(); }
		_progress.v=0;
		refs=new FileReferenceList();
		refs.addListener(this);
	}//<<
	
	public function setupFolder(password:String, folder:String):Void {
		this.folder=folder;		this.password=password;
	}//<<
	
	private function doStart(Void):Boolean {
		if(folder){
			if(!refs.fileList.length){ return false; } 
			filesToUpload=refs.fileList.length;
			_progress.v=0;
			logHistory('start upload '+filesToUpload+' files; folder>'+folder);
			return uploadNext();
		}else{
			logError_UnexpectedSituation(arguments, 'folder is not set; <b>folder</b>'+link(folder));
			return false;
		}
	}//<<
	
	private function doFinish(Void):Boolean {
		logHistory('upload files complete');
		return true;
	}//<<
	
	public function uploadAll():Void {
		start();
	}//<<
	
	private function uploadNext():Boolean {
		if(refs.fileList.length){
			var ref:FileReference=FileReference(refs.fileList.shift());
			currentUploadedFile=new MIFileReference(ref);
			currentUploadedFile.addListener(this);
			currentUploadedFile.setupUploadScriptURL(phpFile+'?pass='+password+'&folder='+folder+'&fileName='+currentUploadedFile.getFileName());
			currentUploadedFile.upload();
			return true;
		}else{
			_progress.v=1;
			finish();
			return false;
		}
	}//<<
	
	public function browse(Void):Void {
		if(isRunning){
			logError_UnexpectedSituation(arguments, 'you can\'t browse for new files while uploading');
			return;
		}
		refs.browse([fileType]);
	}//<<
	
	public function getFilestoLoadLength(Void):Number {
		return refs.fileList.length;
	}//<<

//****************************************************************************
// EVENTS for MIFileReferencesList
//****************************************************************************
	private function onEvent(ev:MIEventInfo) {
		//super.onEvent(ev);
		switch(ev.hero){
			case currentUploadedFile:
				switch(ev.event){
					case currentUploadedFile.event_Finish:
						_progress.v=1-refs.fileList.length/filesToUpload;
						uploadNext();
					break;
				}
			break;
		}
	}//<<Events
	
	private function onSelect(Void):Void {
		bev(event_Select);
	}//<<
	
	private function onCancel(Void):Void {
		
	}//<<
	
}
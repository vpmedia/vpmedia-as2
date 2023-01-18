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

import org.as2lib.env.reflect.Delegate;

import pl.milib.core.supers.MIBroadcastClass;

/**
 * @often_name milv
 * re-usable: no
 * 
 * TODO - apply using LoadObserver
 * 
 * @author Marek Brun 'minim'
 */
class pl.milib.tools.MILoadVars extends MIBroadcastClass {
	
	//Invoked when data has completely downloaded from the server or when an error occurs while data is downloading from a server.
	//DATA: src:String
	public var event_Data:Object={name:'Data'};
	
	//Invoked when Flash Player receives an HTTP status code from the server.
	public var event_HTTPStatus:Object={name:'HTTPStatus'};
	
	//Invoked when a LoadVars.load() or LoadVars.sendAndLoad() operation has ended.
	public var event_Load:Object={name:'Load'};
	
	private var loadVars : LoadVars;
	private var rawData : String;
	private var httpStatus : Number;
	private var getVars : Array;// of Array [0]varName, [1]value
	private var postVars : Array;// of Array [0]varName, [1]value
	private var loadVarsBack : LoadVars;
	private var url : String;
	private var isSended : Boolean;
	
	public function MILoadVars(scriptFileUrl:String) {
		this.url=scriptFileUrl;
		loadVars=new LoadVars();
		postVars=[]; 		getVars=[]; 
		isSended=false;
	}//<>
	
	public function addPOSTVar(varName:String, value:String){
		postVars.push([varName, value]);
	}//<<
	
	public function addGETVar(varName:String, value:String){
		getVars.push([varName, value]);
	}//<<
	
	public function startLoad(Void):Void{
		if(isSended){ logError_UnexpectedSituation(arguments, "that class is not reusable; alredy sended"); return; }
		isSended=true;
		var GETs:Array=[];
		for(var p=0;p<getVars.length;p++){ GETs.push(getVars[p].join('=')); }
		for(var p=0;p<postVars.length;p++){ loadVars[postVars[p][0]]=postVars[p][1]; }
		var completeUrl:String=url;
		if(GETs.length){ completeUrl+='?'+GETs.join('&'); }
		logHistory('send '+getVars.length+' GET vars('+link(getVars)+'), '+postVars.length+' POST vars('+link(postVars)+'), completeUrl>'+link(completeUrl));
		loadVarsBack=new LoadVars();
		loadVarsBack.onData=Delegate.create(this, onLoadVarsData); 
		loadVarsBack.onHTTPStatus=Delegate.create(this, onLoadVarsHTTPStatus); 
		loadVarsBack.onLoad=Delegate.create(this, onLoadVarsLoad);
		loadVars.sendAndLoad(completeUrl, loadVarsBack, "POST");
	}//<<
	
	public function getStatusText(Void):String{
		return getStatusTextByStatusNumber(httpStatus);
	}//<<
	
	public function dbgShowStatusText(Void):Void{
		log('dbgShowStatusText>'+getStatusTextByStatusNumber(httpStatus));
	}//<<
	
	public function dbgShowRawData(Void):Void{
		log('dbgShowRawData>'+rawData);
	}//<<
	
	public function getLoadedVar(varName:String):String{
		return loadVarsBack[varName];
	}//<<
	
	static public function getStatusTextByStatusNumber(httpStatus:Number):String{
		var httpStatusType:String;
		if(httpStatus<100){ httpStatusType = "flashError"; }
	    else if(httpStatus<200){ httpStatusType = "informational"; }
	    else if(httpStatus<300){ httpStatusType = "successful"; }
	    else if(httpStatus<400){ httpStatusType = "redirection"; }
	    else if(httpStatus<500){ httpStatusType = "clientError"; }
	    else if(httpStatus<600){ httpStatusType = "serverError"; }
		return httpStatusType;
	}//<<
	
	public function pasteSendDataToClippboard(Void):Void {
		var arr:Array=[];
		for(var p=0;p<getVars.length;p++){ arr.push('[GET] '+getVars[p].join('=')); }
		for(var p=0;p<postVars.length;p++){ arr.push('[POST] '+postVars[p].join('=')); }
		System.setClipboard('URL:'+url+'\n\n'+arr.join('\n--------------------\n'));
		logHistory('sended data pasted to clippboard');
	}//<<
	
//****************************************************************************
// EVENTS for MILoadVars
//****************************************************************************
	public function onLoadVarsData(src:String){
		rawData=src;
		loadVarsBack.decode(rawData);
		logHistory('onLoadVarsData rawData>'+link(rawData));
		bev(event_Data);
	}//<<
	
	public function onLoadVarsHTTPStatus(httpStatus:Number){
		this.httpStatus=httpStatus;
		logHistory('onLoadVarsHTTPStatus status>'+getStatusTextByStatusNumber(httpStatus));
		bev(event_HTTPStatus);
	}//<<
	
	public function onLoadVarsLoad(){
		bev(event_Load);
	}//<<
}
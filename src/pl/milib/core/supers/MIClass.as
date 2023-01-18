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

import pl.milib.core.Broadcastable;
import pl.milib.core.MIDeletable;
import pl.milib.core.MIDeleter;
import pl.milib.core.MIObjSoul;
import pl.milib.core.MISubscriber;
import pl.milib.dbg.DebuggableInstance;

/**
 * @author Marek Brun 'minim'
 */
class pl.milib.core.supers.MIClass implements MIDeletable, MISubscriber, DebuggableInstance {
	
	private var subscriptions : Array;//of Broadcastable	private var dbg : Object; //pl.milibdbg.InstanceDebugProvider
	static private var DBG_WIN_INI : String='variables';
	
	public function MIClass() {
		dbg=_global.pl.milib.dbg.InstanceDebugProvider.forInstance(this);
	}//<>
	
	public function getDeleter(Void):MIDeleter {
		return MIDeleter.forInstance(this);
	}//<<
	
	private function addDeletingSub(obj:MIDeletable):Void {
		MIDeleter.forInstance(this).addDeletingSub(obj);
	}//<<
	
	private function addDeletingSubs(objs:Array):Void {
		getDeleter().addDeletingsSub(objs);
	}//<<
	
	private function addDeleteWith(obj:MIDeletable):Void {
		obj.getDeleter().addDeletingSub(this);
	}//<<
	
	private function addDeleteTogether(obj:MIDeletable):Void {
		addDeletingSub(obj);
		addDeleteWith(obj);
	}//<<
	
	private function doDelete(Void):Void {
		for(var i=0,broadcaster:Broadcastable;i<subscriptions.length;i++){
			broadcaster=subscriptions[i];
			broadcaster.removeListener(this);
		}
		delete subscriptions;
	}//<<
	
	public function addSubscription(subscription:Broadcastable):Void {
		if(!subscriptions){ subscriptions=[]; }
		for(var i=0;i<subscriptions.length;i++){
			if(subscriptions[i]===subscription){ return; }
		}
		subscriptions.push(MIObjSoul.forInstance(subscription));
	}//<<
	
	public function removeSubscription(subscription:Broadcastable):Void {
		for(var i=0;i<subscriptions.length;i++){
			if(subscriptions[i]===subscription){ subscriptions.splice(i, 1); i--; }
		}
	}//<<
	
	public function getDebugContents(Void):Array {
		return dbg.getDebugContentsForMIClass();
	}//<<
	
	private function getDBGInfo(Void):Array {
		return [dbg.getDBGInfoforMIClass()];
	}//<<
	
	private function log(text:String):Void { dbg.log(text, arguments.caller); }//<<	private function logHistory(text:String):Void { dbg.logHistory(text, arguments.caller); }//<<
	private function logMethod(args:FunctionArguments, $text:String):Void { dbg.logMethod(args, $text); }//<<
	private function logError_UnexpectedArg(args:FunctionArguments, badArgNum:Number, $argsNames:Array, $errorText:String):Void { dbg.logError_UnexpectedArg(args, badArgNum, $argsNames, $errorText); }//<<	private function logError_UnexpectedSituation(args:FunctionArguments, errorText:String):Void { dbg.logError_UnexpectedSituation(args, errorText); }//<<
	
	public function logv(name:String, $value):Void { dbg.logv(name, $value); }//<<
	
	public function link(value):String{ return dbg.link(value); }//<<
	
	public function toString(Void):String { return link(this); }//<<
	
}
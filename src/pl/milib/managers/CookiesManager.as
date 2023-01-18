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

import pl.milib.core.supers.MIClass;
import pl.milib.data.IDObjectsHolder;
import pl.milib.util.MILibUtil;

/**
 * zajmuje się zarządzaniem ciasteczkami
 * 
 * @author Marek Brun 'minim'
 */
class pl.milib.managers.CookiesManager extends MIClass {
	
	private static var instance : CookiesManager;
	private var mc : MovieClip;
	private var cookies : IDObjectsHolder;
	
	/**
	 * @return singleton instance of CookiesManager
	 */
	static public function getInstance() : CookiesManager {
		if (instance == null)
			instance = new CookiesManager();
		return instance;
	}//<<
	
	private function CookiesManager() {
		mc=MILibUtil.getMCMILibMC(_root).createEmptyMovieClip('forCookiesManager', MILibUtil.getMCMILibMC(_root).getNextHighestDepth());
		mc.onUnload=MILibUtil.createDelegate(this, onMCUnload);
		cookies=new IDObjectsHolder(this);
	}//<>
	
	private function getCookie_(name:String):SharedObject {
		if(!cookies.isAddedID(name)){
			addCookie(name);
		}
		return cookies.getObjectByID(name);
	}//<<
	
	private function addCookie(name:String):Void {
		var so:SharedObject=SharedObject.getLocal(name);
		cookies.addObject(so, name);
	}//<<
	
	private function removeCookie_(name:String):Void {
		cookies.delObject(cookies.getObjectByID(name));
	}//<<
	
	static public function getCookie(name:String):SharedObject {
		return getInstance().getCookie_(name);
	}//<<
	
	static public function removeCookie(name:String):Void {
		getInstance().removeCookie_(name);
	}//<<
	
//****************************************************************************
// EVENTS for CookiesManager
//****************************************************************************
	private function onMCUnload():Void{
		var arr:Array=cookies.getAllObjects().concat();
		for(var i=0,so:SharedObject;so=arr[i];i++){
			so.flush();
		}
	}//<<
}
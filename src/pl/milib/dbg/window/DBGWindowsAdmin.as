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

import pl.milib.collection.MIObjects;
import pl.milib.core.supers.MIBroadcastClass;
import pl.milib.core.value.MIValue;
import pl.milib.core.value.MIValueOwner;
import pl.milib.dbg.window.DBGWindow;

/**
 * @author Marek Brun 'minim'
 */
class pl.milib.dbg.window.DBGWindowsAdmin extends MIBroadcastClass implements MIValueOwner {
	
	private static var instance : DBGWindowsAdmin;
	private var windowsUIs : MIObjects; //of DBGWindowUI
	private var selectedWindow : MIValue;
	
	private function DBGWindowsAdmin() {
		windowsUIs=new MIObjects();
		selectedWindow=(new MIValue()).setOwner(this);
	}//<>
	
	private function regWindow(window:DBGWindow):Void {
		windowsUIs.addObject(window.ui);
	}//<<
	
	private function selectWindow(window:DBGWindow):Void {
		selectedWindow.v=window;
	}//<<
	
	/** @return singleton instance of DBGWindowsAdmin */
	public static function getInstance(Void):DBGWindowsAdmin {
		if (instance == null){ instance = new DBGWindowsAdmin(); }
		return instance;
	}//<<
	
//****************************************************************************
// EVENTS for DBGWindowsAdmin
//****************************************************************************
	public function onSlave_MIValue_ValueChange(val:MIValue, oldValue):Void {
		
	}//<<

}
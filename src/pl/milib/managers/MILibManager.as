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

import pl.milib.core.supers.MIBroadcastClass;
import pl.milib.core.supers.MIClass;
import pl.milib.util.MILibUtil;

/**
 * @author Marek Brun
 */
class pl.milib.managers.MILibManager extends MIBroadcastClass {
	
	private static var instance : MILibManager;
	private var contextMenu : ContextMenu;
	
	private function MILibManager() {
		MILibUtil.hideVariables(MIClass.prototype, ['dbg']);
		MILibUtil.preparePackagesBySearch();
		contextMenu=new ContextMenu();
		_root.menu=contextMenu;
		contextMenu.hideBuiltInItems();
		//addContextMenuItem(new ContextMenuItem("Powered by MILib", MILibUtil.createDelegate(this, onPressContextMenuItemPoweredByMILib), true));
		
	}//<>
	
	public function addContextMenuItem(contextMenuItem:ContextMenuItem):Void {
		contextMenu.customItems.unshift(contextMenuItem);
	}//<<
	
	/** @return singleton instance of MILibManager */
	public static function getInstance() : MILibManager {
		if(instance == null){ instance = new MILibManager(); }
		return instance;
	}//<<
	
//****************************************************************************
// EVENTS for MILibManager
//****************************************************************************
	private function onPressContextMenuItemPoweredByMILib(Void):Void {
		getURL('http://milib.minim.pl', '_blank');
	}//<<
	
}
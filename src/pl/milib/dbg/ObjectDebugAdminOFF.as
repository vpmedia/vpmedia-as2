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
import pl.milib.dbg.MIDBG;
import pl.milib.util.MILibUtil;

/**
 * @author Marek Brun 'minim'
 */
class pl.milib.dbg.ObjectDebugAdminOFF extends MIClass {

	private var obj : Object;
	private var window : Object;
	
	private function ObjectDebugAdminOFF(obj) {
		addDeleteWith(obj);
		this.obj=obj;
	}//<>
	
	public function openWindow(Void):Void {
		if(!window){ window=MIDBG.getInstance().getNewDBGClassWindow(obj); }
	}//<<
	
	static public function forInstance(obj:Object):ObjectDebugAdminOFF {
		var milibObjObj:Object=MILibUtil.getObjectMILibObject(obj);
		if(!milibObjObj.serviceByObjectDebugAdmin){ milibObjObj.serviceByObjectDebugAdmin=new ObjectDebugAdminOFF(obj); }
		return milibObjObj.serviceByObjectDebugAdmin;
	}//<<
	
}
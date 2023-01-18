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
import pl.milib.util.MILibUtil;

/**
 * Zajmuje sie przyznawaniem i pobieraniem unikalnego numeru identyfikacyjnego obiektu. 
 * 
 *  - SINGLETON
 * 
 * @author Marek Brun 'minim'
 */
class pl.milib.managers.ObjectsIdNumbersManager extends MIClass {
	
	private static var instance : ObjectsIdNumbersManager;
	private var countInstances : Number;
	
	private function ObjectsIdNumbersManager() {
		countInstances=1;
	}//<>
	
	public function getObjectIdNumber(obj:Object):Number {
		var objMilibObj:Object=MILibUtil.getObjectMILibObject(obj);
		if(!objMilibObj.idNumber){
			objMilibObj.idNumber=countInstances;
			countInstances++;
		}
		return objMilibObj.idNumber;
	}//<<
	
	/** @return singleton instance of InstancesIndexManager */
	public static function getInstance():ObjectsIdNumbersManager {
		if (instance == null) instance = new ObjectsIdNumbersManager();
		return instance;
	}//<<
}
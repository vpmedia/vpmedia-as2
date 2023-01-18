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

/**
 * data holder
 * 
 * @author Marek Brun 'minim'
 */
class pl.milib.core.MIObjSoul {
	
	public var o;
	
	public function MIObjSoul(obj:Object) {
		o=obj;
	}//<>
	
	public function deleteObject(Void):Void {
		o.__isDeleted__=true;
		delete o;
	}//<<
	
	static public function forInstance(obj):MIObjSoul {
		if(obj.__isDeleted__){ return null; }
		if(!obj.milibObject){
			obj.milibObject={};
			_global.ASSetPropFlags(obj, ['milibObject'], 1, true);
		} 
		var milibObj:Object=obj.milibObject;
		if(milibObj.soul){
			return milibObj.soul;
		}else{
			milibObj.soul=new MIObjSoul(obj);
			return milibObj.soul;
		}
	}//<<
	
}
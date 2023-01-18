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

/**
 * @often_name duplication
 * 
 * @author Marek Brun 'minim'
 */
class pl.milib.mc.MCDuplicaton extends MIClass {
	
	private var elementsName : String;
	private var ele0 : MovieClip;
	private var dupliationsCount : Number;
	
	/** @param elements Array of MovieClip */
	public function MCDuplicaton(ele0:MovieClip) {
		dupliationsCount=0;
		this.ele0=ele0;
		elementsName=ele0._name.substr(0, -1);
	}//<>
	
	public function getNewMC($isDepthByCount:Boolean):MovieClip {
		dupliationsCount++;
		if(ele0._parent[elementsName+dupliationsCount]){
			return ele0._parent[elementsName+dupliationsCount];
		}else{
			return ele0.duplicateMovieClip(
				elementsName+dupliationsCount,
				$isDepthByCount ? dupliationsCount : ele0._parent.getNextHighestDepth()
			);
		}
	}//<<
	
}
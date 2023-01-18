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
import pl.milib.mc.service.MIMC;

/**
 * @author Marek Brun 'minim'
 */
class pl.milib.mc.MCDropDownTitle extends MIBroadcastClass {

	public var mimc : MIMC;
	
	public function MCDropDownTitle(mc:MovieClip) {
		mimc=MIMC.forInstance(mc);
		mc.gotoAndStop(1);
	}//<>
	
	public function setData(data:Object):Void {
		mimc.mc.tfName.htmlText=data.title;
	}//<<
	
	public function setWidth(width:Number):Void {
		mimc.mc.bg._width=width;
	}//<<
	
}
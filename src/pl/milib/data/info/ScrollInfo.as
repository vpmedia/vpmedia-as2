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

/**
 * data standard
 * 
 * @often_name scrollData
 * 
 * @author Marek Brun 'minim'
 */
class pl.milib.data.info.ScrollInfo extends MIBroadcastClass {
	
	public var total:Number;
	public var visible:Number;
	public var scrollN01:Number;
	public var invisible : Number;
	public var visibleN01 : Number;
	public var invisibleN01 : Number;
	
	public function ScrollInfo(total:Number, visible:Number, scrollN01:Number){
		this.total=total;
		this.visible=visible;
		this.scrollN01=scrollN01;
		invisible=total-visible;
		visibleN01=visible/total;		invisibleN01=invisible/total;
	}//<>
	
}

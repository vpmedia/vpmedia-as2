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

import flash.geom.Rectangle;

import pl.milib.data.ScrollableArray;
import pl.milib.mc.MCList;
import pl.milib.mc.MCListOwner;
import pl.milib.mc.MCScroller;
import pl.milib.mc.service.MIMC;

/**
 * @author Marek Brun 'minim'
 */
class pl.milib.mc.MCListWithScroller extends MCList {

	private var scrollerMC : MCScroller;
	private var mimc2 : MIMC;
	
	public function MCListWithScroller(owner:MCListOwner, mc:MovieClip, $scrlArr:ScrollableArray) {
		super(owner, MIMC.forInstance(mc).g('list'), $scrlArr);
		mimc2=MIMC.forInstance(mc);
		scrollerMC=new MCScroller(mimc2.g('scroller'));
		if($scrlArr){ scrollerMC.setScrolledObject($scrlArr); }
		setupScroller(scrollerMC);
		setWidth(mimc2.mc._width);		setHeight(mimc2.mc._height);
	}//<>
	
	public function setWidth(width:Number):Void {
		scrollerMC.mimc.mc._x=width-scrollerMC.getBreadth();
		super.setWidth(width-scrollerMC.getBreadth());
		area.setWidth(width);
	}//<<
	
	public function setHeight(height:Number):Void {
		scrollerMC.length=height;
		super.setHeight(height);
	}//<<
	
	public function getRectangle(Void):Rectangle {
		return (new Rectangle(0, 0, mc_bg._width+scrollerMC.getBreadth(), mc_bg._height));
	}//<<
	
}
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
import pl.milib.mc.service.MIMC;

/**
 * @often_name *MCSXYAligner 
 * 
 * @author Marek Brun 'minim'
 */
class pl.milib.mc.MCSXYAligner extends MIClass {
	
	public var mimc : MIMC;
	private var ele0MC : MovieClip;
	private var distX : Number;
	private var distY : Number;
	private var xLength : Number;
	private var mimcEle0Parent : MIMC;
	private var prefixName : String;
	
	public function MCSXYAligner(ele0MC:MovieClip, eleXMC:MovieClip, eleYMC:MovieClip, xLength:Number) {
		this.ele0MC=ele0MC;
		mimcEle0Parent=MIMC.forInstance(ele0MC._parent);
		distX=eleXMC._x-ele0MC._x;
		distY=eleYMC._y-ele0MC._y;
		eleXMC.unloadMovie();
		eleYMC.unloadMovie();
		this.xLength=xLength;
		prefixName=ele0MC._name.substr(0, -1);
		
		render();
	}//<>
	
	public function render():Void {
		var eleMCS:Array=mimcEle0Parent.getMCS(prefixName);
		for(var i=0,eleMC:MovieClip;i<eleMCS.length;i++){
			eleMC=eleMCS[i];
			eleMC._x=(i%xLength)*distX;
			eleMC._y=int(i/xLength)*distY;
		}
	}//<<

}
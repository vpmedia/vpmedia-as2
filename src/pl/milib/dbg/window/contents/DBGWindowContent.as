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

import pl.milib.data.info.WidthAndHeightInfo;
import pl.milib.dbg.window.DBGWindow;
import pl.milib.mc.abstract.AbstractContentMCA;

/**
 * @author Marek Brun 'minim'
 */
class pl.milib.dbg.window.contents.DBGWindowContent extends AbstractContentMCA {
	
	/*abstract*/ public var name:String;
	/*abstract*/ public function getTitle(Void):String { return null; }//<<
	/*abstract optional*/ public function setWidthAndHeight(width:Number, height:Number):WidthAndHeightInfo { return new WidthAndHeightInfo(width, height); }//<<
	/*abstract optional*/ public function setupDbgWindow(dbgWindow:DBGWindow):Void {}//<<
	
	public function getName(Void):String { return name; }//<<
	public function setName(name:String):Void { this.name=name; }//<<
	
}
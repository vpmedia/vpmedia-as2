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

import pl.milib.mc.buttonViews.ButtonViewFourFrames;
import pl.milib.mc.service.MITextField;

/**
 * @author Marek Brun 'minim'
 */
class pl.milib.mc.buttonViews.ButtonViewFourFramesOfTextField extends ButtonViewFourFrames {

	public var mitf : MITextField;

	public function ButtonViewFourFramesOfTextField(mc:MovieClip) {
		super(mc);
		mitf=mimc.getMITextField('tf');
	}//<>
	
	private function gotoFrame(frame:Number):Void {
		var text:String=mitf.tf.text;
		super.gotoFrame(frame);
		mitf=mimc.getMITextField('tf');
		mitf.tf.text=text;
	}//<<
	
}
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
import pl.milib.data.info.MIEventInfo;
import pl.milib.mc.service.MITextField;

/**
 * @author Marek Brun 'minim'
 */
class pl.milib.mc.InputTFWithIniText extends MIClass {

	public var mitf : MITextField;
	private var iniText : String;
	
	public function InputTFWithIniText(tf:TextField) {
		iniText=tf.htmlText;
		mitf=MITextField.forInstance(tf);
		mitf.addListener(this);
	}//<>
	
	public function getGotText(Void):Boolean {
		if(mitf.getGotFocus() && mitf.text==''){
			return false;
		}else{
			return mitf.tf.htmlText!=iniText;
		}
	}//<<
	
	public function getIsMail(Void):Boolean {
		var text = mitf.tf.text;
		var okChars = "1234567890-_abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ.@";
		var count = 0;
		while(count < text.length) {
			if (okChars.indexOf(text.substr(count, 1)) == -1) {
				return false;
			}
			count++;
		}
		if((text.indexOf("@") > 0) && (text.indexOf("@") == text.lastIndexOf("@"))) {
			if(((text.lastIndexOf(".") > text.indexOf("@")) && (text.lastIndexOf(".") < (text.length - 1))) && ((text.lastIndexOf(".") - text.indexOf("@")) > 1)) {
				return true;
			}
		}else{
			return false;
	 	}
	}//<<
	
	public function setIniText(Void):Void {
		mitf.tf.htmlText=iniText;
	}//<<
	 
//****************************************************************************
// EVENTS for InputTFWithIniText
//****************************************************************************
	private function onEvent(ev:MIEventInfo) {
		//super.onEvent(ev);
		switch(ev.hero){
			case mitf:
				switch(ev.event){
					case mitf.event_SetFocus:
						if(mitf.tf.htmlText==iniText){
							mitf.tf.text='';
						}
					break;
					case mitf.event_KillFocus:
						if(mitf.tf.text==''){
							mitf.tf.htmlText=iniText;
						}
					break;
				}
			break;
		}
	}//<<Events
}
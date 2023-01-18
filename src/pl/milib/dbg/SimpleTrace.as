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



/** @author Marek Brun 'minim' */
class pl.milib.dbg.SimpleTrace{
	
	private static var instance : SimpleTrace;
	private var mc : MovieClip;
	private var tf : TextField;
	private var text : String;
	private var texts : Array;
	
	
	private function SimpleTrace() {
		mc=_root.createEmptyMovieClip('SimpleTraceMC', _root.getNextHighestDepth());
		mc.createTextField('pole', 1, 10, 10, 400, 600);
		tf=TextField(mc.pole);
		tf.setNewTextFormat(new TextFormat('Andale Mono', 10, 0x000000));
		tf.background=true;
		tf.border=true;
		tf.html=true;
		Key.addListener(this);
		
		_root.simpleTrace=this;
		
		texts=[];
		mc._visible=false;
		
		trace_('SimpleTrace started... to close/open <b>press Ctrl+I</b>');		
	}//<>
	
	public function trace_(text):Void{
		mc._visible=true;
		texts.push(random(2)+''+random(2)+random(2)+' '+text);
		texts=texts.splice(texts.length-300);
		tf.htmlText=texts.join('\n');
		tf._height=Math.min(400, tf.textHeight+20);
		tf.scroll=tf.maxscroll;
	}//<<
	
	static public function trace(text:String):Void{
		getInstance().trace_(text);
	}//<<
	
	/** @return singleton instance of SimpleTrace */
	static public function getInstance(Void):SimpleTrace {
		if (instance == null){ instance = new SimpleTrace(); }
		return instance;
	}//<<
	
//****************************************************************************
// EVENTS for SimpleTrace
//****************************************************************************
	public function onKeyDown():Void{
		var kc=Key.getCode();
		if(Key.isDown(Key.CONTROL) && kc==73 /*Ctrl+I*/){
			mc._visible=!mc._visible;
		}
	}//<<
}
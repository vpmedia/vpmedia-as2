/**
* ...
* @author F Boyle
* 
* * * The MIT License
* 
* Copyright (c) 2008 Fintan Boyle (www.fboyle.com)
* 
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
* 
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
* 
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
* 
*/

import mx.events.EventDispatcher;
import mx.utils.Delegate;

class com.fboyle.load.LoadSound {
	
	//declare the dispatchEvent, addEventListener and removeEventListener methods that EventDispatcher uses
 	function dispatchEvent() {};
 	function addEventListener() {};
 	function removeEventListener() {};
	
	private var soundURL:String;
	private var soundItem:Sound;
	private var container:MovieClip;
	private static var soundCount:Number = 0;
	private var soundID:String;
	
	public function LoadSound(dest_mc:MovieClip, file:String, id:String) {
		
		// send instance of self to the Event Dispatcher
		mx.events.EventDispatcher.initialize(this);
		soundID = id;
		soundURL = file;
		container = dest_mc;
		soundCount++;
		soundLoad();
		
	}
	
	//load the individual sound
	private function soundLoad():Void {	
		
		soundItem = new Sound();			
		preload();
		
	}
	
	//preloader for sound files
	private function preload():Void {		
		
		soundItem.onLoad = Delegate.create(this, onSoundLoaded);
		soundItem.loadSound(soundURL, false);//load sound without playing it		
		
		addPreloaderInfo();
		
	}
	
	private function addPreloaderInfo():Void {
		
		container.createEmptyMovieClip("soundLoad_" + LoadSound.soundCount , container.getNextHighestDepth());
		
		var here:Object = this;
		container["soundLoad_" + LoadSound.soundCount].onEnterFrame = function() {
			
			var percent:Number = Number((here.soundItem.getBytesLoaded()/here.soundItem.getBytesTotal())*100);
				
			var progressObject:Object = {
				target:here,
				type:'onSoundProgress'
			};
				
			progressObject.percentLoaded = percent;
			progressObject.file = here.soundURL;
			progressObject.id = here.soundID;
				
			here.dispatchEvent(progressObject);
				
			if (percent == 100) {
					
				var loadedObject:Object = {
					target:here,
					type:'onSoundLoaded'
				};
					
				loadedObject.loadSuccess = true;
				loadedObject.file = here.soundURL;
				loadedObject.id = here.soundID;
					
				here.dispatchEvent(loadedObject);	
				//sound is loaded	
				delete this.onEnterFrame
			}
			
		};
		
	}
	private function onSoundLoaded(ev:Object):Void {
		
		if(!ev){			
			
			var failObject:Object = {
				target:this,
				type:'onSoundLoaded'
			};
			
			failObject.loadSuccess = ev;
			failObject.file = soundURL;					
			
			this.dispatchEvent(failObject);	
		}
		
	}
}
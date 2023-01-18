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

class com.fboyle.load.LoadSwf extends MovieClip {
	
	//declare the dispatchEvent, addEventListener and removeEventListener methods that EventDispatcher uses
 	function dispatchEvent() {};
 	function addEventListener() {};
 	function removeEventListener() { };
	
	private var swfID:String;
	private static var count:Number = 0;
	
	public function LoadSwf(dest_mc:MovieClip, file:String, id:String) {
		
		// send instance of self to the Event Dispatcher
		mx.events.EventDispatcher.initialize(this);
		count++;
		swfID = id;
		preloadLOswf(dest_mc, file);
		
	}
	
	private function preloadLOswf(dest_mc:MovieClip, file:String):Void {
		
		_root.createEmptyMovieClip("loLoad_"+count, _root.getNextHighestDepth());
		
		var percent:Number = 0;
		var loading:Number = 0;
		var total:Number = 0;
		var here:Object = this;
		//adjust bar size according to percent loaded and remove the preloader once finished
		_root["loLoad_" + count].onEnterFrame = function() {
			
			here.loading = dest_mc.getBytesLoaded();
			here.total = dest_mc.getBytesTotal();
			here.percent = Number((here.loading / here.total) * 100);
				
			var progressObject:Object = {
				target:here,
				type:'onLoadProgress'
			};
				
			progressObject.percentLoaded = here.percent;
			progressObject.file = file;
			progressObject.id = here.swfID;
			
			here.dispatchEvent(progressObject);

			if (here.percent == 100) {
				//lo swf is now loaded
				var eventObject:Object = {
					target:here,
					type:'onSWFLoaded'
				};
				eventObject.id = here.swfID
				eventObject.file = file;
				
				here.dispatchEvent(eventObject);
				
				delete this.onEnterFrame
			}
			
		};
		dest_mc.loadMovie(file);
		
	}	
	
}
/**
* ...
* @author F Boyle 
* @blog www.fboyle.com
* 
* @usage Controls and monitors sequential loading of external resources in AS2
* 
* - based on an AS3 library written by Donovan Adams, which can be found here:
* 	http://blog.hydrotik.com/category/queueloader/ 
* 
* 
* The MIT License
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
* 
*/

import mx.events.EventDispatcher;
import mx.utils.Delegate;
import com.fboyle.load.LoadSwf;
import com.fboyle.load.LoadSound;
import com.fboyle.load.QueueLoaderEvent;

class com.fboyle.load.QueueLoader {
	
	//declare the dispatchEvent, addEventListener and removeEventListener methods that EventDispatcher uses
 	function dispatchEvent() {};
 	function addEventListener() {};
 	function removeEventListener() {};
	
	private var VERBOSE:Boolean = false; //for debug
	
	private var queuedItems : Array;
	private var isLoading:Boolean;
	private var currItem:Object;
	private var _currType:String;
	private var sound:LoadSound;
	private var swf:LoadSwf;
	private var _orig_length:Number;
	private var _listProgress:Number;
	
	public function QueueLoader() {
		// send instance of self to the Event Dispatcher
		mx.events.EventDispatcher.initialize(this);
		queuedItems = new Array();
	}
	
	public function addItemAt(url : String, targ : MovieClip, info : Object) : Void {	
		queuedItems.splice(queuedItems.length, 0, { url:url, targ:targ, info:info } );		
		_orig_length = queuedItems.length;	
	}
	
	
	//executes the loading sequence
	public function execute() : Void {
		isLoading = true;
		loadNextItem();	
	}
	
	private function loadNextItem():Void {		
		
		var i:Number = queuedItems.length;
		currItem = queuedItems.shift();	
			
		if (currItem.targ == "undefined") {	
			trace("load error");
		} else {
			_currType = "none";
			
			//if (currItem.url.indexOf(".jpg") > -1) _currType = "FILE_IMAGE";					
			if (currItem.url.indexOf(".jpg") > -1) _currType = "FILE_SWF";					
			if (currItem.url.indexOf(".png") > -1) _currType = "FILE_SWF";					
			if (currItem.url.indexOf(".swf") > -1) _currType = "FILE_SWF";					
			if (currItem.url.indexOf(".mp3") > -1) _currType = "FILE_MP3";
			
			switch (_currType) {
				
				case "FILE_IMAGE":
				case "FILE_SWF":
					
					swf = new LoadSwf(MovieClip(currItem.targ), currItem.url, currItem.info.id);
					swf.addEventListener('onSWFLoaded', Delegate.create(this, completeHandler));
					swf.addEventListener('onLoadProgress', Delegate.create(this, progressHandler));
					
					break;
				case "FILE_MP3":
					
					sound = new LoadSound(MovieClip(currItem.targ), currItem.url, currItem.info.slide_id);
					sound.addEventListener('onSoundLoaded',Delegate.create(this, completeHandler));
					sound.addEventListener('onSoundProgress', Delegate.create(this, progressHandler));
					
					break;
				default:
					if(VERBOSE) debug(">> loadNextItem() NO TYPE DETECTED! "+currItem);
			}
		}	
		
	}
		
	private function progressHandler(ev:Object):Void {
		
		if (VERBOSE) debug("progress: " + ev.file + " - " + ev.percentLoaded + " - "+ ev.id);
		
		var itemProgress:Object = {
			target:this,
			type:QueueLoaderEvent.ITEM_PROGRESS
		};
			
		itemProgress.file = ev.file;
		itemProgress.percent = ev.percentLoaded;
		itemProgress.id = ev.id;
			
		this.dispatchEvent(itemProgress);
		
		if (_orig_length > 1)
		{
			//splice will have shortened the array, plus 1 so we can add current item % to it / _orig_length
			_listProgress = ((queuedItems.length+1) / _orig_length) * 100;
			_listProgress = 100 - _listProgress;
			_listProgress = _listProgress + (itemProgress.percent / _orig_length);
		}else
		{
			_listProgress = itemProgress.percent;
		}
		
		var queueProgress:Object = {
			target:this,
			type:QueueLoaderEvent.QUEUE_PROGRESS
		};
			
		queueProgress.percent = _listProgress;
			
		this.dispatchEvent(queueProgress);
	
	}
		
		
	private function completeHandler(event:Object):Void {
		switch (_currType) {
			case "FILE_IMAGE":
			case "FILE_SWF":
				
				if(VERBOSE) debug(">>>>>>>>>>>  swf has loaded: "+ event.id);
				//dispatch event 'item_complete'
				var swfComplete:Object = {
					target:this,
					type:QueueLoaderEvent.ITEM_COMPLETE
				};
				swfComplete.file = event.file;
				swfComplete.id = event.id;
				
				this.dispatchEvent(swfComplete);
				
				isQueueComplete();
				break;
			case "FILE_MP3":
				
				if(VERBOSE) debug(">>>>>>>>>>>  mp3 has loaded: "+ event.id);						
				//dispatch event 'item_complete'
				var mp3Complete:Object = {
					target:this,
					type:QueueLoaderEvent.ITEM_COMPLETE
				};
				mp3Complete.file = event.file;
				mp3Complete.id = event.id;
			
				this.dispatchEvent(mp3Complete);
				
				isQueueComplete();
				break;
		}
    }
		
	private function isQueueComplete():Void {		
			
		if (queuedItems.length == 0) {	
			isLoading = false;
			if(VERBOSE) debug("dispatched event 'onQueueComplete'");
			//dispatch an event 'onQueueComplete'
			var completeObject:Object = {
				target:this,
				type:QueueLoaderEvent.QUEUE_COMPLETE
			};
				
			this.dispatchEvent(completeObject);
			
		} else {
			loadNextItem();
		}
		
	}
		
	private function debug(str:String):Void{
		trace(str);
	}
	
}
/*
 *This file is part of MovieClipCommander Framework.
 *
 *   MovieClipCommander Framework  is free software; you can redistribute it and/or modify
 *    it under the terms of the GNU General Public License as published by
 *    the Free Software Foundation; either version 2 of the License, or
 *    (at your option) any later version.
 *
 *    MovieClipCommander Framework is distributed in the hope that it will be useful,
 *    but WITHOUT ANY WARRANTY; without even the implied warranty of
 *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *    GNU General Public License for more details.
 *
 *    You should have received a copy of the GNU General Public License
 *    along with MovieClipCommander Framework; if not, write to the Free Software
 *    Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 */
 import iap.functionUtils.Delegate;

/**
* SoundItem - a sound item for a MovieClipCommander extention
* 
* @author IAP itzik arzoni (itzik.mcc@gmail.com)
*/
class iap.commander.extentions.SoundItem extends iap.app.extentions.AbstractLoader {
	/**
	* soundLoadDone - dispaches when the loading of the sound has finished
	*/
	static var EVT_SOOUND_LOAD_DONE:String = "soundLoadDone";
	/**
	* soundPlay - dispatches when the sound begin to play
	*/
	static var EVT_PLAY:String = "soundPlay";
	/**
	* soundStop - dispatches when the sound stops playing
	* {[B]abort[/B]: set to true, if the use aborted. false if the sound completed}
	*/
	static var EVT_STOP:String = "soundStop";

	
	private var __sound:Sound;
	private var __volume:Number;
	private var __pan:Number;
	private var __loops:Number;
	private var __savedPosition:Number;
	
	function init(id:String, loops:Number)	{
		createSoundObject();
//		if (__commander._params.getParam("volume") == undefined) {
//			__commander._params.setParamFromGlobal("volume", "defaultVolume");
//		}
//		if (__commander._params.getParam("pan") == undefined) {
//			__commander._params.setParamFromGlobal("pan", "defaultPan");
//		}
		__commander.addEventListener("paramChange", this);
		if (id != undefined) {
			attachAndPlaySound(id);
		}
		super.init();
	}
	
	/**
	* attach one sound and plays it
	* @param	id	the id of the sound from the library
	*/
	public function attachAndPlaySound(id:String, loops:Number) {
		__sound.attachSound(id);
		if (__sound.duration == undefined) {
			trace("~5ERROR: Unable to attach sound '"+id+"', in "+this+", operation ignored.");
		} 
		play(0, loops);
	}
	
	/**
	* loads the sound from external file
	* @param	fileName	fileName to load
	* @param	isStreaming	if set to true, the sound would be played as a stream
	*/
	function loadSound(fileName:String, isStreaming:Boolean) {
		var fileToLoad:String = getProperFileName(fileName);
		__sound.loadSound(fileToLoad, isStreaming);
	}
	
	/**
	* plays the sound
	* @param	offset	starts playing from a spesific offset
	* @param	loops	how many time to loop (undefined -no loop, 0 - infinite loop)
	*/
	public function play(offset:Number, loops:Number) {
		if (__sound.duration == undefined) {
			__commander.addClipEvent("onEnterFrame", this);
		} else {
			__loops = (loops == undefined)?0: loops;
			__sound.start(offset, loops);
			dispatchEvent(EVT_PLAY);
		}
	}
	
	public function unregisterService() {
		__sound.stop();
	}
	
	/**
	* stops the sound and dispatch "soundStop" event
	*/
	public function stop() {
		__sound.stop();
		dispatchEvent(EVT_STOP, {abort:true});
	}
	
	public function pause() {
		__savedPosition = __sound.getDuration();
		__sound.stop();
	}
	
	public function resume() {
		__sound.start(__savedPosition);
	}
	
	/**
	* creates the sound class instance
	* and register to its listeners
	*/
	private function createSoundObject() {
		__sound = new Sound(__clip);
		__sound.onLoad = Delegate.create(this, onLoad);
		__sound.onSoundComplete = Delegate.create(this, onSoundComplete);
	}
	
	
	//{ event handling:
	/**
	* delegation from the sound onLoad event
	*/
	private function onLoad() {
		dispatchEvent(EVT_SOOUND_LOAD_DONE);
	}
	
	/**
	* delegation from the sound onSoundComplete event
	*/
	private function onSoundComplete() {
		dispatchEvent(EVT_STOP, {abort:false});
	}
	
	private function onEnterFrame(evt:Object) {
		trace("stopping undefined sound");
		stop();
		__commander.removeClipEvent("onEnterFrame", this);
	}
	
	/**
	* paramChange method event listener
	* Handles these params:
	* 
	*/
	private function paramChange(evt:Object) {
	//	trace(this+" paramChange: "+[evt.name, evt.value]);
		switch(evt.name) {
			case "volume":
				__sound.setVolume(evt.value);
				break;
			case "pan":
				__sound.setPan(evt.value);
				break;
		}
	}
	//}
}

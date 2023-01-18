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


import iap.app.extentions.sequences.SequenceManager;
import iap.app.extentions.sequences.SequenceStep;
import iap.commander.extentions.Loader;
import iap.commander.extentions.Matrix;
import iap.commander.extentions.SoundItem;
import iap.commander.MovieClipCommander;

/**
* Sounds manager  extention for MovieClipCommander
* This extention enables you to load and manage playing of multiple sounds at ones or one at a time or by a defined sequence
* You can load a swf with all the sounds as linkages, or use the linbkages in the main SWF.
* It creates a movieclip for each sound item played (and delete it in the end) to have a specific control on each sound volume and pan
*
* main commands:
* 	loadSoundsSWF - to load a swf with all the sounds embeded with linkages
*	playSound - to play a sound with linkage. can be together with other sounds, or can stop all othe sounds.
* events:
* 	EVT_LOAD_COMPLETE - when the loading of the sounds SWF is completed
*	EVT_SOUND_ITEM_STOP - when the sound item stoped playing
* 
* @author IAP itzik Arzoni (itzik.mcc@gmail.com)
* @version 1
*/
class iap.commander.extentions.SoundManager extends iap.services.MovieClipService {
	/**
	* soundLoadComplete - dispatches when the loading of a SWF file is complete
	*/
	static var EVT_LOAD_COMPLETE:String = "soundsLoadComplete";
	/**
	* soundItemStop - dispatches when a sound item stoped playing.
	*/
	static var EVT_SOUND_ITEM_STOP:String = "soundItemStop";
		
	private var __sounds:Matrix;
	private var __loader:Loader;
	private var __sequential:Boolean;
	private var __sequence:SequenceManager;
	private var __sequencesCount:Number;
	private var __enabled:Boolean;
		
	function init(defaultVolume:Number, defaultPan:Number)	{
		__commander._params.getCreateParam("defaultVolume", (defaultVolume==undefined)?100:defaultVolume);
		__commander._params.getCreateParam("defaultPan", (defaultPan==undefined)?0:defaultPan);
		
		__sounds = Matrix(__commander.uniqueExtention("soundsMatrix", Matrix));
		__sounds.cellsTemplate("soundItem", "");
		__sounds.defineMatrix(1,40,0,0,0,0);
		__sounds.extentionsTemplate({sound:SoundItem});
		__sounds._autoDestroy = true;
		__sounds._autoMove = false;
		
		__sequence = SequenceManager(__commander.uniqueExtention("sequence", SequenceManager));
		__sequencesCount = 0;
		__commander.addEventListener(Matrix.EVT_MATRIX_CELL_ITERATION, this);
		__enabled = true;
	}
	
	/**
	* loads a SWF containing all your sounds as embeded linkages
	* @param	fileName	the neame of the SWF
	*/
	function loadSoundsSWF(fileName:String) {
		__loader = Loader(__commander.uniqueExtention("loader", Loader))
		__loader.loadClip(fileName);
		__commander.addEventListener(Loader.EVT_LOAD_COMPLETE, this);
	}
	
	/**
	* plays a sound.
	* @param	id	the linkage of the sound in the library
	* @param 	loops how many times to repeat playing the sound
	* @param 	volume	the volume of the sound
	* @param 	pan	the pan of the sound
	*/
	function playSound(id:String, loops:Number, volume:Number, pan:Number) {
		volume = (volume == undefined)? __commander._params.getNumber("defaultVolume"): volume;
		pan = (pan == undefined)? __commander._params.getNumber("defaultPan"): pan;
		if (__sequential) {
			this.stopAllSounds();
		}
		var cell:MovieClipCommander = __sounds.createNextCell({volume:volume, pan:pan});
		cell._commands.sound.attachAndPlaySound(id, loops);
		cell.addEventListener(SoundItem.EVT_STOP, this);
	}
	
	/**
	* plays a sequence of sounds one after another
	* @param	soundsArr	an array of linkages
	*/
	public function playSequentialSounds(soundsArr:Array) {
		_sequential = true;
		this.stopAllSounds();
		__sequence.defineSequence("soundSequence"+(++__sequencesCount));
		for (var i:Number = 0; i<soundsArr.length; i++) {
			__sequence.addSequenceStep(new SequenceStep(_name, "playSound", [soundsArr[i]], EVT_SOUND_ITEM_STOP));
		}
		__sequence.saveSequence();
		__sequence.run("soundSequence"+__sequencesCount);
	}
	
	/**
	* stop playing all the sounds
	*/
	public function stopAllSounds() {
		__sounds.iterate({command:"destroy"});
	}
	
	/**
	* sets the global volyume
	* effect all playing sounds
	*/
	public function setVolume(val:Number) {
		__commander._params.setParam("defaultVolume", val);
		__sounds.iterate({command: "setVolume", value:val});
	}
	
	/**
	* sets global pan
	* effects all playing sounds
	*/
	public function setPan(val:Number) {
		__commander._params.setParam("defaultPan", val);
		__sounds.iterate({command: "setPan", value:val});
	}

	/**
	* handleEvent method
	*/
	private function handleEvent(evt:Object) {
		//		trace(this+", handle event of type: "+evt.type);
		switch (evt.type) {
		case Loader.EVT_LOAD_COMPLETE:
			dispatchEvent(EVT_LOAD_COMPLETE);
			break;
		case SoundItem.EVT_STOP:
			__sounds.removeFromMatrix(evt.commander._params.getNumber("index"));
			dispatchEvent(EVT_SOUND_ITEM_STOP);
			break;
		case Matrix.EVT_MATRIX_CELL_ITERATION:
			switch (evt.command) {
			case "destroy":
				evt.cell._commands.sound.stop();
				__sounds.removeFromMatrix(evt.index);
				break;
			case "setVolume":
				evt.cell._params.setParam("volume", evt.value);
				break;
			case "setPan":
				evt.cell._params.setParam("pan", evt.value);
				break;
			}
		}
	}
	
	public function set _sequential(val:Boolean) {
		__sequential = val;
		if (val) {
			this.stopAllSounds();
		}
	}
	
	public function set _enabled(val:Boolean) {
		if (val != __enabled) {
			this.stopAllSounds();
			__enabled = val;
		}
	}
	
	public function get _enabled():Boolean {
		return __enabled;
	}
	
}

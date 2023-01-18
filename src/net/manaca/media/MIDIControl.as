import net.manaca.lang.BObject;

/**
 * MIDI控制器，用于控制一组声音的播放
 * @author Wersling
 * @version 1.0, 2006-6-10
 */
class net.manaca.media.MIDIControl extends BObject {
	private var className : String = "net.manaca.media.MIDIControl";
	private var _noteMap:Array = ["c","d","e","f","g","a","b","c1","d1","e1","f1","g1","a1","b1","c2"];
	private var _notes:Object;
	private var _switch:Object;
	public function MIDIControl() {
		super();
		initialize();
	}
	private function initialize():Void{
		_notes = new Object();
		_switch = new Object();
		for (var i : Number = 0; i < _noteMap.length; i++) {
			var _note:Sound = new Sound();
			_note.attachSound(_noteMap[i]);
			_notes[_noteMap[i]] = _note;
			_switch[_noteMap[i]] = false;
		}
	}
	/**
	 * 播放一个指定音符
	 */
	public function play(note:String):Void{
		if(!_switch[note]){
			_notes[note].start();
			_switch[note] = true;
		}
	}
	
	/**
	 * 停止播放一个指定音符
	 */
	public function stop(note:String):Void{
		//Tracer.debug('note: ' + note);
		_notes[note].stop();
		_switch[note] = false;
	}
}
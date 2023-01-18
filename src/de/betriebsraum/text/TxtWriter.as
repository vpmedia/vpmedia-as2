/**
 * TxtWriter.
 *
 * @author: Felix Raab, E-Mail: f.raab@betriebsraum.de, Url: http://www.betriebsraum.de
 * @version: 1.2
 */
 
 
import mx.events.EventDispatcher;
import mx.utils.Delegate;
 

class de.betriebsraum.text.TxtWriter {
	
	
	private var dispatchEvent:Function;
	public var addEventListener:Function;
	public var removeEventListener:Function;
	
	private var curTxt:String;
	private var intervalID:Number;
	private var gCount:Number;
	private var scrollListener:Object;		
	
	private var _targetField:Object;
	private var _scrolling:Boolean;	
	private var _effectType:String;
	private var _speed:Number;
	private var _directStart:Boolean;
	private var _stageUpdate:Boolean;
	private var _removeDir:String;
	private var _removeSpeed:Number;

	private var pTagStart:String; 
	private var pTagEnd:String;
	

	public function TxtWriter(field:Object) {
		
		EventDispatcher.initialize(this);
		
		_targetField = field;
		
		_effectType = "replace";
		_speed = 50;
		_directStart = false;
		_stageUpdate = false;			
		_removeDir = "left";
		_removeSpeed = 50;
		_scrolling = false;
		
		pTagStart = "[pause="; 
		pTagEnd = "]";
		clearInterval(intervalID);

	}
	
	
	/***************************************************************************
	// PRIVATE METHODS (NOT DOCUMENTED)
	***************************************************************************/
	private function addText(newTxt:String, startPos:Number):Void {		
	
		gCount = startPos;	
		intervalID = setInterval(Delegate.create(this, addLetter), _speed, newTxt, startPos);		
		if (_directStart) addLetter();
		
	}
	
	
	private function addLetter(newTxt:String, startPos:Number):Void {

		if (newTxt.substr(gCount, pTagStart.length) == pTagStart) {	

			var endIndex:Number = newTxt.indexOf(pTagEnd.substr(0, 1), gCount);
			var duration:Number = Number(newTxt.substr(gCount + pTagStart.length, endIndex-(gCount+pTagStart.length)));			

			gCount = endIndex + pTagEnd.length;
			this.pause(duration);
			return;
			
		}		
		
		_targetField.text += newTxt.substr(gCount, 1);		
		if (_stageUpdate) updateAfterEvent();
		
		gCount++;		
		if (gCount >= newTxt.length) effectComplete();
		
	}
	
	
	private function overwriteText(oldTxt:String, newTxt:String, removeText:Boolean):Void {
		
		gCount = 0;	
		intervalID = setInterval(Delegate.create(this, overwriteLetter), _speed, oldTxt, newTxt, removeText);		
		if (_directStart) overwriteLetter();
		
	}
	
	
	private function overwriteLetter(oldTxt:String, newTxt:String, removeText:Boolean):Void {		
			
		var oldLetter:String = oldTxt.substr(gCount, 1);
		var newLetter:String = newTxt.substr(gCount, 1);		

		if (newLetter !== oldLetter) _targetField.text = changeLetter(_targetField.text, gCount, newLetter);			
		if (_stageUpdate) updateAfterEvent();
		
		gCount++;	
		
		if (gCount >= newTxt.length) {

			if (!removeText) {
				_targetField.text = _targetField.text.substr(0, gCount);
				effectComplete();
			} else {
				clearInterval(intervalID);
				remove(newTxt.length, _targetField.text.length - 0);
			};			
			
		}			
		
	}
	
	
	private function changeLetter(str:String, pos:Number, letter:String):String {
	
		var strB:String = str.substr(0, pos);	
		var strA:String = str.substr(pos+1, str.length);	
		
		var finalStr:String = strB+letter+strA;
	
		return finalStr;
		
	}
	
	
	private function removeLetter(txt:String, pos1:Number, pos2:Number):Void {		
		
		if (_removeDir == "left") {		
			_targetField.text = txt.substr(0, pos1) + txt.substr(pos1+1+gCount, txt.length);				
		} else if (_removeDir == "right") {		
			_targetField.text = txt.substr(0, pos2-gCount) + txt.substr(pos2+1, txt.length);							
		}			

		if (pos2-gCount == pos1) effectComplete();	
		if (_stageUpdate) updateAfterEvent();
	
		gCount++;
		
	}	
	
	
	private function effectComplete():Void {
		
		clearInterval(intervalID);
		setScrolling(false);
		dispatchEvent({target:this, type:"onEffectComplete"}); 
		
	}
	
	
	private function checkPause(startTime:Number, duration:Number):Void {	
		
		if (getTimer() >= startTime + duration) {
			clearInterval(intervalID);
			dispatchEvent({target:this, type:"onPauseEnd"});
			addText(curTxt, gCount);				
		}	
			
	}
	
	
	private function setScrolling(mode:Boolean):Void {
		
		var field:Object = (typeof _targetField == "movieclip") ? _targetField.label : _targetField;
		
		if (mode) {
				
			scrollListener = new Object();
			scrollListener.onScroller = function() {
				field.scroll = field.maxscroll;
			}			
			
			field.addListener(scrollListener);
		
		} else {
		
			field.removeListener(scrollListener);		
		
		}
		
	}		
	
	
	/***************************************************************************
	// PUBLIC METHODS
	***************************************************************************/
	public function write(txt:String):Void {	
	
		clearInterval(intervalID);
		
		if (typeof txt !== "string") {
			trace("Text must be of type \"string\"!");
			return;
		}		
		
		curTxt = txt;		
		setScrolling(_scrolling);
		
		switch (_effectType) {
			
			case "add":			
				addText(curTxt, 0);				
				break;			
			case "replace":
				_targetField.text = "";
				addText(curTxt, 0);
				break;			
			case "overwrite":
				overwriteText(_targetField.text, curTxt, false);
				break;			
			case "overwriteAndRemove":
				overwriteText(_targetField.text, curTxt, true );
				break;
			
		}
		
	}		
	
	
	public function remove(from:Number, to:Number):Void {
		
		clearInterval(intervalID);		
		gCount = 0;	
		intervalID = setInterval(Delegate.create(this, removeLetter), _removeSpeed, _targetField.text, Math.min(from, to), Math.max(from, to));	
		if (_directStart) removeLetter();
		
	}

	
	public function pause(duration:Number):Void {
		
		if (_effectType == "overwrite" || _effectType == "overwriteAndRemove") {
			trace("Pauses are respected only with \"replace\" or \"add\" effectTypes!");
			return;
		}
		
		clearInterval(intervalID);		
		dispatchEvent({target:this, type:"onPauseStart"});		
		
		intervalID = setInterval(Delegate.create(this, checkPause), 10, getTimer(), duration);		
		
	}
		
	
	public function stop():Void {		
		
		clearInterval(intervalID);
		setScrolling(false);
		
	}
	
	
	public function getCleanText(txt:String):String {
		
		var cleanText:String = "";
		var i:Number = 0;
		
		while (i < txt.length) {
		
			if (txt.substr(i, pTagStart.length) == pTagStart) {	
				var endIndex:Number = txt.indexOf(pTagEnd.substr(0, 1), i);
				i = endIndex + pTagEnd.length; 	
				
				getCleanText();			
			}		
		
			cleanText += txt.substr(i, 1);
			i++;			
			
		}	
		
		return cleanText;
		
	}
		
	
	public function setPauseTags(startTag:String, endTag:String):Void {
		
		pTagStart = startTag;
		pTagEnd = endTag;		
		
	}
	
	
	/***************************************************************************
	// GETTER / SETTER
	***************************************************************************/
	public function set targetField(newField:Object):Void {	
		_targetField = newField;		
	}
	
	public function get targetField():Object {	
		return _targetField;
	}
	
	
	public function set scrolling(mode:Boolean):Void {		
		_scrolling = mode;		
	}	
	
	public function get scrolling():Boolean {		
		return _scrolling;		
	}	
	
	
	public function set effectType(newType:String):Void {				
		_effectType = newType;		
	}
	
	public function get effectType():String {				
		return _effectType;	
	}
	
	
	public function set speed(newSpeed:Number):Void {		
		_speed = newSpeed;		
	}
	
	public function get speed():Number {		
		return _speed;		
	}
	
	
	public function set directStart(mode:Boolean):Void {		
		_directStart = mode;		
	}
	
	public function get directStart():Boolean {		
		return _directStart;		
	}
	
		
	public function set stageUpdate(mode:Boolean):Void {		
		_stageUpdate = mode;		
	}
	
	public function get stageUpdate():Boolean {		
		return _stageUpdate;		
	}
	
	
	public function set removeDir(newDir:String):Void {	
		_removeDir = newDir;		
	}
	
	public function get removeDir():String {	
		return _removeDir;		
	}	
	
	
	public function set removeSpeed(newSpeed:Number):Void {	
		_removeSpeed = newSpeed;		
	}
	
	public function get removeSpeed():Number {	
		return _removeSpeed;		
	}	
	
	
}
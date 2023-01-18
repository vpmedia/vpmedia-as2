/**
 * PageHistory.
 *
 * @author: Felix Raab, E-Mail: f.raab@betriebsraum.de, Url: http://www.betriebsraum.de
 * @version: 1.0
 */ 


import mx.events.EventDispatcher;


class de.betriebsraum.utils.PageHistory {
	
	
	private var dispatchEvent:Function;
	public var addEventListener:Function;
	public var removeEventListener:Function;	
	
	private var _history:Array;
	private var _pos:Number;
	
	
	public function PageHistory() {
		
		init();
		
	}
	
	
	
	private function init():Void {
		
		_history = new Array();	
		_pos = -1;
		
		EventDispatcher.initialize(this);
		
	}	
	
	
	private function dispatch():Void {
		dispatchEvent({type:"onPageSet", target:this, pos:_pos, pid:_history[_pos]});
	}
	
	
	/***************************************************************************
	// Public Methods
	***************************************************************************/
	public function setPage(id:String):Void {
		
		_pos++;
		if (_pos != 0) _history = _history.slice(0, _pos);
		_history.push(id);
		dispatch();
		
	}
	
	
	public function getPageAt(pos:Number):String {
		return _history[pos];
	}
	
	
	public function gotoPrevPage():Void {
		
		if (_pos-1 < 0) return;		
		_pos--;	
		dispatch();		
		
	}
	
	
	public function gotoNextPage():Void {
		
		if (_pos+1 > _history.length-1) return;
		_pos++;
		dispatch();
		
	}
	
	
	public function gotoFirstPage():Void {
		
		_pos = 0;
		dispatch();
		
	}
	
	
	public function gotoLastPage():Void {
				
		_pos = history.length-1;
		dispatch();
				
	}
	
	
	public function gotoPage(pos:Number):Void {
		
		_pos = Math.max(0, Math.min(pos, history.length-1));
		dispatch();
		
	}
	
	
	/***************************************************************************
	// Getter/Setter
	***************************************************************************/
	public function get history():Array {
		return _history.slice(0);
	}
	
	
	public function get position():Number {
		return _pos;
	}
	
	
}
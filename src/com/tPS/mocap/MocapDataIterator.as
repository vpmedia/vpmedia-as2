import com.tPS.utils.Iterator;
import com.tPS.draw.Point;

/**
 * Mocap Data Iterator
 * 
 * Iterates through motion capture 
 * tracked coordinate XML Data
 * and returns actual coordinates 
 * for the particles
 * 
 * MocapData is generated as Textfile 
 * from AfterEffects and transformed 
 * to useable XML via the Mocap
 * XMLFormer_utility
 * 
 * @author tPS
 * @version 1
 */
class com.tPS.mocap.MocapDataIterator implements Iterator {
	
	private var _data:XML;
	private var _frame:Number;
	private var particleCount:Number;
	
	function MocapDataIterator( $data:XML ) {
		_data = validateData( $data );
	}
	
	/**
	 * INTERFACE	INTERFACE	INTERFACE	INTERFACE	INTERFACE	
	 * INTERFACE	INTERFACE	INTERFACE	INTERFACE	INTERFACE	
	 * INTERFACE	INTERFACE	INTERFACE	INTERFACE	INTERFACE	
	 */
	public function start() {
		trace(this + " ---> start" );
		reset();
	}
	
	/*
	 * get Current
	 * returns Object holding a Point Object for 
	 * every Particle of the Mocapdata 
	 */
	public function getCurrent() : Object {
		var current:Object = new Object();
		
		var i:Number = _data.childNodes.length;
		
		while( --i > -1 ){
			var x:Number = Number( _data.childNodes[i].childNodes[_frame].childNodes[0].attributes.v ) - 360;
			x = x * .85;
			var y:Number = Number( _data.childNodes[i].childNodes[_frame].childNodes[1].attributes.v ) - 488;
			y = y * .85;
			y = y * 1.094;
			current[_data.childNodes[i].attributes.name] = new Point( x, y );
		}
		
		return current;
	}

	public function iterate() : Void {
		if( !isLast() )	_frame ++;	
	}

	public function isLast() : Boolean {
		return ( _frame == _data.firstChild.childNodes.length - 1 );
	}
	
	
	
	/**
	 * BEHAVIOUR	BEHAVIOUR	BEHAVIOUR	BEHAVIOUR	BEHAVIOUR	
	 * BEHAVIOUR	BEHAVIOUR	BEHAVIOUR	BEHAVIOUR	BEHAVIOUR	
	 * BEHAVIOUR	BEHAVIOUR	BEHAVIOUR	BEHAVIOUR	BEHAVIOUR	
	 */
	private function validateData( $data:XML ) : XML {
		var tData:XML = new XML();
		var isValid:Boolean = true;
		
		/* check if all nodes have the same amount of frames */
		var totalFrames:Number = $data.firstChild.childNodes.length;
		var i:Number = $data.childNodes.length;
		
		while( --i > 0 ){
			var nd:XML = $data.childNodes[i];
			if( nd.childNodes.length != totalFrames ) {
				isValid = false; 
				trace( this + " ---> inputData is not Valid, particle " + i + " has the wrong amount of steps" );
				break;
			}
		}
		
		if( isValid ){
			trace( this + " ---> " + "successfully parsed Mocapdata,\r" +
			this + " ---> " + "a total amount of " + $data.childNodes.length + " particles\r" +
			this + " ---> " + "with " + totalFrames + " frames are imported");
			tData = $data;
			particleCount = $data.childNodes.length;
		}
		
		return tData;
	}
	
	
	private function reset() : Void {
		_frame = -1;
		iterate();
	}
	
	
	/**
	 * GETTER	SETTER	GETTER	SETTER	GETTER	SETTER	GETTER	SETTER	
	 * GETTER	SETTER	GETTER	SETTER	GETTER	SETTER	GETTER	SETTER	
	 * GETTER	SETTER	GETTER	SETTER	GETTER	SETTER	GETTER	SETTER	
	 */
	 
	 /*
	  * sets Data and resets iteration
	  */
	public function set data( $data:XML ) : Void {
		_data = $data;
		reset();
	}
	
	/*
	 * offsets current frame
	 */
	public function set frame( $frame:Number ) : Void {
		if( $frame < _data.firstChild.childNodes.length-1 ){
			_frame = $frame;
		}else{
			trace( this + " ---> set frame is out of scope, max is: " + _data.firstChild.childNodes.length-1 );
			_frame = _data.firstChild.childNodes.length-2;
		}		
	}
	
	public function get _particles() : Array {
		var particles:Array = [];
		var i:Number = _data.childNodes.length;
		while( --i > -1 ){
			particles.push( _data.childNodes[i].attributes.name );
		}
		return particles;
	}
	
	
	public function toString() : String {
		return "[MocapDataIterator]";
	}
	
	
}
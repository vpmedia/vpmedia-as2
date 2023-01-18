
/**
* A ring buffer is a stack with a fixed size.  
* 
* When the stack is full and new items are added, oldest entries are removed.
* 
* @author David Knape 
*/
class com.bumpslide.data.types.RingBuffer
{	
	private var mArray:Array;
	private var mBufferSize:Number;

	/**
	* Create new Stack with a maximum length (bufferSize)
	* 
	* @param	bufferSize
	*/
	function RingBuffer( bufferSize:Number ) {
		mArray = new Array();
		mBufferSize = bufferSize;
	}
	
	/**
	* return contents as array
	*/
	function getArray() {
		return mArray.concat();
	}
	
	/**
	* Returns number of items in the stack
	* 
	* @return
	*/
	function get length () : Number {
		return mArray.length;
	}
	
	/**
	* Remove item from top of the stack
	* 
	* @return
	*/
	function pop():Object {
		return mArray.pop();
	}
	
	/**
	* Add item to the stack
	* 
	* @param	value
	* @return
	*/
	function push( value:Object ) : Number {
		if(mBufferSize!=undefined && length>mBufferSize-1) {
			mArray.shift();			
		}		
		return mArray.push( value );
	}	
	
	/**
	* View contents as string
	* 
	* @return string
	*/
	function toString() : String {
		return mArray.toString();
	}
	
	/**
	* Here is a simple usage example
	*/
	static function demoTest() {		
		trace("RingBuffer Demo:");		
		var buf:RingBuffer = new RingBuffer( 4 );
		buf.push( 1 );
		buf.push( 2 );
		buf.push( 3 );
		buf.push( 4 );
		buf.push( 5 );
		buf.push( 6 );		
		trace( buf.toString() );	// outputs "3,4,5,6"
	}	
}
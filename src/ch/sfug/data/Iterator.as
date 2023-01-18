/**
 * an iterator that iterates over an array
 * @author loop
 */
class ch.sfug.data.Iterator {

	private var d:Array;
	private var i:Number;

	public function Iterator( data:Array) {
		d = data;
		reset();
	}

	/**
	 * returns true if the iterator has a next element
	 */
	public function hasNext(  ):Boolean {
		return i+1<d.length;
	}

	/**
	 * returns true if the iterator has a previous element
	 */
	public function hasPrevious(  ):Boolean {
		return i-1>=0;
	}

	/**
	 * returns the next element
	 */
	public function next(  ):Object {
		if( hasNext() ) {
			return d[ ++i ];
		} else {
			trace( "there is no next element in iterator" );
		}
	}

	/**
	 * returns the previous element
	 */
	public function previous(  ):Object {
		if( hasPrevious() ) {
			return d[ --i ];
		} else {
			trace( "there is no previous element in iterator" );
		}
	}

	/**
	 * resets the iterator
	 */
	public function reset(  ):Void {
		i = -1;
	}

	/**
	 * returns the current active object
	 */
	public function current(  ):Object {
		return d[ i ];
	}

	/**
	 * returns the index of the next element but will not got to the next element.
	 */
	public function nextIndex(  ):Number {
		return Math.min( i + 1, d.length );
	}

	/**
	 * returns the index of the previous element but will not got to the previous element.
	 */
	public function previousIndex(  ):Number {
		return Math.max( i - 1, -1 );
	}

	/**
	 * returns the index of the previous element but will not got to the previous element.
	 */
	public function currentIndex(  ):Number {
		return i;
	}

	/**
	 * sets the data to iterate over
	 */
	public function set data( data:Array ):Void {
		this.d = data;
	}

	/**
	 * returns the data to iterate over
	 */
	public function get data(  ):Array {
		return d;
	}


}
import ch.sfug.data.Iterator;

/**
 * @author loop
 */
class ch.sfug.data.LoopIterator extends Iterator {

	public function LoopIterator( data:Array ) {
		super(data);
	}

	/**
	 * returns true if the iterator has a next element
	 */
	public function hasNext(  ):Boolean {
		return true;
	}

	/**
	 * returns true if the iterator has a previous element
	 */
	public function hasPrevious(  ):Boolean {
		return true;
	}

	/**
	 * returns the next element
	 */
	public function next(  ):Object {
		if( super.hasNext() ) {
			return super.next();
		} else {
			// restarts the pointer
			i = -1;
			return super.next();
		}
	}

	/**
	 * returns the previous element
	 */
	public function previous(  ):Object {
		if( super.hasPrevious() ) {
			return super.previous();
		} else {
			i = d.length - 1;
			return d[ i ];
		}
	}

	/**
	 * returns true if the iterator is at the start - at element 0
	 */
	public function isAtStart(  ):Boolean {
		return i == 0;
	}

	/**
	 * returns true if the iterator is at the end - at element length-1
	 */
	public function isAtEnd(  ):Boolean {
		return i == d.length - 1;
	}

}
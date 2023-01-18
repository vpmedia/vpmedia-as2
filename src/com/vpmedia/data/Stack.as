/* See the IStack.as file first */

// Here we are delcaring a class now that will have the same methods
// defined in the IStack interface we have previously created.  The
// pre and post conditions are all the same, and have not been
// repeated here.
class com.darronschall.Stack implements com.darronschall.IStack {
	// private implementation detail, hide this from users!
	// We'll use the built in Array data type to implement
	// our stack.
	private var _array : Array;
	
	public function Stack() {
		_array = new Array();
	}
	
	public function pop() : Void {
		_array.pop();
	}
	
	public function push(o:Object) : Void {
		_array.push(o);
	}
	
	public function top() : Object {
		return _array[_array.length-1];
	}
	
	public function isEmpty() : Boolean {
		return (_array.length == 0);
	}
}
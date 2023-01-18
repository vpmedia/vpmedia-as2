/* Continuing with the Stack ADT example on my weblog, we will use an 
interface to define the ADT in ActionScript 2.0.  By using an interface,
we can guarantee that an object of type IStack has the proper Stack ADT
methods available.  Any implemention of the Stack ADT will use this
interface and be foreced to implement the methods declared here.  Additionally,
note that we're now getting into language-specific elements of the Stack, and
the ADT specification will be slightly modified to fit the language.  No longer
do we pass the stack in as a function parameter, instead we will use the "this"
reference to refer to the Stack instance that the method was invoked upon. */

// Note we're using the interface keyword here, NOT class
interface com.darronschall.IStack {
	// We can use a constructor that will be the same
	// as the "create" method in the ADT.  However, constructors
	// are NOT permitted in interfaces (you cannot create an instance
	// of an interface), so we need to define the constructor
	// in the implementation class.
	// post: 
	//		stack is not null
	//		isEmpty() == true
	
	// pre: stack has been created
	public function isEmpty() : Boolean;
	
	// pre: isEmpty() == false
	public function top() : Object;
	
	// pre: stack has been created
	// post: 
	//		top() == o
	//		isEmpty() == false
	public function push(o : Object) : Void;
	
	// pre: isEmpty() == false
	// post: The Stack Axiom is used to determine the contents of the stack
	public function pop() : Void;
	
	// We have no destroy function because the garbage collector will clean
	// up for us
	// post: stack is null
	
}
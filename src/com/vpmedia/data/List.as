class com.darronschall.List {
	// private variables to hold our data
	private var element:Object;
	private var next:List;
	
	// pre: none
	// post:
	//   Suppose l is the return value of construct.. then:
	// 1) l is a references to a newly created object
	// 2) l != nil
	// 3) first(l) = newElement
	// 4) rest(l) = oldList
	public static function construct(newElement:Object, oldList:List):List {
		var newList:List = new List();
		
		newList.element = newElement;
		newList.next = oldList;
		
		return newList;
	};

	// pre: aList != nil
	// post: none
	// returns the first element of aList
	public static function first(aList:List):Object {
		return aList.element;		
	};
	
	// pre: aList != nil
	// post: none
	// returns the list aList, minues the first element
	public static function rest(aList:List):List {
		return aList.next;
	};
	
	// The nil constant denotes an empty list 
	public static function get nil():List {
		return null;
	}

}
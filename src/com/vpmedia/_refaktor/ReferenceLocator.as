//
//  ReferenceLocator
//
//  Created by Rich Rodecker on 2006-07-14.
//  http://www.visible-form.com/blog/downloads/
//	
//	Stores a reference to any object as a string.
//	Useful for storing reference to functions returned from Delegate.create(), or Tween references...or anything really.
class ReferenceLocator {
	private static var instance = null;
	private var references:Array;
	private function ReferenceLocator () {
		references = new Array ();
	}
	public static function getInstance () {
		if (instance == null) {
			instance = new ReferenceLocator ();
		}
		return instance;
	}
	// new reference object needs two props: referenceName:String, referenceTo:Object
	// new reference object can also specify property 'overwrite', set to true will overwrite existing reference with the same name
	function addReference (newReference:Object):Boolean {
		if (newReference.referenceName == undefined) {
			return false;
		}
		if (newReference.referenceTo == undefined) {
			return false;
		}
		var existingRef = getReference (newReference.referenceName);
		if (existingRef != null && newReference.overwrite != true) {
			return false;
		}
		if (existingRef != null && newReference.overwrite == true) {
			deleteReference (existingRef.referenceName);
		}
		references.push ({referenceName:newReference.referenceName, referenceTo:newReference.referenceTo});
		return true;
	}
	//returns the object the given string refers to
	function getReference (refName:String):Object {
		for (var prop in references) {
			if (references[prop].referenceName == refName) {
				return references[prop].referenceTo;
			}
		}
	}
	//deletes a reference to an object.  if the second parameter is set to true,
	//it will delete both the string reference to the object, and the object itself.
	//if object is a movieclip, it will swap itself to the nextHighestDepth() of its parent and remove itself
	function deleteReference (refName:String, deleteObj:Boolean) {
		var num = references.length;
		for (var i = 0; i < num; i++) {
			var nextItem = references[i];
			if (nextItem.referenceName == refName) {
				if (deleteObj == true) {
					deleteObject (nextItem.referenceTo);
				}
				references.splice (i, 1);
				return;
			}
		}
	}
	function deleteObject (obj:Object) {
		if (typeof obj == "movieclip") {
			obj.swapDepth (obj._parent.getNextHighestDepth ());
			obj.removeMovieClip ();
		}
		else {
			delete obj;
		}
	}
}

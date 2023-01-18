import com.fear.core.CoreObject;

class com.fear.util.ObjectUtil extends CoreObject{
	//	Check whether the object can be seen.
	//	Loop thru the object, testing for member. if the member does not exist,
	//	this method will return false. if the member is hidden (via ASSetPropFlags),
	//	this method will return false.
	public static function isEnumerable(obj:Object, member:Object):Boolean{
		var i:String;
		for(i in obj){
			if(obj[i] == member){
				return true;	
			}
		}
		return false;
	}

	//	Modded from FlashCoders, this function will try to delete the object, 
	//	then restore it. It will report the success of the delete operation.
	public static function isDeletable(obj:Object):Boolean{
		var snapShot:Object = obj;
		var success:Boolean = false;
		delete(obj);
		if(isUndefined(obj)){
			success = true;
			obj = snapShot;
		}
		return success;
	}

	//	If this object is empty, return true. Otherwise, false.
	public static function isEmpty(obj:Object):Boolean{
		return isUndefined(obj);
	}

	//	Return the typeof the object.
	public static function getTypeOf(obj:Object):String{
		return typeof obj;
	}

	//	Return true if the object is typeof type.
	public static function isTypeOf(obj:Object, type:String):Boolean{
		return (getTypeOf(obj).toLowerCase() == type.toLowerCase());
	}

	//	Return true if the object is a primitive type.
	public static function isFlashPrimitive(obj:Object):Boolean{
		return (isTypeOf(obj, "number") || isTypeOf(obj, "boolean") || isTypeOf(obj, "string"));
	}

	//	If obj is an instance of classPtr or an instance of a classPtr subclass, return true.
	public static function isInstanceOf(obj:Object, classPtr:Function):Boolean{
		//	if the two args are exactly the same:
		if(obj === classPtr) return true;
		return (obj instanceof classPtr);
	}

	//	Make sure obj is not a subclass of classPtr, but a direct instance of it
	public static function isExplicitInstanceOf(obj:Object, classPtr:Function):Boolean{
		if(isInstanceOf(obj, classPtr)){
			if(isInstanceOf(obj.__proto__, classPtr) == false){
				return true;
			}
		}
		return false;
	}

	//	Return true if obj is defined, false otherwise
	public static function isSet(obj:Object):Boolean{
		return (obj != undefined && !isNull(obj));
	}

	public static function isEqual(a:Object, b:Object):Boolean{
		return (a == b);
	}


	//	Return true if obj is undefined, false otherwise
	public static function isUndefined(obj:Object):Boolean{
		return (obj == undefined);
	}

	//	Return true if obj is null, false otherwise
	public static function isNull(obj:Object):Boolean{
		return (obj == null);
	}


	//	Return true if obj is a Function, false otherwise
	public static function isFunction(obj:Object):Boolean{
		return (isTypeOf(obj, 'function'));
	}

	// invoke a method on an object
	//
	// optional 3rd argument should 
	// contain an array  whose elements 
	// are passed to the target function
	// as parameters
	public static function callMethod(obj:Object, methodName:String):Void
	{
		if(arguments[2] != undefined)
		{
			var args = arguments[2];
			obj[methodName].apply(obj, [args]);
		}
		else
		{
			obj[methodName].apply(obj, []);
		}
	}
}

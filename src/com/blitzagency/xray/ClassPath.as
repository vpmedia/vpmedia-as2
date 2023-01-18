/*
Copyright (c) 2005 John Grden | BLITZ

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
documentation files (the "Software"), to deal in the Software without restriction, including without limitation
the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and
to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions
of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO
THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

class com.blitzagency.xray.ClassPath
{
	/**
     * @summary check is an array that holds references to all the objects found in the initial registerPackage process.
	 * it's used in the checkExtended method to check for super relationships
	 */
	private static var check:Array;
	/**
     * @summary fullPath is what's returned when getFullPath is called.
	 */
	private static var fullPath:String;

	/**
	* Registers a package to be used with getClassName and getPath. If packageName is undefined, then _global is searched
	* with it's properties exposed, then the properties are reset to the original state.  This allows the user to simply
	* inspect all of global and all packages that might be in com or mx or anywhere else.
	*
	* @param a string describing a top level package to be registered, for
	example "mx" or "trimm"
	*/
	public static function registerPackage (packageName : String)
	{
		// this initializes the check array if this is the first instance of ClassUtilities
		if(check == undefined) check = [];

		// check to see if packageName is undefined
		if(packageName == undefined)
		{
			// add the enumerable properties of global for reseting after examination
			var unprotected:Array = [];
			for(var items:String in _global)
			{
				unprotected.push(items);
			}

			// make all properties enumerable
			_global.ASSetPropFlags(_global, null, 0, true);

			// start examination
			classPusher (_global);

			// protect global's props again
			_protect(_global, unprotected);
		}
		else
		{
			// examine just the package the user specified
			classPusher (_global[packageName], packageName);
		}

	}

	private static function _protect(package_obj:Object, unprotected:Array):Void
	{
		// First, hides all properties, then shows only the props in the unprotected array
		_global.ASSetPropFlags(package_obj, null, 1, true);
		_global.ASSetPropFlags(package_obj, unprotected, 0, true);

		// for some reason, on another project, I found that I still had to run this to protect these.
		_global.ASSetPropFlags(package_obj,["constructor", "__constructor__", "prototype", "__proto__"],1,true);
	}

	/**
	* Returns the short classname (ie without the package info) for an
	object or a constructor (Class).
	*
	* @param obj the obj to get the classname for
	* @return the classname if the object's class was previously correctly
	registered
	*/
	public static function getClassName (obj : Object):String
	{
		if (obj instanceof Function)
		{

			return obj["shortClassName"];
		}
		else
		{

		return obj.constructor["shortClassName"];
		}
	}



	/**
	* Returns the short classname (ie without the package info) for an
	object or a constructor (Class).
	*
	* @param obj the obj to get the classname for
	* @return the classname if the object's class was previously correctly
	registered
	*/
	public static function getLongClassName (obj : Object):String
	{
		if (obj instanceof Function)
		{

			return obj["className"];
		}
		else
		{

			return obj.constructor["className"];
		}
	}


	/**
	* Returns the complete classname including the package part, for the
	given object or constructor (Class).
	*
	* @param obj the obj to get the complete package name for
	* @return the complete package name if the object's class was
	previously correctly registered
	*/
	public static function getPath (obj : Object):String
	{
		if (obj instanceof Function)
		{
			return obj["className"];
		}
		else
		{
			return obj.constructor["className"];

		}
	}

	/**
	* Private helper function to look up all classes in a given package and
	tell them there own classname and
	* package name.
	*
	* @param node the object that corresponds to the given name for
	example _global["mx"]
	* @param name the starting package name, to start the recursion,
	eg "mx"
	*/
	private static function classPusher (node : Object, name : String)
	{
		// extName that looks to see if there was a name included.  If not, we ommit the "." and set the name correctly
		// If name is not defined, that means the user is searching all of _global
		var extName:String = name == undefined ? "" : name + ".";

		for (var childNode in node)
		{
			//if you have found an object that is a function and has a	constructor register it
			if (node[childNode] instanceof Function &&	node[childNode].constructor != null)
			{
				//_global.tt("adding classes ", extName + childNode);
				node[childNode]["className"] = extName + childNode;
				node[childNode]["shortClassName"] = childNode;
				check.push(node[childNode]);

				//else if it isnt a class object, but still an object,recurse it to find more objects.
			}
			else if (node[childNode] instanceof Object)
			{
			classPusher (node[childNode], extName + childNode);
			}
		}
	}
	/**
     * @summary checkProtoChain walks up the __proto__ chain to resolve the entire extended path of a class
	 *
	 * @param obj:Object - starting point
	 *
	 * @return nothing
	 */
	private static function checkProtoChain(obj:Object, extendedPath:Boolean, includePath:Boolean):Void
	{
		// className is added at the point when classPusher examines the packages.  if there's a name and proto, we continue
		if(obj.__proto__ != undefined && obj.__proto__.constructor["className"] != undefined)
		{
			var chk:Object = checkExtended(obj);
			var className:String = extendedPath || includePath ? chk.className : chk.shortClassName;
			fullPath = fullPath == "" ? className : fullPath + "." + chk.shortClassName;
			if(extendedPath) checkProtoChain(obj.__proto__, extendedPath);
		}
	}

	/**
     * @summary returns a string containing either the className, class path and name or fully extended class path
	 *
	 * @param obj:Object - object who's class name you want to resolve
	 * @param extendedPath:Boolean - return extended full class path
	 * @param includePath:Boolean - if extendedPath is false, then this flag is evaluated to see if you want the
	 * class package path included with the class name.
	 *
	 * exampe
	 * //this example has a glow filter which extends BitmapFilter and we want to see the full extended path
	 * import ClassUtilities;
	 * import flash.filters.GlowFilter;
	 * var glow:GlowFilter = new GlowFilter(0x00ff00,1,5,5,2,3,false,false);
	 * trace("protoChain full Path :: " + ClassUtilities.getFullPath(glow, true));
	 * //traces
	 * flash.filters.GlowFilter.BitmapFilter.Object
	 *
	 * //this example has a glow filter which extends BitmapFilter and we want to see the non-extended path
	 * import ClassUtilities;
	 * import flash.filters.GlowFilter;
	 * var glow:GlowFilter = new GlowFilter(0x00ff00,1,5,5,2,3,false,false);
	 * trace("protoChain full Path :: " + ClassUtilities.getFullPath(glow, false));
	 * //traces
	 * flash.filters.GlowFilter
	 *
	 * //this example has a glow filter which extends BitmapFilter and we want to see the full extended path
	 * import ClassUtilities;
	 * import flash.filters.GlowFilter;
	 * var glow:GlowFilter = new GlowFilter(0x00ff00,1,5,5,2,3,false,false);
	 * trace("protoChain full Path :: " + ClassUtilities.getFullPath(glow, false, false));
	 * //traces
	 * GlowFilter
	 *
	 * @return String containing either the className, class path and name or fully extended class path
	 */
	public static function getClass(obj:Object, extendedPath:Boolean, includePath:Boolean):String
	{
		fullPath = "";
		checkProtoChain(obj, extendedPath, includePath);

		// if fullPath is empty, then check type
		if(fullPath == "") fullPath = typeof(obj);
		return fullPath;
	}

	/**
     * @summary compares the __proto__ of the object sent in with the prototype of the objects in the check array.  If a match is
	 * found, then this is the direct super class of the object
	 *
	 * @param obj:Object
	 *
	 * @return Object containing 3 properties:
	 * extended:Boolean - whether or not it's extended
	 * className:String - className with path
	 * shortClassName:String - just the className
	 */

	public static function checkExtended(obj:Object):Object
	{
		// set to false initially
		var returnObj:Object = {extended:false};

		// loop through the check array
		for(var i:Number=0;i<check.length;i++)
		{
			// if the obj's __proto__ == check[i].prototype, this means this is the super class
			var extended = obj.__proto__ == check[i].prototype ? true : false;
			if(extended)
			{
				returnObj.extended = extended;
				returnObj.className = check[i]["className"];
				returnObj.shortClassName = check[i]["shortClassName"];
				return returnObj;
			}
		}

		return returnObj;
	}
}
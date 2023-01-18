/**
* Class: Extension
*
* Version: v1.0
* Released: 03 April, 2006
*
* System extension routines. Methods to extend existing Flash methods where they are inadequate or where such functionality does
* not exist.
*
* The latest version can be found at:
* http://sourceforge.net/projects/bnm-fc
* -or-
* http://www.baynewmedia.com/
*
* (C)opyright 2006 Bay New Media.
*
* This library is free software; you can redistribute it and/or
* modify it under the terms of the GNU Lesser General Public
* License as published by the Free Software Foundation; either
* version 2.1 of the License, or (at your option) any later version.
*
* This library is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
* Lesser General Public License for more details.
*
* You should have received a copy of the GNU Lesser General Public
* License along with this library (see "lgpl.txt") ; if not, write to the Free Software
* Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
*
*	Class/Asset Dependencies
* 		Extends: None
*		Requires: None
*		Required By: All classes
*		Required Data Sources: None
*		Required Assets:
*			None
*
*
* History:
*
* v1.0 [03/05/06]
* 	- first public version
*
*/
class com.bnm.fc.Extension {

	// __/ STATIC VARIABLES \_

	// __/ PUBLIC VARIABLES \_
	//parentClass (object, required) - A pointer to the class, movie clip, or object that created this class instance. May be required by
	//			some methods. Should always be set to ensure proper functioning.
	public var parentClass:Object=undefined;

	// __/ PRIVATE VARIABLES \_

	// __/ PUBLIC METHODS \__

	/**
	* Method: Extension
	*
	* Constructor method for the class.
	*
	* Parameters:
	* 	iniObj (object, optional) - An object containing reciprocal properties to the class instance. That is, each item in the object
	* 			will be assigned to an existing or new item in the class instance.
	* strict (boolean, optional) - if TRUE, items in initObj must both exist and be of the same type as the reciprocal items in the
	* 			class instance. Any items not matching this criteria is discarded.
	*
	* Returns:
	* 	object - A reference to the newly created class instance.
	*
	* See also:
	* <init>
	* <setDefaults>
	*/
	public function Extension (initObj:Object, strict:Boolean) {
		this.setDefaults();
		if (initObj<>undefined) {
			this.init(initObj);
		}// if
	}// constructor

	/**
	* Method: init
	*
	* Initializes class members by assigning reciprocal items in the parameter object to items in the class instance.
	*
	* Parameters:
	* 	iniObj (object, required) - An object containing reciprocal properties to the class instance. That is, each item in the object
	* 			will be assigned to an existing or new item in the class instance.
	* strict (boolean, optional) - if TRUE, items in initObj must both exist and be of the same type as the reciprocal items in the
	* 			class instance. Any items not matching this criteria is discarded.
	*
	* Returns:
	* 	bolean - FALSE if 'initObj' was not supplied.
	*
	* See also:
	* <Extension>
	*/
	public function init(initObj:Object, strict:Boolean):Boolean {
		if (initObj==undefined) {return (false);};
		for (var item in initObj) {
			if (strict) {
				if (xtypeof(initObj[item])==xtypeof(this[item])) {
					this[item]==initObj[item];
				} else {
					//rejected
				}// else
			} else {
				this[item]=initObj[item];
			}// else
		}// for
	}// init

	/**
	* Method: xtypeof
	*
	* An extended 'typeof' routine to detect more Flash object types than the standard 'typeof' function. This method evaluates both
	* primitive data types as well as class instances.
	*
	* Parameters:
	* 	itemRef (object reference, required) - The item to analyze. May be of any type.
	*
	* Returns:
	* 	string - A string name representation of the object type. The list includes:
	*
	* 			textfield - A text field or instance of a TextField object
	* 			textformat - An instance of a TextFormat object
	* 			button - A button instance or instance of a Button object
	* 			array - An array or instance of an Array object
	* 			xml - An instance of an XML object
	* 			xmlnode - An instance of an XMLNode object
	* 			loadvars - An instance of a LoadVars object
	* 			string - An instance of a String object
	* 			sound - An instance of a Sound object
	* 			color - An instance of a Color object
	* 			movieclip - A movie clip instance primitive type
	* 			boolean - A Boolean primitive type
	* 			number - A Number primitive type
	* 			function - A Function primitive type
	* 			object - A generic or unidentified object
	* 			undefined - Undefined (non-existent)
	*/
	public static function xtypeof(itemRef):String {
		if ((itemRef.text<>undefined) && (itemRef.text<>undefined) && (typeof(itemRef.setTextFormat)=='function')) {
			return('textfield');
		}// if
		if ((typeof(itemRef.useHandCursor)=='boolean') && (itemRef.text==undefined) && (typeof(itemRef)<>'movieclip')) {
			return ('button');
		}// if
		if ((typeof(itemRef.pop)=='function') && (typeof(itemRef.push)=='function') && (itemRef.length<>undefined)) {
			return ('array');
		}// if
		if (itemRef instanceof XML) {	return ('xml');	}
		if (itemRef instanceof XMLNode) {return ('xmlnode');}
		if (itemRef instanceof LoadVars) {return ('loadvars');}
		if (itemRef instanceof TextField) {	return ('textfield');	}
		if (itemRef instanceof TextFormat) {	return ('textformat');}
		if (itemRef instanceof Button) {return ('button');}
		if (itemRef instanceof String) {return ('string');}
		if (itemRef instanceof Sound) {	return ('sound');}
		if (itemRef instanceof Color) {return ('color');}
		if (itemRef instanceof Number) {return ('number');}
		return (typeof(itemRef));
	}//xtypeof

	/**
	* Method: stringToClipPath
	*
	* Converts a string representation of a dot-syntax path to a reference to the actual object, or undefined if the
	* object doesn't exist. This is useful when placing objects into specific paths on the stage or when checking for
	* the existence of objects using paths from external data sources.
	*
	* Parameters:
	* 	stringPath (string, required) - The dot-syntax string representation of the object to target.
	* 	thisRef (object reference, optional) - A reference to 'this' when using a relative reference.
	* 			If omitted, the 'parentClass' value is used instead. If 'parentClass' is not set, '_level0'
	* 			is used.
	*
	* Returns:
	* 	reference - A reference to the object specified, or undefined if the specified object can't be found.
	*
	*/
	public function stringToClipPath(stringPath:String, thisRef) {
		var currentRef;
		var pathString=new String(stringPath);
		if (thisRef<>undefined) {currentRef=thisRef;}
		else if (this.parentClass<>undefined) {currentRef=this.parentClass;}
		else {currentRef=_level0;};
		var pointer=currentRef;
		var pathParts:Array=new Array();
		pathParts=stringPath.split('.');
		var pathLength:Number=pathParts.length;
		for (var count:Number=0;count<pathLength;count++) {
			if ((count>0) && (pathParts[count]=='this')) {
				//if 'this' is found at any point beyond the first
				//delimiter, the path is incorrect.
				return (undefined);
			}// if
			//Skip any 'this' reference mentioned in the first path part
			if (pathParts[count]<>'this') {
				if (pathParts[count]=='_parent') {
					//Assign relative reference
					pointer=pointer._parent;
				} else {
					//Assign symbolic reference
					pointer=pointer[pathParts[count]];
				}// else
			}// if
		}// for
		return (pointer);
	}//stringToClipPath

	/**
	* Method: clipPathToString
	*
	* Creates a dot-syntax path string representation of a specified movie clip. This method produces the similar output as when
	* placing a movie clip reference directly into a trace statement. This is useful for storing target paths in external data sources
	* such as XML or databases.
	*
	* Parameters:
	* 	clipRef (movie clip, required) - The movie clip to evaluate.
	*
	* Returns:
	* 	string - A dot-syntax string representation of the movie clip nesting position. If the input parameter is not a movie clip
	* or is undefined, 'null' is returned;
	*
	*/
	public static function clipPathToString(clipRef:MovieClip):String {
		if ((clipRef==undefined) || (xtypeof(clipRef)<>'movieclip')) {return (null);}
		var outStr:String=new String(clipRef._name);
		var currentPath:MovieClip=clipRef;
		while (currentPath._parent<>undefined) {
			currentPath=currentPath._parent;
			var pathName:String=currentPath._name;
			if (pathName=='') {pathName='_root'};
			outStr=pathName+'.'+outStr;
		}// while
		return (outStr);
	}//refToString

	/**
	* Method: findFrame
	*
	* Attempts to find the frame number that corresponds to a frame name. This is accomplished by switching frames
	* and comparing the results. Because frame switching occurs, it may be advisable to hide the targetted clip
	* prior to invoking this method. It is currently impossible to find the specified frame if the target clip has only one
	* frame.
	*
	* Parameters:
	* 	frameName (string, required) - The frame name to search for.
	* 	clipRef (movie clip, required) - The movie clip to search through.
	*
	* Returns:
	* 	number - The frame number corresponding to the 'frameName' parameter. If only one frame is present
	* 				in the target clip, 1 is always returned. If no corresponding frame is found, -1 is returned. If input parameters
	* 				are invalid or missing, -2 is returned.
	*
	*/
	public static function findFrame (frameName:String, clipRef:MovieClip):Number {
		if ((frameName==undefined) || (frameName=='') || xtypeof(frameName)<>'string') {return (-2);}
		if ((clipRef==undefined) || (xtypeof(clipRef)<>'movieclip')) {return (-2);}
		if (clipRef._totalframes==1) {return (1);}
		var savedFrame:Number=clipRef._currentframe;
		//Only two frames are required to be switched for checking the position of the frame.
		clipRef.gotoAndStop(1);
		clipRef.gotoAndStop(frameName);
		var newFrame:Number=clipRef._currentframe
		if (newFrame<>1) {
			clipRef.gotoAndStop(savedFrame);
			return (newFrame)
		}//if
		clipRef.gotoAndStop(2);
		clipRef.gotoAndStop(frameName);
		newFrame=clipRef._currentframe
		if (newFrame<>2) {
			clipRef.gotoAndStop(savedFrame);
			return (newFrame)
		}//if
		clipRef.gotoAndStop(savedFrame);
		return (-1);
	}//findFrame

	/**
	* Method: alignToPixel
	*
	* Aligns the specified clip ot text field to the nearest whole pixel, as well as any child movie clips or text fields. This method
	* is useful tor preventing blurry edges on fonts sometimes found in Flash movies which are caused by alignment to
	* sub-pixels.
	*
	* Parameters:
	* 	clipRef (reference, required) - The movie clip or text field to align. All child movie clips and text fields will also
	* 			be aligned.
	* 	exclude (array, optional) - A numbered array holding all of the items already evaluated. This prevents cyclical references
	* 			(and infinite recursion) and will be created automatically if not specified. You may specify items directly within this
	* 			parameter by including references to the clips to be excluded in the numbered array.
	*
	* Returns:
	* 	Nothing.
	*
	* Note:
	* 	Specifying a movie clip that has more than 255 levels of nesting (child movie clips or text fields) will cause the Flash player
	* 	to hang because this will be considered an infinite recursive loop. If this is the case, consider including a child movie clip
	* 	as the first parameter instead. You may also call this method from any child clips directly in order to prevent this condition.
	*/
	public static function alignToPixel (clipRef, exclude:Array) {
		if (exclude==undefined) {
			exclude=new Array();
		} else {
			for (var item in exclude) {
				if (exclude[item]==clipRef) {
					return;
				}//if
			}//for
		}//else
		exclude.push(clipRef);
		clipRef._x=Math.round(clipRef._x);
		clipRef._y=Math.round(clipRef._y);
		for (var item in clipRef) {
			if ((typeof(clipRef [item])=='movieclip') || (clipRef [item].text<>undefined)) {
				alignToPixel(clipRef [item],exclude);
			}//if
		}// for
	}//alignToPixel

	// __/ PRIVATE METHODS \__

	/**
	* Method: setDefaults
	*
	* Creates required class members and assigns default values.
	*
	* Parameters:
	* 	None
	*
	* Returns:
	* 	Nothing
	*
	* See also:
	* <Extension>
	*/
	private function setDefaults() {

	}// setDefaults

}// Extension class
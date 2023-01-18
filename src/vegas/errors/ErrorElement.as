/*

  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at 
  
           http://www.mozilla.org/MPL/ 
  
  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
  for the specific language governing rights and limitations under the License. 
  
  The Original Code is Vegas Framework.
  
  The Initial Developer of the Original Code is
  ALCARAZ Marc (aka eKameleon)  <vegas@ekameleon.net>.
  Portions created by the Initial Developer are Copyright (C) 2004-2007
  the Initial Developer. All Rights Reserved.
  
  Contributor(s) :
  
*/

import vegas.core.CoreObject;
import vegas.core.IEquality;
import vegas.util.Comparater;
import vegas.util.ConstructorUtil;

/**
 * Base object for representing an errors.
 * @author eKameleon
 */
class vegas.errors.ErrorElement extends CoreObject implements IEquality 
{
    
	/**
	 * Creates a new ErrorElement instance.
	 */
	public function ErrorElement(thrower, methodName:String, args:Array, fileName:String, lineNumber:Number, isNative:Boolean) 
	{
		_args = args || null ;
		_fileName = fileName || null ;
		_lineNumber = lineNumber || null ;
		_isNative = isNative || null ;
		_methodName = methodName || null ;
		_thrower = thrower || null ;
	}
	
	/**
	 * Indicates whether some other object is "equal to" this one.
	 */
	public function equals(o):Boolean 
	{
		if (!o instanceof ErrorElement) 
		{
			return false ;
		}
		var b1:Boolean = o.getConstructorName() == getConstructorName()  ;
		var b2:Boolean = o.getConstructorPath() == getConstructorPath() ;
		var b3:Boolean = Comparater.compare(o.getArguments(), getArguments()) ;
		var b4:Boolean = o.getFileName() == getFileName() ;
		var b5:Boolean = o.getLineNumber() == getLineNumber() ;
		var b6:Boolean = o.getMethodName() == getMethodName() ;
		var b7:Boolean = o.getThrower() == getThrower() ;
		return b1 && b2 && b3 && b4 && b5 && b6 && b7 ;
	}
	
	/**
	 * Returns an array with parameters of the thrower method.
	 */
	public function getArguments():Array 
	{
		return _args ;
	}
	
	/**
	 * Returns the fully qualified name of the class containing the execution point represented by this stack trace element.
	 */
	public function getConstructorName():String 
	{
		return ConstructorUtil.getName(_thrower) ;
	}
	
	/**
	 * Returns the fully qualified path of the class containing the execution point represented by this stack trace element.
	 */
	public function getConstructorPath():String 
	{
		return ConstructorUtil.getPath(_thrower) ;
	}
	
	/**
	 * Returns the name of the source file containing the execution point represented by this stack trace element.
	 */
	public function getFileName():String 
	{
		return _fileName ;
	}
	
	/**
	 * Returns the line number of the source line containing the execution point represented by this stack trace element.
	 */
	public function getLineNumber():Number 
	{
		return _lineNumber ;
	}
	
	/**
	 * Returns the name of the method containing the execution point represented by this stack trace element.
	 */
	public function getMethodName():String 
	{
		return _methodName ;
	}
	
	/**
	 * Return the thrower object reference.
	 */
	public function getThrower() 
	{
		return _thrower ;
	}

	/**
	 * Returns true if the method containing the execution point represented by this stack trace element is a native method.
	 */
	public function isNativeMethod():Boolean 
	{
		return _isNative ;
	}
	
	/**
	 * Internal array parameters of the thrower method.
	 */
	private var _args:Array ;

	/**
	 * Internal file name.
	 */
	private var _fileName:String ;

	/**
	 * Internal line number.
	 */
	private var _lineNumber ;

	/**
	 * Internal value to represented is the trace is a native method.
	 */
	private var _isNative:Boolean ;

	/**
	 * The name of the method.
	 */
	private var _methodName:String ;

	/**
	 * The internal thrower.
	 */
	private var _thrower ;
	
}

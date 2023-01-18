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

/**
 * The {@code ConstructorUtil} utility class is an all-static class with methods for working with function constructor in AS2.
 * @author eKameleon
 */
class vegas.util.ConstructorUtil 
{
	
	/**
	 * Creates an returns a basic instance of the constructor function passed in argument.
	 * @param c the function constructor.
	 * @return a new instance of the specified constructor function.
	 */
	static public function createBasicInstance(c:Function) 
	{
		var i = {} ;
		i.__proto__ = c.prototype ;
		i.__constructor__ = c ;
		return i ;
	}
	
	/**
	 * Creates an instance of the constructor function passed in argument.
	 * This method launch the constructor of the class with all arguments in the {@code args} array.
	 * @param c the function constructor.
	 * @param args the array of all arguments to pass in the constructor of the new instance.
	 * @return a new instance of the specified constructor function.
	 */
	static public function createInstance(c:Function, args:Array) 
	{
		if (!c)
		{
			return null ;
		}
		var i = ConstructorUtil.createBasicInstance(c) ;
		c.apply(i, args) ;
		return i ;
	}

	/**
	 * Transforms and returns the reference of the visual object passed in argument. 
	 * The visual object are {@code MovieClip} and {@code TextField} class instances.
	 * @param c the function constructor to apply on the visual object.
	 * @param oVisual the {@code MovieClip} or {@code TextField} reference
	 * @param oInit an object to initialize the specified visual reference.
	 * @return the new reference transformed with the specified constructor. 
	 */
    static public function createVisualInstance(c:Function, oVisual, oInit) 
    {
    	oVisual.__proto__ = c.prototype ;
		if (oInit) 
		{
			for (var each:String in oInit) 
			{
				oVisual[each] = oInit[each] ;
			}
		}	
		c.apply(oVisual) ;   
		return oVisual ;
    }

	/**
	 * Returns the name string representation of the specified instance passed in arguments.
	 * @param instance the reference of the object to apply reflexion.
	 * @param scope the scope of the name to search more easily this name. 
	 */
	static public function getName(instance, scope):String 
	{
		var path:String = getPath(instance, scope) ;
		if (path == null)
		{
			return null ;
		}
		var p:Array = path.split(".") ;
		return p.pop() || null ;
	}

	/**
	 * Returns the package string representation of the specified instance passed in arguments.
	 * @param instance the reference of the object to apply reflexion.
	 * @param scope the scope of the name to search more easily this package. 
	 */
	static public function getPackage(instance, scope):String 
	{
		var path:String = getPath(instance, scope) ;
		if (path == null) 
		{
			return null ;
		}
		var package:Array = path.split(".") ;
		package.pop() ;
		return package.join(".") ;
	}

	/**
	 * Returns the full path string representation of the specified instance passed in arguments (package + name).
	 * @param instance the reference of the object to apply reflexion.
	 * @param scope the scope of the name to search more easily this path. 
	 */
	static public function getPath(instance, scope):String 
	{
		if (instance.__path__) 
		{
			return instance.__path__ ;
		}
		else 
		{

			var o = (typeof(instance)=="function") ? Function(instance).prototype : instance.__proto__ ;
			var callee:Function ;
			var find:Function = function( s:String, target ) 
			{
				for ( var prop:String in target )  
				{
					var current:Function = target[prop] ;
					if ( current.__constructor__ === Object ) 
					{
						prop = callee( s + prop + ".", current );
						if ( prop ) 
						{
							return prop ;
						}
					}
					else if ( current.prototype === o ) 
					{
						return s + prop ;
					}
				}
			};
			
			callee = find ;
			
			instance["__path__"] = find( "", scope || _global ) || null ;
			
			_global.ASSetPropFlags(instance, ["__path__"], 7, 7) ;
			
			return instance["__path__"] || null ;
			
		}
	}
	
	/**
	 * Returns {@code true} if the constructor function is an implementation of the specified interface.
	 * @param c the function constructor reference.
	 * @param i the interface reference.
	 * @return {@code true} if the constructor function is an implementation of the specified interface.
	 */
	static public function isImplementationOf(c:Function, i:Function):Boolean 
	{
		if (ConstructorUtil.isSubConstructorOf(c, i)) 
		{
			return false;
		}
		return ConstructorUtil.createBasicInstance(c) instanceof i ;
	}
	
	/**
	 * Returns {@code true} if the constructor function is the sub constructor of the specified function constructor.
	 * @param c the function constructor reference.
	 * @param sc the specified sub constructor reference.
	 * @return {@code true} if the constructor function is the sub constructor of the specified function constructor.
	 */
	static public function isSubConstructorOf( c:Function, sc:Function):Boolean 
	{
		var p = c.prototype ;
		while(p) 
		{
			p = p.__proto__;
			if(p === sc.prototype) return true ;
		}
		return false;
	}


}

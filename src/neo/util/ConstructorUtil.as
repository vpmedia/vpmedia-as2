/*

  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at 
  
           http://www.mozilla.org/MPL/ 
  
  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
  for the specific language governing rights and limitations under the License. 
  
  The Original Code is Neo Library.
  
  The Initial Developer of the Original Code is
  ALCARAZ Marc (aka eKameleon)  <contact@ekameleon.net>.
  Portions created by the Initial Developer are Copyright (C) 2004-2005
  the Initial Developer. All Rights Reserved.
  
  Contributor(s) :
  
*/

/* ---------- ConstructorUtil

	AUTHOR
	
		Name : ConstructorUtil
		Package : neo.util
		Version : 1.0.0.0
		Date : 2005-10-12
		Author : ekameleon
		URL : http://www.ekameleon.net
		Mail : contact@ekameleon.net
	
	DESCRIPTION
	
		Constructor tools.
	
	METHODS
	
		- createBasicInstance(class:Function)
		
		- createInterface(class:Function, args:Array)
		
		- createVisualInstance(class:Function, oVisual, oInit)

		- getName(instance)
		
		- getPackage(instance)
		
		- getPath(instance)
		
		- isImplementationOf(constructor:Function, interface:Function)
		
		- isSubConstructorOf (subConstructor, superConstructor) ;
	
----------  */

import com.bourre.utils.ClassUtils;

class neo.util.ConstructorUtil {
	
	// ----o Constructor
	
	private function ConstructorUtil() {}

	

	// ----o Static 

	static public function createBasicInstance(c:Function) {
		var i = {} ;
		i.__proto__ = c.prototype ;
		i.__constructor__ = c ;
		return i ;
	}
	

	static public function createInstance(c:Function, args:Array) {
		if (!c) return null ;
		var i = ConstructorUtil.createBasicInstance(c) ;
		c.apply(i, args) ;
		return i ;
	}

    static public function createVisualInstance(c:Function, oVisual, oInit) {
		oVisual.__proto__ = c.prototype ;
		if (oInit) for (var each:String in oInit) oVisual[each] = oInit[each] ;	
		c.apply(oVisual) ;   
		return oVisual ;
    }


	static public function getName( instance ):String {

		var path:String = getPath(instance) ;

		if (path == null) return null ;

		var p:Array = path.split(".") ;

		return p.pop() || null ;

	}

	static public function getPackage( instance ):String {

		var path:String = getPath(instance) ;

		if (path == null) return null ;
		var package:Array = path.split(".") ;

		package.pop() ;
		return package.join(".") ;
	}
	
	static public function getPath( instance ):String {

		return ClassUtils.getClassName(instance) || null ;
	}

	static public function isImplementationOf(c:Function, i:Function):Boolean {
		if (ConstructorUtil.isSubConstructorOf(c, i)) return false;
		return ConstructorUtil.createBasicInstance(c) instanceof i ;
	}

	static public function isSubConstructorOf( c:Function, sc:Function):Boolean {
		var p = c.prototype ;
		while(p) {
			p = p.__proto__;
			if(p === sc.prototype) return true ;
		}
		return false;
	}

}

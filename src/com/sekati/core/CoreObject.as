/**
 * com.sekati.core.CoreObject
 * @version 1.1.0
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */

import com.sekati.core.CoreInterface;
import com.sekati.core.KeyFactory;
import com.sekati.reflect.Stringifier;

/**
 * The core mixin object in the SASAPI framework.
 */
class com.sekati.core.CoreObject extends Object implements CoreInterface {

	/**
	 * CoreObject Constructor calls superclass, links _this and injects a 
	 * {@link com.sekati.crypt.RUID} via {@link com.sekati.core.KeyFactory}.
	 * @return Void
	 */
	public function CoreObject() {
		super( );
		KeyFactory.inject( this );
	}

	/**
	 * Clean and destroy object instance contents/self for garbage collection.
	 * Always call destroy() before deleting last object pointer.
	 * @return Void
	 */		
	public function destroy():Void {
		/*		 
		 * VERY DANGEROUS BUGS CAN OCCUR WHEN EXTENDING 
		 * COREOBJECT WITH THIS LOOP INCLUDED!
		for(var i in this){
		delete this[i];	
		}
		 */
		delete this;
	}

	/**
	 * Return the Fully Qualified Class Name string representation of
	 * the instance object via {@link com.sekati.reflect.Stringifier}.
	 * @return String
	 */		
	public function toString():String {
		return Stringifier.stringify( this );	
	}	
}
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
import vegas.util.AttributeType;

/**
 * This tool static class define a basic attribute structure.
 * SSAS FMS Framework inspiration and Zwetan : Core2 AS2 Framework inspiration for refactoring !
 * @author eKameleon
 * @see ASSetPropFlags global and no documented function.
 */
class vegas.util.Attribute extends CoreObject
{

	/**
	 * Creates a new Attribute instance.
	 * <p><b>Example :</b></p>
	 * {@code
	 * import vegas.util.Attribute ;
	 * var attr:Attribute = new Attribute(true, true, true) ;
	 * }
	 * @param dontEnum a boolean to defined if the object is enumerable or not.
	 * @param dontDelete a boolean to defined if the object can be remove or not.
	 * @param readOnly a boolean to defined if the object is readable only or not.
	 */
	public function Attribute(dontEnum:Boolean, dontDelete:Boolean, readOnly:Boolean) 
	{
		this.dontEnum = dontEnum == true ;
        this.dontDelete = dontDelete == true ;
		this.readOnly = readOnly == true ;
	}

	/**
	 * The dontEnum value to defined if the object is enumerable or not.
	 */
	public var dontEnum:Boolean ;
	
	/**
	 * The dontDelete value to defined if the object can be remove or not. 
	 */
	public var dontDelete:Boolean ;
	
	/**
	 * The readOnly value to defined if the object is readable only or not.
	 */
	public var readOnly:Boolean ;

	/**
	 * Returns the attribut instance and configuration of an object.
	 * @param obj the object to defined the {@code Attribute} instance.
	 * @param property the property in the object to check.
	 * @return the attribut instance and configuration of an object.
	 */
    static public function getAttribute(obj:Object, property:String):Attribute 
    {
        var dontEnum:Boolean = Attribute.isDontEnum(obj, property);
        var readOnly:Boolean = Attribute.isReadOnly(obj, property);
        var dontdelete:Boolean = Attribute.isDontDelete(obj, property);
        var attrib:Attribute = new Attribute( dontEnum, dontdelete, readOnly ) ;
        Attribute.setAttribute( obj, property, attrib ) ;
        return attrib ;
	}

	/**
	 * Returns {@code true} if the property in the specified object can't be deleted.
	 * @return {@code true} if the property in the specified object can't be deleted.
	 */
    static public function isDontDelete(obj, property:String):Boolean 
    {
        var save = obj[property] ;
		delete obj[property] ;
        if( obj[property] === undefined ) 
        {
            obj[property] = save ;
            return false;
		}
        return true;
	}

	/**
	 * Returns {@code true} if the property in the specified object isn't enumerable.
	 * @return {@code true} if the property in the specified object isn't enumerable.
	 */
    static public function isDontEnum(obj, property:String):Boolean 
    {
        return !obj.isPropertyEnumerable(property) ;
	}
    
	/**
	 * Returns {@code true} if the property in the specified object can be read only.
	 * @return {@code true} if the property in the specified object can be read only.
	 */
    static public function isReadOnly(obj, property:String):Boolean 
    {
        var dummy:String = "__\uFFFC\uFFFD\uFFFC\uFFFD__"; // we use ORC char to prevent string colision
        var save = obj[property] ;
        obj[property] = dummy ;
        if( obj[property] == dummy ) 
        {
            obj[property] = save ;
            return false ;
		}
        return true ;
	}
	
	/**
	 * Sets the attribute of the property in the specified object.
	 * @param obj the specified object to change the property attribute.
	 * @param property the string name of the property of the specified object.
	 * @param attrib the Attribute instance to change the current attribute of the property.
	 * @param override to defined the override value. This value is the last parameter of the {@code ASSetPropFlags} global function.
	 * @see ASSetPropFlags
	 */
	static public function setAttribute(obj:Object, property, attrib, override):Void 
	{
        if( attrib == null ) attrib = AttributeType.NONE ;
		if( override == null ) 
		{
			override = AttributeType.NONE ;
		}
		if( attrib instanceof Attribute ) 
		{
			attrib = attrib.valueOf() ;
		}
        if( override instanceof Attribute ) 
        {
        	override = override.valueOf();
        }
        _global.ASSetPropFlags( obj, property, attrib, override );
    }
    
    /**
     * Returns the string representation of this object.
     * @return the string representation of this object.
     */
	public function toString():String 
	{
        var data:Array = [];
        var sep:String = ",";
        if(readOnly) 
        {
        	data.push( "readOnly" ) ;
        }
		if(dontDelete) 
		{
			data.push( "dontDelete" ) ;
		}
		if(dontEnum) 
		{
			data.push( "dontEnum" ) ;
		}
        if(data.length == 0) 
        {
        	data.push("none") ;
        }
        return "[Attribute:" + data.join( sep ) + "]";
	}
	
	/**
	 * Returns the value of this object.
	 * @return the value of this object.
	 */
	public function valueOf():Number 
	{
        return ((Number(readOnly) << 2) | (Number(dontDelete) << 1) | Number(dontEnum) );
	}
	
	
}

/*
  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at 
  http://www.mozilla.org/MPL/ 
  
  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
  for the specific language governing rights and limitations under the License. 
  
  The Original Code is core2: ECMAScript core objects 2nd gig AS2. 
  
  The Initial Developer of the Original Code is
  Zwetan Kjukov <zwetan@gmail.com>.
  Portions created by the Initial Developer are Copyright (C) 2003-2006
  the Initial Developer. All Rights Reserved.
  
  Contributor(s):
*/

/* Class: Attribute
   Define a basic attribute structure.
   
   dependencies:
   propertyIsEnumerable, ASSetPropFlags, AttributeType
   
   based on ECMA-262 property attributes specification
   (chapter 8.6.1 , PDF p38/188)
   
   note:
   This class is essential for ActionScript v2.0 introspection.
   
   It allow us to just unlock the dontEnum attribute
   and preserve other attributes if they exists.
   
   example:
   (code)
   Attribute.setAttribute( _global, "something", AttributeType.none, AttributeType.dontEnum );
   (end)
   
*/
class Attribute
    {
    
    var dontEnum:Boolean;
    var dontDelete:Boolean;
    var readOnly:Boolean;
    
    function Attribute( dontEnum:Boolean, dontDelete:Boolean, readOnly:Boolean )
        {
        
        if( dontEnum == null )
            {
            dontEnum = false;
            }
        
        if( dontDelete == null )
            {
            dontDelete = false;
            }
        
        if( readOnly == null )
            {
            readOnly = false;
            }
        
        this.dontEnum   = dontEnum;
        this.dontDelete = dontDelete;
        this.readOnly   = readOnly;
        
        }
    
    
    function toString():String
        {
        var data:Array = [];
        var sep:String = ",";
        
        if( this.readOnly )
            {
            data.push( "readOnly" );
            }
    
        if( this.dontDelete )
            {
            data.push( "dontDelete" );
            }
    
        if( this.dontEnum )
            {
            data.push( "dontEnum" );
            }
        
        if( data.length == 0 )
            {
            data.push( "none" );
            }
        
        return "[" + data.join( sep ) + "]";
        }
    
    function valueOf():Number
        {
        return( (this.readOnly << 2) | (this.dontDelete << 1) | this.dontEnum );
        }
    
    static function isDontEnum( target:Object, property:String ):Boolean
        {
        return !target.propertyIsEnumerable( property );
        }
    
    static function isDontDelete( target:Object, property:String ):Boolean
        {
        var tmp = target[property];
        
        delete target[property];
        
        if( target[property] === undefined )
            {
            target[property] = tmp;
            return false;
            }
        
        return true;
        }
    
    static function isReadOnly( target:Object, property:String ):Boolean
        {
        var dummy:String = "__\uFFFC\uFFFD\uFFFC\uFFFD__"; // we use ORC char to prevent string colision
        var tmp = target[property];
        
        target[property] = dummy;
        
        if( target[property] == dummy )
            {
            target[property] = tmp;
            return false;
            }
        
        return true;
        }
    
    static function getAttribute( target:Object, property:String ):Attribute
        {
        var dontEnum:Boolean   = Attribute.isDontEnum(   target, property );
        var readOnly:Boolean   = Attribute.isReadOnly(   target, property );
        var dontdelete:Boolean = Attribute.isDontDelete( target, property );
        
        var attrib:Attribute = new Attribute( dontEnum, dontdelete, readOnly );
        
        Attribute.setAttribute( target, property, attrib );
        
        return attrib;
        }
    
    /* StaticMethod: setAttribute
       Sets the attribute of one property.
       
       attention:
       property can be a String or null (for all the elements) or an Array of elements.
       The override parameter allow you to unlock initial settings.
       
       example:
       (code)
       //initial setting
       Attribute.setAttribute( _global, "Attribute", AttributeType.locked );
       //now the Attribute class is totally locked: [dontEnum, dontDelete, readOnly]
       
       Attribute.setAttribute( _global, "Attribute", AttributeType.none );
       //the attribue is not overrided, the Attribute class stay locked
       
       Attribute.setAttribute( _global, "Attribute", AttributeType.none, Attribute.locked );
       //the attribute is overrided, the Attribute class has now [none] attribute
       (end)
       
       The override parameter allow to set a filter on the attribute authorisation
       
       another example:
       (code)
       //initial setting
       Attribute.setAttribute( _global, "Attribute", AttributeType.locked );
       //now the Attribute class is totally locked: [dontEnum, dontDelete, readOnly]
       
       Attribute.setAttribute( _global, "Attribute", AttributeType.none );
       //the attribue is not overrided, the Attribute class stay locked
       
       Attribute.setAttribute( _global, "Attribute", AttributeType.none, Attribute.enumOnly );
       //the attribute is overrided, the Attribute class is now only [dontEnum]
       //enumOnly attribute is like the "inverse" of the dontEnum attribute
       (end)
       
    */
    static function setAttribute( target:Object, property, attrib, override ):Void
        {
        if( attrib == null )
            {
            attrib = AttributeType.none; //default value
            }
        
        if( override == null )
            {
            override = AttributeType.none; //default value
            }
        
        //attrib can be of the type Number or Attribute
        if( attrib instanceof Attribute )
            {
            attrib = attrib.valueOf();
            }
        
        //override can be of the type Number or Attribute
        if( override instanceof Attribute )
            {
            override = override.valueOf();
            }        
        
        _global.ASSetPropFlags( target, property, attrib, override );
        }
    
    }


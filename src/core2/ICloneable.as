
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

/* Interface: ICloneable
   Allows an object to be copied by reference.
   
   note:
   In general we consider all clone method to
   return a shallow copy (reference) of the current objet.
   
   But in certain particular case a clone can provide a mixed copy
   of the object where some of its members will be copied by reference (objects)
   and others will be copied by value (primitives).
   
   see: <Object.memberwiseClone> and <Array.clone>
   
   example:
   Here a simple way to implement it
   
   (code)
   class myCustomObject
       {
       var x:Number;
       var y:Number;
       
       function myCustomObject( x:Number, y:Number )
           {
           this.x = x;
           this.y = y;
           }
       
       
       function clone():Object
           {
           return this;
           }
       
       }
   (end)
*/
interface ICloneable
    {
    
    /* Method: clone
       Returns a copy by reference of this object.
       
       attention:
       If the instance is a primitive the behaviour
       is to return a copy by value.
    */
    function clone():Object;
    
    }



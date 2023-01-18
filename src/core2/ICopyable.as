
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

/* Interface: ICopyable
   Allows an object to be copied by value.
   
   note:
   In general we consider all copy method to
   return a deep copy (value) of the current objet.
   
   But also consider that you can decide to not copy
   all members of an object to obtain a legit copy.
   
   example:
   Here a basic way to implement it
   
   (code)
   class Point
       {
       var x:Number;
       var y:Number;
       
       function Point( x:Number, y:Number )
           {
           this.x = x;
           this.y = y;
           }
       
       function copy():Object
           {
           return new Point( x, y );
           }
       }
   (end)
   
   We could have done it this way
   (code)
   Point.prototype.copy = function()
       {
       return { x:this.x, y:this.y };
       }
   (end)
   
   but in general is best to use the constructor
   as a starting point for the newly created object.
   
   other example:
   Here a particular case where you can not just use
   the object constructor to have a correct copy.
   
   (code)
   class Gift
       {
       var source:String;
       var destination:String;
       var location:String;
       
       function Gift( source:String, destination:String )
           {
           this.source      = source;
           this.destination = destination;
           this.location    = source;
           }
   
       function moveTo( newLocation:String ):Void
           {
           location = newLocation;
           }
   
       function copy():Object
           {
           var obj:Gift = new Gift( source, destination );
           obj.location = location;
           return obj;
           }
       }
   (end)
   
   The scenario is basic, you have a Gift object
   that you want to send from a source location
   to a particular destination location.
   
   But as you need to go trough transitional location,
   if you decide to copy the Gift object, you have also
   to copy the current location property to obtain
   a "correct" copy of the object.
   
   If the locations could be either Strings or Objects
   it would be safer to do the copy like that:
   
   (code)
   function copy():Object
       {
       var obj:Gift = new Gift( source.copy(), destination.copy() );
       obj.location = location.copy();
       return obj;
       }
   (end)
*/
interface ICopyable
    {
    
    /* Method: copy
       Returns a copy by value of this object.
    */
    function copy():Object;
    
    }


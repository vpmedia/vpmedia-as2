
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

/* Interface: ISerializable
   Allows an object to control its own serialization.
   
   note:
   Totally inspired by Mozilla SpiderMonkey.
   
   We consider the default source formating to be the ECMAScript syntax.
   
   To add a different syntax formating it should be
   possible to add a 3rd *formater* argument and override
   the implementation of the method in all core objects.
   
   example:
   
   (code)
   class Boolean
       {
       
       function toSource( indent:Number, indentor:String, formater )
           {
           switch( formater )
               {
               case "PHP"
               return "b:" + this.toNumber();
               
               default: //from the original Boolean.toSource implementation
               if( equals( true ) )
                   {
                   return "true";
                   }
               
               return "false";
               }
           }
       
       }
   (end)
*/
interface ISerializable
    {
    
    /* Method: toSource
       Returns a string representing the source code of the object.
       
       Parameters:
       indent   - optionnal, the starting amount of indenting
       indentor - optionnal, the string value used to do the indentation
    */
    function toSource( /*int*/ indent:Number, indentor:String ):String;
    
    }


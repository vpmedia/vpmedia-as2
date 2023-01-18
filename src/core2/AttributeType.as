
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

/* Enum: AttributeType
   
   based on ECMA-262 property attributes specification
   (chapter 8.6.1 , PDF p38/188)
*/
class AttributeType
    {
    
    static var none:Number         = 0;
    static var dontEnum:Number     = 1;
    static var dontDelete:Number   = 2;
    static var readOnly:Number     = 4;
    
    static var overrideOnly:Number = dontEnum | dontDelete;            //3
    static var deleteOnly:Number   = dontEnum | readOnly;              //5
    static var enumOnly:Number     = readOnly | dontDelete;            //6
    static var locked:Number       = dontEnum | readOnly | dontDelete; //7
    
    static private var __ASPF__    = _global.ASSetPropFlags( AttributeType, null, 7, 7 );
    }


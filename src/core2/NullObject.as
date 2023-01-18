
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

/* Class: NullObject
   Utilitarian object allowing to treat
   a null value as an object.
   
   note:
   usefull for some polymorphic situation.
   
   see: <http://c2.com/cgi/wiki?NullObject>
   
   attention:
   By default core2 ECMA-262 library include
   the NullObject constructor, so even if we could
   define a normal class (not an intrinsic one),
   it's simpler to treat this class as an intrinsic class.
   
   This avoid us to recompile a special core2 lib
   not including the NullObject constructor.
*/
intrinsic class NullObject
    {
    
	function NullObject();
    
	function toString():String;
	function valueOf():Object;
	
    }


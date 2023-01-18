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
import vegas.util.visitor.IVisitable;
import vegas.util.visitor.IVisitor;

/**
 * The abstract representation of the IVisitable interface.
 * To implements a Visitor pattern you must inspired your IVisitor classes with this interface.
 * This Abstract class is a basical implementation of the Visitor pattern, you can inspirate your custom Visitor design pattern implementation with it easy representation.  
 * @author eKameleon
 */
class vegas.util.visitor.AbstractVisitable extends CoreObject implements IVisitable 
{
	
	/**
	 * Abstract constructor to creates a concrete constructor when this constructor is extended.
	 */
	public function AbstractVisitable() 
	{
		super();
	}

	/**
	 * Accept a IVisitor object. 
	 * You can overrides this method in complexe Visitor pattern implementation.
	 */
	function accept( visitor:IVisitor ) 
	{
		visitor.visit(this) ;
	}

}
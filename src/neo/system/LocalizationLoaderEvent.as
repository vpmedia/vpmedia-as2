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

/* ------ LocalizationLoaderEvent

	AUTHOR

		Name : LocalizationLoaderEvent
		Package : neo.system
		Version : 1.0.0.0
		Date :  2006-02-19
		Author : ekameleon
		URL : http://www.ekameleon.net
		Mail : contact@ekameleon.net

	DESCRIPTION
	

	PROPERTY SUMMARY
	

	METHOD SUMMARY
	

----------  */	

import com.bourre.core.HashCodeFactory;
import com.bourre.data.libs.LibEvent;
import com.bourre.events.EventType;

import neo.system.Lang;
import neo.system.LocalizationLoader;

class neo.system.LocalizationLoaderEvent extends LibEvent {

	// ----o Constructor
	
	public function LocalizationLoaderEvent(e:EventType, oLib:LocalizationLoader) {
		super(e, oLib) ;
	}

	// ----o Public Methods

	public function getLib():LocalizationLoader {
		return LocalizationLoader( super.getLib() );
	}

	public function getLocalization(lang:Lang) {
		return getLib().getLocalization(lang) ;
	}

	public function toString() : String
	{
		return '[LocaleLoaderEvent' + HashCodeFactory.getKey( this ) + ' : ' + getType() + ']';
	}

	
}
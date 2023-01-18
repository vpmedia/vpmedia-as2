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

/* ------ Lang

	AUTHOR

		Name : Lang
		Package : neo.system
		Version : 1.0.0.0
		Date :  2006-02-17
		Author : ekameleon
		URL : http://www.ekameleon.net
		Mail : contact@ekameleon.net

	CONSTANT

		- CS:Lang
		
		- DA:Lang
		
		- NL:Lang
		
		- FI:Lang
		
		- FR:Lang
		
		- DE:Lang
		
		- HU:Lang
		
		- IT:Lang
		
		- JA:Lang
		
		- KO:Lang
		
		- NO:Lang
		
		- XU:Lang
		
		- PL:Lang
		
		- PT:Lang
		
		- RU:Lang
		
		- ZH_CN:Lang
		
		- ES:Lang
		
		- SV:Lang
		
		- ZH_TW:Lang
		
		- TR:Lang
	
	METHOD SUMMARY
	
		- static validate(lang:String):Boolean
	
----------  */	

import com.bourre.events.EventType;

import neo.util.ArrayUtil;

class neo.system.Lang extends EventType {

	// ----o Constructor
	
	private function Lang(s:String) {
		super(s) ;
	}

	// ----o  CONSTANT

	static public var CS:Lang = new Lang("cs") ;
	static public var DA:Lang = new Lang("da") ;
	static public var NL:Lang = new Lang("nl") ;
	static public var EN:Lang = new Lang("en") ;
	static public var FI:Lang = new Lang("fi") ;
	static public var FR:Lang = new Lang("fr") ;
	static public var DE:Lang = new Lang("de") ;
	static public var HU:Lang = new Lang("hu") ;
	static public var IT:Lang = new Lang("it") ;
	static public var JA:Lang = new Lang("ja") ;
	static public var KO:Lang = new Lang("ko") ;
	static public var NO:Lang = new Lang("no") ;
	static public var XU:Lang = new Lang("xu") ;
	static public var PL:Lang = new Lang("pl") ;
	static public var PT:Lang = new Lang("pt") ;
	static public var RU:Lang = new Lang("ru") ;
	static public var ZH_CN:Lang = new Lang("zh-CN") ;
	static public var ES:Lang = new Lang("es") ;
	static public var SV:Lang = new Lang("sv") ;
	static public var ZH_TW:Lang = new Lang("zh-TW") ;
	static public var TR:Lang = new Lang("tr") ;

	static private var __ASPF__ = _global.ASSetPropFlags(Lang, null , 7, 7) ;
	
	static public function validate( lang:String ):Boolean {
		
		var langs:Array = [
			CS, DA, NL, EN, FI, FR,
			DE, HU, IT, JA, KO, NO,
			XU, PL, PT, RU, ZH_CN,
			ES, SV, ZH_TW, TR
		] ;
	
		return ArrayUtil.contains(langs, lang) ;
	

	}
	
}
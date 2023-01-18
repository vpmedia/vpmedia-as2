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

import vegas.data.map.HashMap;
import vegas.util.ArrayUtil;

// TODO change the full string of the Lang reference + localization.

/**
 * The Lang class register all international lang of the application. Use this class in the Localization model of ASGard.
 * @author eKameleon
 */
class asgard.system.Lang extends String 
{

	/**
	 * Creates a new Lang instance.
	 */
	public function Lang(s) 
	{
		super(s) ;
	}
	
	static public var CS:Lang    = new Lang("cs") ;

	static public var DA:Lang    = new Lang("da") ;

	static public var NL:Lang    = new Lang("nl") ;

	static public var EN:Lang    = new Lang("en") ;

	static public var FI:Lang    = new Lang("fi") ;

	static public var FR:Lang    = new Lang("fr") ;

	static public var DE:Lang    = new Lang("de") ;

	static public var HU:Lang    = new Lang("hu") ;

	static public var IT:Lang    = new Lang("it") ;

	static public var JA:Lang    = new Lang("ja") ;

	static public var KO:Lang    = new Lang("ko") ;

	static public var NO:Lang    = new Lang("no") ;

	static public var XU:Lang    = new Lang("xu") ;

	static public var PL:Lang    = new Lang("pl") ;

	static public var PT:Lang    = new Lang("pt") ;

	static public var RU:Lang    = new Lang("ru") ;

	static public var ZH_CN:Lang = new Lang("zh-CN") ;

	static public var ES:Lang    = new Lang("es") ;

	static public var SV:Lang    = new Lang("sv") ;

	static public var ZH_TW:Lang = new Lang("zh-TW") ;

	static public var TR:Lang    = new Lang("tr") ;

	static public var CS_FULL:String = "Tchèque" ;

	static public var DA_FULL:String = "Danois" ;

	static public var NL_FULL:String = "Hollandais" ;

	static public var EN_FULL:String = "Anglais" ;

	static public var FI_FULL:String = "Finlandais" ;

	static public var FR_FULL:String = "Français" ;

	static public var DE_FULL:String = "Allemand" ;

	static public var HU_FULL:String = "Hongrois" ;

	static public var IT_FULL:String = "Italien" ;

	static public var JA_FULL:String = "Japonais" ;

	static public var KO_FULL:String = "Coréen" ;

	static public var NO_FULL:String = "Norvégien" ;

	static public var XU_FULL:String = "Autre/Inconnu" ;

	static public var PL_FULL:String = "Polonais" ;

	static public var PT_FULL:String = "Portugais" ;

	static public var RU_FULL:String = "Russe" ;

	static public var ZH_CN_FULL:String = "Chinois simplifié" ;

	static public var ES_FULL:String = "Espagnol" ;

	static public var SV_FULL:String = "Suédois" ;

	static public var ZH_TW_FULL:String = "Chinois Traditionnel" ;

	static public var TR_FULL:String = "Turc" ;

	static public var LANGS:HashMap = new HashMap () ;
	
	/**
	 * Returns the name of the Lang define with the specified id in argument.
	 * @return the name of the Lang define with the specified id in argument.
	 */
	static public function get(id:String):String 
	{
		if (LANGS.size() == 0) 
		{
			Lang.initialize() ;
		}
		return LANGS.get(id) ;			
	}

	/**
	 * Initialize the model of this class.
	 */
	static public function initialize():Void 
	{
		LANGS.clear() ;
		LANGS.put(CS, CS_FULL) ;
		LANGS.put(DA, DA_FULL) ;
		LANGS.put(NL, NL_FULL) ;
		LANGS.put(EN, EN_FULL) ;
		LANGS.put(FI, FI_FULL);
		LANGS.put(FR, FR_FULL);
		LANGS.put(DE, DE_FULL) ;
		LANGS.put(HU, HU_FULL) ;
		LANGS.put(IT, IT_FULL) ;
		LANGS.put(JA, JA_FULL) ;
		LANGS.put(KO, KO_FULL) ;
		LANGS.put(NO, NO_FULL) ;
		LANGS.put(XU, XU_FULL) ;
		LANGS.put(PL, PL_FULL) ;
		LANGS.put(PT, PT_FULL) ;
		LANGS.put(RU, RU_FULL) ;
		LANGS.put(ZH_CN, ZH_CN_FULL) ;
		LANGS.put(ES, ES_FULL) ;
		LANGS.put(SV, SV_FULL) ;
		LANGS.put(ZH_TW, ZH_TW_FULL) ;
		LANGS.put(TR, TR_FULL) ;
	}

	/**
	 * Inserts a new Lang in the Lang model.
	 */
	static public function put( lang:Lang , label:String ) 
	{
		return LANGS.put(lang, label) ;
	}

	/**
	 * Removes a new Lang in the Lang model.
	 */
	static public function remove( lang:Lang ) 
	{
		return LANGS.remove(lang) ;
	}

	/**
	 * Validate the specified lang in argument.
	 * @return {@code true} if the lang passed in argument is registered in the model.
	 */
	static public function validate( lang:String ):Boolean 
	{
		
		var langs:Array = [
			CS, DA, NL, EN, FI, FR,
			DE, HU, IT, JA, KO, NO,
			XU, PL, PT, RU, ZH_CN,
			ES, SV, ZH_TW, TR
		] ;
		
		return ArrayUtil.contains(langs, lang) ;
	}

	static private var __INITLANGS__ = Lang.initialize() ;
	
}



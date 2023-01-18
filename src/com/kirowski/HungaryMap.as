/**
 * Hungary Map Class by Kirowski - 2005-2006. András Csizmadia 
 * GVOP project implementation.
 * 
 * Do not distribute or modify this code without the owner/author(s) permission.
 * 
 * Class provides API for Hungary Map divided by area: "Region","County","Settlement,City"
 * navigation and data arrangement.
 * 
 * functions: getCountyInstances, getRegionInstances,  getCountyIdxByLabel, getCountyByRegion
 *
 */
// Implementations
import mx.events.EventDispatcher;
import mx.utils.Delegate;
// Define Class
class com.kirowski.HungaryMap extends MovieClip
{
	// START CLASS
	public var hungaryMap:String = "HungaryMap";
	public static var version:String = "1.6.1";
	public static var author:String = "András Csizmadia - kirowski.com";
	// EventDispatcher
	public var addEventListener:Function;
	public var removeEventListener:Function;
	public var dispatchEvent:Function;
	public var dispatchQueue:Function;
	//
	               
	public static var county_array:Array = new Array (
		{idx:"county43", instance:"megye_budapest", label:"Budapest", city:"Budapest", color:0xFFE4BF},
		{idx:"county42", instance:"megye_pest", label:"Pest", city:"Budapest", color:0xBF9660},
		{idx:"county25", instance:"megye_baranya", label:"Baranya", city:"Pécs", color:0xFFF4E6},
		{idx:"county38", instance:"megye_tolna", label:"Tolna", city:"Szekszárd", color:0xFFC980},
		{idx:"county29", instance:"megye_fejer", label:"Fejér", city:"Székesfehérvár", color:0xBFD4FF},
		{idx:"county30", instance:"megye_gyor", label:"Győr-Moson-Sopron", city:"Győr", color:0x607FBF},
		{idx:"county39", instance:"megye_vas", label:"Vas", city:"Szombathely", color:0xE6EEFF},
		{idx:"county34", instance:"megye_komarom", label:"Komárom-Esztergom", city:"Tatabánya", color:0x80AAFF},
		{idx:"county24", instance:"megye_bacs", label:"Bács-Kiskun", city:"Kecskemét", color:0xD9BFFF},
		{idx:"county33", instance:"megye_jasz", label:"Jász-Nagykun-Szolnok", city:"Szolnok", color:0x8660BF},
		{idx:"county28", instance:"megye_csongrad", label:"Csongrád", city:"Szeged", color:0xF0E6FF},
		{idx:"county26", instance:"megye_bekes", label:"Békés", city:"Békéscsaba", color:0xB280FF},
		{idx:"county32", instance:"megye_heves", label:"Heves", city:"Eger", color:0xFFF7BF},
		{idx:"county35", instance:"megye_nograd", label:"Nógrád", city:"Salgótarján", color:0xBFB360},
		{idx:"county27", instance:"megye_borsod", label:"Borsod-Abaúj-Zemplén", city:"Miskolc", color:0xFFFCE6},
		{idx:"county31", instance:"megye_hajdu", label:"Hajdú-Bihar", city:"Debrecen", color:0xFFEF80},
		{idx:"county37", instance:"megye_szabolcs", label:"Szabolcs-Szatmár-Bereg", city:"Nyíregyháza", color:0xC9FFBF},
		{idx:"county36", instance:"megye_somogy", label:"Somogy", city:"Kaposvár", color:0xFFBFD4},
		{idx:"county40", instance:"megye_veszprem", label:"Veszprém", city:"Veszprém", color:0xFFDBBF},
		{idx:"county41", instance:"megye_zala", label:"Zala", city:"Zalaegerszeg", color:0xBFF7FF}
	);
	public static var region_array:Array = new Array (
		{idx:0, instance:"region_kozep-magyarorszag", content:"Budapest,Pest", label:"Közép-Magyarország", color: 0xEDD3BB},
		{idx:1, instance:"region_eszak-magyarorszag", content:"Borsod-Abaúj-Zemplén,Heves,Nógrád", label:"Észak-Magyarország", color: 0xE6EDBB},
		{idx:2, instance:"region_eszak-alfold", content:"Hajdú-Bihar,Jász-Nagykun-Szolnok,Szabolcs-Szatmár-Bereg", label:"Észak-Alföld", color: 0xB0EDBB},
		{idx:3, instance:"region_del-alfold", content:"Bács-Kiskun,Békés,Csongrád", label:"Dél-Alföld", color: 0xD6DEF0},
		{idx:4, instance:"region_kozep-dunantul", content:"Fejér,Komárom-Esztergom,Veszprém", label:"Közép-Dunántúl", color: 0xB0C5F0},
		{idx:5, instance:"region_nyugat-dunantul", content:"Győr-Moson-Sopron,Vas,Zala", label:"Nyugat-Dunántúl", color: 0xFAD9F2},
		{idx:6, instance:"region_del-dunantul", content:"Baranya,Somogy,Tolna", label:"Dél-Dunántúl", color: 0xFAE6D4}
	);
	public static var regionCoordinates_array:Array = new Array (
		{idx:0, instance:"region_kozep-magyarorszag", x:-150, y:-20, scale:90},
		{idx:1, instance:"region_eszak-magyarorszag", x:-300, y:80, scale:90},
		{idx:2, instance:"region_eszak-alfold", x:-450, y:0, scale:85},
		{idx:3, instance:"region_del-alfold", x:-250, y:-200, scale:90},
		{idx:4, instance:"region_kozep-dunantul", x:40, y:-70, scale:90},
		{idx:5, instance:"region_nyugat-dunantul", x:150, y:-70, scale:85},
		{idx:6, instance:"region_del-dunantul", x:0, y:-240, scale:90}
	);
	public static var countyCoordinates_array:Array = new Array (
		{idx:"county43", instance:"megye_budapest", x:-200,y:-50,scale:100},
		{idx:"county42", instance:"megye_pest", x:-200,y:-50,scale:100},
		
		{idx:"county25", instance:"megye_baranya",x:0,y:-450,scale:120},
		{idx:"county38", instance:"megye_tolna", x:-50,y:-350,scale:120},
		{idx:"county36", instance:"megye_somogy", x:0,y:-350,scale:120},
		
		{idx:"county40", instance:"megye_veszprem", x:40,y:-200,scale:120},
		{idx:"county34", instance:"megye_komarom", x:-200,y:-100,scale:130},
		{idx:"county29", instance:"megye_fejer", x:-100,y:-200,scale:120},
		
		{idx:"county24", instance:"megye_bacs", x:-300,y:-320,scale:110},
		{idx:"county28", instance:"megye_csongrad",x:-400,y:-350,scale:120},
		{idx:"county26", instance:"megye_bekes", x:-550,y:-330,scale:120},
		
		{idx:"county32", instance:"megye_heves", x:-600,y:-100,scale:150},
		{idx:"county35", instance:"megye_nograd", x:-600,y:-50,scale:170},
		{idx:"county27", instance:"megye_borsod", x:-600,y:50,scale:120},
		
		{idx:"county33", instance:"megye_jasz", x:-500,y:-150,scale:120},
		{idx:"county31", instance:"megye_hajdu", x:-650,y:-100,scale:120},
		{idx:"county37", instance:"megye_szabolcs",x:-750,y:0,scale:120},
		
		{idx:"county30", instance:"megye_gyor", x:100,y:0,scale:120},
		{idx:"county39", instance:"megye_vas", x:150,y:-200,scale:120},
		{idx:"county41", instance:"megye_zala", x:150,y:-300,scale:120}
	);
	// Settle arrangements
public static var settle_borsod = new Array("c_matrafured","c_gyongyos","c_matranovak","c_batonyterenye","c_parad","c_sirok","c_petervasara","c_nyekladhaza","c_hajduhadhaz","c_teglas","c_ujfeherto","c_nagykallo","c_mariapocs","c_baktaloranthaza","c_vasarosnameny","c_pacin","c_dombrad","c_kisvarda","c_nagyhalasz","c_ibrany","c_gavavencsello","c_sarospatak","c_satoraljaujhely","c_tornyosnemeti","c_tornalja","c_tornanadaska","c_aggtelek","c_rudabanya","c_szendro","c_tiszaujvaros","c_polgar","c_hajdudorog","c_hajdunanas","c_mezocsat","c_mezokovesd","c_fuzesabony","c_tiszafured","c_tokaj","c_tiszalok","c_tiszavasvari","c_belapatfalva","c_putnok","c_banreve","c_ozd","c_szikszo","c_szerencs","c_encs","c_edeleny","c_sajoszentpeter","c_kazincbarcika","c_nyiradony","c_hajduboszormeny","c_jaszarokszallas","c_nyiregyhaza","c_miskolc","c_salgotarjan","c_eger")
public static var settle_szabolcs = new Array("c_zahony","c_tiszabecs","c_hajduhadhaz","c_teglas","c_ujfeherto","c_nagykallo","c_mariapocs","c_nyirbator","c_nagyecsed","c_csenger","c_csengersima","c_zajta","c_fehergyarmat","c_mateszalka","c_baktaloranthaza","c_vasarosnameny","c_beregsurany","c_barabas","c_lonya","c_mandok","c_pacin","c_dombrad","c_kisvarda","c_nagyhalasz","c_ibrany","c_gavavencsello","c_sarospatak","c_satoraljaujhely","c_tiszaujvaros","c_polgar","c_hajdudorog","c_hajdunanas","c_mezocsat","c_balmazujvaros","c_tokaj","c_tiszalok","c_tiszavasvari","c_szerencs","c_encs","c_nyiradony","c_hajduboszormeny","c_nyiregyhaza")
public static var settle_hajdu = new Array("c_artand","c_gyomaendrod","c_devavanya","c_turkeve","c_veszto","c_szeghalom","c_korosnagyharsany","c_biharkeresztes","c_nagykereki","c_berettyoujfalu","c_puspokladany","c_karcag","c_kunhegyes","c_nadudvar","c_derecske","c_hajduszoboszlo","c_letavertes","c_nyirabrany","c_hajduhadhaz","c_teglas","c_ujfeherto","c_nagykallo","c_mariapocs","c_nyirbator","c_baktaloranthaza","c_tiszaujvaros","c_polgar","c_hajdudorog","c_hajdunanas","c_mezocsat","c_tiszafured","c_balmazujvaros","c_hortobagy","c_tiszavasvari","c_nyiradony","c_hajduboszormeny","c_debrecen","c_nyiregyhaza")
public static var settle_bekes = new Array("c_lokoshaza","c_kondoros","c_bekes","c_gyula","c_sarkad","c_mehkerek","c_mako","c_battonya","c_mezohegyes","c_tothkomlos","c_mezokovacshaza","c_elek","c_oroshaza","c_szentes","c_szarvas","c_tiszafoldvar","c_artand","c_mezobereny","c_mezotur","c_gyomaendrod","c_devavanya","c_turkeve","c_veszto","c_szeghalom","c_korosnagyharsany","c_biharkeresztes","c_nagykereki","c_berettyoujfalu","c_torokszentmiklos","c_kisujszallas","c_hodmezovasarhely","c_bekescsaba")
public static var settle_jasz = new Array("c_kondoros","c_szarvas","c_kunszentmarton","c_lakitelek","c_tiszakecske","c_tiszafoldvar","c_martfu","c_mezobereny","c_mezotur","c_gyomaendrod","c_devavanya","c_turkeve","c_abony","c_ujszasz","c_lajosmizse","c_nagykata","c_torokszentmiklos","c_kisujszallas","c_karcag","c_kunhegyes","c_hatvan","c_tiszafured","c_cegled","c_nagykoros","c_jaszarokszallas","c_jaszfenyszaru","c_jaszbereny","c_jaszapati","c_heves","c_kiskore","c_kecskemet","c_szolnok")
public static var settle_heves = new Array("c_holloko","c_somoskoujfalu","c_szecseny","c_paszto","c_matrafured","c_gyongyos","c_lorinci","c_hatvan","c_matranovak","c_batonyterenye","c_parad","c_sirok","c_petervasara","c_nyekladhaza","c_mezokovesd","c_fuzesabony","c_tiszafured","c_belapatfalva","c_jaszarokszallas","c_jaszfenyszaru","c_jaszbereny","c_jaszapati","c_heves","c_kiskore","c_salgotarjan","c_eger")
public static var settle_bacs = new Array("c_tiszasziget","c_roszke","c_morahalom","c_kelebia","c_tompa","c_bugac","c_kiskunfelegyhaza","c_kiskunmajsa","c_kistelek","c_mindszent","c_janoshalma","c_kiskunhalas","c_tolna","c_fadd","c_soltvadkert","c_kecel","c_kiskoros","c_kalocsa","c_paks","c_dunapataj","c_izsak","c_szabadszallas","c_solt","c_dunafoldvar","c_sarbogard","c_bacsalmas","c_hercegszanto","c_mohacs","c_bataszek","c_csongrad","c_baja","c_kunszentmarton","c_lakitelek","c_tiszakecske","c_abony","c_dunaujvaros","c_pusztaszabolcs","c_rackeve","c_kunszentmiklos","c_lajosmizse","c_cegled","c_nagykoros","c_hodmezovasarhely","c_szekszard","c_szeged","c_kecskemet")
public static var settle_baranya = new Array("c_tolna","c_mohacs","c_udvar","c_boly","c_villany","c_siklos","c_harkany","c_dravaszabolcs","c_szentlorinc","c_sellye","c_szigetvar","c_bataszek","c_komlo","c_bonyhad","c_dombovar","c_sasd","c_kadarkut","c_kaposvar","c_pecs","c_szekszard")
public static var settle_tolna = new Array("c_tolna","c_fadd","c_kalocsa","c_paks","c_dunapataj","c_dunafoldvar","c_cece","c_sarbogard","c_simontornya","c_tamasi","c_bataszek","c_komlo","c_bonyhad","c_dombovar","c_sasd","c_baja","c_balatonfoldvar","c_tab","c_pecs","c_szekszard")
public static var settle_fejer = new Array("c_dunafoldvar","c_cece","c_sarbogard","c_simontornya","c_polgardi","c_balatonfuzfo","c_balatonfoldvar","c_tab","c_enying","c_siofok","c_balatonalmadi","c_varpalota","c_dunaujvaros","c_pusztaszabolcs","c_gardony","c_rackeve","c_szazhalombatta","c_martonvasar","c_erd","c_mor","c_oroszlany","c_kisber","c_budaors","c_pilisvorosvar","c_bicske","c_tatabanya","c_szekesfehervar")
public static var settle_zala = new Array("c_nemesnep","c_magyarszombatfa","c_bajansenye","c_zalalovo","c_szentgotthard","c_rabafuzes","c_kormend","c_vasvar","c_pinkamindszent","c_redics","c_lenti","c_tornyiszentmiklos","c_letenye","c_murakeresztur","c_bohonye","c_keszthely","c_heviz","c_balatonboglar","c_zalaszentgrot","c_sumeg","c_marcali","c_zalakaros","c_zalaegerszeg","c_nagykanizsa")
public static var settle_vas = new Array("c_magyarszombatfa","c_bajansenye","c_zalalovo","c_szentgotthard","c_rabafuzes","c_kormend","c_vasvar","c_pinkamindszent","c_szentpeterfa","c_jak","c_keszthely","c_heviz","c_zalaszentgrot","c_sumeg","c_bozsok","c_buk","c_csepreg","c_koszeg","c_celldomolk","c_sarvar","c_szombathely","c_zalaegerszeg")
public static var settle_veszprem = new Array("c_keszthely","c_heviz","c_badacsonytomaj","c_polgardi","c_balatonfuzfo","c_balatonfoldvar","c_balatonlelle","c_balatonboglar","c_tihany","c_balatonfured","c_tapolca","c_zalaszentgrot","c_sumeg","c_nagyvazsony","c_enying","c_siofok","c_balatonalmadi","c_herend","c_varpalota","c_mor","c_oroszlany","c_kisber","c_celldomolk","c_ajka","c_devecser","c_zirc","c_papa","c_szekesfehervar","c_veszprem")
public static var settle_gyor = new Array("c_csepreg","c_koszeg","c_kophaza","c_nagycenk","c_fertorakos","c_hegyeshalom","c_rajka","c_vamosszabadi","c_pannonhalma","c_acs","c_kisber","c_fertod","c_kapuvar","c_janossomorja","c_lebeny","c_csorna","c_mosonmagyarovar","c_sopron","c_gyor")
public static var settle_komarom = new Array("c_budapest","c_szazhalombatta","c_vamosszabadi","c_pannonhalma","c_babolna","c_acs","c_erd","c_mor","c_oroszlany","c_kisber","c_nyergesujfalu","c_komarom","c_tata","c_nagymaros","c_dorog","c_szentendre","c_budaors","c_pilisvorosvar","c_esztergom","c_bicske","c_tatabanya")
public static var settle_pest = new Array("c_budapest","c_tiszakecske","c_diosjeno","c_nagyborzsony","c_letkes","c_szob","c_kismaros","c_visegrad","c_romhany","c_abony","c_ujszasz","c_dunaujvaros","c_pusztaszabolcs","c_gardony","c_rackeve","c_kunszentmiklos","c_lajosmizse","c_dabas","c_szazhalombatta","c_martonvasar","c_szigetszentmiklos","c_gyal","c_monor","c_nagykata","c_erd","c_csomor","c_nagymaros","c_dorog","c_szentendre","c_holloko","c_retsag","c_balassagyarmat","c_szecseny","c_paszto","c_matrafured","c_gyongyos","c_lorinci","c_hatvan","c_aszod","c_matranovak","c_batonyterenye","c_parad","c_petervasara","c_pecel","c_budaors","c_pilisvorosvar","c_esztergom","c_bicske","c_vac","c_godollo","c_dunakeszi","c_cegled","c_nagykoros","c_jaszarokszallas","c_jaszfenyszaru","c_jaszbereny","c_kecskemet")
public static var settle_csongrad = new Array("c_nagylak","c_mako","c_mezohegyes","c_tothkomlos","c_oroshaza","c_tiszasziget","c_roszke","c_morahalom","c_kelebia","c_tompa","c_bugac","c_kiskunfelegyhaza","c_kiskunmajsa","c_kistelek","c_mindszent","c_soltvadkert","c_csongrad","c_szentes","c_kunszentmarton","c_hodmezovasarhely","c_szeged")
public static var settle_somogy = new Array("c_harkany","c_szentlorinc","c_sellye","c_szigetvar","c_barcs","c_gyekenyes","c_csurgo","c_berzence","c_dombovar","c_sasd","c_nagyatad","c_kadarkut","c_murakeresztur","c_bohonye","c_keszthely","c_heviz","c_badacsonytomaj","c_balatonfoldvar","c_balatonlelle","c_balatonboglar","c_fonyod","c_lengyeltoti","c_tab","c_tihany","c_balatonfured","c_tapolca","c_zalaszentgrot","c_sumeg","c_siofok","c_balatonalmadi","c_marcali","c_zalakaros","c_zalaegerszeg","c_nagykanizsa","c_kaposvar","c_pecs")
public static var settle_nograd = new Array("c_diosjeno","c_nagyborzsony","c_szob","c_kismaros","c_visegrad","c_romhany","c_nagymaros","c_holloko","c_retsag","c_balassagyarmat","c_somoskoujfalu","c_szecseny","c_paszto","c_matrafured","c_gyongyos","c_matranovak","c_batonyterenye","c_parad","c_petervasara","c_vac","c_salgotarjan")
public static var settle_budapest = new Array("c_gyal","c_erd","c_csomor","c_pecel","c_budaors","c_pilisvorosvar")

	
	// Constructor
	function HungaryMap ()
	{
		EventDispatcher.initialize (this);
	}
	/**
	 * REGION
	 */
	public static function getRegionInstances (Void):Array
	{
		trace ("@getRegionInstances");
		return (HungaryMap.region_array);
	}
	public static function getRegionCoordinatesByIdx (__idx:Number):Array
	{
		trace ("@getRegionCoordinatesByIdx");
		var __coords_array = HungaryMap.regionCoordinates_array;
		for (var i in __coords_array)
		{
			if (__coords_array[i].idx == __idx)
			{
				var __result = __coords_array[i];
			}
		}
		return (__result);
	}
	public static function getRegionInstanceByIdx (__idx:Number):Array
	{
		trace ("@getRegionInstanceByIdx");
		for (var i in region_array)
		{
			if (region_array[i].idx == __idx)
			{
				var __result = region_array[i].instance;
			}
		}
		return __result;
	}
	public static function getRegionLabelByIdx (__idx:Number):Array
	{
		trace ("@getRegionLabelByIdx");
		for (var i in region_array)
		{
			if (region_array[i].idx == __idx)
			{
				var __result = region_array[i].label;
			}
		}
		return __result;
	}
	/**
	 * COUNTY
	 */
	public static function getCountyInstances (Void):Array
	{
		trace ("@getCountyInstances");
		return (HungaryMap.county_array);
	}
	public static function getCountyByRegion (__regionName:String):Array
	{
		trace ("@getCountyByRegion -> " + __regionName);
		var __tmp_array = HungaryMap.region_array;
		for (var i = 0; i <= __tmp_array.length; i++)
		{
			if (__tmp_array[i].label == __regionName)
			{
				var __idx = i;
			}
		}
		var __result = region_array[__idx];
		return __result;
	}
	public static function getCountyByLabel (__label:String):Array
	{
		trace ("@getCountyIdxByLabel -> " + __label);
		var __tmp_array = county_array;
		for (var i = 0; i <= __tmp_array.length; i++)
		{
			//trace (county_array[i].label + ":" + __label);
			if (__tmp_array[i].label == __label)
			{
				var __result = __tmp_array[i];
			}
		}
		return __result;
	}
	public static function getCountyIdxByLabel (__label:String):Number
	{
		trace ("@getCountyIdxByLabel -> " + __label);
		var __tmp_array = county_array;
		for (var i = 0; i <= __tmp_array.length; i++)
		{
			//trace (county_array[i].label + ":" + __label);
			if (__tmp_array[i].label == __label)
			{
				var __result = i;
			}
		}
		return __result;
	}
	public static function getCountyCoordinatesByIdx (__idx:Number):Array
	{
		trace ("@getCountyCoordinatesByIdx");
		var __coords_array = HungaryMap.countyCoordinates_array;
		for (var i in __coords_array)
		{
			if (__coords_array[i].idx == __idx)
			{
				var __result = __coords_array[i];
			}
		}
		return (__result);
	}
	// Get version
	public function toString ():String
	{
		return ("[" + hungaryMap + "]");
	}
	// END CLASS
}

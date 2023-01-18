/**
 * MapUtil
 * Copyright © 2006 András Csizmadia
 * Copyright © 2006 VPmedia
 * http://www.vpmedia.hu
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
 * IN THE SOFTWARE.
 * 
 * Project: MapUtil
 * File: MapUtil.as
 * Created by: András Csizmadia
 *
 */
// Implementations
import com.vpmedia.core.IFramework;
class com.vpmedia.utils.MapUtil extends MovieClip implements IFramework
{
	// START CLASS
	public var className:String = "MapUtil";
	public var classPackage:String = "com.vpmedia.utils";
	public var version:String = "2.0.0";
	public var author:String = "András Csizmadia";
	//
	//Information Codes 
	public var CountryCode_arr = new Array ();
	function MapUtil ()
	{
		this.CountryCode_arr["ad"] = "Andorra, Principality of";
		this.CountryCode_arr["ae"] = "United Arab Emirates";
		this.CountryCode_arr["af"] = "Afghanistan, Islamic State of";
		this.CountryCode_arr["ag"] = "Antigua and Barbuda";
		this.CountryCode_arr["ai"] = "Anguilla";
		this.CountryCode_arr["al"] = "Albania";
		this.CountryCode_arr["am"] = "Armenia";
		this.CountryCode_arr["an"] = "Netherlands Antilles";
		this.CountryCode_arr["ao"] = "Angola";
		this.CountryCode_arr["aq"] = "Antarctica";
		this.CountryCode_arr["ar"] = "Argentina";
		this.CountryCode_arr["arpa"] = "Old style Arpanet";
		this.CountryCode_arr["as"] = "American Samoa";
		this.CountryCode_arr["at"] = "Austria";
		this.CountryCode_arr["au"] = "Australia";
		this.CountryCode_arr["aw"] = "Aruba";
		this.CountryCode_arr["az"] = "Azerbaidjan";
		this.CountryCode_arr["ba"] = "Bosnia-Herzegovina";
		this.CountryCode_arr["bb"] = "Barbados";
		this.CountryCode_arr["bd"] = "Bangladesh";
		this.CountryCode_arr["be"] = "Belgium";
		this.CountryCode_arr["bf"] = "Burkina Faso";
		this.CountryCode_arr["bg"] = "Bulgaria";
		this.CountryCode_arr["bh"] = "Bahrain";
		this.CountryCode_arr["bi"] = "Burundi";
		this.CountryCode_arr["bj"] = "Benin";
		this.CountryCode_arr["bm"] = "Bermuda";
		this.CountryCode_arr["bn"] = "Brunei Darussalam";
		this.CountryCode_arr["bo"] = "Bolivia";
		this.CountryCode_arr["br"] = "Brazil";
		this.CountryCode_arr["bs"] = "Bahamas";
		this.CountryCode_arr["bt"] = "Bhutan";
		this.CountryCode_arr["bv"] = "Bouvet Island";
		this.CountryCode_arr["bw"] = "Botswana";
		this.CountryCode_arr["by"] = "Belarus";
		this.CountryCode_arr["bz"] = "Belize";
		this.CountryCode_arr["ca"] = "Canada";
		this.CountryCode_arr["cc"] = "Cocos (Keeling) Islands";
		this.CountryCode_arr["cf"] = "Central African Republic";
		this.CountryCode_arr["cd"] = "Congo, The Democratic Republic of the";
		this.CountryCode_arr["cg"] = "Congo";
		this.CountryCode_arr["ch"] = "Switzerland";
		this.CountryCode_arr["ci"] = "Ivory Coast (Cote D Ivoire)";
		this.CountryCode_arr["ck"] = "Cook Islands";
		this.CountryCode_arr["cl"] = "Chile";
		this.CountryCode_arr["cm"] = "Cameroon";
		this.CountryCode_arr["cn"] = "China";
		this.CountryCode_arr["co"] = "Colombia";
		this.CountryCode_arr["com"] = "Commercial";
		this.CountryCode_arr["cr"] = "Costa Rica";
		this.CountryCode_arr["cs"] = "Former Czechoslovakia";
		this.CountryCode_arr["cu"] = "Cuba";
		this.CountryCode_arr["cv"] = "Cape Verde";
		this.CountryCode_arr["cx"] = "Christmas Island";
		this.CountryCode_arr["cy"] = "Cyprus";
		this.CountryCode_arr["cz"] = "Czech Republic";
		this.CountryCode_arr["de"] = "Germany";
		this.CountryCode_arr["dj"] = "Djibouti";
		this.CountryCode_arr["dk"] = "Denmark";
		this.CountryCode_arr["dm"] = "Dominica";
		this.CountryCode_arr["do"] = "Dominican Republic";
		this.CountryCode_arr["dz"] = "Algeria";
		this.CountryCode_arr["ec"] = "Ecuador";
		this.CountryCode_arr["edu"] = "Educational";
		this.CountryCode_arr["ee"] = "Estonia";
		this.CountryCode_arr["eg"] = "Egypt";
		this.CountryCode_arr["eh"] = "Western Sahara";
		this.CountryCode_arr["er"] = "Eritrea";
		this.CountryCode_arr["es"] = "Spain";
		this.CountryCode_arr["et"] = "Ethiopia";
		this.CountryCode_arr["fi"] = "Finland";
		this.CountryCode_arr["fj"] = "Fiji";
		this.CountryCode_arr["fk"] = "Falkland Islands";
		this.CountryCode_arr["fm"] = "Micronesia";
		this.CountryCode_arr["fo"] = "Faroe Islands";
		this.CountryCode_arr["fr"] = "France";
		this.CountryCode_arr["fx"] = "France (European Territory)";
		this.CountryCode_arr["ga"] = "Gabon";
		this.CountryCode_arr["gb"] = "Great Britain";
		this.CountryCode_arr["gd"] = "Grenada";
		this.CountryCode_arr["ge"] = "Georgia";
		this.CountryCode_arr["gf"] = "French Guyana";
		this.CountryCode_arr["gh"] = "Ghana";
		this.CountryCode_arr["gi"] = "Gibraltar";
		this.CountryCode_arr["gl"] = "Greenland";
		this.CountryCode_arr["gm"] = "Gambia";
		this.CountryCode_arr["gn"] = "Guinea";
		this.CountryCode_arr["gov"] = "USA Government";
		this.CountryCode_arr["gp"] = "Guadeloupe (French)";
		this.CountryCode_arr["gq"] = "Equatorial Guinea";
		this.CountryCode_arr["gr"] = "Greece";
		this.CountryCode_arr["gs"] = "S. Georgia & S. Sandwich Isls.";
		this.CountryCode_arr["gt"] = "Guatemala";
		this.CountryCode_arr["gu"] = "Guam (USA)";
		this.CountryCode_arr["gw"] = "Guinea Bissau";
		this.CountryCode_arr["gy"] = "Guyana";
		this.CountryCode_arr["hk"] = "Hong Kong";
		this.CountryCode_arr["hm"] = "Heard and McDonald Islands";
		this.CountryCode_arr["hn"] = "Honduras";
		this.CountryCode_arr["hr"] = "Croatia";
		this.CountryCode_arr["ht"] = "Haiti";
		this.CountryCode_arr["hu"] = "Hungary";
		this.CountryCode_arr["id"] = "Indonesia";
		this.CountryCode_arr["ie"] = "Ireland";
		this.CountryCode_arr["il"] = "Israel";
		this.CountryCode_arr["in"] = "India";
		this.CountryCode_arr["int"] = "International";
		this.CountryCode_arr["io"] = "British Indian Ocean Territory";
		this.CountryCode_arr["iq"] = "Iraq";
		this.CountryCode_arr["ir"] = "Iran";
		this.CountryCode_arr["is"] = "Iceland";
		this.CountryCode_arr["it"] = "Italy";
		this.CountryCode_arr["jm"] = "Jamaica";
		this.CountryCode_arr["jo"] = "Jordan";
		this.CountryCode_arr["jp"] = "Japan";
		this.CountryCode_arr["ke"] = "Kenya";
		this.CountryCode_arr["kg"] = "Kyrgyz Republic (Kyrgyzstan)";
		this.CountryCode_arr["kh"] = "Cambodia, Kingdom of";
		this.CountryCode_arr["ki"] = "Kiribati";
		this.CountryCode_arr["km"] = "Comoros";
		this.CountryCode_arr["kn"] = "Saint Kitts & Nevis Anguilla";
		this.CountryCode_arr["kp"] = "North Korea";
		this.CountryCode_arr["kr"] = "South Korea";
		this.CountryCode_arr["kw"] = "Kuwait";
		this.CountryCode_arr["ky"] = "Cayman Islands";
		this.CountryCode_arr["kz"] = "Kazakhstan";
		this.CountryCode_arr["la"] = "Laos";
		this.CountryCode_arr["lb"] = "Lebanon";
		this.CountryCode_arr["lc"] = "Saint Lucia";
		this.CountryCode_arr["li"] = "Liechtenstein";
		this.CountryCode_arr["lk"] = "Sri Lanka";
		this.CountryCode_arr["lr"] = "Liberia";
		this.CountryCode_arr["ls"] = "Lesotho";
		this.CountryCode_arr["lt"] = "Lithuania";
		this.CountryCode_arr["lu"] = "Luxembourg";
		this.CountryCode_arr["lv"] = "Latvia";
		this.CountryCode_arr["ly"] = "Libya";
		this.CountryCode_arr["ma"] = "Morocco";
		this.CountryCode_arr["mc"] = "Monaco";
		this.CountryCode_arr["md"] = "Moldavia";
		this.CountryCode_arr["mg"] = "Madagascar";
		this.CountryCode_arr["mh"] = "Marshall Islands";
		this.CountryCode_arr["mil"] = "USA Military";
		this.CountryCode_arr["mj"] = "Montenegro";
		this.CountryCode_arr["mk"] = "Macedonia";
		this.CountryCode_arr["ml"] = "Mali";
		this.CountryCode_arr["mm"] = "Myanmar";
		this.CountryCode_arr["mn"] = "Mongolia";
		this.CountryCode_arr["mo"] = "Macau";
		this.CountryCode_arr["mp"] = "Northern Mariana Islands";
		this.CountryCode_arr["mq"] = "Martinique (French)";
		this.CountryCode_arr["mr"] = "Mauritania";
		this.CountryCode_arr["ms"] = "Montserrat";
		this.CountryCode_arr["mt"] = "Malta";
		this.CountryCode_arr["mu"] = "Mauritius";
		this.CountryCode_arr["mv"] = "Maldives";
		this.CountryCode_arr["mw"] = "Malawi";
		this.CountryCode_arr["mx"] = "Mexico";
		this.CountryCode_arr["my"] = "Malaysia";
		this.CountryCode_arr["mz"] = "Mozambique";
		this.CountryCode_arr["na"] = "Namibia";
		this.CountryCode_arr["nato"] = "NATO (this was purged in 1996 - see hq.nato.int)";
		this.CountryCode_arr["nc"] = "New Caledonia (French)";
		this.CountryCode_arr["ne"] = "Niger";
		this.CountryCode_arr["net"] = "Network";
		this.CountryCode_arr["nf"] = "Norfolk Island";
		this.CountryCode_arr["ng"] = "Nigeria";
		this.CountryCode_arr["ni"] = "Nicaragua";
		this.CountryCode_arr["nl"] = "Netherlands";
		this.CountryCode_arr["no"] = "Norway";
		this.CountryCode_arr["np"] = "Nepal";
		this.CountryCode_arr["nr"] = "Nauru";
		this.CountryCode_arr["nt"] = "Neutral Zone";
		this.CountryCode_arr["nu"] = "Niue";
		this.CountryCode_arr["nz"] = "New Zealand";
		this.CountryCode_arr["om"] = "Oman";
		this.CountryCode_arr["org"] = "Non-Profit Making Organisations (sic)";
		this.CountryCode_arr["pa"] = "Panama";
		this.CountryCode_arr["pe"] = "Peru";
		this.CountryCode_arr["pf"] = "Polynesia (French)";
		this.CountryCode_arr["pg"] = "Papua New Guinea";
		this.CountryCode_arr["ph"] = "Philippines";
		this.CountryCode_arr["pk"] = "Pakistan";
		this.CountryCode_arr["pl"] = "Poland";
		this.CountryCode_arr["pm"] = "Saint Pierre and Miquelon";
		this.CountryCode_arr["pn"] = "Pitcairn Island";
		this.CountryCode_arr["pr"] = "Puerto Rico";
		this.CountryCode_arr["pt"] = "Portugal";
		this.CountryCode_arr["pw"] = "Palau";
		this.CountryCode_arr["py"] = "Paraguay";
		this.CountryCode_arr["qa"] = "Qatar";
		this.CountryCode_arr["rb"] = "Serbia";
		this.CountryCode_arr["re"] = "Reunion (French)";
		this.CountryCode_arr["ro"] = "Romania";
		this.CountryCode_arr["ru"] = "Russian Federation";
		this.CountryCode_arr["rw"] = "Rwanda";
		this.CountryCode_arr["sa"] = "Saudi Arabia";
		this.CountryCode_arr["sb"] = "Solomon Islands";
		this.CountryCode_arr["sc"] = "Seychelles";
		this.CountryCode_arr["sd"] = "Sudan";
		this.CountryCode_arr["se"] = "Sweden";
		this.CountryCode_arr["sg"] = "Singapore";
		this.CountryCode_arr["sh"] = "Saint Helena";
		this.CountryCode_arr["si"] = "Slovenia";
		this.CountryCode_arr["sj"] = "Svalbard and Jan Mayen Islands";
		this.CountryCode_arr["sk"] = "Slovak Republic";
		this.CountryCode_arr["sl"] = "Sierra Leone";
		this.CountryCode_arr["sm"] = "San Marino";
		this.CountryCode_arr["sn"] = "Senegal";
		this.CountryCode_arr["so"] = "Somalia";
		this.CountryCode_arr["sr"] = "Suriname";
		this.CountryCode_arr["st"] = "Saint Tome (Sao Tome) and Principe";
		this.CountryCode_arr["su"] = "Former USSR";
		this.CountryCode_arr["sv"] = "El Salvador";
		this.CountryCode_arr["sy"] = "Syria";
		this.CountryCode_arr["sz"] = "Swaziland";
		this.CountryCode_arr["tc"] = "Turks and Caicos Islands";
		this.CountryCode_arr["td"] = "Chad";
		this.CountryCode_arr["tf"] = "French Southern Territories";
		this.CountryCode_arr["tg"] = "Togo";
		this.CountryCode_arr["th"] = "Thailand";
		this.CountryCode_arr["tj"] = "Tadjikistan";
		this.CountryCode_arr["tk"] = "Tokelau";
		this.CountryCode_arr["tm"] = "Turkmenistan";
		this.CountryCode_arr["tn"] = "Tunisia";
		this.CountryCode_arr["to"] = "Tonga";
		this.CountryCode_arr["tp"] = "East Timor";
		this.CountryCode_arr["tr"] = "Turkey";
		this.CountryCode_arr["tt"] = "Trinidad and Tobago";
		this.CountryCode_arr["tv"] = "Tuvalu";
		this.CountryCode_arr["tw"] = "Taiwan";
		this.CountryCode_arr["tz"] = "Tanzania";
		this.CountryCode_arr["ua"] = "Ukraine";
		this.CountryCode_arr["ug"] = "Uganda";
		this.CountryCode_arr["uk"] = "United Kingdom";
		this.CountryCode_arr["um"] = "USA Minor Outlying Islands";
		this.CountryCode_arr["us"] = "United States";
		this.CountryCode_arr["uy"] = "Uruguay";
		this.CountryCode_arr["uz"] = "Uzbekistan";
		this.CountryCode_arr["va"] = "Holy See (Vatican City State)";
		this.CountryCode_arr["vc"] = "Saint Vincent & Grenadines";
		this.CountryCode_arr["ve"] = "Venezuela";
		this.CountryCode_arr["vg"] = "Virgin Islands (British)";
		this.CountryCode_arr["vi"] = "Virgin Islands (USA)";
		this.CountryCode_arr["vn"] = "Vietnam";
		this.CountryCode_arr["vu"] = "Vanuatu";
		this.CountryCode_arr["wf"] = "Wallis and Futuna Islands";
		this.CountryCode_arr["ws"] = "Samoa";
		this.CountryCode_arr["ye"] = "Yemen";
		this.CountryCode_arr["yt"] = "Mayotte";
		this.CountryCode_arr["yu"] = "Yugoslavia";
		this.CountryCode_arr["za"] = "South Africa";
		this.CountryCode_arr["zm"] = "Zambia";
		this.CountryCode_arr["zr"] = "Zaire";
		this.CountryCode_arr["zw"] = "Zimbabwe";
	}
	// Get Country Error code description.
	public function getCodeName (__id)
	{
		var __name = this.CountryCode_arr[__id];
		if (__name == undefined)
		{
			__name = "Unknown";
		}
		return __name;
	}
	/**
	 * <p>Description: Get Class version</p>
	 *
	 * @author András Csizmadia
	 * @version 1.0
	 */
	public function getVersion ():String
	{
		//trace ("%%" + "getVersion" + "%%");
		var __version = this.version;
		return __version;
	}
	/**
	 * <p>Description: Get Class name</p>
	 *
	 * @author András Csizmadia
	 * @version 1.0
	 */
	public function toString ():String
	{
		return ("[" + className + "]");
	}
	// END CLASS
}

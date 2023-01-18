/**
 * GPSConversion
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
 * Project: GPSConversion
 * File: GPSConversion.as
 * Created by: András Csizmadia
 *
 */
// Implementations
import com.vpmedia.core.IFramework;
import mx.events.EventDispatcher;
import com.vpmedia.Delegate;
// Start
class com.vpmedia.utils.GpsUtil extends MovieClip implements IFramework
{
	// START CLASS
	/**
	 * <p>Description: Decl.</p>
	 *
	 * @author András Csizmadia
	 * @version 1.0
	 */
	public var className:String = "GpsUtil";
	public var classPackage:String = "com.vpmedia.utils";
	public var version:String = "2.0.0";
	public var author:String = "András Csizmadia";
	// EventDispatcher
	public var addEventListener:Function;
	public var removeEventListener:Function;
	public var dispatchEvent:Function;
	public var dispatchQueue:Function;
	/**
	 * <p>Description: Constructor</p>
	 *
	 * @author András Csizmadia
	 * @version 1.0
	 */
	function GpsUtil ()
	{
		EventDispatcher.initialize (this);
		WGS_GK_sptab = Array (19.302867257309940, 47.249256065058470, 19.304476695833880, 47.249599892680150);
		WGS_GK_vtab = Array (0, 1.994470770779322E-006, 1.488197111970393E-005, -9.999910960077663E-001, -1.209595946567990E-006, 4.058537916544679E-007, -1.769608275779716E-006, 5.323206883794172E-007, -1.873513420714942E-008, 1.711323539566677E-006, 1.274006951910734E-006, 8.881811139642477E-008, -1.034992051222070E-007, 5.859407358889408E-007, 1.360853346433319E-007, 7.961570142682142E-007, -4.548839025572330E-008, 4.672030988661885E-009, 8.115438504590858E-008, -5.380802702682799E-007, -1.194959546202321E-006, 1.232512559499496E-008);
		WGS_GK_wtab = Array (0, -3.651782918428801E-006, -9.999984040034487E-001, -2.744258062654284E-005, 1.729250686965232E-006, -1.650179863495445E-006, 4.310270358554220E-006, -7.288072025557876E-007, -3.956331251673465E-007, 1.149712137595569E-006, -2.648523141982078E-006, -1.050225430505119E-007, 1.312705767336386E-007, -2.593265474708148E-007, 1.948200672541805E-006, -4.596681426634352E-006, 8.530348725015583E-008, -1.588568353875511E-007, 2.843481499137538E-007, 9.131207185888350E-008, 2.299696468663950E-007, -8.392362531979707E-007);
		GK_EOV_sptab = Array (19.304476681286550, 47.249600051169590, 668681.1163157895, 213260.2084210527);
		GK_EOV_vtab = Array (0, 1542.201484504271000, -248.175720189985100, -111168.993758289000000, -484.117492422473600, 4.393715504297376, -11.368024804104980, -2.902083812730282E-002, 9.182040541077439, -2.641504203698521E-001, -5.898046607453989, 5.053218787374092E-003, 2.603094074924560E-002, -1.409346621916045E-001, 1.047783385448708E-001, -1.431526101709165E-001, 3.623259040334425E-003, -8.850215197829688E-003, 5.887466732891530E-003, -3.184179404336629E-003, 2.181339015469002E-001, -3.268621158519169E-003);
		GK_EOV_wtab = Array (0, -651.312789993438100, -75696.412635766810000, 363.975394380253600, 1.398929672029684, 1422.416708632149000, -3.689316452960405E-001, 2.116557332963998, 3.462520373043620E-002, -1.569027004682901E-001, 3.991221070111424E-001, 1.297201939302248E-002, -1.015462159951873E-001, 7.435064577358319E-002, -1.199688302737911E-002, 3.446829909692077E-001, -5.443974878287516E-003, -8.558072975802800E-004, 1.641894072276084E-002, -3.443957421496169E-002, 9.284547428923595E-002, -7.129883545595517E-002);
		EOV_WGS_sptab = Array (6.686811163157894, 2.132602084210526, 19.302867142105260, 47.249256068421050);
		EOV_WGS_vtab = Array (0., -1.389346302296581E-002, 2.831051369736226E-003, -8.995273182444177E-001, 7.604064482862907E-003, 4.967015339995485E-005, 8.631367816723606E-005, -8.022654203907561E-007, 1.257606424116442E-004, 1.205961554542139E-006, 3.774432450230807E-005, -7.666184426238757E-007, -2.944782243063789E-007, 2.119433442075802E-006, -1.031448749770506E-006, 2.908844783304452E-007, 3.794007440847319E-008, 1.888272007847316E-007, -3.020662118318374E-007, 8.574721117742268E-007, -6.945888828184749E-007, -9.565641665696682E-009);
		EOV_WGS_wtab = Array (0., 8.543809825502319E-003, -1.321399864762058, -4.157635053997734E-003, 7.179927971415591E-005, -2.233913022628941E-002, -6.983677125129497E-005, 1.259158610444358E-004, 3.248808131515476E-006, -3.749610036201226E-004, -2.167397891004658E-006, -2.135320596732371E-007, 7.771437902469193E-006, -6.916062867883154E-007, -7.353443740667734E-006, -6.456221341945349E-008, -7.627132599514393E-008, 3.945874285553073E-007, -4.770309421567439E-007, 2.111119668870645E-007, -1.148366910964295E-006, 7.197970309876090E-007);
	}
	///////////////////////////////////////////////////////////////////////////////
	// EOV <-> WGS converter
	// EOV koordináta WGS koordinátára, WGS koordináta EOV koordinátára átszámolása
	// Copyright (c)Psoft Kft. 2002-2005
	// @author Békefi Gábor
	// @version 1.0
	///////////////////////////////////////////////////////////////////////////////
	var WGS_GK_sptab;
	var WGS_GK_vtab;
	var WGS_GK_wtab;
	var GK_EOV_sptab;
	var GK_EOV_vtab;
	var GK_EOV_wtab;
	var EOV_WGS_sptab;
	var EOV_WGS_vtab;
	var EOV_WGS_wtab;
	///////////////////////////////////////////////////////////////////////////////
	private function EOVWGS_convert (sptab, vtab, wtab, srcx, srcy)
	{
		vg = srcy - sptab[1];
		wg = srcx - sptab[0];
		yg = vtab[1] + vtab[2] * wg + vtab[3] * vg + vtab[4] * wg * wg + vtab[5] * vg * wg + vtab[6] * vg * vg + vtab[7] * wg * wg * wg + vtab[8] * wg * wg * vg + vtab[9] * wg * vg * vg + vtab[10] * vg * vg * vg + vtab[11] * wg * wg * wg * wg + vtab[12] * wg * wg * wg * vg + vtab[13] * wg * wg * vg * vg + vtab[14] * wg * vg * vg * vg + vtab[15] * vg * vg * vg * vg + vtab[16] * wg * wg * wg * wg * wg + vtab[17] * wg * wg * wg * wg * vg + vtab[18] * wg * wg * wg * vg * vg + vtab[19] * wg * wg * vg * vg * vg + vtab[20] * wg * vg * vg * vg * vg + vtab[21] * vg * vg * vg * vg * vg;
		xg = wtab[1] + wtab[2] * wg + wtab[3] * vg + wtab[4] * wg * wg + wtab[5] * vg * wg + wtab[6] * vg * vg + wtab[7] * wg * wg * wg + wtab[8] * wg * wg * vg + wtab[9] * wg * vg * vg + wtab[10] * vg * vg * vg + wtab[11] * wg * wg * wg * wg + wtab[12] * wg * wg * wg * vg + wtab[13] * wg * wg * vg * vg + wtab[14] * wg * vg * vg * vg + wtab[15] * vg * vg * vg * vg + wtab[16] * wg * wg * wg * wg * wg + wtab[17] * wg * wg * wg * wg * vg + wtab[18] * wg * wg * wg * vg * vg + wtab[19] * wg * wg * vg * vg * vg + wtab[20] * wg * vg * vg * vg * vg + wtab[21] * vg * vg * vg * vg * vg;
		var desty = sptab[3] - yg;
		var destx = sptab[2] - xg;
		return Array (destx, desty);
	}
	///////////////////////////////////////////////////////////////////////////////
	private function EOVWGSchk (eovx, eovy)
	{
		return ((eovx >= 420000) && (eovx <= 940000)) && ((eovy >= 37000) && (eovy <= 370000));
	}
	///////////////////////////////////////////////////////////////////////////////
	private function WGSEOVchk (lat, lon)
	{
		return ((lon > 15) && (lon < 23)) && ((lat > 45) && (lat < 49));
	}
	///////////////////////////////////////////////////////////////////////////////
	private function EOVWGS (eovx, eovy)
	{
		if (EOVWGSchk (eovx, eovy))
		{
			eovx = (parseFloat (eovx) / 100000);
			eovy = (parseFloat (eovy) / 100000);
			return EOVWGS_convert (EOV_WGS_sptab, EOV_WGS_vtab, EOV_WGS_wtab, eovx, eovy);
		}
		else
		{
			trace ("Error EOVWGS");
			return;
		}
	}
	///////////////////////////////////////////////////////////////////////////////
	private function WGSEOV (lat, lon)
	{
		if (WGSEOVchk (lat, lon))
		{
			var a = EOVWGS_convert (WGS_GK_sptab, WGS_GK_vtab, WGS_GK_wtab, lon, lat);
			return EOVWGS_convert (GK_EOV_sptab, GK_EOV_vtab, GK_EOV_wtab, a[0], a[1]);
		}
		else
		{
			trace ("Error WGSEOV");
			return;
		}
	}
	//trace (EOVWGS (648569, 238965));
	// eger aktualis poziciojanak megallapitasa EOV koordinataban
	///////////////////////////////////////////////////////////////////////////////
	// ****************************************************************************
	// DISPLAY functions
	// felhasznaloi feluleten megjelenito fuggvenyek
	///////////////////////////////////////////////////////////////////////////////
	// kirja a koordinatat, ahol jar az eger
	public static function mapDisplayCoord ()
	{
		var xstr = "-";
		var ystr = "-";
		// kurzor eov koordinata lekerdezes
		var wgscoord = EOVWGS (_root._xmouse, _root._ymouse);
		// ha orszagon kivul van, akkor 0                   
		// fok, perc, masodperc formatumra szamolas
		trace (parseInt (wgscoord[1]));
		var coord = wgscoord[1];
		var f = coord;
		var p = (coord - f) * 60;
		var mp = (((coord - f) * 60) - p) * 6000 / 100;
		if (p < 10)
		{
			p = "0" + p;
		}
		if (mp < 10)
		{
			mp = "0" + mp;
		}
		xstr = f + "° " + p + "' " + mp + "\"";
		f = wgscoord[0];
		p = (wgscoord[0] - f) * 60;
		mp = (((wgscoord[0] - f) * 60) - p) * 6000 / 100;
		if (p < 10)
		{
			p = "0" + p;
		}
		if (mp < 10)
		{
			mp = "0" + mp;
		}
		ystr = f + "° " + p + "' " + mp + "\"";
		//eov koordinatak kijelzese
		trace (xstr + "," + ystr);
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

import net.manaca.lang.BObject;
import net.manaca.data.map.KeyMap;
import net.manaca.util.StringUtil;

/**
 * sina天气预报分析
 * @author Wersling
 * @version 1.0, 2006-5-8
 * 
 * @example
 * 		<pre>
  		var _textLoader:TextLoader = new TextLoader();
		_textLoader.addEventListener("onLoadComplete",Delegate.create(this,onLoadComplete));
		_textLoader.load("http://weather.sina.com.cn/images/figureWeather/map/wholeNation.html");
 		var _was:WeatherAnalyseBySina = new WeatherAnalyseBySina();
		var _m:KeyMap = _was.Analyse(unescape(e.text));</pre>

 * @see
 * <li>全国：http://weather.sina.com.cn/images/figureWeather/map/wholeNation.html</il>
 * <li>东北：http://weather.sina.com.cn/images/figureWeather/map/northEast.html</il>
 * <li>华北：http://weather.sina.com.cn/images/figureWeather/map/northOfChina.html</il>
 * <li>华东：http://weather.sina.com.cn/images/figureWeather/map/eastOfChina.html</il>
 * <li>中南：http://weather.sina.com.cn/images/figureWeather/map/southOfChina.html</il>
 * <li>西北：http://weather.sina.com.cn/images/figureWeather/map/northWest.html</il>
 * <li>西南：http://weather.sina.com.cn/images/figureWeather/map/southWest.html</il>
 * <li>亚洲：http://weather.sina.com.cn/images/figureWeather/map/aisa.html</il>
 * <li>欧洲：http://weather.sina.com.cn/images/figureWeather/map/europe.html</il>
 * <li>北美洲：http://weather.sina.com.cn/images/figureWeather/map/northAmerica.html</il>
 * <li>南美洲：http://weather.sina.com.cn/images/figureWeather/map/southAmerica.html</il>
 * <li>非洲：http://weather.sina.com.cn/images/figureWeather/map/africa.html</il>
 * <li>大洋洲 ：http://weather.sina.com.cn/images/figureWeather/map/oceania.html</il>
 * </pre>
 */
class net.manaca.app.WeatherAnalyseBySina extends BObject {
	private var className : String = "net.manaca.app.WeatherAnalyseBySina";
	/** 全国 */
	static public var wholeNation:String = "http://weather.sina.com.cn/images/figureWeather/map/wholeNation.html";
	/** 东北 */
	static public var northEast:String = "http://weather.sina.com.cn/images/figureWeather/map/northEast.html";
	/** 华北 */
	static public var northOfChina:String = "http://weather.sina.com.cn/images/figureWeather/map/northOfChina.html";
	/** 华东 */
	static public var eastOfChina:String = "http://weather.sina.com.cn/images/figureWeather/map/eastOfChina.html";
	/** 中南 */
	static public var southOfChina:String = "http://weather.sina.com.cn/images/figureWeather/map/southOfChina.html";
	/** 西北 */
	static public var northWest:String = "http://weather.sina.com.cn/images/figureWeather/map/northWest.html";
	/** 西南 */
	static public var southWest:String = "http://weather.sina.com.cn/images/figureWeather/map/southWest.html";
	/** 亚洲 */
	static public var aisa:String = "http://weather.sina.com.cn/images/figureWeather/map/aisa.html";
	/** 欧洲 */
	static public var europe:String = "http://weather.sina.com.cn/images/figureWeather/map/europe.html";
	/** 北美洲 */
	static public var northAmerica:String = "http://weather.sina.com.cn/images/figureWeather/map/northAmerica.html";
	/** 南美洲 */
	static public var southAmerica:String = "http://weather.sina.com.cn/images/figureWeather/map/southAmerica.html";
	/** 非洲 */
	static public var africa:String = "http://weather.sina.com.cn/images/figureWeather/map/africa.html";
	/** 大洋洲 */
	static public var oceania:String = "http://weather.sina.com.cn/images/figureWeather/map/oceania.html";
	
	/**
	 * 构造 WeatherAnalyseBySina 
	 */
	public function WeatherAnalyseBySina() {
		super();
	}
	
	/**
	 * 处理指定的字符并返回一个具有天气信息数据的 KeyMap 
	 * @param html html字符串，通过TextLoader从网络加载
	 * @return KeyMap 返回一个具有天气信息数据的 KeyMap 
	 */
	public function Analyse (html:String):KeyMap{
		var _map:KeyMap = new KeyMap();
		//获取有效字符
		html = html.toUpperCase();
		html = StringUtil.intercept (html, "SUDS_CODE_END", "COPYRIGHT");
		var _arrWeatherList:Array = html.split ("<AREA");
		for (var i in _arrWeatherList){
			_arrWeatherList [i] = StringUtil.intercept (_arrWeatherList [i] , "城市:", "<BR> ');");
			_arrWeatherList [i] = StringUtil.replace(_arrWeatherList [i]," ","");
			if (_arrWeatherList [i] == undefined) _arrWeatherList.splice(i,1);
			_arrWeatherList [i] = _arrWeatherList [i].split ("<BR>");
			//转为对象保存
			var _obj:Object = new Object();
			_obj.city = _arrWeatherList [i][0].substring(3);
			_obj.weather = _arrWeatherList [i][1].substring(3);
			_obj.temperature = _arrWeatherList [i][2].substring(3);
			if(_arrWeatherList [i].length > 4){
				_obj.vane = _arrWeatherList [i][3].substring(3);
				_obj.power = _arrWeatherList [i][4].substring(3);
			}else{
				_obj.power = _arrWeatherList [i][3].substring(3);
			}
			_map.put(_obj.city,_obj);
		}
		return _map;
	}
}
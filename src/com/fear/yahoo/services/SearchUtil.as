import com.yahoo.xml.SimpleXML;

class com.fear.yahoo.services.SearchUtil
{
	public static var YSearchServiceURL:String = 'http://api.search.yahoo.com/';

	public static function getServiceURL(needle:String, searchType:String):String
	{
		var query:String;
		var zip:String;
		var serviceURL:String;
		// chack for zip
		if(arguments[2] != undefined)
		{
			zip = '&zip=' + arguments[2];
		}
		if(arguments[3] != undefined)
		{
			zip = '&start=' + arguments[3];
		}
		// ensure presence of required parameters
		if(needle == undefined || searchType == undefined)
		{
			return undefined;
		}
		else
		{
			query = '?appid=YahooDemo&query=';
		}
		// access Y! search string
		query += needle;
		// add zip if need be
		if(zip != undefined)
		{
			query += zip;
		}
		var services:Array = new Array;
		services['image'] = SearchUtil.YSearchServiceURL + 'ImageSearchService/V1/imageSearch';
		services['news']  = SearchUtil.YSearchServiceURL + 'NewsSearchService/V1/newsSearch';
		services['video'] = SearchUtil.YSearchServiceURL + 'VideoSearchService/V1/videoSearch';
		services['web']   = SearchUtil.YSearchServiceURL + 'WebSearchService/V1/webSearch';
		// local search is on a different host
		services['local'] = 'http://api.local.yahoo.com/LocalSearchService/V1/localSearch';
		// build service url
		serviceURL = services[searchType].concat(query);
		
		trace('[SearchUtil] getServiceURL: ' + serviceURL);
		_root.debug.htmlText = 'serviceURL:'+serviceURL;
		
		return serviceURL;
	}
}
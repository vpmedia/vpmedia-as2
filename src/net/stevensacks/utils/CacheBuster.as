class net.stevensacks.utils.CacheBuster
{
	public static function create(url:String):String
	{
		if (_root.url.indexOf("http") > -1) 
		{
			var d:Date = new Date();
			var nc:String = "nocache=" + d.getTime();
			if (url.indexOf("?") > -1) return url + "&" + nc;
			return url + "?" + nc;
		}
		return url;
	}
}
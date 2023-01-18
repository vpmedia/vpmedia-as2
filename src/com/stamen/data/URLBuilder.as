/*
 * vim:et sts=4 sw=4 cindent:
 * $Id: URLBuilder.as 477 2006-10-31 20:50:08Z allens $
 */

class com.stamen.data.URLBuilder
{
    /**
     * Build a URL with a base URL and optional object containing query string
     * parameters. If the base URL already contains query string parameters, the
     * new ones are simply appended.
     *
     * @param   String  requestURL      the base request URL
     * @param   Object  args            query string arguments
     * @return  String                  a URL with query string
     *
     * @see     queryString()
     */
    public static function build(requestURL:String, args:Object):String
    {
        var glue:String = (requestURL.indexOf('?') > -1) ? '&' : '?';
        return requestURL + glue + URLBuilder.queryString(args);
    }

    /**
     * Build a query string URL using an object's property/value pairs.
     *
     * @param   Object  args    an object with iterable properties that can be
     *                          used as keys for query string variables.
     * @return  String          a query string *WITHOUT* the preceding '?'
     */
    public static function queryString(args:Object):String
    {
        var parts:Array = new Array();
        for (var a:String in args)
            parts.push(escape(a) + '=' + escape(args[a]));

        return (parts.length > 0) ? parts.join('&') : '';
    }
}

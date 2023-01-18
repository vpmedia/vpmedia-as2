/*
 * vim:et sts=4 sw=4 cindent:
 * $Id: Request.as 663 2007-02-13 01:18:28Z allens $
 */

/**
 * The Request class is a thin layer on top of Flash's built-in XML class that
 * does automatically does a couple of nice things:
 *
 * 1. sets "ignoreWhite" to true
 * 2. remembers the URL requested, and the HTTP status code of the response
 */
class com.digg.services.Request extends XML
{
    public var url:String;
    public var HTTPStatus:Number;

    public function Request(url:String)
    {
        if (url) load(url);
    }

    public function load(url:String):Void
    {
        this.url = url;
        ignoreWhite = true;
        super.load(url);
    }

    public function onHTTPStatus(statusCode:Number):Void
    {
        HTTPStatus = statusCode;
    }
}

/*
 * vim:et sts=4 sw=4 cindent:
 * $Id$
 */

class com.digg.services.ResponseError
{
    public var url:String;
    public var code:Number;
    public var text:String;

    public function ResponseError(url:String, code:Number, text:String)
    {
        this.url = url;
        this.code = code;
        this.text = text;
    }

    public function toString():String
    {
        return '[ResponseError "' + url + '" (' + code + '): ' + text + ']';
    }
}

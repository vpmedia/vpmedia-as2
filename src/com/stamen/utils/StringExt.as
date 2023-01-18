/*
 * vim:et sts=4 sw=4 cindent:
 * $Id: StringExt.as 391 2006-09-21 02:33:27Z allens $
 */

class com.stamen.utils.StringExt extends String
{
    public static function zerofill(n:Object, len:Number, truncate:Boolean):String
    {
        var str:String = String(n);
        if (null == len) len = 2;
        while (str.length < len)
            str = '0' + str;
        return str;
    }

    public static function capitalize(str:String):String
    {
        return str.substr(0, 1).toUpperCase() + str.substr(1);
    }
}

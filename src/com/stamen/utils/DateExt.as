/*
 * vim:et sts=4 sw=4 cindent:
 * $Id: DateExt.as 651 2007-02-10 01:23:43Z allens $
 */

import com.stamen.utils.StringExt;

class com.stamen.utils.DateExt extends Date
{
    public static var months:Array = ['January', 'February', 'March', 'April',
                                      'May', 'June', 'July', 'August',
                                      'September', 'October', 'November', 'December'];
    public static var days:Array = ['Sunday', 'Monday', 'Tuesday', 'Wednesday',
                                    'Thursday', 'Friday', 'Saturday'];

    public static var PERIOD_YEAR:String = 'year';
    public static var PERIOD_MONTH:String = 'month';
    public static var PERIOD_DAY:String = 'date';
    public static var PERIOD_HOUR:String = 'hour';
    public static var PERIOD_MINUTE:String = 'minute';
    public static var PERIOD_SECOND:String = 'second';

    public static function fromTimestamp(timestamp):DateExt
    {
        return new DateExt(Number(timestamp) * 1000);
    }

    public static function fromString(text:String):DateExt
    {
        var year:Number = parseInt(text.substr(0, 4));
        var month:Number = parseInt(text.substr(5, 2));
        var day:Number = parseInt(text.substr(8, 2));
        var hour:Number = parseInt(text.substr(11, 2));
        var minute:Number = parseInt(text.substr(14, 2));
        var second:Number = parseInt(text.substr(17, 2));
        return new DateExt(year, month - 1, day, hour, minute, second);
    }

    public static function getRelative(offset:Number, period:String):DateExt
    {
        var d:DateExt = new DateExt();
        d.applyOffset(offset, period);
        return d;
    }

    public function copy():DateExt
    {
        return DateExt.fromTimestamp(toTimestamp());
    }

    public function applyOffset(offset:Number, period:String):Boolean
    {
        if (!isFinite(offset) || offset == 0) return false;

        if (null == period) period = PERIOD_SECOND;
        var method:String = period.substr(0, 1).toUpperCase() + period.substr(1);

        this['set' + method](this['get' + method]() + offset);
    }

    public function DateExt(year:Number, month:Number, day:Number, hour:Number,
                            minute:Number, second:Number, ms:Number)
    {
        if (null == year)
            super()
        else if (null == month)
            super(year)
        else
            super(year, month, day, hour, minute, second, ms);
    }

    public function toTimestamp():Number
    {
        return (getTime() / 1000) >> 0;
    }

    public function getMonth(actual:Boolean):Number
    {
        return actual ? super.getMonth() + 1 : super.getMonth();
    }

    public function formatDate(fancy:Boolean):String
    {
        if (fancy)
        {
            return days[getDay()] + ', ' + months[getMonth()] + ' ' + getDate();
        }
        
        return getFullYear() + '-' +
               StringExt.zerofill(getMonth(true), 2) + '-' +
               StringExt.zerofill(getDate(), 2);
    }

    public function getHours(military:Boolean):Number
    {
        if (military || null == military)
        {
            return super.getHours();
        }
        else
        {
            var h:Number = super.getHours() % 12;
            return (h == 0) ? 12 : h;
        }
    }

    public function getMeridian():String
    {
        return (super.getHours() >= 12) ? 'pm' : 'am';
    }

    public function formatTime(fancy:Boolean):String
    {
        if (fancy)
        {
            return getHours(false) + getMeridian();
        }
        else
        {
            return StringExt.zerofill(getHours(), 2) + ':' +
                   StringExt.zerofill(getMinutes(), 2) + ':' +
                   StringExt.zerofill(getSeconds(), 2);
        }
    }

    public function format(showTime:Boolean, fancy:Boolean):String
    {
        if (null == showTime) showTime = true;

        var str:String = formatDate(fancy);
        if (showTime)
            str += ' ' + formatTime(fancy);
        return str;
    }

    public function toString():String
    {
        return '[DateExt ' + format(true) + ']';
    }
}

/*
 * vim:et sts=4 sw=4 cindent tw=120:
 * $Id: MathExt.as 199 2006-06-30 17:40:40Z allens $
 */

class com.stamen.utils.MathExt extends Math
{
	/**
	 * @param	min		Number	the minimum value
	 * @param	max		Number	the maximum value
	 * @param	round	Boolean	whether or not to round the result
	 * @return	Number			a random number between {min} and {max}
     */
    public static function random(min:Number, max:Number, round:Boolean):Number
    {
        var n:Number = min + Math.random() * (max - min);
        return round ? Math.round(n) : n;
    }
    /**
     * @param	value	Number	the value you wish to constrain
     * @param	min		Number	the minimum bound
     * @param	max		Number	the maximum bound
     * @return			Number	the new value
     */
    public static function bound(value:Number, min:Number, max:Number):Number
    {
        if (!isFinite(value)) value = 0;
        return Math.min(max, Math.max(min, value));
    }

    public static function scaleMinMax(value:Number, min:Number, max:Number, bound:Boolean):Number
    {
        if (null == bound || bound)
            value = MathExt.bound(value, min, max);
        return (value - min) / (max - min);
    }

    /**
     * @param	x1	Number	the x value of point 1
     * @param	y2	Number	the y value of point 1
     * @param	x2	Number	the x value of point 2
     * @param	y2	Number	the y value of point 2
     * @return		Number	the angle of the line between points 1 and 2, in radians
     */
    public static function angle(x1:Number, y1:Number, x2:Number, y2:Number):Number
    {
        return Math.atan2(y2 - y1, x2 - x1);
    }
    
    /**
     * @param	x1	Number	the x value of point 1
     * @param	y2	Number	the y value of point 1
     * @param	x2	Number	the x value of point 2
     * @param	y2	Number	the y value of point 2
     * @return		Number	the distance between points 1 and 2
     */
    public static function distance(x1:Number, y1:Number, x2:Number, y2:Number):Number
    {
        var x:Number = x2 - x1;
        var y:Number = y2 - y1;
        if (x == 0 && y == 0) return 0;
        return Math.sqrt(x * x + y * y);
    }

    /**
     * @param	radians	Number
     * @return			Number	the provided angle in degrees
     * @see		radians()
     */
    public static function degrees(radians:Number):Number
    {
        var degrees:Number = radians * 180 / Math.PI;
        while (degrees < 0) degrees += 360;
        return degrees % 360;
    }
    
    /**
     * @param	degrees	Number
     * @return			Number	the provided angle in radians
     * @see		degrees()
     */
    public static function radians(degrees:Number):Number
    {
        return degrees * Math.PI / 180;
    }
}

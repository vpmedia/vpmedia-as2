/*
 * vim:et sts=4 sw=4 cindent tw=120:
 * $Id: ColorModel.as,v 1.1 2006/06/28 01:08:57 allens Exp $
 */

import com.stamen.display.color.IColorModel;

class com.stamen.display.color.ColorModel extends Object
{
    private function _blend(color:IColorModel, amount:Number):Array
    {
        if (null == amount) amount = 0.5;

        var c1:Array = this.toArray();
        var c2:Array = color.toArray();
        var c3:Array = new Array();
        for (var i:Number = 0; i < c1.length; i++)
            c3[i] = c1[i] + (c2[i] - c1[i]) * amount;

        return c3;
    }

	public function toArray():Array
	{
        return [];
	}
}

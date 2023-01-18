/*
 * vim:et sts=4 sw=4 cindent:
 * $Id$
 */

import com.stamen.display.color.*;

interface com.stamen.display.color.IColorModel
{
    public function copy():IColorModel;

    public function toHex():Number;
    public function toArray():Array;
    public function toRGB():RGB;
    public function toHSV():HSV;

    public function blend(color:IColorModel, amount:Number, asRGB:Boolean):IColorModel;
}

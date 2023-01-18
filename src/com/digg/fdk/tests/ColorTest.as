/*
 * vim:et sts=4 sw=4 cindent:
 * $Id: ColorTest.as 586 2007-01-11 21:35:21Z allens $
 */

import asunit.framework.TestCase;

import com.stamen.display.color.*;
import com.stamen.display.Draw;

class com.digg.fdk.tests.ColorTest extends TestCase
{
    public function testRed():Void
    {
        var redRGB:RGB = new RGB(255, 0, 0);
        assertEquals("redRGB.red = 255", redRGB.red, 255);

        var redHSV:HSV = redRGB.toHSV();
        assertEquals('redHSV.hue == 0', redHSV.hue, 0);
        assertEquals('redHSV.sat == 1', redHSV.sat, 1);

        this.compareRGB(redRGB, redHSV.toRGB());
    }

    public function testConversions():Void
    {
        var rgb:RGB = RGB.random();
        var hsv:HSV = rgb.toHSV();

        this.compareRGB(rgb, hsv.toRGB());
    }

    private function compareRGB(rgb1:RGB, rgb2:RGB):Void
    {
        assertEquals('rgb1.red == rgb2.red', rgb1.red, rgb2.red);
        assertEquals('rgb1.green == rgb2.green', rgb1.green, rgb2.green);
        assertEquals('rgb1.blue == rgb2.blue', rgb1.blue, rgb2.blue);
    }
}

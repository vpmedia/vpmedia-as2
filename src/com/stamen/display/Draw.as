/*
 * vim:et sts=4 sw=4 cindent tw=120:
 * $Id: Draw.as,v 1.10 2006/07/21 00:25:40 allens Exp $
 */

import com.stamen.utils.MathExt;
import com.stamen.display.color.*;
import com.digg.geo.*;

class com.stamen.display.Draw
{
    public static function line(mc:MovieClip, x1:Number, y1:Number, x2:Number, y2:Number):Void
    {
        if (null != x2 && null != y2)
        {
            mc.moveTo(x1, y1);
            mc.lineTo(x2, y2);
        }
        else
        {
            mc.lineTo(x1, y1);
        }
    }

    public static function rect(mc:MovieClip, r, y1:Number, w:Number, h:Number):Void
    {
        var x1:Number = r;
        if (r instanceof flash.geom.Rectangle)
        {
            x1 = r.x;
            y1 = r.y;
            w = r.width;
            h = r.height;
        }

        var x2:Number = x1 + w;
        var y2:Number = y1 + h;
        mc.moveTo(x1, y1);
        mc.lineTo(x2, y1);
        mc.lineTo(x2, y2);
        mc.lineTo(x1, y2);
        mc.lineTo(x1, y1);
    }

    public static function bounds(mc:MovieClip, bounds:Object):Void
    {
        Draw.rect(mc, bounds.xMin, bounds.yMin, bounds.xMax - bounds.xMin, bounds.yMax - bounds.yMin);
    }

    public static function x(mc:MovieClip, x1:Number, y1:Number, w:Number, h:Number):Void
    {
        if (null == w) w = 10;
        x1 -= (w / 2);
        var x2:Number = x1 + w;
        if (null == h) h = w;
        y1 -= (h / 2);
        var y2:Number = y1 + h;
        mc.moveTo(x1, y1);
        mc.lineTo(x2, y2);
        mc.moveTo(x1, y2);
        mc.lineTo(x2, y1);
    }

    public static function circle(mc:MovieClip, x:Number, y:Number, r:Number):Void
    {
        if (null == mc) mc = _root;
        if (null == x) x = 0;
        if (null == y) y = 0;
        if (null == r) r = mc.__width || mc._width;

        var c1:Number = Math.tan(Math.PI / 8);
        var c2:Number = Math.sin(Math.PI / 4);

		mc.moveTo(x + r, y);
		mc.curveTo(r + x, c1 * r + y, c2 * r + x, c2 * r + y);
		mc.curveTo(c1 * r + x, r + y, x, r + y);
		mc.curveTo(-c1 * r + x, r + y, -c2 * r + x, c2 * r + y);
		mc.curveTo(-r + x, c1 * r + y, -r + x, y);
		mc.curveTo(-r + x, -c1 * r + y, -c2 * r + x, -c2 * r + y);
		mc.curveTo(-c1 * r + x, -r + y, x, -r + y);
		mc.curveTo(c1 * r + x, -r + y, c2 * r + x, -c2 * r + y);
		mc.curveTo(r + x, -c1 * r + y, r + x, y);
    }

    public static function arc(mc:MovieClip, radius:Number, angle1:Number, angle2:Number, x:Number, y:Number, steps:Number, first:Boolean):Void
    {
        if (null == x) x = 0;
        if (null == y) y = 0;
        if (null == steps) steps = MathExt.degrees(Math.round(angle2 - angle1)) / 5;

        var center:Point = new Point(x, y);
        var polar:PolarCoordinate = new PolarCoordinate(angle1, radius);
        var step:Number = (angle2 - angle1) / (steps - 1);
        for (var i:Number = 0; i < steps; i++)
        {
            var p:Point = polar.toCartesian(center);
            if (i == 0 && first)
            {
                mc.moveTo(p.x, p.y);
            }
            else
            {
                mc.lineTo(p.x, p.y);
            }
            polar.theta += step;
        }
    }

    public static function roundRect(mc:MovieClip, x:Number, y:Number, w:Number, h:Number, r:Number):Void
    {
        if (null == r) r = Math.min(Math.min(w / 2, h / 2), 4);
        if (w < 0)
        {
            x += w;
            w = -w;
        }
        if (h < 0)
        {
            y += h;
            h = -h;
        }

        Draw.arc(mc, r, MathExt.radians(-180), MathExt.radians(-90), x + r, y + r, null, true);
        mc.lineTo(x + w - r, y);
        Draw.arc(mc, r, MathExt.radians(-90), MathExt.radians(0), x + w - r, y + r);
        mc.lineTo(x + w, y + h - r);
        Draw.arc(mc, r, MathExt.radians(0), MathExt.radians(90), x + w - r, y + h - r);
        mc.lineTo(x + r, y + h);
        Draw.arc(mc, r, MathExt.radians(90), MathExt.radians(180), x + r, y + h - r);
        mc.lineTo(x, y + r);
    }

    public static function gradient(mc:MovieClip, fillType:String,
                                    colors:Array, alphas:Array, ratios:Array,
                                    matrix:Object):Void
    {
        if (null == fillType)
        {
            fillType = 'linear';
        }

        if (null == alphas)
        {
            alphas = new Array();
            var alpha:Number = 100;
            for (var i:Number = 0; i < colors.length; i++)
                alphas[i] = alpha;
        }

        if (null == ratios)
        {
            ratios = new Array();
            for (var i:Number = 0; i < colors.length; i++)
                ratios[i] = (255 * i / (colors.length - 1)) >> 0;
        }

        if (null == matrix || null != matrix.xMin)
        {
            var angle:Number = isFinite(matrix.angle)
                               ? matrix.angle
                               : (isFinite(matrix))
                                 ? matrix
                                 : 90; // top to bottom
            if (null == matrix) matrix = mc.getBounds();
            matrix = {matrixType: 'box',
                      x: matrix.xMin,
                      y: matrix.yMin,
                      w: matrix.xMax - matrix.xMin,
                      h: matrix.yMax - matrix.yMin,
                      r: MathExt.radians(angle)};
        }
        else if (null == matrix.matrixType)
        {
            matrix.matrixType = 'box';

            if (null == matrix.r)
            {
                var angle:Number = matrix.angle ? matrix.angle : 90;
                matrix.r = MathExt.radians(angle);
            }
        }

        mc.beginGradientFill(fillType, colors, alphas, ratios, matrix);
    }

    public static function colorBlend(mc:MovieClip, colors:/*IColorModel*/Array, bounds:Object, steps:Number, asRGB:Boolean, ease:Function):Void
    {
        if (null == steps) steps = 10;
        if (null == colors || colors.length == 0 || steps <= 0) return;

        var w:Number = bounds.xMax - bounds.xMin;
        var h:Number = bounds.yMax - bounds.yMin;
        if (w < 1 || h < 1) return;

        // don't do more than one step per pixel
        steps = Math.min(w, steps);

        var x:Number = bounds.xMin;
        var step:Number = (bounds.xMax - bounds.xMin) / steps;

        var blend:Number = 0;
        var blendStep:Number = 1 / (steps - 1);

        for (var i:Number = 0; i < steps; i++)
        {
            var box:Object = {xMin: x, yMin: bounds.yMin,
                              xMax: (x += step), yMax: bounds.yMax};

            if (ease)
                blend = ease(i, 0, 1, steps - 1);

            var color = colors[0].blend(colors[1], blend, asRGB);
            mc.beginFill(color.toHex(false), isFinite(color.alpha) ? color.alpha : 100);
            Draw.bounds(mc, box);
            mc.endFill();

            if (!ease)
                blend += blendStep;
        }
    }

    public static function polygon(mc:MovieClip, x:Number, y:Number, radius:Number, sides:Number, offset:Number):Void
    {
        if (null == offset) offset = 0;
        var step:Number = 2 * Math.PI / sides;
        var polar:PolarCoordinate, pos:Point;
        for (var i:Number = 0; i < sides; i++)
        {
            if (i == 0)
            {
                polar = new PolarCoordinate(offset, radius);
                pos = polar.toCartesian();
                mc.moveTo(x + pos.x, y + pos.y);
            }
            polar = new PolarCoordinate(step * (i + 1) + offset, radius);
            pos = polar.toCartesian();
            mc.lineTo(x + pos.x, y + pos.y);
        }
    }

    /*
    public static function bezierCurve(mc:MovieClip, start:Point, control1:Point, end:Point, control2:Point, steps:Number):Void
    {
        if (null == steps) steps = 50;

        var dx:Number = end.x - start.x;
        var dy:Number = end.y - start.y;
        // mc.moveTo(start.x, start.y);
        for (var t:Number = 1; t <= steps; t++)
        {
            var x:Number = MathExt.cubicBezier(t, start.x, dx, steps, control1.x, control2.x);
            var y:Number = MathExt.cubicBezier(t, start.y, dy, steps, control1.y, control2.y);
            mc.lineTo(x, y);
        }
    }
    */
}

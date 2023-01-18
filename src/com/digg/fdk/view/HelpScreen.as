/*
 * vim:et sts=4 sw=4 cindent:
 * $Id: HelpScreen.as 602 2007-01-18 23:35:42Z migurski $
 */

import com.stamen.display.Draw;
import com.stamen.display.color.*;
import com.digg.fdk.view.ViewObject;

import mx.transitions.Tween;
import mx.transitions.easing.Regular;

class com.digg.fdk.view.HelpScreen extends ViewObject
{
    public var expiry:Number = 5000;
    private var alreadyHidden:Boolean = false;
    private var fadeDuration:Number = 0.2;

    public var isVisible:Boolean = true;

    public var _text:String = 'This is a help screen.';
    public var textFont:String = 'Helvetica Bold';
    public var textSize:Number = 18;
    public var textAlign:String = 'center';
    public var color:RGB;

    private var __width:Number = 256;
    private var __height:Number = 192;
    public var field:TextField;

    private var tween:Tween;

    public static var symbolName:String = '__Packages.com.digg.fdk.view.HelpScreen';
    public static var symbolOwner:Function = HelpScreen;
    public static var symbolLink:Boolean = Object.registerClass(symbolName, symbolOwner);

    public function init():Void
    {
        if (null == this.color) this.color = RGB.white();
        this.createTextField('field', this.getNextHighestDepth(), 0, 0, this.__width, this.__height);
        var tf:TextFormat = new TextFormat(this.textFont, this.textSize, this.color.toHex());
        tf.align = this.textAlign;
        tf.leading = 4;
        with (this.field)
        {
            setNewTextFormat(tf);
            multiline = wordWrap = true;
            embedFonts = true;
            selectable = false;
            text = _parent._text;

            // border = true;
            // borderColor = 0xFF0000;
        }

        this.tween = new Tween(this, '_alpha', Regular.easeOut,
                               this._alpha, this._alpha,
                               this.fadeDuration, true);
        this.tween.stop();

        this.tween.onMotionChanged = function():Void
        {
            this.obj._visible = this.obj._alpha > 0;
        };

        this['cacheAsBitmap'] = true;
    }

    public function size():Void
    {
        this.field._width = this.__width;
        this.field._height = this.__height;
    }

    public function set text(text:String):Void
    {
        this.field.text = text;
        this.size();
    }

    public function get text():String
    {
        return this.field.text;
    }

    public function show():Void
    {
        this.tween.continueTo(100, this.fadeDuration);
        this.isVisible = true;
    }

    public function hide(auto:Boolean, duration:Number):Void
    {
        if (!auto) this.alreadyHidden = true;

        this.tween.continueTo(0, isFinite(duration) ? duration : this.fadeDuration);
        this.isVisible = false;
    }

    public function expire():Void
    {
        this.resetExpirationInterval(0);
        if (!this.alreadyHidden && this.isVisible)
        {
            this.hide(true, 2);
            this.dispatchEvent({type: 'expired'});
        }
    }
}

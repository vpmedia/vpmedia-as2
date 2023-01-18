/*
 * vim:et sts=4 sw=4 cindent:
 * $Id: TextButton.as 602 2007-01-18 23:35:42Z migurski $
 */

import com.stamen.display.Draw;
import com.stamen.display.color.*;

import com.digg.fdk.view.ViewObject;

class com.digg.fdk.view.controls.TextButton extends ViewObject
{
    public var textColor:RGB;
    public var bgColor:RGBA;
    public var borderColor:RGBA;
    public var font:String = 'Helvetica';

    public var id:String;
    public var text:String;
    public var textSize:Number = 12;
    public var textAlign:String = 'left';
    public var padding:Array = [2, 2, 1, 2];
    public var labelText:TextField;

    public static var symbolName:String = '__Packages.com.digg.fdk.view.controls.TextButton';
    public static var symbolOwner:Function = TextButton;
    public static var symbolLink:Boolean = Object.registerClass(symbolName, symbolOwner);

    public function init():Void
    {
        super.init();

        if (null == this.textColor) this.textColor = RGB.white();
        if (null == this.bgColor) this.bgColor = RGBA.black(90);
        if (null == this.borderColor) this.borderColor = RGBA.fromRGB(this.textColor);

        this.createTextField('labelText', this.getNextHighestDepth(), 0, 0, 0, 0);
        var tf:TextFormat = this.getTextFormat(true);
        with (this.labelText)
        {
            setNewTextFormat(tf);
            multiline = wordWrap = false;
            embedFonts = true;
            autoSize = _parent.textAlign;
        }

        if (null == this.id) this.id = this._name;
        this.label = this.text;
    }

    public function getTextFormat(bold:Boolean):TextFormat
    {
        var font:String = this.font;
        if (bold) font += ' Bold';
        trace('getTextFormat(): got font "' + font + '"');
        return new TextFormat(font, this.textSize, this.textColor.toHex(false), bold);
    }

    public function onPress():Void
    {
        this.dispatchEvent({type: 'click'});
    }

    public function setSize(w:Number, h:Number):Void
    {
        var old:Object = {w: this.__width, h: this.__height};
        super.setSize(w, h);

        if (old.w != this.__width || old.h != this.__height)
        {
            this.dispatchEvent({type: 'resized'});
        }
    }

    public function size():Void
    {
        if (null == this.__width) this.__width = 1;
        if (null == this.__height) this.__height = 1;

        this.__width = Math.max(this.__width, this.labelText._width + this.padding[1] + this.padding[3]);
        this.__height = Math.max(this.__height, this.labelText._height + this.padding[0] + this.padding[2]);

        this.labelText._x = this.padding[3];
        this.labelText._y = (this.__height - this.labelText._height) / 2;
        this.labelText._width = this.__width - (this.padding[1] + this.padding[3]);

        this.draw();
    }

    public function draw():Void
    {
        var mask:MovieClip = this.mask();
        mask.clear();
        // trace('TextButton.draw(): mask = ' + mask + ', w/h = ' + this.__width + '/' + this.__height);

        if (this.bgColor.alpha > 0)
            mask.beginFill(this.bgColor.toHex(false), this.bgColor.alpha);
        if (this.borderColor.alpha > 0)
            mask.lineStyle(0, this.borderColor.toHex(false), this.borderColor.alpha);
        Draw.rect(mask, 0, 0, this.__width, this.__height);
        mask.endFill();
        mask.lineStyle();
    }

    public function set label(str:String):Void
    {
        this.labelText.text = str;
        this.size();
    }

    public function get label():String
    {
        return this.labelText.text;
    }
}

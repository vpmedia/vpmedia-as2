/*
 * vim:et sts=4 sw=4 cindent:
 * $Id: Dialog.as 602 2007-01-18 23:35:42Z migurski $
 */

import mx.utils.Delegate;
import mx.transitions.*;
import mx.transitions.easing.*;

import com.digg.geo.Point;
import com.stamen.display.Draw;
import com.stamen.display.color.*;

import com.digg.fdk.view.controls.TextButton;
import com.digg.fdk.view.ViewObject;

class com.digg.fdk.view.Dialog extends ViewObject
{
    public var bgColor:RGBA;
    public var borderColor:RGBA;
    public var textColor:RGB;
    public var obscureColor:RGBA;

    public var padding:Array = [12, 12, 12, 12];
    public var spacing:Number = 10;

    private var __width:Number = 256;
    private var __height:Number = 256;

    public var autoSize:Boolean = true;
    public var autoPosition:Boolean = true;
    public var autoDismiss:Boolean = true;

    private var titleText:TextField;
    private var bodyText:TextField;
    private var buttons:Array;
    private var buttonStage:MovieClip;

    public var font:String = 'Helvetica';

    private var clickHandler:Function;
    private var buttonResizeHandler:Function;
    private var transition:Transition;
    private var transitionOptions:Object;

    public static var symbolName:String = '__Packages.com.digg.fdk.view.Dialog';
    public static var symbolOwner:Function = Dialog;
    public static var symbolLink:Boolean = Object.registerClass(symbolName, symbolOwner);

    public function init():Void
    {
        super.init();

        if (null == this.textColor) this.textColor = RGB.white();
        if (null == this.bgColor) this.bgColor = RGBA.black();
        if (null == this.obscureColor) this.obscureColor = RGBA.fromRGB(this.bgColor.rgb, 80);
        if (null == this.borderColor) this.borderColor = RGBA.fromRGB(this.textColor);

        this.buttons = new Array();
        this.createEmptyMovieClip('buttonStage', this.getNextHighestDepth());

        var tf:TextFormat = this.getTextFormat(16, true);
        this.createTextField('titleText', this.getNextHighestDepth(), 0, 0, 100, 50);
        with (this.titleText)
        {
            setNewTextFormat(tf);
            multiline = wordWrap = true;
            embedFonts = true;
        }

        this.createTextField('bodyText', this.getNextHighestDepth(), 0, 0, 100, 50);
        tf = this.getTextFormat(14, false);
        with (this.bodyText)
        {
            setNewTextFormat(tf);
            multiline = wordWrap = true;
            embedFonts = true;
            text = 'body text';
        }

        this.clickHandler = Delegate.create(this, this.onButtonPress);
        this.buttonResizeHandler = Delegate.create(this, this.onButtonResized);

        this.transitionOptions = {type:         Fade,
                                  duration:     0.5,
                                  easing:       Regular.easeOut};

        if (this.autoPosition)
        {
            Stage.addListener(this);
        }
    }

    public function getTextFormat(size:Number, bold:Boolean):TextFormat
    {
        var font:String = this.font;
        if (bold) font += ' Bold';
        trace('getTextFormat(): got font "' + font + '"');
        return new TextFormat(font, size, this.textColor.toHex());
    }

    public function attach():Void
    {
        // trace('Dialog.attach()');
        this.transitionOptions.direction = Transition.IN;
        this.transition = TransitionManager.start(this, this.transitionOptions);
        this.transition.addEventListener('transitionInDone', Delegate.create(this, this.onDoneAttaching));
    }

    public function detach(reason:String):Void
    {
        if (this.transition)
            this.transition.stop();

        this.transitionOptions.direction = Transition.OUT;
        this.transition = TransitionManager.start(this, this.transitionOptions);
        this.transition.addEventListener('transitionOutDone', Delegate.create(this, this.onDoneDetaching));
    }

    public function set title(str:String):Void
    {
        this.titleText.text = str;
        this.titleText._visible = str ? true : false;
        this.size();
    }

    public function get title():String
    {
        return this.titleText.text;
    }

    public function set body(str:String):Void
    {
        this.bodyText.text = str;
        this.size();
    }

    public function get body():String
    {
        return this.bodyText.text;
    }

    public function onButtonPress(event:Object):Void
    {
        event.button = event.target;
        event.target = this;
        event.type = 'dismissed';

        this.dispatchEvent(event);
        this.detach(event.type);
    }

    public function onButtonResized(event:Object):Void
    {
        this.size();
    }

    public function addButton(name:String, params:Object, symbolName:String):MovieClip
    {
        if (null == params) params = {};
        if (null == params.text) params.text = name;
        if (null == params.textColor) params.textColor = this.textColor;
        if (null == params.bgColor) params.bgColor = this.bgColor;
        if (null == params.borderColor) params.borderColor = this.borderColor;
        if (null == params.font) params.font = this.font;

        if (null == symbolName) symbolName = TextButton.symbolName;
        params.id = name;

        var clip:MovieClip = this.buttonStage.attachMovie(symbolName, 'button_' + name,
                                                          this.buttonStage.getNextHighestDepth(),
                                                          params);
        trace('added button: ' + clip + ' (label: "' + clip.label + '")');
        clip.addEventListener('click', this.clickHandler);
        clip.addEventListener('resized', this.buttonResizeHandler);

        this.buttons.push(clip);
        this.size();

        return clip;
    }

    public function removeButton(name:String):Boolean
    {
        var clip:MovieClip = this.buttonStage['button_' + name];
        if (clip)
        {
            for (var i:Number = 0; i < this.buttons.length; i++)
            {
                if (this.buttons[i] == clip)
                {
                    this.buttons.splice(i, 1);
                    break;
                }
            }
            clip.removeMovieClip();
            return true;
        }
        return false;
    }

    public function size():Void
    {
        if (this.titleText._visible)
        {
            this.titleText._x = this.padding[3];
            this.titleText._y = this.padding[0];
            this.titleText._width = this.__width - (this.padding[1] + this.padding[3]);
            this.titleText._height = this.titleText.textHeight * 1.2;

            this.bodyText._x = this.titleText._x;
            this.bodyText._y = this.titleText._y + this.titleText._height + this.spacing;
        }
        else
        {
            this.bodyText._x = this.padding[3];
            this.bodyText._y = this.padding[0];
        }

        this.bodyText._width = this.titleText._width;
        this.bodyText._height = this.bodyText.textHeight * 1.2;

        if (this.autoSize)
        {
            if (this.buttons.length > 0)
            {
                this.buttonStage._y = Math.max(this.bodyText._y + this.bodyText._height + this.spacing * 2,
                                               this.__height - (this.buttonStage._height + this.padding[2]));
                this.__height = this.buttonStage.getBounds(this).yMax + this.padding[2];
            }
            else
            {
                this.__height = this.bodyText._y + this.bodyText._height + this.padding[2];
            }

            // trace('autoSize: w/h = ' + this.__width + '/' + this.__height);
        }

        if (this.autoPosition)
        {
            var p:Point = new Point((Stage.width - this.__width) / 2,
                                    (Stage.height - this.__height) / 2,
                                    _root);
            p = p.asLocalPoint(this._parent, false);
            // trace('autoPosition: w/h = ' + this.__width + '/' + this.__height + ', x/y = ' + p.toString());
            this._x = p.x;
            this._y = p.y;
        }

        this.arrangeButtons();

        this.draw();
    }

    public function onResize():Void
    {
        this.size();
    }

    private function arrangeButtons():Void
    {
        if (this.buttons.length == 0) return;

        var availWidth:Number = this.__width - (this.padding[1] + this.padding[3]);
        var totalWidth:Number = this.spacing * (this.buttons.length - 1);

        for (var i:Number = 0; i < this.buttons.length; i++)
        {
            totalWidth += this.buttons[i]._width;
        }

        this.buttons[0]._x = (availWidth - totalWidth) / 2;
        for (var i:Number = 1; i < this.buttons.length; i++)
        {
            this.buttons[i]._x = this.buttons[i - 1].getBounds(this).xMax + this.spacing;
        }
    }

    public function draw():Void
    {
        var mask:MovieClip = this.mask();
        mask.clear();

        if (this.obscureColor.alpha > 0)
        {
            mask.onPress = function() {};
            mask.useHandCursor = false;

            var tl:Point = new Point(0, 0, _root);
            var br:Point = new Point(Stage.width, Stage.height, _root);
            tl = tl.asLocalPoint(this, false);
            br = br.asLocalPoint(this, false);
            var bounds:Object = {xMin: tl.x, xMax: br.x,
                                 yMin: tl.y, yMax: br.y};
            mask.beginFill(this.obscureColor.toHex(false), this.obscureColor.alpha);
            Draw.bounds(mask, bounds);
            mask.endFill();
        }
        else
        {
            delete mask.onPress;
        }

        if (this.bgColor.alpha > 0)
            mask.beginFill(this.bgColor.toHex(false), this.bgColor.alpha);
        if (this.borderColor.alpha > 0)
            mask.lineStyle(0, this.borderColor.toHex(false), this.borderColor.alpha);
        Draw.rect(mask, 0, 0, this.__width, this.__height);
        mask.endFill();
        mask.lineStyle();
    }
}

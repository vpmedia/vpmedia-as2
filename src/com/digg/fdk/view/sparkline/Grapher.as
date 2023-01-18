/*
 * vim:et sts=4 sw=4 cindent:
 * $Id: Grapher.as 602 2007-01-18 23:35:42Z migurski $
 */

import com.stamen.display.color.*;
import com.stamen.display.Draw;
import com.stamen.utils.XMLExt;
import com.stamen.utils.DateExt;
import com.digg.geo.Point;
import com.digg.fdk.view.sparkline.*;

import mx.core.UIObject;
import mx.utils.Delegate;
import mx.events.EventDispatcher;
import mx.transitions.TransitionManager;

class com.digg.fdk.view.sparkline.Grapher extends UIObject
{
    public var min:Number;
    public var max:Number;
    public var adjustMinMax:Boolean = true;
    public var baseline:Number;
    public var flip:Boolean = false;
    private var adjustedMin:Number;
    private var adjustedMax:Number;
    private var step:Number = 0;

    public var values:Array;
    public var valueClips:Array;
    public var oldValues:Array;
    public var showTooltips:Boolean = true;

    public var valueKey:String = 'diggs';
    public var labelKey:String = 'start';

    public var titleColor:RGB;
    public var loadingTextColor:RGB;
    public var borderColor:RGBA;
    public var markColor:RGBA;
    public var zeroColor:RGBA;
    public var labelColor:RGB;
    public var labelTextFormat:TextFormat;
    public var labelEmbedFonts:Boolean = true;
    public var labelStage:MovieClip;
    public var labelMask:MovieClip;
    public var valueColor:RGBA;
    public var valueLabelColor:RGB;

    public var graphInterval:Number;

    public var title:TextField;
    public var titleText:String = 'Title';
    public var loadText:TextField;
    public var padding:Number = 4;
    public var margin:Number = 10;
    public var spacing:Number = 1;
    public var graphRate:Number = 1;

    public var request:XMLExt;
    public var requestHandler:Function;
    public var loading:Boolean = false;

    public static var symbolName:String = '__Packages.com.digg.fdk.view.sparkline.Grapher';
    public static var symbolOwner:Function = Grapher;
    public static var symbolLink:Boolean = Object.registerClass(symbolName, symbolOwner);
    private static var dispatched = EventDispatcher.initialize(Grapher.prototype);

    public function init():Void
    {
        if (null == titleColor) titleColor = RGB.black();
        if (null == loadingTextColor) loadingTextColor = RGB.grey(102);
        if (null == borderColor) borderColor = RGBA.black(50);
        if (null == valueColor) valueColor = RGBA.fromRGB(titleColor, 100);
        if (null == markColor) markColor = borderColor;
        if (null == zeroColor) zeroColor = borderColor;
        if (null == labelColor) labelColor = RGB.grey(102);
        if (null == valueLabelColor) valueLabelColor = labelColor;

        if (null == labelTextFormat)
            labelTextFormat = new TextFormat('Helvetica', 12, labelColor.toHex());

        valueClips = new Array();

        requestHandler = Delegate.create(this, handleRequest);
        createTextField('title', getNextHighestDepth(), 0, 0, 0, 0);
        var tf:TextFormat = new TextFormat('Helvetica Bold', 16, titleColor.toHex(false), true);
        with (title)
        {
            setNewTextFormat(tf);
            autoSize = 'left';
            embedFonts = true;
            text = _parent.titleText;
            selectable = false;
        }

        createTextField('loadText', getNextHighestDepth(), 0, 0, 0, 0);
        tf.color = loadingTextColor.toHex();
        with (loadText)
        {
            setNewTextFormat(tf);
            autoSize = 'left';
            embedFonts = true;
            selectable = false;
            _visible = false;
        }

        createEmptyMovieClip('labelMask', getNextHighestDepth());
        labelMask._visible = false;
    }

    public function size():Void
    {
        title._x = -1;
        title._y = 0 - (title._height + padding);
        draw();
    }

    public function draw():Void
    {
        clear();
        lineStyle(0, borderColor.toHex(false), borderColor.alpha);
        Draw.rect(this, 0, 0, __width, __height);

        if (zeroColor && baseline < __height && baseline > 0)
        {
            lineStyle(0, zeroColor.toHex(false), zeroColor.alpha);
            moveTo(0, baseline);
            lineTo(__width, baseline);
        }

        labelMask.beginFill(0xFF00FF);
        Draw.rect(labelMask, 0, -margin, __width + 200, __height + margin * 2);
    }

    public function load(url:String):Void
    {
        trace(_name + '.load("' + url + '")');
        clearValue();
        clearRequest();

        onEnterFrame = loadEnterFrame;
        loadText._visible = true;
        loadText.text = 'Loading...';
        loadText._x = loadText._y = padding;

        request = new XMLExt();
        request.onLoad = requestHandler;
        request.load(url);
        loading = true;
    }

    public function hide():Void
    {
        TransitionManager.start(this, {type: mx.transitions.Fade, duration: 0.5,
                                       direction: mx.transitions.Transition.OUT});
    }

    public function setTitle(str:String, color:RGB):Void
    {
        title.text = str;
        if (null != color)
        {
            var tf:TextFormat = title.getTextFormat();
            tf.color = color.toHex();
            title.setTextFormat(tf);
        }
        size();
    }

    public function loadEnterFrame():Void
    {
        var loading:String = 'Loading... ';
        var progress:Number = request.getBytesLoaded() / request.getBytesTotal() * 100;
        if (isFinite(progress))
        {
            loading += Math.round() + '%';
        }
        loadText.text = loading;
    }

    public function handleData(event:Object):Void
    {
        // trace(_name + '.handleData()!');
        loadText._visible = false;

        clearValue();

        setTitle((event.title ? event.title : titleText));
        // trace('CONVERTING NODES TO VALUES...', 2);
        if (event.nodes.length > 0)
        {
            var values:Array = convertNodesToValues(event.nodes);
            graph(values);
        }
        else
        {
            trace('HIDING, NO NODES!', 3);
            hide();
        }

        clearRequest();
    }

    public function clearRequest():Void
    {
        loading = false;
        request.cancel();
        delete request;
        delete onEnterFrame;
    }

    public function convertNodesToValues(nodes:Array):Array
    {
        var values:Array = new Array();
        var len:Number = nodes.length;
        for (var i:Number = 0; i < len; i++)
        {
            values.push(convertNodeToValue(nodes[i], i));
        }
        return values;
    }

    public function convertNodeToValue(node:XMLNode, index:Number):Object
    {
        // trace('convertNodeToValue(): ' + node.toString());

        var _value:Number = parseFloat(node.attributes[valueKey]);
        if (!isFinite(_value)) _value = 0;

        var value:Object = {index: index,
                            value: _value};
        // trace('got value: ' + _value + ' at index ' + index);
        return value;
    }

    public function getValueLabel(value:Object):String
    {
        return value.value;
    }

    public function graph(values:Array):Void
    {
        trace('Grapher.graph(): graphing ' + values.length + ' values');
        // copy?
        this.values = new Array();
        var len:Number = values.length;
        for (var i:Number = 0; i < len; i++)
        {
            this.values[i] = values[i];
        }

        trace('adjusting min/max...');
        adjustedMin = Math.max(min, -Infinity);
        adjustedMax = Math.min(max, Infinity);
        for (var i:Number = 0; i < len; i++)
        {
            var value:Object = this.values[i];
            if (!isFinite(value.value)) continue;
            adjustedMin = Math.min(value.value, adjustedMin);
            adjustedMax = Math.max(value.value, adjustedMax);
        }

        if (!adjustMinMax)
        {
            adjustedMin = Math.min(min, adjustedMin);
            adjustedMax = Math.max(max, adjustedMax);
        }

        // trace('Grapher.graph(): got ' + this.values.length + ' values, min/max = ' + min + '/' + max);
        step = __width / this.values.length;
        // trace('width = ' + __width + ', step = ' + step);

        if (null == baseline) baseline = getYForValue(0, false);

        graphInterval = setInterval(this, '_graph', graphRate);
        return;
    }

    public function drawLabels():Void
    {
        var minLabel:TextField = drawValueLabel(adjustedMin, 'min');
        if (min < 0 && max > 0)
        {
            drawValueLabel(0, 'zero');
        }
        var maxLabel:TextField = drawValueLabel(adjustedMax, 'max');
    }

    public function drawValueLabel(value:Number, name:String):TextField
    {
        var p:Point = new Point(__width + padding, getYForValue(value));
        var label:TextField = drawLabel(String(Math.round(value)), p, 'label_' + name, false);
        var tf:TextFormat = label.getTextFormat();
        tf.color = valueLabelColor.toHex(false);
        label.setTextFormat(tf);
        label._y -= label._height / 2;
        return label;
    }

    public function clearLabels():Void
    {
        labelStage.removeMovieClip();
        labelMask._visible = false;
        var otherLabels:Array = ['min', 'zero', 'max'];
        for (var i:Number = 0; i < otherLabels.length; i++)
            this['label_' + otherLabels[i]].removeTextField();
    }

    private function _graph():GraphValue
    {
        if (values.length == 0)
        {
            trace('_graph(): done graphing!');
            clearInterval(graphInterval);
            draw();
            drawLabels();
            dispatchEvent({type: 'graphed'});
            return null;
        }

        updateAfterEvent();

        var value:Object = values[0];
        values.shift();
        return graphValue(value);
    }

    public function graphValue(value:Object):GraphValue
    {
        if (!value.value)
        {
            // trace('graphValue() got no value!');
            return null;
        }

        // trace('graphValue(): valueKey = "' + valueKey + '", index = ' + value.index + ', value = ' + value.value);

        var clip:GraphValue = attachValueClip(value);
        clip.label = getValueLabel(value);

        clip.width = step - spacing;
        clip._x = 1 + value.index * step;
        clip._y = baseline;
        if (value.value < 0) clip._y += 1;
        clip.maxY = getYForValue(value.value);
        clip.draw();
        return clip;
    }

    public function attachValueClip(value:Object):GraphValue
    {
        value.maxY = getYForValue(value.value);
        value.fillColor = valueColor;

        var clip:GraphValue = GraphValue(attachMovie(GraphValue.symbolName,
                                                     'data_' + valueKey + value.index,
                                                     getNextHighestDepth(),
                                                     value));
        valueClips.push(clip);
        return clip;
    }

    public function drawLabel(labelText:String, pos:Point, name:String, centered:Boolean, where:MovieClip):TextField
    {
        if (!labelStage)
        {
            createEmptyMovieClip('labelStage', getNextHighestDepth());
            // labelMask._visible = true;
            // labelStage.setMask(labelMask);
        }

        if (null == where) where = labelStage;

        where.createTextField(name, where.getNextHighestDepth(), 0, 0, 0, 0);
        var field:TextField = where[name];

        with (field)
        {
            autoSize = 'left';
            selectable = false;
            setNewTextFormat(labelTextFormat);
            embedFonts = labelEmbedFonts;
            text = labelText;
            _x = pos.x;
            _y = pos.y;

            if (centered || null == centered)
            {
                _x -= Math.round(_width / 2);
                _y -= Math.round(_height / 2);
            }
        }

        return field;
    }

    public function getYForValue(value:Number, useBaseline:Boolean):Number
    {
        // trace('getYForValue(' + value + '): valueKey = "' + valueKey + '", flip = ' + flip);
        if (null == useBaseline) useBaseline = true;
        var maxHeight:Number;

        if (flip && useBaseline)
        {
            maxHeight = __height - baseline;
        }
        else
        {
            maxHeight = useBaseline ? baseline : __height;
        }

        var h:Number = (value - adjustedMin) / (adjustedMax - adjustedMin) * maxHeight;
        var y:Number = (flip && useBaseline)
                       ? Math.round(baseline + h)
                       : Math.round(maxHeight - h);
        return y;
    }

    public function clearValue():Void
    {
        while (valueClips.length > 0)
        {
            var clip:GraphValue = GraphValue(valueClips.pop());
            clip.removeMovieClip();
            delete clip;
        }

        clearLabels();

        clearInterval(graphInterval);
        size();
    }

    public function handleRequest(success:Boolean):Boolean
    {
        // trace('handleRequest(): success = ' + success, 1);

        if (!request.loaded)
        {
            return false;
        }

        if (success)
        {
            var root:XMLNode = request.firstChild;

            var startDate:DateExt = DateExt.fromTimestamp(parseInt(root.attributes['start']));
            var endDate:DateExt = DateExt.fromTimestamp(parseInt(root.attributes['end']));

            var event:Object = {type:  'data',
                                title: root.attributes.title,
                                start: startDate,
                                end:   endDate,
                                nodes: root.childNodes};

            handleData(event);
            return true;
        }
        else
        {
            loadText.text = 'ERROR: Unable to load "' + request.url + '"';
            clearRequest();
            return false;
        }
    }
}

/*
 * vim:et sts=4 sw=4 cindent tw=120:
 * $Id: FPSCounter.as 186 2006-06-21 03:51:12Z allens $
 */

class com.stamen.display.FPSCounter extends MovieClip
{
    public var samples:Number = 20;

    private var label:TextField;
    private var t:Number;
    private var counts:Array;

    public static var symbolName:String = '__Packages.com.stamen.display.FPSCounter';
    public static var symbolOwner:Function = FPSCounter;
    private static var symbolLinked = Object.registerClass(symbolName, symbolOwner);

	public function FPSCounter()
    {
        this.createTextField('label', this.getNextHighestDepth(), 2, 2, 0, 0);
        with (this.label)
        {
            autoSize = 'left';
            setNewTextFormat(new TextFormat('Verdana', 9, 0xFFFF00));
        }
        this.counts = new Array();
        this.start();
    }

    public function measure():Void
    {
        while (this.counts.length > this.samples)
            this.counts.shift();

        var d = new Date();
        var t = d.getTime();
        var elapsed = t - this.t;
        this.t = t;

        var count = (1000 / elapsed) >> 0;

        this.counts.push(count);
        var avg = 0;
        for (var i = 0; i < this.counts.length; i++)
            avg += this.counts[i];
        avg /= this.counts.length;

        this.label.text = String(avg >> 0);
    }

    public function start():Void
    {
        this.onEnterFrame = this.measure;
    }

    public function stop():Void
    {
        delete this.onEnterFrame;
    }

    public function show():Void
    {
        this._visible = true;
        this.swapDepths(this._parent.getNextHighestDepth());
        this.start();
    }

    public function hide():Void
    {
        this._visible = false;
        this.stop();
    }
}


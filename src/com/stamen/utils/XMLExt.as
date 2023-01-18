/*
 * vim:et sts=4 sw=4 cindent:
 * $Id: XMLExt.as 651 2007-02-10 01:23:43Z allens $
 */

import mx.events.EventDispatcher;

class com.stamen.utils.XMLExt extends XML
{
    public static var EVENT_LOADED:String = 'loaded';

    public var url:String;
    public var statusCode:Number;
    public var loading:Boolean = false;
    public var ignoreWhite:Boolean = true;

    public var dispatchEvent:Function;
    public var addEventListener:Function;
    public var removeEventListener:Function;

    private static var eventLink = EventDispatcher.initialize(XMLExt.prototype);

    public function load(url:String):Void
    {
        // trace('ControllerRequest.load(): url = ' + url);
        this.ignoreWhite = true;
        this.url = url;
        this.loaded = false;
        super.load(url);
        this.loading = true;
    }

    public function cancel():Void
    {
        if (this.loading)
        {
            trace('XMLExt.cancel(): cancelling "' + this.url + '"');
            this.onData = function():Void {};
            this.onLoad = function():Void {};
        }
    }

    public function onLoad(success:Boolean):Void
    {
        // trace('XMLExt.onLoad(' + success + ')', 2);

        this.loaded = true;
        this.loading = false;
        this.dispatchEvent({type: EVENT_LOADED, success: success});
    }

    public function onHTTPStatus(statusCode:Number):Void
    {
        this.statusCode = statusCode;
    }

    /**
     * Emulate MovieClipLoader.getProgress(), so that we have a common interface
     * for obtaining loading object's progress.
     *
     * @return  Object  an object with 'bytesTotal' and 'bytesLoaded' properties.
     */
    public function getProgress():Object
    {
        return {bytesTotal: this.getBytesTotal(),
                bytesLoaded: this.getBytesLoaded()};
    }
}

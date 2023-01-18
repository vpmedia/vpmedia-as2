/*
 * vim:et sts=4 sw=4 cindent:
 * $Id$
 */

interface com.digg.fdk.interfaces.IViewObject
{
    public function attach():Void;
    public function detach(reason:String):Void;
    public function expire():Void;

    public function place():Void;
    public function draw():Void;

    public function setSize(width:Number, height:Number):Void;
    public function getMask():MovieClip;

    public function addEventListener(event:String, listener):Void;
    public function removeEventListener(event:String, listener):Void;
    public function dispatchEvent(event:Object):Void;
}

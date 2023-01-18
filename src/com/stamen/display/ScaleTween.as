/*
 * vim:et sts=4 sw=4 cindent:
 * $Id: ScaleTween.as 85 2006-05-11 03:05:58Z allens $
 */

import mx.transitions.*;

class com.stamen.display.ScaleTween extends Tween
{
    public function ScaleTween(obj:Object, easing:Function, begin:Number,
                               finish:Number, duration:Number, useSeconds:Boolean)
    {
        super(obj, '_xscale', easing, begin, finish, duration, useSeconds);
    }

    public function setPosition(p:Number):Void
    {
        this.prevPos = this._pos;
        this.obj._xscale = this.obj._yscale = this._pos = p;
        this.broadcastMessage('onMotionChanged', this, this._pos);
        updateAfterEvent();
    }
}

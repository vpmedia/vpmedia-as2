/*
 * vim:et sts=4 sw=4 cindent:
 * $Id: ControlObject.as 602 2007-01-18 23:35:42Z migurski $
 */

import mx.core.UIObject;
import mx.events.EventDispatcher;

class com.digg.fdk.view.controls.ControlObject extends UIObject
{
    private static var eventLink = EventDispatcher.initialize(ControlObject.prototype);
}

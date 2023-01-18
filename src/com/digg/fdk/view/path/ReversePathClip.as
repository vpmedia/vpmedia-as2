/*
 * vim:et sts=4 sw=4 cindent:
 * $Id: ReversePathClip.as 605 2007-01-18 23:51:57Z allens $
 */

import com.digg.geo.*;
import com.digg.fdk.view.path.PathClip;

class com.digg.fdk.view.path.ReversePathClip extends PathClip
{
    public function place(initial:Boolean):Void
    {
        super.place(initial);
        this._rotation -= 180;
    }
}

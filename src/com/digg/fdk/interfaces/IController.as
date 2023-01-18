/*
 * vim:et sts=4 sw=4 cindent:
 * $Id$
 */

import com.digg.fdk.interfaces.*;
import com.digg.fdk.model.*;
import com.digg.services.IResponse;

interface com.digg.fdk.interfaces.IController
{
    public function init():Void;
    public function stop():Void;
    public function start():Void;
    public function reset(immediately:Boolean):Void;
    public function error(message:String, fatal:Boolean):Void;

    public function loadStory(story:Story):IResponse;
    public function loadStories(storyIDs:Array):IResponse;
    public function updateStory(story:Story):IResponse;
}

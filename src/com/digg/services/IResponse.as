/*
 * vim:et sts=4 sw=4 cindent:
 * $Id$
 */

import com.digg.services.*;
import com.digg.fdk.model.Model;

interface com.digg.services.IResponse
{
    public function load(url:String):Void;

    public function addLoadListener(listener:Function):Void;
    public function isLoaded():Boolean;

    public function getURL():String;
    public function getError():ResponseError;
    public function getBody():XML;
    public function getMeta():Object;

    public function getItem():Object;
    public function getItems():Array;

    public function useModel(model:Model):Void;
}

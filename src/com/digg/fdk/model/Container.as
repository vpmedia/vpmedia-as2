/*
 * vim:et sts=4 sw=4 cindent:
 * $Id: Container.as 695 2007-02-26 19:41:42Z allens $
 */

import com.digg.fdk.model.*;

class com.digg.fdk.model.Container extends Topic
{
    public function Container(properties:Object)
    {
        super(properties);
    }

    public static function fromXML(node:XMLNode, model:Model):Container
    {
        return new Container(node.attributes);
    }

    public function get url():String
    {
        return 'http://digg.com/view/' + shortName;
    }
}

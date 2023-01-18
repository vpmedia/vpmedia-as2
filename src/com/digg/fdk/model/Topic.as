/*
 * vim:et sts=4 sw=4 cindent:
 * $Id: Topic.as 695 2007-02-26 19:41:42Z allens $
 */

import com.digg.fdk.model.*;
import org.json.JSON;

class com.digg.fdk.model.Topic extends ModelObject
{
	public var name:String;
    public var shortName:String;
    public var container:Container;

    public static function fromXML(node:XMLNode, model:Model):Topic
    {
        var topic:Topic = new Topic(node.attributes);
        if (node.hasChildNodes())
        {
            topic.container = Container.fromXML(node.firstChild, model);
        }

        if (model)
        {
            return model.topics.getOrSet(topic.safeKey(), topic);
        }
        else
        {
            return topic;
        }
    }

    public function Topic(properties:Object)
    {
        super(properties);

        if (null != this['short_name'])
        {
            shortName = this['short_name'];
            delete this['short_name'];
        }
    }

    public function toString():String
    {
        return name;
    }

    public function get url():String
    {
        return 'http://digg.com/' + shortName;
    }

    public function compare(topic:Topic):Boolean
    {
        return name == topic.name;
    }
}

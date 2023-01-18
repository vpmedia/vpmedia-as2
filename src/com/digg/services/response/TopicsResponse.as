/*
 * vim:et sts=4 sw=4 cindent:
 * $Id$
 */

import com.digg.services.*;
import com.digg.fdk.model.Topic;
import com.digg.fdk.model.Model;

class com.digg.services.response.TopicsResponse extends Response
{
    public function getItem():Topic
    {
        return Topic(items.shift());
    }

    private function loadItems():Boolean
    {
        items = new Array();

        var root:XMLNode = getBody().firstChild;
        for (var child:XMLNode = root.firstChild; child; child = child.nextSibling)
        {
            items.push(Topic.fromXML(child, model));
        }

        return true;
    }
}



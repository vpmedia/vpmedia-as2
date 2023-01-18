/*
 * vim:et sts=4 sw=4 cindent:
 * $Id$
 */

import com.digg.services.*;
import com.digg.fdk.model.Story;
import com.digg.fdk.model.Model;

class com.digg.services.response.StoriesResponse extends Response
{
    public function getItem():Story
    {
        return Story(items.shift());
    }

    private function loadItems(model:Model):Boolean
    {
        items = new Array();

        var root:XMLNode = getBody().firstChild;
        for (var child:XMLNode = root.firstChild; child; child = child.nextSibling)
        {
            items.push(Story.fromXML(child, model));
        }

        return true;
    }
}

/*
 * vim:et sts=4 sw=4 cindent:
 * $Id$
 */

import com.digg.services.*;
import com.digg.fdk.model.Story;
import com.digg.fdk.model.Model;

class com.digg.services.response.StoryResponse extends Response
{
    public function getItem():Story
    {
        return Story(items[0]);
    }

    private function loadItems(model:Model):Boolean
    {
        items = new Array();

        var root:XMLNode = getBody().firstChild;
        // there should only be one <story/> element
        items.push(Story.fromXML(root.firstChild, model));

        return true;
    }
}

/*
 * vim:et sts=4 sw=4 cindent:
 * $Id$
 */

import com.digg.services.*;
import com.digg.fdk.model.Comment;
import com.digg.fdk.model.Model;

class com.digg.services.response.CommentsResponse extends com.digg.services.Response
{
    public function getItem():Comment
    {
        return Comment(items.shift());
    }

    private function loadItems(model:Model):Boolean
    {
        items = new Array();

        var root:XMLNode = getBody().firstChild;
        for (var child:XMLNode = root.firstChild; child; child = child.nextSibling)
        {
            items.push(Comment.fromXML(child, model));
        }

        return true;
    }
}



/*
 * vim:et sts=4 sw=4 cindent:
 * $Id$
 */

import com.digg.services.*;
import com.digg.fdk.model.User;
import com.digg.fdk.model.Model;

class com.digg.services.response.UsersResponse extends com.digg.services.Response
{
    public function getItem():User
    {
        return User(items.shift());
    }

    private function loadItems(model:Model):Boolean
    {
        items = new Array();

        var root:XMLNode = getBody().firstChild;
        for (var child:XMLNode = root.firstChild; child; child = child.nextSibling)
        {
            items.push(User.fromXML(child, model));
        }

        return true;
    }
}



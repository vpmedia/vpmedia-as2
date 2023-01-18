/*
 * vim:et sts=4 sw=4 cindent:
 * $Id$
 */

import com.digg.services.*;
import com.digg.fdk.model.User;
import com.digg.fdk.model.Model;

class com.digg.services.response.UserResponse extends Response
{
    public function getItem():User
    {
        return User(items[0]);
    }

    private function loadItems(model:Model):Boolean
    {
        items = new Array();

        var root:XMLNode = getBody().firstChild;
        // there should only be one <user/> element
        items.push(User.fromXML(root.firstChild, model));

        return true;
    }
}


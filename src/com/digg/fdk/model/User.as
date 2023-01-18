/*
 * vim:et sts=4 sw=4 cindent:
 * $Id: User.as 598 2007-01-13 01:20:42Z allens $
 */

import com.digg.fdk.model.*;
import com.stamen.utils.DateExt;

class com.digg.fdk.model.User extends ModelObject
{
    public var name:String;
    public var icon:String;
    public var registered:DateExt;
    public var profileViews:Number = 0;

    public function User(properties:Object)
    {
        super(properties);
    }

    public static function fromXML(node:XMLNode, model:Model):User
    {
        var user:User = new User(node.attributes);
        user.registered = DateExt.fromTimestamp(node.attributes['registered']);
        user.profileViews = parseInt(node.attributes['profileviews']);
        return user;
    }

    public function copy():User
    {
        return new User(this);
    }

    public function safeKey():String
    {
        return super.safeKey(this.name, 'user_');
    }

    public function get url():String
    {
        return 'http://digg.com/users/' + this.name;
    }

    public function compare(user:User):Boolean
    {
        return this.name == user.name;
    }
}

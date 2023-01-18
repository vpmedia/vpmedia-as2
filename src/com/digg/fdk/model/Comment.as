/*
 * vim:et sts=4 sw=4 cindent:
 * $Id$
 */

import com.digg.fdk.model.*;
import com.stamen.utils.DateExt;

class com.digg.fdk.model.Comment extends ModelObject
{
    public var user:User;
    public var text:String;
    public var date:DateExt;
    public var story:Story;

    public var id:Number = -1;
    public var upDiggs:Number = 0;
    public var downDiggs:Number = 0;
    public var numReplies:Number = 0;

    public function Comment(properties:Object)
    {
        super(properties);
    }

    public static function fromXML(node:XMLNode, model:Model):Comment
    {
        var comment:Comment = new Comment();
        comment.id = parseInt(node.attributes['id']);

        var user:User = new User({name: node.attributes['user']});
        comment.user = model
                       ? model.users.getOrSet(user.safeKey(), user)
                       : user;
        var story:Story = new Story({id: node.attributes['story']});
        comment.story = model
                        ? model.stories.getOrSet(story.safeKey(), story)
                        : story;
        comment.text = node.firstChild.nodeValue;
        comment.date = DateExt.fromTimestamp(node.attributes['date']);

        comment.upDiggs = parseInt(node.attributes['up']);
        comment.downDiggs = parseInt(node.attributes['down']);
        comment.numReplies = parseInt(node.attributes['replies']);
        return comment;
    }
}

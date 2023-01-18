/*
 * vim:et sts=4 sw=4 cindent:
 * $Id: Digg.as 693 2007-02-26 19:34:20Z allens $
 */

import com.stamen.utils.DateExt;
import org.json.JSON;
import com.digg.fdk.model.*;

class com.digg.fdk.model.Digg extends ModelObject
{
    public var id:Number;
    public var time:DateExt;
    public var user:User;
    public var story:Story;
    public var status:String;

    public var requeueCount:Number = 0;

    public function Digg(properties:Object)
    {
        super(properties);
    }
    
    /**
     * Create a Digg object from an XML node. Currently, the <digg /> elements
     * that come through in the API have only 4 attributes:
     *
     * 'story': the *id* of the story that was dugg
     * 'user': the username of the user that dugg the story
     * 'time': a MySQL DATETIME-formatted timestamp
     * 'status': 'upcoming' or 'popular'
     *
     * The {@link Story} object created here shouldn't be placed in the model,
     * since it isn't an accurate representation of the story (because it has
     * only an 'id' property). However, the string from its {@link * Story.safeKey()}
     * can be used as a key to find the actual representation in the model's
     * stories hash.
     *
     * The {@link User} object, on the other hand, is as representative as we
     * need it to be: it has only a username. At some point we may want to store
     * more information about the user in the model, but we can use {@link
     * ModelObject.update()} for that.
     *
     * @param   XMLNode     node
     * @param   Model       model
     * @return  Digg
     */
    public static function fromXML(node:XMLNode, model:Model):Digg
    {
        var user:User = new User({name: node.attributes['user']})
        var story:Story = new Story({id: node.attributes['story']});
        var time:DateExt = DateExt.fromTimestamp(parseInt(node.attributes['date']));
        var status:String = node.attributes['status'];
        var id:Number = parseInt(node.attributes['id']);

        if (model.stories.hasKey(story.safeKey()))
            story = model.stories.getValue(story.safeKey())

        return new Digg({id:     id,
                        user:   model.users.getOrSet(user.safeKey(), user),
                        story:  story,
                        time:   time,
                        status: status});
    }

    /**
     * This performs a shallow copy; that is, references to the original user
     * and story members should remain intact in the new Digg object.
     *
     * @return  Digg
     */
    public function copy():Digg
    {
        return new Digg(this);
    }

    /**
     * Keys should be unique for each user/story pair.
     *
     * @return  String
     */
    public function safeKey():String
    {
        return user.safeKey() + '_' + story.safeKey();
    }

    public function toString():String
    {
        return JSON.stringify({user: user.toString(),
                               story: story.toString(),
                               time: time.toString()});
    }

    public function compare(digg:Digg):Boolean
    {
        return digg.id == id;
    }
}


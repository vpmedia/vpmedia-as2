/*
 * vim:et sts=4 sw=4 cindent:
 * $Id: Model.as 693 2007-02-26 19:34:20Z allens $
 */

import com.stamen.data.Hash;
import com.digg.fdk.model.*;

class com.digg.fdk.model.Model
{
    public var users:Hash;
    public var stories:Hash;
    public var topics:Hash;
    public var containers:Hash;
    public var diggs:Array;

    public function Model()
    {
        users = new Hash();
        stories = new Hash();
        diggs = new Array();
        topics = new Hash();
        containers = new Hash();
    }

	/**
	 * Add a digg to the diggs array, as long as it's not in there already.
	 * @return	true if the digg was added successfully, false if the digg was
     *          already added.
     * @see     hasDigg()
     */
    public function addDigg(digg:Digg, force:Boolean):Boolean
    {
        if (!force && hasDigg(digg))
        {
            return false;
        }

        diggs.push(digg);
        return true;
    }

    public function hasStory(story:Story):Boolean
    {
        return stories.hasKey(story.safeKey());
    }

    /**
     * Determine whether or not a digg has already been added.
     * @return  true if the digg has already been added, false otherwise.
     */
    public function hasDigg(digg:Digg):Boolean
    {
        // go backward through the list, since the recently added diggs are most
        // likely to be dupes
        for (var i:Number = diggs.length - 1; i >= 0; i--)
        {
            if (digg.compare(diggs[i]))
            {
                return true;
            }
        }

        return false;
    }

    /**
     * Add a story to the model, optionally updating an existing one.
     *
     * @param   story   the story to add. If update is true, the {@link
     *                  Story.safeKey()} method should return an existing key in
     *                  the stories hash if 
     * @param   update  whether or not to update the story if one with the same
     *                  key exists already.
     * @return          true if the story was added or updated successfully,
     *                  otherwise false
     */
    public function addStory(story:Story, update:Boolean):Boolean
    {
        var storyKey:String = story.safeKey();
        if (!story || !storyKey)
        {
            trace('addStory(): got bogus story and/or hash key');
            return false;
        }

        if (stories.hasKey(storyKey))
        {
            return update
                   ? stories[storyKey].update(story)
                   : false;
        }
        else
        {
            stories.setValue(storyKey, story);
            return true;
        }
    }

    public function addUser(user:User, update:Boolean):Boolean
    {
        var userKey:String = user.safeKey();
        if (users.hasKey(userKey))
        {
            return update
                   ? users[userKey].update(user)
                   : false;
        }
        else
        {
            users.setValue(userKey, user);
            return true;
        }
    }

    /**
     * Remove a user (and its diggs) from the model.
     */
    public function removeUser(user:User):Void
    {
        removeUserDiggs(user);
        users.deleteKey(user.safeKey());
    }

    /**
     * Remove a story (and its diggs) from the model.
     */
    public function removeStory(story:Story):Void
    {
        removeStoryDiggs(story);
        stories.deleteKey(story.safeKey());
    }

    /**
     * Remove diggs associated with the given Story instance.
     */
    public function removeStoryDiggs(story:Story):Number
    {
        var count:Number = 0;
        var len:Number = diggs.length;
        for (var i:Number = 0; i < len; i++)
        {
            if (diggs[i].story.compare(story))
            {
                diggs.splice(i, 1);
                i--;
                count++;
            }
        }
        return count;
    }

    /**
     * Get the last digg from a user.
     */
    public function getLastUserDigg(user:User):Digg
    {
        for (var i:Number = diggs.length - 1; i >= 0; i--)
        {
            if (diggs[i].user.compare(user))
            {
                return diggs[i];
            }
        }

        return null;
    }
    
    /**
     * Clear all diggs for the given user from the diggs array.
     * @return	the number of diggs removed
     */
    public function removeUserDiggs(user:User):Number
    {
        var count:Number = 0;
        var len:Number = diggs.length;
        for (var i:Number = 0; i < len; i++)
        {
            if (diggs[i].user.compare(user))
            {
                diggs.splice(i, 1);
                i--;
                count++;
            }
        }
        return count;
    }
}

/*
 * vim:et sts=4 sw=4 cindent:
 * $Id: Story.as 693 2007-02-26 19:34:20Z allens $
 */

import com.stamen.utils.DateExt;
import com.stamen.data.URLBuilder;
import com.digg.fdk.model.*;
import com.digg.services.API;

class com.digg.fdk.model.Story extends ModelObject
{
    public var id:Number = -1;
    public var title:String;
    public var href:String;
    public var link:String;
    public var diggs:Number = 0;
    public var comments:Number = 0;
    public var description:String;
    public var submitter:User;
    public var status:String;
    public var submitDate:DateExt;
    public var promoteDate:DateExt;
    public var topic:Topic;
    public var container:Container;

    public var inView:Boolean = false;
    public var inQueue:Boolean = false;

    public function Story(properties:Object)
    {
        super(properties);

        if (null != properties['submit_date'])
        {
            makeDate(properties['submit_date'], 'submitDate');
            makeDate(properties['promote_date'], 'promoteDate');
            delete properties['submit_date'];
            delete properties['promote_date'];
        }

        cleanup();

        name = title;
    }

    public static function fromXML(node:XMLNode, model:Model):Story
    {
        // for backwards compatibility with old API
        if (node.attributes['digs'])
        {
            node.attributes['diggs'] = node.attributes['digs'];
        }

        var story:Story = new Story(node.attributes);
        
        // trace("Story.fromXML(): parsing " + node.toString());
        for (var child:XMLNode = node.firstChild; child; child = child.nextSibling)
        {
            switch (child.nodeName)
            {
                case 'title':
                case 'description':
                    story[child.nodeName] = child.firstChild.nodeValue;
                    break;
                    
                case 'user':
                    var user:User = User.fromXML(child);
                    story.submitter = model.users.getOrSet(user.safeKey(), user);
                    break;

                case 'topic':
                    story.topic = Topic.fromXML(child, model);
                    break;

                case 'container':
                    story.container = Container.fromXML(child, model);
                    break;
            }
        }

        story.topic.container = story.container;
        
        // trace("Story.fromXML(): produced " + story.toString());
        return story;
    }

    public function copy():Story
    {
        return new Story(this);
    }

    private function cleanup():Void
    {
        if (typeof diggs == 'string')
            diggs = parseInt(this['diggs']);
        if (typeof comments == 'string')
            comments = parseInt(this['comments']);

        if (description.length > 0)
        {
            var str:String = description;
            var chars:Array = ["\n", "\r"];

            for (var i:Number = 0; i < chars.length; i++)
            {
                if (str.indexOf(chars[i]) == -1) continue;
                // trace('Story.cleanup(): removing "' + chars[i].charCodeAt(0) + '"');
                str = str.split(chars[i]).join(' ');
            }

            description = str;
        }
    }

    private function makeDate(value, key:String):Void
    {
        // trace('Story.makeDate("' + value + '", "' + key + '")');
        // attempt conversion to a UNIX timestamp
        var intVal:Number = parseInt(value);
        if (isFinite(intVal)) value = intVal;

        if (typeof value == 'number')
        {
            this[key] = DateExt.fromTimestamp(value);
        }
        else if (typeof value == 'string')
        {
            this[key] = DateExt.fromString(value);
        }

        if (this[key])
        {
            // trace('* Story.makeDate() parsed into: ' + this[key]);
        }
        else
        {
            // trace('* Story.makeDate(): unable to parse!');
        }
    }

    public function getLink(text:String, href:String, target:String):String
    {
        if (null == text) text = title;
        return super.getLink(text, href, target);
    }

    public function safeKey():String
    {
        return super.safeKey(id.toString(), 'story_');
    }

    public function get url():String
    {
        return href;
    }

    public function getActivityURL(args:Object):String
    {
        var baseURL:String = API.baseURL + 'story/' + id + '/activity';
        return URLBuilder.build(baseURL, args);
    }

    public function compare(story:Story):Boolean
    {
        return id == story.id;
    }

    /*
     * Sorting methods
     */
    public static function comparePromoteAsc(story1:Story, story2:Story):Number
    {
        return Story.compareDates(story1, story2, 'promote', 1);
    }

    public static function comparePromoteDesc(story1:Story, story2:Story):Number
    {
        return Story.compareDates(story1, story2, 'promote', -1);
    }

    public static function compareSubmitAsc(story1:Story, story2:Story):Number
    {
        return Story.compareDates(story1, story2, 'submit', 1);
    }

    public static function compareSubmitDesc(story1:Story, story2:Story):Number
    {
        return Story.compareDates(story1, story2, 'submit', -1);
    }

    public static function compareDates(story1:Story, story2:Story, key:String, order:Number):Number
    {
        var p1:DateExt = story1[key + 'Date'];
        var p2:DateExt = story2[key + 'Date'];
        if (p1 < p2) return -order;
        else if (p1 > p2) return order;
        else return 0;
    }

    public function get loaded():Boolean
    {
        return title.length > 0;
    }

    /*
     * BC methods... in other words, DEPRECATED!
     */
    public function get category():String
    {
        return topic.name;
    }

    public function get submit_date():DateExt
    {
        return submitDate;
    }

    public function get promote_date():DateExt
    {
        return promoteDate;
    }
}


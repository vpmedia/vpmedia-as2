/*
 * vim:et sts=4 sw=4 cindent:
 * $Id: ModelObject.as 598 2007-01-13 01:20:42Z allens $
 */

import org.json.JSON;
import com.digg.fdk.model.Model;

class com.digg.fdk.model.ModelObject extends Object
{
	public var name:String;
	
    public function ModelObject(properties:Object)
    {
        for (var k:String in properties)
            this[k] = properties[k];
    }

    public function copy():ModelObject
    {
        return new ModelObject(this);
    }

    public function update(obj:ModelObject):Boolean
    {
        var updated:Boolean = false;
        for (var p:String in obj)
        {
            if (this.hasOwnProperty(p) && typeof obj[p] == typeof this[p] && obj[p] != this[p])
            {
                this[p] = obj[p];
                updated = true;
            }
        }
        return updated;
    }

    public function get url():String
    {
        return 'javascript:alert("Hello there!")';
    }
    
    public function getLink(text:String, href:String, target:String):String
    {
        if (null == text) text = this.name;
        if (null == href) href = this.url;
        if (null == target) target = '_blank';
        return '<a href="' + href + '" target="' + target + '">' + text + '</a>';
    }

    public static function fromXML(node:XMLNode, model:Model):ModelObject
    {
        return new ModelObject(node.attributes);
    }

    public function safeKey(key:String, prefix:String):String
    {
        if (null == key) key = this.name;

        if (null != prefix && !isNaN(parseInt(key.substr(0, 1))))
        {
            return prefix + key;
        }

        return key;
    }

    public function toObject(deep:Boolean):Object
    {
        if (null == deep) deep = true;

        var obj:Object = new Object();
        for (var k:String in this)
        {
            obj[k] = (deep && typeof this[k].toObject == 'function')
                     ? this[k].toObject(true)
                     : this[k];
        }
        return obj;
    }

    public function toString():String
    {
        return JSON.stringify(this.toObject());
    }
}

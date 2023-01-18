class com.fear.util.StringUtil
{
        static public function endswith(inString:String, sChar:String):Boolean
        {
                var l_index:Number = inString.lastIndexOf(sChar);
                var s_count = inString.length;
                var c_count = sChar.length;
                return (s_count - c_count == l_index);
        }

        static public function startswith(inString:String, sChar:String):Boolean
        {
                return inString.indexOf(sChar) == 0;
        }

        static public function lstrip(inString:String):String
        {
                var index:Number = 0;
                while(inString.charCodeAt(index) < 33){
                        index++;
                }
                return inString.substr(index)
        }

        static public function rstrip(inString:String):String
        {
                var index:Number = inString.length - 1;
                while(inString.charCodeAt(index) < 33){
                        index--;
                }
                return inString.substr(0,index + 1)
        }

        static public function strip(inString:String):String
        {
                return StringUtil.rstrip(StringUtil.lstrip(inString))
        }

        static public function capitalize(inString:String):String
        {
                var a:Number = 0;
                var aString:Array = inString.split(" ");
                for(a = 0; a < aString.length; a++)
                {
                        aString[a] = aString[a].substring(0,1).toUpperCase() + aString[a].substring(1, aString[a].length).toLowerCase();
                }
                return aString.join(" ");
        }

        static public function replace(inStr:String, oldChar:String, newChar:String):String
        {
                if(inStr == undefined or inStr == null)
                {
                        return inStr;
                }
                return inStr.split(oldChar).join(newChar);
        }
}

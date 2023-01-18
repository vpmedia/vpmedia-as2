class com.desuade.partigen.Errors
{
    function Errors()
    {
    } // End of the function
    static function output(er, ec, ol, es, a1, a2)
    {
        es = es == undefined ? ("GLOBAL") : (es);
        if (com.desuade.partigen.Partigen._output >= ol)
        {
            if (er == true)
            {
                a1 = a1 == undefined ? ("") : (String(a1));
                a2 = a2 == undefined ? ("") : (String(a2));
                trace (">>Partigen [" + es + "]: " + a2 + com.desuade.partigen.Errors.code(ec) + a1);
            }
            else
            {
                trace (com.desuade.partigen.Errors.code(ec));
            } // end if
        } // end else if
    } // End of the function
    static function code(ec)
    {
        switch (ec)
        {
            case 0:
            {
                //return ("####################################\rDesuade Partigen " + com.desuade.partigen.Partigen.LONGVERSION() + "\n" + com.desuade.partigen.Partigen.__get__WEBSITE() + "\n" + com.desuade.partigen.Partigen.__get__LICENSE() + "\n" + "####################################");
                break;
            } 
            case 1:
            {
                return ("This beta version has expired and will cease to function.");
                break;
            } 
            case 2:
            {
                return ("Created: ");
                break;
            } 
            case 3:
            {
                return ("Removed: ");
                break;
            } 
            case 4:
            {
                return ("No such emitter.");
                break;
            } 
            case 5:
            {
                return ("s: Received event broadcast from ");
                break;
            } 
            case 6:
            {
                return ("Duplicating ");
                break;
            } 
            case 7:
            {
                return ("This trial of Partigen is over. Please purchase a license to continue use.");
                break;
            } 
            case 111:
            {
                return ("Failed to create an emitter. Reason: Unknown.");
                break;
            } 
            case 112:
            {
                return ("Failed to create an emitter. Reason: No target.");
                break;
            } 
            case 113:
            {
                return ("Failed to create an emitter. Reason: No name.");
                break;
            } 
            case 114:
            {
                return ("Failed to create an emitter. Reason: An instance exists at desired depth.");
                break;
            } 
            case 121:
            {
                return ("Starting verification sequence on ");
                break;
            } 
            case 122:
            {
                return (" - Error: Undefined");
                break;
            } 
            case 123:
            {
                return (" - OK");
                break;
            } 
            case 124:
            {
                return ("Verification proccess completed with ");
                break;
            } 
            case 125:
            {
                return (" - Error: Does not exist in library.");
                break;
            } 
            case 126:
            {
                return (" - Warning: Events should be a 3 item Object with boolean values.");
                break;
            } 
            case 127:
            {
                return (" - Error: Could not load source after 3 seconds.");
                break;
            } 
            case 128:
            {
                return (" - Error: Unknown mode or type.");
                break;
            } 
            case 129:
            {
                return (" - Error: Type must be a Number or String.");
                break;
            } 
            case 130:
            {
                return (" - Error: Type must be a Number.");
                break;
            } 
            case 131:
            {
                return (" - Warning: Values less than 0 will be treated as 0.");
                break;
            } 
            case 132:
            {
                return (" - Error: String must be a number, \'disabled\', or \'null\'.");
                break;
            } 
            case 133:
            {
                return (" - Error: Unknown ease type.");
                break;
            } 
            case 134:
            {
                return (" - Error: The only String accepted is \'disabled\'.");
                break;
            } 
            case 135:
            {
                return (" - Error: Must be an Array or \'disabled\'.");
                break;
            } 
            case 136:
            {
                return (" - Error: Array should have exactly two defined values.");
                break;
            } 
            case 137:
            {
                return (" - Warning: Minimum value is greater than maximum.");
                break;
            } 
            case 138:
            {
                return (" - Warning: A range of -360 to +360 is recommended.");
                break;
            } 
            case 139:
            {
                return (" - Error: A positive number is required.");
                break;
            } 
            case 140:
            {
                return (" - Error: Should be \'front\', \'back\', or \'random\'.");
                break;
            } 
            case 141:
            {
                return (" - Error: Target must be a valid MovieClip.");
                break;
            } 
            case 142:
            {
                return (" - Error: Lowest depth must be 1 to 1048574.");
                break;
            } 
            case 143:
            {
                return (" - Warning: An item exists at that depth and will be overwritten.");
                break;
            } 
            case 144:
            {
                return (" - Error: An emitter will be overwritten.");
                break;
            } 
            case 145:
            {
                return (" - Error: One or more Array items were not a Number.");
                break;
            } 
            case 146:
            {
                return (" - Error: String must be a number.");
                break;
            } 
            case 147:
            {
                return (" - Error: One or more Array items were not a Number or String.");
                break;
            } 
            case 148:
            {
                return (" - Error: A Number between 0 and 100 is required.");
                break;
            } 
            case 149:
            {
                return (" - Warning: A negative friction will produce incorrect results.");
                break;
            } 
            case 150:
            {
                return (" - Warning: Event object should only contain onBirth, onDeath, or onTweenEnd.");
                break;
            } 
            case 151:
            {
                return (" - Warning: The other control is disabled. This value will have no effect.");
                break;
            } 
            case 152:
            {
                return (" - Error: Array must have exactly 3 defined values.");
                break;
            } 
            case 211:
            {
                return ("Failed to create particle. Reason: Error loading.");
                break;
            } 
            case 212:
            {
                return ("Failed to create particle. Reason: Error unknown.");
                break;
            } 
            case 221:
            {
                return ("Started: ");
                break;
            } 
            case 222:
            {
                return ("Emitter is already started.");
                break;
            } 
            case 223:
            {
                return ("Stopped: ");
                break;
            } 
            case 224:
            {
                return ("Emitter is already stopped.");
                break;
            } 
            case 225:
            {
                return ("Emitter could not be started due to errors.");
                break;
            } 
            case 231:
            {
                return ("Thawing and freezing all child particles.");
                break;
            } 
            case 232:
            {
                return ("Thawing particle: ");
                break;
            } 
            case 233:
            {
                return ("Freezing particle: ");
                break;
            } 
            case 234:
            {
                return ("Freezing selected child particles.");
                break;
            } 
            case 235:
            {
                return ("Thawing selected child particles.");
                break;
            } 
            case 236:
            {
                return (" contains antifreeze and can not be frozen.");
                break;
            } 
            case 237:
            {
                return ("Freezing or thawing is only allowed on child particles.");
                break;
            } 
            case 238:
            {
                return (" is not frozen, so only antifreeze will be applied.");
                break;
            } 
            case 239:
            {
                return ("No effect: There are no current living particles.");
                break;
            } 
            case 241:
            {
                return ("Applied configuration successfully.");
                break;
            } 
            case 242:
            {
                return ("Error loading config file: ");
                break;
            } 
            case 243:
            {
                return (" does not exist.");
                break;
            } 
            case 244:
            {
                return (" -> ");
                break;
            } 
            case 245:
            {
                return ("The active emitter\'s timeout has been changed to ");
                break;
            } 
            case 246:
            {
                return ("Emission timeout has been disabled (0)");
                break;
            } 
            case 247:
            {
                return ("The next emission start will have a timeout of ");
                break;
            } 
            case 248:
            {
                return ("Parsing string...");
                break;
            } 
            case 249:
            {
                return ("Loading configuration file: ");
                break;
            } 
            case 311:
            {
                return (") was born!");
                break;
            } 
            case 312:
            {
                return (") has died!");
                break;
            } 
            case 313:
            {
                return (" has an infinite life.");
                break;
            } 
            case 314:
            {
                return (") has been killed!");
                break;
            } 
            case 411:
            {
                return ("Error loading DLM Client - halting engine");
                break;
            } 
            case 412:
            {
                return ("You can not create emitters through AS with a Publish-Only license.");
                break;
            } 
        } // End of switch
    } // End of the function
} // End of Class

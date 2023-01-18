class com.rootylicious.utils.Delegate
{
    /**
    Creates a functions wrapper for the original function so that it runs
    in the provided context.
    @param obj Context in which to run the function.
    @param func Function to run.
    @param args... Specify other args if you like - they'll get appended 
to the arguments list of the called function.
    */
    static function create(obj:Object, func:Function):Function
    {
        var wrapper:Function=function()
        {
            var wrapper:Function=arguments.callee;

            var args:Array=arguments.slice();
            if (wrapper.moreArgs!=undefined)
                args=args.concat(wrapper.moreArgs);

            return wrapper.func.apply(wrapper.target, args);
        };

        wrapper.target = obj;
        wrapper.func = func;
        if (arguments.length>2)
            wrapper.moreArgs=arguments.slice(2);
        return wrapper;
    }
}
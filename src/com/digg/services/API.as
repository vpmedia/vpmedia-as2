/*
 * vim:et sts=4 sw=4 cindent:
 * $Id: API.as 663 2007-02-13 01:18:28Z allens $
 */

import com.digg.fdk.model.*;
import com.digg.services.*;
import com.digg.services.response.*;
import com.stamen.data.URLBuilder;
import com.stamen.utils.DateExt;

/**
 * The API class is a collection of static methods used to query the Digg API.
 * For more information, please refer to the API documentation on the web:
 *
 * [FIXME: need URL]
 */
class com.digg.services.API
{
    public static var STORIES_POPULAR:String = 'popular';
    public static var STORIES_UPCOMING:String = 'upcoming';

    /**
     * @var     apiURL  The base URL for API calls.
     */
    public static var baseURL:String = 'http://services.digg.com/';

    /**
     * @var     appKey  The default API application key.
     */
    public static var appKey:String;

    /**
     * Execute an API request. The returned Response object can be listened to
     * for load events using {@link Response.addLoadListener()}.
     *
     * @param   path    the API path component.
     * @param   args    arbitrary key/value pairs to be supplied as parameters
     *                  for the API call.
     */
    public static function request(path:String, args:Object, response:IResponse):IResponse
    {
        // make sure we get an object
        if (null == args)
            args = new Object();

        // make sure there's an appkey
        if (null == args.appkey && appKey)
            args.appkey = appKey;

        var baseURL:String = API.baseURL + path;
        var url:String = URLBuilder.build(baseURL, args);
        // trace('API.request(): ' + url);

        if (null == response) response = new Response();
        response.load(url);
        return response;
    }

    /**
     * Convert a numeric UNIX timestamp (seconds since the epoch) into a Date
     * object.
     *
     * @TODO: explain why UNIX timestamps are used
     */
    public static function getDateFromTimestamp(timestamp:Number):Date
    {
        return new Date(timestamp * 1000);
    }

    /**
     * Get the number of seconds since the UNIX epoch from a Date object.
     *
     * @TODO: explain why UNIX timestamps are used
     */
    public static function getTimestampFromDate(date:Date):Number
    {
        return (date.getTime() / 1000) >> 0;
    }


    /*
     * Tutorial methods!
     *
     * These are some convenience methods used in the FDK example pieces.
     * Looking for something a bit more low-level? Scroll down to the bottom.
     */

    /**
     * Retrieve a list of recent popular stories.
     *
     * @param   count   The number of stories to retrieve
     */
    public static function getRecentPopularStories(count:Number):StoriesResponse
    {
        return StoriesResponse(request('stories/popular',       // request path
                                       {count: count || 10},    // query string arguments
                                       new StoriesResponse())); // a response object to hold the stories
    }

    /**
     * Retrieve a list of recent upcoming stories.
     *
     * @param   count   The number of stories to retrieve
     */
    public static function getRecentUpcomingStories(count:Number):StoriesResponse
    {
        return StoriesResponse(request('stories/upcoming',      // request path
                                       {count: count || 10},    // query string arguments
                                       new StoriesResponse())); // a response object to hold the stories
    }

    /**
     * Retrieve a list of recent diggs.
     *
     * @param   count   The number of stories to retrieve
     */
    public static function getRecentDiggs(count:Number):DiggsResponse
    {
        return DiggsResponse(request('stories/diggs',       // request path
                                     {count: count || 100}, // query string arguments
                                     new DiggsResponse())); // a response object to hold the diggs
    }

    /**
     * Retrieve a list of diggs in the queue, bounded by dates.
     *
     * @param   startDate   Starting date (inclusive)
     * @param   endDate     Ending date (exclusive)
     */
    public static function getQueueDiggsBetweenDates(startDate:Date, endDate:Date):DiggsResponse
    {
        var args:Object = new Object();
    
        if (startDate)  args['min_date'] = getTimestampFromDate(startDate);
        if (endDate)    args['max_date'] = getTimestampFromDate(endDate);
    
        return DiggsResponse(request('stories/upcoming/diggs',  // request path
                                     args,                      // query string arguments
                                     new DiggsResponse()));     // a response object to hold the diggs
    }


    /*
     * Low-level methods
     *
     * Use these if you'd like to construct some more sophisticated API queries.
     */

    /**
     * Get the REST path for a story.
     *
     * @param   story   Either be a first-class Story object or the ID of a
     *                  story. NOTE: You can query the API for stories with a
     *                  specific URL by providing the "link" argument to any of
     *                  the "stories" endpoints.
     */
    public static function getStoryPath(story):String
    {
        var storyID:String = (story instanceof Story)
                             ? story.id.toString()
                             : story.toString();
        return 'story/' + storyID;
    }

    /**
     * Get the REST path for a user.
     *
     * @param   user    Either a first-class User object with a valid "name"
     *                  member, or a username string.
     */
    public static function getUserPath(user):String
    {
        var username:String = (user instanceof User)
                              ? user.name
                              : user;
        return 'user/' + username;
    }

    /**
     * Get the REST path for a list of stories.
     *
     * @param   storyStatus     any of the STORY_* constants representing a
     *                          story status ("popular" or "upcoming").
     */
    public static function getStoriesPath(storyStatus:String):String
    {
        var path:String = 'stories';
        if (storyStatus) path += '/' + storyStatus;
        return path;
    }

    /**
     * Get the REST path for a list of diggs.
     *
     * @param   storyStatus     any of the STORY_* constants representing a
     *                          story status ("popular" or "upcoming")
     */
    public static function getDiggsPath(storyStatus:String):String
    {
        return getStoriesPath(storyStatus) + '/diggs';
    }

    /**
     * Query the API for information about a single story.
     *
     * @param   story   either a story ID, or a {@link Story} object with an id
     *                  attribute. (see {@link getStoryPath()}).
     */
    public static function getStory(story):StoryResponse
    {
        return StoryResponse(request(getStoryPath(story), null, new StoryResponse()));
    }

    /**
     * Query the API for a list of stories.
     *
     * @param   number          the number of stories to fetch.
     * @param   storyStatus     any of the STORY_* constants representing a
     *                          story status ("popular" or "upcoming"). If this
     *                          is not provided, an interleaved list of all
     *                          stories matching the given criteria will be
     *                          returned.
     * @param   args            additional query string arguments
     */
    public static function getStories(storyStatus:String, args:Object):StoriesResponse
    {
        return StoriesResponse(request(getStoriesPath(storyStatus), args, new StoriesResponse()));
    }

    /**
     * Query the API for recent stories.
     *
     * @param   number          the number of stories to fetch.
     * @param   storyStatus     any of the STORY_* constants representing a
     *                          story status ("popular" or "upcoming").
     * @param   args            additional query string arguments.
     */
    public static function getRecentStories(number:Number, storyStatus:String, args:Object):StoriesResponse
    {
        if (null == args) args = new Object();
        args['count'] = number || 10;
        return getStories(storyStatus, args);
    }

    /**
     * Query the API for diggs on a given story.
     *
     * @param   story   either a numeric story ID, or a {@link Story} object
     *                  with an id attribute. (see {@link getStoryPath()})
     * @param   args    additional query string arguments.
     */
    public static function getStoryDiggs(story, args:Object):StoriesResponse
    {
        var path:String = getStoryPath(story) + '/diggs';
        return StoriesResponse(request(path, args, new StoriesResponse()));
    }

    /**
     * Query the API for comments on a given story.
     *
     * @param   story   either a numeric story ID, or a {@link Story} object
     *                  with an id attribute. (see {@link getStoryPath()})
     * @param   args    additional query string arguments.
     */
    public static function getStoryComments(story, args:Object):CommentsResponse
    {
        var path:String = getStoryPath(story) + '/comments';
        return CommentsResponse(request(path, args, new CommentsResponse()));
    }

    /**
     * Query the API for information about a single user.
     *
     * @param   user    either a user name string, or a {@link User} object
     *                  with a name attribute. (see {@link getUserPath()})
     */
    public static function getUser(user):UserResponse
    {
        return UserResponse(request(getUserPath(user), null, new UserResponse()));
    }

    /**
     * Query the API for diggs by a certain user.
     *
     * @param   user    either a username string, or a {@link User} object with
     *                  a name attribute. (see {@link getUserPath()})
     * @param   args    additional query string arguments
     */
    public static function getUserDiggs(user, args:Object):DiggsResponse
    {
        var path:String = getUserPath(user) + '/diggs';
        return DiggsResponse(request(path, args, new DiggsResponse()));
    }

    /**
     * Query the API for a list of a user's friends.
     *
     * @param   user    either a username string, or a {@link User} object with
     *                  a name attribute. (see {@link getUserPath()})
     * @param   args    additional query string arguments
     */
    public static function getUserFriends(user, args:Object):UsersResponse
    {
        var path:String = getUserPath(user) + '/friends';
        return UsersResponse(request(path, args, new UsersResponse()));
    }

    /**
     * Query the API for a list of a user's fans.
     *
     * @param   user    either a username string, or a {@link User} object with
     *                  a name attribute. (see {@link getUserPath()})
     * @param   args    additional query string arguments
     */
    public static function getUserFans(user, args:Object):UsersResponse
    {
        var path:String = getUserPath(user) + '/fans';
        return UsersResponse(request(path, args, new UsersResponse()));
    }

    /**
     * Query the API for diggs made in a given date range.
     *
     * @param   startDate       the start of the date range (inclusive)
     * @param   endDate         the end of the date range (exclusive)
     * @param   storyStatus     see {@link getStoryPath()}
     * @param   args            additional query string arguments
     */
    public static function getDiggsBetweenDates(startDate:Date, endDate:Date, storyStatus:String, args:Object):DiggsResponse
    {
        if (null == args) args = new Object();
        args['min_date'] = getTimestampFromDate(startDate);
        args['max_date'] = getTimestampFromDate(endDate);
        return DiggsResponse(request(getDiggsPath(storyStatus), args, new DiggsResponse()));
    }

    public static function getTopics():TopicsResponse
    {
        var path:String = 'topics';
        return TopicsResponse(request(path, null, new TopicsResponse()));
    }
}

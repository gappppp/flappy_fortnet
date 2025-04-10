<?php
    // CONSTANTS ---------------------------------------------
    const DB_HOSTNAME = "localhost";
    const DB_USERNAME = "root";
    const DB_PASSWORD = "";
    const DB_DATABASE = "fortnet";
    const ALLOWED_METHODS = ["GET", "POST", "PUT", "DELETE"];//TODO expand PATCH method

    // SQL SCHEMA ---------------------------------------------
    /*
    CREATE TABLE `like_post` (
    	`id_like` int(11) PRIMARY KEY NOT NULL AUTO_INCREMENT,
        `id_user` int(11) NOT NULL,
        `id_post` int(11) NOT NULL
    );

    CREATE TABLE `post` (
        `id_post` int(11) NOT NULL,
        `title` varchar(30) NOT NULL DEFAULT 'Insert title here',
        `body` varchar(255) NOT NULL DEFAULT 'Insert body here'
    );

    CREATE TABLE `utenti` (
        `id_user` int(11) NOT NULL,
        `username` varchar(32) NOT NULL,
        `password` varchar(255) NOT NULL
    );
    */

    // INFOS ---------------------------------------------
    /*
    request should be formed like this: http://[server_name]/php/fortnet.php/[operation]?[querystring]

    WEB API
    // TODO
    GET METHODS
    - users (type: READ) --> returns an XML or JSON of every user
    - user_search (type: READ) --> returns an XML or JSON of users,
        only the users that satisfy the filter given as parameter will be returned
        - parameters: id(unsigned_int), username(string), format('XML'|'JSON')

    - posts (type: READ) --> returns an XML or JSON of every post
    - post_search (type: READ) --> returns an XML or JSON of posts,
    only the posts that satisfy the filter given as parameter will be returned
        - parameters: id(unsigned_int), title(string), body(string), format('XML'|'JSON')

    - likes (type: READ) --> returns an XML or JSON of every like
    - like_search (type: READ) --> returns an XML or JSON of likes,
        only the likes that satisfy the filter given as parameter will be returned
        - parameters: id_like(unsigned_int), format('XML'|'JSON')
            id_user(unsigned_int), username(string),
            id_post(unsigned_int), title(string), body(string)

    note: 'format' parameter can assume the 'XML' or 'JSON' value and it indicates whether
        the server response should be an XML or a JSON. if omitted the default is 'XML'.

    all READ function returns:
    - a XML or JSON if query is succesful and has content,
    - 'BAD REQUEST' if querystring of the URI is bad formed (e.g.: has wrong/empty parameter)
    - 'ERROR' if query is unsuccesful or an exception/error occurs during runtime

    POST METHODS
    - user (type: CREATE) --> create a new user with the body given in the request
    - post (type: CREATE) --> create a new post with the body given in the request

    note: the body request can be encoded in 'XML' or 'JSON' with the appropriate header ('Content-type')
        that reports it (correspondingly 'application/xml' or 'application/json')

    all POST function returns:
    - 'CREATED' if successful
    - 'BAD REQUEST' if body request is bad formed
    - 'ERROR' if query is unsuccesful or an exception/error occurs during runtime
    
    PUT METHOD
    - user (type: UPDATE) --> update a user with the body given in the request
    - post (type: UPDATE) --> update a post with the body given in the request
    - add_like (type: UPDATE) --> add a like with the body given in the request
    - mod_like (type: UPDATE) --> modify a like with the body given in the request
    - del_like (type: UPDATE) --> delete a like with the id given in the querystring

    note: the body request can be encoded in 'XML' or 'JSON' with the appropriate header ('Content-type')
        that reports it (correspondingly 'application/xml' or 'application/json')

    all PUT function returns:
    - 'NO CONTENT' if successful
    - 'BAD REQUEST' if body request is bad formed
    - 'ERROR' if query is unsuccesful or an exception/error occurs during runtime

    DELETE METHOD
    - user (type: CREATE) --> delete a user with the id given in the querystring
        (parameters: id(unsigned_int))
    - post (type: CREATE) --> delete a post with the id given in the querystring
        (parameters: id(unsigned_int))

    all DELETE function returns:
    - 'NO CONTENT' if successful
    - 'BAD REQUEST' if body request is bad formed
    - 'ERROR' if query is unsuccesful or an exception/error occurs during runtime

    GENERAL PRINCIPLES

    - for each operation of the web api a [method]_[operation] function is defined
        parameters: $conn (the connection to the database)
        return: string representing the XML or the JSON
    - in case of specifying unsupported method (see the 'ALLOWED_METHODS' constant):
        status code 405 (Method not allowed) in response is returned
    - in case of specifying an operation that is not present in the web api:
        status code 404 (Not Found) in the response is returned

    */

    // FUNCTIONS DECLARATION ---------------------------------------------
    // UTILS ---------------------------------------------
    /**
     * converts an associative array of users into a SimpleXMLElement.
     * @param array $arr an array of users with the following structure:
     *  [
     *      ["id" => "...", "username" => "...", "password" => "..."],
     *      ...
     *  ]
     * @return SimpleXMLElement|NULL The XML representation of the users or NULL on failure.
     */
    function users_assoc_to_xml($arr) {
        if (!is_array($arr)) return NULL; // check if $arr is an users array

        $res = new SimpleXMLElement("<users/>");

        foreach ($arr as $value) {
            if (array_keys($value) !== ["id", "username", "password"])
                return NULL; // check if $arr is an users array

            // build the XML
            $user = $res->addChild("user");
            $user->addAttribute("id", $value["id"]);
            $user->addChild("username", $value["username"]);
            $user->addChild("password", $value["password"]);
        }

        return $res->asXML();
    }

    /**
     * converts an associative array of users into a JSON string.
     * @param array $arr an array of users with the following structure:
     *  [
     *      ["id" => "...", "username" => "...", "password" => "..."],
     *      ...
     *  ]
     * @return string|NULL The JSON representation of the users or NULL on failure.
    */
    function users_assoc_to_json($arr) {
        //check if $arr is an users array
        if (!is_array($arr)) return NULL;

        foreach ($arr as $value) {
            if(array_keys($value) !== ["id", "username", "password"]) return NULL;
        }

        //build the json string
        $res = json_encode($arr);
        return (($res === FALSE) ? NULL : $res);//return the array or NULL on failure
    }

    /**
     * converts an associative array of posts into a SimpleXMLElement.
     * @param array $arr an array of posts with the following structure:
     *  [
     *      ["id" => "...", "title" => "...", "body" => "..."],
     *      ...
     *  ]
     * @return SimpleXMLElement|NULL The XML representation of the posts or NULL on failure.
     */
    function posts_assoc_to_xml($arr) {
        if (!is_array($arr)) return NULL; // check if $arr is an posts array

        $res = new SimpleXMLElement("<posts/>");

        foreach ($arr as $value) {
            if (array_keys($value) !== ["id", "title", "body"])
                return NULL; // check if $arr is an posts array

            // build the XML
            $user = $res->addChild("post");
            $user->addAttribute("id", $value["id"]);
            $user->addChild("title", $value["title"]);
            $user->addChild("body", $value["body"]);
        }

        return $res->asXML();
    }

    /**
     * converts an associative array of posts into a JSON string.
     * @param array $arr an array of posts with the following structure:
     *  [
     *      ["id" => "...", "title" => "...", "body" => "..."],
     *      ...
     *  ]
     * @return string|NULL The JSON representation of the posts or NULL on failure.
    */
    function posts_assoc_to_json($arr) {
        // check if $arr is an posts array
        if (!is_array($arr)) return NULL;

        foreach ($arr as $value) {
            if(array_keys($value) !== ["id", "title", "body"]) return NULL;
        }

        // build the json string
        $res = json_encode($arr);
        return (($res === FALSE) ? NULL : $res); // return the array or NULL on failure
    }

    /**
     * converts an associative array of likes into a SimpleXMLElement.
     * @param array $arr an array of likes with the following structure:
     *  [
     *      ["id_like" => "...", "id_user" => "...", "username" => "...", "password" => "...", "id_post" => "...", "title" => "...", "body" => "..."],
     *      ...
     *  ]
     * @return SimpleXMLElement|NULL The XML representation of the likes or NULL on failure.
     */
    function likes_assoc_to_xml($arr) {
        if (!is_array($arr)) return NULL; // check if $arr is a like array

        $res = new SimpleXMLElement("<likes/>");

        foreach ($arr as $value) {
            if (array_keys($value) !== [
                "id_like",
                "id_user", "username", "password",
                "id_post", "title", "body"
            ])
                return NULL; // check if $arr is a like array

            $like = $res->addChild("like");

            $like->addAttribute("id", $value["id_like"]);

            $user = $like->addChild("user");

            $user->addAttribute("id", $value["id_user"]);
            $user->addChild("username", $value["username"]);
            $user->addChild("password", $value["password"]);

            $post = $like->addChild("post");

            $post->addAttribute("id", $value["id_post"]);
            $post->addChild("title", $value["title"]);
            $post->addChild("body", $value["body"]);
        }

        return $res->asXML();
    }

    /**
     * converts an associative array of likes into a JSON string.
     * @param array $arr an array of likes with the following structure:
     *  [
     *      ["id_like" => "...", "id_user" => "...", "username" => "...", "password" => "...", "id_post" => "...", "title" => "...", "body" => "..."],
     *      ...
     *  ]
     * @return string|NULL The JSON representation of the likes or NULL on failure.
    */
    function likes_assoc_to_json($arr) {
        // check if $arr is an like array
        if (!is_array($arr)) return NULL;

        $new_json = [];

        foreach ($arr as $value) {
            if (array_keys($value) !== [
                "id_like",
                "id_user", "username", "password",
                "id_post", "title", "body"
            ])
                return NULL; // check if $arr is a like array

            $new_json[] = [
                "id" => $value["id_like"],
                "user" => [
                    "id" => $value["id_user"],
                    "username" => $value["username"],
                    "password" => $value["password"]
                ],
                "post" => [
                    "id" => $value["id_post"],
                    "title" => $value["title"],
                    "body" => $value["body"]
                ]
            ];
        }

        // build the json string
        $res = json_encode($new_json);
        return (($res === FALSE) ? NULL : $res); // return the array or NULL on failure
    }

    // /**
    //  * flatten an associative array (using normal array may cause unexpected behaviour)
    //  * 
    //  * @param array $arr the array to flatten
    //  * 
    //  * @return array the array flattened
    //  */
    // function flatten_assoc(array $arr) {
    //     $flattened = FALSE;

    //     while (!$flattened) {
    //         foreach ($arr as $key => $value) {
    //             $temp = $value;

    //             if(is_array($temp)) {
    //                 unset($arr[$key]);
    //                 $arr = array_merge($arr, $temp);
    //                 $flattened = TRUE; //contrary logic: FALSE because...
    //                 break;
    //             }
    //         }
            
    //         $flattened = !$flattened;//...here is reversed
    //     }
        
    //     return $arr;
    // }

    // GENERAL ---------------------------------------------
    /**
     * get the operation from the URI
     *
     * @param string $uri the uri that contains the operation
     * @return string the operation
     */
    function ws_operation($uri) { // extract the operationfrom the URI
        $uri_arr = parse_url($uri); // parse the uri (see PHP parse_url)
        $path = explode("/", $uri_arr['path']); // split the path into parts using '/' as separator
        return $path[count($path) - 1]; // the last element is the operation
    }

    /**
     * Check whether the response should be an XML or JSON by the parameter 'format' of the querystring
     * and then invoke the proper function (if format is not set, by default XML response is given)
     *
     * @param string $xml_func_name a string representing the name of the function to invoke if requested format is 'XML'
     * @param string $json_func_name a string representing the name of the function to invoke if requested format is 'JSON'
     * @param array $arr the array that need to passed at the callbacks to produce the XML or the JSON string
     *
     * @return SimpleXMLElement|string|NULL|FALSE a SimpleXMLElement or a JSON string if the format is 'XML' or 'JSON' and the given function exist,
     * otherwise FALSE (note that the callbacks on conversion failure will return NULL)
     *
     */
    function assoc_to_xml_or_json(string $xml_func_name, string $json_func_name, $arr) {
        if (function_exists($xml_func_name) && function_exists($json_func_name)) {
            if (!isset($_GET['format'])) { // no format set = use DEFAULT = response in XML
                // header to indicate that response is an XML
                header('Content-Type: application/xml');
                return call_user_func($xml_func_name, $arr);
            } else {
                $format = strtoupper($_GET['format']);

                if ($format == 'XML') { // respond in XML if specified
                    // header to indicate that response is an XML
                    header('Content-Type: application/xml');
                    return call_user_func($xml_func_name, $arr);
                } else if ($format == 'JSON') { // respond in JSON if specified
                    // header to indicate that response is a JSON
                    header('Content-Type: application/json');
                    return call_user_func($json_func_name, $arr);
                }
            }
        }

        return FALSE;
    }

    /**
     * Attempt to convert a raw XML or JSON string to an associative array
     * 
     * @param string raw_string the string to convert
     * 
     * @return true|false|null|array an associative array or FALSE if the request header CONTENT_TYPE is not
     * <code>application/xml</code> nor <code>application/json</code>. the conversion may also returns
     * <code>TRUE</code> or <code>NULL</code>, please check json_decode function.
     */
    function xml_or_json_to_assoc(string $raw_strig) {
        if ($_SERVER["CONTENT_TYPE"] == "application/xml") {
            $xml = simplexml_load_string($raw_strig);
            $json = json_encode($xml);
            return json_decode($json,TRUE);

        } else if ($_SERVER["CONTENT_TYPE"] == "application/xml") {
            return json_decode($raw_strig,TRUE);

        }

        return FALSE;
    }

    // GET ---------------------------------------------
    /**
    * GET all user 👌.
    *
    * How to use this function:
    * <code>
    *   // GET all user
    *   $conn = new mysqli(DB_HOSTNAME, DB_USERNAME, DB_PASSWORD, DB_DATABASE);
    *   get_users($conn);
    * </code>
    * @param mixed $conn la connessione col database (mysqli)
    * @return string|SimpleXMLElement Returns a string message ("ERROR", "BAD REQUEST")
    * or an XML string (SimpleXMLElement) / JSON string representing the users' data in XML/JSON format
    * (see function assoc_to_xml_or_json for further detail on succes returns)
    */
    function get_users($conn) {
        $res = "ERROR"; // set default result of function to ERROR (= failure)

        $sql = "SELECT id_user AS id, username, password FROM utenti"; // basic query
        $stmt = $conn->prepare($sql); // use statements to avoid injections

        $res_query = $stmt->execute();

        if ($res_query) {
            $raw_res = $stmt->get_result();
            $res_arr = $raw_res->fetch_all(MYSQLI_ASSOC);

            // turn array to XML or JSON, on format failure report (a general) ERRROR
            $res = assoc_to_xml_or_json("users_assoc_to_xml", "users_assoc_to_json", $res_arr);
            if ($res === FALSE || $res === NULL) $res = "ERROR";

            $raw_res->free();
        }

        return $res;
    }

    /**
    * GET user that satisfy the querystring like <code>id</code> and/or <code>username</code>,
    * this method will list all user that respect the filters (GET params)
    *
    * How to use this function:
    * <code>
    *   // GET all user
    *   // filter are automatically included in $_GET that contains id and username
    *   $conn = new mysqli(DB_HOSTNAME, DB_USERNAME, DB_PASSWORD, DB_DATABASE);
    *   get_users($conn);
    * </code>
    * @param mixed $conn la connessione col database (mysqli)
    * @return string|SimpleXMLElement Returns a string message ("ERROR", "BAD REQUEST")
    * or an XML string (SimpleXMLElement) / JSON string representing the users' data in XML/JSON format
    * (see function assoc_to_xml_or_json for further detail on success returns)
    */
    function get_search_user($conn) {
        $res = "ERROR"; // set default result of function to ERROR (= failure)

        $sql = "SELECT id_user AS id, username, password FROM utenti"; // basic query
        $filters = []; // additional filters
        $stmt_types = ""; // data types of the filters (see PHP bind_param for more)

        // add id filter if isset and contains digits (ctype_digits)
        if (isset($_GET['id'])) {
            if (ctype_digit($_GET['id'])) {
                // urldecode avoids error if using wildcards (e.g.: '%')
                $filters["id_user LIKE ?"] = strval(urldecode($_GET['id']));
                $stmt_types .= "s";
            } else return "BAD REQUEST"; // bad request
        }

        // add username filter if isset and is not an empty string
        if (isset($_GET['username'])) {
            if ($_GET['username'] != "") {
                // urldecode avoids error if using wildcards
                $filters["username LIKE ?"] = strval(urldecode($_GET['username']));
                $stmt_types .= "s";
            } else return "BAD REQUEST"; // bad request
        }

        if (count($filters) > 0) { // if filters were set
            $sql .= ' WHERE '.implode(' AND ', array_keys($filters)); // build sql string with WHERE and the filters
            $stmt = $conn->prepare($sql); // use statements to avoid injections

            // splat operator (...) work like this: e.g.: ...[1, 5, 7, 9] == turned into ==> 1, 5, 7, 9
            $stmt->bind_param($stmt_types, ...array_values($filters));
        } else {
            return "BAD REQUEST";//must explicfy at least 1 filter
        }

        $res_query = $stmt->execute();

        if ($res_query) {
            $raw_res = $stmt->get_result();
            $res_arr = $raw_res->fetch_all(MYSQLI_ASSOC);

            // turn array to XML or JSON, on format failure report (a general) ERRROR
            $res = assoc_to_xml_or_json("users_assoc_to_xml", "users_assoc_to_json", $res_arr);
            if ($res === FALSE || $res === NULL) $res = "ERROR";

            $raw_res->free();
        }

        return $res;
    }

    /**
    * GET all post 👌.
    * 
    * How to use this function:
    * <code>
    *   // GET all post
    *   $conn = new mysqli(DB_HOSTNAME, DB_USERNAME, DB_PASSWORD, DB_DATABASE);
    *   get_posts($conn);
    * </code>
    * @param mixed $conn la connessione col database (mysqli)
    * @return string|SimpleXMLElement Returns a string message ("ERROR", "BAD REQUEST")
    * or an XML string (SimpleXMLElement) / JSON string representing the users' data in XML/JSON format
    * (see function assoc_to_xml_or_json for further detail on succes returns)
    */
    function get_posts($conn) {
        $res = "ERROR"; // set default result of function to ERROR (= failure)

        $sql = "SELECT id_post AS id, title, body FROM post"; // basic query
        $stmt = $conn->prepare($sql); // use statements to avoid injections

        $res_query = $stmt->execute();

        if ($res_query) {
            $raw_res = $stmt->get_result();
            $res_arr = $raw_res->fetch_all(MYSQLI_ASSOC);

            // turn array to XML or JSON, on format failure report (a general) ERRROR
            $res = assoc_to_xml_or_json("posts_assoc_to_xml", "posts_assoc_to_json", $res_arr);
            if ($res === FALSE || $res === NULL) $res = "ERROR";

            $raw_res->free();
        }

        return $res;
    }

    /**
    * GET all post that satisfy the querystring like <code>id</code>
    * and/or <code>title</code> and/or <code>body</code>
    * 
    * How to use this function:
    * <code>
    *   // GET all post
    *   $conn = new mysqli(DB_HOSTNAME, DB_USERNAME, DB_PASSWORD, DB_DATABASE);
    *   get_posts($conn);
    * </code>
    * @param mixed $conn la connessione col database (mysqli)
    * @return string|SimpleXMLElement Returns a string message ("ERROR", "BAD REQUEST")
    * or an XML string (SimpleXMLElement) / JSON string representing the users' data in XML/JSON format
    * (see function assoc_to_xml_or_json for further detail on succes returns)
    */
    function get_search_post($conn) {
        $res = "ERROR"; // set default result of function to ERROR (= failure)

        $sql = "SELECT id_post AS id, title, body FROM post"; // basic query
        $filters = []; // additional filters
        $stmt_types = ""; // data types of the filters (see PHP bind_param for more)

        // add id filter if isset and contains digits (ctype_digits)
        if (isset($_GET['id'])) {
            if (ctype_digit($_GET['id'])) {
                // urldecode avoids error if using wildcards (e.g.: '%')
                $filters["id_post LIKE ?"] = strval(urldecode($_GET['id']));
                $stmt_types .= "s";

            } else return "BAD REQUEST"; // bad request
        }

        // add title filter if isset and is not an empty string
        if (isset($_GET['title'])) {
            if ($_GET['title'] != "") {
                // urldecode avoids error if using wildcards
                $filters["title LIKE ?"] = strval(urldecode($_GET['title']));
                $stmt_types .= "s";

            } else return "BAD REQUEST"; // bad request
        }

        // add body filter if isset and is not an empty string
        if (isset($_GET['body'])) {
            if ($_GET['body'] != "") {
                // urldecode avoids error if using wildcards
                $filters["body LIKE ?"] = strval(urldecode($_GET['body']));
                $stmt_types .= "s";
            } else return "BAD REQUEST"; // bad request
        }

        if (count($filters) > 0) { // if filters were set
            $sql .= ' WHERE '.implode(' AND ', array_keys($filters)); // build sql string with WHERE and the filters
            $stmt = $conn->prepare($sql); // use statements to avoid injections

            // splat operator (...) work like this: e.g.: ...[1, 5, 7, 9] == turned into ==> 1, 5, 7, 9
            $stmt->bind_param($stmt_types, ...array_values($filters));
        } else {
            return "BAD REQUEST";//must explicify at least 1 filter
        }

        $res_query = $stmt->execute();

        if ($res_query) {
            $raw_res = $stmt->get_result();
            $res_arr = $raw_res->fetch_all(MYSQLI_ASSOC);

            // turn array to XML or JSON, on format failure report (a general) ERRROR
            $res = assoc_to_xml_or_json("posts_assoc_to_xml", "posts_assoc_to_json", $res_arr);
            if ($res === FALSE || $res === NULL) $res = "ERROR";

            $raw_res->free();
        }

        return $res;
    }

    /**
    * GET all user liked posts 👌.
    *
    * How to use this function:
    * <code>
    *   // GET all user liked posts
    *   $conn = new mysqli(DB_HOSTNAME, DB_USERNAME, DB_PASSWORD, DB_DATABASE);
    *   get_user_liked_posts($conn);
    * </code>
    * @param mixed $conn la connessione col database (mysqli)
    * @return string|SimpleXMLElement Returns a string message ("ERROR", "BAD REQUEST")
    * or an XML string (SimpleXMLElement) / JSON string representing the users liked posts' data in XML/JSON format
    * (see function assoc_to_xml_or_json for further detail on succes returns)
    */
    function get_likes($conn) {
        $res = "ERROR"; // set default result of function to ERROR (= failure)

        $sql = "SELECT id_like, utenti.id_user, username, password, post.id_post, title, body FROM utenti LEFT JOIN like_post ON like_post.id_user=utenti.id_user LEFT JOIN post ON like_post.id_post=post.id_post"; // basic query
        $stmt = $conn->prepare($sql); // use statements to avoid injections

        $res_query = $stmt->execute();
        
        if ($res_query) {
            $raw_res = $stmt->get_result();
            $res_arr = $raw_res->fetch_all(MYSQLI_ASSOC);
                // echo "<pre>".print_r($res_arr, TRUE)."</pre>";
            // turn array to XML or JSON, on format failure report (a general) ERRROR
            $res = assoc_to_xml_or_json("likes_assoc_to_xml", "likes_assoc_to_json", $res_arr);

            if ($res === FALSE || $res === NULL) $res = "ERROR";
            // header('Content-Type: application/text');
                // echo "RES: $res";
            $raw_res->free();
        }

        return $res;
    }

    /**
    * GET all user liked posts that satisfy the querystring like <code>id_like</code> and/or <code>id_user</code> and/or <code>username</code>
    * and/or <code>password</code> and/or <code>id_post</code> and/or <code>title</code> and/or <code>body</code>,
    * this method will list all user liked posts that respect the filters (GET params)
    *
    * How to use this function:
    * <code>
    *   // GET all user liked posts
    *   // filter are automatically included in $_GET that contains id_user, username, password, id_post, title and body
    *   $conn = new mysqli(DB_HOSTNAME, DB_USERNAME, DB_PASSWORD, DB_DATABASE);
    *   get_user_liked_posts($conn);
    * </code>
    * @param mixed $conn la connessione col database (mysqli)
    * @return string|SimpleXMLElement Returns a string message ("ERROR", "BAD REQUEST")
    * or an XML string (SimpleXMLElement) / JSON string representing the users liked posts' data in XML/JSON format
    * (see function assoc_to_xml_or_json for further detail on succes returns)
    */
    function get_search_like($conn) {
        $res = "ERROR"; // set default result of function to ERROR (= failure)

        $sql = "SELECT id_like, utenti.id_user, username, password, post.id_post, title, body FROM utenti LEFT JOIN like_post ON like_post.id_user=utenti.id_user LEFT JOIN post ON post.id_post=like_post.id_post"; // basic query
        $filters = []; // additional filters
        $stmt_types = ""; // data types of the filters (see PHP bind_param for more)

        // add id filter if isset and contains digits (ctype_digits)
        if (isset($_GET['id_like'])) {
            if (ctype_digit($_GET['id_like'])) {
                // urldecode avoids error if using wildcards (e.g.: '%')
                $filters["like_post.id_like LIKE ?"] = strval(urldecode($_GET['id_like']));
                $stmt_types .= "s";

            } else return "BAD REQUEST"; // bad request
        }

        // add id filter if isset and contains digits (ctype_digits)
        if (isset($_GET['id_user'])) {
            if (ctype_digit($_GET['id_user'])) {
                // urldecode avoids error if using wildcards (e.g.: '%')
                $filters["utenti.id_user LIKE ?"] = strval(urldecode($_GET['id_user']));
                $stmt_types .= "s";

            } else return "BAD REQUEST"; // bad request
        }

        // add username filter if isset and is not an empty string
        if (isset($_GET['username'])) {
            if ($_GET['username'] != "") {
                // urldecode avoids error if using wildcards
                $filters["username LIKE ?"] = strval(urldecode($_GET['username']));
                $stmt_types .= "s";

            } else return "BAD REQUEST"; // bad request
        }

        // add password filter if isset and is not an empty string
        if (isset($_GET['password'])) {
            if ($_GET['password'] != "") {
                // urldecode avoids error if using wildcards
                $filters["password LIKE ?"] = strval(urldecode($_GET['password']));
                $stmt_types .= "s";
            } else return "BAD REQUEST"; // bad request
        }

        // add id filter if isset and contains digits (ctype_digits)
        if (isset($_GET['id_post'])) {
            if (ctype_digit($_GET['id_post'])) {
                // urldecode avoids error if using wildcards (e.g.: '%')
                $filters["post.id_post LIKE ?"] = strval(urldecode($_GET['id_post']));
                $stmt_types .= "s";

            } else return "BAD REQUEST"; // bad request
        }

        // add title filter if isset and is not an empty string
        if (isset($_GET['title'])) {
            if ($_GET['title'] != "") {
                // urldecode avoids error if using wildcards
                $filters["title LIKE ?"] = strval(urldecode($_GET['title']));
                $stmt_types .= "s";

            } else return "BAD REQUEST"; // bad request
        }

        // add body filter if isset and is not an empty string
        if (isset($_GET['body'])) {
            if ($_GET['body'] != "") {
                // urldecode avoids error if using wildcards
                $filters["body LIKE ?"] = strval(urldecode($_GET['body']));
                $stmt_types .= "s";
            } else return "BAD REQUEST"; // bad request
        }

        if (count($filters) > 0) { // if filters were set
            $sql .= ' WHERE '.implode(' AND ', array_keys($filters)); // build sql string with WHERE and the filters
            $stmt = $conn->prepare($sql); // use statements to avoid injections

            // splat operator (...) work like this: e.g.: ...[1, 5, 7, 9] == turned into ==> 1, 5, 7, 9
            $stmt->bind_param($stmt_types, ...array_values($filters));
        } else {
           return "BAD REQUEST";//require at least 1 filter
        }

        $res_query = $stmt->execute();

        if ($res_query) {
            $raw_res = $stmt->get_result();
            $res_arr = $raw_res->fetch_all(MYSQLI_ASSOC);

            // turn array to XML or JSON, on format failure report (a general) ERRROR
            $res = assoc_to_xml_or_json("likes_assoc_to_xml", "likes_assoc_to_json", $res_arr);
            if ($res === FALSE || $res === NULL) $res = "ERROR";

            $raw_res->free();
        }

        return $res;
    }

    // POST --------------------------------------------------
    /**
    * POST/CREATE a user 👌.
    * Create a user the <code>username</code> and the <code>password</code> of the user are specified in the body of the request
    *
    * How to use this function:
    * <code>
    *   // POST/CREATE a user
    *   $conn = new mysqli(DB_HOSTNAME, DB_USERNAME, DB_PASSWORD, DB_DATABASE);
    *   post_user($conn);
    * </code>
    * @param mixed $conn la connessione col database (mysqli)
    * @return string Returns a string message ("BAD REQUEST", "CREATED", "ERROR")
    */
    function post_user($conn) {
        $sql = "INSERT INTO utenti (username, password) VALUES (?, ?)"; // basic query
        $values = [];

        // get body data
        $input = file_get_contents('php://input');

        $arr = xml_or_json_to_assoc($input);

        // need username to add a post
        if (isset($arr['username'])) {
            // urldecode avoids error if using wildcards
            $values[] = strval(urldecode($arr['username']));
        } else return "BAD REQUEST"; // bad request

        // need password to add a post
        if (isset($arr['password'])) {
            // urldecode avoids error if using wildcards
            $values[] = strval(urldecode($arr['password']));
        } else return "BAD REQUEST"; // bad request

        $stmt = $conn->prepare($sql); // use statements to avoid injections

        // splat operator (...) work like this: e.g.: ...[1, 5, 7, 9] == turned into ==> 1, 5, 7, 9
        $stmt->bind_param("ss", ...$values);

        $res = $stmt->execute();

        return ($res) ? "CREATED" : "ERROR";
    }

    /**
    * POST/CREATE a post 👌.
    * Create a post the <code>title</code> and the <code>body</code> of the post are specified in the body of the request
    *
    * How to use this function:
    * <code>
    *   // POST/CREATE a post
    *   $conn = new mysqli(DB_HOSTNAME, DB_USERNAME, DB_PASSWORD, DB_DATABASE);
    *   post_post($conn);
    * </code>
    * @param mixed $conn la connessione col database (mysqli)
    * @return string Returns a string message ("BAD REQUEST", "CREATED", "ERROR")
    */
    function post_post($conn) {
        $sql = "INSERT INTO post (title, body) VALUES (?, ?)"; // basic query
        $values = [];

        // get body data
        $input = file_get_contents('php://input');

        $arr = xml_or_json_to_assoc($input);

        // need title to add a post
        if (isset($arr['title'])) {
            // urldecode avoids error if using wildcards
            $values[] = strval(urldecode($arr['title']));
        } else return "BAD REQUEST"; // bad request

        // need body to add a post
        if (isset($arr['body'])) {
            // urldecode avoids error if using wildcards
            $values[] = strval(urldecode($arr['body']));
        } else return "BAD REQUEST"; // bad request

        $stmt = $conn->prepare($sql); // use statements to avoid injections

        // splat operator (...) work like this: e.g.: ...[1, 5, 7, 9] == turned into ==> 1, 5, 7, 9
        $stmt->bind_param("ss", ...$values);

        $res = $stmt->execute();

        return ($res) ? "CREATED" : "ERROR";
    }

    // PUT --------------------------------------------------
    /**
    * PUT/UPDATE a user 👌.
    * Updates a user the <code>username</code> or the <code>password</code> or both of them
    * and the id of the user is specified in the body of the request
    *
    * How to use this function:
    * <code>
    *   // PUT/UPDATE a user
    *   $conn = new mysqli(DB_HOSTNAME, DB_USERNAME, DB_PASSWORD, DB_DATABASE);
    *   put_user($conn);
    * </code>
    * @param mixed $conn la connessione col database (mysqli)
    * @return string Returns a string message ("BAD REQUEST", "NO CONTENT", "ERROR")
    */
    function put_user($conn) {
        $sql = "UPDATE utenti SET "; // basic query
        $values = [];
        $stmt_types = "";

        // get body data
        $input = file_get_contents('php://input');

        $arr = xml_or_json_to_assoc($input);

        // username to update a user
        if (isset($arr['username'])) {
            // urldecode avoids error if using wildcards
            $values["username=?"] = strval(urldecode($arr['username']));
            $stmt_types .= "s";
        }

        // password to update a user
        if (isset($arr['password'])) {
            // urldecode avoids error if using wildcards
            $values["password=?"] = strval(urldecode($arr['password']));
            $stmt_types .= "s";
        }

        // need id to update a user
        if (isset($arr['id']) && is_numeric($arr['id']) && count($values) >= 2) {
            // urldecode avoids error if using wildcards
            $id = strval(urldecode($arr['id']));

            $sql .= implode(', ', array_keys($values))." WHERE id_user=?";

            $stmt = $conn->prepare($sql); // use statements to avoid injections

            $values[] = $id;

            // splat operator (...) work like this: e.g.: ...[1, 5, 7, 9] == turned into ==> 1, 5, 7, 9
            $stmt->bind_param($stmt_types."i", ...array_values($values));

            $res_query = $stmt->execute();

            return ($res_query) ? "NO CONTENT" : "ERROR";

            return "NO CONTENT";
        }

        return "BAD REQUEST";
    }

    /**
    * PUT/UPDATE a post 👌.
    * Updates a post the <code>title</code> or the <code>body</code> or both of them
    * and the id of the post is specified in the body of the request
    *
    * How to use this function:
    * <code>
    *   // PUT/UPDATE a post
    *   $conn = new mysqli(DB_HOSTNAME, DB_USERNAME, DB_PASSWORD, DB_DATABASE);
    *   put_post($conn);
    * </code>
    * @param mixed $conn la connessione col database (mysqli)
    * @return string Returns a string message ("BAD REQUEST", "NO CONTENT", "ERROR")
    */
    function put_post($conn) {
        $sql = "UPDATE post SET "; // basic query
        $values = [];
        $stmt_types = "";

        // get body data
        $input = file_get_contents('php://input');

        $arr = xml_or_json_to_assoc($input);

        // title to update a post
        if (isset($arr['title'])) {
            // urldecode avoids error if using wildcards
            $values["title=?"] = strval(urldecode($arr['title']));
            $stmt_types .= "s";
        }

        // body to update a post
        if (isset($arr['body'])) {
            // urldecode avoids error if using wildcards
            $values["body=?"] = strval(urldecode($arr['body']));
            $stmt_types .= "s";
        }

        // need id to update a post
        if (isset($arr['id']) && is_numeric($arr['id']) && count($values) >= 2) {
            // urldecode avoids error if using wildcards
            $id = strval(urldecode($arr['id']));

            $sql .= implode(', ', array_keys($values))." WHERE id_post=?";

            $stmt = $conn->prepare($sql); // use statements to avoid injections

            $values[] = $id;

            // splat operator (...) work like this: e.g.: ...[1, 5, 7, 9] == turned into ==> 1, 5, 7, 9
            $stmt->bind_param($stmt_types."i", ...array_values($values));

            $res_query = $stmt->execute();

            return ($res_query) ? "NO CONTENT" : "ERROR";

            return "NO CONTENT";
        }

        return "BAD REQUEST";
    }

    /**
    * PUT/UPDATE a like 👌 (CREATE a relation => PUT).
    * Create a like, the <code>id_user</code> and the <code>id_post</code> are specified in the body of the request
    *
    * How to use this function:
    * <code>
    *   // PUT/UPDATE a like
    *   $conn = new mysqli(DB_HOSTNAME, DB_USERNAME, DB_PASSWORD, DB_DATABASE);
    *   put_add_likes($conn);
    * </code>
    * @param mixed $conn la connessione col database (mysqli)
    * @return string Returns a string message ("BAD REQUEST", "CREATED", "ERROR")
    */
    function put_add_like($conn) {
        $sql = "INSERT INTO like_post (id_user, id_post) VALUES (?, ?)"; // basic query
        $values = [];

        // get body data
        $input = file_get_contents('php://input');

        $arr = xml_or_json_to_assoc($input);

        // need id_user to add a like
        if (isset($arr['id_user'])) {
            // urldecode avoids error if using wildcards
            $values[] = strval(urldecode($arr['id_user']));
        } else return "BAD REQUEST"; // bad request

        // need id_post to add a like
        if (isset($arr['id_post'])) {
            // urldecode avoids error if using wildcards
            $values[] = strval(urldecode($arr['id_post']));
        } else return "BAD REQUEST"; // bad request

        $stmt = $conn->prepare($sql); // use statements to avoid injections

        // splat operator (...) work like this: e.g.: ...[1, 5, 7, 9] == turned into ==> 1, 5, 7, 9
        $stmt->bind_param("ss", ...$values);

        $res = $stmt->execute();

        return ($res) ? "CREATED" : "ERROR";
    }

    /**
    * PUT/UPDATE a like 👌
    * Updates a like, the <code>id_user</code> and the <code>id_post</code> are specified in the body of the request
    *
    * How to use this function:
    * <code>
    *   // PUT/UPDATE a like
    *   $conn = new mysqli(DB_HOSTNAME, DB_USERNAME, DB_PASSWORD, DB_DATABASE);
    *   put_mod_likes($conn);
    * </code>
    * @param mixed $conn la connessione col database (mysqli)
    * @return string Returns a string message ("BAD REQUEST", "NO CONTENT", "ERROR")
    */
    function put_mod_likes($conn) {
        $sql = "UPDATE like_post SET "; // basic query
        $values = [];
        $stmt_types = "";

        // get body data
        $input = file_get_contents('php://input');

        $arr = xml_or_json_to_assoc($input);
        
        // id_user to update a post
        if (isset($arr['id_user']) && is_numeric($arr['id_user'])) {
            // urldecode avoids error if using wildcards
            $values["id_user=?"] = strval(urldecode($arr['id_user']));
            $stmt_types .= "s";
        }

        // id_post to update a post
        if (isset($arr['id_post']) && is_numeric($arr['id_post'])) {
            // urldecode avoids error if using wildcards
            $values["id_post=?"] = strval(urldecode($arr['id_post']));
            $stmt_types .= "s";
        }

        // need id to update a post
        if (isset($arr['id_like']) && is_numeric($arr['id_like']) && count($values) >= 2) {
            // urldecode avoids error if using wildcards
            $id = strval(urldecode($arr['id_like']));

            $sql .= implode(', ', array_keys($values))." WHERE id_like=?";

            $stmt = $conn->prepare($sql); // use statements to avoid injections

            $values[] = $id;

            // splat operator (...) work like this: e.g.: ...[1, 5, 7, 9] == turned into ==> 1, 5, 7, 9
            $stmt->bind_param($stmt_types."i", ...array_values($values));

            $res_query = $stmt->execute();

            return ($res_query) ? "NO CONTENT" : "ERROR";

            return "NO CONTENT";
        }

        return "BAD REQUEST";
    }

    /**
    * DELETE a like 👌 (PUT method since it's a relation).
    * id specified in the querystring
    *
    * How to use this function:
    * <code>
    *   // DELETE a user
    *   $conn = new mysqli(DB_HOSTNAME, DB_USERNAME, DB_PASSWORD, DB_DATABASE);
    *   put_del_likes($conn);
    * </code>
    * @param mixed $conn la connessione col database (mysqli)
    * @return string Returns a string message ("BAD REQUEST", "NO CONTENT", "ERROR")
    */
    function put_del_likes($conn) {
        $sql = "DELETE FROM like_post WHERE id_like=?"; // basic query

        // need id to delete a user
        if (isset($_GET['id'])) {
            // urldecode avoids error if using wildcards
            $id = strval(urldecode($_GET['id']));

            $stmt = $conn->prepare($sql); // use statements to avoid injections

            // splat operator (...) work like this: e.g.: ...[1, 5, 7, 9] == turned into ==> 1, 5, 7, 9
            $stmt->bind_param("i", $id);

            $res = $stmt->execute();

            return ($res) ? "NO CONTENT" : "ERROR";
        }

        return "BAD REQUEST"; // bad request
    }

    // DELETE ----------------------------------------------
    /**
    * DELETE a user 👌.
    * id specified in the querystring
    *
    * How to use this function:
    * <code>
    *   // DELETE a user
    *   $conn = new mysqli(DB_HOSTNAME, DB_USERNAME, DB_PASSWORD, DB_DATABASE);
    *   delete_user($conn);
    * </code>
    * @param mixed $conn la connessione col database (mysqli)
    * @return string Returns a string message ("BAD REQUEST", "NO CONTENT", "ERROR")
    */
    function delete_user($conn) {
        $sql = "DELETE FROM utenti WHERE id_user=?"; // basic query

        // need id to delete a user
        if (isset($_GET['id'])) {
            // urldecode avoids error if using wildcards
            $id = strval(urldecode($_GET['id']));

            $stmt = $conn->prepare($sql); // use statements to avoid injections

            // splat operator (...) work like this: e.g.: ...[1, 5, 7, 9] == turned into ==> 1, 5, 7, 9
            $stmt->bind_param("i", $id);

            $res = $stmt->execute();

            return ($res) ? "NO CONTENT" : "ERROR";
        }

        return "BAD REQUEST"; // bad request
    }

    /**
    * DELETE a post 👌.
    * id specified in the querystring
    *
    * How to use this function:
    * <code>
    *   // DELETE a post
    *   $conn = new mysqli(DB_HOSTNAME, DB_USERNAME, DB_PASSWORD, DB_DATABASE);
    *   delete_post($conn);
    * </code>
    * @param mixed $conn la connessione col database (mysqli)
    * @return string Returns a string message ("BAD REQUEST", "NO CONTENT", "ERROR")
    */
    function delete_post($conn) {
        $sql = "DELETE FROM post WHERE id_post=?"; // basic query

        // need id to delete a post
        if (isset($_GET['id'])) {
            // urldecode avoids error if using wildcards
            $id = strval(urldecode($_GET['id']));

            $stmt = $conn->prepare($sql); // use statements to avoid injections

            // splat operator (...) work like this: e.g.: ...[1, 5, 7, 9] == turned into ==> 1, 5, 7, 9
            $stmt->bind_param("i", $id);

            $res = $stmt->execute();

            return ($res) ? "NO CONTENT" : "ERROR";
        }

        return "BAD REQUEST"; // bad request
    }

    // MAIN BODY ---------------------------------------------
    $statuscode = 405; // status code inizializzato a 405 Method Not Allowed

    // use this to let code work in most php versions
    // (report everything and use try-catch to handle every possible error)
    mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);

    try {
        $conn = new mysqli(DB_HOSTNAME, DB_USERNAME, DB_PASSWORD, DB_DATABASE);

        // get function name to invoke
        $function = strtolower($_SERVER['REQUEST_METHOD'])."_".ws_operation($_SERVER['REQUEST_URI']);
        
        // invoke requested function if exist
        if (function_exists($function)) $res = call_user_func($function, $conn);

        $conn->close();

        if(in_array($_SERVER['REQUEST_METHOD'], ALLOWED_METHODS)) {
            if(!isset($res)) $statuscode = 404; // operation unavailable
            else if($res == "BAD REQUEST") $statuscode = 400; // operation exist but parameters are insufficient
            else if($res == "NO CONTENT") $statuscode = 204; // operation returned nothing
            else if($res == "CREATED") $statuscode = 201; // operation returned nothing
            else if($res == "ERROR") $statuscode = 500; // general server error
            else $statuscode = 200; // operation executed successfuly
        }

    } catch (mysqli_sql_exception $mse) {
        $statuscode = 500;
        echo "<p>ERROR REPORT: ".$mse."</p>";// TEMP DEBUG
    }

    http_response_code($statuscode); // return status code of the response
    if (isset($res) && !is_bool($res) && ($statuscode == 200 || $statuscode == 201)) echo $res; // send response if exist

?>

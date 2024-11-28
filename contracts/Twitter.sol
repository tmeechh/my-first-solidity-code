// SPDX-License-Identifier: MIT

// Create Twitter Contract - DONE
// Create a mapping between user and tweet - DONE
// Add function to create a tweet and save it in mapping -DONE
// Create a function to get tweet - DONE
// Add array of tweet -DONE

// Define a Tweet struct, author, content, time-stamp, likes - DONE
// Add the struct to array - DONE
// Test tweets - DONE

// use require to limit the  length of tweet to be only 280 characters - DONE

// 1 Add a function called changeTweetLength to change max tweet length - DONE
// HINT: use newTweetLength as input for function - DONE
// 2 Create a constructor function to set an owner of contract - DONE
// 2 Create a modifier call onlyOwner - DONE
// 4 Use onlyOwner on the changeTweetLength function - DONE

// Add id to tweet Struct to make every tweet unique
// Set the id to be Tweet[] length
// HINT: ypu do it in the createTweet function
// Add a function to like the tweet
// HINT : there should be 2 parameters, id and author
// Add a function to unlike the tweet
// HINT : make sure you can unlike only if likes count is greater than 0
// Mark both funcions external

// 1 Create event for creating the tweet, called TweetCreated - DONE
// USE parameters like id, author , content , timestamp
// 2 Emit the event in the createTweet() function below - DONE
// 3 Create event for liking the tweet, called TweetLiked - DONE
// Use parameters like liker, tweetAuthor, tweetId, newLikeCount
// 4 Emit the event in the likeTweet() function below

// 1 Create a function, getTotalLikes, to get total Tweet Likes for the user - DONE
// USE parameters of author - DONE
// 2 Loop over all the tweets - DONE
// 3 Sum up totalLikes - DONE
// 4 Return totalLikes - DONE

// 1 Import Ownable.sol contract from OpenZepplelin
// 2 Inherit Ownable Contract
// 3 Replace current onlyOwner

// 1 Add a getProfile() function to the interface - DONE
// 2 Initialize the IProfile in the constructor - DONE
// HINT : dont forget to include the _profileContract address as a input
// 3 Create a modifier called onlyRegistered that require the msg.sender to have a profile - DONE
// HINT : use the getProfile() to get the user
// HINT: check if displayName.length > 0 to make sure the user exists
// 4 ADD the onlyRegistered modified to createTweet, likeTweet, and unlikeTweet - DONE

import "@openzeppelin/contracts/access/Ownable.sol";

pragma solidity ^0.8.26;

interface IProfile {
    struct UserProfile {
        string displayName;
        string bio;
    }

    function getProfile(address _user)
        external
        view
        returns (UserProfile memory);
}

contract Twitter is Ownable {
    uint16 public MAX_TWEET_LENGTH = 280;

    // Define struct
    struct Tweet {
        uint256 id;
        address author;
        string content;
        uint256 timestamp;
        uint256 likes;
    }
    mapping(address => Tweet[]) public tweets;
    // profile contract defined here
    IProfile public profileContract;

    // address public owner;

    // Define the events here
    event TweetCreated(
        uint256 id,
        address author,
        string content,
        uint256 timestamp
    );
    event TweetLiked(
        address liker,
        address tweetAuthor,
        uint256 tweetId,
        uint256 newLikeCount
    );
    event TweetUnLiked(
        address UnLiker,
        address tweetAuthor,
        uint256 tweetId,
        uint256 newLikeCount
    );

    modifier onlyRegistered (){
    IProfile.UserProfile memory userProfileTemp = profileContract.getProfile(msg.sender);

    require(bytes(userProfileTemp.displayName).length > 0, "user not registered ");
    _;
    }


    //    // Pass the initial owner to the Ownable constructor
    // constructor(address initialOwner) Ownable(initialOwner) {
    //     // Any additional setup can go here
    // }

    constructor(address _profileContract) Ownable(msg.sender) {
        profileContract = IProfile(_profileContract);
    }

    // modifier onlyOwner() {
    //     require(msg.sender == owner, "You are not the owner!!!");
    //     _;
    // }

    function changeTweetLength(uint16 newTweetLength) public onlyOwner {
        MAX_TWEET_LENGTH = newTweetLength;
    }

    function createTweet(string memory _tweet) public onlyRegistered{
        // conditional
        // if tweet length <= 280 then we are good, otherwise we revert
        require(
            bytes(_tweet).length <= MAX_TWEET_LENGTH,
            "Tweet is too long bro! calma"
        );

        Tweet memory newTweet = Tweet({
            author: msg.sender,
            content: _tweet,
            timestamp: block.timestamp,
            likes: 0,
            id: tweets[msg.sender].length
        });

        tweets[msg.sender].push(newTweet);

        emit TweetCreated(
            newTweet.id,
            newTweet.author,
            newTweet.content,
            newTweet.timestamp
        );
    }

    function getTweet(uint256 _i) public view returns (Tweet memory) {
        return tweets[msg.sender][_i];
    }

    function getAllTweets(address _owner) public view returns (Tweet[] memory) {
        return tweets[_owner];
    }

    function likeTweet(address author, uint256 id) external onlyRegistered{
        require(tweets[author][id].id == id, "Tweet does not exist");

        tweets[author][id].likes++;

        emit TweetLiked(msg.sender, author, id, tweets[author][id].likes);
    }

    function unLikeTweet(address author, uint256 id) external onlyRegistered{
        require(tweets[author][id].id == id, "Tweet does not exist");
        require(tweets[author][id].likes > 0, "Tweet has no likes MR MAN");

        tweets[author][id].likes--;

        emit TweetUnLiked(msg.sender, author, id, tweets[author][id].likes);
    }

    function getTotalLikes(address _author) external view returns (uint256) {
        uint256 totalLikes;

        for (uint256 i = 0; i < tweets[_author].length; i++) {
            totalLikes += tweets[_author][i].likes;
        }

        return totalLikes;
    }
}

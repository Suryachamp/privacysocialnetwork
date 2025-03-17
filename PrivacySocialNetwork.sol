// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract PrivacySocialNetwork {
    // Structure to store post details.
    struct Post {
        address author;
        string content; // This can be an encrypted message
        uint256 timestamp;
    }
    
    // Counter for post IDs
    uint256 public postCount;
    
    // Mapping to store posts using a post ID.
    mapping(uint256 => Post) private posts;
    
    // Event emitted when a new post is created.
    event PostCreated(uint256 indexed postId, address indexed author, uint256 timestamp);
    
    // Event emitted when a post is updated.
    event PostUpdated(uint256 indexed postId, address indexed author, uint256 timestamp);
    
    /**
     * @dev Creates a new post.
     * @param _content The (preferably encrypted) content of the post.
     */
    function createPost(string calldata _content) external {
        postCount++;
        posts[postCount] = Post({
            author: msg.sender,
            content: _content,
            timestamp: block.timestamp
        });
        emit PostCreated(postCount, msg.sender, block.timestamp);
    }
    
    /**
     * @dev Retrieves a post by its ID.
     * @param _postId The ID of the post to retrieve.
     * @return author The address of the post creator.
     * @return content The content of the post.
     * @return timestamp The timestamp when the post was created.
     */
    function getPost(uint256 _postId) external view returns (address author, string memory content, uint256 timestamp) {
        Post memory post = posts[_postId];
        return (post.author, post.content, post.timestamp);
    }
    
    /**
     * @dev Allows the author of a post to update its content.
     * @param _postId The ID of the post to update.
     * @param _newContent The new (preferably encrypted) content.
     */
    function updatePost(uint256 _postId, string calldata _newContent) external {
        Post storage post = posts[_postId];
        require(msg.sender == post.author, "Only the author can update this post.");
        post.content = _newContent;
        // Update the timestamp to reflect the time of update.
        post.timestamp = block.timestamp;
        emit PostUpdated(_postId, msg.sender, block.timestamp);
    }
}

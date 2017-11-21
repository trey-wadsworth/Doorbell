module TweetsHelper
	def get_tagged(tweet)
		message_arr = []
		message_arr = tweet.message.split

    

    message_arr.each_with_index do |word, index|
      if word[0] == '#'
        if Tag.pluck(:phrase).include?(word.downcase)
          tag = Tag.find_by(phrase: word.downcase)
        else
          tag = Tag.create(phrase: word.downcase)
        end
        tweet_tag = TweetTag.create(tweet_id: tweet.id, tag_id: tag.id)
        message_arr[index] = "<a href='/tag_tweets?id=#{tag.id}'>#{word}</a>"
      end
    end
    
    tweet.message = message_arr.join(" ")
    return tweet

  end

  def hot_tags
    # tags = Tag.order(created_at: :desc).limit(3)
    tweets = TweetTag.all
    if tweets.length > 0
      tag_ids = []
      tag_arr = []
      count = 1
      tags = TweetTag.all.group_by { |h| h['tag_id']}.to_a.sort_by{|x| x[1].length}
      3.times do
        tag_ids.push(tags[tags.length-count][0])
        count += 1
      end
    end
    tag_ids.each do |phrase|
      tag_phrase = Tag.find(phrase)
      tag_arr.push(tag_phrase)
    end
    return tag_arr
  end
    
    
  

  def top_tweeter
    tweets = Tweet.all
    if tweets.length > 0
      user_id = Tweet.all.group_by { |h| h['user_id']}.to_a.max_by { |x| x[1].length}.first
      user = User.find(user_id)
      return user
    end
  end
  def top_number_tweets
    tweets = Tweet.all
    if tweets.length > 0
      user_id = Tweet.all.group_by { |h| h['user_id']}.to_a.max_by { |x| x[1].length}.first
    end
    @tweets = Tweet.where(user_id: user_id)
    return tweets.length
  end
end

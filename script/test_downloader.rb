require "merb-core"
Merb.start_environment(:environment => ENV['MERB_ENV'] || 'development')

url = 'http://s3.amazonaws.com/twitter_production/profile_images/140671252/sapiens_normal.jpg'
#url = 'http://filebar.kg/files/451806871/5%20Tohoshinki%20-%20Share%20The%20World%5B720X544%5D.mkv'
url = 'http://farm4.static.flickr.com/3550/3632204442_65309ee83a.jpg?v=0'

#url = 'http://kino.motor.kg/Download.ashx?video_id=b82016965dae4fc4a05cfcb623a13150'

link = Link.create! :url => url, :status => 'queued'

Downloader.start!(link)

link.delete
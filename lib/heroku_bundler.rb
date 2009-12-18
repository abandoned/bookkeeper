class HerokuBundler
  require 'heroku'
  
  def initialize(user, password, app_name)
    @user, @password, @app_name = user, password, app_name
  end
  
  def destroy_all
    client.bundles(@app_name).each do |bundle|
      client.bundle_destroy(@app_name, bundle[:name])
    end
    return self
  end
  
  def capture
    client.bundle_capture(@app_name)
    return self
  end
  
  private
  
  def client
    @client ||= Heroku::Client.new(@user, @password)
  end
end
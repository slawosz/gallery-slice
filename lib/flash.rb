class Flash
  def initialize(*args)
    @attrs = Mash.new(*args)
    @keepers = []
  end
 
  def []=(key, value)
    @attrs[key] = value
    keep key
  end
 
  def update(hash)
    @attrs.update(hash)
    hash.keys.each {|key| keep key}
  end
 
  def method_missing(method_name, *args, &block)
    @attrs.send(method_name, *args, &block)
  end
 
  def keep(key)
    key = key.to_s
    @keepers << key unless @keepers.include?(key)
  end
 
  def sweep
    @attrs.keys.each {|key| @attrs.delete(key) unless @keepers.include?(key)}
    @keepers = []
  end
end
 
class Merb::Request
  def message
    session['flash'] || {}
  end
end
 
class Merb::Controller
  after :sweep_flash
  def sweep_flash
    session["flash"].sweep if session["flash"]
  end
 
  def redirect(url, opts = {})
    default_redirect_options = { :message => nil, :permanent => false }
    opts = default_redirect_options.merge(opts)
    if opts[:message]
      opts[:message] = {:notice => opts[:message]} unless opts[:message].is_a?(Hash)
      session['flash'] = Flash.new unless session['flash'].is_a?(Flash)
      session['flash'].update(opts[:message])
    end
    self.status = opts[:permanent] ? 301 : 302
    Merb.logger.info("Redirecting to: #{url} (#{self.status})")
    headers['Location'] = url
    "<html><body>You are being <a href=\"#{url}\">redirected</a>.</body></html>"
  end
end


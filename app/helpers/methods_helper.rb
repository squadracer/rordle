module MethodsHelper
  GEMS = %w[actioncable actionmailbox actionmailer actionpack actiontext actionview
            activejob activemodel activerecord activestorage activesupport bundler railties].freeze

  def self.list_all_ruby_methods
    ObjectSpace.each_object(Class).flat_map do |klass|
      methods = klass.public_instance_methods.map { |method| klass.instance_method(method) }
      methods.filter { |method| method.source_location.nil? }
             .map { |method| { owner: method.owner, name: method.name } }
    end.uniq
  end

  def self.list_all_rails_methods
    ObjectSpace.each_object(Class).flat_map do |klass|
      methods = klass.public_instance_methods.map { |method| klass.instance_method(method) }
      methods.filter { |method| method.source_location&.first =~ /gems\/(#{GEMS.join('|')})/ }
             .map { |method| { owner: method.owner, name: method.name } }
    end.uniq
  end

  def self.filter_methods(methods)
    methods.filter { |method| method[:name] =~ /^[a-z][a-z_?!]{1,}$/ }
  end

  def self.filtered_methods
    @filtered_methods ||= filter_methods(list_all_ruby_methods | list_all_rails_methods).map { |method| method[:name] }
  end

  
  # https://api.rubyonrails.org/classes/ActionView/Helpers/AssetUrlHelper.html#method-i-video_url
  # https://rubyapi.org/3.2/o/math#method-c-acos



  def self.create_url_from(method)
    # TODO: select rails_method_doc_url or ruby_method_doc_url for the given method
    # TODO: in "#method-i-acos" and "#method-i-video_url", "i" and "c" repectively refers to "Instance method" and "Class method"
    #       we have to verify this to create the right url
  end

  def self.rails_method_doc_url(method)
    "https://api.rubyonrails.org/classes/#{method[:owner].to_s.gsub('::', '/')}.html#method-i-#{method[:name]}"
  end

  def self.ruby_method_doc_url(method)
   "https://ruby-doc.org/3.2.0/#{method[:owner].to_s.scan(/(?<=:)\w+(?=>)/).first}.html#method-c-#{method[:name]}"
  end
end

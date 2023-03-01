module MethodsHelper
  GEMS = Gem::Specification.find_by_name('rails').dependencies.map(&:name).freeze

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

  def self.get_doc(method)
    #RDoc::RI::Driver.run([method]).to_s
    TTYString.parse(`ri "#{method}"`)
  end
end

module Spree::Chimpy
  class Engine < Rails::Engine
    require 'spree/core'
    isolate_namespace Spree
    engine_name 'spree_chimpy'

    config.autoload_paths += %W(#{config.root}/lib)

    config.generators do |g|
      g.test_framework :rspec
    end

    initializer 'spree_chimpy.environment', before: :load_config_initializers do |app|
      Spree::Chimpy::Config = Spree::Chimpy::Configuration.new
    end

    initializer 'spree_chimpy.ensure' do
      if !Rails.env.test? && Spree::Chimpy.configured?
        Spree::Chimpy.ensure_list
        Spree::Chimpy.ensure_segment
      end
    end

    def self.activate
      if defined?(Spree::StoreController)
        Spree::StoreController.send(:include, Spree::Chimpy::ControllerFilters)
      else
        Spree::BaseController.send(:include,  Spree::Chimpy::ControllerFilters)
      end

      Dir.glob(File.join(File.dirname(__FILE__), '../../../app/**/*_decorator*.rb')) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
    end

    config.to_prepare &method(:activate).to_proc
  end
end

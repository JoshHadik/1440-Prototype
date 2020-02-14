class FeatureGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../templates', __FILE__)

  def generate_story
    template "feature.erb", "spec/features/#{ DateTime.now.strftime('%Y%m%d%H%M%S')}_#{file_name}_spec.rb"
  end

  private
  def file_name
    name.underscore
  end
end

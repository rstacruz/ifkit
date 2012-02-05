[:sass, :scss].each do |type|
  Proton.project.config.tilt_options(type)[:load_paths] ||= Array.new
  Proton.project.config.tilt_options(type)[:load_paths] << File.expand_path('../../../assets/stylesheets', __FILE__)
end

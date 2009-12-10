class SchemalessGenerator < Rails::Generator::NamedBase
  def manifest
    record do |m|
      m.class_collisions class_path, class_name, "#{class_name}Cell"
      m.directory File.join('app/models', class_path)
      m.template "item.rb", File.join('app/models',  class_path,  "#{file_name}.rb")
      m.template "cell.rb", File.join('app/models',  class_path,  "#{file_name}_cell.rb")
      m.migration_template 'migration.rb',  'db/migrate',  :assigns  => {
        :migration_name => "Create#{class_name.pluralize.gsub(/::/, '')}"
      }, :migration_file_name => "create_#{file_path.gsub(/\//, '_').pluralize}"
    end
  end
end

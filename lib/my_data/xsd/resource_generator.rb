# frozen_string_literal: true

require "fileutils"

# This class is for development reason only, to generate resources
module MyData::Xsd::ResourceGenerator
  module_function

  def generate
    MyData::Xsd::Structure.complex_types.each do |_, type|
      folder_name = File.join(MyData.root, "lib/my_data/resources", type.namespace.to_s)
      FileUtils.mkdir_p(folder_name)

      class_name = "#{type.namespace.capitalize}::#{type.name}"

      puts "Create file: #{folder_name} #{type.name}"

      file = File.new(File.join(folder_name, "#{type.name.underscore}.rb"), "w")
      file.write(class_string(class_name))
      file.close
    end

    "done"
  end

  def class_string(class_name)
    string = "# frozen_string_literal: true\n"
    string += "\n"
    string += "class MyData::Resources::#{class_name}\n"
    string += "  include MyData::Resource\n"
    string += "\n"
    string += "  xsd_structure\n"
    string += "end\n"

    string
  end
end

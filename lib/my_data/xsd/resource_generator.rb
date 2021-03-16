# frozen_string_literal: true

require "fileutils"

# This class is for development reason only, to generate resources
module MyData::Xsd::ResourceGenerator
  module_function

  def generate_docs
    MyData::Xsd::Structure.docs.each do |name, doc|
      folder_name = File.join(MyData.root, "lib/my_data/resources", doc.target_namespace.to_s)
      FileUtils.mkdir_p(folder_name)

      class_name = [doc.target_namespace&.camelize, name.camelize].compact.join("::")
      puts "Create file: #{folder_name}/#{name}"

      file = File.new(File.join(folder_name, "#{name.underscore}.rb"), "w")
      file.write(class_doc_string(class_name))
      file.close
    end

    "done"
  end

  def generate_types
    MyData::Xsd::Structure.complex_types.each do |_, type|
      folder_name = File.join(MyData.root, "lib/my_data/resources", type.namespace.to_s)
      FileUtils.mkdir_p(folder_name)

      class_name = [type.namespace&.camelize, type.name.camelize].compact.join("::")

      puts "Create file: #{folder_name}/#{type.name}"

      file = File.new(File.join(folder_name, "#{type.name.underscore}.rb"), "w")
      file.write(class_complex_string(class_name))
      file.close
    end

    "done"
  end

  def class_complex_string(class_name)
    string = "# frozen_string_literal: true\n"
    string += "\n"
    string += "class MyData::Resources::#{class_name}\n"
    string += "  include MyData::Resource\n"
    string += "\n"
    string += "  xsd_complex_type\n"
    string += "end\n"

    string
  end

  def class_doc_string(class_name)
    string = "# frozen_string_literal: true\n"
    string += "\n"
    string += "class MyData::Resources::#{class_name}\n"
    string += "  include MyData::Resource\n"
    string += "\n"
    string += "  xsd_doc\n"
    string += "end\n"

    string
  end
end

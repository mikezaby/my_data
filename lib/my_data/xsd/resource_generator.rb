# frozen_string_literal: true

require "fileutils"

# This class is for development reason only, to generate resources
module MyData::Xsd::ResourceGenerator
  extend self

  def generate_docs
    MyData::Xsd::Structure.docs.each do |name, doc|
      generate_file(name: name, namespace: doc.target_namespace, xsd_mode: "xsd_doc")
    end

    "done"
  end

  def generate_types
    MyData::Xsd::Structure.complex_types.each_value do |type|
      generate_file(name: type.name, namespace: type.namespace, xsd_mode: "xsd_complex_type")
    end

    "done"
  end

  private

  def generate_file(name:, namespace:, xsd_mode:)
    folder_name = File.join(MyData.root, "lib/my_data/resources", namespace.to_s)
    FileUtils.mkdir_p(folder_name)

    class_name = [namespace&.camelize, name.camelize].compact.join("::")
    puts "Create file: #{folder_name}, #{name}"

    file = File.new(File.join(folder_name, "#{name.underscore}.rb"), "w")
    file.write(class_string(class_name, xsd_mode))
    file.close
  end

  def class_string(class_name, xsd_mode)
    string = "# frozen_string_literal: true\n"
    string += "\n"
    string += "class MyData::Resources::#{class_name}\n"
    string += "  include MyData::Resource\n"
    string += "\n"
    string += "  #{xsd_mode}\n"
    string += "end\n"

    string
  end
end

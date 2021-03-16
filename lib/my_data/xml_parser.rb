# frozen_string_literal: true

module MyData::XmlParser
  extend self

  def xml_to_hash(xml:, resource:, root: nil)
    h = transofrm_xml_to_hash(fix_xml(xml))
    h = h[root] if root

    resource.new hash_mapping(h, resource)
  end

  def hash_mapping(hash, resource)
    flatten(hash, resource).each_with_object({}) do |(key, value), h|
      mappings = resource.mappings[key]

      next h[key] = value unless mappings[:resource]

      h[key] =
        if value.is_a?(Array)
          value.map { |v| hash_mapping(v, mappings[:resource]) }
        else
          hash_mapping(value, mappings[:resource])
        end
    end
  end

  private

  def fix_xml(xml)
    xml.sub(/^.+/, "").sub("</string>", "").strip.gsub("&lt;", "<").gsub("&gt;", ">")
  end

  def transofrm_xml_to_hash(xml)
    Hash.from_xml(xml).deep_transform_keys(&:underscore)
  end

  def flatten(hash, resource)
    return {} unless hash

    hash.each_with_object({}) do |(k, v), h|
      next if resource.attributes.none?(k) || !v

      mappings = resource.mappings[k]

      next h[k] = v unless mappings[:collection] && mappings[:collection_element_name]

      h[k] = v[mappings[:collection_element_name]]
    end
  end
end

require "propshaft/asset"

class Propshaft::Asset
  alias fresh_without_tinymce_exception? fresh?

  # Allow TinyMCE assets to be accessed (in development mode) without a digest
  def fresh?(digest)
    fresh_without_tinymce_exception?(digest) ||
      (digest.blank? && logical_path.to_s.starts_with?("tinymce/"))
  end
end

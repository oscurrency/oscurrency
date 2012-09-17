# encoding: utf-8

class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MimeTypes
  include CarrierWave::RMagick
  include Sprockets::Helpers::RailsHelper
  include Sprockets::Helpers::IsolatedHelper

  if Rails.env.development?
    storage :file
  else
    storage :fog
  end

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def default_url
    asset_path [model.class.to_s.underscore, "default", mounted_as, version_name].compact.join('_') + ".png"
  end
  
  process convert: 'jpg'
  process :set_content_type
  process resize_to_fit: [240, 240]

  version :thumbnail do
    process resize_to_fill: [72, 72]
  end

  version :icon, from_version: :thumbnail do
    process resize_to_fill: [36, 36]
  end

  def filename
    super and super.chomp(File.extname(super)) + '.jpg'
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

end

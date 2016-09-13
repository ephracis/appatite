module FixtureHelpers
  def fixture_file(filename)
    return '' if filename.blank?
    file_path = File.expand_path(Rails.root.join('spec/fixtures/', filename))
    File.read(file_path)
  end

  def json_response(hash)
    JSON.parse({ body: hash.to_json }.to_json, object_class: OpenStruct)
  end

  def json_response_file(filename)
    hash = fixture_file(filename)
    JSON.parse({ body: hash }.to_json, object_class: OpenStruct)
  end
end

RSpec.configure do |config|
  config.include FixtureHelpers
end

require 'rubygems'
require 'rmagick'
require 'fileutils'
require 'net/http'

class BagBuilder
  attr_accessor :base, :parts, :output_path, :output_image_path, :working_dir, :root_path

  def initialize(base_source_path, parts_path={}, root_path=nil)
    @root_path = root_path || "."

    @output_path = "#{@root_path}/tmp" if output_path.nil?
    prepare_working_dir unless working_dir_prepared?
    @base = prepare_file(base_source_path)
    @parts = []
    parts_path.map do |position, path|
      @parts.push([position.to_i, prepare_file(path)])
    end
  end

  def build
    base = Magick::Image.read(@base.path).first
    output = Magick::Image.new(base.columns, base.rows) { self.background_color = "Transparent" }
    @parts.map do |position, file|
      overlay = Magick::Image.read(file.path).first rescue next
      output.composite!(overlay, 0, 0, Magick::OverCompositeOp)
    end
    output.write("#{@working_dir}/output.png")

    @output_image_path = "#{@working_dir}/output.png"
  end

  private
    def prepare_working_dir
      dirs = FileUtils::mkdir_p "#{@output_path}/working_dir_#{Time.now.to_s.gsub(" ", "_")}"
      @working_dir = dirs.last
    end

    def prepare_file(path)
      if uri?(path)
        assumed_file_name = "#{path.split("/").last}.png"
        uri = URI(path)
        binary_contents = Net::HTTP.get(uri)
        File.new("#{@working_dir}/#{assumed_file_name}", "w").write(binary_contents)
        path = "#{@working_dir}/#{assumed_file_name}"
      end
      file = File.open(path)

      file
    end

    def uri?(path)
      uri = URI.parse(path) rescue nil
      return false if uri.nil?
      %w(http https).include?(uri.scheme)
    end

    def working_dir_prepared?
      !@working_dir.nil? && Dir.exist?(@working_dir)
    end
end

require 'logger'
require 'erubis'

module Generator
  Renderer = Struct.new(:build_dir, :glob, :events) do
    def run!
      logger.info "Rendering '#{glob}' to '#{build_dir}'"
      FileUtils.mkdir_p(build_dir)

      Dir[glob].each do |filename|
        logger.info "processing #{filename}"
        template = Erubis::Eruby.new(File.read(filename))
        File.write(
          File.join(build_dir, File.basename(filename, '.erb')),
          template.result(binding)
        )
      end
    end

    private def logger
      @logger ||= Logger.new(STDOUT)
    end
  end
end

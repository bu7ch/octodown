require 'erb'
require 'octodown/renderer/renderable'

module Octodown
  module Renderer
    class HTML
      include Octodown::Support
      include Renderable

      attr_reader :rendered_markdown, :filepath, :options

      def initialize(rendered_markdown, options = {})
        @rendered_markdown = rendered_markdown
        @options = options
        @filepath = File.join parent_dir, 'template', 'octodown.html.erb'
      end

      def content
        template_text = File.read filepath
        erb_template = ERB.new template_text
        erb_template.result binding
      end

      def title
        'Octodown Preview'
      end

      def stylesheet
        tagger assets_dir("#{options[:style]}.css"), :style
      end

      def vendor
        Dir[assets_dir('vendor', '*.js')].reduce '' do |a, e|
          a << tagger(e, 'script')
        end
      end

      def host
        "ws://localhost:#{options[:port]}".dump
      end

      def present
        Launchy.open PersistentTempfile.create(content, :html).path
      end

      private

      def tagger(name, tag)
        "<#{tag}>#{File.read name}</#{tag}>"
      end

      def assets_dir(*args)
        File.join Octodown.root, 'assets', args
      end

      def parent_dir
        current_file = File.dirname __FILE__
        File.expand_path '..', current_file
      end
    end
  end
end
